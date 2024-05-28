
create schema rls;
create table rls.tab (
  id int generated always as identity,
  state  varchar(10) not null,
  x      numeric,
  y      numeric
);
insert into rls.tab (state,x,y) values
( 'X', 1, 1 ),
( 'Y', 2, 2 ),
( 'Z', 3, 3 );
commit;
-- select * from rls.tab should show 3 rows;

create role x_only_role;
create role y_only_role;
grant select,update(x) on rls.tab to x_only_role;
grant select,update(y) on rls.tab to y_only_role;

create user daustin;
grant x_only_role,y_only_role to daustin;
grant usage on schema rls to daustin;
-- as "daustin": select * from rls.tab should show 3 rows;

alter table rls.tab enable row level security;
create policy tab_x_policy on rls.tab for all to x_only_role using ( state = 'X' ) with check ( state='X' );
create policy tab_y_policy on rls.tab for all to y_only_role using ( state = 'Y' ) with check ( state='X' );
-- as "daustin": select * from rls.tab should now show 2 rows;

TEST:
set role daustin;
update rls.tab set x = 0;
-- expected: 1 row modified; actual: 2 rows modified
update rls.tab set y = 0;
-- expected: 1 row modified; actual: 2 rows modified
rollback;


