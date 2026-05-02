# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

This repo contains **no application source code**. It is a packaging project that ships two things to be executed by external tools:

1. **Pentaho/Kettle ETL artifacts** under `jobs/pentaho/` (`.kjb` jobs, `.ktr` transforms, plus `.sql` and `.csv` support files) — edited and run with Pentaho Spoon / Kitchen and by the [PETL](https://github.com/PIH/petl) Spring Boot runner, using jobs of type "pentaho"
2. **PETL job-pipeline YAML** under `jobs/` and `datasources/` — orchestration definitions consumed by the [PETL](https://github.com/PIH/petl) Spring Boot runner.

Maven is only used to bundle `datasources/` and `jobs/` into a distributable `apzu-etl-*-distribution.zip` and publish it to Maven Central. There is nothing to compile.

## Build / package

```bash
mvn clean package        # produces target/apzu-etl-*-distribution.zip containing datasources/ and jobs/
mvn clean deploy -U -DdeployRelease -Dgpg.passphrase=*** -Dgpg.keyname=<key>   # signed release deploy (Sonatype Central)
```

There are no unit tests and no `test` goal wired up. CI release scripts live in `ci/release-prepare.sh` and `ci/release-finish.sh`; do not invoke them locally — they `git reset --hard central/master` and push tags.

## Running the pipeline locally

PETL itself is **not** in this repo. To run end-to-end you stage an execution directory containing a PETL jar plus this project's `jobs/` + `datasources/` + an `application.yml` (see `example-application.yml`), then `java -jar petl.jar`. The README's "Installation" section is the source of truth; the typical dev pattern is to symlink `datasources/` and `jobs/` from a checkout into `/opt/petl/apzu-etl/` rather than reinstalling the zip on every change.

`example-application.yml` declares `refresh-full.yml` as a startup job, so launching PETL with that config kicks off a full refresh immediately. Three datasource blocks must be filled in: `mysqlOpenmrs` (source OpenMRS DB), `mysqlReporting` (warehouse), `sqlServerReporting` (reporting target).

For Pentaho-only iteration (editing `.kjb`/`.ktr` files), use Spoon. The Spoon setup (kettle.properties, pih-kettle.properties, symlinking `~/.kettle/shared.xml` to `jobs/pentaho/shared-connections.xml`) is documented in the README's "DEV ENVIRONMENT SETUP" section and **must** be done before opening the jobs — without it, connection variables are unresolved.

### Running a single job during development

- Single Pentaho job in Spoon: open it and Run; variables come from `~/.kettle/pih-kettle.properties`.
- Single Pentaho job via PETL: change `example-application.yml`'s `startup.jobs` to a single-job wrapper, or call `execute-pentaho-job.yml` with the desired `jobPath`.
- Single PETL pipeline: set `startup.jobs` to that one YAML (e.g. `refresh-mysql-reporting.yml` or `refresh-sqlserver-reporting.yml`).

## Architecture: how the pieces fit

The pipeline is two stages, orchestrated by `jobs/refresh-full.yml`:

```
OpenMRS MySQL  ──(Pentaho/Kettle)──▶  MySQL warehouse  ──(PETL bulk import)──▶  SQL Server reporting
```

**Stage 1 — `refresh-mysql-reporting.yml`** iterates over Pentaho `.kjb` files, calling `execute-pentaho-job.yml` (a `pentaho-job` PETL task) for each. `execute-pentaho-job.yml` is the bridge between the two worlds: it maps PETL's datasource config (`mysqlOpenmrs.*`, `mysqlReporting.*`) onto the kettle variables Pentaho expects (`openmrs.db.*`, `warehouse.db.*`, `pih.pentahoHome`). PETL writes these into a per-execution `kettle.properties`, which Kettle auto-loads on `KettleEnvironment.init()` — so every job and transform sees them as JVM-scoped variables with no explicit "load configuration" step. Stage 1 then runs `refresh-derived-mysql-data.yml`, which executes MySQL-only derived-table SQL from `jobs/sql/mysql/`.

The Pentaho side itself has structure worth knowing:
- `jobs/pentaho/openmrs/` — generic OpenMRS extract: `create-omrs-schema.kjb` builds the `omrs_*` warehouse tables, `load-from-openmrs.kjb` populates them via `transforms/import-into-omrs-*.ktr`, `create-omrs-indexes.kjb` indexes them. These run before the Malawi-specific jobs.
- `jobs/pentaho/malawi/` — Malawi-specific reporting tables (the `mw_*` tables). `schema/table/*.sql` defines table DDL, `schema/function/*.sql` and `schema/procedure/*.sql` register reusable MySQL routines, `transforms/*.ktr` populate the tables, and `jobs/load-malawi-data-*.kjb` group them by program (ART, NCD, PDC, Nutrition, POC, users).
- `jobs/pentaho/shared-connections.xml` — DB connection definitions referenced by every transform; symlinked into `~/.kettle/shared.xml` for Spoon.

**Stage 2 — `refresh-sqlserver-reporting.yml`** is a flat list of `iterations:` (one per warehouse table). For each table it `drop`s and recreates the SQL Server table from the MySQL schema, then bulk-imports rows using `jobs/selectAllFromTable.sql`. **Adding a new warehouse table requires a new entry in this `iterations:` list** — otherwise the table exists in MySQL but never lands in SQL Server. There is no auto-discovery.

## Conventions to preserve

- Warehouse tables use `mw_` prefix (Malawi-specific) or `omrs_` prefix (generic OpenMRS extract).
- Table names in `refresh-sqlserver-reporting.yml`'s `iterations:` must match the actual MySQL warehouse table names exactly.
- Pentaho variables (`${openmrs.db.host}`, `${warehouse.db.name}`, `${pih.pentahoHome}`, etc.) are resolved by PETL via `execute-pentaho-job.yml` and made available through `kettle.properties` (auto-loaded by Kettle). When adding a new variable to a transform, also add it to `execute-pentaho-job.yml`'s `configuration:` block or it will be empty at runtime.
- There is no longer a country/property-file mechanism. Static Malawi-specific values (e.g. patient attribute type names) are hardcoded directly into the transforms that use them. Do not reintroduce `pih.country`, `default.properties`, `malawi.properties`, or `load-configuration.kjb`.
- Do not commit Spoon's `.kettle/` directory or IntelliJ files (already gitignored).

## Releases

Versioning is handled by Bamboo via the `ci/` scripts: `release-prepare.sh` strips `-SNAPSHOT`, tags, pushes; `release-finish.sh` bumps minor and re-adds `-SNAPSHOT`. Both `git reset --hard central/master` first, so any uncommitted local work in CI's checkout would be lost — relevant only on the build server.
