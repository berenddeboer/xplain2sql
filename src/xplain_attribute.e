indexing

	description: "Xplain attribute"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2010/02/11 $"
	revision:   "$Revision: #10 $"

class

	XPLAIN_ATTRIBUTE

create

	make

feature {NONE} -- Initialization

	make (a_role: STRING;
			an_abstracttype: XPLAIN_ABSTRACT_TYPE;
			a_overrule_required, a_required, a_specialization,
			a_unique: BOOLEAN) is
		require
			role_void_or_not_empty: a_role = Void or else not a_role.is_empty
			abstracttype_is_valid_or_is_self_reference:
			-- if it is a self reference, we don't have the type yet
		do
			role := a_role
			abstracttype := an_abstracttype
			overrule_required := a_overrule_required
			is_required := a_required
			is_specialization := a_specialization
			is_unique := a_unique
		end


feature -- Status

	is_assertion: BOOLEAN is
			-- Is this a virtual attribute?
		do
			Result := False
		end

	is_extension: BOOLEAN is
			-- Is this an extended attribute?
		do
			Result := False
		end

	is_required: BOOLEAN
			-- Is a value required for this attribute?
			-- Xplain defaults to true, it's an extension to set this to false.

	is_specialization: BOOLEAN
			-- Is this attribute a specialisation?

	is_unique: BOOLEAN
			-- Are values in this attribute unique accross all instances
			-- of this type?
			-- Xplain extension, not in Xplain itself.

	is_init_default: BOOLEAN
			-- Is `init' expression a default only and can it be
			-- overriden at insert time?


feature -- Access

	abstracttype: XPLAIN_ABSTRACT_TYPE
			-- Base/type/extension that defines this attribute

	full_name: STRING is
		do
			if role = Void then
				Result := name
			else
				Result := role.twin
				Result.append_character ('_')
				Result.append_string (name)
			end
		ensure
			name_not_empty: Result /= Void and then not Result.is_empty
		end

	init: XPLAIN_EXPRESSION
			-- init or init default expression

	name: STRING is
		do
			Result := abstracttype.name
		end

	role: STRING

	overrule_required: BOOLEAN
			-- Use non-standard Xplain extension to allow user to specify
			-- null clause


feature -- Change

	set_abstracttype (aowner: XPLAIN_TYPE) is
			-- fix abstracttype when it is a self reference (reference to
			-- its owner in this case)
		require
			not_yet_set: abstracttype = Void
		do
			abstracttype := aowner
		ensure
			owner_set: aowner = abstracttype
		end

	set_required (a_required: BOOLEAN) is
		do
			is_required := a_required
		ensure
			definition: is_required = a_required
		end


feature -- Set Init [default] statement

	set_init_default (a_init: XPLAIN_EXPRESSION) is
			-- Set/clear init default expression for this attribute.
		do
			init := a_init
			is_init_default := True
		ensure
			init_set: init = a_init
			init_default_set: is_init_default
		end

	set_init (a_init: XPLAIN_EXPRESSION) is
			-- Set/clear init expression for this attribute.
		do
			init := a_init
			is_init_default := False
		ensure
			init_set: init = a_init
			init_default_not_set: not is_init_default
		end


feature -- SQL code

	q_sql_select_name (sqlgenerator: SQL_GENERATOR): STRING is
			-- Name to be used in select or order by statement. Should
			-- replace usage of `sqlcolumnidentifier'.
		require
			type_info_available: abstracttype /= Void
		do
			Result := abstracttype.q_sql_select_name (sqlgenerator, role)
		ensure
			result_not_empty: Result /= Void and then not Result.is_empty
		end

	sql_select_name (sqlgenerator: SQL_GENERATOR): STRING is
			-- Name to be used in select or order by statement. Should
			-- replace usage of `sqlcolumnidentifier'.
		require
			type_info_available: abstracttype /= Void
		do
			Result := abstracttype.sql_select_name (sqlgenerator, role)
		ensure
			result_not_empty: Result /= Void and then not Result.is_empty
		end

	write_drop (sqlgenerator: SQL_GENERATOR; a_type: XPLAIN_TYPE) is
		do
			sqlgenerator.write_drop_column (a_type, Current)
		end


invariant

	role_void_or_not_empty: role = Void or else not role.is_empty
	is_init_default_consistent: is_init_default implies init /= Void

end
