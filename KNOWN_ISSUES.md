# Known issues

This file tracks suspected bugs and stale code in the ETL pipeline that have
been noticed but not yet fixed. The intent is to keep them visible until they
can be triaged into proper tickets.

## Latent inconsistencies

### `get_parent_health_facility` function is referenced but never created

`jobs/pentaho/malawi/schema/function/get_parent_health_facility.sql` exists
in the schema dir but is not in `jobs/create-reporting-utilities.yml`, so
the function is never created at runtime.

The procedure `create_changed_regimen_list`
(`jobs/pentaho/malawi/schema/procedure/create_changed_regimen_list.sql`)
calls `get_parent_health_facility(...)` in its body. MySQL resolves the
function lazily (at procedure-call time, not at procedure-create time), so
the procedure is created without error — but if anything ever invokes
`create_changed_regimen_list`, MySQL will raise "FUNCTION ... does not
exist".

Either:

- the function should be added to `jobs/create-reporting-utilities.yml`
  (if `create_changed_regimen_list` is in active use), or
- both the function file and the call site should be removed (if the
  feature is dead).

The right call depends on whether anything in the reporting layer actually
calls `create_changed_regimen_list`.
