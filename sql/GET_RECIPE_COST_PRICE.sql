CREATE OR REPLACE FUNCTION GET_RECIPE_COST_PRICE (FP_VOUCHER_DTE IN VARCHAR2,FP_COA_CDE IN VARCHAR2,FP_SALE_QTY IN NUMBER,FP_SITE_ID IN NUMBER,FP_FIN_YEAR_ID IN NUMBER,FP_COMPANY_ID IN NUMBER) 
RETURN NUMBER 
IS
CURSOR CS_RECIPE_ITEMS IS SELECT RD.COA_CDE, RD.QTY FROM RECIPE_DETAIL RD, RECIPE_MASTER RM 
                            WHERE RD.RECIPE_MASTER_ID=RM.RECIPE_MASTER_ID AND RM.COA_CDE=FP_COA_CDE
                            AND RM.SITE_ID=FP_SITE_ID AND RM.COMPANY_ID=FP_COMPANY_ID AND NVL(RD.QTY,0)<>0;
CURSOR CS_BEFORE_COST_PRICE(CP_COA_CDE IN VARCHAR2) IS SELECT NVL(VD.BEFORE_COST_PRICE,0) BEFORE_COST_PRICE
                             FROM VOUCHER_DETAIL VD, VOUCHER_MASTER VM, VOUCHER_SUB_TYPE VST
                             WHERE VD.VOUCHER_MASTER_ID = VM.VOUCHER_MASTER_ID AND VM.VOUCHER_SUB_TYP_ID = VST.VOUCHER_SUB_TYP_ID
                             AND VM.CANCELLED_BY IS NULL AND VM.POSTED_IND='Y' AND VM.SITE_ID=FP_SITE_ID
                             AND VM.VOUCHER_DTE=TO_DATE(FP_VOUCHER_DTE,'DD-MM-YYYY') 
                             AND NVL(VD.QTY,0)<>0  AND VD.COA_CDE=CP_COA_CDE
                             AND VST.VOUCHER_SUB_TYP_DESC='SI' AND VM.COMPANY_ID=FP_COMPANY_ID AND VM.FIN_YEAR_ID=FP_FIN_YEAR_ID;                            
V_RECIPE_COST_PRICE NUMBER := 0;
V_TOTAL_VALUE NUMBER := 0;
BEGIN
  V_TOTAL_VALUE := 0;
  V_RECIPE_COST_PRICE := 0;
  FOR FL_RECIPE_ITEMS IN CS_RECIPE_ITEMS LOOP
    FOR FL_BEFORE_COST_PRICE IN CS_BEFORE_COST_PRICE(FL_RECIPE_ITEMS.COA_CDE) LOOP
      IF (FL_BEFORE_COST_PRICE.BEFORE_COST_PRICE > 0) THEN
        V_TOTAL_VALUE := V_TOTAL_VALUE + ROUND(((FP_SALE_QTY * FL_RECIPE_ITEMS.QTY) * FL_BEFORE_COST_PRICE.BEFORE_COST_PRICE),2);
      END IF;  
    END LOOP;  
  END LOOP;
  IF (V_TOTAL_VALUE > 0 AND FP_SALE_QTY > 0) THEN
    V_RECIPE_COST_PRICE := ROUND((V_TOTAL_VALUE / FP_SALE_QTY),4);
  END IF;
  RETURN V_RECIPE_COST_PRICE;
END; 
/
 