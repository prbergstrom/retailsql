# What is the average daily revenue brought in by stores in areas of
# high, medium, or low levels of high school education?

SELECT (CASE 
		WHEN m.msa_high BETWEEN 50 AND 60 THEN 'low'
		WHEN m.msa_high BETWEEN 60.01 AND 70 THEN 'medium'
		WHEN m.msa_high > 70 THEN 'high'
		END) AS education_level, SUM(stores.revenue) AS group_revenue, SUM(stores.days) AS store_days, group_revenue/store_days AS ADR 
FROM(SELECT store, SUM(amt) AS revenue, COUNT(distinct saledate) AS days
			FROM trnsact 
			WHERE stype='p' AND (EXTRACT(MONTH from saledate)<>8 AND EXTRACT(YEAR from saledate)<>2005)
			GROUP BY store
			HAVING days >=20) AS stores JOIN store_msa m ON stores.store=m.store
GROUP BY education_level
ORDER BY ADR DESC;
