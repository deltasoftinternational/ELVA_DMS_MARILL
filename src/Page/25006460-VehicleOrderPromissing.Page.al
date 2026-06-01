Page 25006460 "Vehicle Order Promissing"
{
    Caption = 'Vehicle Order Promissing';
    Editable = false;
    PageType = Card;
    SourceTable = "Sales Line";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                }
                field(ModelCode; Rec."Model Code")
                {
                    ApplicationArea = Basic;
                }
                field(ModelVersionNo; Rec."Model Version No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: action): Boolean
    var
        VehOrderPromising: Codeunit "Vehicle Order Promising";
    begin
        if CloseAction in [Action::OK, Action::LookupOK] then begin
            SalesHeader.Get(Rec."Document Type", Rec."Document No.");
            Rec.CalcFields(Reserved);
            if not ((SalesHeader.Status = SalesHeader.Status::Open) and not Rec.Reserved) then
                Error(Text001);
            VehOrderPromising.CreateReqLine(Rec);
        end;
    end;

    var
        SalesHeader: Record "Sales Header";
        Text001: label 'Either the document is not opened or vehicle had promised already.';
}

