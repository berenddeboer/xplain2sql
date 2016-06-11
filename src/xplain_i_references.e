note

	description: "Xplain integer foreign key constraint restriction"
	author:     "Berend de Boer <berend@pobox.com>"


class

	XPLAIN_I_REFERENCES

inherit

	XPLAIN_IDENTIFICATION_RESTRICTION
		rename
			make as make_xplain_domain_restriction
		end

create

	make

feature -- initialization

	make
		do
			make_xplain_domain_restriction (True)
		end

end
