note

	description: "Class that generates an XML string."

	notes: "Shamelessly copied from eposix."

	author: "Berend de Boer"
	date: "$Date: 2008/12/15 $"
	revision: "$Revision: #5 $"

class

	XML_WRITER

inherit

	KL_IMPORTED_STRING_ROUTINES

create

	make,
	make_with_capacity


feature {NONE} -- Initialization

	make
		do
			make_with_capacity (1024)
		end

	make_with_capacity (a_capacity: INTEGER)
		do
			create my_xml.make (a_capacity)
			create tags.make
			create attributes.make (0, 32)
			create values.make (0, 32)
			clear
		end


feature -- constants from the XML specification, should be Unicode...

	ValidFirstChars: STRING = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_:"
			-- which characters are valid as the first character

	ValidOtherChars: STRING = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_:.-0123456789"
			-- which characters are valid as second etc characters


feature -- queries

	is_a_parent (tag: STRING): BOOLEAN
			-- True if `tag' is a container (parent) at the current level
			-- That can be a just started tag, or a tag higher up
		do
			Result := tags.has (tag)
		end

	is_header_written: BOOLEAN
		do
			Result := header_written
		end

	is_started (tag: STRING): BOOLEAN
			-- True if this tag has just been started
		do
			Result := tags.item.is_equal (tag)
		end

	is_tag_started: BOOLEAN
		do
			Result := not tags.is_empty
		end

	is_valid_attribute_name (an_attribute: STRING): BOOLEAN
			-- Return True if this is a valid attribute name
		local
			first,
			other: CHARACTER
			i: INTEGER
		do
			Result := an_attribute /= Void and then not an_attribute.is_empty
			if Result then
				first := an_attribute.item (1)
				Result := ValidFirstChars.has (first)
				from
					i := 2
				until
					not Result or else i = an_attribute.count
				loop
					other := an_attribute.item (i)
					Result := ValidOtherChars.has (other)
					i := i + 1
				end
			end
		end

	unfinished_xml: STRING
			-- the `xml' in progress
		do
			Result := my_xml
		end

	xml: STRING
			-- the result
		require
			building_finished: not is_tag_started
		do
			Result := my_xml
		end


feature -- influence state

	clear
			-- start fresh
		do
			xml.wipe_out
			tags.wipe_out
			clear_attributes
			header_written := False
			may_close_tag := False
			tag_closed := False
			tag_written := True
		ensure
			no_tags: tags.is_empty
		end


feature -- commands that expand `xml'

	add_header (encoding: STRING)
		require
			valid_point_for_header: not is_header_written
		do
			extend ("<?xml version=%"1.0%" encoding=%"")
			extend (encoding)
			extend ("%" ?>")
			new_line
			header_written := True
		end

	add_header_iso_8859_1_encoding
		do
			add_header ("ISO-8859-1")
		end

	add_header_utf_8_encoding
		do
			add_header ("UTF-8")
		end

	add_data (data: STRING)
			-- write data in the current tag
			-- invalid characters like < or > are quoted
		require
			valid_point_for_data: is_tag_started
		local
			s: STRING
		do
			assure_last_tag_written
			if data /= Void and then not data.is_empty then
				create s.make_from_string (data)
				replace_content_meta_characters (s)
				extend (s)
			end
		end

	add_entity (name: STRING)
		do
			assure_last_tag_written
			extend ("&")
			extend (name)
			extend (";")
		end

	add_raw (raw_data: STRING)
			-- write `data' straight in the current tag, meta characters
			-- are not quoted.
		require
			valid_point_for_data: is_tag_started
		do
			assure_last_tag_written
			if raw_data /= Void and then not raw_data.is_empty then
				extend (raw_data)
			end
		end

	add_system_doctype (root_tag, system_id: STRING)
		require
			have_header: is_header_written
			valid_root_tag: root_tag /= Void and then not root_tag.is_empty
			valid_system_id: system_id /= Void and then not system_id.is_empty
		do
			extend ("<!DOCTYPE ")
			extend (root_tag)
			extend (" SYSTEM %"")
			extend (system_id)
			extend ("%">")
			new_line
		end

	add_tag (tag, data: STRING)
			-- shortcut for `add_tag', `add_data' and `stop_tag'
		require
			have_header: is_header_written
			valid_tag: tag /= Void and then not tag.is_empty
		do
			start_tag (tag)
			add_data (data)
			stop_tag
		end

	extend (stuff: STRING)
			-- add anything to the current `xml' string, you're on your own here!
			-- all changes to `my_xml' are made from here
		do
			if stuff /= Void and then not stuff.is_empty then
				my_xml.append_string (stuff)
			end
		end

	get_attribute (an_attribute: STRING): STRING
			-- Get contents of attribute `attribute' for current tag.
			-- Returns Void if attribute doesn't exist
		do
			if exist_attribute (an_attribute) then
				Result := get_value
			end
		end

	put_new_line
			-- write a new line at the current position
		do
			assure_last_tag_written
			new_line
		end

	put (a: ANY)
			-- write data within the current tag
		do
			add_data (a.out)
		end

	puts (stuff: STRING)
			-- write data within the current tag
		do
			add_data (stuff)
		end

	set_attribute (an_attribute, value: STRING)
			-- Set an attribute of the current tag.
			-- `value' may not contain an entity reference.
		require
			valid_attribute: is_valid_attribute_name (an_attribute)
		do
			if value = Void then
				do_set_attribute (an_attribute, Void)
			else
				do_set_attribute (an_attribute, make_valid_attribute_value (value))
			end
		end

	start_tag (tag: STRING)
			-- start a new tag
		require
			have_header: is_header_written
			valid_tag: tag /= Void and then not tag.is_empty
		do
			assure_last_tag_written
			tags.put (tag)
			tag_written := False
		end

	stop_tag
			-- stop last started tag
		require
			tag_is_started: is_tag_started
		do
			may_close_tag := True
			assure_last_tag_written
			if not tag_closed then
				if on_new_line then
					indent
				end
				extend ("</")
				extend (tags.item)
				extend (">")
				new_line_after_closing_tag (tags.item)
			end
			tags.remove
		end


feature -- quote unsafe characters

	replace_content_meta_characters (s: STRING)
			-- replace all characters in s that have a special meaning in
			-- XML. These characters are < and &
		local
			i: INTEGER
			c: CHARACTER
		do
			from
				i := 1
			until
				i > s.count
			loop
				c := s.item (i)
				inspect c
				when '<' then
					s.put ('&', i)
					s.insert_string (PartQuoteLt, i+1)
					i := i + QuoteLt.count
				when '&' then
					s.insert_string (PartQuoteAmp, i+1)
					i := i + QuoteAmp.count
				else
					i := i + 1
				end
			end
		end


feature -- comments

	start_comment
		do
			assure_last_tag_written
			extend ("<!--")
		end

	stop_comment
		do
			extend ("-->")
		end


feature {NONE} -- internal xml change

	assure_last_tag_written
			-- starting a tag is a delayed activity. This routine makes
			-- sure the tag is really written
		local
			i: INTEGER
			v: STRING
		do
			tag_closed := False
			if not tag_written then
				if not on_new_line then
					new_line_before_starting_tag (tags.item)
				end
				if on_new_line then
					indent
				end
				extend ("<")
				extend (tags.item)
				from
					i := 0
				until
					i = attribute_count
				loop
					extend (" ")
					extend (attributes.item (i))
					extend ("=%"")
					v := values.item (i)
					if v /= Void then
						extend (v)
					end
					extend ("%"")
					i := i + 1
				end
				clear_attributes
				if may_close_tag then
					extend (empty_tag_closing_chars) -- i.e. "/>"
					new_line_after_closing_tag (tags.item)
					tag_closed := True
				else
					extend (">")
				end
				tag_written := True
			end
			may_close_tag := False
		ensure
			tag_is_written: tag_written
			tag_must_be_explictly_closed: not may_close_tag
		end

	empty_tag_closing_chars: STRING
			-- which characters to use for an empty tag?
			-- XHTML applications like an additional space
		do
			Result := "/>"
		end

	indent
		local
			spaces: STRING
		do
			if tags.count > 1 then
				create spaces.make_filled (' ', 2 * (tags.count - 1 ) )
				extend (spaces)
			end
		end

	make_valid_attribute_value (value: STRING): STRING
		local
			i: INTEGER
		do
			if value /= Void then
				Result := value.twin
				from
					i := 1
				until
					i > Result.count
				loop
					inspect Result.item (i)
					when '"' then
						Result.put ('&', i)
						Result.insert_string (PartQuoteQuote, i + 1)
						i := i + QuoteQuote.count
					when '<' then
						Result.put ('&', i)
						Result.insert_string (PartQuoteLt, i + 1)
						i := i + QuoteLt.count
					when '&' then
						Result.insert_string (PartQuoteAmp, i + 1)
						i := i + QuoteAmp.count
					else
						i := i + 1
					end
				end
			end
		end

	new_line
			-- write a new line now
			-- cannot be called indiscriminately, but only when a pending
			-- tag has been written. Use `put_new_line' for a safe variant
		do
			extend ("%N")
		end

	new_line_after_closing_tag (a_tag: STRING)
			-- outputs a new line, called when `a_tag' is closed
			-- can be overridden to start a new line only occasionally
			-- For XHTML documents a new line is treated as a single
			-- space, so it can influence layout.
		require
			valid_tag: a_tag /= Void and then not a_tag.is_empty
		do
			new_line
		end

	new_line_before_starting_tag (a_tag: STRING)
			-- outputs a new line, called when `a_tag' is about to begin.
		require
			valid_tag: a_tag /= Void and then not a_tag.is_empty
		do
			new_line
		end


feature {NONE} -- stack of tags

	tags: DS_LINKED_STACK [STRING]


feature {NONE} -- tag attributes

	attributes: ARRAY[STRING]

	values: ARRAY[STRING]

	current_attribute: INTEGER

	attribute_count: INTEGER

	add_attribute (an_attribute: STRING)
		do
			if attributes.count = attribute_count then
				attributes.resize (attributes.lower, attributes.upper * 2)
				values.resize (values.lower, values.upper * 2)
			end
			attributes.put (an_attribute, attribute_count)
			values.put (Void, attribute_count)
			attribute_count := attribute_count + 1
		end

	clear_attributes
		do
			attributes.clear_all
			values.clear_all
			attribute_count := 0
		end

	do_set_attribute (an_attribute, value: STRING)
		do
			if exist_attribute (an_attribute) then
				set_value (value)
			else
				add_attribute (an_attribute)
				set_value (value)
			end
		end

	exist_attribute (an_attribute: STRING): BOOLEAN
		do
			from
				current_attribute := 0
			until
				Result or else current_attribute = attribute_count
			loop
				Result := attributes.item (current_attribute).is_equal (an_attribute)
				if not Result then
					current_attribute := current_attribute + 1
				end
			end
		ensure
			Result implies valid_current_attribute
		end

	get_value: STRING
		require
			valid_index: valid_current_attribute
		do
			Result := values.item (current_attribute)
		end

	set_value (value: STRING)
		require
			valid_index: valid_current_attribute
		do
			values.put (value, current_attribute)
		end

	valid_current_attribute: BOOLEAN
		do
			Result :=
				current_attribute >= 0 and
				current_attribute < attribute_count
		end


feature {NONE} -- private state

	my_xml: STRING
			-- the string builded as we go

	header_written: BOOLEAN

	may_close_tag: BOOLEAN
			-- True if a tag may be closed immediately, i.e. written as
			-- <tag/> when it is started

	on_new_line: BOOLEAN
			-- True if cursor is on new line
		do
			Result :=
				my_xml.is_empty or else
				(my_xml.count >= 1 and then my_xml.item (my_xml.count) = '%N')
		end

	tag_closed: BOOLEAN

	tag_written: BOOLEAN


feature {NONE} -- attribute value sanitize

	QuoteAmp: STRING = "&amp;"
	QuoteLt: STRING = "&lt;"
	QuoteGt: STRING = "&gt;"
	QuoteQuote: STRING = "&quot;"

	PartQuoteAmp: STRING = "amp;"
	PartQuoteLt: STRING = "lt;"
	PartQuoteGt: STRING = "gt;"
	PartQuoteQuote: STRING = "quot;"


invariant

	same_size: attributes.count = values.count
	has_tag_stack: tags /= Void

end
