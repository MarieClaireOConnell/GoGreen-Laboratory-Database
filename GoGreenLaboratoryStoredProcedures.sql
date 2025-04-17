

USE GoGreenLaboratory;
GO 
/*DECLARE @Status int;
DECLARE @customer_id int;
EXEC @Status = pGetCustomerIDByBusinessLic
                @business_licenses = '604 404 607'
               ,@customer_id = @customer_id output;

SELECT @Status as [Return Code Value], @customer_id as [CustomerID]*/



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