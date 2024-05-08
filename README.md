# CRM SALES OPPORTUNITIES ANALYSIS
## PROJECT OVERVIEW
This project was done to analyze the effectiveness of the CRM strategy adopted by this company, a seller of computer hardware. The analysis was done using a B2B sales pipeline data. CRM (Customer Relationship Management) is the aspect of business involving how a company manages its relationships and interactions with customers and potential customers. This project focuses on analyzing how successful this company was in closing sales with other companies – it is a Business to Business (B2B) analysis.
## DATA SOURCES
## TOOLS USED
-	Microsoft Excel – Data cleaning, inspection and preparation
-	Postgres (SQL) – Data Analysis
-	Tableau – Data Visualization
## PROJECT QUESTIONS
1.  Which agents had the highest number of won deals, and what was the total value of the deals?
 2. How many deals were won each month?
3. Which accounts had the highest number of won deals?
 4. How many deals were in each deal stage?
 5. What products had the highest win rates?
6. What teams had the most won deals?
7. Which accounts had the most lost deals?
 8. Which teams had the most lost deals?
 9. Which products had the most lost deals?
10. What was the total revenue from won deals?

## DATA CLEANING/PREPARATION
The data was contained in 4 tables, and relevant cleaning and transformation techniques had to be applied to prepare the data for our analysis.
-	The data was inspected to ensure the relevant fields or columns were available.
-	Searching for and handling of duplicate values.
-	Null values were handled. However some null values were left in the close value field of the sales pipeline table. This is because deals which were still in the engaging or prospecting stages did not have any close value, as the deal had not been completed.
-	The process also involved ensuring that the fields had the correct data types which would suit the analysis.
## DATA ANALYSIS
The data was then imported into the Postgresql server. Using create commands, I created tables and columns for the 4 tables and imported the elements afterwards. After this, I began my analysis of the data by exploring it. Tasks done include:
-	Identifying the agents with the highest number of deals and the value of the deals:
```sql

select 
	a.sales_agent,
	a.deals_won,
	a.total_value,
	b.manager,
	b.regional_office
from
(select sales_agent, count(*) as deals_won, to_char(sum(close_value),'l9,999,999') as total_value
from sales_pipeline
where deal_stage = 'Won'
group by sales_agent) as a
inner join sales_teams as b
on a.sales_agent=b.sales_agent
order by deals_won desc
```
-	Identifying the number of won deals in each month:
``` sql
select month, year, deals_won from
(select extract(month from engage_date) as month_num, max(to_char(engage_date, 'Month')) as month,
 extract(year from engage_date) as year, 
 count(*) as deals_won
from
(select * from sales_pipeline where deal_stage in ('Won','Lost'))
where deal_stage = 'Won'
group by month_num, year
order by year, month_num)
```
-	Discovering which accounts had the highest number of won deals
```sql

select
	a.account,
	a.deals_won,
	a.total_value,
	b.sector,
	b.year_established,
	b.office_location
from
(select account, count(*) as deals_won, to_char(sum(close_value), 'l999,999') as total_value
 from sales_pipeline
 where deal_stage='Won'
 group by account) as a
 right join accounts as b
on a.account=b.account
order by deals_won desc
```
-	Identifying how many deals were in each stage:
```sql
select 
	deal_stage, 
	count(*) as no_of_deals
from sales_pipeline
group by deal_stage
order by no_of_deals desc
```

-	Finding which products had the highest win rates:
```sql
select 
	a.product,
	a.deals_won,
	a.total_value,
	b.series
from
	(select product, count(*) as deals_won, to_char(sum(close_value), 'l9,999,999') as total_value
	 from sales_pipeline
	 where deal_stage='Won'
	 group by product) as a
inner join products as b
on a.product=b.product
order by deals_won desc
```
-	Identifying which teams/managers won the most deals:
```sql
select manager, deals_won, to_char(total_value, 'l9,999,999') from
(select count(*) as deals_won, sum(close_value) as total_value,
 (select manager from sales_teams where sales_pipeline.sales_agent=sales_teams.sales_agent)
from sales_pipeline
where deal_stage='Won'
group by manager)
order by deals_won desc
```
-	Discovering which accounts had the most lost deals:
```sql
select
	a.account,
	a.deals_lost,
	b.sector,
	b.year_established,
	b.office_location
from
(select account, count(*) as deals_lost
 from sales_pipeline
 where deal_stage='Lost'
 group by account) as a
 right join accounts as b
on a.account=b.account
order by deals_lost desc
```
-	Discovering which teams had the most lost deals:
```sql
select manager, deals_lost from
(select count(*) as deals_lost,
 (select manager from sales_teams where sales_pipeline.sales_agent=sales_teams.sales_agent)
from sales_pipeline
where deal_stage='Lost'
group by manager)
order by deals_lost desc
```
-	Identifying which products had the highest loss rates:
```sql
select product, deals_lost, series from
	(select product, count(*) as deals_lost,
	(select series from products where sales_pipeline.product=products.product)
	from sales_pipeline 
	where deal_stage='Lost'
	group by product)
order by deals_lost desc	
```
-	Total revenue from won deals:
```sql
select to_char(sum(close_value), 'l999,999,999') as total_revenue
from sales_pipeline
```

## Results/Findings:
-	Kan-code account/company had the highest number of won deals. This means that the computer hardware supplier closed the most successful deals with Kan-code.
-	GTX Basic, with 915 won deals, was the product with the highest win rate. It was followed by MG Special with 793 won deals and MG Advanced with 654 won deals.
-	Melvin Marxen was the manager with the most won deals with a total of 882 won deals. He was followed by Summer Sewald and Dustin Brinkmann with 828 and 747 won deals respectively.
-	With 82 lost deals, Hottechi was the company with the most lost deals, followed by Kan-code with 72 lost deals and Konex with 63 lost deals.
-	Melvin Marxen, Summer Sewald, and Dustin Brinkmann, with 536, 459 and 439 lost deals respectively, were the managers with the most lost deals, as there were the managers with the most won deals also.
-	GTX Basic had 521 lost deals, and was the product with the highest lost deals. It was followed by MG Advanced and MG Special, both with 430 lost deals.
-	Deal numbers were down in both the fourth quarter of 2016 and that of 2017.
## RECOMMENDATIONS
-	The company needs adopt better strategies to maximize its wins and minimize its losses. It was discovered that products, managers, and accounts with high win rates also had high loss rates, indicating that much effort had to be put in to achieve results, and this may not be sustainable for the company.
-	Incentives should be given to sales agents and managers during the fourth quarter of each year as it seems deal rates are down during this time. This will incentivize them to achieve more.


