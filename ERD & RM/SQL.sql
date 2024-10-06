--Delet table
DROP TABLE IF EXISTS TakeoutOrders;
DROP TABLE IF EXISTS reservationDetail;
DROP TABLE IF EXISTS allocates;
DROP TABLE IF EXISTS Dine_inOrder;
DROP TABLE IF EXISTS Dine_inTable;
DROP TABLE IF EXISTS DeliveredOrders;
DROP TABLE IF EXISTS Deliver;
DROP TABLE IF EXISTS Come_free;
DROP TABLE IF EXISTS Free_items;
DROP TABLE IF EXISTS CoffeeOrder;
DROP TABLE IF EXISTS OrderDetail;
DROP TABLE IF EXISTS Menu;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Person;
DROP TABLE IF EXISTS Credit_cardDetail;

--DDL
-- Creating Person Table
create table Person(
	personId varchar(10) not null,
	f_Name varchar(20) not null,
	l_Name varchar(20) not null,
	primary key (personId)
);

-- Creating Customer Table
create table Customer(
	personId varchar(10) not null,
	email varchar(20) not null,
	contactNum varchar(20) not null,
	foreign key (personId) references Person(personId) on delete cascade,
	primary key (personId)
);

-- Creating Deliver Table
create table Deliver(
	personId varchar(10) not null,
	age int not null check(age > 21),
	salary decimal(10,2) check (salary > 0),
	foreign key (personId) references Person(personId) on delete cascade,
	primary key (personId)
);

-- Creating Credit Card Detail Table
create table Credit_cardDetail(
	cardNum varchar(16) not null,
	f_name varchar(20) not null,
	l_name varchar(20) not null,
	expiryDate date not null,
	CVV varchar(3),
	primary key (cardNum)
);

-- Creating Payment Table
create table Payment(
	paymentId varchar(20) not null,
	payMethod varchar(5) check (payMethod in ('Cash','Card')),
	price decimal(10,2) check (price > 0 and price <= 5000),
	cardNum VARCHAR(16),
	FOREIGN KEY (cardNum) REFERENCES Credit_cardDetail(cardNum),
	primary key (paymentId)
);

-- Creating Orders table
create table Orders(
	orderId varchar(10) not null,
	methods varchar(50) not null check (methods in ('Dine-in','Takeout','Delivery')),
	customerId varchar(10) not null,
	paymentId varchar(20) not null,
	foreign key (customerId) references Customer(personId),
	foreign key (paymentId) references Payment(paymentId),
	primary key (orderId)
);

-- Creating Dine-in Table Table
create table Dine_inTable(
	tableId varchar(100) not null,
	tableLocation varchar(50) check (tableLocation in ('Inside','Outside')),
	capacity int not null check (capacity between 4 and 8),
	primary key (tableId)
);

-- Creating Dine-in Table
create table Dine_inOrder(
	orderId varchar(10) not null,
	tableId varchar(100),
	gNum int not null,
	startTime timestamp not null,
	endTime timestamp not null,
	check(endTime-startTime <= '01:30:00'),
	d_state varchar(20) check (d_state in ('Available', 'Unavailable')),
	foreign key (orderId) references Orders(orderId) on delete cascade,
	foreign key (tableId) references Dine_inTable(tableId) on delete cascade,
	primary key (orderId)
);

-- Creating allocate Table
create table allocates(
	orderId varchar(10) not null,
	tableId varchar(100),
	foreign key (orderId) references Orders(orderId) on delete cascade,
	foreign key (tableId) references Dine_inTable(tableId) on delete cascade,
	primary key (orderId,tableId)
);

-- Creating Reservation Detail Table
create table reservationDetail(
	orderId varchar(10) not null,
	tableId varchar(100) not null,
	r_startTime timestamp not null,
	r_endTime timestamp not null,
	check(r_endTime-r_startTime <= '01:30:00'),
	r_state varchar(10) check (r_state in ('Confirmed', 'Cancelled')),
	foreign key (orderId) references Orders(orderId) on delete cascade,
	foreign key (tableId) references Dine_inTable(tableId) on delete cascade,
	primary key (tableId)
);

-- Creating Takeout Order Table
create table TakeoutOrders(
	orderId varchar(10) not null,
	foreign key (orderId) references Orders(orderId) on delete cascade,
	primary key (orderId)
);

-- Creating Delivered Order Table
create table DeliveredOrders(
	orderId varchar(10) not null,
	DeliverId varchar(10) not null,
	d_Fee decimal(10,2) not null check (d_Fee > 0),
	d_street varchar(50) not null,
	d_unit varchar(10) not null,
	d_date date not null,
	d_time time not null,
	d_suburbs varchar(255) not null,
	instruction varchar(255),
	foreign key (DeliverId) references Deliver(personId),
	foreign key (orderId) references Orders(orderId) on delete cascade,
	primary key (orderId)
);

--create menu table
create table Menu(
	foodId varchar(20) not null,
	f_Price decimal(10,2) not null check (f_price > 0),
	f_Category varchar(20) not null,
	foodName varchar(30) not null,
	foodSeason varchar (50) not null check (foodSeason in ('spring','summer','autumn','winter')),
	f_Description varchar(255) not null,
	primary key (foodId)
);

-- Creating Order Detail Table
create table OrderDetail(
	oDetial_Id varchar(20) not null,
	orderId varchar(10) not null,
	foodId varchar(20) not null,
	foodQuantity integer not null check(foodQuantity > 0),
	foreign key (foodId) references Menu(foodId) on delete cascade,
	foreign key (orderId) references Orders(orderId) on delete cascade,
	primary key (oDetial_Id)
);

-- Creating coffee order table
create table CoffeeOrder(
	oDetial_Id varchar(20) not null,
	cType varchar(20) not null check (cType in ('espresso', 'latte', 'cappuccino', 'long black', 'cold brew')),
	milkKind varchar(20) not null check (milkKind in ('whole', 'skim', 'soy')),
	foreign key (oDetial_Id) references OrderDetail(oDetial_Id) on delete cascade,
	primary key (oDetial_Id)
);

--Creating free items table
create table Free_items(
	free_Fid varchar(20) not null,
	foodId varchar(20) not null,
	foreign key (foodId) references Menu(foodId) on delete cascade,
	primary key (free_Fid)
);

--Creating Come free table
create table Come_free(
	free_Fid varchar(20) not null,
	foodId varchar(20) not null,
	foreign key (foodId) references Menu(foodId) on delete cascade,
	foreign key (free_Fid) references Free_items(free_Fid) on delete cascade,
	primary key (foodId,free_Fid)
);

--DML
-- Insert Person Table Data
INSERT INTO Person VALUES (2390128329,'Alice', 'Johnson');
INSERT INTO Person VALUES (1234567890,'Bob', 'Smith');
INSERT INTO Person VALUES (3420128329,'Jack', 'Fisher');
INSERT INTO Person VALUES (5344567891,'Harrison', 'Bob');
INSERT INTO Person VALUES (4921732232,'Frank', 'Job');
INSERT INTO Person VALUES (7322321233,'Ted', 'Zed');
INSERT INTO Person VALUES (4322321233,'CC', 'DD');
INSERT INTO Person VALUES (6322321233,'EEE', 'AJi');
INSERT INTO Person VALUES (2322321233,'FFF', 'DS');
INSERT INTO Person VALUES (1322321233,'SSS', 'Zq');

select * from Person;

-- Insert Customer Table Data
INSERT INTO Customer (personId, email, contactNum) VALUES (2390128329, 'alice@example.com', '1234567890');
INSERT INTO Customer (personId, email, contactNum) VALUES (1234567890, 'bob@example.com', '0987654321');
INSERT INTO Customer (personId, email, contactNum) VALUES (5344567891, 'jack@example.com', '0923234321');
INSERT INTO Customer (personId, email, contactNum) VALUES (7322321233, 'harrison@example.com', '0321324321');
INSERT INTO Customer (personId, email, contactNum) VALUES (4322321233, 'sds@example.com', '01321324321');
INSERT INTO Customer (personId, email, contactNum) VALUES (6322321233, 'aa@example.com', '0421324321');
INSERT INTO Customer (personId, email, contactNum) VALUES (2322321233, 'hsison@example.com', '0521324321');
INSERT INTO Customer (personId, email, contactNum) VALUES (1322321233, 'han@example.com', '0221324321');
select * from Customer;

-- Insert Deliver Table Data
INSERT INTO Deliver (personId, age, salary) VALUES (4921732232, 25, 50000.00);
INSERT INTO Deliver (personId, age, salary) VALUES (7322321233, 30, 75000.00);
select * from Deliver;

-- Insert Credit_cardDetail Table Data
INSERT INTO Credit_cardDetail (cardNum, f_name, l_name, expiryDate, CVV) VALUES (1234567890123456, 'Jack', 'Fisher', '2025-12-31', '123');
INSERT INTO Credit_cardDetail (cardNum, f_name, l_name, expiryDate, CVV) VALUES (9876543210987654, 'Harrison', 'Bob', '2024-11-30', '456');
INSERT INTO Credit_cardDetail (cardNum, f_name, l_name, expiryDate, CVV) VALUES (4476543210987654, 'CC', 'DD', '2022-11-30', '455');
INSERT INTO Credit_cardDetail (cardNum, f_name, l_name, expiryDate, CVV) VALUES (3376543210987654, 'EEE', 'Aji', '2023-11-30', '116');
INSERT INTO Credit_cardDetail (cardNum, f_name, l_name, expiryDate, CVV) VALUES (2276543210987654, 'FFF', 'Ds', '2024-10-30', '226');
INSERT INTO Credit_cardDetail (cardNum, f_name, l_name, expiryDate, CVV) VALUES (1176543210987654, 'SSS', 'Zq', '2024-11-20', '336');
select * from Credit_cardDetail;

-- Insert Payment Table Data
INSERT INTO Payment (paymentId, payMethod, price) VALUES (1234567891234567,'Cash', 100.99);
INSERT INTO Payment (paymentId, payMethod, price) VALUES (9203092321234567,'Cash', 50.49);
INSERT INTO Payment (paymentId, payMethod, price, cardNum) VALUES (4232327891234567,'Card', 30.99,1234567890123456);
INSERT INTO Payment (paymentId, payMethod, price, cardNum) VALUES (6534322321234567,'Card', 10.49,9876543210987654);
INSERT INTO Payment (paymentId, payMethod, price, cardNum) VALUES (4476543210987654,'Card', 50.49,4476543210987654);
INSERT INTO Payment (paymentId, payMethod, price, cardNum) VALUES (3376543210987654,'Card', 30.49,3376543210987654);
INSERT INTO Payment (paymentId, payMethod, price, cardNum) VALUES (2276543210987654,'Card', 10.49,2276543210987654);
INSERT INTO Payment (paymentId, payMethod, price, cardNum) VALUES (1176543210987654,'Card', 40.49,1176543210987654);
select * from Payment;

-- Insert Orders Table Data
INSERT INTO Orders (orderId, methods, customerId, paymentId) VALUES (2323312429,'Dine-in', 2390128329, 1234567891234567);
INSERT INTO Orders (orderId, methods, customerId, paymentId) VALUES (6734992301,'Takeout', 1234567890, 9203092321234567);
INSERT INTO Orders (orderId, methods, customerId, paymentId) VALUES (3292122324,'Delivery', 5344567891, 4232327891234567);
INSERT INTO Orders (orderId, methods, customerId, paymentId) VALUES (4543843931,'Delivery', 7322321233, 6534322321234567);
INSERT INTO Orders (orderId, methods, customerId, paymentId) VALUES (8243843931,'Dine-in', 4322321233, 4476543210987654);
INSERT INTO Orders (orderId, methods, customerId, paymentId) VALUES (1143843931,'Dine-in', 6322321233, 3376543210987654);
INSERT INTO Orders (orderId, methods, customerId, paymentId) VALUES (5543843931,'Dine-in', 2322321233, 2276543210987654);
INSERT INTO Orders (orderId, methods, customerId, paymentId) VALUES (3343843931,'Dine-in', 1322321233, 1176543210987654);
select * from Orders;

-- Insert DiningTable Table Data
INSERT INTO Dine_inTable (tableId, tableLocation, capacity) VALUES (23,'Inside', 4);
INSERT INTO Dine_inTable (tableId, tableLocation, capacity) VALUES (45,'Outside', 6);
INSERT INTO Dine_inTable (tableId, tableLocation, capacity) VALUES (1,'Outside', 6);
INSERT INTO Dine_inTable (tableId, tableLocation, capacity) VALUES (2,'Outside', 6);
INSERT INTO Dine_inTable (tableId, tableLocation, capacity) VALUES (3,'Outside', 6);
INSERT INTO Dine_inTable (tableId, tableLocation, capacity) VALUES (4,'Outside', 6);
select * from Dine_inTable;

-- Insert Dine_inOrder Table Data
INSERT INTO Dine_inOrder (orderId, tableId, gNum, startTime, endTime, d_state) VALUES (2323312429, 23, 4, '2024-03-25 18:00:00', '2024-03-25 19:30:00', 'Available');
INSERT INTO Dine_inOrder (orderId, tableId, gNum, startTime, endTime, d_state) VALUES (6734992301, 45, 6, '2024-03-28 18:30:00', '2024-03-28 20:00:00', 'Available');
INSERT INTO Dine_inOrder (orderId, tableId, gNum, startTime, endTime, d_state) VALUES (8243843931, 1, 2, '2024-03-25 12:00:00', '2024-03-25 13:30:00', 'Available');
INSERT INTO Dine_inOrder (orderId, tableId, gNum, startTime, endTime, d_state) VALUES (1143843931, 2, 5, '2024-03-28 14:30:00', '2024-03-28 15:00:00', 'Available');
INSERT INTO Dine_inOrder (orderId, tableId, gNum, startTime, endTime, d_state) VALUES (5543843931, 3, 3, '2024-04-25 11:00:00', '2024-04-25 11:30:00', 'Unavailable');
INSERT INTO Dine_inOrder (orderId, tableId, gNum, startTime, endTime, d_state) VALUES (3343843931, 4, 4, '2024-04-28 18:30:00', '2024-04-28 20:00:00', 'Unavailable');
select * from Dine_inOrder;

-- Insert allocate Table Data
INSERT INTO allocates (orderId, tableId) VALUES (2323312429, 23);
INSERT INTO allocates (orderId, tableId) VALUES (6734992301, 45);
select * from allocates;

-- Insert reservationDetail Data
INSERT INTO reservationDetail (orderId, tableId, r_startTime, r_endTime, r_state) VALUES (2323312429, 23, '2024-03-25 18:00:00', '2024-03-25 19:30:00', 'Confirmed');
INSERT INTO reservationDetail (orderId, tableId, r_startTime, r_endTime, r_state) VALUES (6734992301, 45, '2024-03-28 18:30:00', '2024-03-28 20:00:00', 'Confirmed');
INSERT INTO reservationDetail (orderId, tableId, r_startTime, r_endTime, r_state) VALUES (8243843931, 1, '2024-03-25 12:00:00', '2024-03-25 13:30:00', 'Cancelled');
INSERT INTO reservationDetail (orderId, tableId, r_startTime, r_endTime, r_state) VALUES (1143843931, 2, '2024-03-28 14:30:00', '2024-03-28 15:00:00', 'Cancelled');
INSERT INTO reservationDetail (orderId, tableId, r_startTime, r_endTime, r_state) VALUES (5543843931, 3, '2024-04-25 11:00:00', '2024-04-25 11:30:00', 'Confirmed');
INSERT INTO reservationDetail (orderId, tableId, r_startTime, r_endTime, r_state) VALUES (3343843931, 4, '2024-04-28 18:30:00', '2024-04-28 20:00:00', 'Confirmed');
select * from reservationDetail;

-- Insert TakeoutOrders Table Data
INSERT INTO TakeoutOrders (orderId) VALUES (2323312429);
INSERT INTO TakeoutOrders (orderId) VALUES (6734992301);
select * from TakeoutOrders;

-- Insert DeliveredOrders Table Data
INSERT INTO DeliveredOrders (orderId, DeliverId, d_Fee, d_street, d_unit, d_date, d_time, d_suburbs, instruction) VALUES (3292122324, 4921732232, 5.00, '123 Main St', 'Apt 1', '2024-04-01', '18:00:00', 'Suburbia', 'Leave at door');
INSERT INTO DeliveredOrders (orderId, DeliverId, d_Fee, d_street, d_unit, d_date, d_time, d_suburbs, instruction) VALUES (4543843931, 7322321233, 5.00, '456 Elm St', 'Apt 2', '2024-04-02', '18:30:00', 'Downtown', 'Call on arrival');
select * from DeliveredOrders;

-- Insert Menu Table Data
INSERT INTO Menu (foodId, f_Price, f_Category, foodName, foodSeason, f_Description) VALUES (1024, 39.99, 'Main Course', 'Grilled Salmon', 'summer', 'Freshly grilled salmon with a side of seasonal vegetables.');
INSERT INTO Menu (foodId, f_Price, f_Category, foodName, foodSeason, f_Description) VALUES (999, 14.50, 'Dessert', 'Apple Pie', 'autumn', 'Classic apple pie served with vanilla ice cream.');
select * from Menu;

-- Insert Order Detail Data
INSERT INTO OrderDetail (oDetial_Id, orderId, foodId, foodQuantity) VALUES (23, 2323312429, 1024, 2);
INSERT INTO OrderDetail (oDetial_Id, orderId, foodId, foodQuantity) VALUES (19, 6734992301, 999, 1);
select * from OrderDetail;

-- Insert Coffee Order Table Data
INSERT INTO CoffeeOrder (oDetial_Id, cType, milkKind) VALUES (23, 'latte', 'whole');
INSERT INTO CoffeeOrder (oDetial_Id, cType, milkKind) VALUES (19, 'espresso', 'soy');
select * from CoffeeOrder;

-- Insert free items table Data
INSERT INTO Free_items (free_Fid, foodId) VALUES (3191, 1024);
INSERT INTO Free_items (free_Fid, foodId) VALUES (23223, 999);
select * from Free_items;

--Insert Come free table Data
INSERT INTO Come_free(free_Fid, foodId) VALUES (3191, 1024);
INSERT INTO Come_free (free_Fid, foodId) VALUES (23223, 999);
select * from Come_free;

-- Find available tables in Dine_inOrder that are not booked.
SELECT DISTINCT Dine_inOrder.tableId
FROM Dine_inOrder
JOIN reservationDetail ON Dine_inOrder.tableId = reservationDetail.tableId
WHERE Dine_inOrder.d_state = 'Available'
AND reservationDetail.r_state = 'Cancelled';