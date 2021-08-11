create table public.f_person
(
	person_id integer not null,
	family_name character varying(50),
	given1_name character varying(50),
	given2_name character varying(50),
	prefix_name character varying(50),
	suffix_name character varying(50),
	preferred_language character varying(50),
	ssn character varying(50),
	active integer,
	contact_point1 character varying(50),
	contact_point2 character varying(50),
	contact_point3 character varying(50),
	maritalstatus character varying(50)
);
