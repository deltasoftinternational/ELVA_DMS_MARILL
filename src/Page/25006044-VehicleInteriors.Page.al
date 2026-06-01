Page 25006044 "Vehicle Interiors"
{
    ApplicationArea = Basic;
    Caption = 'Vehicle Interiors';
    PageType = List;
    PopulateAllFields = true;
    SourceTable = "Vehicle Interior";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1190000)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
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

