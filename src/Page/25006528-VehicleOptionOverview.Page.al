Page 25006528 "Vehicle Option Overview"
{
    Caption = 'Vehicle Option Overview';
    Editable = false;
    PageType = List;
    SourceTable = "Vehicle Opt. Ledger Entry";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(OptionType; Rec."Option Type")
                {
                    ApplicationArea = Basic;
                }
                field(OptionSubtype; Rec."Option Subtype")
                {
                    ApplicationArea = Basic;
                }
                field(OptionCode; Rec."Option Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Standard; Rec.Standard)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

