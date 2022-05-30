-- Query 3
-- Drill down in time to just one month 
--set search_path to awssampledb;
--select current_schema();
select count(a.*) from lineorder a, lineorder b;