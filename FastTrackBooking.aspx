<%-- ============================================================
     FastTrackBooking.aspx  –  Fast Track Booking Page
     Project: Automation of Canteen Trolley Operation
     PPT Slide 11: If vendor has not punched-in and tries to do
     fast track booking → redirect to punch-in page.
     ============================================================ --%>
<%@ Page Language="VB" AutoEventWireup="true"
         CodeFile="FastTrackBooking.aspx.vb"
         Inherits="FastTrackBooking" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Fast Track Booking</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Segoe UI, Arial, sans-serif; background: #f0f2f5; }

        .navbar {
            background: #1565c0;
            color: #fff;
            padding: 14px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .navbar .brand { font-size: 17px; font-weight: bold; }
        .btn-back {
            background: transparent;
            color: #fff;
            border: 1px solid #fff;
            padding: 6px 14px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 13px;
        }
        .btn-back:hover { background: rgba(255,255,255,0.15); }

        .content { padding: 30px; max-width: 700px; margin: 0 auto; }
        h2 { color: #1a237e; margin-bottom: 20px; font-size: 20px; }

        /* Punch-in warning banner */
        .warn-banner {
            background: #fff3e0;
            border: 1px solid #fb8c00;
            border-radius: 8px;
            padding: 16px 20px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 14px;
        }
        .warn-banner .icon { font-size: 28px; }
        .warn-banner p { font-size: 14px; color: #e65100; margin-bottom: 8px; font-weight: 600; }
        .warn-banner span { font-size: 13px; color: #bf360c; }
        .btn-goto-punchin {
            display: inline-block;
            margin-top: 10px;
            padding: 8px 18px;
            background: #e65100;
            color: #fff;
            border: none;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
        }
        .btn-goto-punchin:hover { background: #bf360c; }

        /* Main booking form card */
        .card {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.09);
            padding: 26px 28px;
            margin-bottom: 20px;
        }
        .card h3 { font-size: 15px; color: #333; margin-bottom: 18px;
                   padding-bottom: 10px; border-bottom: 1px solid #eee; }

        .field { margin-bottom: 16px; }
        .field label { display: block; font-size: 13px; font-weight: 600;
                       color: #444; margin-bottom: 5px; }
        .field input, .field select {
            width: 100%; padding: 9px 12px;
            border: 1px solid #ccc; border-radius: 6px; font-size: 14px;
        }
        .field input:focus, .field select:focus {
            border-color: #1976d2; outline: none;
        }
        .field input[readonly] { background: #f5f5f5; color: #777; }

        .row2 { display: flex; gap: 16px; }
        .row2 .field { flex: 1; }

        .btn-submit {
            width: 100%; padding: 12px;
            background: #1565c0; color: #fff;
            border: none; border-radius: 7px;
            font-size: 15px; font-weight: 600; cursor: pointer;
            margin-top: 6px;
        }
        .btn-submit:hover { background: #0d47a1; }
        .btn-submit:disabled { background: #aaa; cursor: not-allowed; }

        .msg-success {
            background: #e8f5e9; border: 1px solid #66bb6a;
            color: #2e7d32; border-radius: 6px;
            padding: 10px 14px; font-size: 13px; font-weight: 600;
            margin-top: 14px;
        }
        .msg-error {
            background: #fdecea; border: 1px solid #f44336;
            color: #c62828; border-radius: 6px;
            padding: 10px 14px; font-size: 13px;
            margin-top: 14px;
        }

        /* Booking summary table */
        .summary-table { width: 100%; border-collapse: collapse; font-size: 13px; margin-top: 14px; }
        .summary-table th {
            background: #1565c0; color: #fff;
            padding: 9px 12px; text-align: left;
        }
        .summary-table td { padding: 9px 12px; border-bottom: 1px solid #eee; }
        .summary-table tr:hover td { background: #f5f9ff; }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <div class="navbar">
            <div class="brand">&#9889; Fast Track Booking</div>
            <asp:Button ID="btnBack" runat="server" Text="&#8592; Dashboard"
                        CssClass="btn-back" OnClick="btnBack_Click" />
        </div>

        <div class="content">
            <h2>Fast Track Meal Booking</h2>

            <%-- Punch-in warning — shown if vendor not punched in --%>
            <asp:Panel ID="pnlPunchInWarning" runat="server" Visible="false">
                <div class="warn-banner">
                    <div class="icon">&#9888;&#65039;</div>
                    <div>
                        <p>You are not punched-in for this meal!</p>
                        <span>You must punch-in before doing fast track booking.</span><br />
                        <asp:Button ID="btnGoToPunchIn" runat="server" Text="Go to Punch-In &#8594;"
                                    CssClass="btn-goto-punchin" OnClick="btnGoToPunchIn_Click" />
                    </div>
                </div>
            </asp:Panel>

            <%-- Meal mismatch warning --%>
            <asp:Panel ID="pnlMealMismatch" runat="server" Visible="false">
                <div class="warn-banner">
                    <div class="icon">&#9888;&#65039;</div>
                    <div>
                        <p>Meal mismatch detected!</p>
                        <asp:Label ID="lblMealMismatch" runat="server"
                            Text="You have not punched-in for this meal." />
                        <br />
                        <asp:Button ID="btnGoToPunchIn2" runat="server" Text="Go to Punch-In &#8594;"
                                    CssClass="btn-goto-punchin" OnClick="btnGoToPunchIn_Click" />
                    </div>
                </div>
            </asp:Panel>

            <%-- Main booking form --%>
            <asp:Panel ID="pnlBookingForm" runat="server">
                <div class="card">
                    <h3>Booking Details</h3>

                    <div class="row2">
                        <div class="field">
                            <label>Location</label>
                            <asp:TextBox ID="txtLocation" runat="server" ReadOnly="true" />
                        </div>
                        <div class="field">
                            <label>Canteen</label>
                            <asp:TextBox ID="txtCanteen" runat="server" ReadOnly="true" />
                        </div>
                    </div>

                    <div class="row2">
                        <div class="field">
                            <label>SP Number</label>
                            <asp:TextBox ID="txtSpNo" runat="server"
                                         placeholder="Enter SP Number" MaxLength="20" />
                        </div>
                        <div class="field">
                            <label>Meal Type</label>
                            <asp:DropDownList ID="ddlMeal" runat="server">
                                <asp:ListItem Value="1">Breakfast</asp:ListItem>
                                <asp:ListItem Value="2">Lunch</asp:ListItem>
                                <asp:ListItem Value="3">Snacks</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="row2">
                        <div class="field">
                            <label>Pickup Point</label>
                            <asp:DropDownList ID="ddlPickup" runat="server" />
                        </div>
                        <div class="field">
                            <label>Quantity</label>
                            <asp:TextBox ID="txtQuantity" runat="server"
                                         placeholder="Enter quantity" TextMode="Number" Text="1" />
                        </div>
                    </div>

                    <div class="field">
                        <label>Item / Menu</label>
                        <asp:DropDownList ID="ddlItem" runat="server" />
                    </div>

                    <asp:Label ID="lblMsg" runat="server" Visible="false" />

                    <asp:Button ID="btnBook" runat="server" Text="Book Now"
                                CssClass="btn-submit" OnClick="btnBook_Click" />
                </div>

                <%-- Today's bookings summary --%>
                <asp:Panel ID="pnlSummary" runat="server" Visible="false">
                    <div class="card">
                        <h3>Today's Fast Track Bookings</h3>
                        <asp:GridView ID="gvBookings" runat="server"
                                      AutoGenerateColumns="false"
                                      CssClass="summary-table"
                                      GridLines="None">
                            <Columns>
                                <asp:BoundField DataField="SP_NO"        HeaderText="SP No"       />
                                <asp:BoundField DataField="ITEM_NAME"    HeaderText="Item"         />
                                <asp:BoundField DataField="QUANTITY"     HeaderText="Qty"          />
                                <asp:BoundField DataField="PICKUP_NAME"  HeaderText="Pickup Point" />
                                <asp:BoundField DataField="MEAL_NAME"    HeaderText="Meal"         />
                                <asp:BoundField DataField="BOOKED_ON"    HeaderText="Booked At"
                                                DataFormatString="{0:HH:mm:ss}" />
                                <asp:BoundField DataField="STATUS"       HeaderText="Status"       />
                            </Columns>
                        </asp:GridView>
                    </div>
                </asp:Panel>

            </asp:Panel>
        </div>
    </form>
</body>
</html>
