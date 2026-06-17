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
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            padding: 30px 28px;
            width: 220px;
            text-align: center;
            cursor: pointer;
            transition: transform 0.3s cubic-bezier(0.25, 0.8, 0.25, 1), 
                        box-shadow 0.3s cubic-bezier(0.25, 0.8, 0.25, 1), 
                        border-color 0.3s ease;
            position: relative;
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .card:hover {
            transform: translateY(-6px);
        }
        .card-punchin:hover { 
            box-shadow: 0 12px 24px rgba(46, 125, 50, 0.25);
            border-color: rgba(46, 125, 50, 0.3);
        }
        .card-punchout:hover { 
            box-shadow: 0 12px 24px rgba(198, 40, 40, 0.25);
            border-color: rgba(198, 40, 40, 0.3);
        }
        .card-report:hover { 
            box-shadow: 0 12px 24px rgba(21, 101, 192, 0.25);
            border-color: rgba(21, 101, 192, 0.3);
        }
        .card-fasttrack:hover { 
            box-shadow: 0 12px 24px rgba(255, 111, 0, 0.25);
            border-color: rgba(255, 111, 0, 0.3);
        }
        .card-delivery:hover { 
            box-shadow: 0 12px 24px rgba(106, 27, 154, 0.25);
            border-color: rgba(106, 27, 154, 0.3);
        }
        
        /* Dynamic Press/Click State */
        .card:active {
            transform: scale(0.97) translateY(-2px);
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        .card .icon {
            font-size: 42px;
            margin-bottom: 14px;
            display: inline-block;
            transition: transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        .card h3 { font-size: 15px; color: #333; margin-bottom: 8px; }
        .card p  { font-size: 12px; color: #888; }
        .card-punchin    .icon { color: #2e7d32; }
        .card-punchout   .icon { color: #c62828; }
        .card-report     .icon { color: #1565c0; }
        .card-fasttrack  .icon { color: #ff6f00; }
        .card-delivery   .icon { color: #6a1b9a; }

        /* Icon Micro-animations on Card Hover */
        @keyframes popBounce {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.2) translateY(-6px); }
        }
        .card-punchin:hover .icon { animation: popBounce 0.6s ease-out; }

        @keyframes doorSwing {
            0%, 100% { transform: rotateY(0deg); }
            50% { transform: rotateY(-35deg) scale(1.1); }
        }
        .card-punchout:hover .icon { 
            animation: doorSwing 0.8s ease-in-out; 
            transform-origin: left center;
        }

        @keyframes barGrow {
            0%, 100% { transform: scaleY(1) scaleX(1); }
            50% { transform: scaleY(1.25) scaleX(1.05) translateY(-2px); }
        }
        .card-report:hover .icon { animation: barGrow 0.6s ease-in-out; }

        @keyframes lightningPulse {
            0%, 100% { transform: scale(1); filter: drop-shadow(0 0 0 transparent); }
            50% { transform: scale(1.3) rotate(-10deg); filter: drop-shadow(0 0 10px rgba(255, 111, 0, 0.6)); }
        }
        .card-fasttrack:hover .icon { animation: lightningPulse 0.5s ease-in-out; }

        @keyframes truckDrive {
            0%, 100% { transform: translateX(0); }
            40% { transform: translateX(6px) skewX(-10deg); }
            80% { transform: translateX(-2px); }
        }
        .card-delivery:hover .icon { animation: truckDrive 0.7s ease-in-out; }

        /* Buttons styles & transitions */
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
            position: relative;
            overflow: hidden;
            transition: transform 0.2s cubic-bezier(0.25, 0.8, 0.25, 1), 
                        filter 0.2s ease, 
                        box-shadow 0.2s ease;
        }
        .card-btn:hover {
            filter: brightness(1.1);
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.15);
        }
        .card-btn:active, .card-btn.active-simulate {
            transform: scale(0.95);
            filter: brightness(0.9);
        }
        
        .card-punchin    .card-btn { background: #2e7d32; }
        .card-punchout   .card-btn { background: #c62828; }
        .card-report     .card-btn { background: #1565c0; }
        .card-fasttrack  .card-btn { background: #ff6f00; }
        .card-delivery   .card-btn { background: #6a1b9a; }

        /* Ripple Effect Styles */
        span.ripple {
            position: absolute;
            border-radius: 50%;
            transform: scale(0);
            animation: ripple-animation 600ms linear;
            background-color: rgba(255, 255, 255, 0.35);
            pointer-events: none;
        }
        .card span.ripple {
            background-color: rgba(0, 0, 0, 0.08);
        }
        @keyframes ripple-animation {
            to {
                transform: scale(4);
                opacity: 0;
            }
        }

        /* Top Progress Bar Loader for Postbacks */
        .page-loader {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background-color: rgba(255, 255, 255, 0.2);
            z-index: 9999;
            overflow: hidden;
            display: none;
        }
        .page-loader-bar {
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, #ff6f00, #ffeb3b, #4caf50, #00cbd6, #ff6f00);
            background-size: 200% 100%;
            animation: loading-bar-run 1.5s infinite linear;
            transform: translateX(-100%);
            transition: transform 0.4s ease;
        }
        @keyframes loading-bar-run {
            0% { background-position: 0% 50%; }
            100% { background-position: 200% 50%; }
        }
        .page-loader.active {
            display: block;
        }
        .page-loader.active .page-loader-bar {
            transform: translateX(0);
        }

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
        <div id="pageLoader" class="page-loader">
            <div class="page-loader-bar"></div>
        </div>

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

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const cards = document.querySelectorAll('.card');
                const loader = document.getElementById('pageLoader');

                // Ripple Effect Function
                function addRipple(e, element, isDark = false) {
                    const circle = document.createElement("span");
                    const diameter = Math.max(element.clientWidth, element.clientHeight);
                    const radius = diameter / 2;

                    circle.style.width = circle.style.height = `${diameter}px`;
                    circle.style.left = `${e.clientX - element.getBoundingClientRect().left - radius}px`;
                    circle.style.top = `${e.clientY - element.getBoundingClientRect().top - radius}px`;
                    circle.classList.add("ripple");

                    if (isDark) {
                        circle.style.backgroundColor = 'rgba(0, 0, 0, 0.08)';
                    } else {
                        circle.style.backgroundColor = 'rgba(255, 255, 255, 0.35)';
                    }

                    const oldRipple = element.querySelector('.ripple');
                    if (oldRipple) {
                        oldRipple.remove();
                    }

                    element.appendChild(circle);
                }

                // Attach click and ripple handlers to cards
                cards.forEach(card => {
                    card.addEventListener('click', function (e) {
                        addRipple(e, this, true);

                        // If user clicked the button directly, let the button handle it
                        if (e.target.closest('.card-btn')) return;

                        // Else, simulate button click inside the card
                        const btn = this.querySelector('.card-btn');
                        if (btn) {
                            btn.classList.add('active-simulate');
                            setTimeout(() => {
                                btn.click();
                            }, 150);
                        }
                    });
                });

                // Attach ripple to buttons directly
                const buttons = document.querySelectorAll('.card-btn, .btn-logout');
                buttons.forEach(btn => {
                    btn.addEventListener('click', function (e) {
                        addRipple(e, this, false);
                    });
                });

                // Intercept form submits / clicks to show top progress loader
                const form = document.getElementById('form1');
                if (form) {
                    form.addEventListener('submit', function () {
                        if (loader) {
                            loader.classList.add('active');
                        }
                    });
                }
                
                // Intercept ASP.NET postbacks specifically
                const originalPostBack = window.__doPostBack;
                if (typeof originalPostBack === 'function') {
                    window.__doPostBack = function (eventTarget, eventArgument) {
                        if (loader) {
                            loader.classList.add('active');
                        }
                        originalPostBack(eventTarget, eventArgument);
                    };
                }
            });
        </script>
    </form>
</body>
</html>