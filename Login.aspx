<%-- ============================================================
     Login.aspx  –  Canteen System Login Page
     Project: Automation of Canteen Trolley Operation
     Stack  : ASP.NET / VB.NET
     ============================================================ --%>
<%@ Page Language="VB" AutoEventWireup="true" CodeFile="Login.aspx.vb" Inherits="Login" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Canteen System - Login</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: Segoe UI, Arial, sans-serif;
            background: linear-gradient(rgba(13, 71, 161, 0.45) 0%, rgba(25, 118, 210, 0.45) 60%, rgba(66, 165, 245, 0.45) 100%), url('images/tata_steel_morning.png') no-repeat center center fixed;
            background-size: cover;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .card {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            width: 400px;
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.3);
            padding: 40px 36px 28px;
        }
        .logo {
            text-align: center;
            margin-bottom: 24px;
        }
        .logo-box {
            display: inline-block;
            background: #1565c0;
            color: #fff;
            font-size: 20px;
            font-weight: bold;
            border-radius: 8px;
            padding: 8px 20px;
            letter-spacing: 2px;
            margin-bottom: 10px;
        }
        .logo h2 { font-size: 19px; color: #1a237e; margin-bottom: 4px; }
        .logo p  { font-size: 13px; color: #777; }
        .field { margin-bottom: 16px; }
        .field label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }
        .field input {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }
        .field input:focus { border-color: #1976d2; outline: none; }
        .btn-login {
            width: 100%;
            padding: 12px;
            background: #1565c0;
            color: #fff;
            border: none;
            border-radius: 7px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 6px;
        }
        .btn-login:hover { background: #0d47a1; }
        .msg-error {
            background: #fdecea;
            border: 1px solid #f44336;
            color: #c62828;
            border-radius: 6px;
            padding: 10px 12px;
            font-size: 13px;
            margin-bottom: 14px;
            display: block;
        }
        .msg-success {
            background: #e8f5e9;
            border: 1px solid #4caf50;
            color: #2e7d32;
            border-radius: 6px;
            padding: 10px 12px;
            font-size: 13px;
            margin-bottom: 14px;
            display: block;
        }
        .toggle-link {
            text-align: center;
            margin-top: 20px;
            font-size: 13px;
            color: #555;
        }
        .toggle-link a {
            color: #1565c0;
            text-decoration: none;
            font-weight: 600;
        }
        .toggle-link a:hover {
            text-decoration: underline;
        }
        .dropdown {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
            background: #fff;
        }
        .footer {
            text-align: center;
            margin-top: 20px;
            font-size: 11px;
            color: #aaa;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="card">
            <div class="logo">
                <div class="logo-box">CANTEEN</div>
                <h2>Canteen Management System</h2>
                <p id="pSubTitle"><%= If(pnlRegister.Visible, "Create your account", "Sign in to your account") %></p>
            </div>

            <asp:Label ID="lblError" runat="server" CssClass="msg-error" Visible="false" />
            <asp:Label ID="lblSuccess" runat="server" CssClass="msg-success" Visible="false" />

            <!-- LOGIN PANEL -->
            <asp:Panel ID="pnlLogin" runat="server">
                <div class="field">
                    <label>User ID</label>
                    <asp:TextBox ID="txtUserId" runat="server" placeholder="Enter User ID" MaxLength="50" />
                </div>
                <div class="field">
                    <label>Password</label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"
                                 placeholder="Enter Password" MaxLength="50" />
                </div>
                <asp:Button ID="btnLogin" runat="server" Text="Sign In"
                            CssClass="btn-login" OnClick="btnLogin_Click" />
                
                <div class="toggle-link">
                    Don't have an account? <asp:LinkButton ID="lnkShowRegister" runat="server" OnClick="ToggleView_Click">Register Now</asp:LinkButton>
                </div>
            </asp:Panel>

            <!-- REGISTER PANEL -->
            <asp:Panel ID="pnlRegister" runat="server" Visible="false">
                <div class="field">
                    <label>User ID (Unique)</label>
                    <asp:TextBox ID="txtRegUserId" runat="server" placeholder="Choose a User ID" MaxLength="20" />
                </div>
                <div class="field">
                    <label>Full Name</label>
                    <asp:TextBox ID="txtRegUserName" runat="server" placeholder="Enter Your Name" MaxLength="100" />
                </div>
                <div class="field">
                    <label>Password</label>
                    <asp:TextBox ID="txtRegPassword" runat="server" TextMode="Password"
                                 placeholder="Create Password" MaxLength="50" />
                </div>
                <div class="field">
                    <label>Work Location</label>
                    <asp:DropDownList ID="ddlRegLocation" runat="server" CssClass="dropdown" AutoPostBack="true" OnSelectedIndexChanged="ddlRegLocation_SelectedIndexChanged" />
                </div>
                <div class="field">
                    <label>Primary Canteen</label>
                    <asp:DropDownList ID="ddlRegCanteen" runat="server" CssClass="dropdown" />
                </div>

                <asp:Button ID="btnRegister" runat="server" Text="Create Account"
                            CssClass="btn-login" OnClick="btnRegister_Click" style="background: #2e7d32;" />
                
                <div class="toggle-link">
                    Already registered? <asp:LinkButton ID="lnkShowLogin" runat="server" OnClick="ToggleView_Click">Sign In</asp:LinkButton>
                </div>
            </asp:Panel>

            <p class="footer">© ITS Department — Internal Use Only</p>
        </div>
    </form>
</body>
</html>

