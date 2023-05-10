-- 
-- Lab 7 creation script for CST2355
--
-- Created by:  Fei Lan
-- Based on database from lab6
--
-- should be run while connected as 'sys as sysdba'
--

-- Create STORAGE
CREATE TABLESPACE cst2355
  DATAFILE 'cst2355.dat' SIZE 40M 
  ONLINE; 
  
-- Create Users
CREATE USER lanUser IDENTIFIED BY lanPassword ACCOUNT UNLOCK
	DEFAULT TABLESPACE cst2355
	QUOTA 20M ON cst2355;
	
CREATE USER testUser IDENTIFIED BY testPassword ACCOUNT UNLOCK
	DEFAULT TABLESPACE cst2355
	QUOTA 5M ON cst2355;
	
-- Create ROLES
CREATE ROLE applicationAdmin;
CREATE ROLE applicationUser;

-- Grant PRIVILEGES
GRANT CONNECT, RESOURCE, CREATE VIEW, CREATE TRIGGER, CREATE PROCEDURE TO applicationAdmin;
GRANT CONNECT, RESOURCE TO applicationUser;

GRANT applicationAdmin TO lanUser;
GRANT applicationUser TO testUser;

-- NOW we can connect as the applicationAdmin and create the stored procedures, tables, and triggers

CONNECT lanUser/lanPassword;

--
-- Stored procedures for use by triggers
--

CREATE OR REPLACE PROCEDURE sp_checkInvalidPostalCode(postalcode IN VARCHAR)
AS
BEGIN
	-- Check the format is OK, otherwise throw a unique error
	IF NOT REGEXP_LIKE (postalcode, '[A-Z][0-9][A-Z][0-9][A-Z][0-9]')  THEN
		RAISE_APPLICATION_ERROR (-20000, 'The postal code must be 6 characters in length of the form: "A9A9A9"!');
	END IF;	
END;
/

CREATE OR REPLACE PROCEDURE sp_checkInvalidTelephone(telnumber IN VARCHAR)
AS
BEGIN
	-- Check the format is OK, otherwise throw a unique error
	IF  telnumber NOT LIKE '(___) ___-____'  THEN
		RAISE_APPLICATION_ERROR (-20000, 'The telepone number must be of the form: "(xxx) xxx-xxxx"!');
	END IF;	
END; 
/

CREATE TABLE address (
  idaddress int NOT NULL,
  street varchar(45) NOT NULL,
  city varchar(45) NOT NULL,
  province varchar(45) NOT NULL,
  postalcode varchar(45) NOT NULL,
  PRIMARY KEY (idaddress)
);

CREATE OR REPLACE TRIGGER address_check
BEFORE INSERT OR UPDATE 
ON address
FOR EACH ROW 
DECLARE 
	var_pc	varchar(45) := :NEW.postalcode;
BEGIN
	sp_checkInvalidPostalCode(var_pc);
END;
/

INSERT INTO address VALUES (1,'123 Blake Street','Guelph','Ontario','K2J0G3');
INSERT INTO address VALUES (2,'234 Derek Drive','Toronto','Ontario','M5W1E5');
INSERT INTO address VALUES (3,'1 Lewis Street','Ottawa','Ontario','K2S1E6');
INSERT INTO address VALUES (4,'78 Patterson Street','Ottawa','Ontario','K1G7E3');
INSERT INTO address VALUES (5,'2-67 Rideau Court','Ottawa','Ontario','K1K1H0');
INSERT INTO address VALUES (6,'1 North Pole Circle','North Pole','Nunavut','H2J0H0');
INSERT INTO address VALUES (7,'2 North Pole Circle','North Pole','Nunavut','H0J0H1');
INSERT INTO address VALUES (8,'11 Lewis Street','Ottawa','Ontario','K2S1E6');


CREATE TABLE cname (
  idname int NOT NULL,
  firstname varchar(20) NOT NULL,
  lastname varchar(45) NOT NULL,
  PRIMARY KEY (idname)
);

INSERT INTO cname VALUES (1,'John','Smith');
INSERT INTO cname VALUES (2,'Jane','Smith');
INSERT INTO cname VALUES (3,'Jane','Lewis');
INSERT INTO cname VALUES (4,'Tom','Jones');
INSERT INTO cname VALUES (5,'Tim','Richards');
INSERT INTO cname VALUES (6,'Tom','Richards');
INSERT INTO cname VALUES (7,'Ricky','Edwards');
INSERT INTO cname VALUES (8,'Flexon','Wringer');

CREATE TABLE customer (
  idcustomer int NOT NULL,
  birthdate timestamp NOT NULL,
  password varchar(45) NOT NULL,
  PRIMARY KEY (idcustomer)
);

INSERT INTO customer VALUES (1,to_timestamp('2000-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),'asdfasdf');
INSERT INTO customer VALUES (2,to_timestamp('1999-02-03 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),'qwert');
INSERT INTO customer VALUES (3,to_timestamp('2002-03-12 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),'xzcv');
INSERT INTO customer VALUES (4,to_timestamp('1995-10-23 12:12:00', 'YYYY-MM-DD HH24:MI:SS'),'noonnoon');
INSERT INTO customer VALUES (5,to_timestamp('1992-08-09 08:00:00', 'YYYY-MM-DD HH24:MI:SS'),'poipoi');
INSERT INTO customer VALUES (6,to_timestamp('2001-07-22 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),'lkjlkj');

CREATE TABLE customer_address (
  idcustomer_address int NOT NULL,
  startdate timestamp NOT NULL,
  enddate timestamp DEFAULT NULL,
  customer_idcustomer int NOT NULL,
  address_idaddress int NOT NULL,
  PRIMARY KEY (idcustomer_address),
  CONSTRAINT fk_c_a_a1 FOREIGN KEY (address_idaddress) REFERENCES address (idaddress),
  CONSTRAINT fk_c_a_c1 FOREIGN KEY (customer_idcustomer) REFERENCES customer (idcustomer)
);

INSERT INTO customer_address VALUES (1,to_timestamp('2018-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),to_timestamp('2018-10-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),1,1);
INSERT INTO customer_address VALUES (2,to_timestamp('2018-10-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),NULL,1,2);
INSERT INTO customer_address VALUES (3,to_timestamp('2017-02-03 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),NULL,2,3);
INSERT INTO customer_address VALUES (4,to_timestamp('2018-01-02 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),to_timestamp('2018-10-09 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),3,4);
INSERT INTO customer_address VALUES (5,to_timestamp('2013-05-22 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),NULL,4,5);
INSERT INTO customer_address VALUES (6,to_timestamp('2018-09-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),NULL,5,6);
INSERT INTO customer_address VALUES (7,to_timestamp('2016-04-22 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),NULL,6,7);
INSERT INTO customer_address VALUES (8,to_timestamp('2018-10-09 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),NULL,3,8);

CREATE TABLE customer_name (
  idcustomer_name int NOT NULL,
  startdate timestamp NOT NULL,
  enddate timestamp DEFAULT NULL,
  customer_idcustomer int NOT NULL,
  name_idname int NOT NULL,
  PRIMARY KEY (idcustomer_name),
  CONSTRAINT fk_c_c1 FOREIGN KEY (customer_idcustomer) REFERENCES customer (idcustomer),
  CONSTRAINT fk_c_n1 FOREIGN KEY (name_idname) REFERENCES cname (idname)
);

INSERT INTO customer_name VALUES (1,to_timestamp('1999-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),NULL,1,1);
INSERT INTO customer_name VALUES (2,to_timestamp('1999-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),to_timestamp('2018-10-10 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),2,2);
INSERT INTO customer_name VALUES (3,to_timestamp('1999-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),NULL,3,4);
INSERT INTO customer_name VALUES (4,to_timestamp('1999-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),to_timestamp('2018-09-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),4,5);
INSERT INTO customer_name VALUES (5,to_timestamp('1999-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),NULL,5,7);
INSERT INTO customer_name VALUES (6,to_timestamp('1999-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),NULL,6,8);
INSERT INTO customer_name VALUES (7,to_timestamp('2018-10-10 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),NULL,2,3);
INSERT INTO customer_name VALUES (8,to_timestamp('2018-09-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),NULL,4,6);


--
-- Table structure for table `telephone`
--

CREATE TABLE telephone (
  idtelephone int NOT NULL,
  telephonetype varchar(45) NOT NULL,
  telephonenumber varchar(45) NOT NULL,
  PRIMARY KEY (idtelephone)
);

CREATE OR REPLACE TRIGGER telephone_check
BEFORE INSERT OR UPDATE 
ON telephone
FOR EACH ROW 
DECLARE 
	var_tel	varchar(45) := :NEW.telephonenumber;
BEGIN
	sp_checkInvalidTelephone (var_tel);
END;
/

INSERT INTO telephone VALUES (1,'home','(613) 987-6543');
INSERT INTO telephone VALUES (2,'cottage','(519) 898-7878');
INSERT INTO telephone VALUES (3,'work','(902) 345-6789');
INSERT INTO telephone VALUES (4,'home','(416) 778-5656');
INSERT INTO telephone VALUES (5,'work','(613) 678-4567');
INSERT INTO telephone VALUES (6,'work','(613) 678-4568');

CREATE TABLE customer_telephone (
  idcustomer_telephone int NOT NULL,
  startdate timestamp NOT NULL,
  enddate timestamp DEFAULT NULL,
  customer_idcustomer int NOT NULL,
  telephone_idtelephone int NOT NULL,
  PRIMARY KEY (idcustomer_telephone),
  CONSTRAINT fk_ct_c1 FOREIGN KEY (customer_idcustomer) REFERENCES customer (idcustomer),
  CONSTRAINT fk_ct_t1 FOREIGN KEY (telephone_idtelephone) REFERENCES telephone (idtelephone)
);

INSERT INTO customer_telephone VALUES (1,to_timestamp('1999-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),NULL,1,1);
INSERT INTO customer_telephone VALUES (2,to_timestamp('1999-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),NULL,2,2);
INSERT INTO customer_telephone VALUES (3,to_timestamp('1999-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),to_timestamp('2018-09-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),3,3);
INSERT INTO customer_telephone VALUES (4,to_timestamp('1999-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),NULL,4,4);
INSERT INTO customer_telephone VALUES (5,to_timestamp('1999-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),NULL,5,5);
INSERT INTO customer_telephone VALUES (6,to_timestamp('2018-09-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),NULL,3,6);

CREATE TABLE product (
  idproduct int NOT NULL,
  name varchar(45) NOT NULL,
  description varchar(45) NOT NULL,
  price decimal(10,2) NOT NULL,
  PRIMARY KEY (idproduct)
);

INSERT INTO product VALUES (1,'Basmati Rice','new crop - 1kg',7.99);
INSERT INTO product VALUES (2,'Jasmine Rice','Indian first rate - 1kg',4.99);
INSERT INTO product VALUES (3,'Cream of Wheat','very fine grain - 10kg',12.34);
INSERT INTO product VALUES (4,'Strip Loin Steak','AAA grade per kilo',23.99);
INSERT INTO product VALUES (5,'Chicken Breast','Boneless, skinless per kilo',8.80);
INSERT INTO product VALUES (6,'Pepperoni Pizza','Frozen 40cm',8.99);

CREATE TABLE retaillocation (
  idretaillocation int NOT NULL,
  telephonenumber varchar(45) NOT NULL,
  streetaddress varchar(45) NOT NULL,
  city varchar(45) NOT NULL,
  province varchar(45) NOT NULL,
  postalcode varchar(45) NOT NULL,
  PRIMARY KEY (idretaillocation)
);

CREATE OR REPLACE TRIGGER retaillocation_check
BEFORE INSERT OR UPDATE 
ON retaillocation
FOR EACH ROW 
DECLARE 
	var_pc	varchar(45) := :NEW.postalcode;
        var_tn  varchar(45) := :NEW.telephonenumber;
BEGIN
	sp_checkInvalidPostalCode (var_pc);
        sp_checkInvalidTelephone (var_tn);
END;
/

INSERT INTO retaillocation VALUES (1,'(416) 456-7890','12 Bank Street','Toronto','Ontario','K2J2G4');
INSERT INTO retaillocation VALUES (2,'(613) 567-8901','23 Rideau Street','Ottawa','Ontario','A1N3G5');
INSERT INTO retaillocation VALUES (3,'(613) 678-9012','34 Sussex Drive','Ottawa','Ontario','K2G2S7');
INSERT INTO retaillocation VALUES (4,'(519) 789-0123','100 College Avenue','Guelph','Ontario','N1H2G3');


CREATE TABLE product_retaillocation (
  idproduct_retaillocation int NOT NULL,
  quantityonhand int NOT NULL,
  product_idproduct int NOT NULL,
  retaillocation_id int NOT NULL,
  PRIMARY KEY (idproduct_retaillocation),
  CONSTRAINT fk_p_r_p1 FOREIGN KEY (product_idproduct) REFERENCES product (idproduct),
  CONSTRAINT fk_p_r_r1 FOREIGN KEY (retaillocation_id) REFERENCES retaillocation (idretaillocation)
);

INSERT INTO product_retaillocation VALUES (1,50,1,1);
INSERT INTO product_retaillocation VALUES (2,20,2,1);
INSERT INTO product_retaillocation VALUES (3,30,3,1);
INSERT INTO product_retaillocation VALUES (4,20,4,1);
INSERT INTO product_retaillocation VALUES (5,20,5,1);
INSERT INTO product_retaillocation VALUES (6,10,6,1);
INSERT INTO product_retaillocation VALUES (7,23,1,2);
INSERT INTO product_retaillocation VALUES (8,34,2,2);
INSERT INTO product_retaillocation VALUES (9,25,3,2);
INSERT INTO product_retaillocation VALUES (10,25,4,2);
INSERT INTO product_retaillocation VALUES (11,10,5,2);
INSERT INTO product_retaillocation VALUES (12,23,6,2);
INSERT INTO product_retaillocation VALUES (13,24,1,3);
INSERT INTO product_retaillocation VALUES (14,23,2,3);
INSERT INTO product_retaillocation VALUES (15,34,3,3);
INSERT INTO product_retaillocation VALUES (16,23,4,3);
INSERT INTO product_retaillocation VALUES (17,24,5,3);
INSERT INTO product_retaillocation VALUES (18,14,6,3);
INSERT INTO product_retaillocation VALUES (19,25,1,4);
INSERT INTO product_retaillocation VALUES (20,35,2,4);
INSERT INTO product_retaillocation VALUES (21,24,3,4);
INSERT INTO product_retaillocation VALUES (22,35,4,4);
INSERT INTO product_retaillocation VALUES (23,22,5,4);
INSERT INTO product_retaillocation VALUES (24,21,6,4);

CREATE TABLE purchase (
  idorder int NOT NULL,
  quantity int NOT NULL,
  customer_id int NOT NULL,
  product_id int NOT NULL,
  retaillocation_id int NOT NULL,
  PRIMARY KEY (idorder),
  CONSTRAINT fk_p_c1 FOREIGN KEY (customer_id) REFERENCES customer (idcustomer),
  CONSTRAINT fk_p_p1 FOREIGN KEY (product_id) REFERENCES product (idproduct),
  CONSTRAINT fk_p_r1 FOREIGN KEY (retaillocation_id) REFERENCES retaillocation (idretaillocation)
);

INSERT INTO purchase VALUES (1,2,3,2,3);
INSERT INTO purchase VALUES (2,3,1,1,2);
INSERT INTO purchase VALUES (3,4,3,2,4);
INSERT INTO purchase VALUES (4,5,6,3,3);
INSERT INTO purchase VALUES (5,3,4,4,1);
INSERT INTO purchase VALUES (6,2,2,3,3);
INSERT INTO purchase VALUES (7,5,3,2,2);
INSERT INTO purchase VALUES (8,6,2,1,4);
INSERT INTO purchase VALUES (9,4,4,2,3);
INSERT INTO purchase VALUES (10,3,2,3,2);
INSERT INTO purchase VALUES (11,7,1,2,1);

COMMIT;

-- End of File
