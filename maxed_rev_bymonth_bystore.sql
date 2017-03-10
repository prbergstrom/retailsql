# Determine the month of maximum total revenue for each store. Count the
# number of stores whose month of maximum total revenue was in each of the twelve
# months. 

SELECT ranked_data.monthID,
       COUNT(*)                         # counts the rows
 FROM (SELECT DISTINCT EXTRACT(year FROM saledate) as yearID,             # returns 6 columns
              EXTRACT(month FROM saledate) as monthID, 
              CASE WHEN extract(year from saledate) = 2005              
                    AND extract(month from saledate) = 8 THEN 'exclude'
              END as exclude_flag,                # CASE statement in SELECT to create exclude_flag
              SUM(amt) as Total_revenue,
              store as storeID,
              ROW_NUMBER() OVER(PARTITION BY store ORDER BY SUM(amt) DESC) as  sales_rank     # RANKING, partition by store and ordered by revenue
         FROM ua_dillards.trnsact
        WHERE stype='p'
          AND exclude_flag is null                # reference exclude_flag
          AND store ||                            # and STORE-YEAR-MONTH is in the list of S-Y-M's with days gr8r than 20
              EXTRACT(year FROM saledate) ||
              EXTRACT(month FROM saledate) IN
                 (SELECT store ||
                         EXTRACT(year FROM saledate) ||
                         EXTRACT(month FROM saledate)
                    FROM ua_dillards.trnsact
                   GROUP BY store,
                         EXTRACT(year FROM saledate),
                         EXTRACT(month FROM saledate)
                  HAVING COUNT(DISTINCT saledate) >= 20
                  )
         GROUP BY monthID,
                  storeID,
                  yearid
          QUALIFY sales_rank = 12
      ) AS ranked_data
GROUP BY monthid
ORDER BY monthid;