indexing

	description:

		"Access to some system/user function defined outside Xplain"

	library: "xplain2sql"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2006, Berend de Boer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2008/12/15 $"
	revision: "$Revision: #5 $"


class

	XPLAIN_USER_FUNCTION


inherit

	XPLAIN_EXPRESSION
		redefine
			add_to_join,
			column_name,
			is_using_other_attributes,
			sqlname
		end


create

	make


feature {NONE} -- Initialization

	make (a_name: STRING; a_parameters: XPLAIN_EXPRESSION_NODE) is
			-- Initialize.
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			name := a_name
			parameters := a_parameters
		end


feature -- Access

	parameters: XPLAIN_EXPRESSION_NODE

	name: STRING
			-- User function name


feature -- Status

	is_using_other_attributes (an_attribute: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Does this expression refer to other attributes as `an_attribute'?
			-- It is used to output better optimized SQL code.
		local
			p: XPLAIN_EXPRESSION_NODE
		do
			from
				p := parameters
			until
				p = Void or else
				Result
			loop
				Result := p.item.is_using_other_attributes (an_attribute)
				p := p.next
			end
		end

	uses_its: BOOLEAN is
			-- Does this expression refer to `a_parameter'?
		local
			p: XPLAIN_EXPRESSION_NODE
		do
			from
				p := parameters
			until
				p = Void or else
				Result
			loop
				Result := p.item.uses_its
				p := p.next
			end
		end

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Does this expression refer to `a_parameter'?
		local
			p: XPLAIN_EXPRESSION_NODE
		do
			from
				p := parameters
			until
				p = Void or else
				Result
			loop
				Result := p.item.uses_parameter (a_parameter)
				p := p.next
			end
		end


feature -- SQL code

	add_to_join (sqlgenerator: SQL_GENERATOR; join_list: JOIN_LIST) is
			-- Possibility of expression to add something to join part of
			-- a select statement.
		local
			p: XPLAIN_EXPRESSION_NODE
		do
			from
				p := parameters
			until
				p = Void
			loop
				p.item.add_to_join (sqlgenerator, join_list)
				p := p.next
			end
		end

	column_name: STRING is
			-- The Xplain based column heading name, if any; it is used
			-- by PostgreSQL output to create the proper function type
			-- for example. The XML_GENERATOR uses it to give clients
			-- some idea what the column name of a select is going to be.
		do
			Result := name
		end

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION is
			-- The representation of this user function
		do
			-- TODO: don't know representation
			Result := sqlgenerator.value_representation_char (250)
		end

	sqlinitvalue (sqlgenerator: SQL_GENERATOR_WITH_TRIGGERS): STRING is
			-- Expression in sql syntax used in init statements. Equal to
			-- `sqlvalue' in many cases, but usually if you refer to
			-- an attribute of `a_type' it has to be prefixed by "new." for
			-- example.
		do
			Result := sqlvalue (sqlgenerator)
		end

	sqlname (sqlgenerator: SQL_GENERATOR): STRING is
			-- Try to come up with the most likely column name for this
			-- expression, only applicable for attributes. If nothing
			-- found, return Void.
		do
			Result := name
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING is
			-- Expression in generator syntax
		local
			p: XPLAIN_EXPRESSION_NODE
		do
			create Result.make (name.count + 2)
			Result.append_string (name)
			Result.append_character ('(')
			from
				p := parameters
			until
				p = Void
			loop
				Result.append_string (p.item.sqlvalue (sqlgenerator))
				p := p.next
				if p /= Void then
					Result.append_character (',')
					Result.append_character (' ')
				end
			end
			Result.append_character (')')
		end


end
