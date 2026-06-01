Page 25006648 "Rent Asset Status Change Log"
{
    Caption = 'Rent Asset Status Change Log';
    Editable = false;
    PageType = List;
    SourceTable = "Rent Asset Status Change Log";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(RentAssetNo; Rec."Rent Asset No.")
                {
                    ApplicationArea = Basic;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                }
                field(PreviosStatus; Rec."Previos Status")
                {
                    ApplicationArea = Basic;
                }
                field(NewStatus; Rec."New Status")
                {
                    ApplicationArea = Basic;
                }
                field(UserID; Rec."User ID")
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

