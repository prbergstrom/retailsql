# Determine which sku had the greatest total sales during the combined summer months of June, July, and August.

SELECT sku,
		SUM(CASE WHEN EXTRACT(MONTH from saledate)=6 THEN amt END) AS june_sales,
		SUM(CASE WHEN EXTRACT(MONTH from saledate)=7 THEN amt END) AS july_sales,
		SUM(CASE WHEN EXTRACT(MONTH from saledate)=8 THEN amt END) AS august_sales,
		june_sales+july_sales+august_sales AS total
FROM trnsact
WHERE stype='p'
GROUP BY sku
ORDER BY total DESC;