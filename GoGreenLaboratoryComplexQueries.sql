

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



