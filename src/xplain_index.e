indexing

   description: "Xplain index"
   author:     "Berend de Boer <berend@pobox.com>"
   copyright:  "Copyright (c) 2000, Berend de Boer"
   date:       "$Date: 2008/12/15 $"
   revision:   "$Revision: #3 $"

class XPLAIN_INDEX

create

   make


feature -- type attributes

   type: XPLAIN_TYPE
   name: STRING
   is_unique: BOOLEAN
   is_clustered: BOOLEAN
   first_attribute: XPLAIN_ATTRIBUTE_NAME_NODE


feature -- initialization

   make (a_type: XPLAIN_TYPE; a_name: STRING; a_unique, a_clustered: BOOLEAN; 
         a_first_attribute: XPLAIN_ATTRIBUTE_NAME_NODE) is
      require
         valid_type: a_type /= Void
         valid_name: a_name /= Void
         valid_list: a_first_attribute /= Void
      do
         type := a_type
         name := a_name
         is_unique := a_unique
         is_clustered := a_clustered
         first_attribute := a_first_attribute
      end
   

end -- class XPLAIN_INDEX
