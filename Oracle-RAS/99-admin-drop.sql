begin
    xs_data_security.remove_object_policy(policy=>'RLS_POLICY',
                                          schema=>'data_schema', object=>'rls_col_test');
end;
/

exec xs_data_security.delete_policy('rls_policy', xs_admin_util.cascade_option);


exec xs_acl.delete_acl('x_only_acl', xs_admin_util.cascade_option);
exec xs_acl.delete_acl('y_only_acl', xs_admin_util.cascade_option);

-----------------------  admin
exec xs_principal.delete_principal('x_only');
exec xs_principal.delete_principal('y_only');

select * from dba_xs_acls;
select * from DBA_POLICIES;
select * from DBA_XS_POLICIES;
select * from DBA_XS_SECURITY_CLASSES;