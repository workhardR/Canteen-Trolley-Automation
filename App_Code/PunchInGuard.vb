' ============================================================
' PunchInGuard.vb  –  Shared gate-check module
' Reuse this in frmSnacksCounter.aspx.vb and frmSmtMealBook.aspx.vb
' Project: Automation of Canteen Trolley Operation
' ============================================================

Imports System.Data
Imports Oracle.ManagedDataAccess.Client

Public Module PunchInGuard

    ''' <summary>
    ''' Call at the top of Page_Load for any booking/delivery page.
    ''' Redirects to PunchIn.aspx if the vendor hasn't punched in.
    ''' Also checks meal mismatch and shows an inline label in that case.
    ''' </summary>
    Public Sub EnsurePunchedIn(
        page As System.Web.UI.Page,
        spNo As String,
        mealId As Integer,
        labelMsg As System.Web.UI.WebControls.Label,
        txtSpNo As System.Web.UI.WebControls.TextBox,
        btnPunchIn As System.Web.UI.WebControls.Button
    )
        Dim result As Integer = GetPunchInStatus(spNo, mealId)

        Select Case result
            Case 0 ' No punch-in at all → redirect
                page.Response.Redirect("~/PunchIn.aspx")

            Case 1 ' Punched in, correct meal → allow
                ' Nothing to do; page loads normally

            Case 2 ' Punched in but different meal
                labelMsg.Text = "You have not punched-in for this meal. Please punch-in for the correct meal."
                labelMsg.CssClass = "msg-error"
                txtSpNo.Enabled = False
                btnPunchIn.Visible = True
        End Select
    End Sub

    Private Function GetPunchInStatus(spNo As String, mealId As Integer) As Integer
        ' Returns: 1 = punched-in for this meal, 2 = punched-in but wrong meal, 0 = not punched-in at all
        Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("CanteenDB").ConnectionString
        Using conn As New OracleConnection(connStr)
            conn.Open()
            ' Check correct meal
            Dim cmdCorrect As New OracleCommand(
                "SELECT COUNT(*) FROM t_Vendor_Attendance " &
                "WHERE sp_no = :spno AND meal_id = :mid AND punch_date = TRUNC(SYSDATE) AND status = 'IN'",
                conn)
            cmdCorrect.Parameters.Add("spno", OracleDbType.Varchar2).Value = spNo
            cmdCorrect.Parameters.Add("mid", OracleDbType.Int32).Value = mealId
            Dim countCorrect As Integer = CInt(cmdCorrect.ExecuteScalar())
            If countCorrect > 0 Then Return 1

            ' Check any meal
            Dim cmdAny As New OracleCommand(
                "SELECT COUNT(*) FROM t_Vendor_Attendance " &
                "WHERE sp_no = :spno AND punch_date = TRUNC(SYSDATE) AND status = 'IN'",
                conn)
            cmdAny.Parameters.Add("spno", OracleDbType.Varchar2).Value = spNo
            Dim countAny As Integer = CInt(cmdAny.ExecuteScalar())
            If countAny > 0 Then Return 2

            Return 0
        End Using
    End Function

End Module


' ============================================================
' Example usage in frmSmtMealBook.aspx.vb
' ============================================================
'
' Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
'     If Not IsPostBack Then
'         Dim spNo As String = Session("CurrentSpNo").ToString()
'         Dim mealId As Integer = CInt(Session("CurrentMealId"))
'
'         PunchInGuard.EnsurePunchedIn(
'             Me, spNo, mealId,
'             lblPunchMsg, txtSpNo, btnGoToPunchIn)
'     End If
' End Sub

