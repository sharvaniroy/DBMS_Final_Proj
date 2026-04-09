USE sst_mental_health;

DROP TABLE IF EXISTS therapists;
DROP TABLE IF EXISTS user_sessions;
DROP TABLE IF EXISTS activities;
DROP TABLE IF EXISTS user_goals;
DROP TABLE IF EXISTS user_activities;
DROP TABLE IF EXISTS session_rec_activities;

#Creating Tables
CREATE TABLE therapists (
	therapist_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	therapist_first_name VARCHAR(50) NOT NUll,
	therapist_last_name VARCHAR(50) NOT NUll,
	phone_number VARCHAR(20) NOT NULL,
	email VARCHAR(50) NOT NULL, 
	fk_specialty_id  INT NOT NULL,
	active_flag BOOLEAN DEFAULT FALSE NOT NULL,
    
	FOREIGN KEY (fk_specialty_id)
	REFERENCES specialties(specialty_id)
	ON UPDATE CASCADE
);

CREATE TABLE user_sessions(
	session_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	fk_user_id INT NOT NULL,
	fk_therapist_id INT NOT NULL,
	session__date DATETIME,
	duration INT, #miniutes
	session_type ENUM ('Weekly', 'Biweekly', 'Check In', 'Emergency') NOT NULL,
	notes VARCHAR(500),
     
	FOREIGN KEY (fk_user_id) 
	REFERENCES user_account(user_id)
	ON DELETE CASCADE ON UPDATE CASCADE,

	FOREIGN KEY (fk_therapist_id) 
	REFERENCES therapists(therapist_id)
	ON UPDATE CASCADE,

	FOREIGN KEY (fk_goal_id) 
	REFERENCES user_goals(goal_id)
	ON UPDATE CASCADE
);

CREATE TABLE activities (
    activity_id  INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    activity_type ENUM ('Exercising', 'Journaling', 'Reading', 'Crafting', 'Meditation') NOT NULL,
    activity_description VARCHAR(300)
);

CREATE TABLE user_goals (
	goal_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	fk_user_id INT NOT NULL,
	goal_description VARCHAR(300),
	target_date DATE, 
	accomplished_flag BOOLEAN DEFAULT FALSE NOT NULL,
    
	FOREIGN KEY (fk_user_id) 
    REFERENCES user_account(user_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE user_activities (
	user_act_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	fk_user_id INT NOT NULL,
	fk_activity_id INT NOT NULL,
	fk_goal_id INT,
    
    FOREIGN KEY (fk_user_id) 
    REFERENCES user_account(user_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
    
    FOREIGN KEY (fk_activity_id) 
    REFERENCES activities(activity_id)
	ON UPDATE CASCADE,
    
    FOREIGN KEY (fk_goal_id)
    REFERENCES user_goals(goal_id)
	ON UPDATE CASCADE
);

CREATE TABLE session_rec_activities(
	ses_act_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	fk_session_id INT NOT NULL,
	fk_activity_id INT NOT NULL,
    
	FOREIGN KEY (fk_session_id)
	REFERENCES user_sessions(sessions_id)
	ON DELETE CASCADE ON UPDATE CASCADE,

	FOREIGN KEY (fk_activity_id)
	REFERENCES activities(activity_id)
	ON UPDATE CASCADE
);

#Inserting Values

INSERT INTO therapists (therapist_first_name, therapist_last_name, phone_number, email, fk_specialty_id, active_flag)
VALUES
    ('Sarah', 'Thomas', '412-555-0101', 'sarahthomas@yahoo.com', 1, FALSE),
    ('Michael', 'Smith', '412-555-0102', 'michealsmith@comcast.net', 2, TRUE),
    ('Emily', 'Buchman', '412-555-0103', 'emilybuchman@gmail.com', 3, TRUE),
    ('James', 'King', '412-555-0104', 'jamesking@icloud.com', 1, FALSE),
    ('Anna', 'Brooks', '412-555-0105', 'annabrooks@gmail.com', 2, TRUE);

INSERT INTO user_sessions (fk_user_id, fk_therapist_id, session_date, duration, session_type, notes)
VALUES
    (1, 1, '2026-04-08 10:00:00', 50, 'Weekly', 'User reported feeling more positive this week, continuing recomended exercise.'),
    (2, 2, '2026-04-09 14:00:00', 60, 'Biweekly', 'Discussed anxiety triggers, recommended journaling activity.'),
    (3, 3, '2026-04-10 11:30:00', 30, 'Check In',  'Brief check in, user is working on less screen time and managing well.'),
    (4, 1, '2026-04-11 09:00:00', 50, 'Weekly', 'User struggling with sleep, adjusted coping strategies.'),
    (5, 2, '2026-04-12 15:00:00', 90, 'Emergency', 'Emergency session, user experiencing high anxiety episode.');

INSERT INTO activities (activty_type, activity_description)
VALUES 
	('Exercising', 'Brisk walking, running, swimming, or team sports reduce stress-releasing hormones and increase endorphins'), 
    ('Journaling', 'Documenting thoughts and feelings to process stress'), 
    ('Reading', '30 minutes of reading to provide therapeutic benefits for anxiety and depression by slowing down the mind'), 
    ('Crafting', 'Painting, drawing, or engaging in hobbies to foster emotional release.'),
    ('Meditation', 'Focusing on the present moment, such as "mindful walking" or observing your environment, to reduce anxiety');
    
INSERT INTO user_goals (fk_user_id, goal_description, target_date, accomplished_flag)
VALUES
    (1, 'Meditate for at least 10 minutes every day', NULL, FALSE),
    (2, 'Journaling thoughts and feelings 3 times a week', '2026-04-15', FALSE),
    (3, 'Get at least 8 hours of sleep every night', NULL, TRUE),
    (4, 'Activate gym membership', '2026-04-10', FALSE),
    (5, 'Get in touch with old friends from highschool', '2026-04-020', FALSE);
    

INSERT INTO user_activities (fk_user_id, fk_activity_id, fk_goal_id)
VALUES
    (1, 5, 1),
    (2, 2, 2),
    (3, 3, NULL),
    (4, 1, NULL),
    (5, 4, NULL);
    
INSERT INTO session_rec_activities (fk_session_id, fk_activity_id)
VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 5),
    (5, 5);
