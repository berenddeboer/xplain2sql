note

	description:

		"Abstract generator, implements common features for generation of SQL%
		%and middleware code."

	author:	"Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer, see forum.txt"
	date:		"$Date: 2010/02/11 $"
	revision:	"$Revision: #12 $"

deferred class

	ABSTRACT_GENERATOR

feature -- Identifier capabilities

	MaxIdentifierLength: INTEGER
			-- Maximum length of identifiers
		deferred
		ensure
			positive: MaxIdentifierLength > 0
		end

feature -- Identifier reformat routines

	no_space_identifier (name: STRING): STRING
			-- Return a valid identifier for a give Xplain name.
			-- if identifier contains spaces, they are replaced by underscores.
		require
			name_not_empty: name /= Void and then not name.is_empty
		local
			s: STRING
			i: INTEGER
			current_char_is_space: BOOLEAN
		do
			if name.count > MaxIdentifierLength then
				s := name.substring (1, MaxIdentifierLength)
			else
				s := name.twin
			end
			from
				i := 1
			until
				i > s.count
			loop
				current_char_is_space := s.item (i) = ' '
				if current_char_is_space then
					s.put ('_', i)
				end
				i := i + 1
			end
			Result := s
		ensure
			got_result: Result /= Void and then not Result.is_empty
			no_spaces: Result.index_of (' ', 1) = 0
		end

	path_identifier (name: STRING): STRING
			-- Return a valid identifier for a give Xplain name.
			-- if identifier contains spaces, they are replaced by dashes.
		require
			name_not_empty: name /= Void and then not name.is_empty
		local
			s: STRING
			i: INTEGER
			current_char_is_space: BOOLEAN
		do
			s := name.twin
			from
				i := 1
			until
				i > s.count
			loop
				current_char_is_space := s.item (i) = ' '
				if current_char_is_space then
					s.put ('-', i)
				end
				i := i + 1
			end
			Result := s
		ensure
			got_result: Result /= Void and then not Result.is_empty
			no_spaces: Result.index_of (' ', 1) = 0
		end


feature -- Assertions

	CalculatedColumnsSupported: Boolean
		-- Does this SQL dialect support columns whose value is based on
		-- an expression?
		once
			Result := False
		end

feature -- Type specification for xplain types

	datatype_boolean (representation: XPLAIN_B_REPRESENTATION): STRING
		deferred
		ensure
			valid_string: result /= Void
		end

	datatype_char (representation: XPLAIN_C_REPRESENTATION): STRING
		deferred
		ensure
			valid_string: result /= Void
		end

	datatype_datetime (representation: XPLAIN_D_REPRESENTATION): STRING
		deferred
		ensure
			valid_string: result /= Void
		end

	datatype_float (representation: XPLAIN_F_REPRESENTATION): STRING
			-- Platform dependent approximate numeric data type using
			-- largest size available on that platform.
		deferred
		ensure
			valid_string: result /= Void
		end

	datatype_int (representation: XPLAIN_I_REPRESENTATION): STRING
		deferred
		ensure
			valid_string: result /= Void
		end

	datatype_money (representation: XPLAIN_M_REPRESENTATION): STRING
		deferred
		ensure
			valid_string: result /= Void
		end

	datatype_numeric (representation: XPLAIN_R_REPRESENTATION): STRING
			-- Exact numeric data type.
		deferred
		ensure
			valid_string: result /= Void
		end

	datatype_picture (representation: XPLAIN_P_REPRESENTATION): STRING
		deferred
		ensure
			valid_string: result /= Void
		end

	datatype_pk_char (representation: XPLAIN_PK_A_REPRESENTATION): STRING
		deferred
		ensure
			valid_string: result /= Void
		end

	datatype_pk_int (representation: XPLAIN_PK_I_REPRESENTATION): STRING
		deferred
		ensure
			valid_string: result /= Void
		end

	datatype_ref_int (representation: XPLAIN_PK_I_REPRESENTATION): STRING
			-- foreign key data type for integer primary keys
		do
			Result := datatype_int (representation)
		end

	datatype_text (representation: XPLAIN_T_REPRESENTATION): STRING
		deferred
		ensure
			valid_string: result /= Void
		end

	datatype_varchar (representation: XPLAIN_A_REPRESENTATION): STRING
		deferred
		ensure
			valid_string: result /= Void
		end

feature -- Type specifications for attributes

	columndatatype_base (base: XPLAIN_BASE): STRING
		do
			Result := base.representation.datatype (Current)
		end

	columndatatype_type (type: XPLAIN_TYPE): STRING
		do
			Result := type.representation.datatype (Current)
		end

	columndatatype_assertion (assertion: XPLAIN_ASSERTION): STRING
		require
			can_translate_asserts: CalculatedColumnsSupported
		do
			Result := "not yet supported"
		end

feature -- Booleans

	SQLTrue: STRING
			-- Return the value for True.
		deferred
		ensure
			not_empty: Result /= Void and then not Result.is_empty
		end

	SQLFalse: STRING
			-- Return the value for False.
		deferred
		ensure
			not_empty: Result /= Void and then not Result.is_empty
		end

feature -- Expression generation

	as_string (s: STRING): STRING
			-- Return `s' as string by surrounding it with
			-- quotes. Special characters in string should be properly
			-- quoted.
		deferred
		ensure
			not_empty: Result /= Void and then not Result.is_empty
			at_least_empty_string: Result.count >= 2
		end

	sqlgetconstant (variable: XPLAIN_VARIABLE): STRING
			-- Expression that returns the contents of a constant
		require
			variable_not_void: variable /= Void
		deferred
		ensure
			expression_returned: Result /= Void and then not Result.is_empty
		end

feature -- Code writing

	write_constant (constant: XPLAIN_VARIABLE)
			-- Code for constant definition.
		require
			constant_not_void: constant /= Void
		deferred
		end

	write_constant_assignment (constant: XPLAIN_VARIABLE; expression: XPLAIN_EXPRESSION)
			-- Code for constant assignment.
		require
			valid_constant: constant /= Void
			valid_expression: expression /= Void
		deferred
		end

	write_delete (subject: XPLAIN_SUBJECT; predicate: XPLAIN_EXPRESSION)
			-- Code for delete statement.
		require
			subject_not_void: subject /= Void
		deferred
		end

	write_extend (extension: XPLAIN_EXTENSION)
			-- Code for extend statement.
		require
			valid_extension: extension /= Void
		deferred
		end

	write_get_insert (
		a_selection: XPLAIN_SELECTION_LIST
		an_insert_type: XPLAIN_TYPE
		an_auto_primary_key: BOOLEAN
		an_assignment_list: XPLAIN_ATTRIBUTE_NAME_NODE)
			-- Get into a table.
		require
			selection_not_void: a_selection /= Void
			insert_type_not_void: an_insert_type /= Void
		deferred
		end

	write_insert (type: XPLAIN_TYPE; id: XPLAIN_EXPRESSION; assignment_list: XPLAIN_ASSIGNMENT_NODE)
			-- Code for insert statement.
		require
			type_not_void: type /= Void
			assignment_list_not_void: assignment_list /= Void
		deferred
		end

	write_procedure (procedure: XPLAIN_PROCEDURE)
			-- Code for an Xplain procedure.
		require
			procedure_not_void: procedure /= Void
		deferred
		end

	write_select (selection: XPLAIN_SELECTION)
			-- Code for get (various forms) or value statements.
		require
			valid_selection: selection /= Void
		deferred
		end

	write_select_function (selection_list: XPLAIN_SELECTION_FUNCTION)
			-- Write get with function.
		require
			select_list_not_void: selection_list /= Void
		deferred
		end

	write_select_list (selection_list: XPLAIN_SELECTION_LIST)
			-- Write get with zero or more attributes.
		require
			selection_list_not_void: selection_list /= Void
		deferred
		end

	write_select_value (value: XPLAIN_VALUE)
			-- Value selection: value v.
		require
			valid_value: value /= Void
		deferred
		end

	write_sql (sql: STRING)
			--- Write literal SQL.
		deferred
		end

	write_type (type: XPLAIN_TYPE)
			-- Code for a type definition.
		require
			valid_type: type /= Void
		deferred
		end

	write_update (
			subject: XPLAIN_SUBJECT;
			assignment_list: XPLAIN_ASSIGNMENT_NODE;
			predicate: XPLAIN_EXPRESSION)
			-- Code for update statement.
		require
			subject_not_void: subject /= Void
			assignment_list_not_void: assignment_list /= Void
			attributes_known: True -- every attribute_name in assignment_list has its `attribute' set.
		deferred
		end

	write_value (value: XPLAIN_VALUE)
			-- Value definition (includes assignment): value v = 10.
		require
			valid_value: value /= Void
		deferred
		end

invariant

	max_identifier_length_positive: MaxIdentifierLength > 0

end
