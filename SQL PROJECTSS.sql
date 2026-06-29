-- Task 1: Create an ER diagram for the Amazon Fresh database to understand the relationships between tables (e.g., Customers, Products, Orders).
-- Task 2: Identify the primary keys and foreign keys for each table and describe their relationships.
-- Task 3: Write a query to:
-- Retrieve all customers from a specific city.
select *  from amazon.customers
where city = "Meganfort";

-- Fetch all products under the "Fruits" category.
select * from amazon.products;
select ProductName,Category from amazon.products
where Category = "Fruits";

-- Task 4: Write DDL statements to recreate the Customers table with the following constraints:
-- CustomerID as the primary key
alter table amazon.customers
add primary key (CustomerId);

-- Ensure Age cannot be null and must be greater than 18.
select Age from amazon.customers
where age >18;

-- Add a unique constraint for Name.
alter table amazon.customers 
add unique index `Namess_UNIQUE` (`Namess` asc) visible;

-- Task 5: Insert 3 new rows into the Products table using INSERT statements.
insert into amazon.products values
("4","table","wood","sub-wood",111,123,"100"),
("5","fan","electronics","sub-electronics",222,234,"101"),
("6","car","motor","sub-motor",333,345,"102");
select * from amazon.products;

-- Task 6: Update the stock quantity of a product where ProductID matches a specific ID.
select *  from amazon.products;

update amazon.products
set StockQuantity = 777
where ProductName = "table";

-- Task 7: Delete a supplier from the Suppliers table where their city matches a specific value.
delete from amazon.suppliers
where city ="South Debra";
select * from amazon.suppliers;


-- Task 8: Use SQL constraints to:
-- Add a CHECK constraint to ensure that ratings in the Reviews table are between 1 and 5.
alter table amazon.reviews
add constraint check (Rating between 1 and 5);


--  Add a DEFAULT constraint for the PrimeMember column in the Customers table (default value: "No").
alter  table amazon.customers
alter PrimeMember set default "No";


-- Task 9: Write queries using:
--  WHERE clause to find orders placed after 2024-01-01.
select * from amazon.orders
where OrderDate > "2024-01-01";


-- HAVING clause to list products with average ratings greater than 4.
select p.ProductName,r.ProductId,avg(Rating) as avg_rating from amazon.reviews as r
join amazon.products as p
on p.ProductID = r.ProductID
group by p.ProductName,r.ProductID
having avg_rating > 4
order by avg_rating asc;

-- GROUP BY and ORDER BY clauses to rank products by total sales.
select p.ProductName,p.ProductID,sum(o.Quantity * o.UnitPrice - o.Discount) as total_sales from amazon.order_details as o
join amazon.products as p
on p.ProductID = o.ProductID
group by p.ProductName,p.ProductID
order by total_sales desc;


-- Task 10:
-- Amazon Fresh wants to identify top customers based on their total spending. We will:
-- 1. Calculate each customer's total spending.
select c.Namess,o.CustomerId,sum(o.OrderAmount + o.DeliveryFee - DiscountApplied) as total_spending from amazon.orders as o
join amazon.customers as c
on c.CustomerID =o.CustomerID
group by c.Namess,o.CustomerID
Order by total_spending desc;

-- 2. Rank customers based on their spending.
select c.Namess,o.CustomerId,sum(o.OrderAmount + o.Deliveryfee - DiscountApplied) as total_spendings,
dense_rank() over(order by sum(o.OrderAmount + o.Deliveryfee - DiscountApplied)desc) as rankk from amazon.orders as o
join amazon.customers as c
on c.CustomerID = o.CustomerID
group by c.Namess,o.CustomerID;

 
-- 3. Identify customers who have spent more than ₹5,000.
select c.Namess,o.CustomerId,sum(o.OrderAmount + o.DeliveryFee - DiscountApplied) as total_spending from amazon.orders as o
join amazon.customers as c
on c.CustomerID =o.CustomerID
group by c.Namess,o.CustomerID
having total_spending > 5000
order by total_spending asc;


-- Task 11: Use SQL to:
-- Join the Orders and OrderDetails tables to calculate total revenue per order.
select * from amazon.Orders;
select * from amazon.Order_Details;
select o.OrderId,sum(o2.Quantity * o2.UnitPrice - o2.Discount) as revenue from amazon.orders as o
join amazon.order_details as o2
on o.OrderId = o2.OrderID
group by o.OrderID
order by revenue desc;

-- Identify customers who placed the most orders in a specific time period.
select  * from amazon.orders;
select c.Namess,c.CustomerId,o.OrderDate,count(o.OrderId) as total_orders from amazon.orders as o
join amazon.customers as c
on c.CustomerID =o.CustomerID
where OrderDate ="2025-01-01"
group by c.Namess,c.CustomerID
order by total_orders desc;

-- Find the supplier with the most products in stock.
select * from amazon.suppliers;
select * from amazon.products;

select SupplierId,sum(StockQuantity) as total from amazon.products
group by SupplierID
order by total desc;

-- Task 12: Normalize the Products table to 3NF:
-- Separate product categories and subcategories into a new table.
create table amazon.ProductCategory
(special_id varchar(100),
product_id varchar(100),
product_category varchar(100),
package_color varchar(100));

select * from amazon.ProductCategory;
select * from amazon.products;

insert into amazon.ProductCategory values
("1","0006853b-74cb-44a2-91ed-699aa31c5b5b","Bakery","black"),
("2","0219aafa-5dbc-4d92-acd9-8a78b4158651","Dairy","white"),
("3","0297061c-1241-4540-ac99-ac6a44fa507e","Backery","red"),
("4","02c7c358-da33-4586-8e32-5e459b7394fc","Snacks","green"),
("5","030ff542-d5f3-4387-9654-90ae0e38702c","Meat","maroon"),
("6","04c600c0-b84f-4de8-a71e-205528c610eb","Fruits","peach"),
("7","04d0f4ba-ccde-47d9-b846-ad470b5048fc","Snacks","blue"),
("8","05765892-c750-44cc-96e2-31fa53d42cb2","Vegetables","saffron"),
("9","059541ff-a15f-4d6d-8a5b-860bbae25715","Snacks","yellow"),
("10","0628599d-2f51-46a8-ab5e-7e54a383ca44","Vegetables","grey");

create table amazon.SubCategory
(sub_category_id varchar(100),
special_id varchar(100),
product_id varchar(100),
sub_category varchar(100));

insert into amazon.SubCategory values
("1a","1","0006853b-74cb-44a2-91ed-699aa31c5b5b","sub-bakery"),
("2a","2","0219aafa-5dbc-4d92-acd9-8a78b4158651","sub-dairy"),
("3a","3","0297061c-1241-4540-ac99-ac6a44fa507e","sub-bakery"),
("4a","4","02c7c358-da33-4586-8e32-5e459b7394fc","sub-snacks"),
("5a","5","030ff542-d5f3-4387-9654-90ae0e38702c","sub-meat"),
("6a","6","04c600c0-b84f-4de8-a71e-205528c610eb","sub-fruits"),
("7a","7","04d0f4ba-ccde-47d9-b846-ad470b5048fc","sub-snacks"),
("8a","8","05765892-c750-44cc-96e2-31fa53d42cb2","sub-vegetables"),
("9a","9","059541ff-a15f-4d6d-8a5b-860bbae25715","sub-snacks"),
("10a","10","0628599d-2f51-46a8-ab5e-7e54a383ca44","sub-vegetables");

select * from amazon.productcategory;
select * from amazon.SubCategory;
-- Create foreign keys to maintain relationships.
-- relationship created


-- Task 13: Write a subquery to:
-- Identify the top 3 products based on sales revenue.
select * from amazon.order_details;
select p.ProductId,p.ProductName,sum(o.Quantity * o.UnitPrice - o.Discount) as total_revenue from amazon.order_details as o
join amazon.products as p
on p.ProductId = o.ProductId
group by p.ProductID,p.ProductName
order by total_revenue desc
limit 3;

-- Find customers who haven’t placed any orders yet.
select * from amazon.customers;
select *  from amazon.orders;

select c.Namess,o.CustomerId from amazon.orders as o
join amazon.customers as c
on c.CustomerID = o.CustomerID
where o.CustomerID is null;

-- Task 14: Provide actionable insights:
-- Which cities have the highest concentration of Prime members?
select City,count(PrimeMember) from amazon.customers
where PrimeMember ="Yes"
group by City
order by count(Primemember) desc
limit 1;
-- What are the top 3 most frequently ordered categories?
select Category,count(Category) as total_quantity_ordered from amazon.products
group by Category
order by total_quantity_ordered desc
limit 1 ;

