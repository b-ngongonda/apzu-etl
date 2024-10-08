CREATE TABLE mw_asthma_followup (
  asthma_followup_visit_id 		int NOT NULL AUTO_INCREMENT,
  patient_id 				int NOT NULL,
  visit_date 				date DEFAULT NULL,
  location 				varchar(255) DEFAULT NULL,
  planned_visit 			varchar(255) DEFAULT NULL,
  height 				int DEFAULT NULL,
  weight 				int DEFAULT NULL,
  day_symptoms 			int DEFAULT NULL,
  night_symptoms 			int DEFAULT NULL,
  inhaler_use_frequency_daily 	int DEFAULT NULL,
  inhaler_use_frequency_weekly 	int DEFAULT NULL,
  inhaler_use_frequency_monthly 	int DEFAULT NULL,
  inhaler_use_frequency_yearly 	int DEFAULT NULL,
  steroid_inhaler_daily 		varchar(255) DEFAULT NULL,
  number_of_cigarettes_per_day 	int DEFAULT NULL,
  passive_smoking 			varchar(255) DEFAULT NULL,
  cooking_indoor 			varchar(255) DEFAULT NULL,
  exacerbation_today 			varchar(255) DEFAULT NULL,
  asthma_severity 			varchar(255) DEFAULT NULL,
  copd 				varchar(255) DEFAULT NULL,
  other_diagnosis 			varchar(255) DEFAULT NULL,
  treatment_inhaled_b_agonist 	varchar(255) DEFAULT NULL,
  treatment_inhaled_b_agonist_dose		INT,
  treatment_inhaled_b_agonist_dosing_unit VARCHAR(50),
  treatment_inhaled_b_agonist_route		VARCHAR(50),
  treatment_inhaled_b_agonist_frequency		VARCHAR(50),
  treatment_inhaled_b_agonist_duration   INT,
  treatment_inhaled_b_agonist_duration_units  VARCHAR(50),
  treatment_inhaled_steriod 		varchar(255) DEFAULT NULL,
  treatment_inhaled_steriod_dose		INT,
  treatment_inhaled_steriod_dosing_unit VARCHAR(50),
  treatment_inhaled_steriod_route		VARCHAR(50),
  treatment_inhaled_steriod_frequency		VARCHAR(50),
  treatment_inhaled_steriod_duration   INT,
  treatment_inhaled_steriod_duration_units  VARCHAR(50),
  treatment_oral_steroid 		varchar(255) DEFAULT NULL,
  treatment_oral_steroid_dose		INT,
  treatment_oral_steroid_dosing_unit VARCHAR(50),
  treatment_oral_steroid_route		VARCHAR(50),
  treatment_oral_steroid_frequency		VARCHAR(50),
  treatment_oral_steroid_duration   INT,
  treatment_oral_steroid_duration_units  VARCHAR(50),
  other_treatment 			varchar(255) DEFAULT NULL,
  other_treatment_dose		INT,
  other_treatment_dosing_unit VARCHAR(50),
  other_treatment_route		VARCHAR(50),
  other_treatment_frequency		VARCHAR(50),
  other_treatment_duration   INT,
  other_treatment_duration_units  VARCHAR(50),
  comments 				varchar(255) DEFAULT NULL,
  next_appointment_date		date,
  PRIMARY KEY (asthma_followup_visit_id)
);
