indexing

	description: "Parser token codes"
	generator: "geyacc version 3.8"

class XPLAIN_TOKENS

inherit

	YY_PARSER_TOKENS

feature -- Last values

	last_any_value: ANY
	last_string_value: STRING
	last_integer_value: INTEGER

feature -- Access

	token_name (a_token: INTEGER): STRING is
			-- Name of token `a_token'
		do
			inspect a_token
			when 0 then
				Result := "EOF token"
			when -1 then
				Result := "Error token"
			when XPLAIN_AND then
				Result := "XPLAIN_AND"
			when XPLAIN_ANY then
				Result := "XPLAIN_ANY"
			when XPLAIN_AS then
				Result := "XPLAIN_AS"
			when XPLAIN_ASSERT then
				Result := "XPLAIN_ASSERT"
			when XPLAIN_BASE then
				Result := "XPLAIN_BASE"
			when XPLAIN_CASCADE then
				Result := "XPLAIN_CASCADE"
			when XPLAIN_CASE then
				Result := "XPLAIN_CASE"
			when XPLAIN_CHECK then
				Result := "XPLAIN_CHECK"
			when XPLAIN_CONSTANT then
				Result := "XPLAIN_CONSTANT"
			when XPLAIN_COUNT then
				Result := "XPLAIN_COUNT"
			when XPLAIN_DATABASE then
				Result := "XPLAIN_DATABASE"
			when XPLAIN_DEFAULT then
				Result := "XPLAIN_DEFAULT"
			when XPLAIN_DELETE then
				Result := "XPLAIN_DELETE"
			when XPLAIN_ECHO then
				Result := "XPLAIN_ECHO"
			when XPLAIN_ELSE then
				Result := "XPLAIN_ELSE"
			when XPLAIN_END then
				Result := "XPLAIN_END"
			when XPLAIN_EXTEND then
				Result := "XPLAIN_EXTEND"
			when XPLAIN_FALSE then
				Result := "XPLAIN_FALSE"
			when XPLAIN_GET then
				Result := "XPLAIN_GET"
			when XPLAIN_IF then
				Result := "XPLAIN_IF"
			when XPLAIN_INIT then
				Result := "XPLAIN_INIT"
			when XPLAIN_INPUT then
				Result := "XPLAIN_INPUT"
			when XPLAIN_INSERT then
				Result := "XPLAIN_INSERT"
			when XPLAIN_ITS then
				Result := "XPLAIN_ITS"
			when XPLAIN_LOGINNAME then
				Result := "XPLAIN_LOGINNAME"
			when XPLAIN_MAX then
				Result := "XPLAIN_MAX"
			when XPLAIN_MIN then
				Result := "XPLAIN_MIN"
			when XPLAIN_NEWLINE then
				Result := "XPLAIN_NEWLINE"
			when XPLAIN_NIL then
				Result := "XPLAIN_NIL"
			when XPLAIN_NOT then
				Result := "XPLAIN_NOT"
			when XPLAIN_NULL then
				Result := "XPLAIN_NULL"
			when XPLAIN_OF then
				Result := "XPLAIN_OF"
			when XPLAIN_OR then
				Result := "XPLAIN_OR"
			when XPLAIN_PER then
				Result := "XPLAIN_PER"
			when XPLAIN_PURGE then
				Result := "XPLAIN_PURGE"
			when XPLAIN_SOME then
				Result := "XPLAIN_SOME"
			when XPLAIN_SYSTEMDATE then
				Result := "XPLAIN_SYSTEMDATE"
			when XPLAIN_THEN then
				Result := "XPLAIN_THEN"
			when XPLAIN_TOTAL then
				Result := "XPLAIN_TOTAL"
			when XPLAIN_TRUE then
				Result := "XPLAIN_TRUE"
			when XPLAIN_TYPE then
				Result := "XPLAIN_TYPE"
			when XPLAIN_UPDATE then
				Result := "XPLAIN_UPDATE"
			when XPLAIN_VALUE then
				Result := "XPLAIN_VALUE"
			when XPLAIN_WITH then
				Result := "XPLAIN_WITH"
			when XPLAIN_WHERE then
				Result := "XPLAIN_WHERE"
			when XPLAIN_COMBINE then
				Result := "XPLAIN_COMBINE"
			when XPLAIN_HEAD then
				Result := "XPLAIN_HEAD"
			when XPLAIN_TAIL then
				Result := "XPLAIN_TAIL"
			when XPLAIN_DAYF then
				Result := "XPLAIN_DAYF"
			when XPLAIN_ISDATE then
				Result := "XPLAIN_ISDATE"
			when XPLAIN_MONTHF then
				Result := "XPLAIN_MONTHF"
			when XPLAIN_NEWDATE then
				Result := "XPLAIN_NEWDATE"
			when XPLAIN_TIMEDIF then
				Result := "XPLAIN_TIMEDIF"
			when XPLAIN_WDAYF then
				Result := "XPLAIN_WDAYF"
			when XPLAIN_YEARF then
				Result := "XPLAIN_YEARF"
			when XPLAIN_DATEF then
				Result := "XPLAIN_DATEF"
			when XPLAIN_INTEGERF then
				Result := "XPLAIN_INTEGERF"
			when XPLAIN_REALF then
				Result := "XPLAIN_REALF"
			when XPLAIN_STRINGF then
				Result := "XPLAIN_STRINGF"
			when XPLAIN_POW then
				Result := "XPLAIN_POW"
			when XPLAIN_ABS then
				Result := "XPLAIN_ABS"
			when XPLAIN_MAXF then
				Result := "XPLAIN_MAXF"
			when XPLAIN_MINF then
				Result := "XPLAIN_MINF"
			when XPLAIN_SQRT then
				Result := "XPLAIN_SQRT"
			when XPLAIN_EXP then
				Result := "XPLAIN_EXP"
			when XPLAIN_LN then
				Result := "XPLAIN_LN"
			when XPLAIN_LOG10 then
				Result := "XPLAIN_LOG10"
			when XPLAIN_SIN then
				Result := "XPLAIN_SIN"
			when XPLAIN_COS then
				Result := "XPLAIN_COS"
			when XPLAIN_TAN then
				Result := "XPLAIN_TAN"
			when XPLAIN_ASIN then
				Result := "XPLAIN_ASIN"
			when XPLAIN_ACOS then
				Result := "XPLAIN_ACOS"
			when XPLAIN_ATAN then
				Result := "XPLAIN_ATAN"
			when XPLAIN_SINH then
				Result := "XPLAIN_SINH"
			when XPLAIN_COSH then
				Result := "XPLAIN_COSH"
			when XPLAIN_TANH then
				Result := "XPLAIN_TANH"
			when XPLAIN_ASINH then
				Result := "XPLAIN_ASINH"
			when XPLAIN_ACOSH then
				Result := "XPLAIN_ACOSH"
			when XPLAIN_ATANH then
				Result := "XPLAIN_ATANH"
			when XPLAIN_CLUSTERED then
				Result := "XPLAIN_CLUSTERED"
			when XPLAIN_ENDPROC then
				Result := "XPLAIN_ENDPROC"
			when XPLAIN_INDEX then
				Result := "XPLAIN_INDEX"
			when XPLAIN_INSERTED then
				Result := "XPLAIN_INSERTED"
			when XPLAIN_OPTIONAL then
				Result := "XPLAIN_OPTIONAL"
			when XPLAIN_PROCEDURE then
				Result := "XPLAIN_PROCEDURE"
			when XPLAIN_PATH_PROCEDURE then
				Result := "XPLAIN_PATH_PROCEDURE"
			when XPLAIN_RECOMPILED_PROCEDURE then
				Result := "XPLAIN_RECOMPILED_PROCEDURE"
			when XPLAIN_TRIGGER_PROCEDURE then
				Result := "XPLAIN_TRIGGER_PROCEDURE"
			when XPLAIN_REQUIRED then
				Result := "XPLAIN_REQUIRED"
			when XPLAIN_UNIQUE then
				Result := "XPLAIN_UNIQUE"
			when XPLAIN_ID then
				Result := "XPLAIN_ID"
			when LITERAL_SQL then
				Result := "LITERAL_SQL"
			when XPLAIN_IDENTIFIER then
				Result := "XPLAIN_IDENTIFIER"
			when XPLAIN_STRING then
				Result := "XPLAIN_STRING"
			when XPLAIN_DOUBLE then
				Result := "XPLAIN_DOUBLE"
			when XPLAIN_INTEGER then
				Result := "XPLAIN_INTEGER"
			when XPLAIN_A then
				Result := "XPLAIN_A"
			when XPLAIN_B then
				Result := "XPLAIN_B"
			when XPLAIN_C then
				Result := "XPLAIN_C"
			when XPLAIN_D then
				Result := "XPLAIN_D"
			when XPLAIN_I then
				Result := "XPLAIN_I"
			when XPLAIN_M then
				Result := "XPLAIN_M"
			when XPLAIN_P then
				Result := "XPLAIN_P"
			when XPLAIN_R then
				Result := "XPLAIN_R"
			when XPLAIN_T then
				Result := "XPLAIN_T"
			when XPLAIN_NE then
				Result := "XPLAIN_NE"
			when XPLAIN_LE then
				Result := "XPLAIN_LE"
			when XPLAIN_GE then
				Result := "XPLAIN_GE"
			when XPLAIN_DOTDOT then
				Result := "XPLAIN_DOTDOT"
			else
				Result := yy_character_token_name (a_token)
			end
		end

feature -- Token codes

	XPLAIN_AND: INTEGER is 258
	XPLAIN_ANY: INTEGER is 259
	XPLAIN_AS: INTEGER is 260
	XPLAIN_ASSERT: INTEGER is 261
	XPLAIN_BASE: INTEGER is 262
	XPLAIN_CASCADE: INTEGER is 263
	XPLAIN_CASE: INTEGER is 264
	XPLAIN_CHECK: INTEGER is 265
	XPLAIN_CONSTANT: INTEGER is 266
	XPLAIN_COUNT: INTEGER is 267
	XPLAIN_DATABASE: INTEGER is 268
	XPLAIN_DEFAULT: INTEGER is 269
	XPLAIN_DELETE: INTEGER is 270
	XPLAIN_ECHO: INTEGER is 271
	XPLAIN_ELSE: INTEGER is 272
	XPLAIN_END: INTEGER is 273
	XPLAIN_EXTEND: INTEGER is 274
	XPLAIN_FALSE: INTEGER is 275
	XPLAIN_GET: INTEGER is 276
	XPLAIN_IF: INTEGER is 277
	XPLAIN_INIT: INTEGER is 278
	XPLAIN_INPUT: INTEGER is 279
	XPLAIN_INSERT: INTEGER is 280
	XPLAIN_ITS: INTEGER is 281
	XPLAIN_LOGINNAME: INTEGER is 282
	XPLAIN_MAX: INTEGER is 283
	XPLAIN_MIN: INTEGER is 284
	XPLAIN_NEWLINE: INTEGER is 285
	XPLAIN_NIL: INTEGER is 286
	XPLAIN_NOT: INTEGER is 287
	XPLAIN_NULL: INTEGER is 288
	XPLAIN_OF: INTEGER is 289
	XPLAIN_OR: INTEGER is 290
	XPLAIN_PER: INTEGER is 291
	XPLAIN_PURGE: INTEGER is 292
	XPLAIN_SOME: INTEGER is 293
	XPLAIN_SYSTEMDATE: INTEGER is 294
	XPLAIN_THEN: INTEGER is 295
	XPLAIN_TOTAL: INTEGER is 296
	XPLAIN_TRUE: INTEGER is 297
	XPLAIN_TYPE: INTEGER is 298
	XPLAIN_UPDATE: INTEGER is 299
	XPLAIN_VALUE: INTEGER is 300
	XPLAIN_WITH: INTEGER is 301
	XPLAIN_WHERE: INTEGER is 302
	XPLAIN_COMBINE: INTEGER is 303
	XPLAIN_HEAD: INTEGER is 304
	XPLAIN_TAIL: INTEGER is 305
	XPLAIN_DAYF: INTEGER is 306
	XPLAIN_ISDATE: INTEGER is 307
	XPLAIN_MONTHF: INTEGER is 308
	XPLAIN_NEWDATE: INTEGER is 309
	XPLAIN_TIMEDIF: INTEGER is 310
	XPLAIN_WDAYF: INTEGER is 311
	XPLAIN_YEARF: INTEGER is 312
	XPLAIN_DATEF: INTEGER is 313
	XPLAIN_INTEGERF: INTEGER is 314
	XPLAIN_REALF: INTEGER is 315
	XPLAIN_STRINGF: INTEGER is 316
	XPLAIN_POW: INTEGER is 317
	XPLAIN_ABS: INTEGER is 318
	XPLAIN_MAXF: INTEGER is 319
	XPLAIN_MINF: INTEGER is 320
	XPLAIN_SQRT: INTEGER is 321
	XPLAIN_EXP: INTEGER is 322
	XPLAIN_LN: INTEGER is 323
	XPLAIN_LOG10: INTEGER is 324
	XPLAIN_SIN: INTEGER is 325
	XPLAIN_COS: INTEGER is 326
	XPLAIN_TAN: INTEGER is 327
	XPLAIN_ASIN: INTEGER is 328
	XPLAIN_ACOS: INTEGER is 329
	XPLAIN_ATAN: INTEGER is 330
	XPLAIN_SINH: INTEGER is 331
	XPLAIN_COSH: INTEGER is 332
	XPLAIN_TANH: INTEGER is 333
	XPLAIN_ASINH: INTEGER is 334
	XPLAIN_ACOSH: INTEGER is 335
	XPLAIN_ATANH: INTEGER is 336
	XPLAIN_CLUSTERED: INTEGER is 337
	XPLAIN_ENDPROC: INTEGER is 338
	XPLAIN_INDEX: INTEGER is 339
	XPLAIN_INSERTED: INTEGER is 340
	XPLAIN_OPTIONAL: INTEGER is 341
	XPLAIN_PROCEDURE: INTEGER is 342
	XPLAIN_PATH_PROCEDURE: INTEGER is 343
	XPLAIN_RECOMPILED_PROCEDURE: INTEGER is 344
	XPLAIN_TRIGGER_PROCEDURE: INTEGER is 345
	XPLAIN_REQUIRED: INTEGER is 346
	XPLAIN_UNIQUE: INTEGER is 347
	XPLAIN_ID: INTEGER is 348
	LITERAL_SQL: INTEGER is 349
	XPLAIN_IDENTIFIER: INTEGER is 350
	XPLAIN_STRING: INTEGER is 351
	XPLAIN_DOUBLE: INTEGER is 352
	XPLAIN_INTEGER: INTEGER is 353
	XPLAIN_A: INTEGER is 354
	XPLAIN_B: INTEGER is 355
	XPLAIN_C: INTEGER is 356
	XPLAIN_D: INTEGER is 357
	XPLAIN_I: INTEGER is 358
	XPLAIN_M: INTEGER is 359
	XPLAIN_P: INTEGER is 360
	XPLAIN_R: INTEGER is 361
	XPLAIN_T: INTEGER is 362
	XPLAIN_NE: INTEGER is 363
	XPLAIN_LE: INTEGER is 364
	XPLAIN_GE: INTEGER is 365
	XPLAIN_DOTDOT: INTEGER is 366

end
