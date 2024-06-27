WITH distinct_visitors AS (
	
SELECT
        	d.variation_id,
        	COUNT(DISTINCT d.visitor_id) AS distinct_visitor_count
    	FROM
        	decisions d
    	GROUP BY
        	d.variation_id
),

signups AS (
SELECT 
		c. variation_id,
    		COUNT(DISTINCT c.visitor_id) AS signup_count
FROM 
		conversions c
where 
c.event_name = 'signUp'
group by
	c.variation_id
)

SELECT
    dv.variation_id,
    dv.distinct_visitor_count,
    ms.signup_count,
    (ms.signup_count * 1.0 / dv.distinct_visitor_count) AS conversion_rate
FROM
    distinct_visitors dv
JOIN
    signups ms ON dv.variation_id = ms.variation_id
;
