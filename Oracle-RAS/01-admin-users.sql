prompt creating user
create user data_schema identified by Change0nInstall
  default tablespace  data -- DATA for OCI; USERS for FREE/XE
  quota  20  M on data
  account unlock;

grant connect, resource, create view, create sequence to data_schema;

-- RUN ONE !!
-- OCI ADB: exec sys.xs_admin_cloud_util.grant_system_privilege('ADMIN_ANY_SEC_POLICY','data_schema');
-- local  : exec sys.xs_admin_util.grant_system_privilege('ADMIN_ANY_SEC_POLICY','data_schema');

prompt creating roles
create role x_only_db;
exec xs_principal.create_role('x_only', true);
grant x_only_db to x_only;

create role y_only_db;
exec xs_principal.create_role('y_only', true);
grant y_only_db to y_only;

prompt creating Direct login RAS users
exec  sys.xs_principal.create_user(name => 'daustin', schema => 'hr');
exec  sys.xs_principal.set_password('daustin', 'Change0nInstall');
exec  sys.xs_principal.grant_roles('daustin', 'XSCONNECT');
exec  sys.xs_principal.grant_roles('daustin', 'x_only');
exec  sys.xs_principal.grant_roles('daustin', 'y_only');
