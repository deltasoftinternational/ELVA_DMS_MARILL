Page 25006072 "Vehicle Statistics"
{
    Caption = 'Vehicle Statistics';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Vehicle;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(SerialNo; Rec."Serial No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(CurrLocationCode; CurrLocationCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Current Location Code';
                    Editable = false;
                }
            }
            group(Service)
            {
                Caption = 'Service';
                field(ServiceCount; ServiceCount)
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Order Count';
                    Editable = false;
                }
                field(ServiceSalesLCY; ServiceSalesLCY)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales (LCY)';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDown(Text010);
                    end;
                }
                field(ServiceCostLCY; ServiceCostLCY)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cost (LCY)';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDown(Text011);
                    end;
                }
                field(ServiceProfitLCY; ServiceProfitLCY)
                {
                    ApplicationArea = Basic;
                    Caption = 'Profit (LCY)';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDown(Text012);
                    end;
                }
                field(ServiceProfitPercent; ServiceProfitPercent)
                {
                    ApplicationArea = Basic;
                    Caption = 'Profit %';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDown(Text013);
                    end;
                }
            }
            group(VehicleTrade)
            {
                Caption = 'Vehicle Trade';
                field(TradeSalesLCY; TradeSalesLCY)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales (LCY)';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDown(Text001);
                    end;
                }
                field(TradeCogsLCY; TradeCogsLCY)
                {
                    ApplicationArea = Basic;
                    Caption = 'COGS (LCY)';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDown(Text003);
                    end;
                }
                field(TradeProfitLCY; TradeProfitLCY)
                {
                    ApplicationArea = Basic;
                    Caption = 'Profit (LCY)';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDown(Text004);
                    end;
                }
                field(TradeProfitPercent; TradeProfitPercent)
                {
                    ApplicationArea = Basic;
                    Caption = 'Profit %';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDown(Text005);
                    end;
                }
                field(TradePurchaseLCY; TradePurchaseLCY)
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase (LCY)';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDown(Text002);
                    end;
                }
                field(TradeCost; TradeCost)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cost';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDown(Text006);
                    end;
                }
                field(TradeExpenses; TradeExpenses)
                {
                    ApplicationArea = Basic;
                    Caption = 'Expenses';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDown(Text008);
                    end;
                }
                field(TradeCostIncExpenses; TradeCostIncExpenses)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cost Inc. Expenses';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDown(Text007);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        CostCalcMgt: Codeunit "Cost Calculation Management";
    begin
        Rec.CalcFields(Inventory);
        CurrLocationCode := '';
        if Rec.Inventory <> 0 then
            GetCurrLocation;

        CalculateVehicleTrade;
        CalculateService;
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange("Serial No.", Rec."Serial No.");
    end;

    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        VehicleTradeStatisticsBuffer: Record "Vehicle Statistics Buffer" temporary;
        ServiceStatisticsBuffer: Record "Vehicle Statistics Buffer" temporary;
        CurrLocationCode: Code[20];
        Text001: label 'Sales (LCY)';
        Text002: label 'Purchase (LCY)';
        Text003: label 'COGS (LCY)';
        Text004: label 'Profit (LCY)';
        Text005: label 'Profit %';
        Text006: label 'Cost';
        Text007: label 'Cost Incl. Expenses';
        Text008: label 'Expenses';
        Text010: label 'Service (LCY)';
        Text011: label 'Service Cost (LCY)';
        Text012: label 'Service Profit (LCY)';
        Text013: label 'Service Profit %';
        ServiceCount: Integer;
        TradeSalesLCY: Decimal;
        TradeCogsLCY: Decimal;
        TradeProfitPercent: Decimal;
        TradeProfitLCY: Decimal;
        TradePurchaseLCY: Decimal;
        TradeCost: Decimal;
        TradeExpenses: Decimal;
        TradeCostIncExpenses: Decimal;
        ServiceSalesLCY: Decimal;
        ServiceCostLCY: Decimal;
        ServiceProfitLCY: Decimal;
        ServiceProfitPercent: Decimal;


    procedure CalculateVehicleTrade()
    var
        SalesAmount: Decimal;
        ProfitAmount: Decimal;
    begin
        TradeSalesLCY := 0;
        TradeCogsLCY := 0;
        TradeProfitPercent := 0;
        TradeProfitLCY := 0;
        TradePurchaseLCY := 0;
        TradeCost := 0;
        TradeExpenses := 0;
        TradeCostIncExpenses := 0;

        VehicleTradeStatisticsBuffer.Reset;
        VehicleTradeStatisticsBuffer.DeleteAll;

        ItemLedgerEntry.Reset;
        ItemLedgerEntry.SetCurrentkey("Serial No.");
        ItemLedgerEntry.SetRange("Serial No.", Rec."Serial No.");
        Rec.CalcFields("Default Vehicle Acc. Cycle No.");
        ItemLedgerEntry.SetRange("Vehicle Accounting Cycle No.", Rec."Default Vehicle Acc. Cycle No.");

        if ItemLedgerEntry.FindFirst then
            repeat
                VehicleTradeInitEntries(ItemLedgerEntry);
                ItemLedgerEntry.CalcFields("Sales Amount (Actual)", "Cost Amount (Actual)", "Cost Amount (Non-Invtbl.)",
                                           "Purchase Amount (Actual)");

                case ItemLedgerEntry."Entry Type" of
                    ItemLedgerEntry."entry type"::Sale:
                        begin
                            SalesAmount := AddStatistic(Rec."Serial No.", ItemLedgerEntry."Vehicle Accounting Cycle No.", 800, Text001,
                                                     ItemLedgerEntry."Sales Amount (Actual)", VehicleTradeStatisticsBuffer);

                            AddStatistic(Rec."Serial No.", ItemLedgerEntry."Vehicle Accounting Cycle No.", 700, Text003,
                                         ItemLedgerEntry."Cost Amount (Actual)", VehicleTradeStatisticsBuffer);

                            ProfitAmount := AddStatistic(Rec."Serial No.", ItemLedgerEntry."Vehicle Accounting Cycle No.", 600, Text004,
                                                         ItemLedgerEntry."Sales Amount (Actual)" + ItemLedgerEntry."Cost Amount (Actual)"
                                                        + ItemLedgerEntry."Cost Amount (Non-Invtbl.)", VehicleTradeStatisticsBuffer);

                            CalcProfitProcent(Rec."Serial No.", ItemLedgerEntry."Vehicle Accounting Cycle No.", 500, Text005,
                                                   SalesAmount, ProfitAmount, VehicleTradeStatisticsBuffer);
                        end;

                    ItemLedgerEntry."entry type"::Purchase:
                        begin
                            AddStatistic(Rec."Serial No.", ItemLedgerEntry."Vehicle Accounting Cycle No.", 400, Text002,
                                        -ItemLedgerEntry."Purchase Amount (Actual)", VehicleTradeStatisticsBuffer);
                            AddStatistic(Rec."Serial No.", ItemLedgerEntry."Vehicle Accounting Cycle No.", 200, Text007,
                                        -ItemLedgerEntry."Cost Amount (Actual)", VehicleTradeStatisticsBuffer);
                            CalcPurchCosts(ItemLedgerEntry, false);
                        end;

                    ItemLedgerEntry."entry type"::"Positive Adjmt.":
                        begin
                            AddStatistic(Rec."Serial No.", ItemLedgerEntry."Vehicle Accounting Cycle No.", 200, Text007,
                                        -ItemLedgerEntry."Cost Amount (Actual)", VehicleTradeStatisticsBuffer);
                            CalcPurchCosts(ItemLedgerEntry, false);
                        end;

                    ItemLedgerEntry."entry type"::Transfer:
                        begin
                            if ItemLedgerEntry.Positive then
                                CalcPurchCosts(ItemLedgerEntry, true);
                        end;

                end;
            until ItemLedgerEntry.Next = 0;

        if VehicleTradeStatisticsBuffer.FindFirst then
            repeat
                case VehicleTradeStatisticsBuffer."Field Name" of
                    Text001:
                        TradeSalesLCY := VehicleTradeStatisticsBuffer."Field Value";
                    Text002:
                        TradePurchaseLCY := VehicleTradeStatisticsBuffer."Field Value";
                    Text003:
                        TradeCogsLCY := VehicleTradeStatisticsBuffer."Field Value";
                    Text004:
                        TradeProfitLCY := VehicleTradeStatisticsBuffer."Field Value";
                    Text005:
                        TradeProfitPercent := VehicleTradeStatisticsBuffer."Field Value";
                    Text006:
                        TradeCost := VehicleTradeStatisticsBuffer."Field Value";
                    Text007:
                        TradeCostIncExpenses := VehicleTradeStatisticsBuffer."Field Value";
                    Text008:
                        TradeExpenses := VehicleTradeStatisticsBuffer."Field Value";
                end;
            until VehicleTradeStatisticsBuffer.Next = 0;
    end;


    procedure AddStatistic(SerialNo: Code[20]; AccNo: Code[20]; Sequence: Integer; FieldName: Text[30]; FieldValue: Decimal; var VehicleStatisticsBuffer: Record "Vehicle Statistics Buffer" temporary): Decimal
    begin
        if VehicleStatisticsBuffer.Get(SerialNo, AccNo, Sequence, FieldName) then begin
            VehicleStatisticsBuffer."Field Value" += FieldValue;
            VehicleStatisticsBuffer.Modify;
        end else begin
            VehicleStatisticsBuffer.Init;
            VehicleStatisticsBuffer."Vehicle Serial No." := SerialNo;
            VehicleStatisticsBuffer."Vehicle Accounting Cycle No." := AccNo;
            VehicleStatisticsBuffer.Sequence := Sequence;
            VehicleStatisticsBuffer."Field Name" := FieldName;
            VehicleStatisticsBuffer."Field Value" := FieldValue;
            VehicleStatisticsBuffer.Insert;
        end;

        exit(VehicleStatisticsBuffer."Field Value");
    end;


    procedure CalcProfitProcent(SerialNo: Code[20]; AccNo: Code[20]; Sequence: Integer; FieldName: Text[30]; SalesAmount: Decimal; ProfitAmount: Decimal; var VehicleStatisticsBuffer: Record "Vehicle Statistics Buffer" temporary)
    begin
        if not VehicleStatisticsBuffer.Get(SerialNo, AccNo, Sequence, FieldName) then begin
            VehicleStatisticsBuffer.Init;
            VehicleStatisticsBuffer."Vehicle Serial No." := SerialNo;
            VehicleStatisticsBuffer."Vehicle Accounting Cycle No." := AccNo;
            VehicleStatisticsBuffer.Sequence := Sequence;
            VehicleStatisticsBuffer."Field Name" := FieldName;
            VehicleStatisticsBuffer.Insert;
        end;

        if SalesAmount = 0 then
            VehicleStatisticsBuffer."Field Value" := 0
        else
            VehicleStatisticsBuffer."Field Value" := ROUND(100 * ProfitAmount / SalesAmount);

        VehicleStatisticsBuffer.Modify;
    end;


    procedure CalcPurchCosts(ItemLedgerEntry: Record "Item Ledger Entry"; IsPositiveTransfer: Boolean)
    var
        ValueEntry: Record "Value Entry";
        InventoryPostingGroup: Record "Inventory Posting Group";
    begin
        ValueEntry.Reset;
        ValueEntry.SetCurrentkey("Item Ledger Entry No.");
        ValueEntry.SetRange("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
        if IsPositiveTransfer then
            ValueEntry.SetRange("Item Ledger Entry Type", ValueEntry."item ledger entry type"::Purchase);

        if ValueEntry.FindFirst then
            repeat
                if InventoryPostingGroup.Get(ValueEntry."Inventory Posting Group") and InventoryPostingGroup."Vehicle Additional Expenses"
            then
                    AddStatistic(ItemLedgerEntry."Serial No.", ItemLedgerEntry."Vehicle Accounting Cycle No.", 100, Text008,
                                 -ValueEntry."Cost Amount (Actual)", VehicleTradeStatisticsBuffer)
                else
                    AddStatistic(ItemLedgerEntry."Serial No.", ItemLedgerEntry."Vehicle Accounting Cycle No.", 300, Text006,
                                 -ValueEntry."Cost Amount (Actual)", VehicleTradeStatisticsBuffer);

                if IsPositiveTransfer then
                    AddStatistic(ItemLedgerEntry."Serial No.", ItemLedgerEntry."Vehicle Accounting Cycle No.", 200, Text007,
                                 -ValueEntry."Cost Amount (Actual)", VehicleTradeStatisticsBuffer);

            until ValueEntry.Next = 0;
    end;


    procedure VehicleTradeInitEntries(ItemLedgerEntries: Record "Item Ledger Entry")
    begin
        AddStatistic(Rec."Serial No.", ItemLedgerEntries."Vehicle Accounting Cycle No.", 800, Text001, 0, VehicleTradeStatisticsBuffer);
        AddStatistic(Rec."Serial No.", ItemLedgerEntries."Vehicle Accounting Cycle No.", 400, Text002, 0, VehicleTradeStatisticsBuffer);
        AddStatistic(Rec."Serial No.", ItemLedgerEntries."Vehicle Accounting Cycle No.", 700, Text003, 0, VehicleTradeStatisticsBuffer);
        AddStatistic(Rec."Serial No.", ItemLedgerEntries."Vehicle Accounting Cycle No.", 600, Text004, 0, VehicleTradeStatisticsBuffer);
        AddStatistic(Rec."Serial No.", ItemLedgerEntries."Vehicle Accounting Cycle No.", 500, Text005, 0, VehicleTradeStatisticsBuffer);
        AddStatistic(Rec."Serial No.", ItemLedgerEntries."Vehicle Accounting Cycle No.", 300, Text006, 0, VehicleTradeStatisticsBuffer);
        AddStatistic(Rec."Serial No.", ItemLedgerEntries."Vehicle Accounting Cycle No.", 200, Text007, 0, VehicleTradeStatisticsBuffer);
        AddStatistic(Rec."Serial No.", ItemLedgerEntries."Vehicle Accounting Cycle No.", 100, Text008, 0, VehicleTradeStatisticsBuffer);
    end;


    procedure GetCurrLocation()
    begin
        ItemLedgerEntry.Reset;
        ItemLedgerEntry.SetCurrentkey("Serial No.");
        ItemLedgerEntry.SetRange("Serial No.", Rec."Serial No.");
        ItemLedgerEntry.SetRange(Open, true);
        if ItemLedgerEntry.FindFirst then
            CurrLocationCode := ItemLedgerEntry."Location Code";
    end;


    procedure CalculateService()
    var
        ServiceLedgerEntry: Record "Service Ledger Entry EDMS";
        CurrExchangeRate: Record "Currency Exchange Rate";
        PostedServiceHeader: Record "Posted Serv. Order Header";
        SalesAmount: Decimal;
        ProfitAmount: Decimal;
    begin
        ServiceSalesLCY := 0;
        ServiceCostLCY := 0;
        ServiceProfitLCY := 0;
        ServiceProfitPercent := 0;

        ServiceStatisticsBuffer.Reset;
        ServiceStatisticsBuffer.DeleteAll;

        PostedServiceHeader.Reset;
        PostedServiceHeader.SetRange("Vehicle Serial No.", Rec."Serial No.");
        ServiceCount := PostedServiceHeader.Count;

        ServiceLedgerEntry.Reset;
        ServiceLedgerEntry.SetCurrentkey("Vehicle Serial No.");
        ServiceLedgerEntry.SetRange("Vehicle Serial No.", Rec."Serial No.");
        ServiceLedgerEntry.SetRange("Entry Type", ServiceLedgerEntry."entry type"::Sale);
        if ServiceLedgerEntry.FindFirst then
            repeat
                if ServiceLedgerEntry."Amount (LCY)" < 0 then
                    ServiceLedgerEntry."Amount (LCY)" *= -1;
                if ServiceLedgerEntry."Total Cost" > 0 then
                    ServiceLedgerEntry."Total Cost" *= -1;
                ServiceInitEntries(ServiceLedgerEntry);
                SalesAmount := AddStatistic(Rec."Serial No.", ServiceLedgerEntry."Vehicle Accounting Cycle No.", 80, Text010,
                                           ServiceLedgerEntry."Amount (LCY)", ServiceStatisticsBuffer);

                if ServiceLedgerEntry."Currency Code" <> '' then
                    ServiceLedgerEntry."Total Cost" := CurrExchangeRate.ExchangeAmtFCYToLCY(
                                             ServiceLedgerEntry."Posting Date",
                                             ServiceLedgerEntry."Currency Code",
                                             ServiceLedgerEntry."Total Cost",
                                             CurrExchangeRate.ExchangeRate(ServiceLedgerEntry."Posting Date", ServiceLedgerEntry."Currency Code")
              );


                AddStatistic(Rec."Serial No.", ServiceLedgerEntry."Vehicle Accounting Cycle No.", 70, Text011,
                            ServiceLedgerEntry."Total Cost", ServiceStatisticsBuffer);

                ProfitAmount := AddStatistic(Rec."Serial No.", ServiceLedgerEntry."Vehicle Accounting Cycle No.", 60, Text012,
                                            ServiceLedgerEntry."Amount (LCY)" + ServiceLedgerEntry."Total Cost", ServiceStatisticsBuffer);

                CalcProfitProcent(Rec."Serial No.", ServiceLedgerEntry."Vehicle Accounting Cycle No.", 50, Text013, SalesAmount, ProfitAmount
                                       , ServiceStatisticsBuffer);
            until ServiceLedgerEntry.Next = 0;

        if ServiceStatisticsBuffer.FindFirst then
            repeat
                case ServiceStatisticsBuffer."Field Name" of
                    Text010:
                        ServiceSalesLCY := ServiceStatisticsBuffer."Field Value";
                    Text011:
                        ServiceCostLCY := ServiceStatisticsBuffer."Field Value";
                    Text012:
                        ServiceProfitLCY := ServiceStatisticsBuffer."Field Value";
                    Text013:
                        ServiceProfitPercent := ServiceStatisticsBuffer."Field Value";
                end;
            until ServiceStatisticsBuffer.Next = 0;
    end;


    procedure ServiceInitEntries(ServiceLedgerEntry: Record "Service Ledger Entry EDMS")
    begin
        AddStatistic(Rec."Serial No.", ServiceLedgerEntry."Vehicle Accounting Cycle No.", 80, Text010, 0, ServiceStatisticsBuffer);
        AddStatistic(Rec."Serial No.", ServiceLedgerEntry."Vehicle Accounting Cycle No.", 70, Text011, 0, ServiceStatisticsBuffer);
        AddStatistic(Rec."Serial No.", ServiceLedgerEntry."Vehicle Accounting Cycle No.", 60, Text012, 0, ServiceStatisticsBuffer);
        AddStatistic(Rec."Serial No.", ServiceLedgerEntry."Vehicle Accounting Cycle No.", 50, Text013, 0, ServiceStatisticsBuffer);
    end;


    procedure DrillDown(FieldName: Text[30])
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        InventoryPostingGroup: Record "Inventory Posting Group";
        TempValueEntry: Record "Value Entry" temporary;
        ServiceLedgerEntry: Record "Service Ledger Entry EDMS";
        TempServiceLedgerEntry: Record "Service Ledger Entry EDMS" temporary;
        VehicleTrade: Boolean;
        Service: Boolean;
    begin
        VehicleTrade := false;
        Service := false;

        ValueEntry.Reset;
        ValueEntry.ClearMarks;

        ItemLedgerEntry.Reset;
        ItemLedgerEntry.SetCurrentkey("Serial No.");
        ItemLedgerEntry.SetRange("Serial No.", Rec."Serial No.");
        Rec.CalcFields("Default Vehicle Acc. Cycle No.");
        ItemLedgerEntry.SetRange("Vehicle Accounting Cycle No.", Rec."Default Vehicle Acc. Cycle No.");

        case FieldName of
            Text001, Text003, Text004, Text005:
                begin
                    VehicleTrade := true;
                    ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."entry type"::Sale);
                    if ItemLedgerEntry.FindFirst then
                        repeat
                            ValueEntry.Reset;
                            ValueEntry.SetCurrentkey("Item Ledger Entry No.");
                            ValueEntry.SetRange("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
                            if ValueEntry.FindFirst then
                                repeat
                                    ValueEntry.Mark(true);
                                until ValueEntry.Next = 0;
                        until ItemLedgerEntry.Next = 0;
                end;

            Text002, Text006, Text007, Text008:
                begin
                    VehicleTrade := true;
                    ItemLedgerEntry.SetFilter("Entry Type", '%1|%2', ItemLedgerEntry."entry type"::Purchase,
                                              ItemLedgerEntry."entry type"::"Positive Adjmt.");
                    if ItemLedgerEntry.FindFirst then
                        repeat
                            ValueEntry.Reset;
                            ValueEntry.SetCurrentkey("Item Ledger Entry No.");
                            ValueEntry.SetRange("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
                            if ValueEntry.FindFirst then
                                repeat
                                    if FieldName = Text006 then begin
                                        if not (InventoryPostingGroup.Get(ValueEntry."Inventory Posting Group") and
                                           InventoryPostingGroup."Vehicle Additional Expenses")
                                        then
                                            ValueEntry.Mark(true);
                                    end;
                                    if FieldName = Text008 then begin
                                        if InventoryPostingGroup.Get(ValueEntry."Inventory Posting Group") and
                                           InventoryPostingGroup."Vehicle Additional Expenses"
                                        then
                                            ValueEntry.Mark(true);
                                    end;
                                    if FieldName in [Text002, Text007] then
                                        ValueEntry.Mark(true);
                                until ValueEntry.Next = 0;
                        until ItemLedgerEntry.Next = 0;
                end;
            Text010, Text011, Text012, Text013:
                begin
                    Service := true;
                    TempServiceLedgerEntry.Reset;
                    TempServiceLedgerEntry.DeleteAll;
                    ServiceLedgerEntry.Reset;
                    ServiceLedgerEntry.SetCurrentkey("Vehicle Serial No.");
                    ServiceLedgerEntry.SetRange("Vehicle Serial No.", Rec."Serial No.");
                    ServiceLedgerEntry.SetRange("Entry Type", ServiceLedgerEntry."entry type"::Sale);
                    if ServiceLedgerEntry.FindFirst then
                        repeat
                            TempServiceLedgerEntry := ServiceLedgerEntry;
                            if TempServiceLedgerEntry.Insert then;
                        until ServiceLedgerEntry.Next = 0;
                end;
        end;

        if VehicleTrade then begin
            ValueEntry.MarkedOnly(true);
            TempValueEntry.Reset;
            TempValueEntry.DeleteAll;
            if ValueEntry.FindFirst then
                repeat
                    TempValueEntry := ValueEntry;
                    TempValueEntry.Insert;
                until ValueEntry.Next = 0;

            Page.RunModal(Page::"Value Entries", TempValueEntry);
        end;

        if Service then
            Page.RunModal(Page::"Service Ledger Entries EDMS", TempServiceLedgerEntry);
    end;
}

