-- 13 SQL Challenge

-- Q.1 SCHEMAS

CREATE TABLE fb_posts (
    post_id INT PRIMARY KEY,
    user_id INT,
    likes INT,
    comments INT,
    post_date DATE
);


INSERT INTO fb_posts (post_id, user_id, likes, comments, post_date) VALUES
(1, 101, 50, 20, '2024-02-27'),
(2, 102, 30, 15, '2024-02-28'),
(3, 103, 70, 25, '2024-02-29'),
(4, 101, 80, 30, '2024-03-01'),
(5, 102, 40, 10, '2024-03-02'),
(6, 103, 60, 20, '2024-03-03'),
(7, 101, 90, 35, '2024-03-04'),
(8, 101, 90, 35, '2024-03-05'),
(9, 102, 50, 15, '2024-03-06'),
(10, 103, 30, 10, '2024-03-07'),
(11, 101, 60, 25, '2024-03-08'),
(12, 102, 70, 30, '2024-03-09'),
(13, 103, 80, 35, '2024-03-10'),
(14, 101, 40, 20, '2024-03-11'),
(15, 102, 90, 40, '2024-03-12'),
(16, 103, 20, 5, '2024-03-13'),
(17, 101, 70, 25, '2024-03-14'),
(18, 102, 50, 15, '2024-03-15'),
(19, 103, 30, 10, '2024-03-16'),
(20, 101, 60, 20, '2024-03-17');

/*
-- Q.1
Question: Identify the top 3 posts with the highest engagement 
(likes + comments) for each user on a Facebook page. Display 
the user ID, post ID, engagement count, and rank for each post.
*/

-- top 3 posts by each user
-- SUM (likes+comments)
-- posts rank

WITH posts_rank
AS
	(SELECT 
		user_id,
		post_id,
		SUM(likes + comments) as engagement_count,
		ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY SUM(likes + comments) DESC) AS rn,
		DENSE_RANK() OVER(PARTITION BY user_id ORDER BY SUM(likes + comments) DESC) AS ranks
	FROM fb_posts
	GROUP BY 1,2
	ORDER BY user_id, engagement_count DESC)
SELECT
	user_id,
	post_id,
	engagement_count,
	ranks
FROM posts_rank
WHERE rn < 4;


/*
-- Q.2

Determine the users who have posted more than 2 times 
in the past week and calculate the total number of likes
they have received. Return user_id and number of post and no of likes
*/

SELECT * FROM fb_posts ORDER BY post_date;

SELECT
	user_id,
	SUM(likes) total_likes,
	COUNT(post_id) post_count
FROM fb_posts
WHERE post_date >= CURRENT_DATE - 7 AND
		post_date < CURRENT_DATE
GROUP BY user_id
HAVING COUNT(post_id) > 2;