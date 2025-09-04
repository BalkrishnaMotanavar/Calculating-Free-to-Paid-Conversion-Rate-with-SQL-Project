# 365 Platform Conversion Analysis

## Overview
This project analyzes user behavior on the 365 educational platform to determine key metrics related to user engagement and conversion to paid subscriptions. Using SQL queries, the project processes data from three tables (`student_info`, `student_engagement`, `student_purchases`) to answer:
- What is the free-to-paid conversion rate for students who watched a lecture?
- What is the average duration between registration and first engagement (watching a lecture)?
- What is the average duration between first engagement and first purchase?
- What are the implications of these metrics for the platform?

The analysis involves two SQL queries:
- **Task 1**: A subquery to create a dataset of students who watched a lecture.
- **Task 2**: A main query to compute conversion and duration metrics.

## Dataset
The dataset consists of three tables:
- **student_info**: 40,979 records with `student_id` and `date_registered`.
- **student_engagement**: 74,246 records with `student_id` and `date_watched`.
- **student_purchases**: 5,922 records with `purchase_id`, `student_id`, and `date_purchased`.

## Files
- `task1_subquery.sql`: SQL query to generate a dataset of 20,255 students who watched a lecture, including:
  - `student_id`
  - `date_registered`
  - `first_date_watched` (earliest lecture watched)
  - `first_date_purchased` (earliest purchase, NULL if none)
  - `date_diff_reg_watch` (days between registration and first lecture)
  - `date_diff_watch_purch` (days between first lecture and purchase, NULL if none)
- `task2_main_query.sql`: SQL query to compute:
  - `conversion_rate`: Percentage of engaged students who purchased (11.29%).
  - `av_reg_watch`: Average days from registration to first lecture (3.4239 days).
  - `av_watch_purch`: Average days from first lecture to purchase (26.2472 days).
- `db_course_conversions.sql` (optional): Database schema for the tables (not included by default).

## Setup
### Prerequisites
- **SQL**: A MySQL-compatible database (e.g., MySQL, MariaDB).
- **Data**: The `db_course_conversions` schema with the three tables.

### Database Setup
1. Import the `db_course_conversions.sql` schema (if available) into your MySQL database.
2. Verify the tables:
   - `student_info`: 40,979 records
   - `student_engagement`: 74,246 records
   - `student_purchases`: 5,922 records

## Usage
1. **Run Task 1 Subquery**:
   - Execute `task1_subquery.sql` to generate a dataset with 20,255 records of students who watched a lecture.
   - Optional: Export the results to a CSV for further analysis (not included in this repository).

2. **Run Task 2 Main Query**:
   - Execute `task2_main_query.sql` to compute the metrics:
     - `conversion_rate`: 11.29%
     - `av_reg_watch`: 3.4239 days
     - `av_watch_purch`: 26.2472 days

   Example command in MySQL:
   ```sql
   SOURCE task2_main_query.sql;
   ```

## Results
- **Free-to-Paid Conversion Rate**: 11.29%
  - Approximately 2,287 of 20,255 engaged students purchased a subscription.
- **Average Registration to Engagement**: 3.4239 days
  - Students typically watch their first lecture ~3.4 days after registering.
- **Average Engagement to Purchase**: 26.2472 days
  - Students who purchase take ~26.2 days after their first lecture to subscribe.

## Interpretation
- **Conversion Rate (11.29%)**:
  - Within the 5–20% industry range for e-learning platforms but lower than top performers (15–20%).
  - Indicates effective initial engagement (~49.4% of 40,979 registered students watch a lecture) but a bottleneck in converting to paid users.
  - **Recommendation**: Enhance subscription value (e.g., exclusive content, certifications) or offer time-sensitive promotions to boost conversions.
- **Registration to Engagement (3.42 days)**:
  - Short duration suggests a user-friendly registration process and effective onboarding.
  - However, ~19,724 registered users never watched a lecture, indicating potential barriers for some users.
  - **Recommendation**: Promote high-value content within the first 3–4 days and target non-engaged users with re-engagement campaigns (e.g., tutorials, reminders).
- **Engagement to Purchase (26.25 days)**:
  - Long duration suggests users need time to evaluate the platform, risking drop-off.
  - Possible reasons include waiting for discounts or insufficient differentiation between free and paid content.
  - **Recommendation**: Introduce early upsell triggers (e.g., discounts within 7–14 days) and analyze conversion triggers at ~26 days.

## Implications
- **Strengths**: The platform excels at driving quick initial engagement (3.4 days to watch a lecture) and achieves a moderate conversion rate.
- **Opportunities**: Increase the conversion rate by improving subscription value and shorten the 26-day purchase delay with targeted incentives.
- **Challenges**: Engage the ~19,724 non-engaged registered users and reduce drop-off during the engagement-to-purchase period.

## License
This project is licensed under the MIT License.

## Contact
For questions or contributions, please open an issue or contact [your-email@example.com].