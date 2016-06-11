note

	description: "Traverses over real Xplain attributes, i.e. ones that %
	%can be written to. Virtual attributes and extends are skipped."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2001, Berend de Boer"


class

	XPLAIN_DATA_ATTRIBUTES_CURSOR


inherit

	DS_FILTER_CURSOR [XPLAIN_ATTRIBUTE]
		rename
			make as ds_make,
			is_included as is_not_virtual_attribute
		end


create {XPLAIN_TYPE}

	make


feature {NONE} -- Initialization

	make (type: XPLAIN_TYPE; sqlgenerator: SQL_GENERATOR)
		require
			type_not_void: type /= Void
			sqlgenerator_not_void: sqlgenerator /= Void
		do
			ds_make (type.attributes)
		end


feature -- checks

	is_not_virtual_attribute: BOOLEAN
		local
			is_virtual: BOOLEAN
		do
			is_virtual :=
				(item.is_assertion) or else
				(item.is_extension)
			Result := not is_virtual
		end


end
