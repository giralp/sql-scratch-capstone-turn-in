-- Quiz Funnel
SELECT *
 FROM survey
 LIMIT 10;


-- Number of responses for each question
SELECT question AS 'question',
       COUNT (DISTINCT user_id) AS 'num_answers'
 FROM survey
 GROUP BY question;


--Home Try-On Funnel
SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

-- Creating a new table
SELECT DISTINCT q.user_id,
       h.user_id IS NOT NULL AS 'is_home_try_on',
       h.number_of_pairs,
       p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
  ON q.user_id = h.user_id
LEFT JOIN purchase p
  ON h.user_id = p.user_id
  LIMIT 10; 
  

-- Test if the user ids are DISTINCT  
SELECT COUNT (DISTINCT user_id) AS 'quiz_num_user'
FROM quiz;

SELECT COUNT (DISTINCT user_id) AS 'home_try_on_num_user'
FROM home_try_on;

SELECT COUNT (DISTINCT user_id) AS 'purchase_num_user'
FROM purchase;


--Compare Funnels For A/B Test:
SELECT number_of_pairs,
  COUNT (DISTINCT CASE
        WHEN number_of_pairs = '3 pairs' THEN
   user_id
        END) AS 'three',
   COUNT (DISTINCT CASE
        WHEN number_of_pairs = '5 pairs' THEN
   user_id
        END) AS 'five'
 FROM home_try_on
 GROUP BY 1
 ORDER BY 1;



--Overall conversion rates by aggregating across all rows
--Compare conversion from quiz?home_try_on and home_try_on?purchase
WITH funnels AS (
SELECT DISTINCT q.user_id,
       h.user_id IS NOT NULL AS 'is_home_try_on',
       h.number_of_pairs,
       p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
  ON q.user_id = h.user_id
LEFT JOIN purchase p
  ON h.user_id = p.user_id
)  
SELECT COUNT (*) AS 'num_users',
       SUM (is_home_try_on) AS 'num_home_try_on',
       SUM (is_purchase) AS 'num_is_purchase',
       ROUND (1.0 * SUM (is_home_try_on) / COUNT (*), 2) AS 'quiz_to_hto',
       ROUND (1.0 * SUM (is_purchase) / SUM (is_home_try_on), 2) AS 'hto_to_purchase'
 FROM funnels;

 
--Calculate the difference in purchase rates between customers who had 3 number_of_pairs with ones who had 5.
WITH funnels AS (
SELECT DISTINCT q.user_id,
       h.user_id IS NOT NULL AS 'is_home_try_on',
       h.number_of_pairs,
       p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
  ON q.user_id = h.user_id
LEFT JOIN purchase p
  ON h.user_id = p.user_id
)  
SELECT number_of_pairs,
       COUNT (*) AS 'num_users',
       SUM (is_home_try_on) AS 'num_home_try_on',
       SUM (is_purchase) AS 'num_is_purchase',
       ROUND (1.0 * SUM (is_home_try_on) / COUNT (*), 2) AS 'quiz_to_hto',
       ROUND (1.0 * SUM (is_purchase) / SUM (is_home_try_on), 2) AS 'hto_to_purchase'
 FROM funnels
 GROUP BY 1;
 
--Calculate the difference in purchase rates between customers who had 3 number_of_pairs with ones who had 5.
--Where home_try_on IS NOT NULL
WITH funnels AS (
SELECT DISTINCT q.user_id,
       h.user_id IS NOT NULL AS 'is_home_try_on',
       h.number_of_pairs,
       p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
  ON q.user_id = h.user_id
LEFT JOIN purchase p
  ON h.user_id = p.user_id
)  
SELECT number_of_pairs,
       COUNT (*) AS 'num_users',
       SUM (is_home_try_on) AS 'num_home_try_on',
       SUM (is_purchase) AS 'num_is_purchase',
       ROUND (1.0 * SUM (is_home_try_on) / COUNT (*), 2) AS 'quiz_to_hto',
       ROUND (1.0 * SUM (is_purchase) / SUM (is_home_try_on), 2) AS     'hto_to_purchase'
 FROM funnels
 WHERE number_of_pairs IS NOT NULL
 GROUP BY 1;
 
-- The most common results of the style quiz
SELECT style,
        COUNT (*) AS'num_styles'
 FROM quiz
 GROUP BY style
 ORDER BY 2 DESC;
 
SELECT fit,
        COUNT (*) AS'num_fits'
 FROM quiz
 GROUP BY fit
 ORDER BY 2 DESC;
 
SELECT shape,
        COUNT (*) AS'num_shapes'
 FROM quiz
 GROUP BY shape
 ORDER BY 2 DESC;
 
SELECT color,
        COUNT (*) AS'num_colors'
 FROM quiz
 GROUP BY color
 ORDER BY 2 DESC;

 
-- the same results are possible if I count the user_id
SELECT color, 
         COUNT (user_id) AS'num_colors'
 FROM quiz
 GROUP BY color
 ORDER BY 2 DESC;
 

--The most common types of purchase made
SELECT product_id,
      model_name,
      style,
      color,
      COUNT (product_id) AS 'num_purchase'
FROM purchase
GROUP BY 1
ORDER BY 5 DESC;
