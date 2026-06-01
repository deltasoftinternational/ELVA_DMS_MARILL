pageextension 25006650 "Blanket Sales Order" extends "Blanket Sales Order" //507
{
    layout
    {
        addafter("Foreign Trade")
        {
            group(Vehicle)
            {
                Caption = 'Vehicle';
                Visible = SparePartDocument;
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;
                }
                field(VehicleRegistrationNo; Rec."Vehicle Registration No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        xRec.Init();
        Rec."Responsibility Center" := UserMgt.GetSalesFilter;
        if (not DocNoVisible) and (Rec."No." = '') then
            Rec.SetSellToCustomerFromFilter;
        UpdateShipToBillToGroupVisibility;
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

    trigger OnOpenPage()
    begin
        if UserMgt.GetSalesFilter <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgt.GetSalesFilter);
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

    local procedure UpdateShipToBillToGroupVisibility()
    begin
        CustomerMgt.CalculateShipBillToOptions(ShipToOptions, BillToOptions, Rec);
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        DocNoVisible := DocumentNoVisibility.SalesDocumentNoIsVisible(DocType::"Blanket Order", rec."No.");
    end;

    var
        UserMgt: Codeunit "User Setup Management";
        CustomerMgt: Codeunit "Customer Mgt.";
        DocNoVisible: Boolean;

    Protected var
        VehicleTradeDocument: Boolean;
        SparePartDocument: Boolean;
        DocumentProfileFilter: Text[250];
}