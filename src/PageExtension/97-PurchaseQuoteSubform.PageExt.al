pageextension 25006056 "Purchase Quote Subform" extends "Purchase Quote Subform"//97
{
    layout
    {
        addafter("No.")
        {
            field(HasReplacement; Rec."Has Replacement")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
        }
        addafter("VAT Prod. Posting Group")
        {
            field(ExternalServTrackingNo; Rec."External Serv. Tracking No.")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
        addafter("Line Discount %")
        {
            field(OrderingPriceTypeCode; Rec."Ordering Price Type Code")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
    }
    actions
    {
        addafter("Insert &Ext. Texts")
        {
            action(DataExchangeAction)
            {
                ApplicationArea = All;
                Caption = 'Data Exchange';
                Image = Change;

                trigger OnAction()
                begin
                    DataExchangeAct;
                end;
            }
        }
        addafter(EditInExcel)
        {
            action(ApplyReplacement)
            {
                ApplicationArea = Basic;
                Caption = 'Apply Replacement';
                Image = ItemSubstitution;

                trigger OnAction()
                var
                    ItemSubstSync: Codeunit "Item Substitution Sync";
                begin
                    //08.06.2016 EB.P7 #PAR28 >>
                    ItemSubstSync.ReplacePurchaseLineItemNo(Rec);
                    //08.06.2016 EB.P7 #PAR28 <<
                    CurrPage.Update;
                end;
            }
        }
    }
    var
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";

        IsSaaSExcelAddinEnabled: Boolean;
        SuppressTotals: Boolean;
        ItemNoAttention: Text[20];
        [InDataSet]
        ItemReferenceVisible: Boolean;

    trigger OnOpenPage()
    var
        ServerSetting: Codeunit "Server Setting";
    begin
        IsSaaSExcelAddinEnabled := ServerSetting.GetIsSaasExcelAddinEnabled();
        SuppressTotals := CurrentClientType() = ClientType::ODataV4;

        SetDimensionsVisibility();
        SetItemReferenceVisibility();

        //08.06.2016 EB.P7 #PAR28 >>
        CheckHasReplacement;
        //08.06.2016 EB.P7 #PAR28 <<
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

    local procedure SetItemReferenceVisibility()
    var
        ItemReference: Record "Item Reference";
    begin
        ItemReferenceVisible := not ItemReference.IsEmpty();
    end;


    local procedure CheckHasReplacement()
    begin
        if Rec."Has Replacement" then
            ItemNoAttention := 'Attention'
        else
            ItemNoAttention := '';
    end;

    local procedure ReturnLines(VAR PurchLine: Record "Purchase Line")
    var
        PurchLine2: Record "Purchase Line";
    begin
        PurchLine.RESET;
        PurchLine.COPYFILTERS(Rec);
        PurchLine2 := Rec;
        CurrPage.SETSELECTIONFILTER(PurchLine);
        Rec := PurchLine2;
    end;

    local procedure DataExchangeAct()
    var
        DocMgt: Codeunit DocumentManagementDMS;
        DataExchSelect: Record "Data Exch. Reports";
        PurchLine: Record "Purchase Line";
        PurchaseHeader: Record "Purchase Header";
    begin
        PurchLine.RESET;
        DocMgt.ChooseExcelReport(Rec."Document Profile", 1, 1, DataExchSelect);
        ReturnLines(PurchLine);
        //MESSAGE('There are selected:'+FORMAT(PurchLine.COUNT));
        PurchaseHeader.GET(Rec."Document Type", Rec."Document No.");
        DocMgt.SelectImportPurchHdr(DataExchSelect, PurchaseHeader, PurchLine);
    end;
}