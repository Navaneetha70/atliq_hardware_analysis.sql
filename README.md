# atliq_hardware_analysis.sql
## Overview

This project involves analyzing various tables from the `gdb0041` (atliq_hardware_db) database to generate insights. The dataset includes information about customers, products, sales, manufacturing costs, and more. The analysis focuses on performing various SQL queries to extract insights such as product counts, sales data, fiscal year comparisons, and more.

## Tables Involved

1. **dim_customer**: Contains customer-related data.
2. **dim_product**: Contains product-related data.
3. **fact_gross_price**: Contains gross price information for each product.
4. **fact_manufacturing_cost**: Contains the manufacturing cost for each product.
5. **fact_pre_invoice_deductions**: Contains pre-invoice deductions for each product.
6. **fact_sales_monthly**: Contains monthly sales data for each product.

## Key Analysis Requests

The project includes queries to answer specific business questions. Some of the main tasks include:

1. Identifying markets in the APAC region where the customer "Atliq Exclusive" operates.
2. Calculating the percentage change in unique products between 2020 and 2021.
3. Reporting the unique product counts for each product segment.
4. Identifying the segment with the most increase in unique products from 2020 to 2021.
5. Identifying products with the highest and lowest manufacturing costs.
6. Analyzing pre-invoice discount percentages for the top customers in the Indian market in 2021.
7. Generating a report of gross sales amount for the customer "Atliq Exclusive" for each month.
8. Identifying which quarter in 2020 had the highest total sold quantity.
9. Determining the channel that contributed the most to gross sales in 2021.
10. Finding the top 3 products in each division based on total sold quantity in 2021.

## Database Schema

Below is a brief description of the columns for each table used in this analysis:

### `dim_customer` table:
- **customer_code**: Unique identifier for each customer.
- **customer**: Customer name.
- **platform**: E-commerce or Brick & Mortar.
- **channel**: Distribution methods like Retailers, Direct, Distributors.
- **market**: Country where the customer operates.
- **region**: Geographic region like APAC, EU, NA, LATAM.
- **sub_zone**: Specific sub-region within the larger region.

### `dim_product` table:
- **product_code**: Unique identifier for each product.
- **division**: Product division (e.g., Peripherals, Network, Storage).
- **segment**: Product segment (e.g., Laptop, Desktop, Monitor).
- **category**: Subcategory of the product.
- **product**: Product name.
- **variant**: Product variant (e.g., Standard, Premium).

### `fact_gross_price` table:
- **product_code**: Unique identifier for each product.
- **fiscal_year**: Year of the product sale (e.g., 2020, 2021).
- **gross_price**: Original price of the product before deductions.

### `fact_manufacturing_cost` table:
- **product_code**: Unique identifier for each product.
- **cost_year**: Year of manufacturing.
- **manufacturing_cost**: Total cost to manufacture the product.

### `fact_pre_invoice_deductions` table:
- **customer_code**: Unique identifier for each customer.
- **fiscal_year**: Year of the sale.
- **pre_invoice_discount_pct**: Pre-invoice discount percentage.

### `fact_sales_monthly` table:
- **date**: Date of sale.
- **product_code**: Unique identifier for each product.
- **customer_code**: Unique identifier for each customer.
- **sold_quantity**: Quantity of product sold.
- **fiscal_year**: Year of the sale.


