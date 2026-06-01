Page 25006425 "DMS Contract Service Subpage"
{
    Caption = 'Services';
    DelayedInsert = true;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "DMS Contract Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ServiceCode; Rec."Service Code")
                {
                    ApplicationArea = Basic;
                }
                field(ObjectCode; Rec."Object Code")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(StartingDate; Rec."Starting Date")
                {
                    ApplicationArea = Basic;
                }
                field(EndingDate; Rec."Ending Date")
                {
                    ApplicationArea = Basic;
                }
                field(ServiceDescription; Rec."Service Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field("Calculation Period Code"; Rec."Calculation Period Code")
                {
                    ApplicationArea = all;
                }
                field(ObjectName; Rec."Object Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(QuantitySource; Rec."Quantity Source")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(PriceSource; Rec."Price Source")
                {
                    ApplicationArea = Basic;
                }
                field(Price; Rec.Price)
                {
                    ApplicationArea = Basic;
                }
                field(PriceIncludingVAT; Rec."Price Including VAT")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }

                field(DiscountUsage; Rec."Discount Usage")
                {
                    ApplicationArea = Basic;
                }
                field(LastCalculationDate; Rec."Last Calculation Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(VehMakeCode; Rec."Veh. Make Code")
                {
                    ApplicationArea = Basic;
                }
                field(VehModelCode; Rec."Veh. Model Code")
                {
                    ApplicationArea = Basic;
                }
                field(VehModelVersionNo; Rec."Veh. Model Version No.")
                {
                    ApplicationArea = Basic;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;
                }
                field(StdPrice; StdPrice)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Standard Price';
                    DecimalPlaces = 2 : 5;
                    Editable = false;
                }
                field(StdDiscount; StdDiscount)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Caption = 'Standard Discount';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                }
                field(VariableFieldRunStart1; Rec."Variable Field Run Start 1")
                {
                    ApplicationArea = Basic;
                    Visible = VFRun1StartVisible;
                }
                field("Variable Field Run Start 2"; Rec."Variable Field Run Start 2")
                {
                    ApplicationArea = All;
                    Visible = VFRun2StartVisible;
                }
                field("Variable Field Run Start 3"; Rec."Variable Field Run Start 3")
                {
                    ApplicationArea = All;
                    Visible = VFRun3StartVisible;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        CalcLineData;
    end;

    trigger OnInit()
    begin
        SetVariableFields;
    end;

    var
        BLSMgt: Codeunit "BLS Management";
        StdPrice: Decimal;
        StdDiscount: Decimal;
        VFRun1StartVisible: Boolean;
        VFRun2StartVisible: Boolean;
        VFRun3StartVisible: Boolean;

    local procedure CalcLineData()
    var
        Contract: Record Contract;
    begin
        StdPrice := 0;
        StdDiscount := 0;

        if (Rec."DMS Contract No." = '') or (Rec."Service Code" = '') or (Rec."Starting Date" = 0D) then
            exit;

        if Rec."DMS Contract No." <> Contract."Contract No." then
            if not Contract.Get(Rec."DMS Contract No.") then
                exit;

        BLSMgt.GetServiceStandardPrice(Rec."Service Code", '', Rec."Object Code", '', '', Rec."Starting Date", Contract."Currency Code", 0, StdPrice);
        BLSMgt.GetServiceStandardDiscount(Rec."Service Code", '', Rec."Object Code", '', '', Rec."Starting Date", Contract."Currency Code", 0, StdDiscount);
    end;

    procedure SetVariableFields()
    begin
        VFRun1StartVisible := rec.IsVFActive(rec.FieldNo("Variable Field Run Start 1"));
        VFRun2StartVisible := rec.IsVFActive(rec.FieldNo("Variable Field Run Start 2"));
        VFRun3StartVisible := rec.IsVFActive(rec.FieldNo("Variable Field Run Start 3"));
    end;
}

