-- Query 2
-- Restrictions on two dimensions 
--set search_path to awssampledb;
--select current_schema();
select sum(lo_revenue), d_year, p_brand1
from awssampledb.lineorder, awssampledb.dwdate, awssampledb.part, awssampledb.supplier
where lo_orderdate = d_datekey
and lo_partkey = p_partkey
and lo_suppkey = s_suppkey
and p_category = 'MFGR#12'
and s_region = 'AMERICA'
group by d_year, p_brand1
order by d_year, p_brand1;