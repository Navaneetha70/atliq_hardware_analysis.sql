-- Request 1: List of markets where "Atliq Exclusive" operates in APAC
SELECT DISTINCT market
FROM dim_customer
WHERE customer = 'Atliq Exclusive'
AND region = 'APAC';
-- Request 2: Percentage of Unique Product Increase (2021 vs. 2020)
WITH unique_counts AS (
    SELECT fiscal_year, COUNT(DISTINCT product_code) AS unique_products
    FROM fact_gross_price
    WHERE fiscal_year IN (2020, 2021)
    GROUP BY fiscal_year
)
SELECT 
    (SELECT unique_products FROM unique_counts WHERE fiscal_year = 2020) AS unique_products_2020,
    (SELECT unique_products FROM unique_counts WHERE fiscal_year = 2021) AS unique_products_2021,
    ROUND(100.0 * ((SELECT unique_products FROM unique_counts WHERE fiscal_year = 2021) - 
    (SELECT unique_products FROM unique_counts WHERE fiscal_year = 2020)) / 
    (SELECT unique_products FROM unique_counts WHERE fiscal_year = 2020), 2) AS percentage_chg;
-- Percentage of Unique Product Increase (2021 vs. 2020)
SELECT 
    t1.unique_products_2020,
    t2.unique_products_2021,
    ROUND(100.0 * (t2.unique_products_2021 - t1.unique_products_2020) / t1.unique_products_2020, 2) AS percentage_chg
FROM 
    (SELECT COUNT(DISTINCT product_code) AS unique_products_2020
     FROM fact_gross_price WHERE fiscal_year = 2020) t1,
    (SELECT COUNT(DISTINCT product_code) AS unique_products_2021
     FROM fact_gross_price WHERE fiscal_year = 2021) t2;
 -- Percentage of Unique Product Increase for 4 Fiscal Years (2020–2023)
SELECT 
    t1.unique_products_2020,
    t2.unique_products_2021,
    t3.unique_products_2022,
    t4.unique_products_2023,
    ROUND(100.0 * (t2.unique_products_2021 - t1.unique_products_2020) / t1.unique_products_2020, 2) AS percentage_chg_2021,
    ROUND(100.0 * (t3.unique_products_2022 - t2.unique_products_2021) / t2.unique_products_2021, 2) AS percentage_chg_2022,
    ROUND(100.0 * (t4.unique_products_2023 - t3.unique_products_2022) / t3.unique_products_2022, 2) AS percentage_chg_2023
FROM 
    (SELECT COUNT(DISTINCT product_code) AS unique_products_2020 FROM fact_gross_price WHERE fiscal_year = 2020) t1,
    (SELECT COUNT(DISTINCT product_code) AS unique_products_2021 FROM fact_gross_price WHERE fiscal_year = 2021) t2,
    (SELECT COUNT(DISTINCT product_code) AS unique_products_2022 FROM fact_gross_price WHERE fiscal_year = 2022) t3,
    (SELECT COUNT(DISTINCT product_code) AS unique_products_2023 FROM fact_gross_price WHERE fiscal_year = 2023) t4;
 --Products with highest and lowest manufacturing costs:
(SELECT product_code, product, manufacturing_cost 
 FROM fact_manufacturing_cost 
 JOIN dim_product USING(product_code) 
 ORDER BY manufacturing_cost DESC LIMIT 1)
UNION
(SELECT product_code, product, manufacturing_cost 
 FROM fact_manufacturing_cost 
 JOIN dim_product USING(product_code) 
 ORDER BY manufacturing_cost ASC LIMIT 1);
-- Top 5 customers with highest pre-invoice discount percentage in India (2021):
SELECT customer_code, customer, ROUND(AVG(pre_invoice_discount_pct), 2) AS average_discount_percentage
FROM fact_pre_invoice_deductions 
JOIN dim_customer USING(customer_code)
WHERE fiscal_year = 2021 AND market = 'India'
GROUP BY customer_code, customer
ORDER BY average_discount_percentage DESC
LIMIT 5;
-- Gross sales report for "Atliq Exclusive" per month:
SELECT 
    EXTRACT(MONTH FROM date) AS Month, 
    EXTRACT(YEAR FROM date) AS Year, 
    SUM(sold_quantity * gross_price) AS Gross_sales_Amount
FROM fact_sales_monthly 
JOIN fact_gross_price USING(product_code)
JOIN dim_customer USING(customer_code)
WHERE customer = 'Atliq Exclusive'
GROUP BY Month, Year
ORDER BY Year, Month;
-- Quarter of 2020 with the highest total sold quantity:
SELECT 
    CASE 
        WHEN EXTRACT(MONTH FROM date) IN (1,2,3) THEN 'Q1'
        WHEN EXTRACT(MONTH FROM date) IN (4,5,6) THEN 'Q2'
        WHEN EXTRACT(MONTH FROM date) IN (7,8,9) THEN 'Q3'
        ELSE 'Q4'
    END AS Quarter,
    SUM(sold_quantity) AS total_sold_quantity
FROM fact_sales_monthly
WHERE EXTRACT(YEAR FROM date) = 2020
GROUP BY Quarter
ORDER BY total_sold_quantity DESC;
--Channel that contributed the most gross sales in 2021:
WITH total_sales AS (
    SELECT channel, SUM(sold_quantity * gross_price) / 1000000 AS gross_sales_mln
    FROM fact_sales_monthly 
    JOIN fact_gross_price USING(product_code)
    JOIN dim_customer USING(customer_code)
    WHERE fiscal_year = 2021
    GROUP BY channel
)
SELECT channel, gross_sales_mln, 
       ROUND((gross_sales_mln / SUM(gross_sales_mln) OVER()) * 100, 2) AS percentage
FROM total_sales
ORDER BY gross_sales_mln DESC;
--Top 3 products in each division with the highest sold quantity (2021):
SELECT 
    dp.division,
    fs.product_code,
    dp.product,
    fs.sold_quantity AS total_sold_quantity,
    RANK() OVER (PARTITION BY dp.division ORDER BY fs.sold_quantity DESC) AS rank_order
FROM fact_sales_monthly fs
JOIN dim_product dp ON fs.product_code = dp.product_code
JOIN fact_gross_price fg ON fs.product_code = fg.product_code  
WHERE fg.fiscal_year = 2021 
ORDER BY dp.division, rank_order;


