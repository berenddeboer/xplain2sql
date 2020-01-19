note

	description:

		"SQL generator which dialect which supports procedures and triggers"

	author: "Berend de Boer <berend@pobox.com>"


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
			optional_create_value_declare,
			drop_table,
			drop_value,
			sqlgetvalue,
			write_type,
			can_write_extend_as_view
		end


feature -- create SQL for Xplain constructs

	create_init (type: XPLAIN_TYPE)
			-- Generate sql code to give attributes of type a default value.
		deferred
		ensure then
			procedure_not_started: not is_stored_procedure
		end

end
