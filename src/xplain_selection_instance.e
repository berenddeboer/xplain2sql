note

	description: "selection of a single value using an instance id."
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2001, Berend de Boer"
	date:       "$Date: 2010/02/11 $"
	revision:   "$Revision: #8 $"


class

	XPLAIN_SELECTION_INSTANCE


inherit

	XPLAIN_SELECTION_VALUE


create

	make


feature {NONE} -- Initialization

	make (a_subject: XPLAIN_SUBJECT
			a_property: XPLAIN_EXPRESSION)
		require
			subject_not_void: a_subject /= Void
			property_not_void: a_property /= Void
		do
			subject := a_subject
			property := a_property
		end


feature -- Access

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION
			-- suitable representation
		do
			Result := property.representation (sqlgenerator)
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING
			-- return the sql expression that returns a single value
		do
			Result := sqlgenerator.sql_select_instance (Current)
		end


feature -- SQL generation

	sp_function_type (sqlgenerator: SQL_GENERATOR; an_emit_path: BOOLEAN): STRING
			-- Callback in generator to generate function type for
			-- PostgreSQL functions.
		do
			Result := sqlgenerator.sp_function_type_for_selection_value (subject.type.sqlname (sqlgenerator), subject.type.representation, an_emit_path)
		end

	write_select (sqlgenerator: SQL_GENERATOR)
		do
			sqlgenerator.write_select_instance (Current)
		end


invariant

	property_not_void: property /= Void

end
