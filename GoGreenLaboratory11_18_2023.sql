CREATE DATABASE GoGreenLaboratoryDatabase
GO

CREATE TABLE  LEGALIZED  (
	legalized_category_id INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,
legalized_category  text NOT NULL
);

CREATE TABLE QA_REQUIREMENTS (
	qa_id INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,
	qa_name varchar(50) NOT NULL,
	qa_description INT NOT NULL,
	
);

CREATE TABLE CATEGORIES  (
	category_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	category_description varchar(500) NOT NULL,
	
);

CREATE TABLE CUSTOMER_TYPE (
	customer_type_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	customer_type_name varchar(50),
	customer_type_description varchar(500) NOT NULL,
);

CREATE TABLE CUSTOMERS (
	customer_id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	--location_id  varchar(50) NOT NULL,
	category_id int NOT NULL,
	customer_type_id int NOT NULL,
	business_name varchar(200) NOT NULL,
	dba varchar(500),
	business_licenses varchar(50)
);

ALTER TABLE CUSTOMERS
ADD  customer_email NVARCHAR(350);
ALTER TABLE CUSTOMERS 
DROP COLUMN location_id

CREATE TABLE LOCATIONS (
    location_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    street_address varchar(100),
    postal_code varchar(50),
    city varchar(50) NOT NULL,
    state_id varchar(50),
    county_id varchar(50) NOT NULL,
    customer_id int NOT NULL

);
ALTER TABLE LOCATIONS
ADD lab_ID int; 
ALTER TABLE LOCATIONS 
ADD CONSTRAINT LabID_Location foreign key ( lab_ID) REFERENCES LABS(lab_id);

ALTER TABLE LOCATIONS 
ALTER COLUMN customer_id int; 



CREATE TABLE GOVERNING_BODY (
    state_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    location_id int NOT NULL,
    legalized_category_id int NOT NULL,
    state_name varchar(50) NOT NULL
);

CREATE TABLE GOVERNING_BODY_QA_REQUIREMENTS (
    state_id INT NOT NULL,
    qa_id INT NOT NULL,
    PRIMARY KEY (state_id, qa_id),
    FOREIGN KEY (state_id) REFERENCES GOVERNING_BODY(state_id),
    FOREIGN KEY (qa_id) REFERENCES QA_REQUIREMENTS(qa_id)
);

CREATE TABLE LABS(
lab_id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
lab_name varchar(50) NOT NULL,
location_id int NOT NULL);

ALTER TABLE LABS
ADD lab_email NVARCHAR(350);
ALTER TABLE LABS
ADD certification VARCHAR(100);
ALTER TABLE LABS
DROP COLUMN location_id;

CREATE TABLE DELIVERABLES(
delivery_id int IDENTITY(1,1) PRIMARY KEY NOT NULL, 
retesting bit,
result_status varchar(50),
results_reported bit, 
data_results_reported date,
lab_id int NOT NULL
);
ALTER TABLE DELIVERABLES 
ADD order_id INT NOT NULL;
ALTER TABLE DELIVERABLES 
ADD CONSTRAINT deliverablies_customer_order FOREIGN KEY (order_id) REFERENCES CUSTOMER_ORDERS(order_id);

CREATE TABLE EQUIPMENT (
equipment_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
equipment_name varchar(100) NOT NULL,
maintenance_requirments varchar(200),
lab_id int NOT NULL);

CREATE TABLE QC_REQUIREMENTS(
qc_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
qc_requirement varchar(50),
qc_discription varchar(500)); 

Drop table QC_REQUIREMENTS

--DROP TABLE PRODUCT_CLASSIFICATION 
CREATE TABLE PRODUCT_CLASSIFICATION(
product_classification_id VARCHAR(2) PRIMARY KEY NOT NULL,
product_classification varchar(50));

--drop TABLE LAB_TEST_PANEL
CREATE TABLE LAB_TEST_PANEL (
lab_test_panel_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
lab_test_panel_name varchar(50),
product_classification_id VARCHAR(2) NOT NULL ,
qc_id INT);

ALTER TABLE LAB_TEST_PANEL
ADD equipment_id INT ;

ALTER TABLE LAB_TEST_PANEL
drop column qc_id;

ALTER TABLE LAB_TEST_PANEL 
ADD CONSTRAINT LabTestPanel_EquipmentID Foreign Key( equipment_id) REFERENCES EQUIPMENT(equipment_id) 

--Drop TABLE LAB_TEST_REQUEST
CREATE TABLE LAB_TEST_REQUEST(
test_request_id VARCHAR(3) PRIMARY KEY NOT NULL, 
test_request_name varchar(50) NOT NULL);

CREATE TABLE LAB_TEST_REQUEST_PANEL_BRIDGE (
test_request_id VARCHAR(3) NOT NULL, 
lab_test_panel_id INT NOT NULL,
PRIMARY KEY (test_request_id, lab_test_panel_id),
FOREIGN KEY (test_request_id) REFERENCES LAB_TEST_REQUEST(test_request_id),
FOREIGN KEY (lab_test_panel_id) REFERENCES LAB_TEST_PANEL(lab_test_panel_id));

--drop Table PRODUCTS
CREATE TABLE PRODUCTS(
product_ID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
product_name varchar (100) NOT NULL,
product_classification_id varchar(2) NOT NULL,
lab_test_panel_id  int);

CREATE TABLE CUSTOMER_ORDERS (
order_ID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
delivery_id int NOT NULL,
customer_id int NOT NULL,
order_date date NOT NULL);

ALTER TABLE CUSTOMER_ORDERS -- 
DROP COLUMN delivery_id;-- dropped column and added order_id to deliverablies - would have need to create a trigger to auto fill in the FK when the PL delivery_id was created

ALTER TABLE CUSTOMER_ORDERS 
ALTER COLUMN delivery_id int NULL;
ALTER TABLE CUSTOMER_ORDERS 
ALTER COLUMN order_date date NULL;

--DROP TABLE ORDER_DETAILS
CREATE TABLE ORDER_DETAILS (
order_detail_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
product_ID INT,
order_id int);
ALTER TABLE ORDER_DETAILS
ADD CONSTRAINT FK_product_ID FOREIGN KEY (product_ID) REFERENCES PRODUCTS(product_ID)




/*drop table ORDER_PRODUCT_BRIDGE
CREATE TABLE ORDER_PRODUCT_BRIDGE (
order_detail_id INT NOT NULL,
product_ID INT NOT NULL,
PRIMARY KEY (order_detail_id, product_ID))

ALTER TABLE ORDER_PRODUCT_BRIDGE 
ADD CONSTRAINT FK_order_detail_id FOREIGN KEY (order_detail_id) REFERENCES ORDER_DETAILS(order_detail_id);
ALTER TABLE ORDER_PRODUCT_BRIDGE
ADD CONSTRAINT FK_product_ID FOREIGN KEY (product_ID) REFERENCES PRODUCTS(product_ID);*/
drop table ORDER_PRODUCT_BRIDGE-- dropped Order Product bridge because it was not needed
ALTER TABLE ORDER_PRODUCT_BRIDGE
DROP CONSTRAINT FK_order_detail_id ;
ALTER TABLE ORDER_PRODUCT_BRIDGE
DROP CONSTRAINT FK_product_ID;

ALTER TABLE CUSTOMERS 
ADD CONSTRAINT FK_customer_categories_id FOREIGN KEY (category_id) REFERENCES CATEGORIES (category_id);
ALTER TABLE CUSTOMERS
ADD CONSTRAINT FK_customer_type_id FOREIGN KEY (customer_type_id) REFERENCES  CUSTOMER_TYPE(customer_type_id);

ALTER TABLE LOCATIONS
ADD CONSTRAINT FK_locations_customer_id FOREIGN KEY (customer_id)  REFERENCES CUSTOMERS(customer_id);

ALTER TABLE GOVERNING_BODY 
ADD CONSTRAINT governing_body_legalized_category_id FOREIGN KEY (legalized_category_id) REFERENCES LEGALIZED  (legalized_category_id);

ALTER TABLE GOVERNING_BODY
ADD CONSTRAINT governing_body_location_id  FOREIGN KEY (location_id) REFERENCES LOCATIONS(location_id);

ALTER TABLE GOVERNING_BODY_QA_REQUIREMENTS
ADD CONSTRAINT GOVERNING_BODY_QA_REQUIREMENTS_qa_id  FOREIGN KEY (qa_id) REFERENCES QA_REQUIREMENTS(qa_id);	

ALTER TABLE LABS
ADD CONSTRAINT labs_location_id FOREIGN KEY (location_id) REFERENCES LOCATIONS(location_id);-- removed 

ALTER TABLE LABS 
DROP CONSTRAINT labs_location_id

ALTER TABLE DELIVERABLES
ADD CONSTRAINT delivery_labs_id FOREIGN KEY (lab_id) REFERENCES LABS(lab_id);

ALTER TABLE EQUIPMENT
ADD CONSTRAINT equipment_labs_id FOREIGN KEY (lab_id) REFERENCES LABS(lab_id);

ALTER TABLE LAB_TEST_PANEL
ADD CONSTRAINT lab_test_panel_product_classification_id FOREIGN KEY (product_classification_id) REFERENCES PRODUCT_CLASSIFICATION(product_classification_id);

ALTER TABLE LAB_TEST_PANEL
ADD CONSTRAINT lab_test_PANEL_qc_id FOREIGN KEY (qc_id) REFERENCES QC_REQUIREMENTS(qc_id);

ALTER TABLE LAB_TEST_PANEL-- dropping QC not needed for this view 
DROP CONSTRAINT lab_test_PANEL_qc_id

ALTER TABLE PRODUCTS 
ADD CONSTRAINT products_product_classification_id FOREIGN KEY ( product_classification_id) REFERENCES PRODUCT_CLASSIFICATION(product_classification_id);

ALTER TABLE PRODUCTS
ADD CONSTRAINT products_lab_test_panel_id FOREIGN KEY (lab_test_panel_id ) REFERENCES LAB_TEST_PANEL(lab_test_panel_id );

ALTER TABLE CUSTOMER_ORDERS 
ADD CONSTRAINT customer_oder_delievery_id FOREIGN KEY ( delivery_id) REFERENCES DELIVERABLES(delivery_id);-- remove FK to remove column delivery_id from table, becuase I added order_id as a FK to DeLIVERABLES 

ALTER TABLE CUSTOMER_ORDERS 
DROP CONSTRAINT customer_oder_delievery_id

ALTER TABLE CUSTOMER_ORDERS
ADD CONSTRAINT customer_order_customer_id FOREIGN KEY (customer_id ) REFERENCES CUSTOMERS(customer_id);

ALTER TABLE ORDER_DETAILS 
ADD CONSTRAINT order_details_order_id FOREIGN KEY ( order_id) REFERENCES CUSTOMER_ORDERS(order_id)

INSERT INTO LEGALIZED VALUES('Illegal');
INSERT INTO LEGALIZED  VALUES('Medical');
INSERT INTO LEGALIZED  VALUES('Recreational');
INSERT INTO LEGALIZED  VALUES('Medical/Recreational');
INSERT INTO LEGALIZED VALUES( 'Other');



INSERT INTO QA_REQUIREMENTS VALUES('Organization','');
INSERT INTO QA_REQUIREMENTS VALUES('Human Resources', '');
INSERT INTO QA_REQUIREMENTS VALUES('Standard Operating Procedures', '');
INSERT INTO QA_REQUIREMENTS VALUES('Facilities and Equipment', '');
INSERT INTO QA_REQUIREMENTS VALUES('QA Program and Testing', '');


INSERT INTO CATEGORIES  VALUES('Tier 1');
INSERT INTO CATEGORIES  VALUES('Tier 2');
INSERT INTO CATEGORIES  VALUES('Tier 3');
INSERT INTO CATEGORIES  VALUES('Tier 4');
INSERT INTO CATEGORIES  VALUES('Tier 5');



INSERT INTO CUSTOMER_TYPE  VALUES('Producer','They can produce, harvest, trim, dry, cire and package marijuana in to lots for sale at wholesale to marijuana processor licensees and to other marijuana producer.' );
INSERT INTO CUSTOMER_TYPE VALUES('Processor',	'They can process, dry, cure, package, and label useable marijuana, marijuana concentrates, and marijuana-infused products for sale at wholesale to marijuana processors and marijuana retailers');
INSERT INTO CUSTOMER_TYPE VALUES('Producer/Processor',	'They can produce, harvest, trim, dry, cire and package marijuana in to lots for sale at wholesale to marijuana processor licensees and to other marijuana producer. They can process, dry, cure, package, and label useable marijuana, marijuana concentrates, and marijuana-infused products for sale at wholesale to marijuana processors and marijuana retailers.');
INSERT INTO CUSTOMER_TYPE VALUES('Research', 'Must adhere to their research projects')
INSERT INTO CUSTOMER_TYPE VALUES('Other', 'At time time there is no other customer types I am only filling this in as part of the assigement')



INSERT INTO QC_REQUIREMENTS  VALUES ('Method Blank',  'A Method Blank is a contaminant-free, pure matrix that is used to identify possible contamination in the handling and preparation of the sample batch.')
INSERT INTO QC_REQUIREMENTS   VALUES('Matrix Spike (MS)', ' MS samples are separated into three segments. One segment is used to determine which target analytes are present, while the other two are spiked by the laboratory with a known concentration of the target analyte.')-- The spiked sample is prepared and ran together with the un-spiked samples. The amount of analyte that is recovered from the spiked sample is identified, quantified, and reported as “percent recovery”. The term “Matrix” refers to the actual material of the sample. The MS allows the laboratory to demonstrate method accuracy for particular sample materials')
INSERT INTO QC_REQUIREMENTS   VALUES('Matrix Spike Duplicate (MSD)', 'Duplicate control sample that is processed with each batch.')
INSERT INTO QC_REQUIREMENTS   VALUES('Laboratory Control Sample (LCS)', ' LCS samples are also contaminant-free and are spiked with a known concentration of the target analyte. Unlike the MS and MSD, the LCS allows the analysts to determine analyte recovery accurately, without any matrix interferences.')
INSERT INTO QC_REQUIREMENTS   VALUES('Laboratory Control Sample Duplicate (LCSD)', ' Duplicate control sample that is processed with each batch.')

INSERT INTO PRODUCT_CLASSIFICATION  VALUES ('MF','Marijuana flower') 
INSERT INTO PRODUCT_CLASSIFICATION VALUES ('IP','Intermediate Products')
INSERT INTO PRODUCT_CLASSIFICATION VALUES ('EP','End Products')
INSERT INTO PRODUCT_CLASSIFICATION VALUES ('ME','Medical Extracts')
INSERT INTO PRODUCT_CLASSIFICATION VALUES ('O','Other')


INSERT INTO LAB_TEST_REQUEST VALUES ('MC','Mositure content')
INSERT INTO LAB_TEST_REQUEST VALUES ('PA','Potency analysis')
INSERT INTO LAB_TEST_REQUEST VALUES ('FMI','foreign matter inspection')
INSERT INTO LAB_TEST_REQUEST VALUES ('MBS','Microbiological screening')
INSERT INTO LAB_TEST_REQUEST VALUES ('MTS','Mycotoxin screening') 
INSERT INTO LAB_TEST_REQUEST VALUES ('RSS','Residual Solvent Screening') 
INSERT INTO LAB_TEST_REQUEST VALUES ('HMS','Heavey Metal screening') 





INSERT INTO LAB_TEST_PANEL (lab_test_panel_name, product_classification_id) VALUES ('Lot Test Panel','MF')
INSERT INTO LAB_TEST_PANEL (lab_test_panel_name, product_classification_id) VALUES ('Mix Test Panel','IP') 
INSERT INTO LAB_TEST_PANEL (lab_test_panel_name, product_classification_id) VALUES ('Extracts Test Panel','IP')		
INSERT INTO LAB_TEST_PANEL (lab_test_panel_name, product_classification_id) VALUES ('Food Grade extract Test Panel','IP')	
INSERT INTO LAB_TEST_PANEL (lab_test_panel_name, product_classification_id) VALUES ('End Product test Panel Test Panel','EP')	

--DELETE FROM LAB_TEST_PANEL
--WHERE lab_test_panel_name>0

INSERT INTO PRODUCTS (product_name, product_classification_id, lab_test_panel_id) VALUES ('Lot of marijuana','MF','1')
INSERT INTO PRODUCTS (product_name, product_classification_id, lab_test_panel_id) VALUES ('flowers or other material that will not be extracted', 'MF',1)
INSERT INTO PRODUCTS (product_name, product_classification_id, lab_test_panel_id) VALUES ('Marijuana Mix','IP',2)
INSERT INTO PRODUCTS (product_name, product_classification_id, lab_test_panel_id) VALUES ('concentration or extract made with hydrocarbons','IP',3)
INSERT INTO PRODUCTS (product_name, product_classification_id, lab_test_panel_id) VALUES ('concentrate or extract made with CO2 extractor like hash oil','IP',3)
INSERT INTO PRODUCTS (product_name, product_classification_id, lab_test_panel_id) VALUES ('concentrate or extract made with ethanol','IP',3)
INSERT INTO PRODUCTS (product_name, product_classification_id, lab_test_panel_id) VALUES ('concentrate or extract made with approved food grade colvent','IP',4)	
INSERT INTO PRODUCTS (product_name, product_classification_id, lab_test_panel_id) VALUES ('nonsolvent','IP',3)
INSERT INTO PRODUCTS (product_name, product_classification_id, lab_test_panel_id) VALUES ('infused cooking oil or fat in solid form','IP',3)
INSERT INTO PRODUCTS (product_name, product_classification_id, lab_test_panel_id) VALUES ('Infused solid edible','EP',5) 
INSERT INTO PRODUCTS (product_name, product_classification_id, lab_test_panel_id) VALUES ('infused liquid ( like a soda or tonic)','EP',5)
INSERT INTO PRODUCTS (product_name, product_classification_id, lab_test_panel_id) VALUES ('infused topical','EP',5)
INSERT INTO PRODUCTS (product_name, product_classification_id, lab_test_panel_id) VALUES ('marijuana mix packaged( loose or rolled)','EP',5)
INSERT INTO PRODUCTS (product_name, product_classification_id, lab_test_panel_id) VALUES ('Marijuana mix infused ( loose or rolled)','EP',5)
INSERT INTO PRODUCTS (product_name, product_classification_id, lab_test_panel_id) VALUES ('Concentrate or marijuana-infused product for inhalation','EP',5)

INSERT INTO CUSTOMERS ( category_id, customer_type_id,business_name ,dba , business_licenses, customer_email) VALUES (1, 3,'BRETTS FAMILY FARM','Family Farm' ,'604 698 789', 'JJohnson@BrettsFamilyFarm')



INSERT INTO CUSTOMER_ORDERS( customer_id) VALUES (19)
INSERT INTO CUSTOMER_ORDERS( customer_id) VALUES (19)
INSERT INTO CUSTOMER_ORDERS( customer_id) VALUES (20)
INSERT INTO CUSTOMER_ORDERS( customer_id) VALUES (23)
INSERT INTO CUSTOMER_ORDERS( customer_id) VALUES (23)
INSERT INTO CUSTOMER_ORDERS( customer_id) VALUES (34)
INSERT INTO CUSTOMER_ORDERS( customer_id) VALUES (34)
INSERT INTO CUSTOMER_ORDERS( customer_id) VALUES (34)
INSERT INTO CUSTOMER_ORDERS( customer_id) VALUES (34)
INSERT INTO CUSTOMER_ORDERS( customer_id) VALUES (19)
INSERT INTO CUSTOMER_ORDERS( customer_id) VALUES (20)
INSERT INTO CUSTOMER_ORDERS( customer_id) VALUES (23)
--DELETE FROM PRODUCTS
--WHERE product_ID>0


INSERT INTO ORDER_DETAILS( product_ID, order_ID ) VALUES (16,4)
INSERT INTO ORDER_DETAILS( product_ID, order_ID ) VALUES (16,4)
INSERT INTO ORDER_DETAILS( product_ID, order_ID ) VALUES (16,4)
INSERT INTO ORDER_DETAILS( product_ID, order_ID ) VALUES (16,5)
INSERT INTO ORDER_DETAILS( product_ID, order_ID ) VALUES (16,5)
INSERT INTO ORDER_DETAILS( product_ID, order_ID ) VALUES (17,6)
INSERT INTO ORDER_DETAILS( product_ID, order_ID ) VALUES (17,5)
INSERT INTO ORDER_DETAILS( product_ID, order_ID ) VALUES (18,7)
INSERT INTO ORDER_DETAILS( product_ID, order_ID ) VALUES (16,4)
INSERT INTO ORDER_DETAILS( product_ID, order_ID ) VALUES (16,5)
INSERT INTO ORDER_DETAILS( product_ID, order_ID ) VALUES (16,4)
INSERT INTO ORDER_DETAILS( product_ID, order_ID ) VALUES (16,6)
INSERT INTO ORDER_DETAILS( product_ID, order_ID ) VALUES (16,4)
INSERT INTO ORDER_DETAILS( product_ID, order_ID ) VALUES (16,4)
INSERT INTO ORDER_DETAILS( product_ID, order_ID ) VALUES (16,4)
INSERT INTO ORDER_DETAILS( product_ID, order_ID ) VALUES (16,5)
INSERT INTO ORDER_DETAILS( product_ID, order_ID ) VALUES (16,5)
INSERT INTO ORDER_DETAILS( product_ID, order_ID ) VALUES (17,6)
INSERT INTO ORDER_DETAILS( product_ID, order_ID ) VALUES (17,5)
INSERT INTO ORDER_DETAILS( product_ID, order_ID ) VALUES (18,7)
INSERT INTO ORDER_DETAILS( product_ID, order_ID ) VALUES (16,4)
INSERT INTO ORDER_DETAILS( product_ID, order_ID ) VALUES (25,5)
INSERT INTO ORDER_DETAILS( product_ID, order_ID ) VALUES (29,4)
INSERT INTO ORDER_DETAILS( product_ID, order_ID ) VALUES (30,6)



INSERT INTO LAB_TEST_REQUEST_PANEL_BRIDGE( lab_test_panel_id,test_request_id) VALUES( 1, 'MC');
INSERT INTO LAB_TEST_REQUEST_PANEL_BRIDGE( lab_test_panel_id,test_request_id) VALUES( 1, 'PA');
INSERT INTO LAB_TEST_REQUEST_PANEL_BRIDGE( lab_test_panel_id,test_request_id) VALUES( 1, 'FMI');
INSERT INTO LAB_TEST_REQUEST_PANEL_BRIDGE( lab_test_panel_id,test_request_id) VALUES( 1, 'MBS');
INSERT INTO LAB_TEST_REQUEST_PANEL_BRIDGE ( lab_test_panel_id,test_request_id)VALUES( 1, 'MTS');

INSERT INTO LAB_TEST_REQUEST_PANEL_BRIDGE( lab_test_panel_id,test_request_id) VALUES( 2, 'MC');
INSERT INTO LAB_TEST_REQUEST_PANEL_BRIDGE( lab_test_panel_id,test_request_id) VALUES( 2, 'PA');
INSERT INTO LAB_TEST_REQUEST_PANEL_BRIDGE( lab_test_panel_id,test_request_id) VALUES( 2, 'FMI');
INSERT INTO LAB_TEST_REQUEST_PANEL_BRIDGE( lab_test_panel_id,test_request_id) VALUES( 2, 'MBS');
INSERT INTO LAB_TEST_REQUEST_PANEL_BRIDGE( lab_test_panel_id,test_request_id) VALUES( 2, 'MTS');

INSERT INTO LAB_TEST_REQUEST_PANEL_BRIDGE( lab_test_panel_id,test_request_id) VALUES( 3, 'PA');

INSERT INTO LAB_TEST_REQUEST_PANEL_BRIDGE( lab_test_panel_id,test_request_id) VALUES( 3, 'RSS');
INSERT INTO LAB_TEST_REQUEST_PANEL_BRIDGE( lab_test_panel_id,test_request_id) VALUES( 3, 'MTS');


INSERT INTO LAB_TEST_REQUEST_PANEL_BRIDGE( lab_test_panel_id,test_request_id) VALUES( 4, 'PA');
INSERT INTO LAB_TEST_REQUEST_PANEL_BRIDGE( lab_test_panel_id,test_request_id) VALUES( 4, 'RSS');
INSERT INTO LAB_TEST_REQUEST_PANEL_BRIDGE( lab_test_panel_id,test_request_id) VALUES( 4, 'MBS');
INSERT INTO LAB_TEST_REQUEST_PANEL_BRIDGE ( lab_test_panel_id,test_request_id)VALUES( 4, 'MTS');

INSERT INTO LAB_TEST_REQUEST_PANEL_BRIDGE ( lab_test_panel_id,test_request_id)VALUES( 5, 'PA');



INSERT INTO EQUIPMENT ( equipment_name, lab_id) VALUES( '1220 Infinity II Prime LC', 18)
INSERT INTO  EQUIPMENT ( equipment_name, lab_id) VALUES( '1220 Infinity II Prime LC', 19)


INSERT INTO DELIVERABLES( result_status, results_reported, lab_id,order_id ) VALUES ('uploaded','1',18,3)
INSERT INTO DELIVERABLES( result_status, results_reported, lab_id,order_id ) VALUES ('uploaded','1',18,4)
INSERT INTO DELIVERABLES( result_status, results_reported, lab_id,order_id ) VALUES ('uploaded','1',18,5)
INSERT INTO DELIVERABLES( result_status, results_reported, lab_id,order_id ) VALUES ('uploaded','1',18,6)
INSERT INTO DELIVERABLES( retesting,results_reported, lab_id,order_id ) VALUES ('1','0',18,7)
INSERT INTO DELIVERABLES( retesting,results_reported, lab_id,order_id ) VALUES ('1','0',18,9)
INSERT INTO DELIVERABLES( retesting,results_reported, lab_id,order_id ) VALUES ('1','0',18,8)

  SELECT TOP (5) [category_id]
      ,[category_description]
  FROM [GoGreenLaboratoryDatabase].[dbo].[CATEGORIES]

  SELECT TOP (10) [legalized_category_id]
      ,[legalized_category]
  FROM [GoGreenLaboratoryDatabase].[dbo].[LEGALIZED]

  SELECT TOP (10) [customer_type_id]
      ,[customer_type_name],[customer_type_description]
  FROM [GoGreenLaboratoryDatabase].[dbo].[CUSTOMER_TYPE]

  SELECT TOP (10) [qc_id]
      ,[qc_discription]
  FROM [GoGreenLaboratoryDatabase].[dbo].[QC_REQUIREMENTS]

  SELECT TOP (10) [product_classification_id]
      ,[product_classification]
  FROM [GoGreenLaboratoryDatabase].[dbo].[PRODUCT_CLASSIFICATION ]

  SELECT TOP(10) [test_request_id]
  ,[test_request_name] 
  FROM[GoGreenLaboratoryDatabase].[dbo].[LAB_TEST_REQUEST]

  SELECT TOP(10) [qa_id]
  ,[qa_name],[qa_description]
  FROM[GoGreenLaboratoryDatabase].[dbo].[QA_REQUIREMENTS]

  SELECT TOP (10) [lab_test_panel_id],
  [lab_test_panel_name],[product_classification_id ] 
FROM [GoGreenLaboratoryDatabase].[dbo].[LAB_TEST_PANEL]

  SELECT TOP (100) [product_ID],
 [product_name], [product_classification_id], [lab_test_panel_id]
FROM [GoGreenLaboratoryDatabase].[dbo].[PRODUCTS]

--DROP TABLE LAB_TEST_PANEL;
go




Create Procedure pUpdLABTESTPANEL
(@lab_test_panel_id int, 
@lab_test_panel_name varchar(50),
@product_classification_id int )
As
 Begin
  Begin Try
    Begin Transaction
	  UPDATE tbl_LAB_TEST_PANEL
	  SET lab_test_panel_name= @lab_test_panel_name,
	  product_classification_id=@product_classification_id
	  WHERE lab_test_panel_id = @lab_test_panel_id
	Commit Transaction
  End Try
  Begin Catch
    Rollback Transaction
	Print Error_Message()
    Print 'Custom Error Message'
  End Catch
 End
go

--DROP PROCEDURE pDelLABTESTPANEL
Create Procedure pDelLABTESTPANEL
(@lab_test_panel_id int
)
As
 Begin
  Begin Try
    Begin Transaction
	  DELETE FROM tblLAB_TEST_PANEL
	  WHERE lab_test_panel_id = @lab_test_panel_id
	Commit Transaction
  End Try
  Begin Catch
    Rollback Transaction
	Print Error_Message()
    Print 'Custom Error Message'
  End Catch
 End
go

Exec pDelLABTESTPANEL
 @lab_test_panel_id = 6
go
 
Select * From tblLAB_TEST_PANEL;
go



/* Complex  queries */

-- THIS query sums the total lab  requested. The lab can run this test to determine which analyzers will need calibration and controls tested prior.

SELECT Categories, COUNT(test_request_name) AS Total_Lab_Tests
FROM (
SELECT ( CASE 
		WHEN LTR.test_request_id ='FMI' THEN 'Total Foreign Matter Inspection Tests'
		WHEN LTR.test_request_id  ='HMS' THEN 'Total Heavey Metal Screening Tests'
		WHEN LTR.test_request_id  = 'MBS' THEN 'Total Microbiological Screening Tests'
		WHEN LTR.test_request_id  ='MC' THEN 'Total Mositure Content Tests'
		WHEN LTR.test_request_id  ='MTS' THEN 'Total Mycotoxin Screening Tests'
		WHEN LTR.test_request_id  ='PA' THEN 'Total Potency Analysis Tests'
		WHEN LTR.test_request_id ='RSS' THEN 'Total Residual Solvent Screening Tests'
		ELSE 'Unknonw' END) AS Categories, LTR.test_request_name
 FROM CUSTOMERS C 
Left JOIN CUSTOMER_ORDERS CO ON C.customer_id=CO.customer_id
left JOIN ORDER_DETAILS OD ON CO.order_ID=OD.order_id
Left JOIN PRODUCTS P ON OD.product_ID =P.product_ID
left JOIN LAB_TEST_PANEL LTP ON LTP.product_classification_id=P.product_classification_id
left JOIN LAB_TEST_REQUEST_PANEL_BRIDGE LTRPB ON LTRPB.lab_test_panel_id=LTP.lab_test_panel_id
left JOIN LAB_TEST_REQUEST LTR ON LTR.test_request_id=LTRPB.test_request_id  
LEFT JOIN DELIVERABLES D ON D.order_id = CO.order_id 
WHERE D.result_status is Null AND D.retesting='1'
) AS subq1
GROUP BY Categories


/***********************************need to update auto results reported to only update when 1 is entered into the results_reported column*************************************************/
--open orders group by product ID

SELECT Categories, COUNT(Sub1.Customer_id) AS TotalTestPending, Sub1.Customer_id
FROM (
    SELECT
        CASE
            WHEN OD.product_ID =16 THEN 'Lot of Marijuana'
WHEN OD.product_ID =17 THEN 'flowers or other material that will not be extracted'
WHEN OD.product_ID =18 THEN 'Marijuana Mix'
WHEN OD.product_ID =19 THEN 'concentration or extract made with hydrocarbons'
WHEN OD.product_ID =20 THEN 'concentrate or extract made with CO2 extractor like hash oil'
WHEN OD.product_ID =21 THEN 'concentrate or extract made with ethanol'
WHEN OD.product_ID =22 THEN 'concentrate or extract made with approved food grade colvent'
WHEN OD.product_ID =23 THEN 'nonsolvent'
WHEN OD.product_ID =24 THEN 'infused cooking oil or fat in solid form'
WHEN OD.product_ID =25 THEN 'Infused solid edible'
WHEN OD.product_ID =26 THEN 'infused liquid ( like a soda or tonic)'
WHEN OD.product_ID =27 THEN 'infused topical'
WHEN OD.product_ID =28 THEN 'marijuana mix packaged( loose or rolled)'
WHEN OD.product_ID =29 THEN 'Marijuana mix infused ( loose or rolled)'
WHEN OD.product_ID =30 THEN 'Concentrate or marijuana-infused product for inhalation' 
ELSE 'Other'
        END AS Categories,
        C.customer_id,
        D.data_results_reported
    FROM  CUSTOMER_ORDERS CO
	   Left JOIN CUSTOMERS C ON CO.customer_id=C.customer_id
	  Left JOIN ORDER_DETAILS OD ON CO.order_ID = OD.order_id
       LEFT JOIN PRODUCTS P ON OD.product_ID = P.product_ID
       LEFT JOIN DELIVERABLES D ON D.order_id = CO.order_id
    WHERE
        D.results_reported != '1' OR D.results_reported is Null
) AS Sub1
GROUP BY Categories, Sub1.customer_id;




/*This Prodcedure was created so when an interface is creaated employees can enter new customer information based off the business lic for correct tracking */ 

CREATE OR ALTER PROCEDURE pGetCustomerIDByBusinessLic
 (@business_licenses varchar(50),
 @customer_id int OUTPUT
 )
AS
 BEGIN
  DECLARE @Status int = 0;
  BEGIN TRY
   SELECT @customer_id = customer_id 
     FROM CUSTOMERS 
	   WHERE business_licenses= @business_licenses;
   SET @Status = +1;
  END TRY
  BEGIN CATCH
   SET @Status = -1;
  END CATCH
  RETURN @Status;
 END
go





--DROP Procedure pInsCustomerWithlocation
Create Procedure pInsCustomerWithlocation
(	@business_licenses varchar(50),
	@category_id INT,
	@customer_type_id INT,
	@business_name varchar(200),
	@dba varchar(500),
	@customer_email NVarchar(350),
    @street_address varchar(100),
    @postal_code varchar(50),
    @city varchar(50),
    @state_id varchar(50),
    @county_id varchar(50),
	@NewCustomerID INT OUTPUT
)
As
 Begin
  DECLARE @Status int = 0;
  DECLARE @customer_id int = NULL;
  DECLARE @location_id int = NULL;
  Begin Try -- Check if the customer already exists using business lic 
    EXEC @Status = pGetCustomerIDByBusinessLic
                     @business_licenses = @business_licenses,
	             @customer_id = @customer_id OUTPUT;
    IF @Status = 1 AND @customer_id IS NULL -- ran successfully and did NOT find an ID
      BEGIN
    Begin Transaction
	--Inset into Customers
	  INSERT INTO CUSTOMERS
	  (customer_email,category_id, customer_type_id, business_name, dba, business_licenses)
	  VALUES
	  (@customer_email,@category_id,@customer_type_id,@business_name, @dba, @business_licenses); 

	   SET @NewCustomerID = SCOPE_IDENTITY()--Get the identity value for the newly inserted customer

	    -- Insert into LOCATIONS
            INSERT INTO LOCATIONS
            (customer_id, street_address, postal_code, city, state_id, county_id)
            VALUES
            (@NewCustomerID, @street_address, @postal_code, @city, @state_id, @county_id); -- The key is to have the New customer ID enter as the customer_id

	 SET @location_id=SCOPE_IDENTITY()--Get the identity value for the newly inserted location ID

	Commit Transaction

	      SET @Status = +1;
	 END
   ELSE -- ran successfully, but found an ID
     RAISERROR('Customer Already Exists! See CustomerID ', 15, 1);  
  END TRY
  BEGIN CATCH
   IF @@TRANCOUNT > 0 ROLLBACK TRAN;  
   SET @Status = -1;
   DECLARE @Message nvarchar(100);
   SET @Message = CONCAT(ERROR_MESSAGE(), ' CustomerID: ', Cast(@customer_id as NVARCHAR(10)));
   RAISERROR(@Message, 15, 1);  
  END CATCH
  RETURN @Status;
 END
go


DECLARE @Status int;
DECLARE @NewID int;
-- Execute the stored procedure and capture the output parameter
EXEC @Status= pInsCustomerWithlocation
	@business_licenses= '604 404 607',
	@category_id=1,
	@customer_type_id=3,
	@business_name= 'ACADEMY OF CANNABIS ETHICS',
	@dba='123' ,
	@customer_email='AJohnson@AcademyofEthics', 
    @street_address='212019 GROUSE LN',
    @postal_code='98244',
    @city='DEMING',
    @state_id='WA' ,
    @county_id= 'Lincoln',
    @NewCustomerID = @NewID output;
-- Display the results
SELECT @Status as [Return Code Value]
SELECT CASE @Status
  WHEN +1 THEN 'Insert was successful!'
  WHEN -1 THEN 'Insert failed! Common Issues: Duplicate Data'
  END AS [Status];
SELECT * FROM CUSTOMERS;
Go

SELECT * FROM CUSTOMERS C 
left JOIN LOCATIONS L ON C.customer_id=L.customer_id




/* Stored Procedures*/

/*************************************************************************************************************************************************************/
/*** this procedure is the same above but for the lab information ***/
DECLARE @Status int;
DECLARE @lab_id int;
EXEC @Status = pGetLabByCertification
                @certification = '2356897'
               ,@lab_id = @lab_id output;

SELECT @Status as [Return Code Value], @lab_id as [CustomerID];

/* same procedure as above but for entering lab information */
CREATE OR ALTER PROCEDURE pGetLabByCertification
 (@certification varchar(100),
 @lab_id int OUTPUT
 )
AS
 BEGIN
  DECLARE @Status int = 0;
  BEGIN TRY
   SELECT @lab_id = lab_id 
     FROM LABS 
	   WHERE certification= @certification;
   SET @Status = +1;
  END TRY
  BEGIN CATCH
   SET @Status = -1;
  END CATCH
  RETURN @Status;
 END
go




--DROP Procedure  pInsLabsWithlocation
Create Procedure pInsLabsWithlocation
(	@certification VARCHAR(100),
	@lab_name varchar(50),
	@lab_email NVARCHAR(350),
	@street_address varchar(100),
    @postal_code varchar(50),
    @city varchar(50),
    @state_id varchar(50),
    @county_id varchar(50),
	@NewLabID INT OUTPUT
)
As
 Begin
  DECLARE @Status int = 0;
  DECLARE @lab_id int = NULL;
  DECLARE @location_id int = NULL;
  Begin Try -- Check if the customer already exists using business lic 
    EXEC @Status = pGetLabByCertification
                     @certification = @certification,
	             @lab_id = @lab_id OUTPUT;
    IF @Status = 1 AND @lab_id IS NULL -- ran successfully and did NOT find an ID
      BEGIN
    Begin Transaction
	--Inset into LABS
	  INSERT INTO LABS
	  (lab_name, lab_email, certification)
	  VALUES
	  (@lab_name, @lab_email, @certification); 

	   SET @NewLabID = SCOPE_IDENTITY()--Get the identity value for the newly inserted customer

	    -- Insert into LOCATIONS
            INSERT INTO LOCATIONS
            (lab_ID, street_address, postal_code, city, state_id, county_id)
            VALUES
            (@NewLabID, @street_address, @postal_code, @city, @state_id, @county_id); -- The key is to have the New lab ID enter as the lab_ID

	 SET @location_id=SCOPE_IDENTITY()--Get the identity value for the newly inserted location ID

	Commit Transaction

	      SET @Status = +1;
	 END
   ELSE -- ran successfully, but found an ID
     RAISERROR('Customer Already Exists! See LabID ', 15, 1);  
  END TRY
  BEGIN CATCH
   IF @@TRANCOUNT > 0 ROLLBACK TRAN;  
   SET @Status = -1;
   DECLARE @Message nvarchar(100);
   SET @Message = CONCAT(ERROR_MESSAGE(), ' LabID: ', Cast(@lab_id as int));
   RAISERROR(@Message, 15, 1);  
  END CATCH
  RETURN @Status;
 END
go



DECLARE @Status INT;
DECLARE @NewID INT;
-- Execute the stored procedure and capture the output parameter
EXEC @Status=  pInsLabsWithlocation
	@certification='123455552JC',
	@lab_name = 'True Northwest, Inc.',
	@lab_email='JJackson@TRUENorthwest.com', 
    @street_address='4139 Libby Rd. NE',
    @postal_code='98506',
    @city='Olympia',
    @state_id='WA' ,
    @county_id= 'Thurston',
    @NewLabID= @NewID output;
-- Display the results
SELECT @Status as [Return Code Value]
SELECT CASE @Status
  WHEN +1 THEN 'Insert was successful!'
  WHEN -1 THEN 'Insert failed! Common Issues: Duplicate Data'
  END AS [Status];
SELECT * FROM LABS;
Go


--DELETE FROM LOCATIONS  WHERE lab_ID= 17
--DELETE FROM LABS WHERE lab_id= 17

SELECT * FROM LABS 
JOIN LOCATIONS L ON LABS.lab_id=L.lab_ID


/*triggers*/
/*This trigger will enter the order date when a new order is created or entered into the database*/ 
CREATE OR ALTER TRIGGER dbo.OrderTimeStemp
ON dbo.CUSTOMER_ORDERS
AFTER INSERT, UPDATE
AS
UPDATE dbo.CUSTOMER_ORDERS
  SET order_date = GETDATE()
  FROM Inserted
  WHERE dbo.CUSTOMER_ORDERS.Customer_ID = Inserted.Customer_ID
;
GO

/*** this trigger will post the date when the results are posted, i.e. given to the customer, after entered into the database under the deliverables column results_reported ***/

CREATE OR ALTER TRIGGER dbo.ResultsReportedTimeStemp
ON dbo.DELIVERABLES
AFTER INSERT
AS
UPDATE dbo.DELIVERABLES
  SET data_results_reported= GETDATE()
  FROM Inserted
  WHERE dbo.DELIVERABLES.results_reported = Inserted.results_reported
  AND dbo.DELIVERABLES.results_reported is Not NULL AND dbo.DELIVERABLES.results_reported !='0'
;
GO


/*Computerd Columns*/

-- Add a new column to store the computed result
ALTER TABLE dbo.DELIVERABLES ADD Turn_Around_time INT; 


--Update the new column using a JOIN with the Customers table

--I used a trigger so when the results are reported the new columne will automatical calculate the turn around time. 
CREATE OR ALTER TRIGGER dbo.TurnAroundTime
ON dbo.DELIVERABLES
AFTER INSERT
as
   BEGIN
 update D
    SET Turn_Around_time = DATEDIFF(HOUR, CO.order_date, D.Data_results_reported) -- since I needed to get the order_date I needed to create a join with custormer order table  and the inserte SQL table for the trigger 
    FROM DELIVERABLES D 
    INNER JOIN INSERTED I ON D.delivery_id = I.delivery_id -- The inserte table is a SQL table in the back ground 
    INNER JOIN [CUSTOMER_ORDERS] CO ON D.order_id = CO.order_ID
    WHERE D.results_reported = I.results_reported
END;


/*************************************************************************************************************************************************************************************************/

/*** this trigger will calculate a new column to sum all the order each customer has placed***/
-- Add a new column to store the computed result
ALTER TABLE dbo.CUSTOMERS ADD Total_Orders INT;


CREATE OR ALTER TRIGGER TotalOrdersPerCustomer
ON CUSTOMER_ORDERS
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE C -- it was simple to run a quary to find the total orders per customer I used the quary and set it equal to the total_order column. 
    SET Total_Orders = (
        SELECT COUNT(order_ID)
        FROM CUSTOMER_ORDERS
        WHERE customer_id = I.customer_id
        GROUP BY customer_id
    )
    FROM CUSTOMERS C
    INNER JOIN INSERTED I ON C.customer_id = I.customer_id;-- for the trigger to wrok we needed to join the SQL INSERTED table 
END;
GO

