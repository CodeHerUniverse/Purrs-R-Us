-- My scenario is a Cat Shelter called Purrs_R_Us that has a basic Database. In order to promote their business and increase 
-- engagement, they have decided to open a store alongside the shelter. The income from the shop will help fund the care that the cats need whilst 
-- they wait to be adopted. The store runs well but they want to increase engagement even more. A proposed chagned with has been approved is to
-- create discount offers for people who adopt a cat from the shelter, encouraging them to buy items in the shelter shop. This also has a
-- second effect, where regular customers may be more likely to adopt a cat if the cats are in the same location as the shop, but if they
-- also provide a discount for future purchases.

-- As part of this scenario I will demonstrate the creation of the database, and any mechanisms coded that will help the shop to make
-- data-driven decisions, and understand their clientelle.


-- -------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------ TABLE SETUP & DATA INSERT ----------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------


-- Create Purrs-R-Us database
CREATE DATABASE purrs_r_us;


-- USE Purrs R Us Database
USE purrs_r_us;


-- CREATE CUSTOMERS Table - This table will maintain the names of the customers only - contact details will be maintained in a different table 
-- in order to protect the customer's sensitive data, whilst the cashiers will still be able to see the customer name & ID

CREATE TABLE customers
	(ID INT NOT NULL, 
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	CONSTRAINT customers UNIQUE (first_name, last_name), # CONSTRAINT
	PRIMARY KEY (ID));


-- INSERT DATA into CUSTOMERS Table

INSERT INTO customers
	(ID, 
    first_name, 
    last_name)
VALUES
	(1, 'Maggie', 'Smith'),
	(2, 'Jack', 'Whitehall'),
	(3, 'Amanda', 'Watts'),
	(4, 'Luna', 'Hammond'),
	(5, 'Patricia', 'Willow'),
	(6, 'Jack', 'Phillips'),
	(7, 'Samantha', 'Phyllis'),
	(8, 'Edgar', 'Adams'),
	(9, 'Mary', 'May'),
	(10, 'Joe', 'Impresso');
    
    
SELECT 
	ID, 
	first_name, 
	last_name 
FROM 
	customers
ORDER BY 
	ID;


-- CREATE CATS Table - This table will maintain key information on our Shelter cats, as well as wether they have been adopted. We keep their records
-- after adoption to enable the discount system.

CREATE TABLE cats
	(cat_id INT NOT NULL, 
	cat_name VARCHAR(255) NOT NULL,
	breed VARCHAR(255) NOT NULL,
	age INT NOT NULL,
	colour VARCHAR(255) NOT NULL,
	adoption_status CHAR(1) DEFAULT 'N', # DEFAULT CONSTRAINT
	owner_id INT,
	FOREIGN KEY (owner_id) REFERENCES customers(ID),
	PRIMARY KEY (cat_id));


-- INSERT DATA into CATS Table

INSERT INTO cats
	(cat_id, 
    cat_name, 
    breed, 
    age, 
    colour, 
    adoption_status, 
    owner_id)
VALUES
	(1, 'Lulu', 'Shorthair', 12, 'Ginger', 'Y', 9),
	(2, 'Podgster', 'Persian', 3, 'Ginger', 'Y', 4),
	(3, 'Mr. Chonkster', 'Shorthair', 17,'Tuxedo', 'Y', 2),
	(4, 'Googly', 'Siamese', 2, 'Beige & Brown', 'N', NULL),
	(5, 'Lord Lordship', 'Unknown', 5, 'Black', 'Y', 6),
	(6, 'Khaleesi', 'Unknown', 7, 'Black', 'N', NULL),
	(7, 'Miss Sass', 'Unknown', 10, 'Ginger', 'Y', 9),
	(8, 'Comdore Whiskers', 'Russian Blue', 6, 'Grey', 'Y', 3),
	(9, 'Sue', 'Shorthair', 12, 'Black', 'N', NULL),
	(10, 'Mr. Grumpy', 'Semi-Long Hair', 4, 'Black', 'N', null);
    
    
SELECT 
	cat_id, 
	cat_name, 
	breed, 
	age, 
	colour, 
	adoption_status, 
	owner_id
FROM 
	cats
ORDER BY 
	cat_id;
        
        
-- CREATE ITEM PRICES Table - This table stores the item prices for each retail item, as well as their stock level. As it stands, our store staff
-- has to manually check these tables when providing an order total to a customer, and manually update the stock level.

CREATE TABLE item_prices
	(item_id INT NOT NULL, 
	item VARCHAR(255) NOT NULL,
	item_type VARCHAR(255) NOT NULL,
	brand VARCHAR(255) NOT NULL,
	price FLOAT NOT NULL,
	stock INT NOT NULL,
	PRIMARY KEY (item_id));


-- INSERT DATA into ITEM_PRICES Table

INSERT INTO item_prices
	(item_id, item, 
    item_type, 
    brand, price, 
    stock)
VALUES
	(1, 'Cat Bed', 'Furniture', 'Fluffy & Co', 25.99, 27),
	(2, 'Feather Toy', 'Toy', 'FastCat', 2.5, 35),
	(3, 'Catnip Puzzle', 'Toy', 'Fluffy & Co',5.6, 30),
	(4, 'Harness', 'Accessories', 'Action Paws', 12.99, 47),
	(5, 'Healthy Nibbles', 'Food', 'NomNom Feline', 5.8, 15),
	(6, 'Salmon Feast Biscuits', 'Food', 'NomNom Feline', 7, 22),
	(7, 'Buzz Ball', 'Toy', 'FastCat', 9.99, 36),
	(8, 'Fishy Delight', 'Food', 'Fluffy & Co', 13.5, 26),
	(9, 'Scratchy Pole', 'Furniture', 'Fluffy & Co', 12.2, 20),
	(10, 'Bell Collar', 'Accessories', 'FastCat', 6.5, 30);
    
    
SELECT 
	item_id, 
	item, 
	item_type, 
	brand, 
	price, 
	stock
FROM 
	item_prices
ORDER BY 
	item_id;


-- After some Strategic meetings, it was agreed that the promotion plan was going to go ahead. As per the decision, a table called CAT_PROMO
-- was created for the shop staff to manually check and apply any discounts, after manually checking the list of customers and the list of
-- cats that have been adopted.


-- CREATE CAT_PROMO Table

CREATE TABLE cat_promo
	(promo_id INT NOT NULL, 
	item_type VARCHAR(255) NOT NULL,
	promo_type VARCHAR(255) NOT NULL,
	discount FLOAT NOT NULL,
	PRIMARY KEY (promo_id));


-- INSERT DATA INTO CAT_PROMO Table

INSERT INTO cat_promo
	(promo_id, 
    item_type, 
    promo_type, 
    discount)
VALUES
	(111, 'Toy', '2-for-1', 0.5),
	(112, 'Food', '20% Discount', 1.2);
    
    
SELECT 
	promo_id, 
	item_type, 
    promo_type, 
    discount
FROM 
	cat_promo
ORDER BY 
	promo_id;


-- CREATE CUSTOMER_CONTACT Table. This table houses the customer's sensisitve data such as email address, physical address and mobile number
-- if they have shared it with us (not mandatory)

CREATE TABLE customer_contact
	(customer_id INT NOT NULL,
	email VARCHAR(255) NOT NULL UNIQUE, # UNIQUE CONSTRAINT TO AVOID DUPLICATE INFO
	address VARCHAR(255) NOT NULL,
	city VARCHAR(255) NOT NULL,
	phone_number CHAR(11) UNIQUE, # forces the max number of digits to be 11 (UK phone numbers) 
	CHECK (phone_number NOT LIKE '%[^0-9]%'), # this is to ensure no alphabetic characters are input CONSTRAINT
	FOREIGN KEY (customer_id) REFERENCES customers(ID));


-- INSERT DATA INTO CUSTOMER_CONTACT TABLE

INSERT INTO customer_contact
	(customer_id, 
    email, 
    address, 
    city, 
    phone_number)
VALUES
	(1, 'maggie.smith@hotmail.co.uk', '13 Poole Road', 'Poole', '07733873526'),
	(2, 'jack.whitehall@yahoo.com', '17 Privet Drive', 'Nottingham', '07256489751'),
	(3, 'amanda.watts@gmail.com', '25 Windwings Road', 'Bournemouth', '07452136589'),
	(4, 'luna.hammond@gmail.com', '47 Wimborne Road', 'Bournemouth', '07854475200'),
	(5, 'peach.fuzzy@hotmail.com', '101 Oxford Avenue', 'Southampton', '07445589741'),
	(6, 'plumber_jack@yahoo.co.uk', '12 Yard Lane', 'Portsmouth', null),
	(7, 'samantha_phills@yahoo.com', '75 Southborne Road', 'Swanage', '07452134875'),
	(8, 'edgar.adams@gmail.com', '2 Shadowy Lane', 'Yeovil', '07854448700'),
	(9, 'mary_mayhem@gmail.com', '34 Summer Drive', 'London', '07781389741'),
	(10, 'joey_impresso@hotmail.co.uk', '31 Pizza Close', 'Cardiff', null);
    
    
SELECT 
	customer_id, 
    email, 
    address, 
    city, 
    phone_number
FROM 
	customer_contact
ORDER BY 
	customer_id;


-- The shop has an input system when the cashiers are running the order. This is mainly used by the Logistics team and cannot be changed as it
-- is setup to work with the curret accounting software. The data is stored in SHOP_ORDERS Table and the data is mainly based on reference ids.

-- CREATE SHOP_ORDERS TABLE.

CREATE TABLE shop_orders
	(order_id INT NOT NULL,
	order_date VARCHAR(255) NOT NULL,
	customer_id INT NOT NULL,
	item_id INT NOT NULL,
	volume INT NOT NULL,
	FOREIGN KEY (customer_id) REFERENCES customers(ID),
	FOREIGN KEY (item_id) REFERENCES item_prices(item_id),
	PRIMARY KEY (order_id));


INSERT INTO shop_orders
	(order_id, 
    order_date, 
    customer_id, 
    item_id, 
    volume)
VALUES
	(1569, '12-08-2024', 5, 8, 2),
	(1570, '12-08-2024', 7, 10, 1),
	(1571, '17-08-2024', 6, 2, 5),
	(1572, '26-08-2024', 3, 1, 3),
	(1573, '26-08-2024', 1, 5, 4),
	(1574, '26-08-2024', 6, 2, 1),
	(1575, '30-08-2024', 9, 3, 2),
	(1576, '01-09-2024', 2, 4, 4),
	(1577, '02-09-2024', 9, 3, 1),
	(1578, '02-09-2024', 4, 6, 3),
	(1579, '10-09-2024', 5, 9, 1),
	(1580, '15-09-2024', 10, 2, 3),
	(1581, '15-09-2024', 9, 7, 2),
	(1582, '15-09-2024', 5, 8, 1),
	(1583, '17-09-2024', 7, 1, 4),
	(1584, '18-09-2024', 3, 4, 3),
	(1585, '20-09-2024', 9, 2, 2),
	(1586, '21-09-2024', 6, 10, 1),
	(1587, '22-09-2024', 4, 7, 5),
	(1589, '22-09-2024', 5, 9, 2);


SELECT 
	order_id, 
    order_date, 
    customer_id, 
    item_id, 
    volume
FROM 
	shop_orders
ORDER BY 
	order_id;
    
    
-- As Part of the initiative to modernize the current processes in the shop, as well as consolidate the information accross tables, we have created
-- an additional table that will be called SHOP_ORDERS_ENHANCED. This will consolidate much of the information, making it more presentable for
-- Stakeholders

-- CREATE TABLE SHOP_ORDERS_ENHANCED - at first we are making the table exactly like SHOP_ORDERS so we can migrate the existing data easily.

CREATE TABLE shop_orders_enhanced
	(order_id INT NOT NULL,
	order_date VARCHAR(255) NOT NULL,
	customer_id INT NOT NULL,
	item_id INT NOT NULL,
	volume INT NOT NULL,
	FOREIGN KEY (customer_id) REFERENCES customers(ID),
	FOREIGN KEY (item_id) REFERENCES item_prices(item_id),
	PRIMARY KEY (order_id));


-- INSERT THE DATA FROM SHOP_ORDERS INTO SHOP_ORDERS_ENHANCED

INSERT INTO 
	shop_orders_enhanced
SELECT 
	order_id,
	order_date,
	customer_id,
	item_id,
	volume
FROM 
	shop_orders;
    

SELECT 
	order_id,
	order_date,
	customer_id,
	item_id,
	volume
FROM 
	shop_orders_enhanced
ORDER BY 
	order_id;


-- ALTER THE TABLE FOR THE ENHANCEMENTS WE ARE GOING TO ADD

ALTER TABLE shop_orders_enhanced 
	ADD COLUMN Customer_Name VARCHAR(255),
    ADD COLUMN item VARCHAR(255),
	ADD COLUMN price FLOAT,
	ADD COLUMN item_type VARCHAR(255),
	ADD COLUMN order_total FLOAT,
	ADD COLUMN has_adopted CHAR(1) DEFAULT 'N',
	ADD COLUMN total_after_discount FLOAT,
	ADD COLUMN promo_type VARCHAR(255) DEFAULT 'N/A';


SELECT 
	*
FROM 
	shop_orders_enhanced
ORDER BY 
	order_id;
    
    
-- -------------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------- DATA MANIPULATION & SETTING PROCEDURES/TRIGGERS ---------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------

-- UPDATE THE PRICE, ITEM_NAME, ITEM_TYPE & ORDER_TOTAL WITHIN THE SHOP_ORDERS_ENHANCED TABLE WITH DATA FROM THE ITEM_PRICES TABLE

UPDATE 
	shop_orders_enhanced AS soe
LEFT JOIN 
	item_prices AS ip 
ON 
	soe.item_id = ip.item_id # LEFT JOIN
SET 
	soe.item = ip.item,
	soe.price = ip.price,
	soe.item_type = ip.item_type,
	soe.order_total = soe.volume * soe.price;


-- UPDATE THE CUSTOMER_NAME COLUMN WITHIN THE SHOP_ORDERS_ENHANCED TABLE WITH DATA FROM THE CUSTOMERS TABLE

UPDATE 
	shop_orders_enhanced AS soe
LEFT JOIN 
	customers AS c 
ON 
	soe.customer_id = c.ID # LEFT JOIN
SET 
	soe.Customer_Name = CONCAT(c.first_name,' ',c.last_name);
    
    
-- UPDATE THE ADOPTION_STATUS COLUMN WITHIN THE SHOP_ORDERS_ENHANCED TABLE WITH DATA FROM THE CATS TABLE

UPDATE 
	shop_orders_enhanced AS soe
LEFT JOIN 
	cats AS c 
ON 
	soe.customer_id = c.owner_id # LEFT JOIN
SET 
	soe.has_adopted = c.adoption_status
WHERE 
	c.adoption_status = 'Y';


-- UPDATE THE PROMO_TYPE COLUMN WITHIN THE SHOP_ORDERS_ENHANCED TABLE WITH DATA FROM THE CAT_PROMO TABLE

UPDATE 
	shop_orders_enhanced AS soe
LEFT JOIN 
	cat_promo AS cp # LEFT JOIN
ON 
	soe.item_type = cp.item_type
SET 
	soe.promo_type = cp.promo_type
WHERE 
	soe.has_adopted = 'Y' AND soe.item_type IN ('Food','Toy');


-- UPDATE THE TOTAL_AFTER_DISCOUNT COLUMN WITHIN THE SHOP_ORDERS_ENHANCED TABLE BY EITHER APPLYING THE DISCOUNT, OR KEEPING THE ORIGINAL ORDER
-- TOTAL IF IT'S A CUSTOMER THAT HASN'T ADOPTED A CAT.

UPDATE 
	shop_orders_enhanced AS soe
SET 
	soe.total_after_discount = 
		CASE
			WHEN (soe.has_adopted = 'Y' AND  soe.promo_type = '2-for-1') THEN ((soe.volume - FLOOR(soe.volume / 2)) * soe.price) # IN-BUILT FUNCTION FLOOR
			WHEN (soe.has_adopted = 'Y' AND  soe.promo_type = '20% Discount') THEN (soe.order_total - (soe.order_total * 0.2))
			ELSE soe.order_total
		END;


SELECT 
	*
FROM 
	shop_orders_enhanced
ORDER BY 
	order_id;
    
    
-- CREATE PROCEDURE AMEND_STOCK. In order to assist the staff to quickly obtain the order total, this procedure was developed to easily check
-- the stock levels when an order is placed, and either adjust the stock levels, or issue a message stating "Not Enough Stock.

DELIMITER //

-- CREATE PROCEDURE
CREATE PROCEDURE amend_stock (
	item_id INT, 
	volume INT)
BEGIN
	SET autocommit = 0;
	-- USING TRANSACTION TO ENSURE PROCESS CAN BE ROLLED BACK IF THERE ISN'T ENOUGH STOCK
	START TRANSACTION;
		-- USING AN IF STATEMENT, CHECK IF THE STOCK IS LARGER OR EQUAL THAN THE VOLUME.
        -- SET A VARIABLE WITH A MESSAGE REGARDING THE OUTCOME OF THE STOCK CHECK
		SET @enoughstock := IF(
								(SELECT 
									ip.stock
								FROM 
									item_prices AS ip
								WHERE 
									ip.item_id = item_id) >= volume, 
								'OK to Proceed', 
								'Not Enough Stock');

-- UPDATE THE STOCK LEVEL FOR THE PURCHASED ITEM (NOT COMMITED)

	UPDATE 
		item_prices AS ip
	SET 
		ip.stock = ip.stock - volume
	WHERE 
		ip.item_id = item_id;

-- IF THE MESSAGE STORED IN THE VARIABLE IS POSITIVE THEN COMMIT; OTHERWISE ROLLBACK.
	IF @enoughstock = 'OK to Proceed'
    THEN 
		COMMIT;
        SET autocommit = 1;
    ELSE 
		ROLLBACK;
        SET autocommit = 1;
	END IF;
END //


-- AFTER WE HAVE OUR AMEND_STOCK PROCEDURE WE THEN DEVELOP A SECOND PROCEDURE, CALLED INSERT_NEW_ORDER. This Procedure is used to enable the users
-- to:
--     -> Input orders in a more user-friendly way (using item descriptions and customer names, rather than having to find the customer id or item id
--     -> If the cashier is processing a new customer, which doesn't exist in the customers table, then the PROCEDURE will add it to the customer table.
--     -> Execute the AMEND_STOCK procedure, which will halt the whole process if the message from the stock level check is "Not Enough Stock".
--     -> Display the "Not Enough Stock" message to the cashier.

CREATE PROCEDURE insert_new_order (
	order_id INT, 
	order_date VARCHAR(255), 
	customer_name VARCHAR(255), 
	item_purchased VARCHAR(255), 
	volume INT)
BEGIN

-- IF STATEMENT TO CHECK IF CUSTOMER EXISTS IN CUSTOMERS TABLE, AND IF NOT, TO ADD IT.
	SET @existingcustomer = customer_name;
    IF 
		@existingcustomer NOT IN (SELECT CONCAT(c.first_name,' ',c.last_name) FROM customers AS c)
    THEN
		INSERT INTO customers(
			SELECT
				(SELECT MAX(ID)+1 FROM customers), # AGGREGATE FUNCTION MAX
				LEFT(@existingcustomer,LOCATE(' ', @existingcustomer)-1),
				RIGHT(@existingcustomer,(LENGTH(@existingcustomer)- LOCATE(' ', @existingcustomer))));
    END IF;
    
-- SET VARIABLE @ITEM AS THE ITEM_ID THAT RELATES TO THE ITEM INPUT BY THE USER
	SET @item = (SELECT 
					ip.item_id 
				FROM 
					item_prices AS ip
				WHERE 
					ip.item = item_purchased);
                    
-- CALL THE AMEND STOCK PROCEDURE, WITH THE @ITEM VARIABLE AND THE VOLUME INPUT BY THE USER
	CALL amend_stock(@item, volume); 

-- IF @ENOUGHSTOCK VARIABLE CONTAINS A NEGATIVE MESSAGE THEN DISPLAY A MESSAGE TO THE USER STATING THIS. 
    IF 
		@enoughstock = 'Not Enough Stock'
    THEN 
		SELECT 
			'Not Enough Stock' AS Message;
-- OTHERWISE CONTINUE AND INSERT THE NEW ORDER INTO THE SHOP_ORDERS TABLE
    ELSE
		INSERT INTO shop_orders (
			order_id, 
			order_date, 
            customer_id, 
            item_id, 
            volume)
		SELECT 
			order_id, 
			order_date, 
			(SELECT 
				c.ID 
			FROM 
				customers AS c
			WHERE 
				customer_name = CONCAT(c.first_name,' ',c.last_name)) AS customer_id, # IN-BUILT FUNCTION CONCAT
			@item AS item_id,
			volume;
		END IF; 
END //


-- CREATE TRIGGER THAT UPDATES THE SHOP_ORDERS_ENHANCED TABLE WITH THE DATA INPUT INTO SHOP_ORDERS. This Trigger:

--   -> Takes the newly input order from the SHOP_ORDERS table and inserts it into the SHOP_ORDERS_ENHANCED table.
--   -> Updates the additional fields of Customer_Name, price, item_type, order_total, adoption_status, promo_type and 
--      total_after_discount immediately

-- CREATE TRIGGER
CREATE TRIGGER update_order_discounts 
AFTER INSERT ON shop_orders
FOR EACH ROW
BEGIN
	INSERT INTO shop_orders_enhanced (
		order_id, 
        order_date, 
        customer_id, 
        item_id, 
        volume)
	SELECT 
		so.order_id, 
        so.order_date, 
        so.customer_id, 
        so.item_id, 
        so.volume
	FROM 
		shop_orders AS so
    WHERE 
		so.order_id = (SELECT 
						MAX(so.order_id) 
					FROM 
						shop_orders AS so); # AGGREGATE FUNCTION MAX
   
-- UPDATE THE CUSTOMER_NAME COLUMN WITHIN THE SHOP_ORDERS_ENHANCED TABLE WITH DATA FROM THE CUSTOMERS TABLE
    UPDATE 
		shop_orders_enhanced AS soe
	LEFT JOIN 
		customers AS c 
	ON 
		soe.customer_id = c.ID # LEFT JOIN
	SET 
		soe.Customer_Name = CONCAT(c.first_name,' ',c.last_name);

-- UPDATE THE PRICE, ITEM_NAME, ITEM_TYPE & ORDER_TOTAL WITHIN THE SHOP_ORDERS_ENHANCED TABLE WITH DATA FROM THE ITEM_PRICES TABLE
	UPDATE 
		shop_orders_enhanced AS soe
	LEFT JOIN 
		item_prices AS ip 
	ON 
		soe.item_id = ip.item_id # LEFT JOIN
	SET 
		soe.item = ip.item,
		soe.price = ip.price,
		soe.item_type = ip.item_type,
		soe.order_total = soe.volume * soe.price
    WHERE soe.price IS NULL;

-- UPDATE THE ADOPTION_STATUS COLUMN WITHIN THE SHOP_ORDERS_ENHANCED TABLE WITH DATA FROM THE CATS TABLE
	UPDATE 
		shop_orders_enhanced AS soe
	LEFT JOIN 
		cats AS c 
	ON 
		soe.customer_id = c.owner_id # LEFT JOIN
	SET 
		soe.has_adopted = c.adoption_status
	WHERE 
		soe.customer_id = c.owner_id 
        AND soe.total_after_discount IS NULL;

-- UPDATE THE PROMO_TYPE COLUMN WITHIN THE SHOP_ORDERS_ENHANCED TABLE WITH DATA FROM THE CAT_PROMO TABLE
	UPDATE 
		shop_orders_enhanced AS soe
	LEFT JOIN 
		cat_promo AS cp # LEFT JOIN
	ON 
		soe.item_type = cp.item_type
	SET 
		soe.promo_type = cp.promo_type
	WHERE 
		soe.item_type = cp.item_type 
		AND soe.has_adopted = 'Y'
        AND soe.promo_type = 'N/A' 
        AND soe.total_after_discount IS NULL;

-- UPDATE THE TOTAL_AFTER_DISCOUNT COLUMN WITHIN THE SHOP_ORDERS_ENHANCED TABLE BY EITHER APPLYING THE DISCOUNT, OR KEEPING THE ORIGINAL ORDER
-- TOTAL IF IT'S A CUSTOMER THAT HASN'T ADOPTED A CAT.
	UPDATE 
		shop_orders_enhanced AS soe
	SET 
		soe.total_after_discount = 
			CASE
				WHEN (soe.has_adopted = 'Y' AND  soe.promo_type = '2-for-1') THEN ((soe.volume - FLOOR(soe.volume / 2)) * soe.price) # IN-BUILT FUNCTION FLOOR
				WHEN (soe.has_adopted = 'Y' AND  soe.promo_type = '20% Discount') THEN (soe.order_total - (soe.order_total * 0.2))
				ELSE soe.order_total
			END
	WHERE 
		soe.total_after_discount IS NULL;
END //

DELIMITER ;


-- The SHOP_ORDERS_ENHANCED Table is now very detailed - for our cashier we don't want to bombard them with information when they are trying
-- to complete the purchase. To make things easier and only display what the cashier needs, we have created a view that is tidy and organized.

CREATE VIEW shop_orders_enhanced_view AS
SELECT 
	soe.order_id,
    soe.order_date,
    soe.customer_name,
    soe.volume AS number_of_items,
    soe.item,
    soe.item_type,
    soe.order_total,
    soe.has_adopted AS promo_applied,
    soe.promo_type,
    soe.total_after_discount
FROM
	shop_orders_enhanced AS soe
ORDER BY
	soe.order_id ASC;


-- Try out the new view for the cashier
SELECT * FROM shop_orders_enhanced_view;


-- CALL PROCEDURE INSERT_NEW_ORDER. Cashier inputs the below information.

   CALL insert_new_order(
	(SELECT 
		@Latest_order_id := MAX(order_id)+1 # AGGREGATE FUNCTION MAX
	FROM 
		shop_orders), 
	'23-09-2024', 
	'Amanda Watts',
	'Salmon Feast Biscuits', 
	5 -- VOLUME
	);
    
    
CALL insert_new_order(
	(SELECT 
		@Latest_order_id := MAX(order_id)+1 # AGGREGATE FUNCTION MAX
	FROM 
		shop_orders), 
	'23-09-2024', 
	'Joe Impresso',
	'Buzz Ball', 
	2 -- VOLUME
	);
    
    
    CALL insert_new_order(
	(SELECT 
		@Latest_order_id := MAX(order_id)+1 # AGGREGATE FUNCTION MAX
	FROM 
		shop_orders), 
	'23-09-2024', 
	'Peter Parker', -- NEW CUSTOMER, NOT ON DATABASE
	'Scratchy Pole', 
	3 -- VOLUME
	);
    
    
	CALL insert_new_order(
	(SELECT 
		@Latest_order_id := MAX(order_id)+1 # AGGREGATE FUNCTION MAX
	FROM 
		shop_orders), 
	'23-09-2024', 
	'Mary May',
	'Fishy Delight', 
	6 -- VOLUME
    );


-- -------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------- DATA QUERYING, DELETION & ANALYSIS ---------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------

-- SCENARIO: A new Shipment has arrived with a new product, ' Cat Fluffy Blanket'. We need to add it to the database so it's available for purchase

INSERT INTO item_prices ( # INSERT QUERY
	item_id, 
	item, 
    item_type, 
    brand, 
    price, 
    stock)
SELECT 
	MAX(item_id)+1, # AGGREGATE FUNCTION MAX
	'Cat Fluffy Blanket', 
	'Accessories',
	'Action Paws',
	10.00,
	30
FROM 
	item_prices;


-- SCENARIO: Our team wants to regularly check who are the top spending customers that use the shop. We have set the parameters as:
--    -> Only display the Top 6, sorted from Highest Spending to Least.
--    -> Only show results for the latest month
--    -> Sum of Sales is for ALL items bought in that time period
--    -> An additional column displays the type of item the customer spends most money on, and what percentage of their overall spend 
--       that category makes up.

-- CREATE A VIEW THAT GIVES THE TOP 6 CUSTOMERS BY SPEND

CREATE VIEW Top6_Sales_per_Amount_Spent AS
	SELECT 
		Top_Overall.Date_Period, 
		Top_Overall.Total_Money_Spent_In_Store, 
		Top_Overall.Customer_Name, 
		CONCAT(	CONVERT(ROUND(((Top_Items.Total_Sales_per_Item_Type / Top_Overall.Total_Money_Spent_In_Store)*100),2), char(20)),
				'% spent on "',
				Top_Items.Spent_Most_Money_On,
				'" items') 
                AS Percentage_Spent_on_Favourite_Item
	FROM 
    -- SELECT STATEMENT AS TABLE Top_Overall
		(SELECT
			CONCAT(MONTHNAME(STR_TO_DATE(soe.order_date, '%d-%m-%Y'))," ", YEAR(STR_TO_DATE(soe.order_date, '%d-%m-%Y'))) AS Date_Period, # IN-BUILT FUNCTION CONCAT
			ROUND(SUM(soe.total_after_discount), 2) AS Total_Money_Spent_In_Store, # AGGREGATE FUNCTION SUM & IN-BUILT FUNCTION ROUND
			soe.Customer_Name # IN-BUILT FUNCTION CONCAT
		FROM 
			shop_orders_enhanced AS soe
		WHERE 
			MONTHNAME(STR_TO_DATE(soe.order_date, '%d-%m-%Y')) = (	SELECT 
																		MONTHNAME(MAX(STR_TO_DATE(order_date, '%d-%m-%Y'))) 
																	FROM 
																		shop_orders_enhanced)
		GROUP BY
			Date_Period,
			soe.Customer_Name
		ORDER BY
			Total_Money_Spent_In_Store DESC
		LIMIT 6) 
	AS Top_Overall
	LEFT JOIN -- LEFT JOIN OVERALL SPEND WITH TOTAL SPEND PER ITEM FOR PERCENTAGES
	-- SELECT STATEMENT AS TABLE Top_Items
	(SELECT *
		FROM (
		-- SELECT STATEMENT AS TABLE Ranked_Items
				SELECT
					CONCAT(MONTHNAME(STR_TO_DATE(soe.order_date, '%d-%m-%Y'))," ", YEAR(STR_TO_DATE(soe.order_date, '%d-%m-%Y'))) AS Date_Period,  # IN-BUILT FUNCTION CONCAT & IN-BUILT FUNCTION STR_TO_DATE & IN-BUILT FUNCTION MONTH_NAME
					ROUND(SUM(soe.total_after_discount), 2) AS Total_Sales_per_Item_Type, # AGGREGATE FUNCTION SUM
					soe.Customer_Name,
					soe.item_type AS Spent_Most_Money_On,
					ROW_NUMBER() OVER(PARTITION BY Customer_Name ORDER BY ROUND(SUM(soe.total_after_discount), 2) desc) AS Rownumber # AGGREGATE FUNCTION SUM &IN-BUILT FUNCTION ROUND
				FROM 
					shop_orders_enhanced AS soe
				WHERE 
					MONTHNAME(STR_TO_DATE(soe.order_date, '%d-%m-%Y')) = (SELECT MONTHNAME(MAX(STR_TO_DATE(order_date, '%d-%m-%Y'))) # IN-BUILT FUNCTION STR_TO_DATE & IN-BUILT FUNCTION MONTH_NAME
																			FROM shop_orders_enhanced	) # AGGREGATE FUNCTION MAX & IN-BUILT FUNCTION STR_TO_DATE & IN-BUILT FUNCTION MONTH_NAME
						GROUP BY
							Date_Period,
							soe.Customer_Name,
							Spent_Most_Money_On
						ORDER BY
							soe.Customer_Name,
							Rownumber) 
				AS Ranked_Items
		WHERE 
			Rownumber = 1)
	AS Top_Items
	ON 
		Top_Overall.Customer_Name = Top_Items.Customer_Name;


-- LET'S VIEW THE RESULTS
SELECT * FROM Top6_Sales_per_Amount_Spent;
  
  
-- CALL PROCEDURE INSERT_NEW_ORDER. Cashier inputs the below information - This customer is currently ranked #2 in the Top6, 
-- with their most bought item class being 'Food'. Let's see how the ranking and the statistics are affected after they make a big purchase
-- of a different item in a different category.

   CALL insert_new_order(
	(SELECT 
		@Latest_order_id := MAX(order_id)+1 # AGGREGATE FUNCTION MAX
	FROM 
		shop_orders), 
	'24-09-2024', 
	'Mary May',
	'Harness', 
	20 -- VOLUME
	);


-- LET'S VIEW THE NEW RESULTS
SELECT * FROM Top6_Sales_per_Amount_Spent;


-- SCENARIO: The Shelter part of the business still has some furbabies to be adopted. In light of this, the Marketing team is going to lauch
-- a targeted campaign to try and persuade customers who haven't adopted to adopt some of our kitties. The first thing to do is to understand
-- our kitties that haven't been adopted. Fur colour is a well known factor that sways some people when choosing to adopt one cat v.s. another
-- so let's extract some facts on our own kitties.

-- Within the adopted and non-adopted population of our shelter, what is the colour most present in each sub-set?
-- The below code will find the most present colour within each sub-set, and divide it by the overall count of cats in that sub-set
-- giving us the percentage of most frequent colour within the adopted and non-adopted groups. The output will be two statements describing the 
-- percentages.

SELECT 
	CONCAT(ROUND(Percentage,2),"% of adopted Cats are ",most_popular_colour,".") AS Cat_Stats # IN-BUILT FUNCTION CONCAT & IN-BUILT FUNCTION ROUND
FROM
	-- SELECT STATEMENT AS TABLE Popular_percentage
	(SELECT
		(SELECT
			count FROM
				-- SELECT STATEMENT AS TABLE Top_Adopted_Colour_count
				(SELECT 
					colour AS Most_adopted_colour, 
                    COUNT(colour) AS count # AGGREGATE FUNCTION COUNT
				FROM 
					cats 
				WHERE 
					adoption_status = 'Y'
				GROUP BY
					Most_adopted_colour
				ORDER BY 
					count DESC
				LIMIT 1) 
				AS Top_Adopted_Colour_count)
		/
        -- SELECT STATEMENT AS TABLE Percentage
		(SELECT
			count 
		FROM 
			-- SELECT STATEMENT AS TABLE overall_adopted_count
			(SELECT 
				COUNT(colour) AS count # AGGREGATE FUNCTION COUNT
			FROM 
				cats
			WHERE 
				adoption_status = 'Y') 
			AS overall_adopted_count) 
		AS Percentage,
        -- SELECT STATEMENT AS TABLE most_popular_colour
		(SELECT
			colour 
		FROM 
			-- SELECT STATEMENT AS TABLE overall_adopted_count
			(SELECT 
				colour, 
                COUNT(colour) AS count # AGGREGATE FUNCTION COUNT
			FROM 
				cats
			WHERE 
				adoption_status = 'Y'
			GROUP BY 
				colour
			ORDER BY 
				count DESC
			LIMIT 1) 
            as overall_adopted_count) 
		AS most_popular_colour) 
	AS Popular_percentage

UNION -- UNION THE MOST PRESENT COLOUR WITHIN ADOPTED CATS PERCENTAGE WITH THE LEAST PRESENT COLOUR WITHIN NON-ADOPTED CATS PERCENTAGE

SELECT 
	CONCAT(ROUND(Percentage,2),"% of not yet adopted Cats are ",Least_popular_colour,".") AS Cat_Stats -- IN-BUILT FUNCTION CONCAT & IN-BUILT FUNCTION ROUND
FROM
	-- SELECT STATEMENT AS TABLE Unpopular_percentage
	(SELECT
		(SELECT
			count 
		FROM
			-- SELECT STATEMENT AS TABLE Least_adopted_colour_count
			(SELECT 
				colour AS Least_adopted_colour, 
                COUNT(colour) AS count  # AGGREGATE FUNCTION COUNT
			FROM 
				cats
			WHERE 
				adoption_status = 'N'
			GROUP BY
				Least_adopted_colour
			ORDER BY 
				count DESC
			LIMIT 1) 
            AS Least_adopted_colour_count)
		/
		-- SELECT STATEMENT AS TABLE Percentage
		(SELECT
			count 
		FROM 
			-- SELECT STATEMENT AS TABLE overall_adopted_count
			(SELECT 
				COUNT(colour) AS count # AGGREGATE FUNCTION COUNT
			FROM 
				cats
			WHERE 
				adoption_status = 'N') 
			as overall_adopted_count)
		AS Percentage,
        -- SELECT STATEMENT AS TABLE Least_popular_colour
		(SELECT
			colour 
		FROM 
			-- SELECT STATEMENT AS TABLE overall_adopted_count
			(SELECT 
				colour, 
                COUNT(colour) AS count # AGGREGATE FUNCTION COUNT
			FROM 
				cats
			WHERE 
				adoption_status = 'N'
			GROUP BY 
				colour
			ORDER BY 
				count DESC
			LIMIT 1) 
            as overall_adopted_count) 
		AS Least_popular_colour) 
	AS Unpopular_percentage;

-- Our query has returned that 0.50% of adopted Cats are Ginger and that 0.75% of not yet adopted Cats are Black.


-- As part of the data gathering Excercise, we also want to observe the Average age per breed of adopted cats
SELECT 
	breed, ROUND(AVG(age),0) AS average_cat_age_of_adopted # AGGREGATE FUNCTION AVG & IN-BUILT FUNCTION ROUND & RETRIEVE DATA QUERY
FROM 
	cats
WHERE 
	adoption_status = 'Y'
GROUP BY
	breed
ORDER BY
	average_cat_age_of_adopted DESC;
    
    
-- As part of the data gathering Excercise, we also want to observe the Average age per breed of non-adopted cats
SELECT 
	breed, ROUND(AVG(age),0) AS average_cat_age_of_non_adopted # AGGREGATE FUNCTION AVG & IN-BUILT FUNCTION ROUND & RETRIEVE DATA QUERY
FROM 
	cats
WHERE 
	adoption_status = 'N'
GROUP BY
	breed
ORDER BY
	average_cat_age_of_non_adopted DESC;


-- We have observed no specific trend of breed and their Average age on neither the Adopted and Non-Adopted Cats.
-- The Marketing team is confident that the basis for the campaign should be to promote cats that have black fur, as these are the highest
-- group within the Non-Adopted sub-set.

-- So lets gather the details of any customers that have and haven't adopted.

-- List of customers that have adopted - The Marketing team will target them with information on the existing promotions, and will include
-- the adopted cat's name in the communication to connect with the customer on an emotional level.

SELECT 
	cat_name, 
	CONCAT(cus.first_name," ",cus.last_name) AS Customer_Name  # RETRIEVE DATA QUERY & IN-BUILT FUNCTION CONCAT
FROM
	customers AS cus
INNER JOIN -- INNER JOIN
	cats AS c
WHERE 
	c.owner_id = cus.ID;


-- As the above customers have already adopted, the Marketing team will promote the products that aren't selling very well to try and up their sales.
-- The below query provides a list of items and how many times they have been purchased to date, with the least sold at the top of the list.
-- In light of this, the strategy will be to promote the Catnip Puzze & the Healthy Nibbles to customers that have adopted, especially because
-- these items will have discounts applied as they are in the "Food" & "Toy" categories.

SELECT 
	soe.item, 
	SUM(volume) AS times_purchased_to_date  # RETRIEVE DATA QUERY & IN-BUILT FUNCTION CONCAT
FROM
	shop_orders_enhanced AS soe
INNER JOIN -- INNER JOIN
	item_prices AS ip
WHERE 
	soe.item_id = ip.item_id
GROUP BY
	soe.item
ORDER BY
	times_purchased_to_date ASC;
    
    
-- The below query provides a list of Customers that haven't adopted, alongside the list of cats that haven't been adopted. 
-- The Marketing team is going to tackle this in two approaches:
--    -> Marketing communication promoting black cats to be sent to the below customers.
--    -> Marketing materials to be placed in store with the pictures and names of our kitties that haven't been adopted.

SELECT 
	cat_name, 
	CONCAT(first_name," ",last_name) AS Customer_Name  # RETRIEVE DATA QUERY & IN-BUILT FUNCTION CONCAT
FROM
	-- SELECT STATEMENT AS TABLE Cats_and_customers_full_join
	(SELECT *
    FROM
		customers AS cus
	LEFT JOIN 
		cats AS c 
	ON c.owner_id = cus.ID
	UNION
	SELECT * 
    FROM 
		customers AS cus
	RIGHT JOIN cats AS c
		ON c.owner_id = cus.ID) 
	AS Cats_and_customers_full_join
WHERE 
	owner_id IS NULL;
    

-- Unexpectedly, there has been a recall on a product issued by Fluffy & Co, the "Scratchy Pole". In light of this information, we need to identify which customers
-- purchased this item, and when, so we can reach out to inform them and issue refunds. 
-- The below query retrieves this data for us.

SELECT -- RETRIEVE DATA QUERY 
	soe.order_id, 
	soe.order_date,
	ip.item,
	ip.brand, 
	CONCAT(c.first_name," ",c.last_name) AS CustomerName,
	cc.email,
	cc.phone_number
FROM 
	item_prices AS ip
INNER JOIN
	shop_orders_enhanced AS soe
ON 
	soe.item_id = ip.item_id
		INNER JOIN
			customers AS c
		ON 
			soe.customer_id = c.ID
				INNER JOIN
					customer_contact AS cc
				ON 
					c.ID = cc.customer_id
WHERE 
	ip.item = 'Scratchy Pole';


-- Edgar Adams has reached out to the store informing us that he is moving to Spain, and therefore doesn't want to be contacted about
-- promotions or marketing campaigns, however he still might buy some treats for his mum's cat when he comes to visit, so he just wants his contact
-- details removed from the database.

-- We developed a procedure that allows a user to remove the contact details of a Customer without accessing the full table, so the contact
-- details of the remaining Customers are protected.

DELIMITER //

CREATE PROCEDURE remove_contact_details (CustomerName VARCHAR(255))
	BEGIN
		IF
			(SELECT 
				ID
			FROM 
				customers AS c
			WHERE
				CustomerName = CONCAT(c.first_name," ",c.last_name)) IN 
					(SELECT 
						customer_ID 
					FROM 
						customer_contact)
		THEN
			DELETE FROM customer_contact # DELETE QUERY
		WHERE 
			customer_id = (SELECT 
								ID 
							FROM 
								(SELECT * 
								FROM 
									customers
								WHERE 
									first_name = LEFT(CustomerName,LOCATE(' ', CustomerName)-1) 
                                    AND last_name = RIGHT(CustomerName,(LENGTH(CustomerName)- LOCATE(' ', CustomerName)))) AS Customer_to_remove);
		ELSE
			SELECT "Contact Details not present in Database" AS Message;
		END IF;
END //

DELIMITER ;


-- Using the Procedure to remove Edgar Adams details

CALL remove_contact_details ('Edgar Adams');


-- Query to retrieve the details of Customers where we don't have any details under the contact details table (customer has chosen not to give,
-- or customer has been removed from customer_contact Table. In this scenrarion, both Edgar Adams and Peter Parker don't have contact details
-- as Peter Parker was a new customer that came to the shop, but didn't give contact details/sign up for an account.

SELECT 
	CONCAT(c.first_name, ' ', c.last_name) AS Customers_without_CC_Details # RETIREVE DATA QUERY
FROM 
	customers AS c
WHERE 
	c.ID NOT IN
		(SELECT 
			c.ID 
		FROM 
			customers AS c
		INNER JOIN
			customer_contact AS cc
		ON 
			c.ID = cc.customer_id);



