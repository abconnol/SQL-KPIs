SEL/* DataCamp Guided Project: User-centric KPI's

This SQL file will analyze user-centric KPI's for an orders dataset from a fictional food delivery app called "Delivr" */

--Query 1: Registrations per month

--First Order Date = Registration Date

--Number of Registrations per month + running_total

WITH registrations_by_month AS
(SELECT DISTINCT User_id, MONTH(MIN(Order_date)) AS registration_month
FROM PortfolioProject.dbo.DelivrOrders
Group by User_id),

regs AS
(SELECT registration_month, COUNT(DISTINCT User_id) AS number_of_user_regs
FROM registrations_by_month
GROUP BY registration_month)

SELECT registration_month, number_of_user_regs, SUM(number_of_user_regs) OVER (ORDER BY registration_month) AS running_total
FROM regs
GROUP BY registration_month, number_of_user_regs;

--Query 2: Number of monthly active users

WITH months AS (SELECT DISTINCT User_id AS User_id, MONTH(Order_date) AS mo
FROM PortfolioProject.dbo.DelivrOrders)

SELECT mo, COUNT(User_id) AS active_monthly_users
FROM months
GROUP BY mo
ORDER BY mo ASC;


--Query 3: Monthyly active Users Compared to previous month

WITH months AS (SELECT DISTINCT User_id AS User_id, MONTH(Order_date) AS mo
FROM PortfolioProject.dbo.DelivrOrders),

totals AS (SELECT mo, COUNT(User_id) AS active_monthly_users
FROM months
GROUP BY mo)

SELECT mo, active_monthly_users, LAG(active_monthly_users,1,0) OVER (ORDER BY mo) AS prior_month
FROM totals;

--Query 4: Percent increase or decrease from prior month

WITH months AS (SELECT DISTINCT User_id AS User_id, MONTH(Order_date) AS mo
FROM PortfolioProject.dbo.DelivrOrders),

totals AS (SELECT mo, COUNT(User_id) AS active_monthly_users
FROM months
GROUP BY mo),

lag_function AS(SELECT mo, active_monthly_users, LAG(active_monthly_users,1,0) OVER (ORDER BY mo) AS prior_month
FROM totals)

SELECT mo, active_monthly_users, prior_month, ROUND(cast(active_monthly_users - prior_month as float)/(active_monthly_users)*100,2) AS percent_increase
FROM lag_function; 








