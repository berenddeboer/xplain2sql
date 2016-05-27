note

	description:

		"Xplain representation abstraction. Every object has a representation"

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #8 $"


deferred class

	XPLAIN_REPRESENTATION


inherit

	ANY
		redefine
			is_equal
		end

	KL_SHARED_STANDARD_FILES
		export
			{NONE} all
		undefine
			is_equal
		end


feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object of the same type
			-- as current object and identical to it?
		do
			-- @@BdB: restriction comparison is not totally correct, but
			-- not used in situations where it will make a difference.
			Result :=
				domain.is_equal (other.domain) and then
				equal (domain_restriction, domain_restriction)
		end


feature -- Status

	is_blob (sqlgenerator: SQL_GENERATOR): BOOLEAN
			-- We need to be careful with storage space for blobs.
		require
			sqlgenerator_not_void: sqlgenerator /= Void
		do
			Result := False
		end

	write_with_quotes: BOOLEAN
			-- Should values of this type be surrounded by quotes?
		do
			Result := True
		end


feature -- Access

	domain: STRING
			-- Give Xplain domain as string like (I4) or (B).
		deferred
		ensure
			result_not_empty: Result /= Void and then not Result.is_empty
			at_least_three_characters: Result.count >= 3
		end

	domain_restriction: XPLAIN_DOMAIN_RESTRICTION

	value_representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION
			-- Representation suitable for the value statement. This
			-- means returning the most general form for this
			-- representation, i.e. for (I2) return (I9), for (R3,2)
			-- return R(9,9).
		require
			sqlgenerator_not_void: sqlgenerator /= Void
		do
			-- for many representations, this routine is not applicable
			-- because you don't encounter them in value expressions.
			-- override in descendents to really do something
			Result := void
		ensure
			valid_result: Result /= Void
		end

	xml_schema_data_type: STRING
			-- Best matching XML schema data type
		deferred
		ensure
			not_empty: Result /= Void and then not Result.is_empty
		end


feature -- Change

	set_domain_restriction (sqlgenerator: SQL_GENERATOR; adomain_restriction: XPLAIN_DOMAIN_RESTRICTION)
		require
			valid_generator: sqlgenerator /= Void
			valid_restriction: adomain_restriction /= Void
			valid_attatchment: True -- domain_restriction.check_attachment (sqlgenerator, Current)
		do
			domain_restriction := adomain_restriction
			domain_restriction.check_attachment (sqlgenerator, Current)
		end


feature  -- SQL code

	datatype (mygenerator: ABSTRACT_GENERATOR): STRING
			-- Data type according to `mygenerator';
			-- used for data type in create table definitions, stored procedures,
			-- or middleware.
		require
			mygenerator_not_void: mygenerator /= Void
			valid_restriction: domain_restriction /= Void
		deferred
		ensure
			valid_string: Result /= Void
		end

	default_value: STRING
			-- A default value to be used when a complex init is used and
			-- the column is not null and needs some value because the
			-- SQL dialect does not have the necessary before-insert
			-- trigger.
		deferred
		ensure
			value_not_empty: Result /= Void and then not Result.is_empty
		end

	max_value (sqlgenerator: SQL_GENERATOR): STRING
			-- Maximum value that fits in this representation.
		require
			sqlgenerator_not_void: sqlgenerator /= Void
		deferred
		ensure
			min_value_not_empty: Result /= Void and then not Result.is_empty
		end

	min_value (sqlgenerator: SQL_GENERATOR): STRING
			-- Minimum value that fits in this representation.
		require
			sqlgenerator_not_void: sqlgenerator /= Void
		deferred
		ensure
			min_value_not_empty: Result /= Void and then not Result.is_empty
		end


feature -- Middleware specific routines

	mw_column_value (mygenerator: MIDDLEWARE_GENERATOR; column_name: STRING): STRING
			-- Return piece of code to get contents.
			-- Getting values is usually type specific,
			-- not column_name specific.
		do
			Result := mygenerator.get_column_value (column_name)
		end

	mw_needs_precision: BOOLEAN
		do
			Result := False
		end

	mw_numeric_scale: INTEGER
		require
			is_numeric: mw_needs_precision
		do
			-- do nothing
		ensure
			Result >= 0
		end

	mw_precision: INTEGER
		require
			is_numeric: mw_needs_precision
		do
			-- do nothing
		ensure
			Result > 0
		end

invariant

	valid_domain_restriction: True
			-- domain_restriction /= Void
			-- cannot be mainted by creation instruction
			-- as available somewhat later in parsing stage

end
