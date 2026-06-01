Page 25006166 "Symptom Code List"
{
    PageType = List;
    SourceTable = "Symptom Code EDMS";
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(Name; Rec.Name)
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
                }
                field(Description3; Rec."Description 3")
                {
                    ApplicationArea = Basic;
                }
                field(SymptomGroup; Rec."Symptom Group")
                {
                    ApplicationArea = Basic;
                }
                field(SymptomGroupName; Rec."Symptom Group Name")
                {
                    ApplicationArea = Basic;
                }
                field(Common; Rec.Common)
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

