{Program Samp1
	{Function setVal vals
		{= val vals}
		return val
	}
	{= myStrn (I like lex and yacc)}
	{print {setVal 99}}
}