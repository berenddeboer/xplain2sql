note

	description: "Xplain abstract function"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"


deferred class

	XPLAIN_FUNCTION


feature -- Status

	is_nil: BOOLEAN
		do
			Result := False
		end

	is_some: BOOLEAN
		do
			Result := False
		end

	property_required: INTEGER
			-- Does function need the presence of a property?
			-- 0: forbidden; 1: must be presented; 2: don't care either way
		deferred
		ensure
			recognized_result: Result = 0 or Result = 1 or Result = 2
		end


feature -- Access

	name: STRING
			-- Xplain name of function
		deferred
		ensure
			name_not_empty: Result /= Void and then not Result.is_empty
		end

	needs_coalesce: BOOLEAN
			-- Need to give a default value in case function can return a
			-- Null.
		do
			Result := True
		end

	needs_distinct: BOOLEAN
			-- Does function need a distinct clause (count function)
		do
			Result := False
		end

	needs_limit (sqlgenerator: SQL_GENERATOR): BOOLEAN
			-- Can the function return more than one value, so we need to
			-- top it off?
		require
			generator_not_void: sqlgenerator /= Void
		do
			Result := False
		end

	representation (
			sqlgenerator: SQL_GENERATOR;
			type: XPLAIN_TYPE;
			expression: detachable XPLAIN_EXPRESSION): XPLAIN_REPRESENTATION
			-- What's the Xplain representation for this function?
		require
			have_sqlgenerator: sqlgenerator /= Void
			have_type: type /= Void
			-- expression may be Void
		deferred
		ensure
			has_representation: Result /= Void
		end

	sqlextenddefault (sqlgenerator: SQL_GENERATOR; expression: detachable XPLAIN_EXPRESSION): STRING
			-- default to use for extension when function can return a Null value
		require
			have_sqlgenerator: sqlgenerator /= Void
		do
			Result := "Null"
		end

	sp_function_type (sqlgenerator: SQL_GENERATOR; a_selection: XPLAIN_SELECTION_FUNCTION; an_emit_path: BOOLEAN): STRING
			-- Callback to generator to retrieve function type for
			-- PostgreSQL functions.
		require
			sqlgenerator_not_void: sqlgenerator /= Void
			selection_not_void: a_selection /= Void
		local
			column_name: STRING
		do
			if attached a_selection.property as property then
				if attached property.column_name as cn then
					column_name := a_selection.function.name + once "_" + cn
				else
					column_name := a_selection.function.name
				end
				Result := sqlgenerator.sp_function_type_for_selection_value (column_name, property.representation (sqlgenerator), an_emit_path)
			else
				Result := sqlgenerator.sp_function_type_for_selection_value (a_selection.subject.type.sqlname (sqlgenerator), a_selection.subject.type.representation, an_emit_path)
			end
		end

	sqlfunction (sqlgenerator: SQL_GENERATOR): STRING
			-- SQL function statement for this function.
		require
			have_sqlgenerator: sqlgenerator /= Void
		deferred
		end


feature -- Status

	is_existential: BOOLEAN
			-- Is this function an any or nil function?
		do
			Result := False
		end


end
