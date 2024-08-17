create domain state_d as enum (x_only,y_only,z_only) not null;
create sequence data_id_seq;

create table state_data (
  id     int default on null data_id_seq.nextval primary key,
  state  state_d,
  unique (id,state)
);

create table x_data (
  id     int,
  state  state_d,
  x      number,
  unique (id,state),
  foreign key (id,state) references state_data (id,state) on delete cascade deferrable initially deferred
);

create table y_data (
  id     int,
  state  state_d,
  y      number,
  unique (id,state),
  foreign key (id,state) references state_data (id,state) on delete cascade deferrable initially deferred
);

alter table state_data add constraint state_x_fk foreign key (id,state) references x_data(id,state) deferrable initially deferred;
alter table state_data add constraint state_y_fk foreign key (id,state) references y_data(id,state) deferrable initially deferred;

create or replace
view rls_test2 as
select a.id, a.state, b.x, c.y
from state_data a
  join x_data b on a.id=b.id
  join y_data c on a.id=c.id;

create or replace
trigger rls_tst_trg
  instead of insert or update or delete
  on rls_test2
  for each row
declare
  state_rec  state_data%rowtype;
  x_rec      x_data%rowtype;
  y_rec      y_data%rowtype;
begin
  case
    when inserting then
      insert all
        into state_data (id,state) values (data_id_seq.nextval,:new.state)
        into x_data (id,state,x) values (data_id_seq.currval,:new.state,:new.x)
        into y_data (id,state,y) values (data_id_seq.currval,:new.state,:new.y)
      select :new.state as state, :new.x as x, :new.y as y;
    when updating then
      if updating('state') then
        update state_data a set a.state = :new.state where a.id = :new.id;
        update x_data a set a.state = :new.state where a.id = :new.id;
        update y_data a set a.state = :new.state where a.id = :new.id;
      end if;

      if updating('x') then
        update x_data a set a.x = :new.x where a.id = :new.id;
      end if;

      if updating('y') then
        update y_data a set a.y = :new.y where a.id = :new.id;
      end if;
    when deleting then
      delete from state_data where id = :old.id;
  end case;
end;
/

insert into rls_test2 (state,x,y) values (state_d.x_only, 1, 1 );
commit;
select * from rls_test2;
update rls_test2 set x=0, y=0;
update rls_test2 set state = state_d.y_only;
delete from rls_test2;
commit;















create domain state_d as enum ( x, y, z ) not null;

create table state_data (
  id     int generated always as identity primary key,
  state  state_d,
  unique (id, state)
);

create table insert_data (
  id        int,
  state     state_d,
  raw_data  number,
  unique (id),
  foreign key (id,state) references state_data(id,state) on delete cascade
);
alter table state_data add constraint state_fk1 foreign key (id) references insert_data(id) deferrable initially deferred;

create table analyze_data (
  id        int,
  state     state_d,
  calc      number,
  unique (id),
  foreign key (id,state) references state_data(id,state) on delete cascade
);
alter table state_data add foreign key (id) references analyze_data(id) deferrable initially deferred;

create table currate_data (
  id        int,
  state     state_d,
  is_valid  boolean default on null true,
  unique(id),
  foreign key (id,state) references state_data(id,state) on delete cascade
);
alter table state_data add foreign key (id) references currate_data(id) deferrable initially deferred;

create view lab_data as
select id, a.state, b.raw_data, c.calc, d.is_valid
from state_data a
  join insert_data  b using (id)
  join analyze_data c using (id)
  join currate_data d using (id)
;

trigger instead of insert or update or delete on lab_data for each row
begin
case
 when inserting
   insert all into analyze_data
   returning
 when updating
   updating(state) or up
end;
/

begin
  for rec in (
select *
from user_constraints where
constraint_type = 'R' order by table_name
  ) loop

  execute immediate 'alter table ' || rec.table_name || ' drop constraint ' || rec.constraint_name;
 end loop;
end;
/

drop table x_data purge;
drop table y_data purge;
drop table state_data purge;

drop table currate_data purge;
drop table analyze_data purge;
drop table insert_data purge;
drop table state_data purge;
purge recyclebin;
drop domain state_d;