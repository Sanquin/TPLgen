TPLgen is developed to create TPL-files for Tecan Evoware ELISA assays that are split in two steps. The first part of the assay takes consists of making sample dilutions in a 96-well deepwell plate. 
In EVOware Standard all labware barcodes are scanned to a scan.csv file.  Standards, Controls and Samples are dilutions are then pipetted to a 96-position deepwell plate (DPW),
 after which TPLgen.exe is run to produce an assay specific TPL-file. The second part of the assay is programmed in Evoware Plus where the DPWs are now used to perform multiple ELISAs. 
 The TPL-file pipetting data supplements the ASCII file with measured absorption data as produced by the Magellan reader. 

Please Note:
The laboratory responsible for running the assay has to ensure that the TPL-file data is an accurate reflection of the actual 
Tecan EVOware performance. Please be informed that by manipulating the TPLgen.ini file nothing is changed in the actual performance of the EVOware program!
When an assay needs to be changed, these changes have to be implemented in both the Evoware program and the TPLgen.ini file. 
Upon first execution of the assay it is paramount that all TPL file data is properly checked to agree with the actual pipetting actions as programmed in Evoware Standard.

TPLgen is programmed in AutoIT v3.3.14.2 and compiled as TPLgen.exe with the AutoIT compiler.
Prerequisites for the correct execution of TPLgen.exe are a TecanEvoware scan.csv file, containing the barcodeID’s of the scanned labware. 
Use of x TPLgen.ini & TPLgen.exe

If not already existent TPLgen.exe automatically produces a TPLgen.ini file in the script directory. 
TPLgen.ini is a text-file that consists of a set of headers that list linked data fields.  
A combination of common sense, a bit of academic deduction and some frivolous sessions of trial and error should get any reasonable plate layout translated to a corresponding TPLgen.ini file, 
which then serves as a template for a representative TPL-file when TPL.exe is run.
The initial TPLgen.ini contains a template to fill a 96- position matrix with samples, standards and controls. 
The program is set up to have the standard, controls and blanks on fixed positions while samples fill up the spaces in between from left to right and top to bottom or vice versa. 
The general order of the workflow is follows the headers of the TPLgen.ini from top to bottom.
The order of the plate layout should be chosen first. The 96 position plate layout can be set up as 12 [1-12] columns of 8 [A-H] 
positions that are to be filled from top to bottom and from left to right. The resulting order of positions in the matrix will look like: A1, B1, C1…….F12, G12, H12.
Alternatively the 96 position plate layout can be set up as 8 [A-H] rows of 12 [1-12] positions. From left to right and from top to bottom, 
i.e.: A1, A2, A3…H10, H11, H12. Both portrait and landscape configurations are captured within both possible setups.
TPLgen.exe translates the chose order of the 96position matrix to a 2D- array of 96 positions. The array is first filled with Standard dilutions. 
Then the controls, blanks and samples are sequentially added to the array, but if a designated position is already filled a message will appear to check the TPLgen.ini file as it
 will probably have an incorrect entry for the position of the control.
Existing data will not be overwritten and the wrong designation is skipped! This will result in a faulty TPL-file! Therefore newly made TPLgen.ini templates should be thoroughly inspected! 
First the standards, then controls, blanks and finally the samples from the scan.csv file are added to the array. One has to take care that positions do not overlap. 
Examples of the use of TPLgen.ini and can be found in the validation tests section. An explanatory overview of the correct entry of TPLgen.ini data fields is given on the next page.

TPLgen script remarks intro:

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
;scan.CSV=C:\ProgramData\Tecan\EVOware\output\
;
; ***********************************************************************************************************************
 

