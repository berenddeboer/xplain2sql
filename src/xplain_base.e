note

	description: "Xplain base type"

	author:		"Berend de Boer <berend@pobox.com>"
	copyright:	"Copyright (c) 1999, Berend de Boer"

class

	XPLAIN_BASE

inherit

	XPLAIN_ABSTRACT_TYPE

create

	make

feature -- to be overriden, callback into sqlgenerator

	sqlname (sqlgenerator: SQL_GENERATOR): STRING
			-- name as known in sql code
		do
			Result := sqlgenerator.domain_identifier (Current)
		end


feature

	write_drop (sqlgenerator: SQL_GENERATOR)
		do
			sqlgenerator.drop_domain (Current)
		end


feature

	columndatatype (mygenerator: ABSTRACT_GENERATOR): STRING
		do
			Result := mygenerator.columndatatype_base (Current)
		end


feature -- implementation of deferred routines

	sqlcolumnidentifier (sqlgenerator: SQL_GENERATOR; role: detachable STRING): STRING
			-- name of base/type when used as a column in a create table
			-- or select statement
		do
			Result := sqlgenerator.sqlcolumnidentifier_base (Current, role)
		end

	sqlcolumndefault (sqlgenerator: SQL_GENERATOR; an_attribute: XPLAIN_ATTRIBUTE): detachable STRING
		do
			Result := sqlgenerator.sqlcolumndefault_base (an_attribute)
		end

	sqlcolumnrequired (sqlgenerator: SQL_GENERATOR; an_attribute: XPLAIN_ATTRIBUTE): READABLE_STRING_GENERAL
		do
			Result := sqlgenerator.sqlcolumnrequired_base (an_attribute)
		end

end
