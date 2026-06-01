Page 25006491 "Manufacturer Option Conditions"
{
    AutoSplitKey = true;
    Caption = 'Manufacturer Option Conditions';
    DataCaptionExpression = Rec."Option Code";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Manufacturer Option Condition";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
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
                field(OptionType; Rec."Option Type")
                {
                    ApplicationArea = Basic;
                }
                field(OptionCode; Rec."Option Code")
                {
                    ApplicationArea = Basic;
                }
                field(OptionDescription; Rec."Option Description")
                {
                    ApplicationArea = Basic;
                }
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(OptionExternalCode; Rec."Option External Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ConditionType; Rec."Condition Type")
                {
                    ApplicationArea = Basic;
                }
                field(ConditionOptionType; Rec."Condition Option Type")
                {
                    ApplicationArea = Basic;
                }
                field(ConditionOptionCode; Rec."Condition Option Code")
                {
                    ApplicationArea = Basic;
                }
                field(ConditionOptionDescription; Rec."Condition Option Description")
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

