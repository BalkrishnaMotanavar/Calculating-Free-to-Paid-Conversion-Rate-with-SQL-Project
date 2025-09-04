USE db_course_conversions;

##########################################################################################################################################

# Create the subquery
-- Import the db_course_conversions database—stored in the db_course_conversions.sql file—into your schemas and study its content.

-- Then, by appropriately joining and aggregating the tables, create a new result dataset comprising the following columns:
-- student_id – (int) the unique identification of a student
-- date_registered – (date) the date on which the student registered on the 365 platform
-- first_date_watched – (date) the date of the first engagement
-- first_date_purchased – (date) the date of first-time purchase (NULL if they have no purchases)
-- date_diff_reg_watch – (int) the difference in days between the registration date and the date of first-time engagement
-- date_diff_watch_purch – (int) the difference in days between the date of first-time engagement and the date of first-time purchase (NULL if they have no purchases)

-- Hint: Research the DATEDIFF function in MySQL.

-- The resulting set you retrieve should include the student IDs of students entering the diagram’s shaded region i.e student engagement.
-- Additionally, your objective is to determine the conversion rate of students who have already watched a lecture.
-- Therefore, filter your result dataset so that the date of first-time engagement comes before (or is equal to) the date of first-time purchase.

-- Sanity check: The number of records in the resulting set should be 20,255.

SELECT 
    si.student_id,
    si.date_registered,
    se.first_date_watched,
    sp.first_date_purchased,
    DATEDIFF(se.first_date_watched, si.date_registered) AS date_diff_reg_watch,
    DATEDIFF(sp.first_date_purchased, se.first_date_watched) AS date_diff_watch_purch
FROM 
    student_info si
INNER JOIN
    (
    SELECT 
        student_id, 
        MIN(date_watched) AS first_date_watched
    FROM 
        student_engagement
    GROUP BY 
        student_id
	) se ON si.student_id = se.student_id
LEFT JOIN
	(
    SELECT 
        student_id, 
        MIN(date_purchased) AS first_date_purchased
    FROM 
        student_purchases
    GROUP BY 
        student_id
	) sp ON si.student_id = sp.student_id
WHERE 
    se.first_date_watched IS NOT NULL
    AND (sp.first_date_purchased IS NULL OR se.first_date_watched <= sp.first_date_purchased);
    
###########################################################################################################################################

# Create the Main Query
-- In this task, you should use the subquery you’ve created above and retrieve the following three metrics.

-- 1. Free-to-Paid Conversion Rate:
		-- This metric measures the proportion of engaged students who choose to benefit from full course access on the 365 platform
        -- by purchasing a subscription after watching a lecture.
        -- It is calculated as the ratio between:
			-- The number of students who watched a lecture and purchased a subscription on the same day or later.
            -- The total number of students who have watched a lecture.
		-- Convert the result to percentages and call the field conversion_rate.

-- 2. Average Duration Between Registration and First-Time Engagement:
		-- This metric measures the average duration between the date of registration and the date of first-time engagement.
        -- This will tell us how long it takes, on average, for a student to watch a lecture after registration.
        -- The metric is calculated by finding the ratio between:
			-- The sum of all such durations.
            -- The count of these durations, or alternatively, the number of students who have watched a lecture.
		-- Call the field av_reg_watch.
        
-- 3. Average Duration Between First-Time Engagement and First-Time Purchase:
		-- This metric measures the average time it takes individuals to subscribe to the platform after viewing a lecture.
        -- It is calculated by dividing:
			-- The sum of all such durations.
            -- The count of these durations, or alternatively, the number of students who have made a purchase.
		-- Call the field av_watch_purch.
        
SELECT 
    (COUNT(CASE WHEN first_date_purchased IS NOT NULL THEN 1 END) / COUNT(*) * 100) AS conversion_rate,
    AVG(date_diff_reg_watch) AS av_reg_watch,
    AVG(CASE WHEN first_date_purchased IS NOT NULL THEN date_diff_watch_purch END) AS av_watch_purch
FROM
	(
		SELECT 
			si.student_id,
			si.date_registered,
			se.first_date_watched,
			sp.first_date_purchased,
			DATEDIFF(se.first_date_watched, si.date_registered) AS date_diff_reg_watch,
			DATEDIFF(sp.first_date_purchased, se.first_date_watched) AS date_diff_watch_purch
		FROM 
			student_info si
		INNER JOIN
			(
			SELECT 
				student_id, 
				MIN(date_watched) AS first_date_watched
			FROM 
				student_engagement
			GROUP BY 
				student_id
			) se ON si.student_id = se.student_id
		LEFT JOIN
			(
			SELECT 
				student_id, 
				MIN(date_purchased) AS first_date_purchased
			FROM 
				student_purchases
			GROUP BY 
				student_id
			) sp ON si.student_id = sp.student_id
		WHERE 
			se.first_date_watched IS NOT NULL
			AND (sp.first_date_purchased IS NULL OR se.first_date_watched <= sp.first_date_purchased)
	) AS engaged_students;
    
###########################################################################################################################################

# Interpretation
-- What you should’ve retrieved by now are
	-- the free-to-paid conversion rate of students who’ve started a lecture,
    -- the average duration between the registration date and date of first-time engagement, and
    -- the average duration between the dates of first-time engagement and first-time purchase.

-- 1. consider the conversion rate and compare this metric to industry benchmarks or historical data.
-- 2. examine the duration between the registration date and date of first-time engagement.
		-- A short duration—watching on the same or the next day—could indicate that the registration process and initial platform experience are user-friendly.
        -- At the same time, a longer duration may suggest that users are hesitant or facing challenges.
-- 3. regarding the time it takes students to convert to paid subscriptions after their first lecture,
		-- a shorter span would suggest compelling content or effective up-sell strategies.
        -- A longer duration might indicate that students have been waiting for the product to be offered at an exclusive price.
        

# Answers
-- 1. Free-to-Paid Conversion Rate: 11.2900%
		-- Approximately 11.29% of the 20,255 students who watched a lecture on the 365 platform purchased a subscription (around 2,287 students).
        -- This indicates that while nearly half of the 40,979 registered students engage by watching a lecture (~49.4%), only a small fraction of these engaged users convert to paid subscribers.
        
        -- Comparison to Industry Benchmarks:
			-- Free-to-paid conversion rates for online education platforms typically range from 5–20%,
            -- depending on the platform’s model (e.g., freemium, trial-based) and industry (e.g., e-learning, SaaS).
            -- A conversion rate of 11.29% is within this range but on the lower side compared to top-performing platforms like Coursera or Udemy, which often report 15–20% for engaged users.
            -- This suggests the 365 platform is moderately effective at converting engaged users but has room for improvement compared to industry leaders.
            
		-- Implications:
			-- Strengths: The platform successfully drives initial engagement (20,255 engaged out of 40,979 registered), but the conversion rate indicates a bottleneck in convincing users to pay.
            -- Potential Issues: Possible reasons for the modest conversion rate include insufficient differentiation between free and paid content, high subscription costs, or lack of compelling upsell triggers.
            -- Recommendations:
				-- Enhance the value of paid subscriptions (e.g., exclusive content, certifications, or personalized learning paths).
				-- Introduce limited-time offers or trial periods to nudge engaged users toward purchasing.
				-- Analyze user feedback to identify barriers to conversion (e.g., pricing, user experience).
        
-- 2. Average Duration Between Registration and First-Time Engagement: 3.4239 days
		-- On average, students take ~3.42 days to watch their first lecture after registering.
        -- This short duration suggests that the registration process and initial platform experience are user-friendly, encouraging quick exploration of content.
        
        -- Implications:
			-- Strengths: A ~3.4-day gap indicates effective onboarding (e.g., clear navigation, engaging free content, or prompts like welcome emails). This is a positive sign, as users quickly interact with the platform.
            -- Potential Issues: While 3.4 days is short, the ~19,724 registered students who never watched a lecture (40,979 − 20,255) suggest a significant portion of users face barriers to initial engagement.
			-- Recommendations:
				-- Leverage the early engagement window (first 3–4 days) to promote high-quality content or subscription benefits.
                -- Investigate why nearly half of registered users don’t engage and target them with re-engagement campaigns (e.g., tutorials, reminders).
                -- Ensure the first lecture experience is compelling to retain users.
                
-- 3. Average Duration Between First-Time Engagement and First-Time Purchase: 26.2472 days
		-- For the ~2,287 students who purchased a subscription, it takes an average of ~26.25 days after watching their first lecture to make a purchase.
        -- This relatively long duration suggests that students need significant time to evaluate the platform’s value before committing financially.
        
        -- Implications:
			-- Strengths: The delay indicates users are likely exploring multiple lectures or courses, suggesting deep engagement with the platform’s content.
            -- Potential Issues: A 26-day gap risks user drop-off, as students may lose interest or find free content sufficient. It could also indicate that upsell strategies (e.g., prompts to subscribe) are not effective enough early on.
            -- Recommendations:
				-- Introduce time-sensitive incentives (e.g., discounts within 7–14 days of engagement) to shorten the conversion window.
                -- Use behavioral triggers (e.g., completing a course or reaching a content limit) to prompt purchases.
                -- Analyze what drives conversions at ~26 days (e.g., specific content, promotions) to optimize the user journey.
                
                
		