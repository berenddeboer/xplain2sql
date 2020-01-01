note

	description:

	"Tracks scanner state for currently parsed file."

	author:     "Berend de Boer <berend@pobox.com>"


class

	XPLAIN_SCANNER_STATE


create {XPLAIN_SCANNER}

	make_file,
	make_include,
	make_use,
	make_stdin


feature {NONE} -- Initialization

	make_file, make_include (a_input_buffer: YY_BUFFER; a_filename: STRING)
			-- state based on file reading
		require
			valid_buffer: a_input_buffer /= Void
		do
			do_make (a_input_buffer)
			filename := a_filename
			set_directory
		end

	make_stdin (a_input_buffer: YY_BUFFER)
			-- state based on stdin reading
		require
			valid_buffer: a_input_buffer /= Void
		do
			do_make (a_input_buffer)
			filename := ""
			directory := ""
		end

	make_use (a_input_buffer: YY_BUFFER; a_filename: STRING)
			-- state based on .use file reading
		require
			valid_buffer: a_input_buffer /= Void
			filename_not_empty: a_filename /= Void and then not a_filename.is_empty
		do
			do_make (a_input_buffer)
			filename := a_filename
			set_directory
			use_mode := True
		ensure
			filename_set: filename.is_equal (a_filename)
			in_use_mode: use_mode
		end


feature {NONE} -- initialization

	do_make (a_input_buffer: YY_BUFFER)
		require
			valid_buffer: a_input_buffer /= Void
		do
			input_buffer := a_input_buffer
		end


feature -- state

	directory,
	filename: STRING

	input_buffer: YY_BUFFER

	use_mode: BOOLEAN
			-- read definitions, but do not generate code


feature {NONE} -- directory

	set_directory
			-- extract the directory part from `filename' and set `directory'
		require
			need_filename: not filename.is_empty
		local
			i: INTEGER
			dir_separator_found: BOOLEAN
		do
			from
				i := filename.count
			until
				i = 0 or dir_separator_found
			loop
				dir_separator_found :=
					filename.item (i) = '/' or else filename.item (i) = '\'
				i := i - 1
			variant
				i
			end
			if dir_separator_found then
				directory := filename.substring (1, i+1)
			else
				directory := ""
			end
		ensure
			direcory_set: directory /= Void
		end


invariant

	filename_implies_directory: filename.is_empty implies directory.is_empty

end
