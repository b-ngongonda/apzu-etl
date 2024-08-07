DROP TABLE IF EXISTS mw_nutrition_adult_initial;
CREATE TABLE mw_nutrition_adult_initial (
    nutrition_initial_visit_id INT NOT NULL AUTO_INCREMENT,
    patient_id INT NOT NULL,
    visit_date DATE,
    location VARCHAR(255),
    enrollment_reason_tb VARCHAR(255),
    enrollment_reason_hiv VARCHAR(255),
    enrollment_reason_ncd VARCHAR(255),
    PRIMARY KEY (nutrition_initial_visit_id));
