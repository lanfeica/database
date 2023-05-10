-- Filename: DDL command file
-- Authors: Fei Wu (040885403), Fei Lan (041055048)
-- Short description: this document create the tables and constraints based on assignment 1

DROP TABLE IF EXISTS order_has_product;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS company;
DROP TABLE IF EXISTS product_has_part;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS part;

CREATE TABLE customer(
Customer_ID		INT 			NOT NULL AUTO_INCREMENT,
Customer_Name		VARCHAR(50)		NOT NULL,
Shipping_Address	VARCHAR(50)		NULL,
Mailing_Address		VARCHAR(50)		NOT NULL,
Phone_Number		VARCHAR(20)		NOT NULL,
Credit_Limit		DECIMAL(6,2)	NOT NULL,
Discount		VARCHAR(10)		NULL,
CONSTRAINT		pk_CustomerID	PRIMARY KEY(Customer_ID)
);

CREATE TABLE company(
Company_Name		VARCHAR(20)		NOT NULL,
Company_Address		VARCHAR(50)		NULL,
Company_Phone		VARCHAR(20)		NULL,
CONSTRAINT		pk_CompanyName		PRIMARY KEY(Company_Name)
);

CREATE TABLE orders(
Order_Number		INT		NOT NULL AUTO_INCREMENT,
Order_Date		DATE		NULL,
Customer_Customer_ID	INT		NOT NULL,
Company_Company_Name	VARCHAR(20)	NOT NULL,
CONSTRAINT		pk_OrderNumber	PRIMARY KEY(Order_Number),
CONSTRAINT		fk_CustomerID	FOREIGN KEY(Customer_Customer_ID) REFERENCES customer(Customer_ID),
CONSTRAINT		fk_CompanyName	FOREIGN KEY(Company_Company_Name) REFERENCES company(Company_Name)
);

CREATE TABLE product(
Product_Code			VARCHAR(20)		NOT NULL,
Product_Description		VARCHAR(80)		NULL,
Quantity_On_Hand		INT			NULL,
Quantity_Backordered		INT			NULL,
Standard_Price			DECIMAL(6,2)		NULL,
CONSTRAINT			pk_ProductCode		PRIMARY KEY(Product_Code)
);

CREATE TABLE part(
Part_Number			VARCHAR(20)		NOT NULL,
Part_Description		VARCHAR(80)		NULL,
CONSTRAINT			pk_PartNumber		PRIMARY KEY(Part_Number)
);

CREATE TABLE order_has_product(
Order_Order_Number		INT			NOT NULL,
Product_Product_Code		VARCHAR(20)		NOT NULL,
Order_Quantity			INT			NULL,
Product_Backordered		INT			NULL,
Product_Filled			INT			NULL,
CONSTRAINT		pk_OrderNumberProductCode	PRIMARY KEY(Order_Order_Number, Product_Product_Code),
CONSTRAINT		fk_OrderNumber			FOREIGN KEY(Order_Order_Number) REFERENCES orders(Order_Number),
CONSTRAINT		fk_ProductCode1			FOREIGN KEY(Product_Product_Code) REFERENCES product(Product_Code)
);

CREATE TABLE product_has_part(
Product_Product_Code	VARCHAR(20)			NOT NULL,
Part_Part_Number	VARCHAR(20)			NOT NULL,
Part_Quantity_Required	INT				NULL,
CONSTRAINT		pk_ProductCodePartNumber	PRIMARY KEY(Product_Product_Code, Part_Part_Number),
CONSTRAINT		fk_ProductCode2			FOREIGN KEY(Product_Product_Code) REFERENCES product(Product_Code),
CONSTRAINT		fk_PartNumber			FOREIGN KEY(Part_Part_Number) REFERENCES part(Part_Number)
);