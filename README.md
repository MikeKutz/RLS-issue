# RLS-issue
 Exploring federated column specific `UPDATE` with Row Level Security.

This repository shows that column specific database level grants (eg `update(x)`) are not being federated by Data Domain (the added `where` clause) for various RDBMS

PoC for RDBMS:
- Oracle Real Application Security (RAS)
- PostgreSQL RLS

# Business Requirement

- `some_user` should only be able to update column `X` in the Data Domain `state='X'`
- `some_user` should only be able to update column `Y` in the Data Domain `state='Y'`

## Use Case
In a science lab, user needs to
- import
- analyze
- curate
- review
- publish
- trash

Each step corrisponse to what actions the data wrangler can perform.

- import - all column need to be modifiable
- analyze - non-raw data columns need to be updateable
- currate - eg only `is_valid` can be changed
- review - read-only for a small group
- published - read-only for a large group (eg everyone else)
- trash - soft delete

 # Issue
 
 If a Principal only has one role, then only the appropriate column is updated.  This works as expected.

 However, when the Principal (`some_user`) is assigned both roles, the Princepal can update both columns in both Data Domains.

 # Current Workaround

 Use a separate table for each unique set of column specific privileges. (eg `import_data`, `state_data`, `analyze_data`, `currate_data`, and view `lab_data`)

 But, that introduces new problems:
 - Enforcing a 1:0..1 relationship
 - providing a single table interface for CRUD operations performed by the framework

 Although possible to develop, the need for extra work to achieve the Business Requirement seems to show a dificency in the SQL/RDBMS/RLS implementations that are tested.
 
