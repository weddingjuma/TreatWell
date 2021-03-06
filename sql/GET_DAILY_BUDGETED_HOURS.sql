CREATE OR REPLACE TYPE OBJECT_DAILY_BUDGETED_HOURS IS OBJECT (
  SITE_ID NUMBER, 
  DAILY_HOURS_H NUMBER, 
  DAILY_HOURS_M NUMBER, 
  BUDGETED_HOURS NUMBER
);
/
CREATE OR REPLACE TYPE TABLE_DAILY_BUDGETED_HOURS IS TABLE OF OBJECT_DAILY_BUDGETED_HOURS;
/
CREATE OR REPLACE
FUNCTION GET_DAILY_BUDGETED_HOURS(FP_MONTH IN VARCHAR2, FP_START_DTE IN VARCHAR2, FP_END_DTE IN VARCHAR2) 
RETURN TABLE_DAILY_BUDGETED_HOURS PIPELINED IS
CURSOR CS_DAILY_BUDGETED_HOURS IS 
        SELECT DDS.SITE_ID, SUM(DDS.DAILY_HOURS_H) DAILY_HOURS_H, SUM(DDS.DAILY_HOURS_M) DAILY_HOURS_M, 
          SUM(DDS.BUDGETED_HOURS) BUDGETED_HOURS FROM ( 
               SELECT DDS.SITE_ID, SUM(SPLIT_NUMBER(NVL(DDS.SAL_QTY,0),'H')) DAILY_HOURS_H, SUM(SPLIT_NUMBER(NVL(DDS.SAL_QTY,0),'M')) DAILY_HOURS_M, 0 BUDGETED_HOURS                 
               FROM ALBERTA.DEPT_DAILY_SALE DDS 
               WHERE DDS.COA_CDE IN ('600-04-01-0001','500-01-06-0013') AND DDS.MONTH_NME=FP_MONTH 
                   AND DDS.VOUCHER_DTE BETWEEN TO_DATE(FP_START_DTE,'DD-MM-YYYY') AND TO_DATE(FP_END_DTE,'DD-MM-YYYY') 
               GROUP BY DDS.SITE_ID UNION ALL 
            SELECT QTM.SITE_ID, 0 DAILY_HOURS_H, 0 DAILY_HOURS_M, (ROUND(SUM(NVL(QTD.TARGET,0))/((LAST_DAY(TO_DATE('01'||UPPER(FP_MONTH),'DD-MON-YYYY'))-TO_DATE('01'||UPPER(FP_MONTH),'DD-MON-YYYY'))+1))*((TO_DATE(FP_END_DTE,'DD-MM-YYYY')-TO_DATE(FP_START_DTE,'DD-MM-YYYY'))+1)) BUDGETED_HOURS 
              FROM ALBERTA.QSR_TARGET_MASTER QTM,ALBERTA.QSR_TARGET_DETAIL QTD 
               WHERE QTM.QSR_TARGET_MASTER_ID=QTD.QSR_TARGET_MASTER_ID 
                   AND QTD.COA_CDE='600-04-01-0001' AND QTM.MONTH_NME=FP_MONTH 
            GROUP BY QTM.SITE_ID UNION ALL 
            SELECT ST.SITE_ID, 0 DAILY_HOURS_H, 0 DAILY_HOURS_M, (ROUND(SUM(NVL(ST.TARGET,0))/((LAST_DAY(TO_DATE('01'||UPPER(FP_MONTH),'DD-MON-YYYY'))-TO_DATE('01'||UPPER(FP_MONTH),'DD-MON-YYYY'))+1))*((TO_DATE(FP_END_DTE,'DD-MM-YYYY')-TO_DATE(FP_START_DTE,'DD-MM-YYYY'))+1)) BUDGETED_HOURS 
            FROM ALBERTA.SALES_TARGET ST 
               WHERE ST.COA_CDE='500-01-06-0013' AND ST.MONTH_NME=FP_MONTH 
            GROUP BY ST.SITE_ID
          ) DDS GROUP BY DDS.SITE_ID;
BEGIN
    FOR FL_DBH IN CS_DAILY_BUDGETED_HOURS LOOP
      PIPE ROW (OBJECT_DAILY_BUDGETED_HOURS(FL_DBH.SITE_ID, FL_DBH.DAILY_HOURS_H, FL_DBH.DAILY_HOURS_M, FL_DBH.BUDGETED_HOURS));          
    END LOOP;
  RETURN;  
END;
/




