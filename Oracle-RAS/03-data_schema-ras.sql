-- Security Class
begin
  sys.xs_security_class.create_security_class(
    name        => 'rls_privileges',
    parent_list => xs$name_list('sys.dml'),
    priv_list   => xs$privilege_list();
end;
/

-- ACLs
declare  
  aces xs$ace_list := xs$ace_list();  
begin 
  aces.extend(1);
 
  -- X only ACL
  aces(1) := xs$ace_type(privilege_list => xs$name_list('select','update'),
                         principal_name => 'x_only' );
 
  sys.xs_acl.create_acl(name      => 'x_only_acl',
                    ace_list  => aces,
                    sec_class => 'rls_privileges');
  -- Y only ACL
  aces(1) := xs$ace_type(privilege_list => xs$name_list('select','update'),
                         principal_name => 'x_only' );
 
  sys.xs_acl.create_acl(name      => 'x_only_acl',
                    ace_list  => aces,
                    sec_class => 'rls_privileges');
end;
/

-- policy
declare
  realms   xs$realm_constraint_list := xs$realm_constraint_list();      
  cols     xs$column_constraint_list := xs$column_constraint_list();
begin  
  realms.extend(4);
 
  realms(1) := xs$realm_constraint_type(
    realm    => q'[ state = 'X' ]',
    acl_list => xs$name_list('x_only_acl'),
    );
  realms(2) := xs$realm_constraint_type(
    realm    => q'[ state = 'Y' ]',
    acl_list => xs$name_list('y_only_acl'),
    );

  sys.xs_data_security.create_policy(
    name                   => 'rls_policy',
    realm_constraint_list  => realms
    );
end;
/

-- apply policy
begin
  sys.xs_data_security.apply_object_policy(
    policy => 'rls_policy'
    ,schema => 'data_schema'
    ,object =>'rls_test'
    ,owner_bypass => true -- optional, usually FALSE for production
    );
end;
/

