-- current timestamp
select getdate()||' (UTC)' as started_at;

--timing on
\timing on

--pager off
\pset pager

-- show Redshift version
select version();

\i create_awssampledb_schema.sql
\i create_awssampledb_table.sql
\i copy_awssampledb_table.sql

-- current timestamp
select getdate()||' (UTC)' as finished_at;