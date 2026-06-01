Page 25006853 "Lost Sales Setup"
{
    ApplicationArea = Basic;
    Caption = 'Lost Sales Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Lost Sales Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(AutomaticRegistration)
            {
                Caption = 'Automatic Registration';
                field(OnServiceDocDeletion; Rec."On Service Doc. Deletion")
                {
                    ApplicationArea = Basic;
                }
                field(OnSalesDocDeletion; Rec."On Sales Doc. Deletion")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
    end;
}

