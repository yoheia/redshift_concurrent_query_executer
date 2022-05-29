-- current timestamp
select getdate()||' (UTC)' as started_at;

--timing on
\timing on

--pager off
\pset pager

revoke usage on schema public, awssampledb from group dwh_batch_group, group dwh_tool_group, group adhoc_l1_group, group adhoc_l2_group;

revoke all on all tables in schema public, awssampledb from group dwh_batch_group;  
revoke all on all tables in schema public, awssampledb from group dwh_tool_group;  
revoke all on all tables in schema public, awssampledb from group adhoc_l1_group;  
revoke all on all tables in schema public, awssampledb from group adhoc_l2_group;  

drop group dwh_batch_group;
drop group dwh_tool_group;
drop group adhoc_l1_group;
drop group adhoc_l2_group;

create group dwh_batch_group;
create group dwh_tool_group;
create group adhoc_l1_group;
create group adhoc_l2_group;

grant usage on schema public, awssampledb to group dwh_batch_group, group dwh_tool_group, group adhoc_l1_group, group adhoc_l2_group;

grant all on all tables in schema public, awssampledb to group dwh_batch_group;
grant all on all tables in schema public, awssampledb to group dwh_tool_group;
grant all on all tables in schema public, awssampledb to group adhoc_l1_group;
grant all on all tables in schema public, awssampledb to group adhoc_l2_group;


-- current timestamp
select getdate()||' (UTC)' as finished_at;