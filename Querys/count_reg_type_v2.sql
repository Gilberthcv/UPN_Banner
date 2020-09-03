SET pages 0
set lines 132
column nl newline
spool count_reg_type.lst
select 'Subject: StuReg UPN' from dual;
select '===================================================================================' nl from dual;
select 'RA: Registration by Advisor | RE: Registration via Banner | RW: Registration by Web' nl from dual;
-- select 'TERMS: 219435  219534' from dual;
select '===================================================================================' nl from dual;
set pages 55
select sfrstcr_term_code||'-'||sfrstcr_rsts_code Reg_Type, count(distinct(sfrstcr_pidm)) Total_Count
from sfrstcr
where sfrstcr_rsts_code in ('RA','RE','RW') and sfrstcr_term_code in ('220534','220435','220735','220736')
group by sfrstcr_term_code||'-'||sfrstcr_rsts_code
order by sfrstcr_term_code||'-'||sfrstcr_rsts_code
/
set head on;
SELECT CASE SUBSTR(sfrstcr_term_code,4,1) WHEN '4' THEN 'Pregrado' WHEN '5' THEN 'Pregrado' WHEN '7' THEN 'Ingles' END nivel
	, count(distinct(sfrstcr_pidm)) Total_Count
from sfrstcr
where sfrstcr_rsts_code in ('RA','RE','RW') and sfrstcr_term_code in ('220534','220435','220735','220736')
group by CASE SUBSTR(sfrstcr_term_code,4,1) WHEN '4' THEN 'Pregrado' WHEN '5' THEN 'Pregrado' WHEN '7' THEN 'Ingles' END
order by CASE SUBSTR(sfrstcr_term_code,4,1) WHEN '4' THEN 'Pregrado' WHEN '5' THEN 'Pregrado' WHEN '7' THEN 'Ingles' END
/
set head off;
select 'Terms total:                               '|| count(distinct(sfrstcr_pidm)) Total_Count
from sfrstcr
where sfrstcr_rsts_code in ('RA','RE','RW') and sfrstcr_term_code in ('220534','220435','220735','220736')
/
set head on;
select sfrstcr_term_code||'-'||sfrstcr_rsts_code Reg_Type, count(distinct(sfrstcr_pidm)) Today
from sfrstcr
where sfrstcr_rsts_code in ('RA','RE','RW') and sfrstcr_term_code in ('220534','220435','220735','220736') and trunc(sfrstcr_activity_date) like trunc(sysdate)
group by sfrstcr_term_code||'-'||sfrstcr_rsts_code
order by sfrstcr_term_code||'-'||sfrstcr_rsts_code
/
set head on;
SELECT CASE SUBSTR(sfrstcr_term_code,4,1) WHEN '4' THEN 'Pregrado' WHEN '5' THEN 'Pregrado' WHEN '7' THEN 'Ingles' END nivel
	, count(distinct(sfrstcr_pidm)) Today
from sfrstcr
where sfrstcr_rsts_code in ('RA','RE','RW') and sfrstcr_term_code in ('220534','220435','220735','220736') and trunc(sfrstcr_activity_date) like trunc(sysdate)
group by CASE SUBSTR(sfrstcr_term_code,4,1) WHEN '4' THEN 'Pregrado' WHEN '5' THEN 'Pregrado' WHEN '7' THEN 'Ingles' END
order by CASE SUBSTR(sfrstcr_term_code,4,1) WHEN '4' THEN 'Pregrado' WHEN '5' THEN 'Pregrado' WHEN '7' THEN 'Ingles' END
/
set head off;
select 'Today totals:                              '|| count(distinct(sfrstcr_pidm)) Today
from sfrstcr
where sfrstcr_rsts_code in ('RA','RE','RW') and sfrstcr_term_code in ('220534','220435','220735','220736') and trunc(sfrstcr_activity_date) like trunc(sysdate)
/
exit;
