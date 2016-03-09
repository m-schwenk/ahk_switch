#singleinstance force
#Hotstring EndChars `n`t ; `n to parse whole line, `t to parse last char only

/*
IGNORE:
	NOP	-	use 'an' for that)
	!	-	continue
	#	-	break
	:	-	if present ignore preceding chars via inStr before parser loop
	J__	-	on jumps with other than JRO append rest of input verbatim then break
*/

unary = ! ; [NEG|SWP|SAV
binary =  ; [ADD|SUB|JRO
ternary = m	; [MOV
ports = alrudn*? ; [aCC|lEFT|rIGHT|uP|dOWN|nIL|*ANY|?LAST]

;~ t := parse("mud")
;~ msgbox, %t%
;~ ExitApp

tis100 := "TIS-100 ahk_class UnityWndClass ahk_exe tis100.exe"
groupadd tis100, TIS-100 ahk_class UnityWndClass ahk_exe tis100.exe

ifwinNotexist ahk_group tis100
	run steam://rungameid/370360
SetKeyDelay, 250, 250
return

#Esc::Reload

#ifwinactive ahk_group tis100

xbutton1::esc
xbutton2::F5

wheelup::
wheeldown::
BlockInput, On
Send, {F6} ; Down}{F6 Up}
BlockInput, Off
return


#ifwinactive 

parse(term)
{
	offset = 0
	ret := ""
	appendMore := 0
	
	loop, Parse, term
	{
		gosub, % switch(A_LoopField)
		if appendMore--
			continue
		ret .= infix ; append possible additional syntax generated by previous loop iteration
		infix := ""
		continue
		
		; instructions
		m:
		ret .= "mov "
		infix .= ", "
		appendMore++
		return
		
		
		; ports
		u:
		ret .= "up"
		return

		d:
		ret .= "down"
		return

		l:
		ret .= "left"
		return

		r:
		ret .= "right"
		return

		c:
		ret .= "acc"
		return

		n:
		ret .= "nil"
		return

		a:
		ret .= "any"
		return
		
		default:
		MsgBox, , %term%, Input mismatch at %ret%:`n[%A_LoopField%] is not recognized in this context
		ret := ""
		break
	}
	return ret
}
