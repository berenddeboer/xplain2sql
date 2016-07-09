note

	description: "Selection of values, i.e. a single instance."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"


deferred class

	XPLAIN_SELECTION


feature -- Access

	type: XPLAIN_TYPE
			-- Type we operate on
		do
			Result := subject.type
		ensure
			type_not_void: Result /= Void
			synchronized: subject.type = Result
		end

	predicate: detachable XPLAIN_EXPRESSION
			-- Optional predicate (where clause).

	subject: XPLAIN_SUBJECT
			-- Type and optional instance we operate on


feature -- Status

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Is parameter `a_parameter' used by this statement?
		do
			Result :=
				(attached subject.identification as id and then
				 id.uses_parameter (a_parameter)) or else
				(attached predicate as p and then
				 p.uses_parameter (a_parameter))
		end


feature -- Change

	set_predicate (a_predicate: XPLAIN_EXPRESSION)
		do
			predicate := a_predicate
		end


feature -- SQL generation

	add_to_join (sqlgenerator: SQL_GENERATOR; a_join_list: JOIN_LIST)
			-- retrieval statement can make sure the join_list is up to
			-- date
		require
			valid_generator: sqlgenerator /= Void
			valid_join_list: a_join_list /= Void
			-- join_list is created starting with `type'
		do
			-- add where clause
			if attached predicate as p then
				a_join_list.enable_existential_join_optimisation
				p.add_to_join (sqlgenerator, a_join_list)
				a_join_list.disable_existential_join_optimisation
			end
		end

	sp_function_type (sqlgenerator: SQL_GENERATOR; an_emit_path: BOOLEAN): STRING
			-- Callback in generator to generate function type for
			-- PostgreSQL functions.
		require
			generator_not_void: sqlgenerator /= Void
		deferred
		ensure
			function_type_not_empty: Result /= Void and then not Result.is_empty
		end

	write_select (a_generator: ABSTRACT_GENERATOR)
			-- Callback to proper write method.
		require
			a_generator_not_void: a_generator /= Void
		deferred
		end


invariant

	have_subject: subject /= Void

end
