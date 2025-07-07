create extension if not exists dblink;

do
$$
begin
	
	if not exists (select * from pg_user where usename = 'nifi') then
		CREATE USER nifi WITH PASSWORD 'nifi_password';
	end if;

	if not exists (select * from pg_database WHERE datname = 'datalake') then
		PERFORM dblink_exec('dbname=' || current_database(), 'CREATE DATABASE datalake');
	end if;

	ALTER DATABASE datalake OWNER TO nifi;
end
$$
;
