Page 25006003 "Variable Field Translations"
{
    Caption = 'Variable Field Translations';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Variable Field Translation";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(LanguageCode; rec."Language Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

