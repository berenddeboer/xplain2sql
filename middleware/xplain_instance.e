indexing

	description:

		"Base class for Eiffel middleware code to access and modify an instance using ECLI."

	library: "xplain2sql library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2006, Berend de Boer"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2008/12/15 $"
	revision: "$Revision: #4 $"


deferred class

	XPLAIN_INSTANCE


inherit

	ANY

	ST_FORMATTING_ROUTINES
		export
			{NONE} all
		end

	EXCEPTIONS
		export
			{NONE} all
		end


feature {NONE} -- Initialization

	make (a_session: ECLI_SESSION) is
		require
			session_not_void: a_session /= Void
		do
			session := a_session
			create return_instance_id_value.make
			make_values
		end


feature -- Management

	close is
			-- Disconnect from session.
			-- You *must* call this statement to free things
			-- properly. Unfortunately, ECLI_SESSION keeps a cache of
			-- statements, and if they are not closed, they will remain
			-- live. So gradually you will eat more and more memory.
		do
			if my_statement /= Void and then not my_statement.is_closed then
				my_statement.close
			end
			my_statement := Void
			if my_insert_statement /= Void and then not my_insert_statement.is_closed then
				my_insert_statement.close
			end
			my_insert_statement := Void
			if my_update_statement /= Void and then not my_update_statement.is_closed then
				my_update_statement.close
			end
			my_update_statement := Void
		ensure
			all_cached_statements_reset:
				my_statement = Void and
				my_insert_statement = Void and
				my_update_statement = Void
		end


feature -- Status

	is_open: BOOLEAN is
		do
			-- is db session open?
			Result := session.is_connected
		end

	is_no_instance: BOOLEAN is
			-- Does `instance_id' indicate that no instance is present?
		do
			Result := my_instance_id = 0
		end

	is_valid_attribute_index (an_index: INTEGER): BOOLEAN is
			-- Is `an_index' an index that can be passed to `attribute_name'
			-- and such?
		do
			Result :=
				an_index >= attribute_names.lower and
				an_index <= attribute_names.upper
		end

	is_valid_instance_id (an_instance_id: INTEGER): BOOLEAN is
			-- Is `an_instance_id' a valid Xplain instance id?
		do
			Result := an_instance_id > 0
		end


feature -- Access

	attribute_name (an_index: INTEGER): STRING is
			-- Name of the `an_index'-th attribute;
			-- When `an_index' is zero, the name of the instance is returned.
		require
			valid_attribute_index: is_valid_attribute_index (an_index)
		do
			Result := attribute_names.item (attribute_names.lower + an_index)
		ensure
			attribute_name_not_empty: Result /= Void and then not Result.is_empty
		end

-- 	attribute_value (an_index: INTEGER): STRING is
-- 			-- Value of the `an_index'-th attribute;
-- 			-- When `an_index' is zero, the identifier value is returned.
-- 		require
-- 			valid_attribute_index: is_valid_attribute_index (an_index)
-- 		deferred
-- 		end

	error_code: INTEGER

	error_message: STRING

	instance_id: INTEGER is
			-- Value of current instance
		require
			have_instance_id: not is_no_instance
		do
			Result := my_instance_id
		ensure
			valid_instance_id: Result >= 1
		end

	instance_name: STRING is
			-- Xplain instance name
		deferred
		ensure
			instance_name_not_empty: Result /= Void and then not Result.is_empty
		end

	table_name: STRING is
			-- SQL table name
		deferred
		ensure
			table_name_not_empty: Result /= Void and then not Result.is_empty
		end

	pk_column_name: STRING is
			-- Name of primary key column of `table_name'
		deferred
		ensure
			table_name_not_empty: Result /= Void and then not Result.is_empty
		end

	session: ECLI_SESSION
			-- ECLI session


feature -- Set instance id

	clear_instance_id is
			-- Indicate that no instance is present.
		deferred
		ensure
			id_cleared: is_no_instance
		end

	set_instance_id (new_id: INTEGER) is
			-- Change the instance id to a valid instance id.
		require
			is_instance_id: new_id > 0
		deferred
		ensure
			id_set: instance_id = new_id
		end


feature -- Basic methods, operating on a single instance

	delete is
			-- Delete current instance.
		require
			instance_id_set: not is_no_instance
			connected: is_open
		do
			close_if_not_after
			delete_statement.execute
			if not delete_statement.is_executed then
				set_diagnostics (insert_statement)
				close
			end
		end

	find_instance (an_instance_id: INTEGER) is
			-- Retrieve instance. An exception will be raised if the
			-- instance is not found.
		require
			connected: is_open
			valid_instance_id: is_valid_instance_id (an_instance_id)
		local
			sql: STRING
		do
			close_if_not_after
			sql := format (sql_select_instance, <<select_column_names, table_name, pk_column_name, integer_cell (an_instance_id)>>)
			statement.set_sql (sql)
			statement.execute
			if statement.is_executed then
				if statement.has_result_set then
					statement.set_results (instance_cursor)
					statement.start
					if statement.after then
						clear_instance_id
					else
						set_instance_id (an_instance_id)
					end
				end
			else
				set_diagnostics (insert_statement)
				statement.close
			end
		end

	get_instance (an_instance_id: INTEGER) is
			-- Retrieve instance. An exception will be raised if the
			-- instance is not found.
		require
			connected: is_open
			valid_instance_id: is_valid_instance_id (an_instance_id)
		do
			close_if_not_after
			find_instance (an_instance_id)
		end

	insert is
			-- Insert current instance as new instance. Sets
			-- `instance_id' to reflect inserted instance id
			-- value.
		require
			connected: is_open
		do
			close_if_not_after
			return_instance_id_value.set_null
			insert_statement.execute
			if insert_statement.is_executed then
				-- This is for non PostgreSQL
				--set_instance_id (return_instance_id_value.item.item)
				-- This is for PostgreSQL
				if insert_statement.has_result_set then
					insert_statement.set_results (<<return_instance_id_value>>)
					insert_statement.start
					if insert_statement.after then
						clear_instance_id
					else
						set_instance_id (return_instance_id_value.item.item)
					end
				end
			else
				set_diagnostics (insert_statement)
				close
			end
		end

	new is
			-- Current row is a new row, fields have their default values.
		do
			set_default_values
		ensure
			no_instance_id: is_no_instance
		end

	set_default_values is
		local
			i: INTEGER
			up: ARRAY [ECLI_VALUE]
		do
			-- Loop through `update_parameters' as they have everything (I hope...)
			up := update_values
			from
				i := up.lower
			until
				i > up.upper
			loop
				up.item (i).set_null
				i := i + 1
			end
			clear_instance_id
		end

	update is
			-- Update current instance.
		require
			instance_id_set: not is_no_instance
			connected: is_open
		do
			close_if_not_after
			update_statement.execute
			if not update_statement.is_executed then
				set_diagnostics (insert_statement)
				close
			end
		end


feature {NONE} -- Result set support

	attribute_names: ARRAY [STRING] is
		deferred
		ensure
			attribute_names_not_void: Result /= Void
			valid_lower_index: Result.lower = 1
		end

	instance_cursor: ARRAY [ECLI_VALUE] is
		deferred
		ensure
			instance_cursor_not_void: Result /= Void
		end

	make_values is
			-- Create the individual value objects used to hold returned
			-- values.
		deferred
		end

	select_column_names: STRING is
			-- List of column names to be used in select statements
		deferred
		ensure
			select_column_names_not_empty: Result /= Void and then not Result.is_empty
		end


feature {NONE} -- ECLI based delete/insert/update support

	add_delete_parameters (a_procedure: ECLI_STORED_PROCEDURE) is
			-- Create the parameters used to communicate with the delete
			-- stored procedure.
		require
			procedure_not_void: a_procedure /= Void
		deferred
		ensure
			just_one_parameter: a_procedure.parameters_count = 1
		end

	add_insert_parameters (a_procedure: ECLI_STORED_PROCEDURE) is
			-- Create the parameters used to communicate with the insert
			-- stored procedure.
		require
			procedure_not_void: a_procedure /= Void
		deferred
		ensure
			not_too_many_parameters: a_procedure.parameters_count <= attribute_names.count
		end

	add_update_parameters (a_procedure: ECLI_STORED_PROCEDURE) is
			-- Create the parameters used to communicate with the update
			-- stored procedure.
		require
			procedure_not_void: a_procedure /= Void
		deferred
		ensure
			got_all_parameters: a_procedure.parameters_count = attribute_names.count
		end

	delete_statement: ECLI_STORED_PROCEDURE is
			-- Once per object statement, used for deletes
		local
			sql: STRING
		do
			if my_delete_statement = Void then
				create my_delete_statement.make (session)
				create sql.make (256)
				sql.append_string (call_prefix)
				sql.append_string (sp_delete_name)
				sql.append_character (' ')
				sql.append_character ('(')
				sql.append_string (delete_parameters_string)
				sql.append_character (')')
				sql.append_string (call_suffix)
				my_delete_statement.set_sql (sql)
				add_delete_parameters (my_delete_statement)
				my_delete_statement.bind_parameters
			end
			Result := my_delete_statement
		ensure
			delete_statement_returned: Result /= Void
			one_parameter: Result.parameters_count = 1
		end

	insert_statement: ECLI_STORED_PROCEDURE is
			-- Once per object statement, used for inserts
		local
			sql: STRING
		do
			if my_insert_statement = Void then
				create my_insert_statement.make (session)
				create sql.make (256)
				sql.append_string (call_prefix)
				sql.append_string (sp_insert_name)
				sql.append_character (' ')
				sql.append_character ('(')
				sql.append_string (insert_parameters_string)
				sql.append_character (')')
				sql.append_string (call_suffix)
				my_insert_statement.set_sql (sql)
				add_insert_parameters (my_insert_statement)
				my_insert_statement.bind_parameters
			end
			Result := my_insert_statement
		ensure
			insert_statement_returned: Result /= Void
			not_too_many_parameters: Result.parameters_count <= attribute_names.count
		end

	close_if_not_after is
			-- If a cursor has been opened, we discard `statement' (and
			-- any pending results) to allow another statement to proceed.
		do
			error_code := 0
			if
				my_statement /= Void and then
				my_statement.is_valid and then
				not my_statement.after
			then
				close
			end
		end

	return_instance_id_value: ECLI_INTEGER
			-- Used for insert instance stored procedures

	statement: ECLI_STATEMENT is
			-- Once per object statement
		require
			connected: my_statement = Void implies is_open
		do
			if my_statement = Void then
				create my_statement.make (session)
			end
			Result := my_statement
		ensure
			statement_returned: Result /= Void
		end

	update_statement: ECLI_STORED_PROCEDURE is
			-- Once per object statement, used for updates
		local
			sql: STRING
		do
			if my_update_statement = Void then
				create my_update_statement.make (session)
				create sql.make (256)
				sql.append_string (call_prefix)
				sql.append_string (sp_update_name)
				sql.append_character (' ')
				sql.append_character ('(')
				sql.append_string (update_parameters_string)
				sql.append_character (')')
				sql.append_string (call_suffix)
				my_update_statement.set_sql (sql)
				add_update_parameters (my_update_statement)
				my_update_statement.bind_parameters
			end
			Result := my_update_statement
		ensure
			update_statement_returned: Result /= Void
			got_all_parameters: Result.parameters_count = attribute_names.count
		end


feature {NONE} -- ECLI once per object caches

	my_delete_statement: ECLI_STORED_PROCEDURE
			-- Statement used in `delete' routine

	my_instance_cursor: ARRAY [ECLI_VALUE]
			-- Cache to use in `instance_cursor';
			-- Should never be used directly.

	my_insert_parameters: ARRAY [ECLI_STATEMENT_PARAMETER]
			-- Cache to use in `insert_parameters';
			-- Should never be used directly.

	my_insert_values: ARRAY [ECLI_VALUE]
			-- Cache to use in `insert_parameters';
			-- Should never be used directly.

	my_insert_statement: ECLI_STORED_PROCEDURE
			-- Statement used in `insert' routine

	my_update_parameters: ARRAY [ECLI_STATEMENT_PARAMETER]
			-- Cache to use in `insert_parameters';
			--Should never be used directly.

	my_update_statement: ECLI_STORED_PROCEDURE
			-- Statement used in `update' routine

	my_update_values: ARRAY [ECLI_VALUE]
			-- Cache to use in `insert_parameters'
			-- Should never be used directly

	my_statement: ECLI_STATEMENT
			-- Used to set SQL


feature {NONE} -- SQL dialects

	call_prefix: STRING is
			-- String that starts a stored procedure call
		do
			inspect dialect
			when dialect_mysql then
				Result := mysql_call_prefix
			when dialect_postgresql then
				Result := pgsql_call_prefix
			else
				Result := cli_call_prefix
			end
		ensure
			prefix_not_void: Result /= Void
		end

	call_suffix: STRING is
			-- String that ends a stored procedure call
		do
			if dialect = dialect_cli then
				Result := "}"
			else
				Result := once_empty
			end
		ensure
			suffix_not_void: Result /= Void
		end

	cli_call_prefix: STRING is "{call "
			-- Call a stored procedure with ODBC

	mysql_call_prefix: STRING is "call "
			-- Call a stored procedure with ODBC

	pgsql_call_prefix: STRING is "select * from "
			-- Call a stored procedure with ODBC

	cli_call_with_result_prefix: STRING is "{?result=call "
			-- Stored procedure that returns something

	sql_select_instance: STRING is "select $s from $s where $s = $i"

	once_empty: STRING is ""

	dialect: INTEGER is
			-- What dialect to use;
			-- there should be a method to set the dialect globally,
			-- but for now it's in the XSLT scripts
		deferred
		end

	dialect_cli: INTEGER is 1
			-- Standard CLI interface

	dialect_mysql: INTEGER is 2
			-- MySQL

	dialect_postgresql: INTEGER is 3
			-- PostgreSQL


feature {NONE} -- Names of stored procedures

	sp_delete_name: STRING is
			-- Delete procedure name
		deferred
		ensure
			name_not_empty: Result /= Void and then not Result.is_empty
		end

	sp_insert_name: STRING is
			-- Insert procedure name
		deferred
		ensure
			name_not_empty: Result /= Void and then not Result.is_empty
		end

	sp_update_name: STRING is
			-- Update procedure name
		deferred
		ensure
			name_not_empty: Result /= Void and then not Result.is_empty
		end

feature {NONE} -- Parameter support

	delete_parameters_string: STRING is
		deferred
		end

	insert_parameters_string: STRING is
		deferred
		end

	update_values: ARRAY [ECLI_VALUE] is
		deferred
		ensure
			update_values_not_void: Result /= Void
		end

	update_parameters_string: STRING is
		deferred
		end


feature {NONE} -- Error handling

	set_diagnostics (a_status: ECLI_STATUS) is
		do
			error_code := a_status.status
			if a_status.diagnostic_message /= Void then
				error_message := a_status.diagnostic_message.twin
			else
				error_message := Void
			end
		end


feature {NONE} -- Implementation

	my_instance_id: INTEGER is
			-- Value of current instance.
		deferred
		end


invariant

	session_not_void: session /= Void
	return_instance_id_value_not_void: return_instance_id_value /= Void

end
