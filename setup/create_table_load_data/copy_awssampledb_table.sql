set search_path to awssampledb;
select current_schema();

copy customer from 's3://awssampledb-az/ssbgz/customer'
iam_role 'arn:aws:iam::542203247656:role/redshift-spectrum-s3-fullaccess'
gzip compupdate off region 'ap-northeast-1';

copy dwdate from 's3://awssampledb-az/ssbgz/dwdate' 
iam_role 'arn:aws:iam::542203247656:role/redshift-spectrum-s3-fullaccess'
gzip compupdate off region 'ap-northeast-1';

copy lineorder from 's3://awssampledb-az/ssbgz/lineorder' 
iam_role 'arn:aws:iam::542203247656:role/redshift-spectrum-s3-fullaccess'
gzip compupdate off region 'ap-northeast-1';

copy part from 's3://awssampledb-az/ssbgz/part' 
iam_role 'arn:aws:iam::542203247656:role/redshift-spectrum-s3-fullaccess'
gzip compupdate off region 'ap-northeast-1';

copy supplier from 's3://awssampledb-az/ssbgz/supplier' 
iam_role 'arn:aws:iam::542203247656:role/redshift-spectrum-s3-fullaccess'
gzip compupdate off region 'ap-northeast-1';

-- show table stats
select * from svv_table_info where schema = 'awssampledb';
