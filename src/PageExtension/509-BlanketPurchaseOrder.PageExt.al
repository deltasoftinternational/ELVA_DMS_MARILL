pageextension 25006207 "Blanket Purchase Order" extends "Blanket Purchase Order"//509
{
    Var
        UserMgt: Codeunit "User Setup Management";
        DocNoVisible: Boolean;
        VehicleTradeDocument: Boolean;
        SparePartDocument: Boolean;
        DocumentProfileFilter: Text[250];

    trigger OnOpenPage()
    begin
        if UserMgt.GetPurchasesFilter <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgt.GetPurchasesFilter);
            Rec.FilterGroup(0);
        end;

        SetDocNoVisible;

        //EDMS >>
        Rec.FilterGroup(3);
        DocumentProfileFilter := Rec.GetFilter("Document Profile");
        Rec.FilterGroup(0);
        //EDMS <<
        //EDMS >>
        VehicleTradeDocument := Rec."Document Profile" = Rec."document profile"::"Vehicles Trade";
        SparePartDocument := Rec."Document Profile" = Rec."document profile"::"Spare Parts Trade";
        //EDMS >>
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter;
        if (not DocNoVisible) and (Rec."No." = '') then
            Rec.SetBuyFromVendorFromFilter;
        //EDMS >>
        case DocumentProfileFilter of
            Format(Rec."document profile"::"Vehicles Trade"):
                begin
                    Rec."Document Profile" := Rec."document profile"::"Vehicles Trade";
                    VehicleTradeDocument := true;
                end;
            Format(Rec."document profile"::"Spare Parts Trade"):
                begin
                    Rec."Document Profile" := Rec."document profile"::"Spare Parts Trade";
                    SparePartDocument := true;
                end;
        end;
        //EDMS >>
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        DocNoVisible := DocumentNoVisibility.PurchaseDocumentNoIsVisible(DocType::"Blanket Order", REc."No.");
    end;
}