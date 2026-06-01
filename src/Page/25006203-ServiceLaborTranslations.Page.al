Page 25006203 "Service Labor Translations"
{
    Caption = 'Service Labor Translations';
    DataCaptionFields = "No.";
    PageType = List;
    SourceTable = "Service Labor Translation";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(No; Rec."No.")
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

