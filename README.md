# Chinook Business Analysis

## Overview

An end-to-end business analysis of the Chinook music store database using SQL, Python, and Power BI.

The project analyzes revenue, customers, orders, genres, artists, sales trends, and customer segments to identify useful business insights.

## Tools

- SQLite / SQL
- Python
- Pandas
- Matplotlib
- Power BI
- Jupyter Notebook

## Analysis

### SQL
21 queries covering:
- Revenue and order metrics
- Customer spending and purchase frequency
- Revenue by country, year, month, genre, and artist
- Top-selling tracks
- Customer value segments
- Revenue contribution of top customers

### Python
SQL results were loaded into Pandas DataFrames and visualized using Matplotlib, including:
- Revenue by Country
- Top 10 Customers
- Revenue by Genre
- Top Artists
- Monthly Sales Trend
- Yearly Revenue Trend
- Customer Distribution by Country

### Power BI
An interactive dashboard was created with:
- Total Revenue
- Total Orders
- Total Customers
- Average Order Value
- Revenue and sales trend charts
- Top customer, genre, artist, and country analysis
- Country, Year, and Genre slicers

## Files

- `analysis.ipynb` — Python analysis and visualizations
- `analysis.sql` — SQL queries
- `chinook_dashboard.pbix` — Power BI dashboard
- `business_insights.md` — Business findings and recommendations

## Conclusion

The project demonstrates an end-to-end analytics workflow: extracting data with SQL, analyzing and visualizing it with Python, and communicating findings through an interactive Power BI dashboard.
