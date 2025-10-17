Create database Student_Survey_db

select * from dbo.StudentSurvey

--1.What are the main factors contributing to the decline in students’ interest in education?
SELECT
    'Teaching Style' AS Challenge_Factor, SUM(challenges_teaching) AS Total_Count
FROM dbo.StudentSurvey
UNION ALL
SELECT
    'Financial Stress' AS Challenge_Factor, SUM(challenges_financial)
FROM dbo.StudentSurvey
UNION ALL
SELECT
    'Mental Health' AS Challenge_Factor, SUM(challenges_mental)
FROM dbo.StudentSurvey
UNION ALL
SELECT
    'Influence' AS Challenge_Factor, SUM(challenges_influence)
FROM dbo.StudentSurvey
UNION ALL
SELECT
    'School Resources' AS Challenge_Factor, SUM(challenges_school)
FROM dbo.StudentSurvey
ORDER BY
    Total_Count DESC


--2.How do demographic variables (age, gender, education level) influence student motivation and academic performance?
--Motivation and performance by Education level
SELECT
    education_level,
    academic_grade,
    COUNT(age_group) AS Total_Students,
    AVG(motivation_level) AS Avg_Motivation_Score
FROM
    dbo.StudentSurvey
GROUP BY
    education_level, academic_grade
ORDER BY
    CASE education_level
        WHEN 'Undergraduate' THEN 1
        WHEN 'Graduate' THEN 2
End
  
--Factor comparison by Gender
SELECT
    gender,
    AVG(teaching_realworld) AS Avg_Teaching_Clarity,
    AVG(challenges_mental) AS Avg_Stress_Score,
	AVG(challenges_financial) AS Avg_Financial_Stress,
	AVG(motivation_level) AS Avg_Motivation_Score
FROM
    StudentSurvey
WHERE
    gender IN ('Male', 'Female')
GROUP BY
    gender
---
SELECT
    age_group,
    AVG(teaching_realworld) AS Avg_Teaching_Clarity,
    AVG(challenges_mental) AS Avg_Stress_Score,
	AVG(challenges_financial) AS Avg_Financial_Stress,
	AVG(motivation_level) AS Avg_Motivation_Score
FROM
    StudentSurvey
GROUP BY
    age_group

---

--3. What is the relationship between learning environments (teaching style, facilities, peer influence) and student engagement?
--Learning environment(facilities) and student engagement
SELECT
	CASE
		WHEN learning_environment >= 4 THEN 'Facilities Adequate (4-5)'
		ELSE 'Facilities Inadequate (1-3)'
	END AS Facility_Group,
	AVG(motivation_level) AS Avg_Motivation_Level,
	AVG(interest_level) AS Avg_Interest_Level
FROM
		StudentSurvey
GROUP BY 
	CASE
		WHEN learning_environment >= 4 THEN 'Facilities Adequate (4-5)'
		ELSE 'Facilities Inadequate (1-3)'
	END 

--peer influence and student engagement
SELECT
    CASE
        WHEN challenges_influence = 1 THEN 'Influence Exists'
        ELSE 'No Influence Exists'
    END AS influence_Group,
    AVG(motivation_level) AS Avg_Motivation_Level,
	AVG(interest_level) AS Avg_Interest_Level
FROM
    StudentSurvey
GROUP BY
	CASE
        WHEN challenges_influence = 1 THEN 'Influence Exists'
        ELSE 'No Influence Exists'
    END
--teaching style and student engagement
SELECT
    CASE
        WHEN challenges_teaching = 1 THEN 'Poor Teaching Style'
        ELSE 'Average Teaching Style'
    END AS Teaching_Group,
    AVG(motivation_level) AS Avg_Motivation_Level,
	AVG(interest_level) AS Avg_Interest_Level
FROM
    StudentSurvey
GROUP BY
	 CASE
        WHEN challenges_teaching = 1 THEN 'Poor Teaching Style'
        ELSE 'Average Teaching Style'
    END

--4. To what extent do personal and external challenges (financial stress, lack of resources, mental health) affect study habits and motivation?
---impact of financial stress on academic grade
SELECT
    academic_grade,
    COUNT(*) AS Total_Responses
FROM
    StudentSurvey
WHERE
    financial_concern = 'Severely' OR financial_concern = 'Significantly'
GROUP BY
    academic_grade
ORDER BY
    CASE academic_grade
        WHEN 'Below Average' THEN 1
		WHEN 'Average' THEN 2
		WHEN 'Good' THEN 3
        ELSE 4
    END DESC

---influence of parental support on study habits
SELECT
    CASE
        WHEN family_encouragement = 'Agree' THEN 'Medium Parental Encouragement'
		WHEN family_encouragement = 'Strongly agree' Then 'High Parental Encouragement'
        ELSE 'Low Parental Encouragement'
    END AS Parental_Support_Group,
    COUNT(CASE WHEN study_hours = '(0-5)' THEN study_hours ELSE NULL END) AS total_low_study,
    COUNT(CASE WHEN study_hours = '(6-10)' THEN study_hours ELSE NULL END) AS total_medium_study,
	COUNT(CASE WHEN study_hours = '(11-15)' THEN study_hours ELSE NULL END) AS total_high_study,
	COUNT(CASE WHEN study_hours = '16+' THEN study_hours ELSE NULL END) AS total_veryhigh_study
FROM
    StudentSurvey
GROUP BY
    CASE
        WHEN family_encouragement = 'Agree' THEN 'Medium Parental Encouragement'
		WHEN family_encouragement = 'Strongly agree' Then 'High Parental Encouragement'
        ELSE 'Low Parental Encouragement'
    END

	---Alternatively
SELECT
    study_hours,
    COUNT(*) AS Total_Responses
FROM
    StudentSurvey
WHERE
    family_encouragement = 'Agree' OR family_encouragement = 'Strongly agree'
GROUP BY
    study_hours
ORDER BY
    CASE study_hours
        WHEN '(0-5)' THEN 1
		WHEN '(6-10)' THEN 2
		WHEN '(11-15)' THEN 3
        ELSE 4
    END DESC


---impact of lack of resources on motivation level
SELECT
	access_to_resources,
    count(*) AS Total_Responses,
	avg(motivation_level) as Avg_Motivation_score
FROM
    StudentSurvey
GROUP BY
    access_to_resources,
	CASE access_to_resources
        WHEN 'Strongly disagree' THEN 1
		WHEN 'Disagree' THEN 2
		WHEN 'Agree' THEN 3
        ELSE 4
    END
ORDER BY
    Avg_Motivation_score desc

---impact of financial strees on motivation level
SELECT
	financial_concern,
	sum(challenges_financial),
    count(*) AS Total_Responses,
	avg(motivation_level) as Avg_Motivation_score
FROM
    StudentSurvey
GROUP BY
    financial_concern,
	CASE financial_concern
        WHEN 'Not at all' THEN 1
		WHEN 'Slightly' THEN 2
		WHEN 'Moderately' THEN 3
        ELSE 4
    END
ORDER BY
    Avg_Motivation_score desc


---impact of mental health on motivation level
SELECT
    CASE challenges_mental
        WHEN '1' THEN 'Yes'
        WHEN '0' THEN 'No'
	END AS Mental_Challenges,
    AVG(motivation_level) AS Avg_Motivation_Score
FROM
    StudentSurvey
GROUP BY
	challenges_mental   
ORDER BY
    Avg_Motivation_Score desc

--5. What strategies or interventions do students believe would improve their interest and performance in education?
---measure the overall enthusiasm for mentorship programs
SELECT
    mentorship_helpfulness,
    COUNT(*) AS Response_Count,
    (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM StudentSurvey)) AS Percentage_Of_Responses
FROM
    StudentSurvey
GROUP BY
    mentorship_helpfulness
ORDER BY
    Percentage_Of_Responses DESC

---measure of willingness to use mental health services
SELECT
    use_stress_service,
    COUNT(*) AS Total_Count,
    (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM StudentSurvey)) AS Percentage_of_Total
FROM
    StudentSurvey
GROUP BY
    use_stress_service
ORDER BY 
	Percentage_of_Total desc