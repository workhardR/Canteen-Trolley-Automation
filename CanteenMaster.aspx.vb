' ============================================================
' CanteenMaster.aspx.vb  –  Dashboard / Master Page
' Shows: Punch-In | Punch-Out | Attendance Report tiles
' Intercepts logout for vendors → redirects to PunchOut page
' Project: Automation of Canteen Trolley Operation
' ============================================================

Partial Class CanteenMaster
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            If Session("UserId") Is Nothing Then
                Response.Redirect("~/Login.aspx")
                Return
            End If

            Dim userRole As String = Session("UserRole").ToString().ToLower()
            litUserName.Text = Session("UserName").ToString()
            litRole.Text = Session("UserRole").ToString()
            litLocation.Text = Session("LocationName").ToString()
            litCanteen.Text = Session("CanteenName").ToString()

            ' Show dashboard tiles based on role
            pnlPunchIn.Visible = True
            pnlPunchOut.Visible = True
            ' For testing: let admin see attendance
            pnlAttendance.Visible = (userRole = "ccs" OrElse userRole = "ecs" OrElse userRole = "itadmin" OrElse userRole = "admin")
        End If
    End Sub

    ' ── Navigate to Punch-In ──────────────────────────────────
    Protected Sub btnGoToPunchIn_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/PunchIn.aspx")
    End Sub

    ' ── Navigate to Punch-Out ─────────────────────────────────
    Protected Sub btnGoToPunchOut_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/PunchOut.aspx")
    End Sub

    ' ── Navigate to Attendance Report ─────────────────────────
    Protected Sub btnAttendanceReport_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/AttendanceDetails.aspx")
    End Sub

    ' ── Logout Handler ────────────────────────────────────────
    ' Called by menu logout link; intercepts if vendor hasn't punched out
    Protected Sub btnLogout_Click(sender As Object, e As EventArgs)
        Dim userRole As String = Session("UserRole").ToString().ToLower()

        ' Roles that must punch-out before logging out
        Dim requiresPunchOut As Boolean = (userRole = "ccs" OrElse userRole = "ecs" OrElse userRole = "itadmin")

        If requiresPunchOut Then
            ' Check if the user has any open (un-punched-out) records today
            If HasOpenPunchIn() Then
                Response.Redirect("~/PunchOut.aspx")
                Return
            End If
        End If

        ' Safe to log out
        Session.Clear()
        Session.Abandon()
        Response.Redirect("~/Login.aspx")
    End Sub

    Private Function HasOpenPunchIn() As Boolean
        Try
            Dim spNo As String = Nothing
            If Session("CurrentSpNo") IsNot Nothing Then
                spNo = Session("CurrentSpNo").ToString()
            End If
            If String.IsNullOrEmpty(spNo) Then Return False

            Dim connStr As String = System.Configuration.ConfigurationManager _
                                       .ConnectionStrings("CanteenDB").ConnectionString
            Using conn As New Oracle.ManagedDataAccess.Client.OracleConnection(connStr)
                conn.Open()
                Dim cmd As New Oracle.ManagedDataAccess.Client.OracleCommand(
                    "SELECT COUNT(*) FROM t_Vendor_Attendance " &
                    "WHERE sp_no = :spno AND punch_date = TRUNC(SYSDATE) AND punch_out_time IS NULL",
                    conn)
                cmd.Parameters.Add("spno", Oracle.ManagedDataAccess.Client.OracleDbType.Varchar2).Value = spNo
                Return CInt(cmd.ExecuteScalar()) > 0
            End Using
        Catch ex As Exception
            ' Return false for testing if DB fails
            Return False
        End Try
    End Function

End Class

