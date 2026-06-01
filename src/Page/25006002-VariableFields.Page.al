Page 25006002 "Variable Fields"
{
    ApplicationArea = Basic;
    Caption = 'Variable Fields';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Variable Field";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field("Code"; rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(Caption; rec.Caption)
                {
                    ApplicationArea = Basic;
                }
                field(MakeDependentLookup; rec."Make Dependent Lookup")
                {
                    ApplicationArea = Basic;
                }
                field(VariableFieldGroupCode; rec."Variable Field Group Code")
                {
                    ApplicationArea = Basic;
                }
                field(UseInFiltering; rec."Use In Filtering")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(VariableField)
            {
                Caption = 'Variable Field';
                action(Options)
                {
                    ApplicationArea = Basic;
                    Caption = 'Options';
                    Image = CheckList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Variable Field Options";
                    RunPageLink = "Variable Field Code" = field(Code);
                }
                action(Translations)
                {
                    ApplicationArea = Basic;
                    Caption = 'Translations';
                    Image = Translations;
                    RunObject = Page "Variable Field Translations";
                    RunPageLink = "Variable Field Code" = field(Code);
                }
            }
        }
    }
}

