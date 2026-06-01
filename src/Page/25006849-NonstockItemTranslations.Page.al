Page 25006849 "Nonstock Item Translations"
{
    Caption = 'Nonstock Item Translations';
    DataCaptionFields = "Nonstock Item Entry No.";
    PageType = List;
    SourceTable = "Nonstock Item Translation";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(NonstockItemEntryNo; Rec."Nonstock Item Entry No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LanguageCode; Rec."Language Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Description2; Rec."Description 2")
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

