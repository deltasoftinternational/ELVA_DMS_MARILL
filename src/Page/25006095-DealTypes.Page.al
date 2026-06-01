Page 25006095 "Deal Types"
{
    ApplicationArea = Basic;
    Caption = 'Deal Types';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Deal Type";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(VehicleNotMandatory; Rec."Vehicle Not Mandatory")
                {
                    ApplicationArea = Basic;
                }
                field(OrderingPriceTypeCode; Rec."Ordering Price Type Code")
                {
                    ApplicationArea = Basic;
                }
                field("Mandatory Checklist Category"; Rec."Mandatory Checklist Category")
                {
                    ToolTip = 'Specifies the Category of first Mandatory Checklist.';
                    ApplicationArea = All;
                }
                field("Mandatory Checklist Category 2"; Rec."Mandatory Checklist Category 2")
                {
                    ToolTip = 'Specifies the Category of second Mandatory Checklist.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Mandatory Checklist Category 3"; Rec."Mandatory Checklist Category 3")
                {
                    ToolTip = 'Specifies the Category of third Mandatory Checklist.';
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(DealType)
            {
                Caption = 'Deal Type';
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = const(25006068),
                                  "No." = field(Code);
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action(Prices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Prices';
                    Image = SalesPrices;
                    RunObject = Page "Service Prices";
                    //RunPageLink = Field130=field(Code); //FIXME
                    Visible = false;
                }
            }
        }
    }
}

