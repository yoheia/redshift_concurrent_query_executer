-- current timestamp
select getdate()||' (UTC)' as started_at;

--timing on
\timing on

--pager off
\pset pager

drop user dwh_batch_user;
drop user dwh_tool_user;
drop user adhoc_l1_user;
drop user adhoc_l2_user;

create user dwh_batch_user password 'Password1' in group dwh_batch_group session timeout 36000;
create user dwh_tool_user password 'Password1' in group dwh_tool_group session timeout 36000;
create user adhoc_l1_user password 'Password1' in group adhoc_l1_group session timeout 36000;
create user adhoc_l2_user password 'Password1' in group adhoc_l2_group session timeout 36000;

alter user dwh_batch_user set enable_result_cache_for_session = off;
alter user dwh_tool_user set enable_result_cache_for_session = off;
alter user adhoc_l1_user set enable_result_cache_for_session = off;
alter user adhoc_l2_user set enable_result_cache_for_session = off;

-- current timestamp
select getdate()||' (UTC)' as finished_at;