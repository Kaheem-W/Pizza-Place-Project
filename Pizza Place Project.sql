--1. How many customers do we have each day?
SELECT [date], COUNT(order_id) AS "number_of_orders"
FROM [Pizza_Place].[dbo].[orders$]
GROUP BY [date]
ORDER BY [date]
--Average number of orders: 59.6

--day of the week
SELECT [day_of_week], COUNT(order_id) AS "number_of_orders"
FROM [Pizza_Place].[dbo].[orders$]
GROUP BY [day_of_week]
ORDER BY number_of_orders

--Are there any peak hours?
SELECT [hour], COUNT(order_id) AS "number_of_orders"
FROM [Pizza_Place].[dbo].[orders$]
GROUP BY [hour]
ORDER BY number_of_orders DESC
--12pm to 1pm and 4pm to 7pm


--2. How many pizzas are typically in an order?
SELECT [quantity], COUNT(quantity) AS "number_of_pizzas_ordered"
FROM [Pizza_Place].[dbo].[order_details$]
GROUP BY [quantity]
ORDER BY [quantity]

--Do we have any bestsellers?
SELECT [pizza_id], COUNT(pizza_id) AS "number_of_pizzas"
FROM [Pizza_Place].[dbo].[order_details$]
GROUP BY [pizza_id]
ORDER BY number_of_pizzas DESC

--3. How much money did we make this year?
SELECT ROUND(SUM(od.quantity * pz.price), 2) AS "Grand_Total"
FROM [Pizza_Place].[dbo].[order_details$] od
INNER JOIN [Pizza_Place].[dbo].[pizzas$] pz
ON od.pizza_id = pz.pizza_id

--Money for each pizza type
SELECT od.pizza_id, ROUND(SUM(od.quantity * pz.price), 2) AS "Pizza_Total"
FROM [Pizza_Place].[dbo].[order_details$] od
INNER JOIN [Pizza_Place].[dbo].[pizzas$] pz
ON od.pizza_id = pz.pizza_id
GROUP BY od.pizza_id
ORDER BY Pizza_Total DESC

--Can we identify any seasonality in the sales?
SELECT o.month, ROUND(SUM(od.quantity * pz.price), 2) AS "Monthly_Total"
FROM [Pizza_Place].[dbo].[order_details$] od
INNER JOIN [Pizza_Place].[dbo].[pizzas$] pz
ON od.pizza_id = pz.pizza_id
INNER JOIN [Pizza_Place].[dbo].[orders$] o
ON o.order_id = od.order_id
GROUP BY o.month
ORDER BY CASE o.month
	when 'January' then 1
	when 'February' then 2
	when 'March' then 3
	when 'April' then 4
	when 'May' then 5
	when 'June' then 6
	when 'July' then 7
	when 'August' then 8
	when 'September' then 9
	when 'October' then 10
	when 'November' then 11
	when 'December' then 12
end

--See which months have the highest sales
SELECT o.month, ROUND(SUM(od.quantity * pz.price), 2) AS "Monthly_Total"
FROM [Pizza_Place].[dbo].[order_details$] od
INNER JOIN [Pizza_Place].[dbo].[pizzas$] pz
ON od.pizza_id = pz.pizza_id
INNER JOIN [Pizza_Place].[dbo].[orders$] o
ON o.order_id = od.order_id
GROUP BY o.month
ORDER BY Monthly_Total DESC


--4. Are there any pizzas we should take off the menu, or any promotions we could leverage?
--pizzas available for promotions
SELECT TOP (10) od.pizza_id, ROUND(SUM(od.quantity * pz.price), 2) AS "Pizza_Total"
FROM [Pizza_Place].[dbo].[order_details$] od
INNER JOIN [Pizza_Place].[dbo].[pizzas$] pz
ON od.pizza_id = pz.pizza_id
GROUP BY od.pizza_id
ORDER BY Pizza_Total DESC

--pizzas to take off the menu
SELECT TOP (10) od.pizza_id, ROUND(SUM(od.quantity * pz.price), 2) AS "Pizza_Total"
FROM [Pizza_Place].[dbo].[order_details$] od
INNER JOIN [Pizza_Place].[dbo].[pizzas$] pz
ON od.pizza_id = pz.pizza_id
GROUP BY od.pizza_id
ORDER BY Pizza_Total