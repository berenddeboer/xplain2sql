indexing

  description: "system variable expression"
  author:     "Berend de Boer <berend@pobox.com>"
  copyright:  "Copyright (c) 2000, Berend de Boer"
  date:       "$Date: 2008/12/15 $"
  revision:   "$Revision: #5 $"

deferred class

	XPLAIN_SYSTEM_EXPRESSION


inherit

	XPLAIN_NON_ATTRIBUTE_EXPRESSION
		redefine
			is_literal
		end


feature -- Status

	is_literal: BOOLEAN is True
			-- Is this expression a literal value?

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Does this expression refer to `a_parameter'?
		do
			Result := False
		end


end
