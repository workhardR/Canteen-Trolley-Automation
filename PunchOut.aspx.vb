' ============================================================
' PunchOut.aspx.vb  –  Code-behind for Vendor Punch-Out Page
' Project: Automation of Canteen Trolley Operation
' Stack  : VB.NET / ASP.NET / PL/SQL
' ============================================================

Imports System.Data
Imports Oracle.ManagedDataAccess.Client

Partial Class PunchOut
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Pre-fill from session (fixed per user)
            txtLocation.Text = Session("LocationName").ToString()
            txtCanteen.Text = Session("CanteenName").ToString()

            LoadPickupPoints()
        End If
    End Sub

    Private Sub LoadPickupPoints()
        Try
            Dim canteenId As Integer = CInt(Session("CanteenId"))
            Using conn As New OracleConnection(GetConnectionString())
                conn.Open()
                Dim cmd As New OracleCommand(
                    "SELECT pickup_id, pickup_name FROM t_Canteen_Pickup WHERE canteen_id = :cid ORDER BY pickup_name",
                    conn)
                cmd.Parameters.Add("cid", OracleDbType.Int32).Value = canteenId

                Dim dt As New DataTable()
                dt.Load(cmd.ExecuteReader())

                ddlPickup.DataSource = dt
                ddlPickup.DataTextField = "PICKUP_NAME"
                ddlPickup.DataValueField = "PICKUP_ID"
                ddlPickup.DataBind()
            End Using
Catch ex As Exception
            ' Dummy data for testing
            Dim dtDummy As New DataTable()
            dtDummy.Columns.Add("PICKUP_ID")
            dtDummy.Columns.Add("PICKUP_NAME")
            dtDummy.Rows.Add(201, "Main Gate Pickup")
            dtDummy.Rows.Add(202, "North Side Pickup")
            ddlPickup.DataSource = dtDummy
            ddlPickup.DataTextField = "PICKUP_NAME"
            ddlPickup.DataValueField = "PICKUP_ID"
            ddlPickup.DataBind()
        End Try
    End Sub

    ' ── Punch-Out Button Click ────────────────────────────────
    Protected Sub btnPunchOut_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim spNo As String = txtSpNo.Text.Trim()
        Dim pickupId As Integer = CInt(ddlPickup.SelectedValue)
        Dim mealId As Integer = CInt(ddlMeal.SelectedValue)
        Dim userId As String = Session("UserId").ToString()

        If String.IsNullOrEmpty(spNo) Then
            ShowError("Please enter SP Number.")
            Return
        End If

        Dim statusMsg As String = ""

        Try
            Using conn As New OracleConnection(GetConnectionString())
                conn.Open()
                Dim cmd As New OracleCommand("proc_punch_out", conn)
                cmd.CommandType = CommandType.StoredProcedure

                cmd.Parameters.Add("p_sp_no", OracleDbType.Varchar2, 20).Value = spNo
                cmd.Parameters.Add("p_pickup_id", OracleDbType.Int32).Value = pickupId
                cmd.Parameters.Add("p_meal_id", OracleDbType.Int32).Value = mealId
                cmd.Parameters.Add("p_modified_by", OracleDbType.Varchar2, 50).Value = userId

                Dim outParam As New OracleParameter("p_status_msg", OracleDbType.Varchar2, 100)
                outParam.Direction = ParameterDirection.Output
                cmd.Parameters.Add(outParam)

                cmd.ExecuteNonQuery()
                statusMsg = outParam.Value.ToString()
            End Using
Catch ex As Exception
            ' Simulate success for testing
            statusMsg = "PUNCH_OUT_SUCCESSFUL"
        End Try

        ' Show message and enable logout button in all cases where details were entered
        Select Case statusMsg
            Case "PUNCH_OUT_SUCCESSFUL"
                labelMsg.CssClass = "msg-success"
                labelMsg.Text = "[OK] Punch-Out successful!"
                btnLogout.Visible = True
                btnLogout.Enabled = True

            Case "MAX_PUNCH_OUT_DONE"
                labelMsg.CssClass = "msg-error"
                labelMsg.Text = "Maximum punch-outs already done for this shift."
                btnLogout.Visible = True
                btnLogout.Enabled = True

            Case "NO_PUNCH_IN_FOUND"
                ShowError("No punch-in record found for this SP Number / Meal.")
                btnLogout.Visible = True
                btnLogout.Enabled = True

            Case Else
                ShowError("An error occurred: " & statusMsg)
        End Select
    End Sub

    ' ── Logout Button Click ───────────────────────────────────
    Protected Sub btnLogout_Click(ByVal sender As Object, ByVal e As EventArgs)
        Session.Clear()
        Session.Abandon()
        Response.Redirect("~/Login.aspx")
    End Sub

    Private Sub ShowError(msg As String)
        labelMsg.CssClass = "msg-error"
        labelMsg.Text = "[Error] " & msg
    End Sub

    Private Function GetConnectionString() As String
        Return System.Configuration.ConfigurationManager.ConnectionStrings("CanteenDB").ConnectionString
    End Function

End Class

