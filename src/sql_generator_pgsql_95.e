note

	description:

		"Produces PostgreSQL 9.5 output."

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2017, Berend de Boer"
	license: "Eiffel Forum License v2 (see forum.txt)"


class

	SQL_GENERATOR_PGSQL_95


inherit

	SQL_GENERATOR_PGSQL_82
		redefine
			target_name,
			datatype_int,
			datatype_picture,
			NamedParametersSupported,
			StoredProcedureSupportsTrueFunction,
			sp_insert_declaration,
			sp_update_declaration,
			sp_delete_declaration,
			create_select_value_inside_sp,
			do_sql_cast_to_real
		end


create

	make


feature -- About this generator

	target_name: STRING
			-- Name and version of dialect
		once
			Result := "PostgreSQL 9.5"
		end


feature -- type specification for xplain types

	datatype_int (representation: XPLAIN_I_REPRESENTATION): STRING
			-- int2 parameters in postgresql give a lot of grieve. They
			-- somehow are not implicitly casted.
		do
			if not is_stored_procedure then
				Result := precursor (representation)
			else
				inspect representation.length
				when 1 .. 9 then
					Result := "integer"
				when 10 .. 17 then
					Result := "bigint"
				else
					Result := "numeric(" + representation.length.out + ", 0)"
				end
			end
		end

	datatype_picture (representation: XPLAIN_P_REPRESENTATION): STRING
		once
			Result := "bytea"
		end


feature {NONE} -- Cast expressions implementation

	do_sql_cast_to_real (an_sql_expression: STRING): STRING
			-- SQL expression to cast `an_expression' to a real
		do
			Result := "cast (" + an_sql_expression + " as numeric)"
		end


feature -- Stored procedure support

	NamedParametersSupported: BOOLEAN = True
			-- PostgreSQL 9 supports named parameters

	StoredProcedureSupportsTrueFunction: BOOLEAN = True

	sp_insert_declaration (
			type: XPLAIN_TYPE;
			cursor: DS_LINEAR_CURSOR [XPLAIN_ATTRIBUTE];
			has_input_parameters: BOOLEAN)
			-- No longer applicable for PostgreSQL 9.
		do
		end

	sp_update_declaration (
			type: XPLAIN_TYPE;
			pk_param_name: STRING;
			cursor: DS_LINEAR_CURSOR [XPLAIN_ATTRIBUTE])
			-- No longer applicable for PostgreSQL 9.
		do
		end

	sp_delete_declaration (
			type: XPLAIN_TYPE;
			param_name: STRING)
			-- No longer applicable for PostgreSQL 9.
		do
		end

	create_select_value_inside_sp (a_value: XPLAIN_VALUE)
			-- Emit SQL that returns the value when asked for that value
			-- inside a stored procedure.
		do
			std.output.put_string ("return ")
			std.output.put_string (a_value.quoted_name (Current))
			std.output.put_character ('%N')
		end

end
