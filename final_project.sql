USE sst_mental_health;

CREATE TABLE user_account(
user_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
password VARCHAR(300) NOT NULL,
email VARCHAR(50) NOT NULL UNIQUE,
phone_no VARCHAR(20) NOT NULL,
created_date DATE NOT NULL,
active_flag BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE user_information(
user_profile_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
user_id INT NOT NULL UNIQUE,
first_name VARCHAR(30) NOT NULL,
last_name VARCHAR(30) NOT NULL,
dob DATE NOT NULL,
sex ENUM('Female', 'Male', 'Non-binary', 'Other', 'Prefer Not to Answer') NOT NULL,
pronouns VARCHAR(30) NULL,
CONSTRAINT fk_user_info_user_id
	FOREIGN KEY (user_id)
	REFERENCES user_account(user_id)
);

CREATE TABLE medication_category (
med_category_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
category_name VARCHAR(50) NOT NULL UNIQUE
);
    
CREATE TABLE medications(
med_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
med_name VARCHAR(300) NOT NULL,
med_category_id INT NOT NULL,
med_purpose TEXT NOT NULL,
CONSTRAINT fk_medications_category
	FOREIGN KEY (med_category_id)
    REFERENCES medication_category(med_category_id)
);

CREATE TABLE illness(
illness_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
illness_name VARCHAR(100) NOT NULL UNIQUE,
illness_description TEXT NOT NULL
);

CREATE TABLE user_meds (
user_med_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
user_id INT NOT NULL,
med_id INT NOT NULL,
CONSTRAINT fk_user_meds_user
	FOREIGN KEY (user_id)
    REFERENCES user_account(user_id),
CONSTRAINT fk_user_meds_med
	FOREIGN KEY (med_id)
    REFERENCES medications(med_id)
);

CREATE TABLE user_illness (
user_illness_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
user_id INT NOT NULL,
illness_id INT NOT NULL,
CONSTRAINT fk_user_illness_user
	FOREIGN KEY (user_id)
    REFERENCES user_account(user_id),
CONSTRAINT fk_user_illness_illness
	FOREIGN KEY (illness_id)
    REFERENCES illness(illness_id)
);
