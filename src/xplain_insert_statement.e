note

	description: "Describes the Xplain insert statement."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2002, Berend de Boer"

class

	XPLAIN_INSERT_STATEMENT


inherit

	XPLAIN_STATEMENT


create

	make


feature -- Initialization

	make (a_type: XPLAIN_TYPE; an_id: like id; an_assignment_list: XPLAIN_ASSIGNMENT_NODE)
		require
			type_not_void: a_type /= Void
			assignment_list_not_void: an_assignment_list /= Void
		do
			type := a_type
			id := an_id
			assignment_list := an_assignment_list
		end


feature -- Generate output

	write (a_generator: ABSTRACT_GENERATOR)
			-- Write output according to this generator.
		do
			a_generator.write_insert (type, id, assignment_list)
		end


feature --  Warnings

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Is parameter `a_parameter' used by this statement?
		local
			node: detachable like assignment_list
		do
			Result :=
				attached id as my_id and then
				my_id.uses_parameter (a_parameter)
			from
				node := assignment_list
			until
				Result or else
				node = Void
			loop
				Result := node.item.expression.uses_parameter (a_parameter)
				node := node.next
			end
		end


feature -- Access

	type: XPLAIN_TYPE
	id: detachable XPLAIN_EXPRESSION
	assignment_list: XPLAIN_ASSIGNMENT_NODE


invariant

	type_not_void: type /= Void
	assignment_list_not_void: assignment_list /= Void

end
