indexing

	description:

		"Base class for Eiffel middleware code to call a stored procedure using ECLI."

	library: "xplain2sql Library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2006, Berend de Boer"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2008/12/15 $"
	revision: "$Revision: #5 $"


deferred class

	XPLAIN_PROCEDURE


inherit

	ECLI_STORED_PROCEDURE
		export
			{NONE} set_sql
		redefine
			execute,
			make
		end


feature {NONE} -- Initialization

	make (a_session : ECLI_SESSION) is
		do
			precursor (a_session)
			set_sql (sql_stored_procedure_call)
			bind_input_parameters
			if parameters /= Void then
				bind_parameters
			end
		end


feature -- Access

	error_code: INTEGER is
		do
			Result := status
		end

	error_message: STRING is
		do
			Result := diagnostic_message
		end

	expected_columns_count: INTEGER is
			-- Expected number of columns returned by `execute'
		deferred
		ensure
			not_negative: Result > 0
		end

	name: STRING is
			-- Procedure name as known in Xplain
		deferred
		ensure
			name_not_empty: Result /= Void and then not Result.is_empty
		end

	sql_name: STRING is
			-- Procedure name in SQL, including quoting
		deferred
		ensure
			sql_name_not_empty: Result /= Void and then not Result.is_empty
		end


feature -- Basic operations

	execute is
		do
			precursor
			if is_ok and then has_result_set then
				bind_columns
			end
		end


feature {NONE} -- Implementation

	bind_columns is
		deferred
		end

	bind_input_parameters is
			-- Create `parameters' and put them in `directed_parameters'.
		deferred
		end

	sql_stored_procedure_call: STRING is
			-- SQL to call procedure; depends on dialect
		deferred
		ensure
			not_empty: Result /= Void and then not Result.is_empty
		end


feature {NONE} -- Implementation

	decimal_zero: MA_DECIMAL is
			-- It seems an ECLI_DECIMAL parameter must be set to
			-- something other than null, else "[unixODBC][Driver
			-- Manager]Invalid string or buffer length" is raised
		once
			create Result.make_from_integer (0)
		ensure
			not_void: Result /= Void
		end


end
