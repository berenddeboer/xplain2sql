note

	description: "Class that can serve as parent to generate output for very basic SQL output, i.e. no stored procedures, domains, and such."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999,2005, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #4 $"


deferred class

	SQL_GENERATOR_SIMPLE


inherit

	SQL_GENERATOR_WITHOUT_SP
		redefine
			DomainsSupported
		end

	SQL_GENERATOR_WITHOUT_TRIGGERS
		redefine
			DomainsSupported
		end


feature -- Domain options

	DomainsSupported: BOOLEAN
			-- Does this dialect support creation of user defined data types?
		once
			Result := False
		end


feature -- ANSI specific SQL creation statements

	create_primary_key_generator (type: XPLAIN_TYPE)
		do
			-- nothing
		end

	create_use_database (database: STRING)
			-- start using a certain database
		do
			-- nothing
		end


feature -- drop statements

	drop_primary_key_generator (type: XPLAIN_TYPE)
		do
			-- nothing
		end


feature -- generation of init [default] expressions

	sqlinitvalue_attribute (expression: XPLAIN_ATTRIBUTE_EXPRESSION): STRING
			-- inits are not supported, we should not be called
		do
			-- n/a
			Result := ""
		end


feature -- Stored procedures

	sp_get_auto_generated_primary_key (type: XPLAIN_TYPE): STRING
			-- Statement that returns the generated primary key into the
			-- output parameters. Statement should end with CommandSeperator.
		do
			-- We should not be called
			Result := ""
		end


end
