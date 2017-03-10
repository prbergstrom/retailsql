# What is the brand of the sku with the greatest standard deviation in sprice?
# Only examine skus that have been part of over 100 transactions.

SELECT top1.sku, s.brand, top1.StdDev
FROM(
	SELECT TOP 1 sku, COUNT(sku) AS SkuCount, STDDEV_SAMP(sprice) AS StdDev
	FROM trnsact t
	GROUP BY sku
	WHERE t.stype='p' AND NOT (EXTRACT(year FROM saledate) = '2005'
		    			AND EXTRACT(month FROM saledate) = '8')
	HAVING SkuCount > 100
	ORDER BY StdDev DESC
	) AS top1 
	JOIN skuinfo s ON top1.sku=s.sku;

# Examine all the transactions for the sku with the greatest standard deviation in
# sprice, but only consider skus that are part of more than 100 transactions.

SELECT *
FROM(SELECT TOP 1 sku, COUNT(sku) AS SkuCount, STDDEV_SAMP(sprice) AS StdDev
	FROM trnsact t
	GROUP BY sku
	WHERE t.stype='p' AND (EXTRACT(MONTH from t.saledate)<>8 AND EXTRACT(YEAR from t.saledate)<>2005)
	HAVING SkuCount > 100
	ORDER BY StdDev DESC) AS top1 JOIN trnsact ON top1.sku=trnsact.sku
WHERE trnsact.sku=top1.sku;