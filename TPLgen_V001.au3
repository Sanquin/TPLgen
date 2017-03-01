; ***********************************************************************************************************************
; TPLgen, V001 January 2017, Dion Methorst
;
; Generates a Tecan Evoware TPL file from scan.csv file in any pre-defined 96 position matrix as defined in TPLgen.ini file
; Run TPLgen.exe for a first time to create an initial TPLgen.ini file then edit the TPLgen.ini file
;
; ************************************************************************************************************************
; TPLgen.ini file example below:
; ************************************************************************************************************************
; TPLgen.exe, Sanquin Amsterdam, Dion Methorst Jan 2017
; TPLgen.exe requires proper data entry in the fields below:
; Please make sure your entries are correct!
;
;[Orientation]
; Change as desired but please notice:TPLgen.ini is rebuild to default after deletion
; Orientation of sample distribution is specified as TB (TopToBottomLeftToRight) or LR (LeftToRightTopToBottom)
;Orientation=TB
;
;[Samples]
; Enter, add or change each sample dilution
; Left side is number of replicates, right side Evoware dilution range designator
;1=V1
;1=V2
;
;[Sampledata]
; Specify the maximum amount of sample carriers that can be used
; Also specify the maximum number of samples per MTP/assay
; If MtpMaxSample = -1 the maximum No of samples will be calculated from the other TPLgen.ini data
;MaxCarrier=4
;MtpMaxSample=-1
;
;[Standards]
; Add or delete standards as desired, designation on the left & dilution factor on the right
; Keep in mind these are not used for calculations, only as designations in the TPL-file
;ST1=10
;ST2=20
;ST3=80
;ST4=120
;ST5=180
;ST6=220
;
;[StdData]
; Startposition of StandardRange
; Number of replicates of the standard
; Replicates will be designated to the adjeacent position, with a safe maximum of 2,
; i.e. right or below depending on the chosen orientation H or V , Horizontal or Vertical
;Startposition=A6
;Replicates=1
;Orientation=V
;
;[Controls]
; Change as desired, designation on the left & dilution factor on the right
; Keep in mind these are not used for calculations, only as designations in the TPL-file
;CT1=10
;CT2=20
;
;[ControlData]
; Change as desired, designation on the left & data on the right
; -replicates maximum of two,
;Replicates=1
;Orientation=V
;CT1pos=C5
;CT2pos=D7
;
;[Blanks]
;BL1=1
;BL2=1
;
;[BlankData]
;Replicates=1
;Orientation=V
;BL1=G6
;BL2=H6
;
;[Assays]
; Change as desired. Designation for assay at the left, LIMS ID on the right side.
;ADL=18
;
;[FilePaths]
; Default folder for TPL files is C:\apps\EVO\TPL\
; Default folder for Scan.csv files is scan.CSV=C:\ProgramData\Tecan\EVOware\output\
; Change as desired, left side file or file extension, right side is folder path
;TPL=C:\APPS\EVO\TPL\
;scan.CSV=H:\Programmeren\Sanquin werk\ROBOTS\CSV_TPL\TPLgen 2017\scan\
;
; ***********************************************************************************************************************
#include <iniComment.au3>
#include <Array.au3>
#include <file.au3>
#include <Date.au3>
#include <String.au3>
#include <Math.au3>
#include <Constants.au3>
#include <MsgBoxConstants.au3>
;********************************************************************************************************************************************************************************************************
; check if TPLgen.ini file exists, create TPLgen.ini file
; TPLgen.ini contains assay data to create EVOware TPL-file.

Dim $TPLgenIni = @Scriptdir & "\TPLgen.ini"

If not FileExists($TPLgenIni) then
	Local $Orient	="Orientation=TB" & @CRLF
	Local $Samples	="1=V1" & @LF & "1=V2" & @CRLF
	Local $SampleData="MaxCarrier=4" & @LF & "MtpMaxSample=-1" & @CRLF
	Local $Cereal	="ST1=10" & @LF & "ST2=20" & @LF & "ST3=80" & @LF & "ST4=120" & @LF & "ST5=180" _
						& @LF & "ST6=220" & @LF & "ST7=250" & @CRLF
	Local $STData	="Startposition=[A-H][1-12]" & @LF & "Replicates=1" & @LF & "Orientation=V" & @CRLF
	Local $Trols	="CT1=10" & @LF & "CT2=20" & @CRLF
	Local $TrolData	="Replicates=1" & @LF & "Orientation=V" & @LF & "CT1pos=[A-H][1-12]" & @LF & "CT2pos=[A-H][1-12]" & @CRLF
	Local $Blank	="BL1=1" & @LF & "BL2=1" & @CRLF
	Local $BlankData="Replicates=1" & @LF & "Orientation=V" & @LF & "BL1=[A-H][1-12]" & @LF & "BL2=[A-H][1-12]" & @CRLF
	Local $Assay	="ADL=18" & @CRLF
	Local $Folder	="TPL=C:\APPS\EVO\TPL\" & @LF & "scan.CSV=C:\ProgramData\Tecan\EVOware\output\" & @CRLF ;C:\Users\Dion\Laboratorium\programWerk\ROBOTS\CSV_TPL\TPLgen 2017\scan\  of H:\Programmeren\Sanquin werk\ROBOTS\CSV_TPL\TPLgen 2017\scan\

	IniWriteSection($TPLgenIni, "Orientation", $Orient)
	IniWriteSection($TPLgenIni, "Samples", $Samples)
	IniWriteSection($TPLgenIni, "Sampledata", $SampleData)
	IniWriteSection($TPLgenIni, "Standards", $Cereal)
	IniWriteSection($TPLgenIni, "StdData", $STData)
	IniWriteSection($TPLgenIni, "Controls", $Trols)
	IniWriteSection($TPLgenIni, "ControlData", $TrolData)
	IniWriteSection($TPLgenIni, "Blanks", $Blank)
	IniWriteSection($TPLgenIni, "BlankData", $BlankData)
	IniWriteSection($TPLgenIni, "Assays", $Assay)
	IniWriteSection($TPLgenIni, "FilePaths", $Folder)

	$iniComments = _IniWriteSectionComment($TPLgenIni, "Orientation", "TPLgen.exe, Sanquin Amsterdam, Dion Methorst Jan 2017|TPLgen.exe requires proper data entry in the fields below:|Please make sure your entries are correct!|",1)
	$iniComments = _IniWriteSectionComment($TPLgenIni, "Orientation", "Orientation of sample distribution is specified as TB (TopToBottomLeftToRight) or LR (LeftToRightTopToBottom)", 0)
	$iniComments = _IniWriteSectionComment($TPLgenIni, "Orientation", "Change as desired but please notice:TPLgen.ini is rebuild to default after deletion",0)
	$iniComments = _IniWriteSectionComment($TPLgenIni, "Samples", "Enter, add or change each sample dilution|Left side is number of replicates, right side Evoware dilution range designator", 0)
	$iniComments = _IniWriteSectionComment($TPLgenIni, "SampleData", "If MtpMaxSample = -1 the maximum No of samples will be calculated from the other TPLgen.ini data", 0)
	$iniComments = _IniWriteSectionComment($TPLgenIni, "SampleData", "Specify the maximum amount of sample carriers that can be used|Also specify the maximum number of samples per MTP/assay",0)
	$IniComments = _IniWriteSectionComment($TPLgenIni, "Standards", "Add or delete standards as desired, designation on the left & dilution factor on the right|Keep in mind these are not used for calculations, only as designations in the TPL-file", 0)
	$IniComments = _IniWriteSectionComment($TPLgenIni, "StdData", "i.e. right or below depending on the chosen orientation H or V , Horizontal or Vertical", 0)
	$IniComments = _IniWriteSectionComment($TPLgenIni, "StdData", "Startposition of StandardRange|Number of replicates of the standard|Replicates will be designated to the adjeacent position, with a safe maximum of 2,",0)
	$IniComments = _IniWriteSectionComment($TPLgenIni, "Controls", "Change as desired, designation on the left & dilution factor on the right|Keep in mind these are not used for calculations, only as designations in the TPL-file", 0)
	$IniComments = _IniWriteSectionComment($TPLgenIni, "ControlData","Change as desired, designation on the left & data on the right|-replicates maximum of two, ", 0)
	$IniComments = _IniWriteSectionComment($TPLgenIni, "Assays", "Change as desired. Designation for assay at the left, LIMS ID on the right side.", 0)
	$IniComments = _IniWriteSectionComment($TPLgenIni, "FilePaths", "Change as desired, left side file or file extension, right side is folder path", 0)
	$IniComments = _IniWriteSectionComment($TPLgenIni, "FilePaths", "Default folder for TPL files is C:\apps\EVO\TPL\|Default folder for Scan.csv files is scan.CSV=C:\ProgramData\Tecan\EVOware\output\", 0)

Endif

$aOrientation	= IniReadSection($TPLgenIni, "Orientation")
$aSamples		= IniReadSection($TPLgenIni, "Samples")
$aSampleData	= IniReadSection($TPLgenIni, "SampleData")
$aStandards		= IniReadSection($TPLgenIni, "Standards")
$aStdData 		= IniReadSection($TPLgenIni, "StdData")
$aControls		= IniReadSection($TPLgenIni, "Controls")
$aControlData 	= IniReadSection($TPLgenIni, "ControlData")
$aBlank			= IniReadSection($TPLgenIni, "Blanks")
$aBlankData		= IniReadSection($TPLgenIni, "BlankData")
$aAssay			= IniReadSection($TPLgenIni, "Assays")
$aFolder		= IniReadSection($TPLgenIni, "FilePaths")

;Calculate maximum positions available for samples: 96 wells -(number of standards * number of replicates)-(number of blanks * number of replicates)
If $aSampleData[2][1] = "-1" Then
	$aSampleData[2][1] = (96-($aStandards[0][0]*$aStdData[2][1])-($aBlankData[1][1])-(($aControls[0][0])*$aControlData[1][1]))
	msgbox(64 + 262144,"Maximum No Samples Calculated","Maximum available number of sample positions: " & $aSampleData[2][1] & @CRLF & "divide by No of replicates if needed",20)
	EndIf

	;_arraydisplay($aOrientation)
	;_arraydisplay($aSamples)
	;_arraydisplay($aSampleData)
	;_arraydisplay($aStandards)
	;_ArrayDisplay($aStdData)
	;_ArrayDisplay($aControls)
	;_ArrayDisplay($aControlData)
	;_ArrayDisplay($aBlank)
	;_ArrayDisplay($aBlankData)
	;_ArrayDisplay($aAssay)
	;_ArrayDisplay($aFolder)

;End TPLgen ini file
;<---------------------------------------------------------------------------------------------------------------------------------------

;main script

;retrieve SampleID's to array
$TPLname = ""
$aScanFile	= _ScanCsv($aFolder)
;Create matrix array with standards, controls & blanks
$aTPL	= _Matrix($aOrientation,$aStdData,$aControlData,$aBlankdata)

; Fill Matrix array with Samples on free positions, then delete all unused positions: array now ready for TPL-file creation
_TPLarray($aTPL, $aScanFile, $aSamples, $aSampleData)

; Produce TPL-file
_TPLfile($aTPL, $aFolder, $TPLname)
;<---------------------------------------------------------------------------------------------------------------------------------------
;Create Matrix array depending on MTP plate orientation [orientation=TB] top to bottom [a-h] and left to right [1-12] or vise versa [Orientation=LR] , matrix will be filled with TPLgen.ini data and Scan.csv data
Func _Matrix(ByRef $aOrientation, ByRef $aStdData, ByRef $aControlData, ByRef $aBlankdata)

Local $aCol = [8,"A","B","C","D","E","F","G","H"]
Local $aRow = [12,1,2,3,4,5,6,7,8,9,10,11,12]
	_arraydisplay($aCol)

local $Positions = $aCol[0] * $aRow[0]
Local $aMatrix = [$Positions]
	msgbox(64 + 262144,"",$Positions,$aOrientation[1][1])

;Set up matrix array
$Orientation = $aOrientation[1][1]
Select
	Case $Orientation = "LR" ;left to right, top to bottom
		For $i = 1 To $aCol[0]
			for $j = 1 to $aRow[0]
				_ArrayAdd($aMatrix, $aCol[$i] & $aRow[$j])
			next
		Next
	Case $Orientation = "TB" ;top to bottom, left to right
		For $p = 1 To $aRow[0]
			for $q = 1 to $aCol[0]
				_ArrayAdd($aMatrix, $aCol[$q] & $aRow[$p])
			next
		Next
EndSelect
_arrayColInsert($aMatrix,1)
_arrayColInsert($aMatrix,0)

;Fill Matrix array with Standards
For $i = 1 to $aStdData[2][1] ; 1 to number of replicates
	Select
		Case $aOrientation[1][1] = "LR" ; MTP layout left to right top to bottom
			Select
				Case $aStdData[3][1]= "H"	;horizontal, only when $Orientation = "LR"
					$pos = _arraysearch($aMatrix,$aStdData[1][1],1,$aMatrix[0][1],0,0,1,-1,False)+(($i-1)*12)
					For $j = 1 to $aStandards[0][0]
						$aMatrix[$pos][0] = $aStandards[$j][0]
						$aMatrix[$pos][2] = $aStandards[$j][1]
						$pos += 1
					Next
				Case $aStdData[3][1]= "V"	;vertical, only when $Orientation = "TB"
					$pos = _arraysearch($aMatrix,$aStdData[1][1],1,$aMatrix[0][1],0,0,1,-1,False)+($i-1)
					For $j = 1 to $aStandards[0][0]
						$aMatrix[$pos][0] = $aStandards[$j][0]
						$aMatrix[$pos][2] = $aStandards[$j][1]
						$pos += 12
					Next
			EndSelect
		Case $aOrientation[1][1] = "TB" ; MTP layout top to bottom left to right
			Select
				Case $aStdData[3][1]= "H"	;horizontal, only when $Orientation = "LR"
					$pos = _arraysearch($aMatrix,$aStdData[1][1],1,$aMatrix[0][1],0,0,1,-1,False)+($i-1)
					For $j = 1 to $aStandards[0][0]
						$aMatrix[$pos][0] = $aStandards[$j][0]
						$aMatrix[$pos][2] = $aStandards[$j][1]
						$pos += 8
					Next
				Case $aStdData[3][1]= "V"	;vertical, only when $Orientation = "TB"
											;msgbox(64 + 262144,"startposition",$aStdData[1][1] & " & " & $aMatrix[0][1])
					$pos = _arraysearch($aMatrix,$aStdData[1][1],1,$aMatrix[0][1],0,0,1,-1,False)+(($i-1)*8)
											;msgbox(64 + 262144,"startposition",$aMatrix[$pos][1])
					For $j = 1 to $aStandards[0][0]
						$aMatrix[$pos][0] = $aStandards[$j][0]
						$aMatrix[$pos][2] = $aStandards[$j][1]
						$pos += 1
					Next
			EndSelect
	EndSelect
Next

;Fill Matrix array with Controls
For $i = 1 to $aControlData[1][1] ; 1 to number of replicates
	Select
		Case $aOrientation[1][1] = "LR" ; MTP layout left to right top to bottom
			Select
				Case $aControlData[2][1]= "H"	;horizontal, only when $Orientation = "LR"
					For $j = 1 to $aControls[0][0]
						$posC = _arraysearch($aMatrix,$aControlData[$j+2][1],1,$aMatrix[0][1],0,0,1,-1,False)+(($i-1)*12)
						If $aMatrix[$posC][0] = "" AND $posC<96 then
							$aMatrix[$posC][0] = $aControls[$j][0]
							$aMatrix[$posC][2] = $aControls[$j][1]
						Else
							Msgbox(48 + 262144, "TPLgen ERROR", "Check the ini-file for overlapping designations of positions" & @CRLF & "Check if duplo values exceeds 96th position of the matrix", 25)
						EndIf
					Next
				Case $aControlData[2][1]= "V"	;vertical, only when $Orientation = "TB"
					For $j = 1 to $aControls[0][0]
						$posC = _arraysearch($aMatrix,$aControlData[$j+2][1],1,$aMatrix[0][1],0,0,1,-1,False)+($i-1)
						If $aMatrix[$posC][0] = "" AND $posC<96 then
							$aMatrix[$posC][0] = $aControls[$j][0]
							$aMatrix[$posC][2] = $aControls[$j][1]
						Else
							Msgbox(48 + 262144, "TPLgen ERROR", "Check the ini-file for overlapping designations of positions" & @CRLF & "Check if duplo values exceeds 96th position of the matrix", 25)
						EndIf
					Next
			EndSelect
		Case $aOrientation[1][1] = "TB" ; MTP layout top to bottom left to right
			Select
				Case $aControlData[2][1]= "H" ;horizontal, only when $Orientation = "LR"
					For $j = 1 to $aControls[0][0]
						$posC = _arraysearch($aMatrix,$aControlData[$j+2][1],1,$aMatrix[0][1],0,0,1,-1,False)+(($i-1)*8)
						If $aMatrix[$posC][0] = "" AND $posC<96 then
							$aMatrix[$posC][0] = $aControls[$j][0]
							$aMatrix[$posC][2] = $aControls[$j][1]
						Else
							Msgbox(48 + 262144, "TPLgen ERROR", "Check the ini-file for overlapping designations of positions" & @CRLF & "Check if duplo values exceeds 96th position of the matrix", 25)
						EndIf
					Next
				Case $aControlData[2][1]= "V"  ;vertical, only when $Orientation = "TB"
											;msgbox(64 + 262144,"startposition",$aControlData[1][1] & " & " & $aMatrix[0][1])
					For $j = 1 to $aControls[0][0]
						$posC = _arraysearch($aMatrix,$aControlData[$j+2][1],1,$aMatrix[0][1],0,0,1,-1,False)+($i-1)
						If $aMatrix[$posC][0] = "" AND $posC<96 then
							$aMatrix[$posC][0] = $aControls[$j][0]
							$aMatrix[$posC][2] = $aControls[$j][1]
						Else
							Msgbox(48 + 262144, "TPLgen ERROR", "Check the ini-file for overlapping designations of positions" & @CRLF & "Check if duplo values exceeds 96th position of the matrix", 25)
						EndIf
					Next
			EndSelect
	EndSelect
Next

;Fill Matrix with Blanks
For $i = 1 to $aBlankData[1][1] ; 1 to number of replicates
	Select
		Case $aOrientation[1][1] = "LR" ; MTP layout left to right top to bottom
			Select
				Case $aBlankData[2][1]= "H"	;horizontal, only when $Orientation = "LR"
					For $j = 1 to $aBlank[0][0]
						$posC = _arraysearch($aMatrix,$aBlankData[$j+2][1],1,$aMatrix[0][1],0,0,1,-1,False)+(($i-1)*12)
						If $aMatrix[$posC][0] = "" AND $posC <=96 then
							$aMatrix[$posC][0] = $aBlank[$j][0]
							$aMatrix[$posC][2] = $aBlank[$j][1]
						Else
							Msgbox(48 + 262144, "TPLgen ERROR", "Check the ini-file for overlapping designations of positions" & @CRLF & "Check if dupo values exceed 96th position of the matrix", 25)
						EndIf
					Next
				Case $aBlankData[2][1]= "V"	;vertical, only when $Orientation = "TB"
					For $j = 1 to $aBlank[0][0]
						$posC = _arraysearch($aMatrix,$aBlankData[$j+2][1],1,$aMatrix[0][1],0,0,1,-1,False)+($i-1)
						If $aMatrix[$posC][0] = "" AND $posC<=96 then
							$aMatrix[$posC][0] = $aBlank[$j][0]
							$aMatrix[$posC][2] = $aBlank[$j][1]
						Else
							Msgbox(48 + 262144, "TPLgen ERROR", "Check the ini-file for overlapping designations of positions" & @CRLF & "Check if dupo values exceed 96th position of the matrix", 25)
						EndIf
					Next
			EndSelect
		Case $aOrientation[1][1] = "TB" ; MTP layout top to bottom left to right
			Select
				Case $aBlankData[2][1]= "H" ;horizontal, only when $Orientation = "LR"
					For $j = 1 to $aBlank[0][0]
						$posC = _arraysearch($aMatrix,$aBlankData[$j+2][1],1,$aMatrix[0][1],0,0,1,-1,False)+(($i-1)*8)
						If $aMatrix[$posC][0] = "" AND $posC<=96 then
							$aMatrix[$posC][0] = $aBlank[$j][0]
							$aMatrix[$posC][2] = $aBlank[$j][1]
						Else
							Msgbox(48 + 262144, "TPLgen ERROR", "Check the ini-file for overlapping designations of positions" & @CRLF & "Check if dupo values exceed 96th position of the matrix", 25)
						EndIf
					Next
				Case $aBlankData[2][1]= "V"  ;vertical, only when $Orientation = "TB"
											;msgbox(0,"startposition",$aBlankData[1][1] & " & " & $aMatrix[0][1])
					For $j = 1 to $aBlank[0][0]
						$posC = _arraysearch($aMatrix,$aBlankData[$j+2][1],1,$aMatrix[0][1],0,0,1,-1,False)+($i-1)
												;msgbox(0,"startposition",$aMatrix[$pos][1])
						If $aMatrix[$posC][0] = "" AND $posC<=96 then
							$aMatrix[$posC][0] = $aBlank[$j][0]
							$aMatrix[$posC][2] = $aBlank[$j][1]
						Else
							Msgbox(48 + 262144, "TPLgen ERROR", "Check the ini-file for overlapping designations of positions" & @CRLF & "Check if dupo values exceed 96th position of the matrix", 25)
						EndIf
					Next
			EndSelect
	EndSelect
Next

return $aMatrix

EndFunc;Create Matrix array, matrix will be filled with TPLgen.ini data and Scan.csv data
;<---------------------------------------------------------------------------------------------------------------------------------------
;<---------------------------------------------------------------------------------------------------------------------------------------
; Read Scan.csv file to array, scan.csv contains SampleID's, DPW plateID and STD and CTL ID's if the EVOware barcode read command is set.
Func _ScanCsv(ByRef $FilePaths)

$ScanPath = $FilePaths[2][1]												; @scriptdir & "\scan\"
																			; $FolderPath = "C:\ProgramData\Tecan\EVOware\output\"
local $ScanCsv = $FilePaths[2][0]											; filename to read to array
local $aScan = ""															; array to fill with scan.csv data

$checkTPL = StringRegExp($ScanPath,"^.+\\$",0)
	  If $checkTPL = 0 Then $TPLath = $ScanPath & "\"
		 If @error = -1 then
			Msgbox(48 + 262144,"","Sorry but " & $ScanPath & " has no files")
;			If $LOGFILE = 1 Then _SendAndLog($ScanPath & " has no *.TPL files", $Logname, True)
			Exit
		 EndIf

$aScansearch = _FileListToArray($ScanPath,"*.csv",1)
	  If Not IsArray($aScansearch) Then
		  Msgbox(48 + 262144,"","Sorry but " & $ScanPath & " has no files")
;			If $LOGFILE = 1 Then _SendAndLog($ScanPath & " has no *.TPL files", $Logname, True)
		  Exit
	  EndIf

Global $aScansearch2D[10][2]
ReDim $aScansearch2D[$aScansearch[0]+1][2]
$aScansearch2D[0][0] = $aScansearch[0]

For $i=1 to $aScansearch[0]
    $aScansearch2D[$i][0] = $aScansearch[$i]
    $aScansearch2D[$i][1] = FileGetTime($ScanPath & $aScansearch[$i],0,1)
Next

_ArraySort($aScansearch2D,1,1,"",1)
$aIndex = _ArraySearch($aScansearch2D, $ScanCsv)
_FileReadToArray($ScanPath & $aScansearch2D[$aIndex][0] , $aScan)

$LoopCount = ubound($aScan)-1
For $j = $LoopCount to 1 step -1
	If Stringright ($aScan[$j],3) = "$$$" Then
	_arraydelete($aScan, $j)
	$LoopCount = $LoopCount-1
	$aScan[0] = $aScan[0]-1
	EndIf
Next

Return $aScan

EndFunc ;ScanCsv
;<---------------------------------------------------------------------------------------------------------------------------------------
;<---------------------------------------------------------------------------------------------------------------------------------------
; Executed after _ScanCsv & _Matrix : the 96 position matrix is now filled with standards, controls and blanks
; _TPLfile will add the SampleIDs to the matrix
Func _TPLarray(ByRef $aTPLtrix, ByRef $aScanFile, ByRef $aSamples, byRef $aSampleData)

$TPLname	= StringTrimleft($aScanFile[$aScanFile[0]],StringInStr($aScanFile[$aScanFile[0]],";",0,-1))	; retrieves DPW plate_ID, which will also be the name of the TPL-file from the contents of the last line of the csv-file read into a string
			If @error then
				MsgBox(48 + 262144, "TPLgen Error", "It seems the scan.csv entry in the TPLgen.ini file" & @CRLF & "is not correct!" _
								& @CRLF & "make sure the '\' is added at the end", 15)
			EndIf

local $aSampleID = [$aScanfile[0]]
	_ArrayDisplay($aSampleID)

; SampleIDs from Scanfile.csv read to array $aScanFile
$q = 0
For $p = 1 to $aScanFile[0]-1
	If StringLeft($aScanFile[$p],1) <= $aSampleData[1][1] then
		$SampleID = StringTrimleft ($aScanFile[$p],StringInStr($aScanFile[$p],";",0,-1))
		If Stringmid($aScanFile[$p],2,1) <> ";" then
			$q += 1
		ElseIf Stringleft($aScanFile[$p],1) <= $aSampleData[1][1] then
			_arrayAdd($aSampleID, $SampleID)
			$aSampleID[0] = $p - $q -1
		EndIf
	EndIf
Next

;Extract all empty indices from $aTPLtrix array to loop over and fill with the SampleIDs.
$aEmptyIndex = _ArrayFindAll($aTPLtrix, "" ,0);_ArrayFindAll ( Const ByRef $aArray, $vValue [, $iStart = 0 [, $iEnd = 0 [, $iCase = 0 [, $iCompare = 0 [, $iSubItem = 0 [, $bRow = False]]]]]] )
$aEmptyIndex[0] = Ubound($aEmptyIndex)-1

	msgbox(48 + 262144, "TrayID/ TPL-file name", $TPLname)
	_ArrayDisplay($aSampleID,"SampleID")
	_ArrayDisplay($aTPLtrix, "96Matrix")
	_ArrayDisplay($aSamples, "replicateDil")
	msgbox(48 + 262144,"",$aSampleData[2][1] & " " & $aSamples[1][0] & " " & $aSampleID[0])
	_arraydisplay($aEmptyIndex, "Available positions")

;#CS
;Add Samples and Dilution range designator to $aTPLtrix matrix array
Select
	Case $aSamples[0][0] = 1 AND $aSamples[1][0] = 1; only one dilution range per sample i.e. V1 or V2 or Vx
		$j= 1
		For $i = 1 to Ubound($aEmptyIndex);Ubound($aSampleID)
				$aTPLtrix[$aEmptyIndex[$i]][0] = $aSampleID[$j]
				$aTPLtrix[$aEmptyIndex[$i]][2] = $aSamples[1][1]
			$j += 1
			If $j = $aSampleID[0] then ExitLoop
		Next
	Case $aSamples[0][0] = 1 AND $aSamples[1][0] > 1;  2 replicates or more & only one dilution range per sample i.e. V1 or V2 or Vx
		If ($aEmptyIndex[0]/$aSamples[1][0]) >= $aSampleID[0] then
			$j= 1
			For $i = 1 to Ubound($aEmptyIndex) ;Ubound($aSampleID)
				For $k = 1 to $aSamples[1][0]
					$aTPLtrix[$aEmptyIndex[$i+($k-1)]][0] = $aSampleID[$j]
					$aTPLtrix[$aEmptyIndex[$i+($k-1)]][2] = $aSamples[1][1]
				Next
				$j += 1
				$i += 1
				If $j-1 = $aSampleID[0] then ExitLoop
			Next
		Else
				MsgBox(48 + 262144, "TPLgen Error", "Maximum number of samples exceeded!",20)
		EndIf
	Case $aSamples[0][0] > 1 ; possibly more then one dilution range per sample V1 and V2 and Vx
		If ($aEmptyIndex[0]/$aSamples[0][0]) >= $aSampleID[0] then
			$j= 1
			For $i = 1 to Ubound($aEmptyIndex) ;Ubound($aSampleID)
				If $aTPLtrix[$aEmptyIndex[$i]][0] = "" then
					For $k = 1 to $aSamples[0][0]
						$aTPLtrix[$aEmptyIndex[$i+($k-1)]][0] = $aSampleID[$j]
						$aTPLtrix[$aEmptyIndex[$i+($k-1)]][2] = $aSamples[$k][1]
					Next
					$j += 1
					$i += 1
				ElseIf $aTPLtrix[$aEmptyIndex[$i]][0] = "" Then
					$i +=1
				EndIf
				If $j-1 = $aSampleID[0] then ExitLoop
			Next
		Else
				MsgBox(48 + 262144, "TPLgen Error", "Maximum number of samples exceeded!",20)
		EndIf
EndSelect

	_ArrayDisplay($aTPLtrix)
	;#CE

;delete empty cells from $aTPLtrix matrix
$j= 1
For $i = $aTPLtrix[0][1] to 1 step -1 ;Ubound($aSampleID)
		If $aTPLtrix[$i][0] = "" then
			_ArrayDelete($aTPLtrix, $i)
			$aTPLtrix[0][1] -= 1
		EndIf
Next

return $aTPLtrix
return $TPLname

EndFunc
;<---------------------------------------------------------------------------------------------------------------------------------------
;<---------------------------------------------------------------------------------------------------------------------------------------
Func _TPLfile(ByRef $aTPLtrix, ByRef $Filepaths, $TPL_ID)

;MsgBox(64 + 262144, "TPLgen TPL-filename", $TrayID,20)
;_arrayDisplay($aTPLtrix)

;Header H;hh:mm:ss;dd-mm-yy
$Header	= "H;" & @HOUR & ":" & @MIN & ":" & @SEC & ";" & @MDAY & "-" & @MON & "-" & @YEAR
$Footer	= "L;"
$LIMS	= $aAssay[1][1]

If @error then
	msgbox(48 + 262144,"TPLgen", $TPL_ID & ".tpl file could not be created in: " & $aFolder[1][1] & @CRLF _
	& "check TPLgen.ini file and folder settings" ,10)
	Exit
EndIf

local $TPLfile = fileopen($aFolder[1][1] & $TPL_ID & ".TPL", 2 +8)

; write TPLfile
FileWriteline($TPLfile, $Header & @CRLF)
For $i = 1 to Ubound($aTPLtrix)-1
	FileWriteLine($TPLfile, "D;" & $LIMS & ";" & $aTPLtrix[$i][0] & ";"  & $aTPLtrix[$i][1] & ";" & $aTPLtrix[$i][2] & ";" & @CRLF)
Next
FileWriteline($TPLfile, $Footer & @CRLF)

If FileExists($aFolder[1][1] & $TPL_ID & ".TPL") then
	msgbox(64 + 262144,"TPLgen",$TPL_ID & ".tpl file created in: " & $aFolder[1][1],10)
EndIf

EndFunc