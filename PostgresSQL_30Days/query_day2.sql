/*
Page With No Likes [Facebook SQL Interview Question]

Assume you're given two tables containing data about Facebook Pages and their respective likes (as in "Like a Facebook Page").

Write a query to return the IDs of the Facebook pages that have zero likes. The output should be sorted in ascending order based on the page IDs.

pages Table: page_id, page_name =	integer, varchar

page_likes Table: user_id, page_id = integer, integer


*/

-- Link to the problem: https://datalemur.com/questions/sql-page-with-no-likes


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 					Solution
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SELECT 
  page_id
FROM pages
WHERE page_id NOT IN(SELECT page_id
                      FROM page_likes)
ORDER BY 1
;


/*
- App Click-through Rate (CTR) [Facebook SQL Interview Question]

Assume you have an events table on Facebook app analytics. 
Write a query to calculate the click-through rate (CTR) for the app in 2022 and round the results to 2 decimal places.

- Definition and note:

Percentage of click-through rate (CTR) = 100.0 * Number of clicks / Number of impressions
To avoid integer division, multiply the CTR by 100.0, not 100.

- events Table: app_id(integer), event_type(string), timestamp(datetime)

- Explanation:
Let's consider an example of App 123. This app has a click-through rate (CTR) of 50.00% because out of the 2 impressions it received, it got 1 click.

To calculate the CTR, 
we divide the number of clicks by the number of impressions, 
and then multiply the result by 100.0 to express it as a percentage. 
In this case, 1 divided by 2 equals 0.5, and when multiplied by 100.0, 
it becomes 50.00%. So, the CTR of App 123 is 50.00%.

*/

-- Link of the problem: https://datalemur.com/questions/click-through-rate

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 					Solution
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

WITH CTE AS 
(SELECT
  app_id,
  SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) AS click,
  SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END) AS imp
FROM events
WHERE EXTRACT(YEAR FROM timestamp) = '2022'
GROUP BY app_id)

SELECT app_id,
ROUND(100.0 * click/imp, 2)
AS ctr
FROM CTE;


/*
- Histogram of Tweets [Twitter SQL Interview Question]


This is the same question as problem #6 in the SQL Chapter of Ace the Data Science Interview!

Assume you're given a table Twitter tweet data, write a query to obtain a histogram of tweets posted per user in 2022. Output the tweet count per user as the bucket and the number of Twitter users who fall into that bucket.

In other words, group the users by the number of tweets they posted in 2022 and count the number of users in each group.

tweets Table: tweet_id(integer), user_id(integer), msg(integer), tweet_date(integer)

tweets Example Input:

+-----------+----------+-----------------------------------------------------------------+-------------------------+
| tweet_id  | user_id  | msg                                                             |     tweet_date          |
+-----------+----------+-----------------------------------------------------------------+-------------------------+
|  214252   |  111     | Am considering taking Tesla private at $420. Funding secured.   |   12/30/2021 00:00:00   |
+-----------+----------+-----------------------------------------------------------------+-------------------------+
|  739252   |  111     | Despite the constant negative press covfefe                     |   01/01/2022 00:00:00   |
+-----------+----------+-----------------------------------------------------------------+-------------------------+
|  846402   |  111     | Following @NickSinghTech on Twitter changed my life!            |   02/14/2022 00:00:00   |
+-----------+----------+-----------------------------------------------------------------+-------------------------+
|  241425   |  254     | If the salary is so competitive y wont you tell me what it is?  |   03/01/2022 00:00:00   |
+-----------+----------+-----------------------------------------------------------------+-------------------------+
|  231574   |  148     | I no longer have a manager. I can't be managed.                 |   03/23/2022 00:00:00   |
+-----------+----------+-----------------------------------------------------------------+-------------------------+


Example Output:

+-------------+-------------+
tweet_bucket  |  users_num  |
+-------------+-------------+
|    1        |      2      |
+-------------+-------------+
|    2        |      1      |
+-------------+-------------+

Explanation:

Based on the example output, there are two users who posted only one tweet in 2022, and one user who posted two tweets in 2022. 
The query groups the users by the number of tweets they posted and displays the number of users in each group.

*/

-- Link of the problem: https://datalemur.com/questions/sql-histogram-tweets

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 					Solution
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SELECT
    per_user_count AS tweet_bucket,
    COUNT(user_id) AS number_of_user
FROM
    (SELECT user_id,
          COUNT(tweet_id) AS per_user_count
    FROM tweets
    WHERE EXTRACT(YEAR FROM tweet_date) = '2022'
    GROUP BY user_id) AS total_tweets
GROUP BY per_user_count;

