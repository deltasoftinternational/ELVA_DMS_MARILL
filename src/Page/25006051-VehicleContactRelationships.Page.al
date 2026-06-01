Page 25006051 "Vehicle-Contact Relationships"
{
    Caption = 'Vehicle-Contact Relationships';
    PageType = List;
    SourceTable = "Vehicle-Contact Relationship";

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
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(DoNotUseInService; Rec."Do Not Use In Service")
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

