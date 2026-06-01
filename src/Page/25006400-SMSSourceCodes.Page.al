Page 25006400 "SMS Source Codes"
{
    Caption = 'SMS Source Codes';
    PageType = List;
    SourceTable = "SMS Source Code";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(ExpirationTimeMin; Rec."Expiration Time (Min.)")
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

