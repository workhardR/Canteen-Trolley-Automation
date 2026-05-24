' ============================================================
' Login.aspx.vb  –  Code-behind for Login Page
' Project: Automation of Canteen Trolley Operation
' ============================================================
 
Imports System.Data
Imports Oracle.ManagedDataAccess.Client
 
Partial Class Login
    Inherits System.Web.UI.Page
 
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        ' If already logged in, skip login page
        If Session("UserId") IsNot Nothing Then
            Response.Redirect("~/CanteenMaster.aspx")
        End If
    End Sub
 
    Protected Sub btnLogin_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim userId   As String = txtUserId.Text.Trim()
        Dim password As String = txtPassword.Text.Trim()
 
        If String.IsNullOrEmpty(userId) OrElse String.IsNullOrEmpty(password) Then
            ShowError("Please enter User ID and Password.")
            Return
        End If
 
        Dim userRow As DataRow = ValidateUser(userId, password)
 
        If userRow IsNot Nothing Then
            ' Store user info in session
            Session("UserId")       = userRow("USER_ID").ToString()
            Session("UserName")     = userRow("USER_NAME").ToString()
            Session("UserRole")     = userRow("ROLE").ToString()
            Session("LocationId")   = userRow("LOCATION_ID").ToString()
            Session("LocationName") = userRow("LOCATION_NAME").ToString()
            Session("CanteenId")    = userRow("CANTEEN_ID").ToString()
            Session("CanteenName")  = userRow("CANTEEN_NAME").ToString()
 
            ' Redirect to Punch-In page (as per requirement: login → punch-in)
            Response.Redirect("~/PunchIn.aspx")
        Else
            ShowError("Invalid User ID or Password. Please try again.")
        End If
    End Sub
 
    Private Function ValidateUser(userId As String, password As String) As DataRow
' FOR TESTING: Allow admin/admin bypass
        ' FOR TESTING: Allow admin/admin bypass
        If userId = "admin" AndAlso password = "admin" Then
            Dim dtTest As New DataTable()
            dtTest.Columns.Add("USER_ID")
            dtTest.Columns.Add("USER_NAME")
            dtTest.Columns.Add("ROLE")
            dtTest.Columns.Add("LOCATION_ID")
            dtTest.Columns.Add("LOCATION_NAME")
            dtTest.Columns.Add("CANTEEN_ID")
            dtTest.Columns.Add("CANTEEN_NAME")
 
            Dim row As DataRow = dtTest.NewRow()
            row("USER_ID") = "admin"
            row("USER_NAME") = "Administrator"
            row("ROLE") = "admin"
            row("LOCATION_ID") = "1"
            row("LOCATION_NAME") = "Main Office"
            row("CANTEEN_ID") = "101"
            row("CANTEEN_NAME") = "Central Canteen"
            dtTest.Rows.Add(row)
            Return row
        End If
 
        Try
            Using conn As New OracleConnection(GetConnectionString())
                conn.Open()
                ' NOTE: In production use bcrypt/hashed passwords.
                ' This query assumes plain-text for simplicity; replace with hash check.
                Dim cmd As New OracleCommand(
                    "SELECT u.user_id, u.user_name, u.role, u.location_id, u.canteen_id, " &
                    "       l.location_name, c.canteen_name " &
                    "  FROM t_Canteen_Users  u " &
                    "  JOIN t_Canteen_Location l ON l.location_id = u.location_id " &
                    "  JOIN t_Canteen_Master   c ON c.canteen_id  = u.canteen_id " &
                    " WHERE u.user_id  = :p_user_id " &
                    "   AND u.password = :p_password " &
                    "   AND u.is_active = 'Y'",
                    conn)
                cmd.BindByName = True
                cmd.Parameters.Add("p_user_id", OracleDbType.Varchar2).Value = userId
                cmd.Parameters.Add("p_password", OracleDbType.Varchar2).Value = password
 
                Dim dt As New DataTable()
                dt.Load(cmd.ExecuteReader())
 
                If dt.Rows.Count > 0 Then
                    Return dt.Rows(0)
                End If
                Return Nothing
            End Using
        Catch ex As Exception
            ' If DB fails, return nothing (or log error)
            Return Nothing
        End Try
    End Function
 
    ' ── Toggle between Login and Register views ──────────────────
    Protected Sub ToggleView_Click(ByVal sender As Object, ByVal e As EventArgs)
        pnlLogin.Visible = Not pnlLogin.Visible
        pnlRegister.Visible = Not pnlRegister.Visible
        lblError.Visible = False
        lblSuccess.Visible = False
        
        If pnlRegister.Visible Then
            LoadLocations()
        End If
    End Sub

    ' ── Handle User Registration ──────────────────────────────────
    Protected Sub btnRegister_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim regId   As String = txtRegUserId.Text.Trim()
        Dim regName As String = txtRegUserName.Text.Trim()
        Dim regPwd  As String = txtRegPassword.Text.Trim()
        Dim locId   As String = ddlRegLocation.SelectedValue
        Dim cantId  As String = ddlRegCanteen.SelectedValue

        If String.IsNullOrEmpty(regId) OrElse String.IsNullOrEmpty(regName) OrElse String.IsNullOrEmpty(regPwd) Then
            ShowError("Please fill in all fields.")
            Return
        End If

        Try
            Using conn As New OracleConnection(GetConnectionString())
                conn.Open()
                
                ' Check if User ID already exists
                Dim checkCmd As New OracleCommand("SELECT COUNT(*) FROM t_Canteen_Users WHERE user_id = :p_user_id", conn)
                checkCmd.BindByName = True
                checkCmd.Parameters.Add("p_user_id", OracleDbType.Varchar2).Value = regId
                If CInt(checkCmd.ExecuteScalar()) > 0 Then
                    ShowError("User ID already exists. Please choose another.")
                    Return
                End If

                ' Insert New User
                Dim insertCmd As New OracleCommand(
                    "INSERT INTO t_Canteen_Users (user_id, user_name, password, role, location_id, canteen_id, is_active) " &
                    "VALUES (:p_user_id, :p_user_name, :p_password, 'staff', :p_location_id, :p_canteen_id, 'Y')", conn)
                insertCmd.BindByName = True
                
                insertCmd.Parameters.Add("p_user_id", OracleDbType.Varchar2).Value = regId
                insertCmd.Parameters.Add("p_user_name", OracleDbType.Varchar2).Value = regName
                insertCmd.Parameters.Add("p_password", OracleDbType.Varchar2).Value = regPwd
                insertCmd.Parameters.Add("p_location_id", OracleDbType.Int32).Value = CInt(locId)
                insertCmd.Parameters.Add("p_canteen_id", OracleDbType.Int32).Value = CInt(cantId)

                insertCmd.ExecuteNonQuery()
                
                ' Clear fields and show success
                txtRegUserId.Text = ""
                txtRegUserName.Text = ""
                txtRegPassword.Text = ""
                
                lblSuccess.Text = "Registration successful! You can now sign in."
                lblSuccess.Visible = True
                pnlRegister.Visible = False
                pnlLogin.Visible = True
            End Using
        Catch ex As Exception
            ShowError("Database error: " & ex.Message)
        End Try
    End Sub

    ' ── Dropdown Loading Logic ────────────────────────────────────
    Private Sub LoadLocations()
        Try
            Using conn As New OracleConnection(GetConnectionString())
                conn.Open()
                Dim cmd As New OracleCommand("SELECT location_id, location_name FROM t_Canteen_Location ORDER BY location_name", conn)
                Dim dt As New DataTable()
                dt.Load(cmd.ExecuteReader())
                
                ddlRegLocation.DataSource = dt
                ddlRegLocation.DataTextField = "LOCATION_NAME"
                ddlRegLocation.DataValueField = "LOCATION_ID"
                ddlRegLocation.DataBind()
                
                ' Initial load of canteens for the first location
                If ddlRegLocation.Items.Count > 0 Then
                    LoadCanteens(CInt(ddlRegLocation.SelectedValue))
                End If
            End Using
        Catch ex As Exception
            ' Dummy data for testing if DB fails
            ddlRegLocation.Items.Clear()
            ddlRegLocation.Items.Add(New ListItem("Main Office", "1"))
            LoadCanteens(1)
        End Try
    End Sub

    Protected Sub ddlRegLocation_SelectedIndexChanged(sender As Object, e As EventArgs)
        LoadCanteens(CInt(ddlRegLocation.SelectedValue))
    End Sub

    Private Sub LoadCanteens(locationId As Integer)
        Try
            Using conn As New OracleConnection(GetConnectionString())
                conn.Open()
                Dim cmd As New OracleCommand("SELECT canteen_id, canteen_name FROM t_Canteen_Master WHERE location_id = :loc ORDER BY canteen_name", conn)
                cmd.Parameters.Add("loc", OracleDbType.Int32).Value = locationId
                
                Dim dt As New DataTable()
                dt.Load(cmd.ExecuteReader())
                
                ddlRegCanteen.DataSource = dt
                ddlRegCanteen.DataTextField = "CANTEEN_NAME"
                ddlRegCanteen.DataValueField = "CANTEEN_ID"
                ddlRegCanteen.DataBind()
            End Using
        Catch ex As Exception
            ' Dummy data for testing
            ddlRegCanteen.Items.Clear()
            ddlRegCanteen.Items.Add(New ListItem("Central Canteen", "101"))
        End Try
    End Sub

    Private Sub ShowError(msg As String)
        lblSuccess.Visible = False
        lblError.Text    = msg
        lblError.Visible = True
    End Sub

    Private Function GetConnectionString() As String
        Return System.Configuration.ConfigurationManager _
                   .ConnectionStrings("CanteenDB").ConnectionString
    End Function
 
End Class