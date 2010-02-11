indexing

	description:

		"Describes the Xplain extension get .. insert"

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2007, Berend de Boer"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2008/12/15 $"
	revision: "$Revision: #2 $"


class

	XPLAIN_GET_INSERT_STATEMENT


inherit

	XPLAIN_STATEMENT


create

	make


feature {NONE} -- Initialization

	make (
		a_selection: XPLAIN_SELECTION_LIST;
		an_insert_type: XPLAIN_TYPE;
		an_auto_primary_key: BOOLEAN
		an_assignment_list: XPLAIN_ATTRIBUTE_NAME_NODE) is
		require
			selection_not_void: a_selection /= Void
			type_not_void: an_insert_type /= Void
		do
			selection := a_selection
			insert_type := an_insert_type
			auto_primary_key := an_auto_primary_key
			assignment_list := an_assignment_list
		end


feature -- Generate output

	write (a_generator: ABSTRACT_GENERATOR) is
			-- Write output according to this generator.
		do
			a_generator.write_get_insert (selection, insert_type, auto_primary_key, assignment_list)
		end


feature --  Warnings

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Is parameter `a_parameter' used by this statement?
		do
			Result := selection.uses_parameter (a_parameter)
		end


feature -- Access

	selection: XPLAIN_SELECTION_LIST

	insert_type: XPLAIN_TYPE

	auto_primary_key: BOOLEAN

	assignment_list: XPLAIN_ATTRIBUTE_NAME_NODE
			-- List of attributes; Void to mean all attributes of this type


invariant

	selection_not_void: selection /= Void
	type_not_void: insert_type /= Void

end
