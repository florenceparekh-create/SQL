#1.BASIC SELECT + FILTER
#1.1.“Show all orders placed in January 2024”
SELECT order_id, customer_id, order_date
FROM Orders
WHERE order_date BETWEEN '2024-01-01' AND '2024-01-31'
ORDER BY order_date;

#2.GROUP BY + HAVING
#2.1.“Which cities generated more than ₹500 in revenue?”
SELECT c.city,
       SUM(p.price * od.quantity) AS city_revenue
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id
GROUP BY c.city
HAVING SUM(p.price * od.quantity) > 500;

#3.LEFT JOIN
#3.1.Show products that were never sold
SELECT p.product_name
FROM Products p
LEFT JOIN OrderDetails od 
ON p.product_id = od.product_id
WHERE od.product_id IS NULL;

#4.CASE STATEMENT
#4.1.Classify products as Expensive or Affordable
SELECT product_name,
       price,
       CASE 
           WHEN price >= 200 THEN 'Expensive'
           ELSE 'Affordable'
       END AS price_category
FROM Products;

#5. NESTED SUBQUERY
#5.1.Find customers who placed more orders than the average customer
SELECT name
FROM Customers
WHERE customer_id IN (
    SELECT customer_id
    FROM Orders
    GROUP BY customer_id
    HAVING COUNT(order_id) >
    (
        SELECT AVG(order_count)
        FROM (
            SELECT COUNT(order_id) AS order_count
            FROM Orders
            GROUP BY customer_id
        ) AS avg_orders
    )
);

#6. WINDOW FUNCTION
#6.1.Rank customers by total spending
SELECT c.name,
       SUM(p.price * od.quantity) AS total_spent,
       RANK() OVER (ORDER BY SUM(p.price * od.quantity) DESC) AS rank_position
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id
GROUP BY c.name;

#7.Handling NULL using COALESCE
SELECT 
    c.customer_id,
    c.name,
    COALESCE(SUM(p.price * od.quantity), 0) AS total_spent
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
LEFT JOIN OrderDetails od ON o.order_id = od.order_id
LEFT JOIN Products p ON od.product_id = p.product_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC;

#8.VIEW
#8.1.Create reusable Monthly Revenue view
CREATE VIEW Monthly_Revenue AS
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,
       SUM(p.price * od.quantity) AS total_revenue
FROM Orders o
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id
GROUP BY DATE_FORMAT(order_date, '%Y-%m');





