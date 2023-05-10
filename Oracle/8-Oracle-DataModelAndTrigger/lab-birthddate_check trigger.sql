CREATE OR REPLACE TRIGGER birthdate_check
AFTER INSERT OR UPDATE 
ON CUSTOMER
FOR EACH ROW 
DECLARE 
	op UNDER18_CUSTOMERS.Operation%TYPE;
BEGIN
	IF INSERTING THEN
        op := 'Insert';
    ELSIF UPDATING THEN
        op := 'Update';
    END IF;
    
    IF trunc(months_between(sysdate, :NEW.birthdate)/12) < 18 THEN
        INSERT INTO UNDER18_CUSTOMERS VALUES (UNDER18_SEQ.nextval, :NEW.IDCUSTOMER, op, sysdate, 'lanUser');
    END IF;
END;
/