Page 25006408 "Warranty Setup"
{
    ApplicationArea = Basic;
    Caption = 'Warranty Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Warranty Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(WarrantyDocumentNos; Rec."Warranty Document Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to service warranty documents.';
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

