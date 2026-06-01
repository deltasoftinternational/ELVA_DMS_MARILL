Page 25006094 "Item Replacement Overview"
{
    // 20.03.2014 Elva Baltic P15 #F124 MMG7.00
    //   * Changed Property - PopulateAllFields to "Yes"

    Caption = 'Item Replacement Overview';
    Editable = false;
    PageType = List;
    SourceTable = "Data Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type; Rec."Text Field 1")
                {
                    ApplicationArea = Basic;
                    Caption = 'Type';
                }
                field(No; Rec."Code Field 1")
                {
                    ApplicationArea = Basic;
                    Caption = 'No';
                }
                field(VariantCode; Rec."Code Field 2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Variant Code';
                    Visible = false;
                }
                field(ReplacementType; Rec."Text Field 2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Replacement Type';
                }
                field(ReplacementNo; Rec."Code Field 3")
                {
                    ApplicationArea = Basic;
                    Caption = 'Replacement No.';
                }
                field(ReplacementVariantCode; Rec."Code Field 4")
                {
                    ApplicationArea = Basic;
                    Caption = 'Replacement Variant Code';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }
}

