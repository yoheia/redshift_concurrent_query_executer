-- Query 1
-- Restrictions on only one dimension. 
set search_path to awssampledb;
select current_schema();

select sum(lo_extendedprice*lo_discount) as revenue
from awssampledb.lineorder, awssampledb.dwdate
where lo_orderdate = d_datekey
and d_year = 1997 
and lo_discount between 1 and 3 
and lo_quantity < 24;