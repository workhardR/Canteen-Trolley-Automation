<%@ Page Language="VB" AutoEventWireup="true" CodeFile="frmSmtMealBook.aspx.vb" Inherits="frmSmtMealBook" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Canteen System - Meal Booking</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(rgba(13, 71, 161, 0.45) 0%, rgba(25, 118, 210, 0.45) 60%, rgba(66, 165, 245, 0.45) 100%), url('images/tata_steel_morning.png') no-repeat center center fixed;
            background-size: cover;
            min-height: 100vh;
            color: #333;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0;
            padding: 0;
        }
        .container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            width: 500px;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.3);
        }
        .header {
            text-align: center;
            margin-bottom: 25px;
            border-bottom: 2px solid #1565c0;
            padding-bottom: 10px;
        }
        .header h2 { color: #1565c0; font-size: 24px; }
        .info-box {
            background: #e3f2fd;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .info-row { display: flex; justify-content: space-between; margin-bottom: 8px; }
        .info-label { font-weight: 600; color: #1565c0; }
        .field { margin-bottom: 20px; }
        .field label { display: block; font-weight: 600; margin-bottom: 8px; font-size: 14px; }
        .field input, .field select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        .btn {
            width: 100%;
            padding: 12px;
            background: #1565c0;
            color: #fff;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s;
        }
        .btn:hover { background: #0d47a1; }
        .msg-error {
            background: #fdecea;
            color: #c62828;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 15px;
            font-size: 14px;
            display: block;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="header">
                <h2>Meal Booking</h2>
            </div>

            <asp:Label ID="lblPunchMsg" runat="server" CssClass="msg-error" Visible="false" />

            <div class="info-box">
                <div class="info-row">
                    <span class="info-label">Vendor SP No:</span>
                    <asp:Literal ID="litSpNo" runat="server" />
                </div>
                <div class="info-row">
                    <span class="info-label">Current Meal:</span>
                    <asp:Literal ID="litMeal" runat="server" />
                </div>
            </div>

            <div class="field">
                <label>Number of Meals</label>
                <asp:TextBox ID="txtMealCount" runat="server" TextMode="Number" Text="1" min="1" max="100" />
            </div>

            <div class="field">
                <label>Remarks</label>
                <asp:TextBox ID="txtRemarks" runat="server" TextMode="MultiLine" Rows="2" placeholder="Optional notes..." />
            </div>

            <asp:Button ID="btnConfirmBooking" runat="server" Text="Confirm Booking" CssClass="btn" OnClick="btnConfirmBooking_Click" />
            
            <div style="text-align:center; margin-top:15px;">
                <asp:LinkButton ID="lnkBack" runat="server" PostBackUrl="~/CanteenMaster.aspx" style="font-size:13px; color:#777;">Cancel & Back to Home</asp:LinkButton>
            </div>
            
            <asp:Button ID="btnGoToPunchIn" runat="server" Text="Go to Punch-In" CssClass="btn" Visible="false" PostBackUrl="~/PunchIn.aspx" />
        </div>
    </form>
</body>
</html>
