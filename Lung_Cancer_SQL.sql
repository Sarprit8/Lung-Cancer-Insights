DROP TABLE IF EXISTS LUNG_CANCER_DATA;

CREATE TABLE LUNG_CANCER_DATA(
					id SERIAL PRIMARY KEY,
					age INT NOT NULL,
					gender VARCHAR (20),
					country VARCHAR (50),
					diagnosis_date DATE,
					cancer_stage  VARCHAR (20),
					family_history VARCHAR (10),
					smoking_status VARCHAR (55),
					bmi FLOAT,
					cholesterol_level FLOAT,
					hypertension VARCHAR (10),
					asthma VARCHAR (10),
					cirrhosis VARCHAR (10),
					other_cancer VARCHAR (10),
					treatment_type VARCHAR (30),
					end_treatment_date DATE,
					survived VARCHAR (10)
);

SELECT * FROM LUNG_CANCER_DATA
ORDER BY ID ASC;

--What is the age distribution of lung cancer patients by gender?
SELECT AGE, GENDER , COUNT(*) AS Total_patients
FROM LUNG_CANCER_DATA
GROUP BY AGE,GENDER
ORDER BY Total_patients DESC;

--Which countries have the highest number of lung cancer cases?
SELECT COUNTRY, MAX(patients) AS Total_patients
FROM (SELECT COUNTRY,COUNT(*) AS patients FROM LUNG_CANCER_DATA
         GROUP BY COUNTRY)
GROUP BY COUNTRY
ORDER BY Total_patients DESC LIMIT 1;

--What is the average BMI and cholesterol level among diagnosed patients?
SELECT CAST(AVG(bmi) AS DECIMAL(10, 2))AS AVG_bmi, 
        CAST(AVG(cholesterol_level)AS DECIMAL(10,2)) AS AVG_cholesterol
FROM LUNG_CANCER_DATA;

--How is smoking status related to lung cancer stage and survival?
SELECT smoking_status, cancer_stage , COUNT(*) AS Total_patients,
       SUM(CASE WHEN Survived = 'Yes' THEN 1 ELSE 0 END) AS Survived_patients,
      ROUND(SUM(CASE WHEN Survived = 'Yes' THEN 1 ELSE 0 END)*100/ COUNT(*),2) AS
	  Survival_percentage
FROM LUNG_CANCER_DATA
GROUP BY smoking_status, cancer_stage ; 

--What’s the survival rate by gender and age group? 
SELECT Gender, CASE WHEN AGE BETWEEN 0 AND 20 THEN '0-20'
                    WHEN AGE BETWEEN 21 AND 40 THEN '21-40'
                    WHEN AGE BETWEEN 41 AND 60 THEN '41-60'
					WHEN AGE BETWEEN 61 AND 70 THEN '61-70'
					WHEN AGE BETWEEN 71 AND 80 THEN '71-80'
					WHEN AGE >80 THEN '80+'
	END AS age_group, COUNT(*) AS Total_patients,
SUM(CASE WHEN Survived='Yes' THEN 1 ELSE 0 END ) AS Survived_patients,
ROUND(SUM(CASE WHEN Survived='Yes' THEN 1 ELSE 0 END)*100/COUNT(*),2) AS Survival_rate
FROM LUNG_CANCER_DATA
GROUP BY Gender,CASE WHEN AGE BETWEEN 0 AND 20 THEN '0-20'
                    WHEN AGE BETWEEN 21 AND 40 THEN '21-40'
                    WHEN AGE BETWEEN 41 AND 60 THEN '41-60'
					WHEN AGE BETWEEN 61 AND 70 THEN '61-70'
					WHEN AGE BETWEEN 71 AND 80 THEN '71-80'
					WHEN AGE >80 THEN '80+'END  
ORDER BY  age_group;			
--What is the average treatment duration (diagnosis → end treatment)?
SELECT ROUND(AVG(End_treatment_date-Diagnosis_date),0) AS AVG_Treatment_duration
FROM LUNG_CANCER_DATA;


