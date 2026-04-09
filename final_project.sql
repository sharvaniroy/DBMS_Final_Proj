USE sst_mental_health;

CREATE TABLE user_account(
user_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
password VARCHAR(300) NOT NULL,
email VARCHAR(50) NOT NULL UNIQUE,
phone_no VARCHAR(20) NOT NULL,
created_date DATE NOT NULL,
active_flag BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB;

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
) ENGINE=InnoDB;

CREATE TABLE medication_category (
med_category_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
category_name VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;
    
CREATE TABLE medications(
med_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
med_name VARCHAR(300) NOT NULL,
med_category_id INT NOT NULL,
med_purpose TEXT NOT NULL,
CONSTRAINT fk_medications_category
	FOREIGN KEY (med_category_id)
    REFERENCES medication_category(med_category_id)
) ENGINE=InnoDB;

CREATE TABLE illness(
illness_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
illness_name VARCHAR(100) NOT NULL UNIQUE,
illness_description TEXT NOT NULL
) ENGINE=InnoDB;

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
) ENGINE=InnoDB;

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
) ENGINE=InnoDB;

INSERT INTO user_account (password, email, phone_no, created_date, active_flag)
VALUES
('password1', 'john.doe@example.com', '412-555-1001', '2026-04-01', TRUE),
('password2', 'jane.doe@example.com', '412-555-1002', '2026-04-02', TRUE),
('password3', 'joseph.doe@example.com', '412-555-1003', '2026-04-03', TRUE),
('password4', 'janice.doe@example.com', '412-555-1004', '2026-04-04', FALSE),
('password5', 'jordan.doe@example.com', '412-555-1005', '2026-04-05', TRUE);

INSERT INTO user_information (user_id, first_name, last_name, dob, sex, pronouns)
VALUES
(1, 'John', 'Doe', '2002-05-14', 'Female', 'she/her'),
(2, 'Jane', 'Doe', '2001-09-21', 'Male', 'he/him'),
(3, 'Joseph', 'Doe', '2003-01-08', 'Female', 'she/her'),
(4, 'Janice', 'Doe', '2000-11-30', 'Male', 'he/him'),
(5, 'Jordan', 'Doe', '2002-07-19', 'Female', 'she/her');

INSERT INTO medication_category (category_name)
VALUES
('Antidepressant'),
('Anxiolytic'),
('Hormone'),
('Antihistamine'),
('Other');

INSERT INTO medications (med_name, med_category_id, med_purpose)
VALUES
('Sertraline', 1, 'Used to treat depression and anxiety disorders'),
('Fluoxetine', 1, 'Used to treat depression, OCD, and panic disorder'),
('Buspirone', 2, 'Used to treat anxiety'),
('Hydroxyzine', 4, 'Used for anxiety and allergy-related symptoms'),
('Melatonin', 5, 'Used to support sleep regulation');

INSERT INTO illness (illness_name, illness_description)
VALUES
('Generalized Anxiety Disorder', 'A mental health disorder characterized by persistent and excessive worry'),
('Major Depressive Disorder', 'A mood disorder causing persistent sadness and loss of interest'),
('Panic Disorder', 'A disorder involving recurring unexpected panic attacks'),
('Insomnia', 'A sleep disorder involving trouble falling or staying asleep'),
('Social Anxiety Disorder', 'A disorder involving intense fear of social situations');

INSERT INTO user_meds (user_id, med_id)
VALUES
(1, 1),
(1, 4),
(2, 3),
(3, 2),
(5, 5);

INSERT INTO user_illness (user_id, illness_id)
VALUES
(1, 1),
(1, 4),
(2, 3),
(3, 2),
(5, 5);
