


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




