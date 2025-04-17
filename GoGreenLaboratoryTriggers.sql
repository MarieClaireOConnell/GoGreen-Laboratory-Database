

USE GoGreenLaboratory;
GO
/* We can enforce data integrity thanks to triggers.Triggers assist us in maintaining a records log. The client-side code is reduced by triggers, saving time and labor.
This trigger will enter the order date when a new order is created or entered into the database*/ 
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

