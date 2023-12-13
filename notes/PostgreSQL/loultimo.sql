CREATE OR REPLACE FUNCTION stat.CreateTestUser(user_payload stat.users)
  RETURNS stat.users
  LANGUAGE plpgsql
  AS $function$
  DECLARE
    role_status TEXT DEFAULT NULL;
    existing_user stat.users DEFAULT NULL;
    new_user stat.users DEFAULT NULL;
  BEGIN
    -- Override role to can store RFQ from public site
    SELECT set_config('role', 'stat_admin', TRUE) INTO role_status;
    -- Create User with contact data
    SELECT * from stat.users where email = user_payload.email INTO existing_user;
    IF existing_user IS NULL THEN
      INSERT INTO stat.users (first_name, last_name, username, email, "role") VALUES (user_payload.first_name,user_payload.last_name, user_payload.username, user_payload.email, user_payload.role) returning * into new_user;
    END IF;
    RETURN new_user;
  END $function$;
  
  select stat.submitUserForTesting(x) from stat.users x where id = 0;
  
  select * from stat.users;
  select stat.submitUserForTesting((2, 'abel', 'last_name', 'username', 'email@email.com', '2023-06-26 18:59:29.436', 'stat_user', 'password')::stat.users);


insert into stat.users (first_name, last_name, username, email, "role") values ('abel', 'last_name', 'username', 'algo@gmail.com', 'stat_user');

select * from stat.users;
create or replace function stat.some_function()
 returns text
    language plpgsql
as $$
    begin
        return 'some function text';
    end;
$$;

DROP FUNCTION IF EXISTS stat.some_function();


revoke execute on function stat.some_function() from public;
revoke execute on function stat.some_function() from stat_anonymous;
grant execute on function stat.some_function() to stat_anonymous;
select current_role;
set role stat_anonymous;
set role postgres;
select stat.some_function();

SELECT rolname, rolsuper FROM pg_roles;
select stat.create_test_user((7, 'first name', 'last_name', 'username', 'somemail@mail.com', '2023-06-30 22:55:05.209', 'stat_user', 'password' )::stat.users);
select current_role;
set role postgres;

SELECT 
    r.rolname AS role, 
    r2.rolname AS member_of
FROM 
    pg_roles r 
JOIN 
    pg_auth_members a ON r.oid = a.member 
JOIN 
    pg_roles r2 ON r2.oid = a.roleid 
WHERE 
    r.rolname = 'stat_admin';
	


-- this works, this shows the owner of a function
SELECT 
    proname AS function_name, 
    nspname AS schema_name, 
    pg_get_userbyid(proowner) AS function_owner 
FROM 
    pg_proc p
JOIN 
    pg_namespace n ON p.pronamespace = n.oid 
WHERE 
    proname = 'some_function' AND nspname = 'stat';

select current_role;
set role stat_admin;
select * from stat.rfq_pdfs;
select * from stat.users;

select * from stat.request_for_quotes;
select * from stat.ssf_pdfs;
select * from stat.ssf_shipping_information;
select * from stat.sample_submission_forms;
select * from stat.studies;
select * from stat.rsi_types_assignments;
select * from stat.reports_sample_inconsistencies;
select * from stat.rsi_types_assignments;
select * from stat.users;
select * from stat.ssf_shipments;
select * from stat.ssf_shipping_information;
select * from stat.ssf_shipping_labels;


SELECT rsi_ta.id from stat.reports_sample_inconsistencies rsi
                       JOIN stat.rsi_types_assignments rsi_ta ON rsi.id = rsi_ta.rsi_id
                       JOIN stat.studies s ON s.id = rsi.study_id
                       JOIN stat.request_for_quotes rfq ON s.rfq_id = rfq.id
WHERE rfq.user_id = 3 and rsi.id = 8;

select * from stat.sample_submission_forms;
select id, sample_submission_form_id,rfq_id from stat.ssf_sample_definitions;
select ssf_sample_definition_id from stat.ssf_test_assignments;
select ssf_sample_definition_id from stat.ssf_product_details;
select shipping_information_id from stat.ssf_shipping_information;
select ssf_sample_definition_id from stat.ssf_shipping_information;

set role postgres;
-- get the shipmemts related to the ssf or in this case the sample definitions
SELECT ssfs.*
FROM stat.ssf_shipments ssfs
INNER JOIN stat.ssf_shipping_information si
    ON ssfs.shipping_information_id = si.id
INNER JOIN stat.ssf_sample_definitions sd
    ON si.ssf_sample_definition_id = sd.id
INNER JOIN stat.sample_submission_forms ssf
    ON sd.sample_submission_form_id = ssf.id
	WHERE ssf.id = 88;
	
insert into stat.ssf_shipments (tracking_number, shipping_temperature, template_data_recipient, ssf_id) values ('sdafsdf', 'Ambient', 'templateDataRecipient', 88);
delete from stat_ssf_shipments where ssf_id

-- si hago un ssf con mas sample definitions (digamos 2) entonces este resultado me tendría que aparecer 	

delete from stat.ssf_shipping_information where ssf_sample_definition_id = 4;
delete from stat.ssf_billing_information where ssf_sample_definition_id = 4;


GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA stat TO stat_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA stat TO stat_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA stat TO stat_anonymous;



select * from stat.organizations;
CREATE OR REPLACE FUNCTION stat.user_allowed_resources()
    RETURNS INT[]
    LANGUAGE plpgsql
AS $function$
DECLARE
    user_data RECORD;
    user_email_domain TEXT;
    user_ids INT[];
    exists_in_organization BOOLEAN;
    current_user_role TEXT;
BEGIN
    -- Get current user role
    SELECT current_setting('role', TRUE)::TEXT INTO current_user_role;
    PERFORM set_config('role', 'stat_admin', TRUE);
    -- Get user email
    SELECT * INTO user_data FROM stat.users WHERE id = current_setting('user.id', TRUE)::INT;
    -- Get email domain
    SELECT split_part(user_data.email, '@', 2) INTO user_email_domain;
    -- Check if email domain exists in organizations
    SELECT EXISTS(SELECT 1 FROM stat.organizations WHERE email_domain = user_email_domain) INTO exists_in_organization;
    -- If user email domain exists in organizations, get all users with the same email domain
    IF exists_in_organization THEN
        SELECT ARRAY_AGG(id) FROM stat.users WHERE email LIKE '%' || user_email_domain INTO user_ids;
    ELSE
        user_ids := ARRAY[user_data.id];
    END IF;
    PERFORM set_config('role', current_user_role, TRUE);
    RETURN user_ids;
END $function$;

create or replace function stat.is_current_role_admin()
    returns boolean
    language plpgsql
    as $$
    begin
        return current_setting('role', TRUE)::TEXT = 'stat_admin';

    end $$;

drop function if exists stat.is_current_role_admin();
drop function if exists stat.is_current_user_admin();
drop function if exists stat.is_user_admin(int);

select null = 3;

create or replace function stat.is_current_user_admin()
    returns boolean
    language plpgsql
as $$
declare
    user_role text;
    user_id int;
begin
    -- get user id
    select current_setting('user.id', true)::int into user_id;
    -- get user role
    select u.role from stat.users u where u.id = user_id into user_role;

    -- if user_role is null, user not found
    if user_role is null then
        return false;
    end if;

    return user_role = 'stat_admin';
exception
    when others then
        return false;
end $$;

select set_config('user.id', 'x', TRUE);
select current_setting('user.id', true)::int;



select stat.is_user_admin(-10);
select * from stat.users;
select * from stat.studies;
select * from stat.request_for_quotes;
select * from stat.sample_inconsistencies;
select * from stat.sample_inconsistency_types;

insert into stat.users (first_name, email, role) values ('Other', 'other@gmail.com', 'stat_user');
select current_role;
select * from pg_stat_activity;
select current_setting('role');
select set_config('role', 'stat_admin', TRUE);

set role stat_admin;
update stat.sample_inconsistencies set resolution = 'resolution 7' where id = 5;

select current_setting('role', TRUE)::TEXT = 'stat_admin';

SELECT graphile_worker.add_job('example', json_build_object('name', 'Bobby Tables'));

create or replace function experiment_function()
    returns trigger
    language plpgsql
    SECURITY DEFINER
    SET search_path TO 'pg_catalog', 'public', 'pg_temp'
as $$
begin
    perform graphile_worker.add_job('example', json_build_object('name', 'Bobby Tables',
                                                                'other', NEW.*));
    return NEW;
end $$;

DROP function experiment_function();


create or replace trigger example_trigger_on_stat_sample_inconsistencies
    after update on stat.sample_inconsistencies
    for each row
execute function experiment_function();

select * from stat.studies;

create table temp_logger(id serial primary key, log text);

alter table temp_logger add column created_at timestamp with time zone default now();
alter table temp_logger add column created_by int default stat.current_user_id();
grant all on temp_logger to stat_anonymous;
grant all on temp_logger to stat_admin;
grant all on temp_logger to stat_user;

grant all privileges on sequence temp_logger_id_seq to stat_anonymous;
grant all privileges on sequence temp_logger_id_seq to stat_user;
grant all privileges on sequence temp_logger_id_seq to stat_admin;

select * from temp_logger;
select * from stat.sample_submission_forms;
select * from stat.studies;
select * from stat.request_for_quotes;
select * from stat.users;

select * from stat.sample_submission_forms where rfq_id = 1 order by id desc limit 1;


-- playing with ctes

with recursive numbers AS (
    select 1 as n
    union all
    select n + 1 from numbers where n < 5
)

select * from numbers;

with recursive ssf_replacements AS (
    select * from stat.sample_submission_forms ssf where ssf.id = 39
    union all
    select * from ssf_replacements r where replacement_for_ssf_id = r.replacement_for_ssf_id and replacement_for_ssf_id is not null
)

select * from ssf_replacements;



WITH RECURSIVE ParentHierarchy AS (
    SELECT
        id,
        replacement_for_ssf_id,
        1 AS depth
    FROM
        stat.sample_submission_forms
    WHERE
            id =  39 -- Specify the target sample_submission_form ID here

    UNION ALL

    SELECT
        ssf.id,
        ssf.replacement_for_ssf_id,
        ph.depth + 1
    FROM
        stat.sample_submission_forms ssf
            INNER JOIN
        ParentHierarchy ph ON ssf.id = ph.replacement_for_ssf_id
)
SELECT
    id,
    replacement_for_ssf_id,
    depth
FROM
    ParentHierarchy;



CREATE TABLE stat.sample_submission_forms_with_version (
    -- Inherit all columns from the original table
    LIKE stat.sample_submission_forms INCLUDING ALL,
    depth INT,
    version TEXT
);
drop table if exists stat.sample_submission_forms_with_version;

select * from stat.sample_submission_forms_with_version;


create type stat.sample_submission_form_with_version AS (
    id int,
    rfq_id int,
    user_id int,
    created_at timestamp,
    replacement_for_ssf_id int,
    depth int,
    version text
);

CREATE TYPE stat.sample_submission_form_version_with_study AS (
    LIKE stat.sample_submission_form_with_version,
    study_id int,
    study_code text
);


drop function if exists stat.get_ssf_version_history(int);
drop type if exists stat.sample_submission_form_with_version;

create or replace function stat.get_ssf_version_history(ssf_id int)
    returns setof stat.sample_submission_form_with_version
    language plpgsql stable
as $$
begin
    return query(
        WITH RECURSIVE SSFParentHierarchy AS (
            SELECT
                ssf.id,
                ssf.rfq_id,
                ssf.user_id,
                ssf.created_at,
                ssf.replacement_for_ssf_id,
                0 AS depth
            FROM
                stat.sample_submission_forms ssf
            WHERE
                    id = ssf_id

            UNION ALL

            SELECT
                ssf.id,
                ssf.rfq_id,
                ssf.user_id,
                ssf.created_at,
                ssf.replacement_for_ssf_id,
                ph.depth + 1
            FROM
                stat.sample_submission_forms ssf
                    INNER JOIN
                SSFParentHierarchy ph ON ssf.id = ph.replacement_for_ssf_id
        )
        SELECT
            *,
            (((ROW_NUMBER() OVER (ORDER BY depth DESC))::int - 1))::text AS version
        FROM
            SSFParentHierarchy);
end $$;

select * from stat.get_ssf_version_history(36);

comment on table stat.sample_submission_forms_with_version is E'@omit create,update,delete';


WITH RECURSIVE SSFParentHierarchy AS (
    SELECT
        ssf.id AS sample_submission_form_id,
        ssf.rfq_id,
        ssf.user_id,
        ssf.created_at,
        ssf.replacement_for_ssf_id,
        0 AS depth,
        'Version 1' AS version
    FROM
        stat.sample_submission_forms ssf
    WHERE
            ssf.rfq_id = :your_rfq_id -- Specify the target RFQ ID here

    UNION ALL

    SELECT
        ssf.id AS sample_submission_form_id,
        ssf.rfq_id,
        ssf.user_id,
        ssf.created_at,
        ssf.replacement_for_ssf_id,
        ph.depth + 1,
        'Version ' || (ph.depth + 2) AS version
    FROM
        stat.sample_submission_forms ssf
            JOIN
        SSFParentHierarchy ph ON ssf.id = ph.replacement_for_ssf_id
)
SELECT
    sample_submission_form_id,
    rfq_id,
    'Version 1' AS version,
    COALESCE(
                    jsonb_agg(
                    jsonb_build_object(
                            'Version', ssf.version
                        )
                ) FILTER (WHERE ssf.version IS NOT NULL),
                    '[]'::jsonb
        ) AS version_hierarchy
FROM
    SSFParentHierarchy ssf
WHERE
        ssf.depth = 0
GROUP BY
    sample_submission_form_id, rfq_id
ORDER BY
    sample_submission_form_id, rfq_id;


drop function if exists stat.get_ssfs_of_quote_with_study(int);

-- function to retrieve sample submission forms of a quote with study version history for a given request for quote id.
create or replace function stat.get_ssfs_of_quote_with_study(request_for_quote_id int)
    returns setof stat.sample_submission_form_version_with_study
    language plpgsql stable
as $$
declare
    -- define a cursor to retrieve studies that match the rfq id.
    -- this because we need to retrieve the leafs of the ssf tree (each study points to the last ssf of the ssfs hierarchy)
    ssfs_leafs cursor for select * from stat.studies s where s.rfq_id = request_for_quote_id order by s.id;
    study_record stat.studies;
    version_record stat.sample_submission_form_with_version;
    version text;
    iteration int := 0;
begin
    -- open the cursor to start fetching rows.
    open ssfs_leafs;

    -- loop through the studies that match the request_for_quote_id.
    loop
        fetch next from ssfs_leafs into study_record;
        exit when not found;

        iteration := iteration + 1;
        -- run the query to get the version history of the ssf (or parent hierarchy)
        for version_record in (select * from stat.get_ssf_version_history(study_record.ssf_id))
            loop
                -- determine the version for the current record.
                if version_record.version::int = 0 then
                    version := iteration::text;
                else
                    version := iteration::text || '.' || version_record.version;
                end if;

                -- create a record of the custom type and return it
                return next (
                     version_record.id,
                     version_record.rfq_id,
                     version_record.user_id,
                     version_record.created_at,
                     version_record.replacement_for_ssf_id,
                     version_record.depth,
                     version,
                     study_record.id,
                     study_record.code,
                     study_record.status
                );
            end loop;
    end loop;
    -- return an empty result set if there are no records.
    return;
end $$;



select * from stat.get_ssf_version_history_with_study_from_quote(5);
select * from stat.studies;
select * from stat.sample_submission_forms;
select * from stat.users;


-- initialize postgres variable to store result of query of all studies of a request_for_quote


WITH RECURSIVE StudyHierarchy AS (
    SELECT
        s.id AS study_id,
        s.rfq_id,
        s.ssf_id,
        0 AS depth
    FROM
        stat.studies s
    WHERE
            s.rfq_id = :your_rfq_id -- Specify the target RFQ ID here

    UNION ALL

    SELECT
        ssf.id AS study_id,
        ssf.rfq_id,
        ssf.replacement_for_ssf_id AS ssf_id,
        sh.depth + 1
    FROM
        StudyHierarchy sh
            JOIN
        stat.sample_submission_forms ssf ON sh.ssf_id = ssf.id
),
               SSFBacktrack AS (
                   SELECT
                       s.id AS ssf_id,
                       s.replacement_for_ssf_id,
                       0 AS depth
                   FROM
                       stat.sample_submission_forms s
                   WHERE
                           s.id IN (SELECT ssf_id FROM StudyHierarchy WHERE rfq_id = :your_rfq_id)

                   UNION ALL

                   SELECT
                       ssf.id AS ssf_id,
                       ssf.replacement_for_ssf_id,
                       sb.depth + 1
                   FROM
                       SSFBacktrack sb
                           JOIN
                       stat.sample_submission_forms ssf ON sb.replacement_for_ssf_id = ssf.id
               ),
               SSFWithVersion AS (
                   SELECT
                       sb.ssf_id,
                       sb.depth,
                       ROW_NUMBER() OVER (PARTITION BY sb.ssf_id ORDER BY sb.depth DESC) AS ssf_version
                   FROM
                       SSFBacktrack sb
               )
SELECT
    sh.study_id,
    sh.rfq_id,
    sh.ssf_id AS sample_submission_form_id,
    swv.ssf_version
FROM
    StudyHierarchy sh
        LEFT JOIN
    SSFWithVersion swv ON sh.ssf_id = swv.ssf_id
ORDER BY
    sh.study_id, sh.rfq_id, sample_submission_form_id, swv.ssf_version DESC;

-- 1.get all studies of a request_for_quote
-- 2. get sample sample submission form of an study
--   2.1 backtrack sample submission forms of the sample submission form related to study
--   2.2 get the version of the sample submission form with the backtrack (using the depth and then reverse its order)


select * from stat.studies join stat.sample_submission_forms ssf on ssf_id = ssf.id where ssf.created_at >= '2023-08-29 23:43:02.608911';
select * from stat.sample_submission_forms where sample_submission_forms.replacement_for_ssf_id is null and created_at >= '2023-08-29 23:43:02.608911';
select * from stat.sample_submission_forms;

select * from temp_logger;
select * from stat.get_ssf_version_history_with_study_from_quote(2);


-- STAT 1150
-- remove leuven and woodlands
delete from stat.ssf_shipping_locations where id = 7 and id = 8;
alter table stat.ssf_shipping_locations add column analysis_department_email text;
-- add the corresponding emails
-- TODO: waiting upon Jason for the emails









SELECT pid, usename, state FROM pg_stat_activity;

-- get database current migration version
SELECT * FROM public.schema_migrations;
SELECT relname, relkind FROM pg_class -- pg_class lists all the kind of objects in the database
    WHERE relkind = 'i'; -- this tells to retrieve only the kind of 'i' which stands for _index_




explain analyze select * from stat.request_for_quotes JOIN stat.sample_submission_forms ON request_for_quotes.id = sample_submission_forms.rfq_id;


select * from stat.users;
select * from stat.request_for_quotes where user_id = 3;




















-- Playground

select * from stat.sample_submission_forms where rfq_id = 5;
select * from stat.studies where id = 5;

select * from stat.get_ssf_version_history_with_study_from_quote(2);
select * from stat.get_ssf_version_history(44);


-- STAT 1361

select * from stat.ssf_shipments join stat.ssf_shipping_information on stat.ssf_shipments.shipping_information_id = stat.ssf_shipping_information.id where shipping_information_id = 4;

select * from stat.ssf_shipments where id IN (1, 2, 4);
select * from stat.ssf_shipments ;
select * from stat.ssf_shipping_information where id = 4;

select * from stat.sample_submission_forms where id = 5;


SELECT * FROM public.schema_migrations;

-- admin user id: 2
-- user user id: 3

select * from stat.sample_inconsistencies;

select * from stat.studies s
    join stat.request_for_quotes rfq on rfq.id = s.rfq_id where rfq.user_id = 3;

select * from stat.users;


update stat.sample_inconsistencies set resolution = null where id = 15;
update stat.studies set status = 'Quarantined' where id = 15;

SELECT s.tracking_number, s.raw_tracking_data FROM stat.ssf_shipments s
                                  INNER JOIN stat.ssf_shipping_information si ON s.shipping_information_id = si.id
WHERE si.id = 1;

select * from stat.ssf_shipments;

select * from stat.request_for_quotes where user_id = 3;