indexing

	description: "Xplain abstract function"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2010/02/11 $"
	revision:   "$Revision: #8 $"


deferred class

	XPLAIN_FUNCTION


feature -- Status

	is_some: BOOLEAN is
		do
			Result := False
		end

	property_required: INTEGER is
			-- Does function need the presence of a property?
			-- 0: forbidden; 1: must be presented; 2: don't care either way
		deferred
		ensure
			recognized_result: Result = 0 or Result = 1 or Result = 2
		end


feature -- Access

	name: STRING is
			-- Xplain name of function
		deferred
		ensure
			name_not_empty: Result /= Void and then not Result.is_empty
		end

	needs_coalesce: BOOLEAN is
			-- Need to give a default value in case function can return a
			-- Null.
		do
			Result := True
		end

	needs_distinct: BOOLEAN is
			-- Does function need a distinct clause (count function)
		do
			Result := False
		end

	needs_limit (sqlgenerator: SQL_GENERATOR): BOOLEAN is
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
			expression: XPLAIN_EXPRESSION): XPLAIN_REPRESENTATION is
			-- What's the Xplain representation for this function?
		require
			have_sqlgenerator: sqlgenerator /= Void
			have_type: type /= Void
			-- expression may be Void
		deferred
		ensure
			has_representation: Result /= Void
		end

	sqlextenddefault (sqlgenerator: SQL_GENERATOR; expression: XPLAIN_EXPRESSION): STRING is
			-- default to use for extension when function can return a Null value
		require
			have_sqlgenerator: sqlgenerator /= Void
		do
			Result := "Null"
		end

	sp_function_type (sqlgenerator: SQL_GENERATOR; a_selection: XPLAIN_SELECTION_FUNCTION; an_emit_path: BOOLEAN): STRING is
			-- Callback to generator to retrieve function type for
			-- PostgreSQL functions.
		require
			sqlgenerator_not_void: sqlgenerator /= Void
			selection_not_void: a_selection /= Void
		local
			column_name: STRING
		do
			if a_selection.property = Void then
				Result := sqlgenerator.sp_function_type_for_selection_value (a_selection.subject.type.sqlname (sqlgenerator), a_selection.subject.type.representation, an_emit_path)
			else
				column_name := a_selection.property.column_name
				if column_name = Void then
					column_name := a_selection.function.name
				else
					column_name := a_selection.function.name + once "_" + column_name
				end
				Result := sqlgenerator.sp_function_type_for_selection_value (column_name, a_selection.property.representation (sqlgenerator), an_emit_path)
			end
		end

	sqlfunction (sqlgenerator: SQL_GENERATOR): STRING is
			-- SQL function statement for this function.
		require
			have_sqlgenerator: sqlgenerator /= Void
		deferred
		end


feature -- Status

	is_existential: BOOLEAN is
			-- Is this function an any or nil function?
		do
			Result := False
		end


end
