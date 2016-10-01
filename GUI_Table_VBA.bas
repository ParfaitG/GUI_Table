
''''''''''''''''''''''''''
'''' MS ACCESS 
''''''''''''''''''''''''''
Option Explicit
Option Compare Database


' Form_ReportMenu Module

Option Explicit
Option Compare Database

Private Sub Form_Open(Cancel As Integer)
    CurrentDb.Execute "DELETE FROM IncData"
    DoCmd.TransferText acImportDelim, , "IncData", Application.CurrentProject.Path & "\DATA\IncData.csv", True
End Sub

Private Sub RunOutput_Click()
    DoCmd.OpenForm "IncTable", acFormDS
End Sub


' Form_IncTable Module

Private Sub COMPANY_Click()
    Application.FollowHyperlink "https://www.google.com/#q=" & Replace(Me.COMPANY, " ", "%20")
End Sub

Private Sub Form_Open(Cancel As Integer)
    DoCmd.ApplyFilter , FilterCriteria()
End Sub

Private Function FilterCriteria() As String
On Error GoTo ErrHandle
    Dim strFilter As String
    
    strFilter = "1=1"
    If Not IsNull(Forms!ReportMenu!IndustryCbo) Then
        strFilter = strFilter & " AND [Industry]='" & Forms!ReportMenu!IndustryCbo & "'"
    End If

    If Not IsNull(Forms!ReportMenu!YearCbo) Then
        strFilter = strFilter & " AND [Inc_Year]='" & Forms!ReportMenu!YearCbo & "'"
    End If
    
    If Not IsNull(Forms!ReportMenu!MetroCbo) Then
        strFilter = strFilter & " AND [Metro_Area]='" & Forms!ReportMenu!MetroCbo & "'"
    End If

    FilterCriteria = strFilter
    Exit Function
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description
    Exit Function
End Function



''''''''''''''''''''''''''
'''' MS EXCEL 
''''''''''''''''''''''''''
' OutputTable (Userform)

Option Explicit
Dim wsh As Worksheet
Dim lastrow As Long

Private Sub IncTable_DblClick(ByVal Cancel As MSForms.ReturnBoolean)
    Dim Msg As String
    Dim i As Integer
    
    For i = 0 To IncTable.ListCount - 1
        If IncTable.Selected(i) Then
            ActiveWorkbook.FollowHyperlink "https://www.google.com/#q=" & Replace(IncTable.List(i, 2), " ", "+")
        End If
    Next i
    
End Sub

Private Sub UserForm_Initialize()
On Error GoTo ErrHandle
    Dim i As Long, row As Long, lastrow As Long
    Dim tblArray() As Variant
    Dim condition As Boolean
    
    Set wsh = Worksheets("DATA")
    lastrow = wsh.Cells(wsh.rows.Count, "A").End(xlUp).row
        
    i = 0
    For row = 1 To lastrow
        condition = 1 = 1
        
        If ReportMenu.IndustryCbo.Value <> "" Then
            condition = condition And wsh.Cells(row, 6).Value = ReportMenu.IndustryCbo.Value
        End If
        
        If ReportMenu.YearCbo.Value <> "" Then
            condition = condition And CStr(wsh.Cells(row, 2).Value) = CStr(ReportMenu.YearCbo.Value)
        End If
        
        If ReportMenu.MetroCbo.Value <> "" Then
            condition = condition And wsh.Cells(row, 8).Value = ReportMenu.MetroCbo.Value
        End If
                
        If condition Then
            i = i + 1
        End If
    Next row
    
    ReDim tblArray(0 To i, 0 To 7)
       
    i = 0
    For row = 1 To lastrow
        condition = 1 = 1
        
        If ReportMenu.IndustryCbo.Value <> "" Then
            condition = condition And wsh.Cells(row, 6).Value = ReportMenu.IndustryCbo.Value
        End If
        
        If ReportMenu.YearCbo.Value <> "" Then
            condition = condition And CStr(wsh.Cells(row, 2).Value) = CStr(ReportMenu.YearCbo.Value)
        End If
        
        If ReportMenu.MetroCbo.Value <> "" Then
            condition = condition And wsh.Cells(row, 8).Value = ReportMenu.MetroCbo.Value
        End If
                        
        If condition Then

            tblArray(i, 0) = wsh.Cells(row, 1).Value
            tblArray(i, 1) = wsh.Cells(row, 2).Value
            tblArray(i, 2) = wsh.Cells(row, 3).Value
            tblArray(i, 3) = wsh.Cells(row, 4).Value
            tblArray(i, 4) = wsh.Cells(row, 5).Value
            tblArray(i, 5) = wsh.Cells(row, 6).Value
            tblArray(i, 6) = wsh.Cells(row, 7).Value
            tblArray(i, 7) = wsh.Cells(row, 8).Value
        
            i = i + 1
        End If
    Next row
            
    IncTable.List() = tblArray
    IncTable.ListIndex = 0
    Exit Sub

ErrHandle:
    MsgBox Err.Number & " - " & Err.Description
    Exit Sub
End Sub



' ReportForm (Userform)

Option Explicit
Dim wsh As Worksheet
Dim lastrow As Long

Private Sub OutputBtn_Click()
On Error GoTo ErrHandle
    OutputTable.Show
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description
    Exit Sub
End Sub

Private Sub UserForm_Initialize()
On Error GoTo ErrHandle
    Dim industryDict As Object, yearDict As Object, metroDict As Object
    Dim industryArray() As Variant, yearArray() As Variant, metroArray() As Variant
    Dim key As Variant, val As Variant, item As Variant
    Dim row As Long
    
    ' IMPORT CSV DATA
    Call ImportIncData
    
    Set industryDict = CreateObject("Scripting.Dictionary")
    Set yearDict = CreateObject("Scripting.Dictionary")
    Set metroDict = CreateObject("Scripting.Dictionary")
        
    Set wsh = Worksheets("DATA")
    lastrow = wsh.Cells(wsh.rows.Count, "A").End(xlUp).row
        
    ' RETRIEVE DISTINCT VALUES
    For row = 1 To lastrow
        On Error Resume Next
        key = wsh.Cells(row, 6): val = "industry": industryDict.Add key, val
        key = wsh.Cells(row, 2): val = "year": yearDict.Add key, val
        key = wsh.Cells(row, 8): val = "metro": metroDict.Add key, val
        On Error GoTo 0
    Next row
    
    industryArray = SortDict(industryDict)
    yearArray = SortDict(yearDict)
    metroArray = SortDict(metroDict)
    
    ' POPULATE COMBO BOXES
    For Each item In industryArray
        Me.IndustryCbo.AddItem item
    Next item

    For Each item In yearArray
        Me.YearCbo.AddItem item
    Next item

    For Each item In metroArray
        Me.MetroCbo.AddItem item
    Next item
    
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description
    Exit Sub
End Sub



' GUITableModule

Option Explicit

Sub OpenForm()
    ReportMenu.Show
End Sub

Sub ImportIncData()
On Error GoTo ErrHandle
    Dim qt As QueryTable
    
    Worksheets("DATA").Range("A:H").Delete xlShiftToLeft
    
    'Imports data from text file
    With Worksheets("DATA").QueryTables.Add(Connection:="TEXT;" & _
        ActiveWorkbook.Path & "\DATA\IncData.csv", Destination:=Worksheets("DATA").Cells(1, 1))
            .TextFileStartRow = 2
            .TextFileParseType = xlDelimited
            .TextFileConsecutiveDelimiter = False
            .TextFileTabDelimiter = False
            .TextFileSemicolonDelimiter = False
            .TextFileCommaDelimiter = True
            .TextFileSpaceDelimiter = False

            .Refresh BackgroundQuery:=False
    End With
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description
    Exit Sub
End Sub

Public Function SortDict(objDict) As Variant
On Error GoTo ErrHandle
    Dim key1 As Variant, key2 As Variant
    Dim itemArray() As Variant, item As Variant
    Dim i As Long

    ReDim itemArray(0 To objDict.Count)
    For Each key1 In objDict.keys
        i = 1
        For Each key2 In objDict.keys
            If key1 > key2 Then
                i = i + 1
            End If
        Next key2
        itemArray(i - 1) = key1
    Next key1

    SortDict = itemArray
    Exit Function
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description
    Exit Function
End Function

Public Function SortDictTest() As Variant
On Error GoTo ErrHandle
    Dim key1 As Variant, key2 As Variant
    Dim objDict As Object
    Dim finalarray() As Variant, item As Variant
    Dim i As Long
    
    Set objDict = CreateObject("Scripting.Dictionary")
    objDict.Add "key1", "z"
    objDict.Add "key2", "a"
    objDict.Add "key3", "y"
    objDict.Add "key4", "b"
    objDict.Add "key5", "x"
    objDict.Add "key6", "c"
    
    ReDim finalarray(0 To objDict.Count)
    For Each key1 In objDict.keys
        i = 1
        For Each key2 In objDict.keys
            If objDict(key1) > objDict(key2) Then
            
                i = i + 1
            End If
        Next key2
        finalarray(i - 1) = objDict(key1)
    Next key1
    
    For Each item In finalarray
        Debug.Print item
    Next item
    Exit Function
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description
    Exit Function
End Function


