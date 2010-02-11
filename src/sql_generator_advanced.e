indexing

	description:

		"SQL generator which dialect which supports procedures and triggers"

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2008/12/15 $"
	revision: "$Revision: #2 $"


deferred class

	SQL_GENERATOR_ADVANCED


inherit

	SQL_GENERATOR_WITH_SP
		undefine
			sqlcolumnrequired_base,
			sqlcolumnrequired_type
		end

	SQL_GENERATOR_WITH_TRIGGERS
		undefine
			create_select_value,
			create_value_assign,
			create_value_declare,
			drop_table,
			drop_value,
			sqlgetvalue,
			write_type
		end


feature -- create SQL for Xplain constructs

	create_init (type: XPLAIN_TYPE) is
			-- Generate sql code to give attributes of type a default value.
		deferred
		ensure then
			procedure_not_started: not is_stored_procedure
		end

end
