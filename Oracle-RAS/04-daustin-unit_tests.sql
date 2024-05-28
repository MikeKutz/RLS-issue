select * from data_schema.rls_test;
-- expect: 2 rows; actual: 2 rows

update data_schema.rls_test set x=99 where state='X';
-- expect: 1 row update; actual: 1 row update
update data_schema.rls_test set x=99 where state='Y';
-- expect: 0 row update; actual: 1 row update

update data_schema.rls_test set x=0;
-- expected: 1 row update; actual 2 row update

update data_schema.rls_test set y=0;
-- expected: 1 row update; actual 2 row update

