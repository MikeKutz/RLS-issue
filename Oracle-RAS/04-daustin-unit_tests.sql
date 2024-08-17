select * from V$XS_SESSION_ROLE where regexp_like( role_name, '^[XY]_ONLY' );
-- should show 2x rows

select * from data_schema.rls_col_test;
-- expect: 2 rows selected; actual: 2 rows selected

update data_schema.rls_col_test set x=99 where state='X';
-- expect: 1 rows update; actual: 1 rows update
update data_schema.rls_col_test set x=99 where state='Y';
-- expect: 0 rows update; actual: 1 rows update

update data_schema.rls_col_test set x=0;
-- expected: 1 rows update; actual: 2 rows update

update data_schema.rls_col_test set y=0;
-- expected: 1 rows update; actual: 2 rows update

update data_schema.rls_col_test set x=-1, y=-1;
-- expected: 0 rows updated; actual: 2 rows updated

