<%-- ============================================================
     PunchOut.aspx  –  Vendor Punch-Out Page
     Project: Automation of Canteen Trolley Operation
     ============================================================ --%>
<%@ Page Language="VB" AutoEventWireup="true" CodeFile="PunchOut.aspx.vb" Inherits="PunchOut" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Vendor Punch-Out</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f4f4; }
        .container { width: 420px; margin: 60px auto; background: #fff;
                     padding: 30px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,.15); }
        h2  { text-align: center; color: #333; }
        .field { margin-bottom: 14px; }
        label { display: block; font-weight: bold; margin-bottom: 4px; }
        .btn  { width: 100%; padding: 10px; background: #cc3300; color: #fff;
                border: none; border-radius: 4px; font-size: 15px; cursor: pointer; }
        .btn-logout { background: #555; margin-top: 10px; }
        .msg-success { color: green; font-weight: bold; }
        .msg-error   { color: red;   font-weight: bold; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h2>Vendor Punch-Out</h2>

            <div class="field">
                <label>Location</label>
                <asp:TextBox ID="txtLocation" runat="server" ReadOnly="true" />
            </div>
            <div class="field">
                <label>Canteen</label>
                <asp:TextBox ID="txtCanteen" runat="server" ReadOnly="true" />
            </div>
            <div class="field">
                <label>SP Number</label>
                <asp:TextBox ID="txtSpNo" runat="server" placeholder="Enter SP Number" MaxLength="20" />
            </div>
            <div class="field">
                <label>Pickup Point</label>
                <asp:DropDownList ID="ddlPickup" runat="server" />
            </div>
            <div class="field">
                <label>Meal Type</label>
                <asp:DropDownList ID="ddlMeal" runat="server">
                    <asp:ListItem Value="1">Breakfast</asp:ListItem>
                    <asp:ListItem Value="2">Lunch</asp:ListItem>
                    <asp:ListItem Value="3">Snacks</asp:ListItem>
                </asp:DropDownList>
            </div>

            <asp:Button ID="btnPunchOut" runat="server" Text="Punch Out"
                        CssClass="btn" OnClick="btnPunchOut_Click" />

            <asp:Label ID="labelMsg" runat="server" CssClass="msg-success" />

            <asp:Button ID="btnLogout" runat="server" Text="Log Out"
                        CssClass="btn btn-logout" Visible="false" Enabled="false"
                        OnClick="btnLogout_Click" />
        </div>
    </form>
</body>
</html>

