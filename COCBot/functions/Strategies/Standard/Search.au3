;Searches for a village that until meets conditions

Func Standard_Search()
	Local $skippedVillages
	Local $conditionlogstr
	Local $AttackMethod
	Local $DG, $DE, $DD, $DT, $G, $E, $D, $T

	_WinAPI_EmptyWorkingSet(WinGetProcess($Title)) ; Reduce BlueStacks Memory Usage

	$MinDeadGold = GUICtrlRead($txtDeadMinGold)
	$MinDeadElixir = GUICtrlRead($txtDeadMinElixir)
	$MinDeadDark = GUICtrlRead($txtDeadMinDarkElixir)
	$MinDeadTrophy = GUICtrlRead($txtDeadMinTrophy)
	$MaxDeadTH = _GUICtrlComboBox_GetCurSel($cmbDeadTH)
	$MinGold = GUICtrlRead($txtMinGold)
	$MinElixir = GUICtrlRead($txtMinElixir)
	$MinDark = GUICtrlRead($txtMinDarkElixir)
	$MinTrophy = GUICtrlRead($txtMinTrophy)
	$MaxTH = _GUICtrlComboBox_GetCurSel($cmbTH)
	$iNukeLimit = GUICtrlRead($txtDENukeLimit)

	While 1
		SetLog("Search Condition:", $COLOR_RED)
		If IsChecked($chkDeadActivate) And $fullArmy Then
			$conditionlogstr = "Dead Base ("
			If IsChecked($chkDeadGE) Then
				If _GUICtrlComboBox_GetCurSel($cmbDead) = 0 Then
					$conditionlogstr = $conditionlogstr & " Gold: " & $MinDeadGold & " And " & "Elixir: " & $MinDeadElixir
				Else
					$conditionlogstr = $conditionlogstr & " Gold: " & $MinDeadGold & " Or " & "Elixir: " & $MinDeadElixir
				EndIf
			EndIf
			If IsChecked($chkDeadMeetDE) Then
				If $conditionlogstr <> "Dead Base (" Then
					$conditionlogstr = $conditionlogstr & ";"
				EndIf
				$conditionlogstr = $conditionlogstr & " Dark: " & $MinDeadDark
			EndIf
			If IsChecked($chkDeadMeetTrophy) Then
				If $conditionlogstr <> "Dead Base (" Then
					$conditionlogstr = $conditionlogstr & ";"
				EndIf
				$conditionlogstr = $conditionlogstr & " Trophy: " & $MinDeadTrophy
			EndIf
			If IsChecked($chkDeadMeetTH) Then
				If $conditionlogstr <> "Dead Base (" Then
					$conditionlogstr = $conditionlogstr & ";"
				EndIf
				$conditionlogstr = $conditionlogstr & " Max Townhall: " & $MaxDeadTH
			EndIf
			If IsChecked($chkDeadMeetTHO) Then
				If $conditionlogstr <> "Dead Base (" Then
					$conditionlogstr = $conditionlogstr & ";"
				EndIf
				$conditionlogstr = $conditionlogstr & " Townhall Outside"
			EndIf
			$conditionlogstr = $conditionlogstr & " )"
			SetLog($conditionlogstr, $COLOR_GREEN)
		EndIf
		If IsChecked($chkAnyActivate) And $fullArmy Then
			$conditionlogstr = "Live Base ("
			If IsChecked($chkMeetGE) Then
				If _GUICtrlComboBox_GetCurSel($cmbAny) = 0 Then
					$conditionlogstr = $conditionlogstr & " Gold: " & $MinGold & " And " & "Elixir: " & $MinElixir
				Else
					$conditionlogstr = $conditionlogstr & " Gold: " & $MinGold & " Or " & "Elixir: " & $MinElixir
				EndIf
			EndIf
			If IsChecked($chkMeetDE) Then
				If $conditionlogstr <> "Live Base (" Then
					$conditionlogstr = $conditionlogstr & ";"
				EndIf
				$conditionlogstr = $conditionlogstr & " Dark: " & $MinDark
			EndIf
			If IsChecked($chkMeetTrophy) Then
				If $conditionlogstr <> "Live Base (" Then
					$conditionlogstr = $conditionlogstr & ";"
				EndIf
				$conditionlogstr = $conditionlogstr & " Trophy: " & $MinTrophy
			EndIf
			If IsChecked($chkMeetTH) Then
				If $conditionlogstr <> "Live Base (" Then
					$conditionlogstr = $conditionlogstr & ";"
				EndIf
				$conditionlogstr = $conditionlogstr & " Max Townhall: " & $MaxTH
			EndIf
			If IsChecked($chkMeetTHO) Then
				If $conditionlogstr <> "Live Base (" Then
					$conditionlogstr = $conditionlogstr & ";"
				EndIf
				$conditionlogstr = $conditionlogstr & " Townhall Outside"
			EndIf
			$conditionlogstr = $conditionlogstr & " )"
			SetLog($conditionlogstr, $COLOR_GREEN)
		EndIf
		If IsChecked($chkNukeOnly) And $fullSpellFactory And $iNukeLimit > 0 Then
			$conditionlogstr = "Zap Base ( Dark: " & $iNukeLimit & " )"
			SetLog($conditionlogstr, $COLOR_GREEN)
		EndIf
		GUICtrlSetData($lblresultsearchcost, GUICtrlRead($lblresultsearchcost) + $SearchCost)
		If $TakeAllTownSnapShot = 1 Then SetLog("Will save all of the towns when searching", $COLOR_GREEN)
		$SearchCount = 0
		_BlockInputEx(3, "", "", $HWnD)
		While 1
			If Not _WaitForColor(30, 505, Hex(0xE80008, 6), 50, 10) Then Return -1
			If _Sleep($speedBump) Then Return -1
			GUICtrlSetState($btnAtkNow, $GUI_ENABLE)

			If IsChecked($chkTakeTownSS) Then
				Local $Date = @MDAY & "." & @MON & "." & @YEAR
				Local $Time = @HOUR & "." & @MIN & "." & @SEC
				_CaptureRegion()
				_GDIPlus_ImageSaveToFile($hBitmap, @ScriptDir & "\AllTowns\" & $Date & " at " & $Time & ".png")
			EndIf

			If _Sleep($icmbSearchsp * 1500) Then Return -1

			If $SearchCount <> 0 And Mod($SearchCount, 30) = 0 Then
				If $MinDeadGold - 5000 >= 0 Then $MinDeadGold -= 5000
				If $MinDeadElixir - 5000 >= 0 Then $MinDeadElixir -= 5000
				If $MinDeadDark - 100 >= 0 Then $MinDeadDark -= 100
				If $MinDeadTrophy - 2 >= 0 Then $MinDeadTrophy -= 2
				If $MinGold - 5000 >= 0 Then $MinGold -= 5000
				If $MinElixir - 5000 >= 0 Then $MinElixir -= 5000
				If $MinDark - 100 >= 0 Then $MinDark -= 100
				If $MinTrophy - 2 >= 0 Then $MinTrophy -= 2
				If $iNukeLimit - 300 >= 0 Then $iNukeLimit -= 100
				SetLog("Search Condition:", $COLOR_RED)
				If IsChecked($chkDeadActivate) And $fullArmy Then
					$conditionlogstr = "Dead Base ("
					If IsChecked($chkDeadGE) Then
						If _GUICtrlComboBox_GetCurSel($cmbDead) = 0 Then
							$conditionlogstr = $conditionlogstr & " Gold: " & $MinDeadGold & " And " & "Elixir: " & $MinDeadElixir
						Else
							$conditionlogstr = $conditionlogstr & " Gold: " & $MinDeadGold & " Or " & "Elixir: " & $MinDeadElixir
						EndIf
					EndIf
					If IsChecked($chkDeadMeetDE) Then
						If $conditionlogstr <> "Dead Base (" Then
							$conditionlogstr = $conditionlogstr & ";"
						EndIf
						$conditionlogstr = $conditionlogstr & " Dark: " & $MinDeadDark
					EndIf
					If IsChecked($chkDeadMeetTrophy) Then
						If $conditionlogstr <> "Dead Base (" Then
							$conditionlogstr = $conditionlogstr & ";"
						EndIf
						$conditionlogstr = $conditionlogstr & " Trophy: " & $MinDeadTrophy
					EndIf
					If IsChecked($chkDeadMeetTH) Then
						If $conditionlogstr <> "Dead Base (" Then
							$conditionlogstr = $conditionlogstr & ";"
						EndIf
						$conditionlogstr = $conditionlogstr & " Max Townhall: " & $MaxDeadTH
					EndIf
					If IsChecked($chkDeadMeetTHO) Then
						If $conditionlogstr <> "Dead Base (" Then
							$conditionlogstr = $conditionlogstr & ";"
						EndIf
						$conditionlogstr = $conditionlogstr & " Townhall Outside"
					EndIf
					$conditionlogstr = $conditionlogstr & " )"
					SetLog($conditionlogstr, $COLOR_GREEN)
				EndIf
				If IsChecked($chkAnyActivate) And $fullArmy Then
					$conditionlogstr = "Live Base ("
					If IsChecked($chkMeetGE) Then
						If _GUICtrlComboBox_GetCurSel($cmbDead) = 0 Then
							$conditionlogstr = $conditionlogstr & " Gold: " & $MinGold & " And " & "Elixir: " & $MinElixir
						Else
							$conditionlogstr = $conditionlogstr & " Gold: " & $MinGold & " Or " & "Elixir: " & $MinElixir
						EndIf
					EndIf
					If IsChecked($chkMeetDE) Then
						If $conditionlogstr <> "Live Base (" Then
							$conditionlogstr = $conditionlogstr & ";"
						EndIf
						$conditionlogstr = $conditionlogstr & " Dark: " & $MinDark
					EndIf
					If IsChecked($chkMeetTrophy) Then
						If $conditionlogstr <> "Live Base (" Then
							$conditionlogstr = $conditionlogstr & ";"
						EndIf
						$conditionlogstr = $conditionlogstr & " Trophy: " & $MinTrophy
					EndIf
					If IsChecked($chkMeetTH) Then
						If $conditionlogstr <> "Live Base (" Then
							$conditionlogstr = $conditionlogstr & ";"
						EndIf
						$conditionlogstr = $conditionlogstr & " Max Townhall: " & $MaxTH
					EndIf
					If IsChecked($chkMeetTHO) Then
						If $conditionlogstr <> "Live Base (" Then
							$conditionlogstr = $conditionlogstr & ";"
						EndIf
						$conditionlogstr = $conditionlogstr & " Townhall Outside"
					EndIf
					$conditionlogstr = $conditionlogstr & " )"
					SetLog($conditionlogstr, $COLOR_GREEN)
				EndIf
				If IsChecked($chkNukeOnly) And $fullSpellFactory And $iNukeLimit > 0 Then
					$conditionlogstr = "Zap Base ( Dark: " & $iNukeLimit & " )"
					SetLog($conditionlogstr, $COLOR_GREEN)
				EndIf
			EndIf

			$GoodBase = False
			Local $conditionlogstr
			$NukeAttack = False

			$BaseData = GetResources()

			If Not IsArray($BaseData) Then Return -1

			$DG = (Number($BaseData[2]) >= Number($MinDeadGold))
			$DE = (Number($BaseData[3]) >= Number($MinDeadElixir))
			$DD = (Number($BaseData[4]) >= Number($MinDeadDark))
			$DT = (Number($BaseData[5]) >= Number($MinDeadTrophy))
			$G = (Number($BaseData[2]) >= Number($MinGold))
			$E = (Number($BaseData[3]) >= Number($MinElixir))
			$D = (Number($BaseData[4]) >= Number($MinDark))
			$T = (Number($BaseData[5]) >= Number($MinTrophy))

			$THL = -1
			$THLO = -1

			For $i = 0 To 4
				If $BaseData[1] = $THText[$i] Then $THL = $i
			Next

			Switch $THLoc
				Case "In"
					$THLO = 0
				Case "Out"
					$THLO = 1
			EndSwitch

			If $THLoc = "Out" And IsChecked($chkDeadActivate) And IsChecked($chkDeadSnipe) And $BaseData[0] Then
				SetLog("~~~~~~~Outside Townhall in Dead Base Found!~~~~~~~", $COLOR_PURPLE)
				Return 0
			ElseIf $THLoc = "Out" And IsChecked($chkAnyActivate) And IsChecked($chkSnipe) And Not $BaseData[0] Then
				SetLog("~~~~~~~Outside Townhall in Live Base Found!~~~~~~~", $COLOR_PURPLE)
				Return 1
			EndIf

			; Variables to check whether to attack dead bases
			Local $conditionDeadPass = True

			If IsChecked($chkDeadActivate) And $fullArmy Then
				If IsChecked($chkDeadGE) Then
					$deadEnabled = True
					If _GUICtrlComboBox_GetCurSel($cmbDead) = 0 Then ; And
						If $DG = False Or $DE = False Then $conditionDeadPass = False
					Else ; Or
						If $DG = False And $DE = False Then $conditionDeadPass = False
					EndIf
				EndIf

				If IsChecked($chkDeadMeetDE) Then
					If $DD = False Then $conditionDeadPass = False
				EndIf

				If IsChecked($chkDeadMeetTrophy) Then
					If $DT = False Then $conditionDeadPass = False
				EndIf

				If IsChecked($chkDeadMeetTH) Then
					If $THL = -1 Or $THL > _GUICtrlComboBox_GetCurSel($cmbDeadTH) Then $conditionDeadPass = False
				EndIf

				If IsChecked($chkDeadMeetTHO) Then
					If $THLO <> 1 Then $conditionDeadPass = False
				EndIf

				If $BaseData[0] And $conditionDeadPass Then
					SetLog("~~~~~~~Dead Base Found!~~~~~~~", $COLOR_GREEN)
					$GoodBase = True
					$AttackMethod = 0
				EndIf
			EndIf

			If Not $GoodBase Then
				; Variables to check whether to attack non-dead bases
				Local $conditionAnyPass = True

				If IsChecked($chkAnyActivate) And $fullArmy Then
					If IsChecked($chkMeetGE) Then
						$anyEnabled = True
						If _GUICtrlComboBox_GetCurSel($cmbAny) = 0 Then ; And
							If $G = False Or $E = False Then $conditionAnyPass = False
						Else ; Or
							If $G = False And $E = False Then $conditionAnyPass = False
						EndIf
					EndIf

					If IsChecked($chkMeetDE) Then
						If $D = False Then $conditionAnyPass = False
					EndIf

					If IsChecked($chkMeetTrophy) Then
						If $T = False Then $conditionAnyPass = False
					EndIf

					If IsChecked($chkMeetTH) Then
						If $THL = -1 Or $THL > _GUICtrlComboBox_GetCurSel($cmbTH) Then $conditionAnyPass = False
					EndIf

					If IsChecked($chkMeetTHO) Then
						If $THLO <> 1 Then $conditionAnyPass = False
					EndIf

					If $conditionAnyPass Then
						SetLog("~~~~~~~Other Base Found!~~~~~~~", $COLOR_GREEN)
						$GoodBase = True
						$AttackMethod = 1
					EndIf
				EndIf
			EndIf

			If Not $GoodBase Then
				; Variables to check whether to zap Dark elixir
				If IsChecked($chkNukeOnly) And $fullSpellFactory And $iNukeLimit > 0 Then
					If Number($BaseData[4]) >= Number($iNukeLimit) Then
						If checkDarkElix() Then
							$NukeAttack = True
							SetLog("~~~~~~~Base to Zap Found!~~~~~~~", $COLOR_GREEN)
							$GoodBase = True
							$AttackMethod = 2
						EndIf
					EndIf
				EndIf
			EndIf

			; Attack instantly if Attack Now button pressed
			GUICtrlSetState($btnAtkNow, $GUI_DISABLE)
			If $AttackNow Then
				$AttackNow = False
				SetLog("~~~~~~~Attack Now Clicked!~~~~~~~", $COLOR_GREEN)
				ExitLoop
			EndIf

			If $GoodBase Then
				ExitLoop
			Else
				_CaptureRegion()
				If _ColorCheck(_GetPixelColor(703, 520), Hex(0xD84400, 6), 20) Then
					_Sleep($speedBump)
					Click(750, 500) ;Click Next
					GUICtrlSetData($lblresultvillagesskipped, GUICtrlRead($lblresultvillagesskipped) + 1)
					GUICtrlSetData($lblresultsearchcost, GUICtrlRead($lblresultsearchcost) + $SearchCost)
					If _Sleep(500) Then Return -1
				ElseIf _ColorCheck(_GetPixelColor(71, 530), Hex(0xC00000, 6), 20) Then
					SetLog("Cannot locate Next button, try to return home...", $COLOR_RED)
					Local $dummyX = 0
					Local $dummyY = 0
					If _ImageSearch(@ScriptDir & "\images\Client.bmp", 1, $dummyX, $dummyY, 50) = 1 Then
						If $dummyX > 290 And $dummyX < 310 And $dummyY > 325 And $dummyY < 340 Then
							$speedBump += 500
							If $speedBump > 5000 Then
								$speedBump = 5000
								SetLog("Out of sync! Already searching slowly, not changing anything.", $COLOR_RED)
							Else
								SetLog("Out of sync! Slowing search speed by 0.5 secs.", $COLOR_RED)
							EndIf
						EndIf
					EndIf
					If $DebugMode = 1 Then _GDIPlus_ImageSaveToFile($hBitmap, $dirDebug & "NoNext-" & @HOUR & @MIN & @SEC & ".png")
					If $PushBulletEnabled = 1 Then
						_Push("Disconnected", "Your bot got disconnected while searching for enemy..")
					EndIf
					Return -1
				Else
					SetLog("Cannot locate Next button & Surrender button, Restarting Bot", $COLOR_RED)
					Local $dummyX = 0
					Local $dummyY = 0
					If _ImageSearch(@ScriptDir & "\images\Client.bmp", 1, $dummyX, $dummyY, 50) = 1 Then
						If $dummyX > 290 And $dummyX < 310 And $dummyY > 325 And $dummyY < 340 Then
							$speedBump += 500
							If $speedBump > 5000 Then
								$speedBump = 5000
								SetLog("Out of sync! Already searching slowly, not changing anything.", $COLOR_RED)
							Else
								SetLog("Out of sync! Slowing search speed by 0.5 secs.", $COLOR_RED)
							EndIf
						EndIf
					EndIf
					If $DebugMode = 1 Then _GDIPlus_ImageSaveToFile($hBitmap, $dirDebug & "NoNextSurr-" & @HOUR & @MIN & @SEC & ".png")
					If $PushBulletEnabled = 1 Then
						_Push("Disconnected", "Your bot got disconnected while searching for enemy..")
					EndIf
					Return -1
				EndIf
			EndIf
		WEnd
		GUICtrlSetData($lblresultvillagesattacked, GUICtrlRead($lblresultvillagesattacked) + 1)
		GUICtrlSetData($lblresultsearchcost, GUICtrlRead($lblresultsearchcost) + $SearchCost)
		If IsChecked($chkAlertSearch) Then
			TrayTip("Match Found!", "Gold: " & $BaseData[2] & "; Elixir: " & $BaseData[3] & "; Dark: " & $BaseData[4] & "; Trophy: " & $BaseData[5] & "; Townhall: " & $BaseData[1] & ", " & $THLoc, 0)
			If FileExists(@WindowsDir & "\media\Windows Exclamation.wav") Then
				SoundPlay(@WindowsDir & "\media\Windows Exclamation.wav", 1)
			Else
				SoundPlay(@WindowsDir & "\media\Festival\Windows Exclamation.wav", 1)
			EndIf
		EndIf
		If $PushBulletEnabled = 1 And $PushBulletmatchfound = 1 Then
			_Push("Match Found!", "[G]: " & _NumberFormat($BaseData[2]) & "; [E]: " & _NumberFormat($BaseData[3]) & "; [D]: " & _NumberFormat($BaseData[4]) & "; [T]: " & $BaseData[5] & "; [TH Lvl]: " & $BaseData[1] & ", Loc: " & $THLoc)
			SetLog("Push: Match Found", $COLOR_GREEN)
		EndIf
		SetLog("===============Searching Complete===============", $COLOR_BLUE)
		_BlockInputEx(0, "", "", $HWnD)
		Return $AttackMethod
	WEnd
EndFunc   ;==>Standard_Search

