<%-- ============================================================
     CanteenMaster.aspx  –  Dashboard / Home Page
     Project: Automation of Canteen Trolley Operation
     ============================================================ --%>
<%@ Page Language="VB" AutoEventWireup="true" CodeFile="CanteenMaster.aspx.vb" Inherits="CanteenMaster" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Canteen Dashboard</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: Segoe UI, Arial, sans-serif;
            background: linear-gradient(rgba(13, 71, 161, 0.45) 0%, rgba(25, 118, 210, 0.45) 60%, rgba(66, 165, 245, 0.45) 100%), url('images/tata_steel_morning.png') no-repeat center center fixed;
            background-size: cover;
            min-height: 100vh;
        }

        /* ── Top Nav ── */
        .navbar {
            background: #1565c0;
            color: #fff;
            padding: 14px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .navbar .brand { font-size: 18px; font-weight: bold; letter-spacing: 1px; }
        .navbar .user-info { font-size: 13px; }
        .btn-logout {
            background: #c62828;
            color: #fff;
            border: none;
            padding: 7px 16px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 13px;
            margin-left: 16px;
        }
        .btn-logout:hover { background: #b71c1c; }

        /* ── Welcome Banner ── */
        .welcome {
            background: #1976d2;
            color: #fff;
            padding: 20px 30px;
            font-size: 15px;
        }
        .welcome span { font-weight: bold; font-size: 17px; }

        /* ── Dashboard Cards ── */
        .dashboard {
            display: flex;
            gap: 24px;
            padding: 36px 30px;
            flex-wrap: wrap;
        }
        .card {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
            padding: 30px 28px;
            width: 220px;
            text-align: center;
            cursor: pointer;
            transition: transform .15s, box-shadow .15s;
        }
        .card:hover { transform: translateY(-4px); box-shadow: 0 6px 18px rgba(0,0,0,0.15); }
        .card .icon {
            font-size: 42px;
            margin-bottom: 14px;
        }
        .card h3 { font-size: 15px; color: #333; margin-bottom: 8px; }
        .card p  { font-size: 12px; color: #888; }
        .card-punchin    .icon { color: #2e7d32; }
        .card-punchout   .icon { color: #c62828; }
        .card-report     .icon { color: #1565c0; }
        .card-fasttrack  .icon { color: #ff6f00; }
        .card-delivery   .icon { color: #6a1b9a; }

        .card-btn {
            margin-top: 16px;
            width: 100%;
            padding: 9px;
            border: none;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            color: #fff;
        }
        .card-punchin    .card-btn { background: #2e7d32; }
        .card-punchout   .card-btn { background: #c62828; }
        .card-report     .card-btn { background: #1565c0; }
        .card-fasttrack  .card-btn { background: #ff6f00; }
        .card-delivery   .card-btn { background: #6a1b9a; }

        /* ── Footer ── */
        .footer {
            text-align: center;
            padding: 18px;
            font-size: 12px;
            color: #aaa;
            border-top: 1px solid #e0e0e0;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <%-- Top Navigation Bar --%>
        <div class="navbar">
            <div class="brand">&#127869; Canteen Management System</div>
            <div class="user-info">
                Welcome, <strong><asp:Literal ID="litUserName" runat="server" /></strong>
                &nbsp;|&nbsp; Role: <asp:Literal ID="litRole" runat="server" />
                <asp:Button ID="btnLogout" runat="server" Text="Logout"
                            CssClass="btn-logout" OnClick="btnLogout_Click" />
            </div>
        </div>

        <%-- Welcome Banner --%>
        <div class="welcome">
            <span>Dashboard</span> &nbsp;&#8212;&nbsp;
            <asp:Literal ID="litLocation" runat="server" /> &nbsp;|&nbsp;
            <asp:Literal ID="litCanteen" runat="server" />
        </div>

        <%-- Dashboard Action Cards --%>
        <div class="dashboard">

            <%-- Punch-In Card --%>
            <asp:Panel ID="pnlPunchIn" runat="server" CssClass="card card-punchin">
                <div class="icon">&#9989;</div>
                <h3>Punch In</h3>
                <p>Record vendor arrival at trolley point</p>
                <asp:Button ID="btnGoToPunchIn" runat="server" Text="Go to Punch In"
                            CssClass="card-btn" OnClick="btnGoToPunchIn_Click" />
            </asp:Panel>

            <%-- Punch-Out Card --%>
            <asp:Panel ID="pnlPunchOut" runat="server" CssClass="card card-punchout">
                <div class="icon">&#128682;</div>
                <h3>Punch Out</h3>
                <p>Record vendor departure from trolley point</p>
                <asp:Button ID="btnGoToPunchOut" runat="server" Text="Go to Punch Out"
                            CssClass="card-btn" OnClick="btnGoToPunchOut_Click" />
            </asp:Panel>

            <%-- Attendance Report Card (role-based visibility) --%>
            <asp:Panel ID="pnlAttendance" runat="server" CssClass="card card-report">
                <div class="icon">&#128202;</div>
                <h3>Attendance Report</h3>
                <p>View individual or canteen-wise attendance</p>
                <asp:Button ID="btnAttendanceReport" runat="server" Text="View Report"
                            CssClass="card-btn" OnClick="btnAttendanceReport_Click" />
            </asp:Panel>

            <%-- Fast Track Booking Card --%>
            <asp:Panel ID="pnlFastTrack" runat="server" CssClass="card card-fasttrack">
                <div class="icon">&#9889;</div>
                <h3>Fast Track Booking</h3>
                <p>Quick booking for urgent / priority meal requests</p>
                <asp:Button ID="btnGoToFastTrack" runat="server" Text="Fast Track"
                            CssClass="card-btn" OnClick="btnGoToFastTrack_Click" />
            </asp:Panel>

            <%-- Meal Delivery Card --%>
            <asp:Panel ID="pnlMealDelivery" runat="server" CssClass="card card-delivery">
                <div class="icon">&#128666;</div>
                <h3>Meal Delivery</h3>
                <p>Track and confirm meal delivery at trolley points</p>
                <asp:Button ID="btnGoToMealDelivery" runat="server" Text="Track Delivery"
                            CssClass="card-btn" OnClick="btnGoToMealDelivery_Click" />
            </asp:Panel>

        </div>

        <div class="footer">&#169; ITS Department &#8212; Internal Use Only</div>

    </form>
</body>
</html>