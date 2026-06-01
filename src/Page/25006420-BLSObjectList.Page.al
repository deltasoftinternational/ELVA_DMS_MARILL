Page 25006420 "BLS Object List"
{
    Caption = 'Object List';
    Editable = false;
    PageType = List;
    SourceTable = "BLS Object";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                IndentationColumn = NameIndent;
                IndentationControls = Name;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic;
                }
                field(PostCode; Rec."Post Code")
                {
                    ApplicationArea = Basic;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic;
                }
                field(CountryRegionCode; Rec."Country/Region Code")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Object")
            {
                Caption = '&Object';
                Image = Resource;
                action(DimensionsSingle)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions-Single';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = const(25006214),
                                  "No." = field(Code);
                    ShortCutKey = 'Shift+Ctrl+D';
                }
            }
            group(Sales)
            {
                Caption = 'Sales';
                Image = Contract;
                action(Prices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Prices';
                    Image = JobPrice;
                    Promoted = true;
                    RunObject = Page "BLS Service Prices";
                    RunPageLink = "Object Code" = field(Code);
                }
                action(Discounts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Discounts';
                    Image = Discount;
                    Promoted = true;
                    RunObject = Page "BLS Service Discounts";
                    RunPageLink = "Object Code" = field(Code);
                }
            }
            group(History)
            {
                Caption = 'History';
                action(ServiceLedgerEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Ledger Entries';
                    Image = ServiceLedger;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "BLS Ledger Entries";
                    RunPageLink = "Object Code" = field(Code),
                                  "Object Code" = field(filter(Totaling));
                }
                action(CalculationLedgerEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Calculation Ledger Entries';
                    Image = CalculateLines;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "BLS Service Discounts";
                    RunPageLink = "Object Code" = field(Code),
                                  "Object Code" = field(filter(Totaling));
                }
                action(InvoicingLedgerEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoicing Ledger Entries';
                    Image = CustomerLedger;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "BLS Invoicing Ledger Entries";
                    RunPageLink = "Object Code" = field(Code),
                                  "Object Code" = field(filter(Totaling));
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        NameIndent := 0;
        FormatLines;
    end;

    var
        Text000: label 'Shortcut Dimension %1';
        [InDataSet]
        Emphasize: Boolean;
        [InDataSet]
        NameIndent: Integer;

    local procedure FormatLines()
    begin
        Emphasize := Rec."Object Type" <> Rec."object type"::Standard;
        NameIndent := Rec.Indentation;
    end;
}

