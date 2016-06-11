note

	description:

		"Called from xplain scanner and parser to produce middleware output."

	remark: "Class should become obsolete, as soon as XSLT stylesheet has been developed that can replace DELPHI_ADO_GENERATOR."

	author:     "Berend de Boer <berend@pobox.com>"

deferred class

	MIDDLEWARE_GENERATOR

inherit

	ABSTRACT_GENERATOR


feature -- Main routines

	dump_type (type: XPLAIN_TYPE; sqlgenerator: SQL_GENERATOR)
			-- Called to write code for a type.
		require
			type_not_void: type /= Void
			sqlgenerator_not_void: sqlgenerator /= Void
		deferred
		end

	dump_statements (statements: XPLAIN_STATEMENTS; sqlgenerator: SQL_GENERATOR)
			-- Given a list of all executed statements, do something with it.
		require
			statements_not_void: statements /= Void
			sqlgenerator_not_void: sqlgenerator /= Void
		deferred
		end

feature -- code writing

	get_column_value (column_name: STRING): STRING
			-- Get value for a certain column.
		deferred
		end

	get_column_value_string (column_name: STRING): STRING
			-- Get value for a certain column if it is a string.
		deferred
		end


end
