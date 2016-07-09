note

	description: "selection of multiple values"
	author:      "Berend de Boer <berend@pobox.com>"


class

	XPLAIN_SELECTION_LIST


inherit

	XPLAIN_SELECTION
		redefine
			add_to_join,
			uses_parameter
		end


create

	make


feature {NONE} -- Initialization

	make (
			a_subject: XPLAIN_SUBJECT
			an_expression_list: like expression_list
			a_predicate: like predicate
			a_sort_order: like sort_order)
		require
			subject_not_void: a_subject /= Void
		do
			subject := a_subject
			expression_list := an_expression_list
			predicate := a_predicate
			sort_order := a_sort_order
		end


feature -- Access

	expression_list: detachable XPLAIN_EXPRESSION_NODE
			-- Attributes of `type' that needs to be written;
			-- Void if all attributes of `subject' are to be written.

	identification_text: detachable STRING
			-- Text that is output before the type identification column

	show_only_identifier_column: BOOLEAN
			-- Does user asks for get t its ""?
		do
			if
				attached expression_list as el and then
				not attached el.next and then
				el.item.is_literal then
				if attached {XPLAIN_STRING_EXPRESSION} el.item as se then
					Result := se.value.is_empty
				end
			end
		end

	sort_order: detachable XPLAIN_SORT_NODE


feature -- Status

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Is parameter `a_parameter' used by this statement?
		local
			node: detachable like expression_list
		do
			Result := precursor (a_parameter)
			from
				node := expression_list
			until
				Result or else
				node = Void
			loop
				Result := node.item.uses_parameter (a_parameter)
				node := node.next
			end
		end


feature -- SQL generation

	add_to_join (sqlgenerator: SQL_GENERATOR; join_list: JOIN_LIST)
			-- Retrieval statement can make sure the join_list is up to
			-- date.
		local
			enode: detachable XPLAIN_EXPRESSION_NODE
			snode: detachable XPLAIN_SORT_NODE
		do
			-- add the retrieved attributes to the list
			from
				enode := expression_list
			until
				enode = Void
			loop
				enode.item.add_to_join (sqlgenerator, join_list)
				enode := enode.next
			end

			-- attributes in where clause
			precursor (sqlgenerator, join_list)

			-- and attributes in the order by clause
			from
				snode := sort_order
			until
				snode = Void
			loop
				join_list.extend (sqlgenerator, snode.item)
				snode := snode.next
			end
		end

	set_identification_text (a_text: STRING)
		do
			identification_text := a_text
		end

	sp_function_type (sqlgenerator: SQL_GENERATOR; an_emit_path: BOOLEAN): STRING
			-- Callback in generator to generate function type for
			-- PostgreSQL functions.
		do
			Result := sqlgenerator.sp_function_type_for_selection_list (Current, an_emit_path)
		end

	write_select (a_generator: ABSTRACT_GENERATOR)
		do
			a_generator.write_select_list (Current)
		end


end
