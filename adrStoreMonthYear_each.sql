# What is the average daily revenue for each store/month/year combination in
# the database? 


SELECT EXTRACT(MONTH from t2.saledate) AS month_num, EXTRACT(YEAR from t2.saledate) AS year_num, store, SUM(t2.amt) AS revenue, COUNT(distinct t2.saledate) AS days,
		revenue/days AS ADR
FROM(SELECT * FROM trnsact 
	WHERE stype='p' AND NOT (EXTRACT(year FROM saledate) = '2005'
		    			AND EXTRACT(month FROM saledate) = '8')) AS t2
GROUP BY month_num, year_num, store
ORDER BY ADR DESC;