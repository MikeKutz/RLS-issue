create table rls_col_test (
  id int generated always as identity,
  state  varchar2(10) not null,
  x      number,
  y      number
);

insert into rls_col_test (state,x,y) values ( 'X', 1, 1 );
insert into rls_col_test (state,x,y) values ( 'Y', 2, 2 );
insert into rls_col_test (state,x,y) values ( 'Z', 3, 3 );
commit;
