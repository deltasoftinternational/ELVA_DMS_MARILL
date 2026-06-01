pageextension 25006470 "Transfer Order Subform" extends "Transfer Order Subform" //5741
{
    layout
    {
        modify("Reserved Quantity Outbnd.")
        {
            StyleExpr = StyleTxt;
        }
        addafter("ShortcutDimCode[8]")
        {
            field(FromLocationDimension1Code; Rec."From Location Dimension 1 Code")
            {
                ApplicationArea = Basic;
            }
            field(FromLocationDimension2Code; Rec."From Location Dimension 2 Code")
            {
                ApplicationArea = Basic;
            }
            field(ToLocationDimension1Code; Rec."To Location Dimension 1 Code")
            {
                ApplicationArea = Basic;
            }
            field(ToLocationDimension2Code; Rec."To Location Dimension 2 Code")
            {
                ApplicationArea = Basic;
            }
            field(DerivedFromLineNo; Rec."Derived From Line No.")
            {
                ApplicationArea = Basic;
            }
        }
    }
    actions
    {
        //DELTA PROMISE
        addafter("Item &Tracking Lines")
        {
            action(CreateOrderPromising)
            {
                ApplicationArea = Basic;
                Caption = 'Create Order Promising';
                Image = CreateInventoryPickup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TransferHeader.Get(Rec."Document No.");
                    CapabletoPromise.CreateReqLinesFromTransfer(TransferHeader, true, Rec."Line No.");
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        SetDimensionsVisibility;

    end;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := REC.GetReservationColor;
    end;

    local procedure SetDimensionsVisibility()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimVisible1 := false;
        DimVisible2 := false;
        DimVisible3 := false;
        DimVisible4 := false;
        DimVisible5 := false;
        DimVisible6 := false;
        DimVisible7 := false;
        DimVisible8 := false;

        DimMgt.UseShortcutDims(
          DimVisible1, DimVisible2, DimVisible3, DimVisible4, DimVisible5, DimVisible6, DimVisible7, DimVisible8);

        Clear(DimMgt);
    end;


    procedure CheckDocumentProfile()
    begin
        TransferHeader.Get(Rec."Document No.");
        if TransferHeader."Document Profile" = TransferHeader."document profile"::Service then
            Error(Text001);
    end;

    Var
        StyleTxt: Text[30];
        CapabletoPromise: Codeunit "Service Transfer Mgt.";
        TransferHeader: Record "Transfer Header";
        Text001: label 'You can''t insert Transfer Line if Document Profile is Service!';
        Text002: label 'You have selected %1 record lines.';
}