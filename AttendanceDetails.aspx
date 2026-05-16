<%-- ============================================================
     AttendanceDetails.aspx  –  Attendance Report Page
     Project: Automation of Canteen Trolley Operation
     ============================================================ --%>
<%@ Page Language="VB" AutoEventWireup="true" CodeFile="AttendanceDetails.aspx.vb" Inherits="AttendanceDetails" EnableEventValidation="false" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Attendance Details</title>
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
        .navbar .brand { font-size: 18px; font-weight: bold; }
        .btn-back {
            background: transparent;
            color: #fff;
            border: 1px solid #fff;
            padding: 6px 14px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 13px;
        }

        .content { padding: 30px; }
        h2 { color: #1a237e; margin-bottom: 20px; font-size: 20px; }

        /* Toggle tabs */
        .tabs { display: flex; gap: 10px; margin-bottom: 24px; }
        .tab-btn {
            padding: 9px 22px;
            border: 2px solid #1565c0;
            background: #fff;
            color: #1565c0;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
        }
        .tab-btn.active { background: #1565c0; color: #fff; }

        /* Filter panels */
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
        .btn-export {
            padding: 9px 22px;
            background: #2e7d32;
            color: #fff;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
        }

        /* Grid */
        .grid-wrap {
            background: #fff;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            overflow-x: auto;
        }
        .grid-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px; }
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
        .badge-in  { background: #e8f5e9; color: #2e7d32; }
        .badge-out { background: #fdecea; color: #c62828; }

        .msg-error {
            background: #fdecea;
            border: 1px solid #f44336;
            color: #c62828;
            border-radius: 6px;
            padding: 10px 14px;
            font-size: 13px;
            margin-bottom: 16px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <div class="navbar">
            <div class="brand">&#128202; Attendance Details</div>
            <asp:Button ID="btnBack" runat="server" Text="<< Back to Dashboard"
                        CssClass="btn-back" OnClick="btnBack_Click" />
        </div>

        <div class="content">
            <h2>Vendor Attendance Report</h2>

            <asp:Label ID="lblError" runat="server" CssClass="msg-error" Visible="false" />

            <%-- Toggle Tabs --%>
            <div class="tabs">
                <asp:Button ID="btnTabIndividual" runat="server" Text="Individual Wise"
                            CssClass="tab-btn active" OnClick="btnTabIndividual_Click" />
                <asp:Button ID="btnTabCanteen" runat="server" Text="Canteen Wise"
                            CssClass="tab-btn" OnClick="btnTabCanteen_Click" />
            </div>

            <%-- Individual Filter Panel --%>
            <asp:Panel ID="pnlIndividual" runat="server" CssClass="filter-panel">
                <div class="filter-row">
                    <div class="filter-field">
                        <label>SP Number</label>
                        <asp:TextBox ID="txtSpNo" runat="server" placeholder="Enter SP No" />
                    </div>
                    <div class="filter-field">
                        <label>From Date</label>
                        <asp:TextBox ID="txtFromDate" runat="server" placeholder="dd-MM-yyyy" />
                    </div>
                    <div class="filter-field">
                        <label>To Date</label>
                        <asp:TextBox ID="txtToDate" runat="server" placeholder="dd-MM-yyyy" />
                    </div>
                    <asp:Button ID="btnShowIndividual" runat="server" Text="Show"
                                CssClass="btn-show" OnClick="btnShowIndividual_Click" />
                </div>
            </asp:Panel>

            <%-- Canteen Filter Panel --%>
            <asp:Panel ID="pnlCanteen" runat="server" CssClass="filter-panel" Visible="false">
                <div class="filter-row">
                    <div class="filter-field">
                        <label>Canteen</label>
                        <asp:DropDownList ID="ddlCanteen" runat="server" />
                    </div>
                    <div class="filter-field">
                        <label>Meal Type</label>
                        <asp:DropDownList ID="ddlMeal" runat="server">
                            <asp:ListItem Value="1">Breakfast</asp:ListItem>
                            <asp:ListItem Value="2">Lunch</asp:ListItem>
                            <asp:ListItem Value="3">Snacks</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="filter-field">
                        <label>From Date</label>
                        <asp:TextBox ID="txtFromDate2" runat="server" placeholder="dd-MM-yyyy" />
                    </div>
                    <div class="filter-field">
                        <label>To Date</label>
                        <asp:TextBox ID="txtToDate2" runat="server" placeholder="dd-MM-yyyy" />
                    </div>
                    <asp:Button ID="btnShowCanteen" runat="server" Text="Show"
                                CssClass="btn-show" OnClick="btnShowCanteen_Click" />
                </div>
            </asp:Panel>

            <%-- Results Grid --%>
            <asp:Panel ID="pnlGrid" runat="server" CssClass="grid-wrap" Visible="false">
                <div class="grid-header">
                    <h3>Results</h3>
                    <asp:Button ID="btnExport" runat="server" Text="Export to Excel"
                                CssClass="btn-export" OnClick="btnExport_Click" />
                </div>
                <asp:GridView ID="gvAttendance" runat="server" AutoGenerateColumns="false"
                              Width="100%" BorderStyle="None" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="SP_NO"          HeaderText="SP Number"   />
                        <asp:BoundField DataField="PUNCH_DATE"     HeaderText="Date"        DataFormatString="{0:dd-MM-yyyy}" />
                        <asp:BoundField DataField="MEAL_ID"        HeaderText="Meal"        />
                        <asp:BoundField DataField="PICKUP_ID"      HeaderText="Pickup Point"/>
                        <asp:BoundField DataField="PUNCH_IN_TIME"  HeaderText="Punch In"    DataFormatString="{0:HH:mm:ss}" />
                        <asp:BoundField DataField="PUNCH_OUT_TIME" HeaderText="Punch Out"   DataFormatString="{0:HH:mm:ss}" />
                        <asp:BoundField DataField="STATUS"         HeaderText="Status"      />
                    </Columns>
                </asp:GridView>
            </asp:Panel>

        </div>
    </form>
</body>
</html>