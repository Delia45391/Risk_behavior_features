USE risk_features;

-- Q1. What gender has the highest level of education (Doctorate)?

SELECT
	Gender,
    SUM(CASE WHEN Education_Level = 'Doctorate' THEN 1 ELSE 0 END) AS 'Doctorate',
    COUNT(*) AS 'Total',
    ROUND(SUM(CASE WHEN Education_Level = 'Doctorate' THEN 1 ELSE 0 END)/COUNT(*) * 100, 2) AS 'Doctorate_Percentage'
FROM risk_behavior_features
GROUP BY Gender
ORDER BY Gender;

-- Q2. What is the average income for each education level?

SELECT 
	Education_Level,
    COUNT(Education_Level) AS 'Total_Education_Level',
    AVG(Income) AS 'Average_Income',
    MAX(Income) AS 'Maximum_Income'
FROM risk_behavior_features
GROUP BY Education_Level
ORDER BY AVG(Income) DESC;

-- Q3. Which marital status has the highest credit score?

SELECT 
	Marital_Status,
    MAX(Credit_Score) AS 'Highest_Credit_Score'
FROM risk_behavior_features
GROUP BY Marital_Status
ORDER BY MAX(Credit_Score) DESC;

-- Q4. How many people are unemployed and what is the average age compared with the employed ones?

SELECT 
	Employment_Status,
    COUNT(Employment_Status) AS 'Employmenr_Count',
    ROUND(AVG(Age)) AS 'Avg_Age'
FROM risk_behavior_features
GROUP BY Employment_Status;

-- Q5. Who has the highest and the lowest value of the assets?

-- Checking if there are individuals with the same value of assets.
SELECT 
	Assets_Value,
    COUNT(ID)
FROM risk_behavior_features
GROUP BY Assets_Value
HAVING COUNT(Assets_Value) > 1;


-- The highest and the lowest assets value that aren't displayed in the previous query
SELECT 
	MAX(Assets_Value) AS 'Max', 
	MIN(Assets_Value) AS 'Min'
FROM risk_behavior_features;

-- Getting the information about the one with the highest and the one with the lowest assets value
SELECT * FROM risk_behavior_features
WHERE Assets_Value IN (
	(SELECT MAX(Assets_Value) AS 'Max' FROM risk_behavior_features),
    (SELECT MIN(Assets_Value) AS 'Min' FROM risk_behavior_features) 
);

-- Q6. What is the average and the median of the income column?

SELECT
	(SELECT ROUND(AVG(Income), 2) FROM risk_behavior_features) AS 'Average',
    (SELECT ROUND(AVG(Income),2)
	FROM (
		SELECT
			Income,
			ROW_NUMBER() OVER (ORDER BY Income) AS 'rn',
			COUNT(*) OVER () AS 'Total'
		FROM risk_behavior_features
    ) AS m
		WHERE rn IN (FLOOR((Total + 1) / 2), CEIL ((Total + 1) / 2))) AS 'Median';
        
-- Q7. How many individuals have an income higher than the average income?

-- Display who gain higher income than the average income of the data set

SELECT
	ID,
    Income,
    (SELECT AVG(Income) FROM risk_behavior_features) AS 'Average'
FROM risk_behavior_features
WHERE Income > (SELECT AVG(Income) FROM risk_behavior_features);

-- Get the number of individuals with higher income than the average income

SELECT
	COUNT(ID) AS 'Count',
    (SELECT COUNT(*) FROM risk_behavior_features) AS 'Total'
FROM risk_behavior_features
WHERE Income > (SELECT AVG(Income) FROM risk_behavior_features);

-- Q8. Select top 10 highest income and analyse the best paid jobs.

-- Create a new table with the individuals' name and job (fictive data) and then join it with the income column from risk_behavior_feature table 
CREATE TABLE Persons (
Person_Id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
Person_name VARCHAR(250) NOT NULL,
City VARCHAR(200) NOT NULL,
Job VARCHAR(200) NOT NULL
);

INSERT INTO Persons(Person_name, City, Job) 
VALUES
('Ozzy Osbourne', 'Birmingham', 'Singer'),
('David Bowie', 'Bucharest', 'Data Analyst'),
('Mick Jagger', 'Paris', 'Waiter'),
('Elton John', 'Tokyo', 'Software Developer'),
('Freddie Mercury', 'Frankfurt', 'Economist'),
('Robert Plant', 'Copenhagen', 'Tourist Guide'),
('Paul McCartney', 'Seul', 'Chef'),
('Sting', 'Cairo', 'Waiter'),
('Bono', 'London', 'Designer'),
('Adele Adkins', 'Bucharest', 'Plumber'),
('John Lennon', 'Paris', 'Singer'),
('Kurt Cobain', 'Tokyo', 'Data Analyst'),
('Dave Grohl', 'Frankfurt', 'Waiter'),
('Liam Gallagher', 'Copenhagen', 'Software Developer'),
('Noel Gallagher', 'Seul', 'Economist'),
('Chris Martin', 'Cairo', 'Tourist Guide'),
('Thom Yorke', 'London', 'Chef'),
('Bjork', 'Bucharest', 'Waiter'),
('Shakira', 'Paris', 'Designer'),
('Rihanna', 'Tokyo', 'Plumber'),
('David Beckham', 'Frankfurt', 'Singer'),
('Cristiano Ronaldo', 'Copenhagen', 'Data Analyst'),
('Lionel Messi', 'Seul', 'Waiter'),
('Neymar Jr.', 'Cairo', 'Software Developer'),
('Harry Kane', 'London', 'Economist'),
('Marcus Rashford', 'Bucharest', 'Tourist Guide'),
('Wayne Rooney', 'Paris', 'Chef'),
('Paulo Dybala', 'Tokyo', 'Waiter'),
('Karim Benzema', 'Frankfurt', 'Designer'),
('Zlatan Ibrahimovic', 'Copenhagen', 'Plumber'),
('Elon Musk', 'Seul', 'Singer'),
('Mark Zuckerberg', 'Cairo', 'Data Analyst'),
('Bill Gates', 'London', 'Waiter'),
('Larry Page', 'Bucharest', 'Software Developer'),
('Sergey Brin', 'Paris', 'Economist'),
('Jeff Bezos', 'Tokyo', 'Tourist Guide'),
('Steve Jobs', 'Frankfurt', 'Chef'),
('Satya Nadella', 'Copenhagen', 'Waiter'),
('Sundar Pichai', 'Seul', 'Designer'),
('Tim Cook', 'Cairo', 'Plumber'),
('Warren Buffett', 'London', 'Singer'),
('Christine Lagarde', 'Bucharest', 'Data Analyst'),
('Mario Draghi', 'Paris', 'Waiter'),
('Paul Krugman', 'Tokyo', 'Software Developer'),
('Janet Yellen', 'Frankfurt', 'Economist'),
('Joseph Stiglitz', 'Copenhagen', 'Tourist Guide'),
('Milton Friedman', 'Seul', 'Chef'),
('Adam Smith', 'Cairo', 'Waiter'),
('David Ricardo', 'London', 'Designer'),
('Karl Marx', 'Bucharest', 'Plumber'),
('Gordon Ramsay', 'Paris', 'Singer'),
('Jamie Oliver', 'Tokyo', 'Data Analyst'),
('Anthony Bourdain', 'Frankfurt', 'Waiter'),
('Nigella Lawson', 'Copenhagen', 'Software Developer'),
('Heston Blumenthal', 'Seul', 'Economist'),
('Wolfgang Puck', 'Cairo', 'Tourist Guide'),
('Alain Ducasse', 'London', 'Chef'),
('Massimo Bottura', 'Bucharest', 'Waiter'),
('Rene Redzepi', 'Paris', 'Designer'),
('Paul Bocuse', 'Tokyo', 'Plumber'),
('David Chang', 'Frankfurt', 'Singer'),
('Marco Pierre White', 'Copenhagen', 'Data Analyst'),
('Ferran Adrià', 'Seul', 'Waiter'),
('Remy Martin', 'Cairo', 'Software Developer'),
('Virgil Abloh', 'London', 'Economist'),
('Karl Lagerfeld', 'Bucharest', 'Tourist Guide'),
('Coco Chanel', 'Paris', 'Chef'),
('Giorgio Armani', 'Tokyo', 'Waiter'),
('Donatella Versace', 'Frankfurt', 'Designer'),
('Ralph Lauren', 'Copenhagen', 'Plumber'),
('Tom Ford', 'Seul', 'Singer'),
('Stella McCartney', 'Cairo', 'Data Analyst'),
('Yves Saint Laurent', 'London', 'Waiter');

SELECT * FROM Persons;

-- Get top 10 highest value and the job that are matching

SELECT
	r.ID,
    r.Income,
    p.Person_name,
    p.Job
FROM risk_behavior_features r
INNER JOIN Persons p ON r.ID = p.Person_Id
ORDER BY Income DESC
LIMIT 10;

-- Finding the number of job appearance in the top 10 highest income

SELECT
	Job,
	COUNT(*) as Appearance
FROM (
	SELECT
		p.Job
	FROM risk_behavior_features r 
	INNER JOIN Persons p ON r.ID=p.Person_Id
	ORDER BY r.Income DESC
	LIMIT 10) as Top10
GROUP BY Job;