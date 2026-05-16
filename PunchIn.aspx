<%-- ============================================================
     PunchIn.aspx  –  Vendor Punch-In Page
     Project: Automation of Canteen Trolley Operation
     Stack  : ASP.NET / VB.NET
     ============================================================ --%>
<%@ Page Language="VB" AutoEventWireup="true" CodeFile="PunchIn.aspx.vb" Inherits="PunchIn" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Vendor Punch-In</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f4f4; }
        .container { width: 420px; margin: 60px auto; background: #fff;
                     padding: 30px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,.15); }
        h2  { text-align: center; color: #333; }
        .field { margin-bottom: 14px; }
        label { display: block; font-weight: bold; margin-bottom: 4px; }
        input[type=text], asp-DropDownList, select {
            width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; }
        .btn  { width: 100%; padding: 10px; background: #0066cc; color: #fff;
                border: none; border-radius: 4px; font-size: 15px; cursor: pointer; }
        .btn:disabled { background: #aaa; }
        .msg-success { color: green; font-weight: bold; margin-top: 10px; }
        .msg-error   { color: red;   font-weight: bold; margin-top: 10px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h2>Vendor Punch-In</h2>

            <%-- Location & Canteen auto-filled from session (fixed per user) --%>
            <div class="field">
                <label>Location</label>
                <asp:TextBox ID="txtLocation" runat="server" ReadOnly="true" CssClass="readonly-field" />
            </div>
            <div class="field">
                <label>Canteen</label>
                <asp:TextBox ID="txtCanteen" runat="server" ReadOnly="true" CssClass="readonly-field" />
            </div>

            <%-- Vendor enters SP Number --%>
            <div class="field">
                <label>SP Number</label>
                <asp:TextBox ID="txtSpNo" runat="server" placeholder="Enter SP Number" MaxLength="20" />
            </div>

            <%-- Pickup Point --%>
            <div class="field">
                <label>Pickup Point</label>
                <asp:DropDownList ID="ddlPickup" runat="server" />
            </div>

            <%-- Meal Type --%>
            <div class="field">
                <label>Meal Type</label>
                <asp:DropDownList ID="ddlMeal" runat="server">
                    <asp:ListItem Value="1">Breakfast</asp:ListItem>
                    <asp:ListItem Value="2">Lunch</asp:ListItem>
                    <asp:ListItem Value="3">Snacks</asp:ListItem>
                </asp:DropDownList>
            </div>

            <%-- Punch-In Button --%>
            <asp:Button ID="btnPunchIn" runat="server" Text="Punch In"
                        CssClass="btn" OnClick="btnPunchIn_Click" />

            <%-- Status message --%>
            <asp:Label ID="labelMsg" runat="server" CssClass="msg-success" />

            <%-- Next button (hidden until punch-in succeeds) --%>
            <asp:Button ID="btnNext" runat="server" Text="Next >>"
                        CssClass="btn" Enabled="false" Visible="false"
                        OnClick="btnNext_Click" Style="margin-top:10px;" />
        </div>
    </form>
</body>
</html>

