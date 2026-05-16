Imports System.Data
Imports Oracle.ManagedDataAccess.Client

Partial Class frmSmtMealBook
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' 1. Check if user is logged in
            If Session("UserId") Is Nothing Then
                Response.Redirect("~/Login.aspx")
                Return
            End If

            ' 2. Check if Punch-In context exists
            If Session("CurrentSpNo") Is Nothing OrElse Session("CurrentMealId") Is Nothing Then
                Response.Redirect("~/PunchIn.aspx")
                Return
            End If

            Dim spNo As String = Session("CurrentSpNo").ToString()
            Dim mealId As Integer = CInt(Session("CurrentMealId"))

            ' 3. Security Guard: Ensure the vendor is actually punched in for this meal
            ' This prevents users from bypassing the Punch-In page by typing the URL manually
            PunchInGuard.EnsurePunchedIn(Me, spNo, mealId, lblPunchMsg, New System.Web.UI.WebControls.TextBox(), btnGoToPunchIn)

            ' 4. Fill UI labels
            litSpNo.Text = spNo
            litMeal.Text = GetMealName(mealId)
        End If
    End Sub

    Protected Sub btnConfirmBooking_Click(sender As Object, e As EventArgs)
        ' Logic to save meal booking to database would go here
        ' For now, we show a success message and go back to master
        Response.Write("<script>alert('Meal Booking Confirmed!'); window.location='CanteenMaster.aspx';</script>")
    End Sub

    Private Function GetMealName(id As Integer) As String
        Select Case id
            Case 1 : Return "Breakfast"
            Case 2 : Return "Lunch"
            Case 3 : Return "Snacks"
            Case Else : Return "Other"
        End Select
    End Function

    Private Function GetConnectionString() As String
        Return System.Configuration.ConfigurationManager.ConnectionStrings("CanteenDB").ConnectionString
    End Function

End Class
