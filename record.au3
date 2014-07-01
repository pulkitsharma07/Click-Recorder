#cs
Local	$pos
Local 	$val="empty"
For $i=1 to 20
	$pos= MouseGetPos()

	$val=MsgBox(65,"Posotion","X="&$pos[0]&" Y="&$pos[1],1)
	If $val == 2 Then
		Exit
	EndIf
	Sleep(500)
Next
#ce
#include <Misc.au3>
#include <File.au3>
#include <GUIConstantsEx.au3>
$hDLL = DllOpen("user32.dll")
Example()
DllClose($hDLL)

Func Example()
    Local $Button_1, $Button_2, $msg
    GUICreate("Click Recorder",215,100) ; will create a dialog box that when displayed is centered

    Opt("GUICoordMode", 2)
    $Button_1 = GUICtrlCreateButton("Record Clicks", 10, 30,100)
    $Button_2 = GUICtrlCreateButton("Play Recording", 0, -1)

    GUISetState()
    ; Run the GUI until the dialog is closed
    While 1
        $msg = GUIGetMsg()
        Select
            Case $msg = $GUI_EVENT_CLOSE
                ExitLoop
            Case $msg = $Button_1
				record()
			Case $msg = $Button_2
                play()
        EndSelect
    WEnd
EndFunc   ;==>Example

Func record()

	MsgBox(64,"ALERT","Press ESC to end recording (this window will close automatically)",3)
	IniDelete("data.ini", "Coord")
	Local $count=0
	Local $tx=-13,$ty=-33
	IniWrite("data.ini","Done","done",0)
		While 1
			$pos= MouseGetPos()
			If _IsPressed("01",$hDLL) Then
				If $tx <> $pos[0] And $ty <> $pos[1] Then
					IniWrite("data.ini","Coord","x"&$count,$pos[0])
					IniWrite("data.ini","Coord","y"&$count,$pos[1])
					$count=$count+1
					$tx=$pos[0]
					$ty=$pos[1]
				EndIf
			ElseIf _IsPressed("1B", $hDLL) Then
				MsgBox(0, "_IsPressed", "The Esc Key was pressed, therefore we will close the application.")
				ExitLoop
			EndIf
		WEnd
		IniWrite("data.ini","Done","done",1)

EndFunc

Func play()
	Local $var2 = IniReadSection("data.ini","done")
	MsgBox(64,"WARNING","PLAYBACK PROCESS IS ABOUT TO START. You will be notified opon completion")
	If $var2[1][1] == 1 Then
		Local $data= IniReadSection("data.ini","Coord")
		Local $num=( $data[0][0]/2) - 1 ;
		for $i=0 to $num
			$x= IniRead("data.ini","Coord","x"&$i ,"0000")
			$y= IniRead("data.ini","Coord","y"&$i ,"0000")

			MouseClick("left",$x,$y,1,50)
			Sleep(1000)
		Next
	Else
		MsgBox(0,"Error","The recording process could not be completed")
	EndIf
	MsgBox(0,"DONE","PLAYBACK COMPLETED")
EndFunc

