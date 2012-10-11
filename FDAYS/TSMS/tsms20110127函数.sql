----------------------------------------------
-- Export file for user TSMS                --
-- Created by yanrui on 2011/1/27, 16:00:07 --
----------------------------------------------

spool tsms20110127函数.log

prompt
prompt Creating function CAL_ACCOUNTID_ORDERSUBTYPE
prompt ============================================
prompt
create or replace function tsms.cal_accountId_orderSubType(orderId integer,orderSubType integer)
  return integer is
  result integer;
  accountId integer:=0;
begin
    if orderSubType=10 or orderSubType=11  then
      select s.to_account_id into accountId from statement s
        where 1=1  and s.order_Id=orderId
		    and s.order_subtype=orderSubType
		    and rownum=1;
    end if;
    if orderSubType=20 or orderSubType=21 then
      select s.to_account_id into accountId from statement s
        where 1=1  and s.order_Id=orderId
		    and s.order_subtype=orderSubType
		    and rownum=1;
    end if;

    result :=accountId;
    return result;
end cal_accountId_orderSubType;
/

prompt
prompt Creating function CAL_NAME_ACCOUNTID
prompt ====================================
prompt
create or replace function tsms.cal_name_accountId(accountId long)
  return varchar2 is
  result varchar2(50);
  accountName varchar2(50):='';
begin
    select s.name into accountName  from account s
           where s.id =accountId
           and rownum=1;
    result :=accountName;
    return result;
end cal_name_accountId;
/

prompt
prompt Creating function CAL_ACCOUNTNAME_ORDERSUBTYPE
prompt ==============================================
prompt
create or replace function tsms.cal_accountName_orderSubType(orderId integer,orderSubType integer)
  return varchar2 is
  result varchar2(50);
  accountId integer;
  accountName varchar2(50):='';
begin
    if orderSubType=10 or orderSubType=11  then
      select s.to_account_id into accountId from statement s
        where 1=1  and s.order_Id=orderId
		    and s.order_subtype=orderSubType
		    and rownum=1;
    end if;
     if orderSubType=20 or orderSubType=21  then
      select s.to_account_id into accountId from statement s
        where 1=1  and s.order_Id=orderId
		    and s.order_subtype=orderSubType
		    and rownum=1;
    end if;
   select cal_name_accountId(accountId) into accountName  from dual;

    result :=accountName;
    return result;
end cal_accountName_orderSubType;
/

prompt
prompt Creating function CAL_DRAWAMOUNT_GROUPID
prompt ========================================
prompt
create or replace function tsms.cal_drawAmount_groupId(groupId integer,orderSubType integer)
  return number is
  result number(15,2);
  totalAmount number(15,2):=0;
begin
      select sum(s.total_amount) into totalAmount from statement s
             where 1=1  and s.order_Id=(select id from airticket_order where tran_type=2 and status=5 and group_id=groupId and rownum=1)
             and s.order_subtype=orderSubType
             and rownum=1;
      if totalAmount is null then
         totalAmount:=0;
      end if;

    result :=totalAmount;
    return result;
end cal_drawAmount_groupId;
/

prompt
prompt Creating function CAL_FLIGHTCARRIER_ORDERID
prompt ===========================================
prompt
create or replace function tsms.cal_flightcarrier_orderId(orderId integer) return varchar2 is
  myresult varchar2(100):='';
  resultlength integer:=0;
  temp varchar2(100):='';
  tempLength integer:=0;
begin
    for TempObj in (select p.flight_code from  flight p,airticket_order o where p.air_order_id=o.id and o.id=orderId) loop
     if TempObj.flight_code is not null then
        temp:=substr(TempObj.flight_code,0,2);
        myresult:=myresult||temp||'/';
     end if;
    end loop;
   resultlength:=length(myresult);
   if resultlength>0 then
    myresult:=substr(myresult,0,resultlength-1);
   end if;
  return(myresult);
end cal_flightcarrier_orderId;
/

prompt
prompt Creating function CAL_FLIGHTCLASS_ORDERID
prompt =========================================
prompt
create or replace function tsms.cal_flightclass_orderId(orderId integer) return varchar2 is
  myresult varchar2(100):='';
  resultlength integer:=0;
begin
    for TempObj in (select p.flight_class from  flight p,airticket_order o where p.air_order_id=o.id and o.id=orderId) loop
     if TempObj.flight_class is not null then
       myresult:=myresult||TempObj.flight_class||'/';
     end if;
    end loop;
   resultlength:=length(myresult);
   if resultlength>0 then
    myresult:=substr(myresult,0,resultlength-1);
   end if;
  return(myresult);
end cal_flightclass_orderId;
/

prompt
prompt Creating function CAL_FLIGHTCODE_ORDERID
prompt ========================================
prompt
create or replace function tsms.cal_flightcode_orderId(orderId integer) return varchar2 is
  myresult varchar2(1000):='';
  resultlength integer:=0;
begin
    for TempObj in (select p.flight_code from  flight p,airticket_order o where p.air_order_id=o.id and o.id=orderId) loop
     if TempObj.flight_code is not null then
       myresult:=myresult||TempObj.flight_code||'/';
     end if;
    end loop;
   resultlength:=length(myresult);
   if resultlength>0 then
    myresult:=substr(myresult,0,resultlength-1);
   end if;

  return(myresult);
end cal_flightcode_orderId;
/

prompt
prompt Creating function CAL_FLIGHTEND_ORDERID
prompt =======================================
prompt
create or replace function tsms.cal_flightEnd_orderId(orderId integer) return varchar2 is
  myresult varchar2(100):='';
  --resultlength integer:=0;
begin

---返回单条 不能去指定排序的第一条
  --select p.end_point into myresult  from  flight p,airticket_order o where p.air_order_id=o.id and o.id=orderId and rownum=1;     

--返回单条，可指定排序
 select end_point into myresult from (select p.id,p.end_point,ROW_NUMBER() over( order by p.id desc) m
         from flight p, airticket_order o where p.air_order_id = o.id and o.id = orderId )   where m<2;

--返回多航程的目的地
    /*    for TempObj in (select p.end_point  from  flight p,airticket_order o where p.air_order_id=o.id and o.id=orderId) loop
     if TempObj.end_point is not null then
       myresult:=myresult||TempObj.end_point||'/';
     end if;
    end loop;
   resultlength:=length(myresult);
   if resultlength>0 then
    myresult:=substr(myresult,0,resultlength-1);
   end if;*/
  return(myresult);
end cal_flightEnd_orderId;
/

prompt
prompt Creating function CAL_FLIGHTSTART_ORDERID
prompt =========================================
prompt
create or replace function tsms.cal_flightStart_orderId(orderId integer) return varchar2 is
  myresult varchar2(100):='';
  --resultlength integer:=0;
begin
---返回单条 无法排序
 -- select p.start_point into myresult  from  flight p,airticket_order o where p.air_order_id=o.id and o.id=orderId and rownum=1 order by p.id desc;     

--返回单条，可指定排序
 select start_point into myresult from (select p.id,p.start_point,ROW_NUMBER() over( order by p.id desc) m
         from flight p, airticket_order o where p.air_order_id = o.id and o.id = orderId )   where m<2;

--返回多航程的出发地
    /*for TempObj in (select p.start_point  from  flight p,airticket_order o where p.air_order_id=o.id and o.id=orderId) loop
     if TempObj.start_point is not null then
       myresult:=myresult||TempObj.start_point||'/';
     end if;
    end loop;
   resultlength:=length(myresult);
   if resultlength>0 then
    myresult:=substr(myresult,0,resultlength-1);
   end if;*/
   
   
  return(myresult);
end cal_flightStart_orderId;
/

prompt
prompt Creating function CAL_INAMOUNT_GROUPID
prompt ======================================
prompt
create or replace function tsms.cal_inAmount_groupId(groupId integer,orderSubType integer)
  return number is
  result number(15,2);
  totalAmount number(15,2):=0;
begin
      select sum(s.total_amount) into totalAmount from statement s
             where 1=1  and s.order_Id=(select id from airticket_order where tran_type=1 and status=5 and group_id=groupId and rownum=1)
             and s.order_subtype=orderSubType
             and rownum=1;
      if totalAmount is null then
         totalAmount:=0;
      end if;

    result :=totalAmount;
    return result;
end cal_inAmount_groupId;
/

prompt
prompt Creating function CAL_NAME_PLATFORMID
prompt =====================================
prompt
create or replace function tsms.cal_name_platformId(platformId long)
  return varchar2 is
  result varchar2(50);
  platformName varchar2(50):='';
begin
    select s.name into platformName  from platform s
           where s.id =platformId
           and rownum=1;
    result :=platformName;
    return result;
end cal_name_platformId;
/

prompt
prompt Creating function CAL_NAME_USERNO
prompt =================================
prompt
create or replace function tsms.cal_name_userNo(userNo varchar2)
  return varchar2 is
  result varchar2(50);
  userName varchar2(50):='';
begin
    select s.user_name into userName  from sys_user s
           --where s.user_no like '%userNo%';
           where s.user_no =userNo
           and rownum=1;
    result :=userName;
    return result;
end cal_name_userNo;
/

prompt
prompt Creating function CAL_PASSCOUNT_ORDERID
prompt =======================================
prompt
create or replace function tsms.cal_passcount_orderId(orderId integer)
  return varchar2 is
  result varchar2(50);
  passengerCount integer:=1;
begin
    select count(p.id) into passengerCount from passenger p,airticket_order o
    where p.air_order_id=o.id
    and o.id=orderId;
    result :=passengerCount;
    return result;
end cal_passcount_orderId;
/

prompt
prompt Creating function CAL_PASSNAME_ORDERID
prompt ======================================
prompt
create or replace function tsms.cal_passname_orderId(orderId integer) return varchar2 is
  PassengerName varchar2(1000):='';
  PassengerLength integer:=0;
begin
    for TempName in (select p.name from  passenger p,airticket_order o where p.air_order_id=o.id and o.id=orderId) loop
     if TempName.name is not null then
       PassengerName:=PassengerName||TempName.name||'/';
     end if;
    end loop;
   PassengerLength:=length(PassengerName);
   if PassengerLength>0 then
      --PassengerName:=PassengerName;
    PassengerName:=substr(PassengerName,0,PassengerLength-1);
   end if;

  return(PassengerName);
end cal_passname_orderId;
/

prompt
prompt Creating function CAL_SAMOUNT_ORDERID
prompt =====================================
prompt
create or replace function tsms.cal_SAmount_orderId(orderId integer,orderSubType integer)
  return number is
  result number(15,2);
  totalAmount number(15,2):=0;
begin
      select sum(s.total_amount) into totalAmount from statement s
             where 1=1  and s.order_Id=orderId
             and s.order_subtype=orderSubType
             and rownum=1;
      if totalAmount is null then
         totalAmount:=0;
      end if;

    result :=totalAmount;
    return result;
end cal_SAmount_orderId;
/

prompt
prompt Creating function CAL_SAMOUNT_ORDERSUBTYPE
prompt ==========================================
prompt
create or replace function tsms.cal_sAmount_orderSubType(orderId integer,orderSubType integer)
  return number is
  result number(15,2);
  totalAmount number(15,2):=0;
begin
      select sum(s.total_amount) into totalAmount from statement s
             where 1=1  and s.order_Id=orderId
             and s.order_subtype=orderSubType
             and rownum=1;
      if totalAmount is null then
         totalAmount:=0;
      end if;

    result :=totalAmount;
    return result;
end cal_sAmount_orderSubType;
/

prompt
prompt Creating function CAL_TOTALTICKETPRICE_ORDERID
prompt ==============================================
prompt
create or replace function tsms.cal_totalTicketPrice_orderId(orderId integer,ticketPrice number)
  return number is
  result number(15,2);
  passcount integer:=1;
  totalTicketPrice number(15,2):=0;
begin
    select cal_passCount_orderId(orderId) into passcount  from dual;
    totalTicketPrice=ticketPrice*passcount;

    result :=totalTicketPrice;
    return result;
end cal_totalTicketPrice_orderId;
/

prompt
prompt Creating function MUL
prompt =====================
prompt
create or replace function tsms.mul
      return   varchar2
  is
      l_mul   number;
  begin
              for   x   in   (   select   value   from   mytab   )   loop
                      l_mul   :=   l_mul   *   x.value;
              end   loop;
              return   l_mul;
  end;
/


spool off
