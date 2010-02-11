indexing

	description: "Produce middleware output for Delphi."

	known_bugs: "timestamp hardcoded to binary for SQL Server."


	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2000, Berend de Boer, see forum.txt"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #8 $"


class

	DELPHI_ADO_GENERATOR

obsolete "2003-10-15: Use XSLT transform on the generated XML output instead."

inherit

	KL_SHARED_STANDARD_FILES

	MIDDLEWARE_GENERATOR

	ADO_GENERATOR

	EXCEPTIONS

feature -- Main routines

	dump_type (type: XPLAIN_TYPE; sqlgenerator: SQL_GENERATOR) is
			-- Called to write code for a type.
		local
			a_class_name,
			file_name: STRING
			file: KL_TEXT_OUTPUT_FILE
			cursor: DS_LINEAR_CURSOR [XPLAIN_ATTRIBUTE]
		do
			a_class_name := no_space_identifier (type.name)
			file_name := "mw_" + a_class_name + ".pas"

			create file.make (file_name)
			file.open_write
			if not file.is_open_write then
				std.error.put_string ("xplain2sql: cannot write to file %'")
				std.error.put_string (file_name)
				std.error.put_string ("%'%N")
				--die (exit_failure_code)
				die (1)
			end

			-- unit comment
			file.put_string ("{ Low level Delphi middleware layer for type ")
			file.put_string (type.name)
			file.put_string (". }%N%N")

			-- unit header
			file.put_string ("unit mw_")
			file.put_string (a_class_name)
			file.put_string (";%N%N")
			file.put_string ("interface%N%N")
			file.put_string ("uses%N")
			file.put_string ("  ADODB_TLB,%N")
			file.put_string ("  mw_custom;%N%N")

			-- class header
			file.put_string ("type%N")
			file.put_string ("  Tmw")
			file.put_string (a_class_name)
			file.put_string (" = class(TmwCustom)%N")
			file.put_string ("  protected%N")
			file.put_string ("    function  DoCreateEmptyRecordset: Recordset; override;%N")
			file.put_string ("    procedure DoDelete(rs: Recordset); override;%N")
			file.put_string ("    procedure DoDeleteId(id: integer; const ts: OleVariant); override;%N")
			file.put_string ("    function  DoInsert(rs: Recordset): integer; override;%N")
			file.put_string ("    procedure DoUpdate(rs: Recordset); override;%N")
			file.put_string ("  end;%N%N")

			-- implementation
			file.put_string ("%Nimplementation%N%N")
			file.put_string ("{$IFNDEF VER130}%Nuses%N  Variants;%N{$ENDIF}%N")
			file.put_string ("%N{ Tmw")
			file.put_string (a_class_name)
			file.put_string (" }%N%N")

			-- DoCreateEmptyRecordset
			file.put_string ("function Tmw")
			file.put_string (a_class_name)
			file.put_string (".DoCreateEmptyRecordset: Recordset;%N")
			file.put_string ("begin%N")
			file.put_string ("  Result := CoRecordset.Create;%N")
			write_append_pk_field (file, type, sqlgenerator)
			from
				cursor := type.new_data_attributes_cursor (sqlgenerator)
				cursor.start
			until
				cursor.after
			loop
				write_append_field (file, cursor.item, sqlgenerator)
				cursor.forth
			end
			write_append_ts_field (file, type, sqlgenerator)
			file.put_string ("  Result.Open(EmptyParam, EmptyParam, adOpenStatic, adLockBatchOptimistic, Integer(adCmdUnspecified));%N")
			file.put_string ("end;%N%N%N")

			-- DoDelete
			file.put_string ("procedure Tmw")
			file.put_string (a_class_name)
			file.put_string (".DoDelete(rs: Recordset);%N")
			file.put_string ("begin%N")
			file.put_string ("  DoDeleteId(rs.Fields['")
			file.put_string (type.sqlpkname(sqlgenerator))
			file.put_string ("'].OriginalValue, ")
			if sqlgenerator.CreateTimestamp then
				file.put_string ("rs.Fields['")
				file.put_string (sqlgenerator.table_ts_name (type))
				file.put_string ("'].OriginalValue")
			else
				file.put_string ("Null")
			end
			file.put_string (");%N")
			file.put_string ("end;%N%N%N")

			-- DoDeleteId
			file.put_string ("procedure Tmw")
			file.put_string (a_class_name)
			file.put_string (".DoDeleteId(id: integer; const ts: OleVariant);%N")
			file.put_string ("var%N")
			file.put_string ("  Param: Parameter;%N")
			file.put_string ("begin%N")
			file.put_string ("  if not Assigned(spDelete) then%N")
			file.put_string ("  begin%N")
			file.put_string ("    spDelete:= CoCommand.Create;%N")
			file.put_string ("    spDelete.Set_CommandText('")
			file.put_string (sqlgenerator.quote_identifier(sqlgenerator.sp_delete_name (type)))
			file.put_string ("');%N")
			write_create_pk_parameter (file, "spDelete", type, sqlgenerator, False, "id")
			write_create_ts_parameter (file, "spDelete", type, sqlgenerator, "ts")
			file.put_string ("  end%N")
			file.put_string ("  else begin%N")
			write_set_pk_parameter (file, "spDelete", type, sqlgenerator, "id")
			write_set_ts_parameter (file, "spDelete", type, sqlgenerator, "ts")
			file.put_string ("  end;%N")
			file.put_string ("  ExecuteSP(spDelete);%N")
			file.put_string ("end;%N%N%N")

			-- DoInsert
			file.put_string ("function Tmw")
			file.put_string (a_class_name)
			file.put_string (".DoInsert(rs: Recordset): integer;%N")
			file.put_string ("var%N")
			file.put_string ("  Param: Parameter;%N")
			file.put_string ("begin%N")
			file.put_string ("  if not Assigned(spInsert) then%N")
			file.put_string ("  begin%N")
			file.put_string ("    spInsert := CoCommand.Create;%N")
			file.put_string ("    spInsert.Set_CommandText('")
			file.put_string (sqlgenerator.quote_identifier(sqlgenerator.sp_insert_name (type)))
			file.put_string ("');%N")

			from
				cursor := type.new_data_attributes_cursor (sqlgenerator)
				cursor.start
			until
				cursor.after
			loop
				write_create_parameter (file, "spInsert", cursor.item, sqlgenerator)
				cursor.forth
			end
			write_create_pk_parameter (file, "spInsert", type, sqlgenerator, type.has_auto_pk (sqlgenerator), Void)

			file.put_string ("  end%N")
			file.put_string ("  else begin%N")
			from
				cursor := type.new_data_attributes_cursor (sqlgenerator)
				cursor.start
			until
				cursor.after
			loop
				write_set_parameter (file, "spInsert", cursor.item, sqlgenerator)
				cursor.forth
			end
			if not type.has_auto_pk (sqlgenerator) then
				write_set_pk_parameter (file, "spInsert", type, sqlgenerator, Void)
			end

			file.put_string ("  end;%N")
			file.put_string ("  ExecuteSP(spInsert);%N")
			file.put_string ("  Result := spInsert.Parameters.Item['")
			file.put_string (sqlgenerator.sp_define_param_name (type.sqlpkname(sqlgenerator)))
			file.put_string ("'].Value;%N")
			file.put_string ("end;%N%N%N")

			-- DoUpdate
			file.put_string ("procedure Tmw")
			file.put_string (a_class_name)
			file.put_string (".DoUpdate(rs: Recordset);%N")
			file.put_string ("var%N")
			file.put_string ("  Param: Parameter;%N")
			file.put_string ("begin%N")
			file.put_string ("  if not Assigned(spUpdate) then%N")
			file.put_string ("  begin%N")
			file.put_string ("    spUpdate := CoCommand.Create;%N")
			file.put_string ("    spUpdate.Set_CommandText('")
			file.put_string (sqlgenerator.quote_identifier(sqlgenerator.sp_update_name (type)))
			file.put_string ("');%N")
			write_create_pk_parameter (file, "spUpdate", type, sqlgenerator, False, Void)
			from
				cursor := type.new_data_attributes_cursor (sqlgenerator)
				cursor.start
			until
				cursor.after
			loop
				write_create_parameter (file, "spUpdate", cursor.item, sqlgenerator)
				cursor.forth
			end
			write_create_ts_parameter (file, "spUpdate", type, sqlgenerator, Void)
			file.put_string ("  end%N")
			file.put_string ("  else begin%N")
			write_set_pk_parameter (file, "spUpdate", type, sqlgenerator, Void)
			from
				cursor := type.new_data_attributes_cursor (sqlgenerator)
				cursor.start
			until
				cursor.after
			loop
				write_set_parameter (file, "spUpdate", cursor.item, sqlgenerator)
				cursor.forth
			end
			write_set_ts_parameter (file, "spUpdate", type, sqlgenerator, Void)
			file.put_string ("  end;%N")
			file.put_string ("  ExecuteSP(spUpdate);%N")
			file.put_string ("end;%N%N%N")

			-- end of unit
			file.put_string ("end.%N")

			file.close
		end

	dump_statements (statements: XPLAIN_STATEMENTS; sqlgenerator: SQL_GENERATOR) is
		do
			-- not yet supported.
		end


feature {NONE} -- Helpers

	write_create_pk_parameter (file: KL_TEXT_OUTPUT_FILE
										sp_name: STRING
										type: XPLAIN_TYPE
										sqlgenerator: SQL_GENERATOR
										OutputParam: BOOLEAN
										value: STRING) is
		do
			file.put_string ("    Param := ")
			file.put_string (sp_name)
			file.put_string (".CreateParameter('")
			file.put_string (sqlgenerator.sp_define_param_name (type.sqlpkname(sqlgenerator)))
			file.put_string ("', ")
			file.put_string (type.representation.datatype (Current))
			file.put_string (", ")
			if OutputParam then
				file.put_string ("adParamOutput")
			else
				file.put_string ("adParamInput")
			end
			file.put_string (", ")
			file.put_string (datalen (type.representation).out)
			file.put_string (", ")
			if OutputParam then
				file.put_string ("Null")
			else
				if Value = Void then
					file.put_string ("rs.Fields['")
					file.put_string (type.sqlpkname(sqlgenerator))
					file.put_string ("'].Value")
				else
					file.put_string (Value)
				end
			end
			file.put_string (");%N")
			file.put_string ("    ")
			file.put_string (sp_name)
			file.put_string (".Parameters.Append(Param);%N")
		end

	write_set_pk_parameter (file: KL_TEXT_OUTPUT_FILE
									sp_name: STRING
									type: XPLAIN_TYPE
									sqlgenerator: SQL_GENERATOR
									Value: string) is
		do
			file.put_string ("    ")
			file.put_string (sp_name)
			file.put_string (".Parameters.Item['")
			file.put_string (sqlgenerator.sp_define_param_name (type.sqlpkname(sqlgenerator)))
			file.put_string ("'].Value := ")
			if Value = Void then
				file.put_string ("rs.Fields['")
				file.put_string (type.sqlpkname(sqlgenerator))
				file.put_string ("'].Value")
			else
				file.put_string (Value)
			end
			file.put_string (";%N")
		end

	write_create_ts_parameter (file: KL_TEXT_OUTPUT_FILE
										sp_name: STRING
										type: XPLAIN_TYPE
										sqlgenerator: SQL_GENERATOR
										Value: string) is
		do
			if sqlgenerator.CreateTimestamp then
				file.put_string ("    Param := ")
				file.put_string (sp_name)
				file.put_string (".CreateParameter('")
				file.put_string (sqlgenerator.sp_define_param_name (sqlgenerator.table_ts_name (type)))
				file.put_string ("', adBinary, adParamInput, 8, ")
				if Value = Void then
					file.put_string ("rs.Fields['")
					file.put_string (sqlgenerator.table_ts_name (type))
					file.put_string ("'].Value")
				else
					file.put_string (Value)
				end
				file.put_string (");%N")
				file.put_string ("    ")
				file.put_string (sp_name)
				file.put_string (".Parameters.Append(Param);%N")
			end
		end

	write_set_ts_parameter (file: KL_TEXT_OUTPUT_FILE
									sp_name: STRING
									type: XPLAIN_TYPE
									sqlgenerator: SQL_GENERATOR
									Value: string) is
		do
			if sqlgenerator.CreateTimestamp then
				file.put_string ("    ")
				file.put_string (sp_name)
				file.put_string (".Parameters.Item['")
				file.put_string (sqlgenerator.sp_define_param_name (sqlgenerator.table_ts_name (type)))
				file.put_string ("'].Value := ")
				if Value = Void then
					file.put_string ("rs.Fields['")
					file.put_string (sqlgenerator.table_ts_name (type))
					file.put_string ("'].Value")
				else
					file.put_string (Value)
				end
				file.put_string (";%N")
			end
		end

	write_create_parameter (file: KL_TEXT_OUTPUT_FILE
									sp_name: STRING
									attribute: XPLAIN_ATTRIBUTE
									sqlgenerator: SQL_GENERATOR) is
		local
			r: XPLAIN_REPRESENTATION
			column_name: string
		do
			column_name := attribute.abstracttype.sqlcolumnidentifier (sqlgenerator, attribute.role)
			r := attribute.abstracttype.representation
			file.put_string ("    Param := ")
			file.put_string (sp_name)
			file.put_string (".CreateParameter('")
			file.put_string (sqlgenerator.sp_define_param_name (column_name))
			file.put_string ("', ")
			file.put_string (attribute.abstracttype.columndatatype (Current))
			file.put_string (", adParamInput, ")
			file.put_string (datalen (r).out)
			file.put_string (", ")
			file.put_string (r.mw_column_value (Current, column_name))
			file.put_string (");%N")
			file.put_string ("    ")
			file.put_string (sp_name)
			file.put_string (".Parameters.Append(Param);%N")
			if r.mw_needs_precision then
				file.put_string ("    Param.Precision := ")
				file.put_integer (r.mw_precision)
				file.put_string (";%N")
				file.put_string ("    Param.NumericScale := ")
				file.put_integer (r.mw_numeric_scale)
				file.put_string (";%N")
			end
		end

	write_set_parameter (file: KL_TEXT_OUTPUT_FILE
								sp_name: STRING
								attribute: XPLAIN_ATTRIBUTE
								sqlgenerator: SQL_GENERATOR) is
		local
			column_name: string
		do
			column_name := attribute.abstracttype.sqlcolumnidentifier (sqlgenerator, attribute.role)
			file.put_string ("    ")
			file.put_string (sp_name)
			file.put_string (".Parameters.Item['")
			file.put_string (sqlgenerator.sp_define_param_name (column_name))
			file.put_string ("'].Value := ")
			file.put_string (attribute.abstracttype.representation.mw_column_value (Current, column_name))
			file.put_string (";%N")
		end

	write_append_pk_field (file: KL_TEXT_OUTPUT_FILE
								  type: XPLAIN_TYPE
								  sqlgenerator: SQL_GENERATOR) is
		do
			file.put_string ("  Result.Fields.Append('")
			file.put_string (type.sqlpkname(sqlgenerator))
			file.put_string ("', ")
			file.put_string (type.representation.datatype (Current))
			file.put_string (", ")
			file.put_string (datalen (type.representation).out)
			file.put_string (", adFldUpdatable + adFldIsNullable + adFldMayBeNull);%N")
		end

	write_append_field (file: KL_TEXT_OUTPUT_FILE
							  attribute: XPLAIN_ATTRIBUTE
							  sqlgenerator: SQL_GENERATOR) is
		local
			r: XPLAIN_REPRESENTATION
			column_name: string
		do
			column_name := attribute.abstracttype.sqlcolumnidentifier (sqlgenerator, attribute.role)
			r := attribute.abstracttype.representation
			file.put_string ("  Result.Fields.Append('")
			file.put_string (column_name)
			file.put_string ("', ")
			file.put_string (attribute.abstracttype.columndatatype (Current))
			file.put_string (", ")
			file.put_string (datalen (r).out)
			file.put_string (", adFldUpdatable + adFldIsNullable + adFldMayBeNull);%N")
			if r.mw_needs_precision then
				file.put_string ("  Result.Fields['")
				file.put_string (column_name)
				file.put_string ("'].Set_Precision(")
				file.put_integer (r.mw_precision)
				file.put_string (");%N")
				file.put_string ("  Result.Fields['")
				file.put_string (column_name)
				file.put_string ("'].Set_NumericScale(")
				file.put_integer (r.mw_numeric_scale)
				file.put_string (");%N")
			end
		end

	write_append_ts_field (file: KL_TEXT_OUTPUT_FILE
								  type: XPLAIN_TYPE
								  sqlgenerator: SQL_GENERATOR) is
		do
			if sqlgenerator.CreateTimestamp then
				file.put_string ("  Result.Fields.Append('")
				file.put_string (sqlgenerator.table_ts_name (type))
				file.put_string ("', ")
				file.put_string ("adBinary")
				file.put_string (", ")
				file.put_string ("8")
				file.put_string (", adFldUpdatable + adFldIsNullable + adFldMayBeNull);%N")
			end
		end

feature -- Booleans

	SQLTrue: STRING is
			-- Return the value for True.
		once
			Result := "True"
		end

	SQLFalse: STRING is
			-- Return the value for False.
		once
			Result := "False"
		end

feature -- Expression generation, not yet implemented for Delphi

	as_string (s: STRING): STRING is
			-- Return `s' as string by surrounding it with
			-- quotes. Special characters in string should be properly
			-- quoted.
		do
		end

	sqlgetconstant (variable: XPLAIN_VARIABLE): STRING is
		do
		end


feature -- Code generation, silence compiler basically, because we're never called here

	write_constant (constant: XPLAIN_VARIABLE) is
		do
		end

	write_constant_assignment (constant: XPLAIN_VARIABLE; expression: XPLAIN_EXPRESSION) is
		do
		end

	write_delete (subject: XPLAIN_SUBJECT; predicate: XPLAIN_EXPRESSION) is
		do
		end

	write_extend (extension: XPLAIN_EXTENSION) is
		do
		end

	write_insert (type: XPLAIN_TYPE; id: XPLAIN_EXPRESSION; assignment_list: XPLAIN_ASSIGNMENT_NODE) is
		do
		end

	write_procedure (procedure: XPLAIN_PROCEDURE) is
		do
		end

	write_select (selection: XPLAIN_SELECTION) is
		do
		end

	write_select_function (selection_list: XPLAIN_SELECTION_FUNCTION) is
		do
		end

	write_select_list (selection_list: XPLAIN_SELECTION_LIST) is
		do
		end

	write_select_value (value: XPLAIN_VALUE) is
		do
		end

	write_sql (sql: STRING) is
		do
		end

	write_type (type: XPLAIN_TYPE) is
		do
		end

	write_update (
			subject: XPLAIN_SUBJECT;
			assignment_list: XPLAIN_ASSIGNMENT_NODE;
			predicate: XPLAIN_EXPRESSION) is
		do
		end

	write_value (value: XPLAIN_VALUE) is
		do
		end

end
