# Compare the average daily revenues of the stores with the highest median
# msa_income and the lowest median msa_income. In what city and state were these stores,
# and which store had a higher average daily revenue?

# Highest
SELECT top1.store, top1.city, top1.state, SUM(stores.revenue) AS group_revenue, SUM(stores.days) AS store_days, group_revenue/store_days AS ADR 
FROM(SELECT t.store AS storenum, m.msa_high AS el, SUM(t.amt) AS revenue, COUNT(distinct t.saledate) AS days
			FROM trnsact t JOIN store_msa m ON t.store=m.store
			WHERE t.stype='p' AND (EXTRACT(MONTH from t.saledate)<>8 AND EXTRACT(YEAR from t.saledate)<>2005)
			GROUP BY storenum, el
			HAVING days >=20) AS stores JOIN (
											SELECT TOP 1 store, city, state
											FROM store_msa
											ORDER BY msa_income DESC) AS top1 ON stores.storenum=top1.store
GROUP BY top1.store, top1.city, top1.state;

#Lowest
SELECT top1.store, top1.city, top1.state, SUM(stores.revenue) AS group_revenue, SUM(stores.days) AS store_days, group_revenue/store_days AS ADR 
FROM(SELECT t.store AS storenum, m.msa_high AS el, SUM(t.amt) AS revenue, COUNT(distinct t.saledate) AS days
			FROM trnsact t JOIN store_msa m ON t.store=m.store
			WHERE t.stype='p' AND (EXTRACT(MONTH from t.saledate)<>8 AND EXTRACT(YEAR from t.saledate)<>2005)
			GROUP BY storenum, el
			HAVING days >=20) AS stores JOIN (
											SELECT TOP 1 store, city, state
											FROM store_msa
											ORDER BY msa_income ASC) AS top1 ON stores.storenum=top1.store
GROUP BY top1.store, top1.city, top1.state;