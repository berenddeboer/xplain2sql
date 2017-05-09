note

	description:

		"Xplain any or nil function"

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2006, Berend de Boer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"


deferred class

	XPLAIN_EXISTENTIAL_FUNCTION


inherit

	XPLAIN_FUNCTION
		redefine
			is_existential,
			needs_limit,
			sp_function_type
		end


feature -- Status

	is_existential: BOOLEAN = True
			-- Is this function an any or nil function?

	property_required: INTEGER = 2
			-- Does function need the presence of a property?
			-- 0: forbidden; 1: must be presented; 2: don't care either way


feature -- Access

	needs_limit (sqlgenerator: SQL_GENERATOR): BOOLEAN
			-- We need to return a single value in case an
			-- ExistentialFrom is needed (else all rows are selected).
		do
			Result := sqlgenerator.ExistentialFromNeeded
		end

	representation (
			 sqlgenerator: SQL_GENERATOR;
			 type: XPLAIN_TYPE;
			 expression: detachable XPLAIN_EXPRESSION): XPLAIN_REPRESENTATION
			-- What's the xplain representation for this function?
		do
			Result := sqlgenerator.value_representation_boolean
		end

	sp_function_type (sqlgenerator: SQL_GENERATOR_WITH_SP; a_selection: XPLAIN_SELECTION_FUNCTION; an_emit_path: BOOLEAN): STRING
			-- Callback to generator to retrieve function type for
			-- PostgreSQL functions.
		do
			Result := sqlgenerator.sp_function_type_for_selection_value (name + " " + a_selection.subject.type.sqlname (sqlgenerator), sqlgenerator.value_representation_boolean, an_emit_path)
		end


end
