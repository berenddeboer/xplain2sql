note

	description: "selection of a single value using a set function"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"

class

	XPLAIN_SELECTION_FUNCTION

inherit

	XPLAIN_SELECTION_VALUE

create

	make


feature {NONE} -- Initialization

	make (
			a_function: XPLAIN_FUNCTION
			a_subject: XPLAIN_SUBJECT
			a_property: detachable XPLAIN_EXPRESSION
			a_predicate: detachable XPLAIN_EXPRESSION)
		require
			function_not_void: a_function /= Void
			subject_not_void: a_subject /= Void
		do
			function := a_function
			subject := a_subject
			property := a_property
			predicate := a_predicate
		end


feature -- Access

	function: XPLAIN_FUNCTION
			-- The particular Xplain function


feature -- SQL generation

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION
			-- Suitable Xplain representation for this function.
		do
			Result := function.representation (sqlgenerator, type, property)
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING
			-- The sql expression that returns a single value
		do
			Result := sqlgenerator.sql_select_function_as_subselect (Current)
		end

	sp_function_type (sqlgenerator: SQL_GENERATOR_WITH_SP; an_emit_path: BOOLEAN): STRING
			-- Callback in generator to generate function type for
			-- PostgreSQL functions.
		do
			Result := function.sp_function_type (sqlgenerator, Current, an_emit_path)
		end

	write_select (a_generator: ABSTRACT_GENERATOR)
		do
			a_generator.write_select_function (Current)
		end


invariant

	have_function: function /= Void

end
