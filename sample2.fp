{Program Samp2
	{Function getEle index lst
      		{if {!= index lst}
       		then {= result (pound f)}
		else {= result (pound t)}
      		}
	return lst
	}
    {print {getEle 2 (abc)}}
}