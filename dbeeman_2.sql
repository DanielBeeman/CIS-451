#USE stores7;


#1
#works
/*
SELECT fname, lname, city, sname FROM customer
INNER JOIN state ON customer.state = state.code
WHERE state.sname = "California" OR state.sname = "Arizona" OR state.sname = "Colorado"
ORDER BY FIELD(state, "CA", "AZ", "CO");
*/

#2
#not working
/*
SELECT customer.customer_num, fname, lname, city, sname AS state, manu_name, SUM(total_price) AS total FROM customer JOIN state ON customer.state = state.code
JOIN orders ON customer.customer_num = orders.customer_num
JOIN items ON orders.order_num = items.order_num
JOIN manufact ON items.manu_code = manufact.manu_code
WHERE manu_name LIKE "Shimara" GROUP BY lname;

# I was not sure how to combine the top part, which added up the amount for each customer from Shimara, and the next line, which grabbed all customers who did not purchase anything.

SELECT fname, lname FROM customer LEFT JOIN orders ON customer.customer_num = orders.customer_num WHERE orders.customer_num is NULL;
*/



#3
#works
/*
SELECT sub1.fname, sub1.lname, (sub1.price + sub2.ship) AS totalspnt FROM 
	(SELECT c.customer_num, c.fname, c.lname, SUM(i.total_price) AS price FROM items AS i 
	JOIN orders AS  o ON i.order_num = o.order_num JOIN customer AS c ON o.customer_num = c.customer_num
	GROUP BY c.customer_num) AS sub1

JOIN

	(SELECT c.customer_num, SUM(ship_charge) AS ship FROM orders AS o 
	JOIN customer AS c ON o.customer_num = c.customer_num GROUP BY c.customer_num) AS sub2

ON sub1.customer_num = sub2.customer_num ORDER BY sub1.lname ASC;
*/


/*
#4
#works
SELECT *
FROM stock
WHERE NOT EXISTS
(SELECT * FROM items WHERE stock.manu_code = items.manu_code AND stock.stock_num = items.stock_num);
*/

/*
#5 
#works
set @ave = (select avg(ship_weight) from orders);
set @largest = (select max(aa) from (select abs(ship_weight-@ave) aa from orders) as a);
select order_num, customer_num, ship_weight from (select customer_num, order_num, ship_weight, abs(ship_weight-@ave) as ab from orders) as bb where ab=@largest;
*/

USE badcompany; 


/*
#7 
#works
SELECT dname, pname, plocation FROM
project JOIN department AS d ON project.dnum = d.dnumber 
WHERE project.plocation
NOT IN 
(SELECT dlocation FROM dept_locations as dl WHERE dl.dnumber = d.dnumber );
*/


/*
#8
#works
SELECT project.pname, SUM(works_on.hours) AS sum_total_hours FROM project JOIN works_on ON project.pnumber = works_on.pno
 group by pname
having sum_total_hours = (select MAX(hours) FROM (SELECT SUM(hours) AS hours FROM works_on group by pno) as sub1);
*/




#9
#works
SELECT fname, lname, project.pname from
employee JOIN works_on on employee.ssn = works_on.essn JOIN project on works_on.pno = project.pnumber JOIN 
(SELECT project.pname, SUM(works_on.hours) AS total_hours FROM project JOIN works_on ON project.pnumber = works_on.pno 
 group by pname ORDER BY total_hours ASC LIMIT 4) as sub1 on sub1.pname = project.pname ORDER BY lname;


#use sakila;

/*
#10
#works 
SELECT title, IFNULL(SUM(p.amount), 0) as amtspnt FROM film AS f 
LEFT OUTER JOIN inventory AS i ON f.film_id = i.film_id 
LEFT OUTER JOIN rental AS r ON i.inventory_id = r.inventory_id 
LEFT OUTER JOIN payment AS p ON r.rental_id = p.rental_id 
WHERE f.title LIKE "A%" GROUP BY f.title ;
*/