----------------------------------------------
-- Export file for user TSMSADMIN           --
-- Created by yanrui on 2011/1/27, 15:58:15 --
----------------------------------------------

spool tsms20110127ађСа.log

prompt
prompt Creating sequence SEQ_ACCOUNT
prompt =============================
prompt
create sequence TSMSADMIN.SEQ_ACCOUNT
minvalue 1
maxvalue 999999999999999999999999999
start with 515
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_ACCOUNTCHECK
prompt ==================================
prompt
create sequence TSMSADMIN.SEQ_ACCOUNTCHECK
minvalue 1
maxvalue 999999999999999999999999999
start with 1329
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_AGENT
prompt ===========================
prompt
create sequence TSMSADMIN.SEQ_AGENT
minvalue 1
maxvalue 999999999999999999999999999
start with 640
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_AIRTICKETORDER
prompt ====================================
prompt
create sequence TSMSADMIN.SEQ_AIRTICKETORDER
minvalue 1
maxvalue 999999999999999999999999999
start with 181645006
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_COMPANY
prompt =============================
prompt
create sequence TSMSADMIN.SEQ_COMPANY
minvalue 1
maxvalue 999999999999999999999999999
start with 530
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_LOGDETAIL
prompt ===============================
prompt
create sequence TSMSADMIN.SEQ_LOGDETAIL
minvalue 1
maxvalue 999999999999999999999999999
start with 508
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_LOGINLOG
prompt ==============================
prompt
create sequence TSMSADMIN.SEQ_LOGINLOG
minvalue 1
maxvalue 999999999999999999999999999
start with 14535
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_NO
prompt ========================
prompt
create sequence TSMSADMIN.SEQ_NO
minvalue 1
maxvalue 999999999999999999999999999
start with 730
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_ORDERGROUP
prompt ================================
prompt
create sequence TSMSADMIN.SEQ_ORDERGROUP
minvalue 1
maxvalue 999999999999999999999999999
start with 86837
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_PAYMENTTOOL
prompt =================================
prompt
create sequence TSMSADMIN.SEQ_PAYMENTTOOL
minvalue 1
maxvalue 999999999999999999999999999
start with 510
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_PLATCOMACCOUNT
prompt ====================================
prompt
create sequence TSMSADMIN.SEQ_PLATCOMACCOUNT
minvalue 1
maxvalue 999999999999999999999999999
start with 635
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_PLATFORM
prompt ==============================
prompt
create sequence TSMSADMIN.SEQ_PLATFORM
minvalue 1
maxvalue 999999999999999999999999999
start with 512
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_ROLE
prompt ==========================
prompt
create sequence TSMSADMIN.SEQ_ROLE
minvalue 1
maxvalue 999999999999999999999999999
start with 616
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_ROLERIGHT
prompt ===============================
prompt
create sequence TSMSADMIN.SEQ_ROLERIGHT
minvalue 1
maxvalue 999999999999999999999999999
start with 634
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_STATEMENT
prompt ===============================
prompt
create sequence TSMSADMIN.SEQ_STATEMENT
minvalue 1
maxvalue 999999999999999999999999999
start with 185049005
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_SYSLOG
prompt ============================
prompt
create sequence TSMSADMIN.SEQ_SYSLOG
minvalue 1
maxvalue 999999999999999999999999999
start with 608
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_SYSUSER
prompt =============================
prompt
create sequence TSMSADMIN.SEQ_SYSUSER
minvalue 1
maxvalue 999999999999999999999999999
start with 620
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_TICKETLOG
prompt ===============================
prompt
create sequence TSMSADMIN.SEQ_TICKETLOG
minvalue 1
maxvalue 999999999999999999999999999
start with 93564734025
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_USERROLE
prompt ==============================
prompt
create sequence TSMSADMIN.SEQ_USERROLE
minvalue 1
maxvalue 999999999999999999999999999
start with 1154
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_USERROLERIGHT
prompt ===================================
prompt
create sequence TSMSADMIN.SEQ_USERROLERIGHT
minvalue 1
maxvalue 999999999999999999999999999
start with 3006
increment by 1
nocache;


spool off
