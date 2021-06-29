CREATE TABLE mw_asthma_initial (
  asthma_initial_visit_id 		int NOT NULL AUTO_INCREMENT,
  patient_id 				int NOT NULL,
  visit_date 				date DEFAULT NULL,
  location 				varchar(255) DEFAULT NULL,
  diagnosis_asthma 			varchar(255) DEFAULT NULL,
  diagnosis_date_asthma 		date DEFAULT NULL,
  diagnosis_copd 			varchar(255) DEFAULT NULL,
  diagnosis_date_copd 			date DEFAULT NULL,
  family_history_asthma 		varchar(255) DEFAULT NULL,
  family_history_copd 			varchar(255) DEFAULT NULL,
  hiv_status 				varchar(255) DEFAULT NULL,
  hiv_test_date 			date DEFAULT NULL,
  art_start_date 			date DEFAULT NULL,
  tb_status 				varchar(255) DEFAULT NULL,
  tb_year 				int DEFAULT NULL,
  chronic_dry_cough 			varchar(255) DEFAULT NULL,
  chronic_dry_cough_duration_in_months int DEFAULT NULL,
  chronic_dry_cough_age_at_onset 	int DEFAULT NULL,
  tb_contact 				varchar(255) DEFAULT NULL,
  tb_contact_date 			date DEFAULT NULL,
  cooking_indoor 			varchar(255) DEFAULT NULL,
  smoking_history 			varchar(255) DEFAULT NULL,
  last_smoking_history_date 		date DEFAULT NULL,
  second_hand_smoking 			varchar(255) DEFAULT NULL,
  second_hand_smoking_date 		date DEFAULT NULL,
  occupation 				varchar(255) DEFAULT NULL,
  occupation_exposure 			varchar(255) DEFAULT NULL,
  occupation_exposure_date 		date DEFAULT NULL,
  PRIMARY KEY (asthma_initial_visit_id)
);