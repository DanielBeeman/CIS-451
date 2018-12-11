USE stores7;


#having trouble getting customers that ordered nothing as well as order number and date

SELECT c.fname, c.lname, SUM(total_price) AS total_price, COUNT(item_num), o.order_num, o.order_date FROM customer c LEFT JOIN orders o ON o.customer_num = c.customer_num LEFT JOIN items ON o.order_num = items.order_num WHERE c.lname = 'Higgins' GROUP BY o.customer_num, c.fname, c.lname, o.order_num;