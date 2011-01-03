indexing

	description: "Xplain base type"

	author:		"Berend de Boer <berend@pobox.com>"
	copyright:	"Copyright (c) 1999, Berend de Boer"
	date:			"$Date: 2008/12/15 $"
	revision:	"$Revision: #4 $"

class

	XPLAIN_BASE

inherit

	XPLAIN_ABSTRACT_TYPE

create

	make

feature -- to be overriden, callback into sqlgenerator

	sqlname (sqlgenerator: SQL_GENERATOR): STRING is
			-- name as known in sql code
		do
			Result := sqlgenerator.domain_identifier (Current)
		end


feature

	write_drop (sqlgenerator: SQL_GENERATOR) is
		do
			sqlgenerator.drop_domain (Current)
		end


feature

	columndatatype (mygenerator: ABSTRACT_GENERATOR): STRING is
		do
			Result := mygenerator.columndatatype_base (Current)
		end


feature -- implementation of deferred routines

	sqlcolumnidentifier (sqlgenerator: SQL_GENERATOR; role: STRING): STRING is
			-- name of base/type when used as a column in a create table
			-- or select statement
		do
			Result := sqlgenerator.sqlcolumnidentifier_base (Current, role)
		end

	sqlcolumndefault (sqlgenerator: SQL_GENERATOR; an_attribute: XPLAIN_ATTRIBUTE): STRING is
		do
			Result := sqlgenerator.sqlcolumndefault_base (an_attribute)
		end

	sqlcolumnrequired (sqlgenerator: SQL_GENERATOR; an_attribute: XPLAIN_ATTRIBUTE): STRING is
		do
			Result := sqlgenerator.sqlcolumnrequired_base (an_attribute)
		end

end
