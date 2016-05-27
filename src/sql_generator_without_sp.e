note

	description: "Parent class for SQL versions that have no stored procedure support."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2005, Berend de Boer"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #3 $"


deferred class

	SQL_GENERATOR_WITHOUT_SP


inherit

	SQL_GENERATOR


feature -- Stored procedure options

	CreateStoredProcedure: BOOLEAN = False
			-- Should insert/update or delete stored procedures be
			-- created?

	NamedParametersSupported: BOOLEAN = False
			-- Can stored procedures use named parameters?

	StoredProcedureSupported: BOOLEAN = False
			-- Are stored procedures supported?

	SupportsDomainsInStoredProcedures: BOOLEAN = False
			-- We do not support stored procedures.


feature -- write statements

	write_procedure (procedure: XPLAIN_PROCEDURE)
			-- Write a stored procedure.
		do
			write_one_line_comment ("procedure " + procedure.name)
			std.error.put_string ("Skipping create of " + procedure.name + ", because stored procedures are not supported by this dialect.%N")
		end


feature -- drop statements

	drop_procedure (procedure: XPLAIN_PROCEDURE)
			-- Drop procedure `procedure'.
		do
			write_one_line_comment ("drop procedure " + procedure.name)
			std.error.put_string ("Dropping stored procedures is not supported by this dialect.%N")
		end


feature -- Some sp support to support some hacks

	sp_define_in_param (name: STRING): STRING
			-- Return `name' formatted as an sp input parameter, as it
			-- should appear in the header/definition of a stored
			-- procedure.
			-- Certain dialects have conventions for this like using a
			-- '@' in front of every identifier. Spaces and such should
			-- be removed if necessary, or the entry should be quoted if
			-- that is supported for sp's.
		do
			-- not applicable
		end

	sp_define_param_name (name: STRING): STRING
			-- Return `name' formatted as the name of the parameter as it
			-- appears in the header, and hopefully as it is known to
			-- clients. It must be quoted, if it can be quoted.
		do
			-- not applicable
		end

	sp_delete_name (type: XPLAIN_TYPE): STRING
			-- Name of stored procedure that deletes an instance of a type
		do
			-- not applicable
		end

	sp_insert_name (type: XPLAIN_TYPE): STRING
			-- Name of stored procedure that inserts an instance of a type
		do
			-- not applicable
		end

	sp_name (name: STRING): STRING
			-- Turn an Xplain name into a stored procedure name.
		do
			-- I suppose we should not be called here
		end

	sp_update_name (type: XPLAIN_TYPE): STRING
			-- Name of stored procedure that updates an instance of a type
		do
			-- not applicable
		end

	sp_use_param (name: STRING): STRING
			-- Return stored procedure parameter `name' formatted
			-- according to the dialects convention when using
			-- parameters in sql code. It is usually prefixed by '@' or
			-- ':'.
			-- Spaces and such should be removed if necessary, or the
			-- entry should be quoted if that is supported for sp's.
		do
			-- I suppose we should not be called here
		end

end
