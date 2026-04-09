USE sst_mental_health;

DROP TABLE IF EXISTS session_rec_activities;
DROP TABLE IF EXISTS user_activities;
DROP TABLE IF EXISTS user_sessions;
DROP TABLE IF EXISTS user_goals;
DROP TABLE IF EXISTS user_journal_symptoms;
DROP TABLE IF EXISTS journal_entries;
DROP TABLE IF EXISTS user_meds;
DROP TABLE IF EXISTS user_illness;
DROP TABLE IF EXISTS therapists;
DROP TABLE IF EXISTS specialties;
DROP TABLE IF EXISTS activities;
DROP TABLE IF EXISTS medications;
DROP TABLE IF EXISTS medication_category;
DROP TABLE IF EXISTS illness;
DROP TABLE IF EXISTS physical_symptoms;
DROP TABLE IF EXISTS mood;
DROP TABLE IF EXISTS user_sleep;
DROP TABLE IF EXISTS user_information;
DROP TABLE IF EXISTS user_account;

CREATE TABLE user_account (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    password VARCHAR(300) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    phone_no VARCHAR(20) NOT NULL,
    created_date DATE NOT NULL DEFAULT (current_date()),
    active_flag BOOLEAN NOT NULL DEFAULT TRUE
)  ENGINE=INNODB;

CREATE TABLE user_information (
    user_profile_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    dob DATE NOT NULL,
    sex ENUM('Female', 'Male', 'Non-binary', 'Other', 'Prefer Not to Answer') NOT NULL,
    pronouns VARCHAR(30) DEFAULT NULL,
    CONSTRAINT fk_user_info_user_id FOREIGN KEY (user_id)
        REFERENCES user_account (user_id)
)  ENGINE=INNODB;

CREATE TABLE medication_category (
    med_category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL UNIQUE
)  ENGINE=INNODB;
    
CREATE TABLE medications (
    med_id INT PRIMARY KEY AUTO_INCREMENT,
    med_name VARCHAR(300) NOT NULL,
    med_category_id INT NOT NULL,
    med_purpose TEXT NOT NULL,
    CONSTRAINT fk_medications_category FOREIGN KEY (med_category_id)
        REFERENCES medication_category (med_category_id)
)  ENGINE=INNODB;

CREATE TABLE illness (
    illness_id INT PRIMARY KEY AUTO_INCREMENT,
    illness_name VARCHAR(100) NOT NULL UNIQUE,
    illness_description TEXT NOT NULL
)  ENGINE=INNODB;

CREATE TABLE user_meds (
    user_id INT NOT NULL,
    med_id INT NOT NULL,
    PRIMARY KEY (user_id , med_id),
    CONSTRAINT fk_user_meds_user FOREIGN KEY (user_id)
        REFERENCES user_account (user_id),
    CONSTRAINT fk_user_meds_med FOREIGN KEY (med_id)
        REFERENCES medications (med_id)
)  ENGINE=INNODB;

CREATE TABLE user_illness (
    user_id INT NOT NULL,
    illness_id INT NOT NULL,
    PRIMARY KEY (user_id , illness_id),
    CONSTRAINT fk_user_illness_user FOREIGN KEY (user_id)
        REFERENCES user_account (user_id),
    CONSTRAINT fk_user_illness_illness FOREIGN KEY (illness_id)
        REFERENCES illness (illness_id)
)  ENGINE=INNODB;

CREATE TABLE user_sleep (
    sleep_id INT AUTO_INCREMENT PRIMARY KEY,
    sleep_quality_rating TINYINT NOT NULL,
    sleep_description TEXT NOT NULL,
    sleep_duration DECIMAL(4 , 2 ) NOT NULL
)  ENGINE=INNODB;

CREATE TABLE mood (
    mood_id INT AUTO_INCREMENT PRIMARY KEY,
    mood_description VARCHAR(50) NOT NULL
)  ENGINE=INNODB;

CREATE TABLE physical_symptoms (
    symptom_id INT AUTO_INCREMENT PRIMARY KEY,
    symptom_description VARCHAR(50) NOT NULL
)  ENGINE=INNODB;

CREATE TABLE journal_entries (
    journal_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    sleep_id INT NOT NULL,
    mood_id INT NOT NULL,
    mood_severity TINYINT NOT NULL,
    wellness_rank INT NOT NULL,
    notes TEXT NOT NULL,
    recorded_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)
        REFERENCES user_account (user_id),
    FOREIGN KEY (sleep_id)
        REFERENCES user_sleep (sleep_id),
    FOREIGN KEY (mood_id)
        REFERENCES mood (mood_id)
)  ENGINE=INNODB;

CREATE TABLE user_journal_symptoms (
    journal_id INT NOT NULL,
    symptom_id INT NOT NULL,
    symptom_severity TINYINT NOT NULL,
    PRIMARY KEY (journal_id , symptom_id),
    FOREIGN KEY (journal_id)
        REFERENCES journal_entries (journal_id),
    FOREIGN KEY (symptom_id)
        REFERENCES physical_symptoms (symptom_id)
)  ENGINE=INNODB;

CREATE TABLE specialties (
    specialty_id INT AUTO_INCREMENT PRIMARY KEY,
    specialty_name VARCHAR(50) NOT NULL,
    specialty_description TEXT NOT NULL
)  ENGINE=INNODB;

CREATE TABLE therapists (
    therapist_id INT PRIMARY KEY AUTO_INCREMENT,
    therapist_first_name VARCHAR(50) NOT NULL,
    therapist_last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL,
    specialty_id INT NOT NULL,
    active_flag BOOLEAN DEFAULT TRUE NOT NULL,
    FOREIGN KEY (specialty_id)
        REFERENCES specialties (specialty_id)
        ON UPDATE CASCADE
)  ENGINE=INNODB;

CREATE TABLE user_goals (
    goal_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    goal_category ENUM('Short-term', 'Long-term'),
    goal_description VARCHAR(300) NOT NULL,
    target_date DATE,
    accomplished_flag BOOLEAN DEFAULT FALSE NOT NULL,
    FOREIGN KEY (user_id)
        REFERENCES user_account (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE
)  ENGINE=INNODB;

CREATE TABLE user_sessions (
    session_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    therapist_id INT NOT NULL,
    session_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    duration INT NOT NULL,
    session_type ENUM('Weekly', 'Biweekly', 'Check In', 'Emergency') NOT NULL,
    notes VARCHAR(500),
    goal_id INT,
    FOREIGN KEY (user_id)
        REFERENCES user_account (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (therapist_id)
        REFERENCES therapists (therapist_id)
        ON UPDATE CASCADE,
    FOREIGN KEY (goal_id)
        REFERENCES user_goals (goal_id)
        ON UPDATE CASCADE
)  ENGINE=INNODB;

CREATE TABLE activities (
    activity_id INT PRIMARY KEY AUTO_INCREMENT,
    activity_type ENUM('Exercising', 'Journaling', 'Reading', 'Crafting', 'Meditation') NOT NULL,
    activity_description VARCHAR(300)
)  ENGINE=INNODB;

CREATE TABLE user_activities (
    user_act_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    activity_id INT NOT NULL,
    goal_id INT,
    UNIQUE (user_id , activity_id),
    FOREIGN KEY (user_id)
        REFERENCES user_account (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (activity_id)
        REFERENCES activities (activity_id)
        ON UPDATE CASCADE,
    FOREIGN KEY (goal_id)
        REFERENCES user_goals (goal_id)
        ON UPDATE CASCADE
)  ENGINE=INNODB;

CREATE TABLE session_rec_activities (
    session_id INT NOT NULL,
    activity_id INT NOT NULL,
    PRIMARY KEY (session_id , activity_id),
    FOREIGN KEY (session_id)
        REFERENCES user_sessions (session_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (activity_id)
        REFERENCES activities (activity_id)
        ON UPDATE CASCADE
)  ENGINE=INNODB;

CREATE INDEX idx_journal_user_id ON journal_entries(user_id);
CREATE INDEX idx_journal_sleep_id ON journal_entries(sleep_id);
CREATE INDEX idx_journal_mood_id ON journal_entries(mood_id);
CREATE INDEX idx_user_sessions_user_id ON user_sessions(user_id);
CREATE INDEX idx_user_sessions_therapist_id ON user_sessions(therapist_id);
CREATE INDEX idx_user_sessions_goal_id ON user_sessions(goal_id);
CREATE INDEX idx_user_activities_user_id ON user_activities(user_id);
CREATE INDEX idx_user_activities_activity_id ON user_activities(activity_id);

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

INSERT INTO user_sleep (sleep_quality_rating, sleep_description, sleep_duration)
VALUES
(4, 'Slept well with minimal interruptions', 7.50),
(3, 'Moderate sleep, woke up once during the night', 6.00),
(2, 'Restless sleep with frequent waking', 5.25),
(5, 'Excellent sleep, felt fully rested', 8.00),
(1, 'Very poor sleep, struggled to fall asleep', 3.75);

INSERT INTO mood (mood_description)
VALUES
('Happy'),
('Anxious'),
('Sad'),
('Calm'),
('Stressed');

INSERT INTO physical_symptoms (symptom_description)
VALUES
('Headache'),
('Fatigue'),
('Nausea'),
('Muscle Tension'),
('Rapid Heartbeat');

INSERT INTO specialties (specialty_name, specialty_description)
VALUES
('Cognitive Behavioral Therapy', 'Focused on changing negative thought patterns'),
('Anxiety Disorders', 'Specializes in treating anxiety-related symptoms'),
('Depression Treatment', 'Focusd on managing and treating depressive disorders'),
('Family Therapy', 'Specialized in helping families navigate interpersonal relationships'),
('Couples Therapy', 'Specialized in helping couples navigate interpersonal relationships');

INSERT INTO journal_entries 
(user_id, sleep_id, mood_id, mood_severity, wellness_rank, notes, recorded_datetime)
VALUES
(1, 1, 1, 2, 8, 'Felt good today, productive and relaxed.', '2026-04-08 20:00:00'),
(2, 2, 2, 4, 5, 'Had some anxiety during the afternoon.', '2026-04-09 21:00:00'),
(3, 3, 3, 5, 3, 'Low mood, struggled with motivation.', '2026-04-10 22:00:00'),
(4, 4, 4, 1, 9, 'Very calm and focused throughout the day.', '2026-04-11 19:30:00'),
(5, 5, 5, 5, 2, 'Very stressed, difficult day overall.', '2026-04-12 23:00:00');

INSERT INTO user_journal_symptoms (journal_id, symptom_id, symptom_severity)
VALUES
(1, 2, 2), 
(2, 5, 4),  
(2, 4, 3),  
(3, 1, 3), 
(3, 2, 4), 
(4, 2, 1), 
(5, 5, 5),  
(5, 3, 3); 

INSERT INTO therapists (therapist_first_name, therapist_last_name, phone_number, email, specialty_id, active_flag)
VALUES
    ('Sarah', 'Thomas', '412-555-0101', 'sarahthomas@yahoo.com', 1, FALSE),
    ('Michael', 'Smith', '412-555-0102', 'michealsmith@comcast.net', 2, TRUE),
    ('Emily', 'Buchman', '412-555-0103', 'emilybuchman@gmail.com', 3, TRUE),
    ('James', 'King', '412-555-0104', 'jamesking@icloud.com', 1, FALSE),
    ('Anna', 'Brooks', '412-555-0105', 'annabrooks@gmail.com', 2, TRUE);

INSERT INTO user_sessions (user_id, therapist_id, session_date, duration, session_type, notes)
VALUES
    (1, 1, '2026-04-08 10:00:00', 50, 'Weekly', 'User reported feeling more positive this week, continuing recomended exercise.'),
    (2, 2, '2026-04-09 14:00:00', 60, 'Biweekly', 'Discussed anxiety triggers, recommended journaling activity.'),
    (3, 3, '2026-04-10 11:30:00', 30, 'Check In',  'Brief check in, user is working on less screen time and managing well.'),
    (4, 1, '2026-04-11 09:00:00', 50, 'Weekly', 'User struggling with sleep, adjusted coping strategies.'),
    (5, 2, '2026-04-12 15:00:00', 90, 'Emergency', 'Emergency session, user experiencing high anxiety episode.');

INSERT INTO activities (activity_type, activity_description)
VALUES 
	('Exercising', 'Brisk walking, running, swimming, or team sports reduce stress-releasing hormones and increase endorphins'), 
    ('Journaling', 'Documenting thoughts and feelings to process stress'), 
    ('Reading', '30 minutes of reading to provide therapeutic benefits for anxiety and depression by slowing down the mind'), 
    ('Crafting', 'Painting, drawing, or engaging in hobbies to foster emotional release.'),
    ('Meditation', 'Focusing on the present moment, such as "mindful walking" or observing your environment, to reduce anxiety');
    
INSERT INTO user_goals (user_id, goal_description, target_date, accomplished_flag)
VALUES
    (1, 'Meditate for at least 10 minutes every day', NULL, FALSE),
    (2, 'Journaling thoughts and feelings 3 times a week', '2026-04-15', FALSE),
    (3, 'Get at least 8 hours of sleep every night', NULL, TRUE),
    (4, 'Activate gym membership', '2026-04-10', FALSE),
    (5, 'Get in touch with old friends from highschool', '2026-04-20', FALSE);
    

INSERT INTO user_activities (user_id, activity_id, goal_id)
VALUES
    (1, 5, 1),
    (2, 2, 2),
    (3, 3, NULL),
    (4, 1, NULL),
    (5, 4, NULL);
    
INSERT INTO session_rec_activities (session_id, activity_id)
VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 5),
    (5, 5);