-- Filename: Test Data
-- Authors: Fei Wu (040885403), Fei Lan (041055048)
-- Short description: create data for tables

INSERT INTO customer VALUES(1001,"Lucy Blair","Ap #232-8257 Vestibulum Street","Ap #232-8257 Vestibulum Street","1-663-382-4819",1000,"");
INSERT INTO customer VALUES(1002,"Chava Page","","P.O. Box 213, 6431 Molestie Av.","(352) 758-8374",3000,"");
INSERT INTO customer VALUES(1003,"Kylan Gibbs","","Ap #205-5242 Arcu. Av","1-275-940-8683",3200,"10%");
INSERT INTO customer VALUES(1004,"Kelly Josep","681-2661 Mauris Road","Ap #160-6359 Dictum. Rd.","(514) 661-2786",2200,"");
INSERT INTO customer VALUES(1005,"Allistair Rocha","","3708 Non Ave","(625) 436-3114", 1500,"5%");

INSERT INTO company VALUES("Nec Ante Foundation","Ap #829-8106 Luctus Road","1-361-315-1478");
INSERT INTO company VALUES("Placerat Institute","Ap #324-9978 Cursus St.","(853) 657-5158");
INSERT INTO company VALUES("Arcu Vel Associates","1319 Risus, Avenue","1-430-812-5376");

INSERT INTO orders VALUES(8850,"2009-05-08",1002,"Arcu Vel Associates");
INSERT INTO orders VALUES(8851,"2022-05-14",1005,"Placerat Institute");
INSERT INTO orders VALUES(8852,"2022-06-12",1003,"Arcu Vel Associates");
INSERT INTO orders VALUES(8853,"2022-04-07",1001,"Arcu Vel Associates");
INSERT INTO orders VALUES(8854,"2022-03-30",1002,"Nec Ante Foundation");

INSERT INTO product VALUES("FR223","HALF SIZE REFRIGERATOR",5,8,750.99);
INSERT INTO product VALUES("TB101","PATIO TABLE",4,5,150);
INSERT INTO product VALUES("FR823","PATIO CHAIRS",7,0,35);
INSERT INTO product VALUES("CH089","DINNING SET",7,5,1599);
INSERT INTO product VALUES("HY428","EGG SWING",6,9,150.99);
INSERT INTO product VALUES("IK874","ROCKING CHAIR",0,7,99.99);

INSERT INTO part VALUES("WOOD223","1 X 2 - 30' WOOD");
INSERT INTO part VALUES("WOOD995","4 X 5 WOOD");
INSERT INTO part VALUES("WOOD556","7 X 4 WOOD");
INSERT INTO part VALUES("WOOD859","2 X 5 WOOD");
INSERT INTO part VALUES("SCREW110","1.25'");
INSERT INTO part VALUES("SCREW524","2.15'");
INSERT INTO part VALUES("SCREW456","1.36'");

INSERT INTO order_has_product VALUES(8850,"CH089",2,1,1);
INSERT INTO order_has_product VALUES(8852,"FR223",2,0,2);
INSERT INTO order_has_product VALUES(8852,"TB101",5,2,3);
INSERT INTO order_has_product VALUES(8852,"CH089",20,0,20);
INSERT INTO order_has_product VALUES(8853,"IK874",3,0,3);


INSERT INTO product_has_part VALUES("CH089","WOOD223",8);
INSERT INTO product_has_part VALUES("CH089","SCREW110",26);
INSERT INTO product_has_part VALUES("FR823","WOOD223",1);
INSERT INTO product_has_part VALUES("FR823","WOOD995",3);
INSERT INTO product_has_part VALUES("FR823","SCREW524",10);
INSERT INTO product_has_part VALUES("HY428","SCREW456",8);

