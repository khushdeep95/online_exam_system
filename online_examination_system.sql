CREATE DATABASE ONLINE_EXAM_SYSTEM;
USE ONLINE_EXAM_SYSTEM;
drop database online_exam_system;

CREATE TABLE USER (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    user_type ENUM('student', 'question_paper_setter', 'examination_conductor', 'admin') NOT NULL,
    official_email_id VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    date_of_birth DATE NOT NULL,
    address VARCHAR(250),
    FOREIGN KEY (student_id) REFERENCES USER(user_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE QuestionPaper (
    question_paper_id INT AUTO_INCREMENT PRIMARY KEY,
    question_paper_title VARCHAR(255) NOT NULL,
    question_paper_meta_data TEXT,
    min_req_number_of_questions_to_be_attempted INT NOT NULL,
    max_number_of_questions_that_can_be_attempted INT NOT NULL,
    max_score INT NOT NULL,
    question_paper_setter_id INT,
    FOREIGN KEY (question_paper_setter_id) REFERENCES USER(user_id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Question (
    question_id INT AUTO_INCREMENT PRIMARY KEY,
    question_paper_id INT NOT NULL,
    question_text TEXT NOT NULL,
    FOREIGN KEY (question_paper_id) REFERENCES QuestionPaper(question_paper_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Options (
    option_id INT AUTO_INCREMENT PRIMARY KEY,
    question_id INT NOT NULL,
    option_text VARCHAR(255) NOT NULL,
    option_label CHAR(1) CHECK (option_label IN ('A', 'B', 'C', 'D')),
    FOREIGN KEY (question_id) REFERENCES Question(question_id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE (question_id, option_label)
);

CREATE TABLE Examination (
    exam_id INT AUTO_INCREMENT PRIMARY KEY,
    question_paper_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    duration INT NOT NULL,  
    examination_conductor_user_id INT,
    FOREIGN KEY (question_paper_id) REFERENCES QuestionPaper(question_paper_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (examination_conductor_user_id) REFERENCES USER(user_id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE UserResponses (
    response_id INT AUTO_INCREMENT PRIMARY KEY,
    exam_id INT NOT NULL,
    student_user_id INT NOT NULL,
    question_id INT NOT NULL,
    selected_option_label CHAR(1) CHECK (selected_option_label IN ('A', 'B', 'C', 'D')),
    FOREIGN KEY (exam_id) REFERENCES Examination(exam_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (student_user_id) REFERENCES USER(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (question_id) REFERENCES Question(question_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE CorrectAnswers (
    question_id INT PRIMARY KEY,
    correct_option_label CHAR(1) CHECK (correct_option_label IN ('A', 'B', 'C', 'D')),
    FOREIGN KEY (question_id) REFERENCES Question(question_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Evaluation (
    evaluation_id INT AUTO_INCREMENT PRIMARY KEY,
    exam_id INT NOT NULL,
    student_user_id INT NOT NULL,
    score INT,
    score_with_respect_to_max_score INT,
    FOREIGN KEY (exam_id) REFERENCES Examination(exam_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (student_user_id) REFERENCES USER(user_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE LiveSession (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    exam_id INT NOT NULL,
    conductor_user_id INT NOT NULL,
    session_code VARCHAR(10) UNIQUE NOT NULL, 
    session_status ENUM('active', 'completed', 'cancelled') DEFAULT 'active',
    FOREIGN KEY (exam_id) REFERENCES Examination(exam_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (conductor_user_id) REFERENCES USER(user_id) ON DELETE CASCADE ON UPDATE CASCADE
);



INSERT INTO USER (user_type, official_email_id)
VALUES
('student', 's1p@gmail.com'),
('student', 's2@gmail.com'),
('student', 's3@gmail.com'),
('student', 's4@gmail.com'),
('question_paper_setter', 'qps1@gmail.com'),
('question_paper_setter', 'qps2@gmail.com'),
('question_paper_setter', 'qps3@gmail.com'),
('question_paper_setter', 'qps4@gmail.com'),
('examination_conductor', 'ec@gmail.com'),
('admin', 'admin@gmail.com');


INSERT INTO Student (student_id, name, gender, date_of_birth, address)
VALUES
(1, 'Jenny Prasad', 'F', '2004-09-15', 'A-123 kamla nagar'),
(2, 'Yashika', 'F', '2005-03-22', 'B-255 bharat nagar'),
(3, 'Khushdeep Singh', 'M', '2006-01-15', 'A-122 shastri nagar'),
(4, 'Divyanshu Jha', 'M', '2003-03-2', 'B-456 shakti nagar');

INSERT INTO QuestionPaper (question_paper_title, question_paper_meta_data, min_req_number_of_questions_to_be_attempted, max_number_of_questions_that_can_be_attempted, max_score, question_paper_setter_id) VALUES
('DSD', 'Focus on designing circuits', 5, 6, 40, 1),
('ADA', 'Algorithm  techniques and analysis', 5, 6, 40, 2),
('PSCS', 'probability and statistics', 5, 6, 40, 3),
('DBMS', 'Database management systems', 5, 6, 40, 4);

INSERT INTO Question (question_paper_id, question_text)
VALUES
(1,'What is Digital Electronics?'),
(1,'Which of the following is correct for Digital Circuits?'),
(1,'What is a Circuit?'),
(1,'Which of the following is a type of digital logic circuit?'),
(1,'Which of the following is an example of a digital Electronic?'),
(1,'What is a switching function that has more than one output called in Digital Electronics?'),
 
(2,'Which of the following algorithms are used to find the shortest path from a source node to all other nodes in a weighted graph?'),
(2,'What is the maximum number of swaps that can be performed in the Selection Sort algorithm?'),
(2,'What is the time complexity of the binary search algorithm?'),
(2,'What should be considered when designing an algorithm?'),
(2,'What will be the best sorting algorithm, given that the array elements are small (<= 1e6)?'),
(2,'What should be considered when designing an algorithm?'),

(3,'A fair dice is rolled. Probability of getting a number x such that 1 < x < 6,is-'),
(3,'If a number is selected at random from the first 100 natural numbers, what will be the probability that the selected number is a perfect cube?'),
(3,'What will be the number of events if 10 coins are tossed simultaneously?'),
(3,'If two dice are thrown simultaneously, what is the probability of getting a multiple of 2 on one dice and multiple of 3 on the other dice?'),
(3,'Four dice are thrown simultaneously. What will be the probability that all of them have the same face?'),
(3,'Two people X and Y apply for a job in a company. The probability of the selection of X is 2/5, and Y is 4/7. What is the probability that both of them get selected?'),

(4,'What is the full form of DBMS?'),
(4,'What is a database?'),
(4,'What is DBMS?'),
(4,'Which type of data can be stored in the database?'),
(4,'In which of the following formats data is stored in the database management system?'),
(4,'Which of the following is not a type of database?');

INSERT INTO Options (question_id, option_text, option_label)
VALUES
(1,'Field of electronics involving the study of digital signal','a'),
(1,'Engineering of devices that digital signal','b'),
(1,'Engineering of devices that produce digital signal','c'),
(1,'All of the above','d'),

(2,'Less susceptible to noise or degradation in quality','a'),
(2,'Use transistors to create logic gates to perform Boolean logic','b'),
(2,'Easier to perform error detection and correction with digital signal','c'),
(2,'All of the above','d'),

(3,'Open-loop through which electrons can pass','a'),
(3,'Closed-loop through which electrons can pass','b'),
(3,'Closed-loop through which Neutrons cannot pass','c'),
(3,'None of the above','d'),

(4,'Combinational logic circuits','a'),
(4,'Sequential logic circuits','b'),
(4,'Both Combinational & Sequential logic circuits','c'),
(4,'None of the above','d'),

(5,'Computers','a'),
(5,'Information appliances','b'),
(5,'Dogigtal Cameras','c'),
(5,'All of the above','d'),

(6,'Multi-gate function','a'),
(6,'Multi-output function','b'),
(6,'Multiple-gate function','c'),
(6,'Multiple-output function','d'),

(7,'BFS','a'),
(7,'Djikstras Alogorithm ','b'),
(7,'Prims Alogorithm','c'),
(7,'Greedy method','d'),

(8,'n-1','a'),
(8,'n','b'),
(8,'1','c'),
(8,'n-2','d'),

(9,'O(n)','a'),
(9,'O(1)','b'),
(9,'O(log2n)','c'),
(9,'0(n^2)','d'),

(10,'Software is used correctly','a'),
(10,'Hardware is used correctly','b'),
(10,'If there is more than one way to solve the problem','c'),
(10,'All of the above','d'),

(11,'Bubble sort','a'),
(11,'Merge sort','b'),
(11,'Counting sort','c'),
(11,'Heap sort','d'),

(12,'Overflow','a'),
(12,'Underflow','b'),
(12,'Syntax error','c'),
(12,'Garbage value','d'),


(13, '0', 'a'),
(13, '>1', 'b'),
(13, 'betwwen 0 and 1', 'c'),
(13, '1', 'd'),


(14, '1/50', 'a'),
(14, '1/25', 'b'),
(14, '1/10', 'c'),
(14, '1/100', 'd'),

(15, '1024', 'a'),
(15, '512', 'b'),
(15, '1000', 'c'),
(15, '2048', 'd'),


(16, '11/36', 'a'),
(16, '1/9', 'b'),
(16, '2/9', 'c'),
(16, '5/36', 'd'),


(17, '1/36', 'a'),
(17, '1/6', 'b'),
(17, '1/216', 'c'),
(17, '1/1296', 'd'),


(18, '8/35', 'a'),
(18, '2/7', 'b'),
(18, '12/35', 'c'),
(18, '4/35', 'd'),

(19, 'Data of Binary Management System', 'a'),
(19, 'Database Management System', 'b'),
(19, 'Database Management Service', 'c'),
(19, 'Data Backup Management System', 'd'),

(20,'Organized collection of information that cannot be accessed, updated, and managed', 'a'),
(20,'Collection of data or information without organizing', 'b'),
(20,'Organized collection of data or information that can be accessed, updated, and managed', 'c'),
(20,'Organized collection of data that cannot be updated', 'd'),

(21, 'DBMS is a collection of queries', 'a'),
(21, 'DBMS is a high-level language', 'b'),
(21, 'DBMS is a programming language', 'c'),
(21, 'DBMS stores, modifies and retrieves data', 'd'),

(22, 'Image oriented data', 'a'),
(22, 'Text, files containing data', 'b'),
(22, 'Data in the form of audio or video', 'c'),
(22, 'All of the above', 'd'),

(23, 'Image', 'a'),
(23, 'Graph', 'b'),
(23, 'Table', 'c'),
(23, 'Text', 'd'),

(24, 'Hierarachial', 'a'),
(24, 'Network', 'b'),
(24, 'Distributed', 'c'),
(24, 'Decentralized', 'd');


INSERT INTO CorrectAnswers (question_id, correct_option_label)
VALUES
(1,'d'),
(2,'d'),
(3,'b'),
(4,'c'),
(5,'d'),
(6,'b'),

(7,'c'),
(8,'a'),
(9,'c'),
(10,'c'),
(11,'c'),
(12,'b'),

(13,'d'),
(14,'b'),
(15,'a'),
(16,'a'),
(17,'c'),
(18,'a'),

(19,'b'),
(20,'c'),
(21,'d'),
(22,'d'),
(23,'c'),
(24,'d');

INSERT INTO Examination (question_paper_id, start_time, end_time, duration, examination_conductor_user_id) VALUES
(1, '2024-12-01 09:00:00', '2024-12-01 10:00:00', 30, 3),
(2, '2024-12-05 11:00:00', '2024-12-05 12:00:00', 30, 3),
(3, '2024-12-01 12:00:00', '2024-12-01 01:00:00', 30, 3),
(4, '2024-12-01 01:00:00', '2024-12-01 02:00:00', 30, 3);

INSERT INTO LiveSession (exam_id, conductor_user_id, session_code, session_status) VALUES
(1, 3, 'ABC123', 'completed'),
(2, 3, 'XYZ789', 'active'),
(3, 3, 'XYZ780', 'cancelled'),
(4, 3, 'XYZ799', 'completed');

 INSERT INTO UserResponses (exam_id, student_user_id, question_id, selected_option_label)
VALUES
(1, 1, 1, 'a'),  
(1, 1, 2, 'b'),  
(1, 1, 3, 'c'),
(1, 1, 4, 'a'),  
(1, 1, 5, 'b'),  
(1, 1, 6, 'c'),
(2, 2, 1, 'a'),  
(2, 2, 2, 'b'),  
(2, 2, 3, 'c'),
(2, 2, 4, 'c'),
(2, 2, 5, 'c'),
(2, 2, 6, 'c');

INSERT INTO Evaluation (student_user_id, exam_id, score_with_respect_to_max_score) 
VALUES 
    (1, 1,35), 
    (2, 2, 40);

SELECT * FROM USER;
SELECT * FROM STUDENT;
SELECT * FROM QUESTIONPAPER;
SELECT * FROM QUESTION;
SELECT * FROM OPTIONS;
SELECT * FROM EXAMINATION;
SELECT * FROM USERRESPONSES;
SELECT * FROM CORRECTANSWERS;
SELECT * FROM EVALUATION;
SELECT * FROM LIVESESSION;


 SELECT -- list of all students and their details
    s.student_id, s.name, s.gender, s.date_of_birth, s.address, u.official_email_id
FROM 
    Student s
JOIN 
    USER u ON s.student_id = u.user_id;
    
    
    SELECT -- list of all exam and details
    e.exam_id, e.start_time, e.end_time, e.duration, 
    qp.question_paper_title, u.official_email_id AS conductor_email
FROM 
    Examination e
JOIN 
    QuestionPaper qp ON e.question_paper_id = qp.question_paper_id
JOIN 
    USER u ON e.examination_conductor_user_id = u.user_id;
    
    
    
SELECT -- list of all question papers
    question_paper_id, question_paper_title, question_paper_meta_data, 
    min_req_number_of_questions_to_be_attempted, 
    max_number_of_questions_that_can_be_attempted, max_score
FROM 
    QuestionPaper;
    
    
    SELECT -- Retrieve all questions and corresponding options for a particular question paper
    q.question_text, o.option_label, o.option_text
FROM 
    Question q
JOIN 
    Options o ON q.question_id = o.question_id
WHERE 
    q.question_paper_id = 4; 
    
    
    SELECT  --  correct answers for each question in a particular question paper:
    q.question_text, ca.correct_option_label
FROM 
    Question q
JOIN 
    CorrectAnswers ca ON q.question_id = ca.question_id
WHERE 
    q.question_paper_id = 4; 
    
    
    SELECT s.student_id, s.name, e.exam_id, q.question_paper_title, e.start_time, e.end_time-- Retrieve All Students Who Have Taken an Examination
FROM Student s
JOIN User u ON s.student_id = u.user_id
JOIN UserResponses ur ON u.user_id = ur.student_user_id
JOIN Examination e ON ur.exam_id = e.exam_id
JOIN QuestionPaper q ON e.question_paper_id = q.question_paper_id
GROUP BY s.student_id, e.exam_id;


SELECT s.student_id, s.name -- list of student who havent given exam
FROM Student s
LEFT JOIN UserResponses ur ON s.student_id = ur.student_user_id
WHERE ur.student_user_id IS NULL;


    
  SELECT -- user response 
    ur.student_user_id, 
    s.name, 
    ur.question_id, 
    ur.selected_option_label
FROM 
    UserResponses ur
JOIN 
    Student s ON ur.student_user_id = s.student_id
WHERE 
    s.student_id = 2;

 

SELECT 
    ur.student_user_id, 
    s.name, 
    COUNT(*) * (MAX(qp.max_score) / NULLIF(COUNT(DISTINCT ca.question_id), 0)) AS student_score
FROM 
    UserResponses ur
JOIN 
    CorrectAnswers ca ON ur.question_id = ca.question_id
JOIN 
    Question q ON ur.question_id = q.question_id
JOIN 
    QuestionPaper qp ON q.question_paper_id = qp.question_paper_id
JOIN 
    Student s ON ur.student_user_id = s.student_id
WHERE 
    ur.selected_option_label = ca.correct_option_label
    AND ur.student_user_id = 2
GROUP BY 
    ur.student_user_id, s.name;



    SELECT -- list of all live session exam
    ls.session_id, ls.session_code, ls.session_status, e.exam_id, e.start_time, u.official_email_id AS conductor_email
FROM 
    LiveSession ls
JOIN 
    Examination e ON ls.exam_id = e.exam_id
JOIN 
    USER u ON ls.conductor_user_id = u.user_id;
    

SELECT 
    e.evaluation_id, 
    e.student_user_id, 
    s.name, 
    e.score_with_respect_to_max_score, 
    ex.exam_id, 
    qp.question_paper_title, 
    qp.max_score
FROM 
    Evaluation e
JOIN 
    Student s ON e.student_user_id = s.student_id
JOIN 
    Examination ex ON e.exam_id = ex.exam_id
JOIN 
    QuestionPaper qp ON ex.question_paper_id = qp.question_paper_id
WHERE 
    qp.question_paper_title = 'DSD';  -- Replace with the actual title


   SELECT  -- total marks obtained by all students in a specific exam and compares it with the maximum possible score for that exam.
    SUM(e.score_with_respect_to_max_score) AS total_marks_obtained,
    COUNT(e.student_user_id) AS total_students,
    qp.max_score * COUNT(e.student_user_id) AS total_possible_score
FROM 
    Evaluation e
JOIN 
    Examination ex ON e.exam_id = ex.exam_id
JOIN 
    QuestionPaper qp ON ex.question_paper_id = qp.question_paper_id
WHERE 
    ex.exam_id = 1;  
    
   
   
    SELECT -- retrieves the student who scored the highest in a particular exam.
    e.student_user_id, s.name, e.score_with_respect_to_max_score
FROM 
    Evaluation e
JOIN 
    Student s ON e.student_user_id = s.student_id
WHERE 
    e.exam_id = 1  
    AND e.score_with_respect_to_max_score = (
        SELECT MAX(score_with_respect_to_max_score)
        FROM Evaluation
        WHERE exam_id = 1 
    );
    
    
    SELECT e.exam_id, COUNT(DISTINCT ur.student_user_id) AS number_of_students-- Get the Number of Students Who Have Taken a Specific Exam
FROM Examination e
JOIN UserResponses ur ON e.exam_id = ur.exam_id
WHERE e.exam_id = 1  
GROUP BY e.exam_id;

SET SQL_SAFE_UPDATES = 0;
    DELETE FROM Evaluation;
    
    INSERT INTO Evaluation (student_user_id, exam_id)
VALUES
(1, 1), 
(2, 2),
(3,3),
(4,4); 

INSERT INTO Evaluation (exam_id, student_user_id, score, score_with_respect_to_max_score)
SELECT
    ur.exam_id,
    ur.student_user_id,
    COUNT(CASE WHEN ur.selected_option_label = ca.correct_option_label THEN 1 END) AS score,
    COUNT(CASE WHEN ur.selected_option_label = ca.correct_option_label THEN 1 END) * 100 / COUNT(ca.correct_option_label) AS score_with_respect_to_max_score
FROM
    Userresponses ur
JOIN
    Correctanswers ca
ON
    ur.question_id = ca.question_id
GROUP BY
    ur.exam_id, ur.student_user_id;
    
    
    
    SELECT ur.student_user_id, ur.exam_id, ur.question_id, ur.selected_option_label, ca.correct_option_label
FROM UserResponses ur
LEFT JOIN CorrectAnswers ca ON ur.question_id = ca.question_id
WHERE ur.exam_id = 1; -- Replace with the exam_id you want to verify



SELECT -- student who scored highest in each sem
    ex.exam_id, 
    qp.question_paper_title, 
    e.student_user_id, 
    s.name AS student_name, 
    MAX(e.score_with_respect_to_max_score) AS highest_score
FROM Evaluation e
JOIN Student s ON e.student_user_id = s.student_id
JOIN Examination ex ON e.exam_id = ex.exam_id
JOIN QuestionPaper qp ON ex.question_paper_id = qp.question_paper_id
GROUP BY ex.exam_id, qp.question_paper_title, e.student_user_id, s.name;

SELECT -- student with less than 50% marks
    e.student_user_id, 
    s.name, 
    e.exam_id, 
    e.score_with_respect_to_max_score
FROM Evaluation e
JOIN Student s ON e.student_user_id = s.student_id
WHERE e.score_with_respect_to_max_score < 50;

SELECT -- live session by status
    ls.session_status, 
    COUNT(*) AS total_sessions
FROM LiveSession ls
GROUP BY ls.session_status;

SELECT -- total score a student in all exam
    e.student_user_id, 
    s.name, 
    SUM(e.score_with_respect_to_max_score) AS total_score
FROM Evaluation e
JOIN Student s ON e.student_user_id = s.student_id
WHERE e.student_user_id = 1 
GROUP BY e.student_user_id, s.name;

SELECT * FROM Evaluation;
