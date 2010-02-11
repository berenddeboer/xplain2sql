indexing

	description: "Describes the Xplain update statement."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2002, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #4 $"

class

	XPLAIN_UPDATE_STATEMENT


inherit

	XPLAIN_STATEMENT
		redefine
			updates_attribute
		end


create

	make


feature -- Initialization

	make (
			a_subject: XPLAIN_SUBJECT;
			a_assignment_list: XPLAIN_ASSIGNMENT_NODE;
			a_predicate: XPLAIN_EXPRESSION) is
		require
			subject_not_void: a_subject /= Void
			assignment_list_not_void: a_assignment_list /= Void
		do
			subject := a_subject
			assignment_list := a_assignment_list
			predicate := a_predicate
		end


feature -- Generate output

	write (a_generator: ABSTRACT_GENERATOR) is
			-- Write output according to this generator.
		do
			a_generator.write_update (subject, assignment_list, predicate)
		end


feature --  Warnings

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Is parameter `a_parameter' used by this statement?
		local
			node: like assignment_list
		do
			Result :=
				subject.identification /= Void and then
				subject.identification.uses_parameter (a_parameter)
			from
				node := assignment_list
			until
				Result or else
				node = Void
			loop
				Result := node.item.expression.uses_parameter (a_parameter)
				node := node.next
			end
			if not Result then
				Result :=
					predicate /= Void and then
					predicate.uses_parameter (a_parameter)
			end
		end


feature -- Access

	subject: XPLAIN_SUBJECT
	assignment_list: XPLAIN_ASSIGNMENT_NODE
	predicate: XPLAIN_EXPRESSION


feature -- Status

	updates_attribute (a_type: XPLAIN_TYPE; an_attribute_name: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Does this statement update the attribute `an_attribute_name'
			-- of type ``a_type_name'?
		local
			p: XPLAIN_ASSIGNMENT_NODE
		do
			if subject.type = a_type then
				from
					p := assignment_list
				until
					Result or else
					p = Void
				loop
					Result := p.item.attribute_name.is_equal (an_attribute_name)
					p := p.next
				end
			end
		end


invariant

	subject_not_void: subject /= Void
	assignment_list_not_void: assignment_list /= Void

end
