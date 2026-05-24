<%-- ============================================================
     MealDelivery.aspx  –  Meal Delivery Tracking Page
     Project: Automation of Canteen Trolley Operation
     Stack  : ASP.NET / VB.NET
     ============================================================ --%>
<%@ Page Language="VB" AutoEventWireup="true" CodeFile="MealDelivery.aspx.vb" Inherits="MealDelivery" EnableEventValidation="false" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Canteen System – Meal Delivery</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Segoe UI, Arial, sans-serif; background: #f0f2f5; }

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

        /* ── Page Content ── */
        .content { padding: 30px; }
        h2 { color: #1a237e; margin-bottom: 20px; font-size: 20px; }

        /* ── Filter Panel ── */
        .filter-panel {
            background: #fff;
            border-radius: 10px;
            padding: 22px 24px;
            margin-bottom: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        .filter-row { display: flex; gap: 20px; flex-wrap: wrap; align-items: flex-end; }
        .filter-field { display: flex; flex-direction: column; gap: 5px; }
        .filter-field label { font-size: 13px; font-weight: 600; color: #444; }
        .filter-field input,
        .filter-field select {
            padding: 8px 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
            min-width: 160px;
        }
        .btn-show {
            padding: 9px 22px;
            background: #1565c0;
            color: #fff;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
        }
        .btn-show:hover { background: #0d47a1; }

        /* ── Summary Cards ── */
        .summary-row {
            display: flex;
            gap: 20px;
            margin-bottom: 24px;
            flex-wrap: wrap;
        }
        .summary-card {
            background: #fff;
            border-radius: 10px;
            padding: 20px 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            flex: 1;
            min-width: 160px;
            text-align: center;
        }
        .summary-card .count {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 6px;
        }
        .summary-card .label {
            font-size: 13px;
            color: #777;
            font-weight: 600;
        }
        .card-total .count { color: #1565c0; }
        .card-delivered .count { color: #2e7d32; }
        .card-pending .count { color: #ff6f00; }

        /* ── Grid ── */
        .grid-wrap {
            background: #fff;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            overflow-x: auto;
        }
        .grid-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 14px;
        }
        .grid-header h3 { font-size: 15px; color: #333; }

        table { width: 100%; border-collapse: collapse; font-size: 13px; }
        th {
            background: #1565c0;
            color: #fff;
            padding: 10px 12px;
            text-align: left;
        }
        td { padding: 9px 12px; border-bottom: 1px solid #eee; color: #333; }
        tr:hover td { background: #f5f9ff; }

        .badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: bold;
        }
        .badge-delivered { background: #e8f5e9; color: #2e7d32; }
        .badge-pending   { background: #fff3e0; color: #e65100; }
        .badge-in        { background: #e3f2fd; color: #1565c0; }

        .btn-deliver {
            padding: 5px 14px;
            background: #2e7d32;
            color: #fff;
            border: none;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
        }
        .btn-deliver:hover { background: #1b5e20; }
        .btn-deliver:disabled { background: #aaa; cursor: default; }

        /* ── Messages ── */
        .msg-error {
            background: #fdecea;
            border: 1px solid #f44336;
            color: #c62828;
            border-radius: 6px;
            padding: 10px 14px;
            font-size: 13px;
            margin-bottom: 16px;
        }
        .msg-success {
            background: #e8f5e9;
            border: 1px solid #4caf50;
            color: #2e7d32;
            border-radius: 6px;
            padding: 10px 14px;
            font-size: 13px;
            margin-bottom: 16px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <%-- Top Navigation Bar --%>
        <div class="navbar">
            <div class="brand">&#128666; Meal Delivery Tracking</div>
            <asp:Button ID="btnBack" runat="server" Text="<< Back to Dashboard"
                        CssClass="btn-back" OnClick="btnBack_Click" />
        </div>

        <div class="content">
            <h2>Meal Delivery Status</h2>

            <asp:Label ID="lblError" runat="server" CssClass="msg-error" Visible="false" />
            <asp:Label ID="lblSuccess" runat="server" CssClass="msg-success" Visible="false" />

            <%-- Filter Panel --%>
            <div class="filter-panel">
                <div class="filter-row">
                    <div class="filter-field">
                        <label>Pickup Point</label>
                        <asp:DropDownList ID="ddlPickup" runat="server">
                            <asp:ListItem Value="0">-- All Points --</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="filter-field">
                        <label>Meal Type</label>
                        <asp:DropDownList ID="ddlMeal" runat="server">
                            <asp:ListItem Value="0">-- All Meals --</asp:ListItem>
                            <asp:ListItem Value="1">Breakfast</asp:ListItem>
                            <asp:ListItem Value="2">Lunch</asp:ListItem>
                            <asp:ListItem Value="3">Snacks</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="filter-field">
                        <label>Delivery Status</label>
                        <asp:DropDownList ID="ddlStatus" runat="server">
                            <asp:ListItem Value="ALL">-- All --</asp:ListItem>
                            <asp:ListItem Value="IN">Pending (Punched In)</asp:ListItem>
                            <asp:ListItem Value="OUT">Delivered (Punched Out)</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <asp:Button ID="btnShow" runat="server" Text="Show"
                                CssClass="btn-show" OnClick="btnShow_Click" />
                </div>
            </div>

            <%-- Summary Cards --%>
            <asp:Panel ID="pnlSummary" runat="server" Visible="false">
                <div class="summary-row">
                    <div class="summary-card card-total">
                        <div class="count"><asp:Literal ID="litTotal" runat="server" Text="0" /></div>
                        <div class="label">Total Booked</div>
                    </div>
                    <div class="summary-card card-delivered">
                        <div class="count"><asp:Literal ID="litDelivered" runat="server" Text="0" /></div>
                        <div class="label">Delivered</div>
                    </div>
                    <div class="summary-card card-pending">
                        <div class="count"><asp:Literal ID="litPending" runat="server" Text="0" /></div>
                        <div class="label">Pending</div>
                    </div>
                </div>
            </asp:Panel>

            <%-- Results Grid --%>
            <asp:Panel ID="pnlGrid" runat="server" CssClass="grid-wrap" Visible="false">
                <div class="grid-header">
                    <h3>Delivery Records — Today</h3>
                    <asp:Button ID="btnMarkAllDelivered" runat="server" Text="Mark All as Delivered"
                                CssClass="btn-deliver" OnClick="btnMarkAllDelivered_Click"
                                OnClientClick="return confirm('Mark all pending items as Delivered?');" />
                </div>
                <asp:GridView ID="gvDelivery" runat="server" AutoGenerateColumns="false"
                              Width="100%" BorderStyle="None" GridLines="None"
                              DataKeyNames="ID"
                              OnRowCommand="gvDelivery_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="SP_NO"           HeaderText="SP Number"   />
                        <asp:BoundField DataField="PICKUP_NAME"     HeaderText="Pickup Point" />
                        <asp:BoundField DataField="MEAL_NAME"       HeaderText="Meal"         />
                        <asp:BoundField DataField="PUNCH_IN_TIME"   HeaderText="Punch In"     DataFormatString="{0:HH:mm:ss}" />
                        <asp:BoundField DataField="PUNCH_OUT_TIME"  HeaderText="Delivered At"  DataFormatString="{0:HH:mm:ss}" />
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class='<%# If(Eval("STATUS").ToString() = "OUT", "badge badge-delivered", "badge badge-pending") %>'>
                                    <%# If(Eval("STATUS").ToString() = "OUT", "Delivered", "Pending") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:Button ID="btnDeliver" runat="server"
                                    Text="Mark Delivered"
                                    CssClass="btn-deliver"
                                    CommandName="MarkDelivered"
                                    CommandArgument='<%# Eval("ID") %>'
                                    Visible='<%# Eval("STATUS").ToString() = "IN" %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </asp:Panel>
        </div>

    </form>
</body>
</html>
