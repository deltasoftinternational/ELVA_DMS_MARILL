Page 25006530 "Option Translations"
{
    Caption = 'Option Translations';
    DataCaptionFields = "Option Type", "Option Code";
    DelayedInsert = true;
    PageType = List;
    PopulateAllFields = true;
    SourceTable = "Option Translation";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(OptionType; Rec."Option Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ModelCode; Rec."Model Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ModelVersionNo; Rec."Model Version No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(OptionSubtype; Rec."Option Subtype")
                {
                    ApplicationArea = Basic;
                }
                field(OptionCode; Rec."Option Code")
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

