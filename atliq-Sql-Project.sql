-- Top 3 products in each division with the highest sold quantity (2021):
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
