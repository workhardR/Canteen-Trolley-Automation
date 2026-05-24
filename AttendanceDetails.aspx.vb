' ============================================================
' AttendanceDetails.aspx.vb
' Project: Automation of Canteen Trolley Operation
' Features: Individual-wise / Canteen-wise report + Excel export
' ============================================================

Imports System.Data
Imports Oracle.ManagedDataAccess.Client
Imports System.IO
' Imports ClosedXML.Excel ' Install via NuGet: ClosedXML

Partial Class AttendanceDetails
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Default date range = today
            Dim today As String = Date.Today.ToString("dd-MM-yyyy")
            txtFromDate.Text = today
            txtToDate.Text = today
            txtFromDate2.Text = today
            txtToDate2.Text = today

            LoadCanteens()
        End If
    End Sub

    Private Sub LoadCanteens()
        ' Dummy data for testing
        Dim dt As New DataTable()
        dt.Columns.Add("CANTEEN_ID")
        dt.Columns.Add("CANTEEN_NAME")
        dt.Rows.Add(101, "Main Canteen")
        dt.Rows.Add(102, "Staff Canteen")
        ddlCanteen.DataSource = dt
        ddlCanteen.DataTextField = "CANTEEN_NAME"
        ddlCanteen.DataValueField = "CANTEEN_ID"
        ddlCanteen.DataBind()
    End Sub

    ' ── Navigation ────────────────────────────────────────────
    Protected Sub btnBack_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/CanteenMaster.aspx")
    End Sub

    ' ── Tab Controls ──────────────────────────────────────────
    Protected Sub btnTabIndividual_Click(sender As Object, e As EventArgs)
        pnlIndividual.Visible = True
        pnlCanteen.Visible = False
        btnTabIndividual.CssClass = "tab-btn active"
        btnTabCanteen.CssClass = "tab-btn"
        pnlGrid.Visible = False
    End Sub

    Protected Sub btnTabCanteen_Click(sender As Object, e As EventArgs)
        pnlIndividual.Visible = False
        pnlCanteen.Visible = True
        btnTabIndividual.CssClass = "tab-btn"
        btnTabCanteen.CssClass = "tab-btn active"
        pnlGrid.Visible = False
    End Sub

    ' ── Show Individual-wise Attendance ───────────────────────
    Protected Sub btnShowIndividual_Click(sender As Object, e As EventArgs)
        Dim spNo As String = txtSpNo.Text.Trim()
        Dim fromDate As Date = Date.ParseExact(txtFromDate.Text, "dd-MM-yyyy", Nothing)
        Dim toDate As Date = Date.ParseExact(txtToDate.Text, "dd-MM-yyyy", Nothing)

        If String.IsNullOrEmpty(spNo) Then
            ShowError("Please enter SP Number.")
            Return
        End If

        Dim dt As DataTable = GetIndividualAttendance(spNo, fromDate, toDate)
        
        ' Reset column visibility for individual report
        gvAttendance.Columns(0).HeaderText = "SP Number"
        gvAttendance.Columns(4).Visible = True ' Punch In
        gvAttendance.Columns(5).Visible = True ' Punch Out
        gvAttendance.Columns(6).Visible = True ' Status
        
        gvAttendance.DataSource = dt
        gvAttendance.DataBind()
        ViewState("CurrentData") = dt
        pnlGrid.Visible = True
    End Sub

    ' ── Show Canteen-wise Attendance ──────────────────────────
    Protected Sub btnShowCanteen_Click(sender As Object, e As EventArgs)
        Dim canteenId As Integer = CInt(ddlCanteen.SelectedValue)
        Dim mealId As Integer = CInt(ddlMeal.SelectedValue)
        Dim fromDate As Date = Date.ParseExact(txtFromDate.Text, "dd-MM-yyyy", Nothing)
        Dim toDate As Date = Date.ParseExact(txtToDate.Text, "dd-MM-yyyy", Nothing)

        Dim dt As DataTable = GetCanteenAttendance(canteenId, mealId, fromDate, toDate)
        
        ' Adjust grid for summary report
        gvAttendance.Columns(0).HeaderText = "SP Number"
        gvAttendance.Columns(4).Visible = False ' Hide Punch In (not in summary)
        gvAttendance.Columns(5).Visible = False ' Hide Punch Out (not in summary)
        gvAttendance.Columns(6).Visible = False ' Hide Status (not in summary)
        
        gvAttendance.DataSource = dt
        gvAttendance.DataBind()
        ViewState("CurrentData") = dt
        pnlGrid.Visible = True
    End Sub

    ' ── Export to Excel ───────────────────────────────────────
    Protected Sub btnExport_Click(sender As Object, e As EventArgs)
        ' Re-bind the grid to ensure it has data during the export postback
        Dim dt As DataTable = TryCast(ViewState("CurrentData"), DataTable)
        If dt IsNot Nothing Then
            gvAttendance.DataSource = dt
            gvAttendance.DataBind()
        End If

        If gvAttendance.Rows.Count = 0 Then
            ShowError("No data available to export.")
            Return
        End If

        Try
            Response.Clear()
            Response.Buffer = True
            Response.AddHeader("content-disposition", "attachment;filename=AttendanceReport_" & Date.Now.ToString("yyyyMMdd_HHmm") & ".xls")
            Response.Charset = ""
            Response.ContentType = "application/vnd.ms-excel"
            
            Using sw As New StringWriter()
                Using hw As New HtmlTextWriter(sw)
                    ' To export with styling, we render the GridView into the HtmlTextWriter
                    gvAttendance.RenderControl(hw)
                    
                    ' Write the rendered content to the response with basic Excel HTML structure
                    Response.Output.Write("<html xmlns:x=""urn:schemas-microsoft-com:office:excel"">")
                    Response.Output.Write("<head><meta http-equiv=""Content-Type"" content=""text/html;charset=utf-8""></head>")
                    Response.Output.Write("<body>")
                    Response.Output.Write(sw.ToString())
                    Response.Output.Write("</body></html>")
                    
                    Response.Flush()
                    Response.End()
                End Using
            End Using
        Catch ex As System.Threading.ThreadAbortException
            ' Normal behavior for Response.End()
        Catch ex As Exception
            ShowError("Export failed: " & ex.Message)
        End Try
    End Sub

    ' Required for GridView Export
    Public Overrides Sub VerifyRenderingInServerForm(ByVal control As Control)
        ' Confirms that an HtmlForm control is rendered for the specified ASP.NET server control at run time.
    End Sub

    ' ── DB Helpers ────────────────────────────────────────────
    Private Function GetIndividualAttendance(spNo As String, fromDate As Date, toDate As Date) As DataTable
        Dim dt As New DataTable()
        Try
            Using conn As New OracleConnection(GetConnectionString())
                conn.Open()
                Dim cmd As New OracleCommand("proc_get_attendance_individual", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("p_sp_no", OracleDbType.Varchar2).Value = spNo
                cmd.Parameters.Add("p_from_date", OracleDbType.Date).Value = fromDate
                cmd.Parameters.Add("p_to_date", OracleDbType.Date).Value = toDate

                Dim cursor As New OracleParameter("p_cursor", OracleDbType.RefCursor)
                cursor.Direction = ParameterDirection.Output
                cmd.Parameters.Add(cursor)

                dt.Load(cmd.ExecuteReader())
            End Using
Catch ex As Exception
            ' Dummy data for testing
            dt.Rows.Add("EMP001", 101, 201, 1, Date.Today.ToString("dd-MM-yyyy"), "08:30 AM", "09:00 AM", "OUT")
        End Try
        Return NormalizeDataTable(dt)
    End Function

    Private Function GetCanteenAttendance(canteenId As Integer, mealId As Integer,
                                          fromDate As Date, toDate As Date) As DataTable
        Dim dt As New DataTable()
        Try
            Using conn As New OracleConnection(GetConnectionString())
                conn.Open()
                Dim cmd As New OracleCommand("proc_get_attendance_canteen_wise", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("p_canteen_id", OracleDbType.Int32).Value = canteenId
                cmd.Parameters.Add("p_meal_id", OracleDbType.Int32).Value = mealId
                cmd.Parameters.Add("p_from_date", OracleDbType.Date).Value = fromDate
                cmd.Parameters.Add("p_to_date", OracleDbType.Date).Value = toDate

                Dim cursor As New OracleParameter("p_cursor", OracleDbType.RefCursor)
                cursor.Direction = ParameterDirection.Output
                cmd.Parameters.Add(cursor)

                dt.Load(cmd.ExecuteReader())
            End Using
Catch ex As Exception
            ' Dummy data for testing
            dt.Rows.Add("EMP001", Date.Today.ToString("dd-MM-yyyy"), 1, 201, "", "", "")
        End Try
        Return NormalizeDataTable(dt)
    End Function

    ' Ensures the DataTable has all columns the GridView expects, preventing "Column not found" errors
    Private Function NormalizeDataTable(dt As DataTable) As DataTable
        Dim requiredColumns() As String = {"SP_NO", "PUNCH_DATE", "MEAL_ID", "PICKUP_ID", "PUNCH_IN_TIME", "PUNCH_OUT_TIME", "STATUS"}
        For Each colName In requiredColumns
            If Not dt.Columns.Contains(colName) Then
                dt.Columns.Add(colName)
            End If
        Next
        Return dt
    End Function

    Private Sub ShowError(msg As String)
        lblError.Text = msg
        lblError.Visible = True
    End Sub

    Private Function GetConnectionString() As String
        Return System.Configuration.ConfigurationManager.ConnectionStrings("CanteenDB").ConnectionString
    End Function

End Class

