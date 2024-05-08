--1.  Which agents had the highest number of won deals, and what was the total value of the deals?

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

-- 2. How many deals were won each month?

select month, year, deals_won from
(select extract(month from engage_date) as month_num, max(to_char(engage_date, 'Month')) as month,
 extract(year from engage_date) as year, 
 count(*) as deals_won
from
(select * from sales_pipeline where deal_stage in ('Won','Lost'))
where deal_stage = 'Won'
group by month_num, year
order by year, month_num)

-- 3. Which accounts had the highest number of won deals?

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

-- 4. How many deals were in each deal stage?

select 
	deal_stage, 
	count(*) as no_of_deals
from sales_pipeline
group by deal_stage
order by no_of_deals desc

-- 5. What products had the highest win rates?

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

-- 6. What teams had the most won deals?

select manager, deals_won, to_char(total_value, 'l9,999,999') from
(select count(*) as deals_won, sum(close_value) as total_value,
 (select manager from sales_teams where sales_pipeline.sales_agent=sales_teams.sales_agent)
from sales_pipeline
where deal_stage='Won'
group by manager)
order by deals_won desc

-- 7. Which accounts had the most lost deals?

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

-- 8. Which teams had the most lost deals?

select manager, deals_lost from
(select count(*) as deals_lost,
 (select manager from sales_teams where sales_pipeline.sales_agent=sales_teams.sales_agent)
from sales_pipeline
where deal_stage='Lost'
group by manager)
order by deals_lost desc

-- 9. Which products had the most lost deals?

select product, deals_lost, series from
	(select product, count(*) as deals_lost,
	(select series from products where sales_pipeline.product=products.product)
	from sales_pipeline 
	where deal_stage='Lost'
	group by product)
order by deals_lost desc	

-- 10. Total revenue from won deals

select to_char(sum(close_value), 'l999,999,999') as total_revenue
from sales_pipeline