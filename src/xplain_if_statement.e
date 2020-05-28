note

	description:

		"If statement in stored procedure."

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2020, Berend de Boer"
	license: "MIT License (see LICENSE)"


class

	XPLAIN_IF_STATEMENT


inherit

	XPLAIN_STATEMENT
		redefine
			write_value_declare_inside_sp
		end


create

	make


feature {NONE} -- Initialisation

	make (a_logical_expression: XPLAIN_LOGICAL_EXPRESSION; a_then_statements, an_else_statements: detachable XPLAIN_STATEMENT_NODE)
		do
			logical_expression := a_logical_expression
			then_statements := new_statements (a_then_statements)
			else_statements := new_statements (an_else_statements)
		end


feature -- Access

	logical_expression: XPLAIN_LOGICAL_EXPRESSION

	then_statements,
	else_statements: DS_BILINKED_LIST [XPLAIN_STATEMENT]


feature -- Commands

	write (a_generator: ABSTRACT_GENERATOR)
			-- Write output according to this generator.
		do
			a_generator.write_if (Current)
		end

	write_value_declare_inside_sp (a_generator: SQL_GENERATOR_WITH_SP)
			-- Write output according to this generator.
		do
			a_generator.sp_value_declarations (then_statements)
			a_generator.sp_value_declarations (else_statements)
		end


feature -- Status

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
		do
			Result :=
				logical_expression.uses_parameter (a_parameter) or else
				statement_uses_parameter (then_statements, a_parameter) or else
				statement_uses_parameter (else_statements, a_parameter)
		end


feature {NONE} -- Implementation

	new_statements (a_node: detachable XPLAIN_STATEMENT_NODE): DS_BILINKED_LIST [XPLAIN_STATEMENT]
			-- Copy statements
		local
			snode: like a_node
		do
			create Result.make
			from
				snode := a_node
			until
				not attached snode
			loop
				Result.put_last (snode.item)
				snode := snode.next
			end
		end

	statement_uses_parameter (a_statements: DS_BILINKED_LIST [XPLAIN_STATEMENT]; a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
		do
			from
				a_statements.start
			until
				Result or else
				a_statements.after
			loop
				Result := a_statements.item_for_iteration.uses_parameter (a_parameter)
				a_statements.forth
			end

		end

end
