Page 25006461 "Veh. Order Promising Setup"
{
    ApplicationArea = Basic;
    Caption = 'Veh. Order Promising Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Veh. Order Promising Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(OrderPromisingNos; Rec."Order Promising Nos.")
                {
                    ApplicationArea = Basic;
                }
                field(OrderPromisingTemplate; Rec."Order Promising Template")
                {
                    ApplicationArea = Basic;
                }
                field(OrderPromisingWorksheet; Rec."Order Promising Worksheet")
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

