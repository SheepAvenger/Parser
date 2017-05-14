{Program Sample
	{Function facto VAL
		{if {< VAL 0 }
		then {= retVal -1}
		else {= retVal 1}
		}
		{while {> VAL 0} do
			{= retVal {* retVal VAL}}
			{= VAL {- VAL 1}}
		}
	return retVal
	}
	{Function rtrn a b
  		{if {< a b}
   		then {= ret -0.001}
		else {= ret 0.001}
		}
   		{if {> a b}
   		then { = ret 0.001}
   		else {= ret 0}
  		}
	return ret
	}

	{Function getEle index lst
      		{if {!= index lst}
       		then {= result (pound f)}
		else {= result (pound t)}
      		}
      		{if {== index 1}
        	 then {= lst lst-1}
		 else {= lst lst}
		}
	return lst
	}
    {= myStrng (I like lex and yacc)}
    {print {facto 999}}
    {print {rtrn 7 5}}
    {print {getEle 2 {= list (abcd)}}}
}
