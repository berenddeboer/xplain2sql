note

	description: "Traverses over Xplain attributes with inits."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2001, Berend de Boer"


class

	XPLAIN_INIT_ATTRIBUTES_CURSOR [G]


inherit

	DS_FILTER_CURSOR [XPLAIN_ATTRIBUTE]
		rename
			make as ds_make,
			is_included as is_initialized_attribute
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

	is_initialized_attribute: BOOLEAN
		do
			Result := attached item.init
		end


end
