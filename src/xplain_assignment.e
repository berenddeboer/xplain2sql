indexing

	description: "Xplain assignment"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #4 $"

class XPLAIN_ASSIGNMENT

create

	make

feature {NONE} -- Initialization

	make (
			a_attribute_name: XPLAIN_ATTRIBUTE_NAME
			a_expression: XPLAIN_EXPRESSION) is
		require
			valid_attribute_name: a_attribute_name /= Void
			attribute_set: a_attribute_name.type_attribute /= Void
			valid_expression: a_expression /= Void
		do
			attribute_name := a_attribute_name
			expression := a_expression
		end


feature -- State

	attribute_name: XPLAIN_ATTRIBUTE_NAME
	expression: XPLAIN_EXPRESSION


invariant

	valid_attribute_name: attribute_name /= Void
	attribute_set: attribute_name.type_attribute /= Void
	valid_expression: expression /= Void

end
