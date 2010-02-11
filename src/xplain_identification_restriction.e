indexing

	description:

	"Xplain foreign key constraint restriction"

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #2 $"

deferred class XPLAIN_IDENTIFICATION_RESTRICTION

inherit
   
   XPLAIN_DOMAIN_RESTRICTION

feature
   
   owner: XPLAIN_TYPE

feature
   
   set_owner (aowner: XPLAIN_TYPE) is
      do
         owner := aowner
      end       
   
end -- class XPLAIN_IDENTIFICATION_RESTRICTION
