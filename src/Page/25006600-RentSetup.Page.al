Page 25006600 "Rent Setup"
{
    ApplicationArea = Basic;
    Caption = 'Rent Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Rent Mgt. Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(DefaultCustLocationCode; Rec."Default Cust. Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies default customer location code. It is used as destination in transfers when rent assets are delivered to customers.';
                }
                field(AvailabilityLocationCode; Rec."Availability Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies default location code where rent assets are located while in stock.';
                    Visible = false;
                }
                field("Deal Type Mandatory"; Rec."Deal Type Mandatory")
                {
                    ToolTip = 'Specifies if it is mandaory to fill Deal Type field in rent orders before creating invoices.';
                    ApplicationArea = All;
                }
                field(AdvancePaymentResourceCode; Rec."Advance Payment Resource Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the resource code used in advance payment lines.';
                }
                field(DepositResourceCode; Rec."Deposit Resource Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the resource code used in deposit payment lines.';
                }
                field(CreditWarnings; Rec."Credit Warnings")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether to warn about the customer''s status when you create a rent quote or order.';
                    Visible = false;
                }
                field(Default4WeeksRentPeriod; Rec."Default 4 Weeks Rent Period")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the default rent period for 4 weeks rent.';
                }
                field(DefaultWeeklyRentPeriod; Rec."Default Weekly Rent Period")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the default rent period for one week rent.';
                }
                field(DefaultDailyRentPeriod; Rec."Default Daily Rent Period")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the default rent period for one day rent.';
                }
                field(SalesInvLineDecrText1; Rec."Sales Inv. Line Decr. Text 1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies description that will be visible in sales invoices for rent items. You can use special characters to retrieve special information in description. %1 Rent Asset No., %2 Rent Asset Description, %3 Rent Asset Make Code, %4 Rent Asset Serial No.,  %5 Rent Asset Model Code,  %6 Rent Asset Model Commercial Name,  %7 Rent Period Code, %8 Rent Period Description, %9 Rent Start Date, %10 Rent End Date,  %11 Rent Sales Line No.,  %12 Rent Sales Line Description,  %13 Invoicing Period Start Date,  %14 Invoicing Period End Date,  %15 Unit Price, %16 Line Amount, %17 VF Run 1 From, %18 VF Run 1 To, %19 VF Run 1 From, %20 VF Run 1 To, %21 VF Run 1 From, %22 VF Run 1 To, %23 Rent Order No., %24 Contract No., %25 External Contract No.';
                }
                field(SalesInvLineDecrText2; Rec."Sales Inv. Line Decr. Text 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies description that will be visible in sales invoices for rent items. You can use special characters to retrieve special information in description. %1 Rent Asset No., %2 Rent Asset Description, %3 Rent Asset Make Code, %4 Rent Asset Serial No.,  %5 Rent Asset Model Code,  %6 Rent Asset Model Commercial Name,  %7 Rent Period Code, %8 Rent Period Description, %9 Rent Start Date, %10 Rent End Date,  %11 Rent Sales Line No.,  %12 Rent Sales Line Description,  %13 Invoicing Period Start Date,  %14 Invoicing Period End Date,  %15 Unit Price, %16 Line Amount, %17 VF Run 1 From, %18 VF Run 1 To, %19 VF Run 1 From, %20 VF Run 1 To, %21 VF Run 1 From, %22 VF Run 1 To, %23 Rent Order No., %24 Contract No., %25 External Contract No.';
                }
                field(SalesInvLineDecrText3; Rec."Sales Inv. Line Decr. Text 3")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies description that will be visible in sales invoices for rent items. You can use special characters to retrieve special information in description. %1 Rent Asset No., %2 Rent Asset Description, %3 Rent Asset Make Code, %4 Rent Asset Serial No.,  %5 Rent Asset Model Code,  %6 Rent Asset Model Commercial Name,  %7 Rent Period Code, %8 Rent Period Description, %9 Rent Start Date, %10 Rent End Date,  %11 Rent Sales Line No.,  %12 Rent Sales Line Description,  %13 Invoicing Period Start Date,  %14 Invoicing Period End Date,  %15 Unit Price, %16 Line Amount, %17 VF Run 1 From, %18 VF Run 1 To, %19 VF Run 1 From, %20 VF Run 1 To, %21 VF Run 1 From, %22 VF Run 1 To, %23 Rent Order No., %24 Contract No., %25 External Contract No.';
                }
                field(SalesInvLineDecrText4; Rec."Sales Inv. Line Decr. Text 4")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies description that will be visible in sales invoices for rent items. You can use special characters to retrieve special information in description. %1 Rent Asset No., %2 Rent Asset Description, %3 Rent Asset Make Code, %4 Rent Asset Serial No.,  %5 Rent Asset Model Code,  %6 Rent Asset Model Commercial Name,  %7 Rent Period Code, %8 Rent Period Description, %9 Rent Start Date, %10 Rent End Date,  %11 Rent Sales Line No.,  %12 Rent Sales Line Description,  %13 Invoicing Period Start Date,  %14 Invoicing Period End Date,  %15 Unit Price, %16 Line Amount, %17 VF Run 1 From, %18 VF Run 1 To, %19 VF Run 1 From, %20 VF Run 1 To, %21 VF Run 1 From, %22 VF Run 1 To, %23 Rent Order No., %24 Contract No., %25 External Contract No.';
                }
                field(VariableFieldRun1; Rec."Variable Field Run 1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure for the first counter field.';
                    Visible = IsVFRun1Visible;
                }
                field(VariableFieldRun2; Rec."Variable Field Run 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure for the second counter field.';
                    Visible = IsVFRun2Visible;
                }
                field(VariableFieldRun3; Rec."Variable Field Run 3")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure for the third counter field.';
                    Visible = IsVFRun3Visible;
                }
                field(OvertimeCalculation; Rec."Overtime Calculation")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the default rent overtime calculation method. Overtime can be calculated whether based on whole rental contract time or individually for each rental period. It can be later changed in rent order.';
                }
                field(InvoiceOnlywithRentAsset; Rec."Invoice Only with Rent Asset")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if it is allowed to start invoice rental line only when a rent asset is specified.';
                }
                field("Rent Capacity Start Time"; Rec."Rent Capacity Start Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the start time of rent allocation in rent capacity screen.';
                }
                field("Rent Capacity End Time"; Rec."Rent Capacity End Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the end time of rent allocation in rent capacity screen.';
                }
                field("Default Capacity Period"; Rec."Default Capacity Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the default period displayed in rent capacity screen.';
                }
                field("Check VF Run 1 on Release"; Rec."Check VF Run 1 on Release")
                {
                    ToolTip = 'Specifies if first vehicle counter field is mandatory in rent transfer orders.';
                    ApplicationArea = All;
                    Visible = IsCheckVFRun1Visible;
                }
                field("Check VF Run 2 on Release"; Rec."Check VF Run 2 on Release")
                {
                    ToolTip = 'Specifies if second vehicle counter field is mandatory in rent transfer orders.';
                    ApplicationArea = All;
                    Visible = IsCheckVFRun2Visible;
                }
                field("Check VF Run 3 on Release"; Rec."Check VF Run 3 on Release")
                {
                    ToolTip = 'Specifies if third vehicle counter field is mandatory in rent transfer orders.';
                    ApplicationArea = All;
                    Visible = IsCheckVFRun3Visible;
                }
                field("Rent Service Location Code"; Rec."Rent Service Location Code")
                {
                    ToolTip = 'Specifies the Location code to mark that Rent Asset is in service.';
                    ApplicationArea = All;
                }
                field("Auto Post Rent Invoices"; Rec."Auto Post Rent Invoices")
                {
                    ApplicationArea = All;
                }
                field("Rent Period Calc. Type"; Rec."Rent Period Calc. Type")
                {
                    ApplicationArea = All;
                }
                field("Default Rent Type"; Rec."Default Rent Type")
                {
                    ApplicationArea = Basic;
                }
                field("Veh.Cust.Change on RentTransf."; Rec."Veh.Cust.Change on RentTransf.")
                {
                    ApplicationArea = All;
                }
            }
            group(Numbering)
            {
                field(RentItemNos; Rec."Rent Item Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to rent items.';
                }
                field(RentAssetNos; Rec."Rent Asset Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to rent assets.';
                }
                field(RentPackageNos; Rec."Rent Package Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to rent packages.';
                }
                field(QuoteNos; Rec."Quote Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to rent quotes.';
                }
                field(OrderNos; Rec."Order Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to rent orders.';
                }
                field(PostedOrderNos; Rec."Posted Order Nos.")
                {
                    ApplicationArea = Basic;
                    Enabled = PostedDocNosEnabled;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to posted rent orders.';
                }
                field(ReturnOrderNos; Rec."Return Order Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to rent return orders.';
                }
                field(PostedReturnOrderNos; Rec."Posted Return Order Nos.")
                {
                    ApplicationArea = Basic;
                    Enabled = PostedDocNosEnabled;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to posted rent return orders.';
                }
                field(InvoiceNos; Rec."Invoice Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to rent invoices.';
                }
                field(CreditMemoNos; Rec."Credit Memo Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to rent credit memos.';
                }
                field(PostedInvoiceNos; Rec."Posted Invoice Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to posted rent invoices.';
                }
                //>>DELTA XX
                field("Posted Credit Memo Nos."; Rec."Posted Credit Memo Nos.")
                {
                    ApplicationArea = Basic;
                }
                //DELTA XX
                field(RentShipmentNos; Rec."Rent Shipment Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to rent shipments.';
                }
                field(PostedRentShptNos; Rec."Posted Rent Shpt. Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to posted rent shipments.';
                }
                field(PstDocNumequalDocNum; Rec."PstDoc. Num. equal Doc. Num.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if posting numbers should be the same as document number before posting.';

                    trigger OnValidate()
                    begin
                        PostedDocNosEnabled := not Rec."PstDoc. Num. equal Doc. Num.";
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        PostedDocNosEnabled := not Rec."PstDoc. Num. equal Doc. Num.";
    end;

    trigger OnInit()
    begin
        SetVariableFields;
    end;

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then
            Rec.Insert;

        SetVariableFields;
    end;

    var
        PostedDocNosEnabled: Boolean;
        [InDataSet]
        IsVFRun1Visible: Boolean;
        [InDataSet]
        IsVFRun2Visible: Boolean;
        [InDataSet]
        IsVFRun3Visible: Boolean;
        IsCheckVFRun1Visible: Boolean;
        IsCheckVFRun2Visible: Boolean;
        IsCheckVFRun3Visible: Boolean;


    procedure SetVariableFields()
    begin
        //Variable Fields
        IsVFRun1Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 1"));
        IsVFRun2Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 2"));
        IsVFRun3Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 3"));
        IsCheckVFRun1Visible := Rec.IsVFActive(Rec.FieldNo("Check VF Run 1 on Release"));
        IsCheckVFRun2Visible := Rec.IsVFActive(Rec.FieldNo("Check VF Run 2 on Release"));
        IsCheckVFRun3Visible := Rec.IsVFActive(Rec.FieldNo("Check VF Run 3 on Release"));
    end;
}

