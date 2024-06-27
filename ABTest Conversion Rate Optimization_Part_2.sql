-- Calculate purchasing behavior metrics for each variation

WITH sign_up_count AS (
SELECT 
c.variation_id,
    	COUNT(DISTINCT c.visitor_id) AS signup_count
FROM 
	conversions c
where c.event_name = 'signUp'
group by
	c.variation_id
),

First_purchaser_count AS (
SELECT
    c.variation_id,
COUNT(distinct CASE WHEN ad.first_purchase_value !=0 and 
ad.sign_up_method = 'manual' THEN 
 	ad.account_id END) AS first_purchasers,
SUM(CASE WHEN ad.sign_up_method = 'manual' and 
ad.first_purchase_value !=0 THEN 
ad.first_purchase_value END) AS sum_first_purchase_value
FROM
    	account_details ad
JOIN (
    	SELECT 
distinct user_account_id, 
    		variation_id
    	FROM 
conversions
	) c ON ad.account_id = c.user_account_id
GROUP BY
    	c.variation_id
)    

SELECT
    su.variation_id,
    su.signup_count,
    pu.first_purchasers,
    pu.sum_first_purchase_value,
    (pu.first_purchasers * 1.0 / su.signup_count) AS purchase_rate
FROM
    sign_up_count su
JOIN
    First_purchaser_count pu ON su.variation_id = pu.variation_id
;
