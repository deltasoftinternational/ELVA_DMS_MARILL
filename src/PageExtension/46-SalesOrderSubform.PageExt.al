pageextension 25006020 "Sales Order Subform" extends "Sales Order Subform" //46
{
    layout
    {
        modify("No.")
        {
            Visible = false;
        }
        addafter("No.")
        {
            field("DMSNo."; Rec."No.")
            {
                ApplicationArea = Basic, Suite;
                ShowMandatory = TypeChosen;
                StyleExpr = ItemNoAttention;
                ToolTip = 'Specifies the number of a general ledger account, item, resource, additional cost, or fixed asset, depending on the contents of the Type field.';

                trigger OnAssistEdit()
                begin
                    Rec.NoAssistEdit //EDMS
                end;

                trigger OnLookup(var Text: Text): Boolean
                var
                    Item: Record Item;
                    ExternalService: Record "External Service";
                    GLAccount: Record "G/L Account";
                    StandardText: Record "Standard Text";
                    FixedAsset: Record "Fixed Asset";
                    ItemCharge: Record "Item Charge";
                    Resource: Record Resource;
                begin
                    case Rec.Type of
                        Rec.Type::" ":
                            begin
                                StandardText.Reset;
                                if LookUpMgt.LookUpStandardText(StandardText, Rec."No.") then
                                    Rec.Validate("No.", StandardText.Code);
                            end;

                        Rec.Type::"G/L Account":
                            begin
                                GLAccount.Reset;
                                if LookUpMgt.LookUpGLAccount(GLAccount, Rec."No.") then
                                    Rec.Validate("No.", GLAccount."No.");
                            end;

                        Rec.Type::Item:
                            begin
                                Item.Reset;
                                if Rec."Line Type" = Rec."line type"::Vehicle then begin
                                    if LookUpMgt.LookUpModelVersion(Item, Rec."No.", Rec."Make Code", Rec."Model Code") then
                                        Rec.Validate("No.", Item."No.")
                                end else begin
                                    if LookUpMgt.LookUpItemREZ(Item, Rec."No.") then
                                        Rec.Validate("No.", Item."No.");
                                end;
                            end;

                        Rec.Type::Resource:
                            begin
                                Resource.Reset;
                                if LookUpMgt.LookUpResource(Resource, Rec."No.") then
                                    Rec.Validate("No.", Resource."No.");
                            end;

                        Rec.Type::"Fixed Asset":
                            begin
                                FixedAsset.Reset;
                                if LookUpMgt.LookUpFixedAsset(FixedAsset, Rec."No.") then
                                    Rec.Validate("No.", FixedAsset."No.");
                            end;

                        Rec.Type::"Charge (Item)":
                            begin
                                ItemCharge.Reset;
                                if LookUpMgt.LookUpItemCharges_Sale(ItemCharge, Rec."No.") then
                                    Rec.Validate("No.", ItemCharge."No.");
                            end;

                        Rec.Type::"External Service":
                            begin
                                ExternalService.Reset;
                                if LookUpMgt.LookUpExternalService(ExternalService, Rec."No.") then
                                    Rec.Validate("No.", ExternalService."No.");
                            end;
                    end;
                    CurrPage.Update;
                end;

                trigger OnValidate()
                begin
                    NoOnAfterValidate();
                    UpdateEditableOnRow();
                    Rec.ShowShortcutDimCode(ShortcutDimCode);

                    QuantityOnAfterValidate();
                    UpdateTypeText();
                    DeltaUpdateTotals();

                end;
            }
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
        modify("Reserved Quantity")
        {
            StyleExpr = StyleTxt;
        }
        addafter("Unit Cost (LCY)")
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
        addafter("Select Nonstoc&k Items")
        {
            action(RegisterLostSale)
            {
                ApplicationArea = All;
                Caption = 'Register Lost Sale';
                Image = Register;
                trigger OnAction()
                begin
                    Rec.RegLostSales
                end;
            }
            action(MoveLines)
            {
                ApplicationArea = Basic;
                Caption = 'Move Lines';
                Image = MoveUp;

                trigger OnAction()
                var
                    SalesLine: Record "Sales Line";
                begin
                    CurrPage.SETSELECTIONFILTER(SalesLine);
                    Rec.MoveLines(SalesLine);
                end;
            }
            action(ReplacementOverview)
            {
                ApplicationArea = Basic;
                Caption = 'Replacement Overview';
                Image = ItemSubstitution;

                trigger OnAction()
                var
                    Item: Record Item;
                    ItemSubstSync: Codeunit "Item Substitution Sync";
                    TypePar: Option Item,"Nonstock Item";
                begin
                    IF Rec.Type = Rec.Type::Item THEN BEGIN
                        Item.GET(Rec."No.");
                        ItemSubstSync.ShowReplacementOverview(TypePar::"Nonstock Item", Item.GetSourceNonstockEntryNo(), '');
                    END;
                end;
            }
        }
        addafter(DocAttach)
        {
            action(ForceBackOrder)
            {
                ApplicationArea = Basic;
                Caption = 'Force Backorder';

                trigger OnAction()
                begin

                    CreateReqLines.CreateReqLineFromSalesLine(Rec);
                end;
            }
        }
        modify(AssembleToOrderLines)
        {
            Visible = false;
        }
        addafter(AssembleToOrderLines)
        {
            action(DMSAssembleToOrderLines)
            {
                AccessByPermission = TableData "BOM Component" = R;
                ApplicationArea = Assembly;
                Caption = 'Assemble-to-Order Lines';
                Image = CheckList;
                ToolTip = 'View any linked assembly order lines if the documents represents an assemble-to-order sale.';

                trigger OnAction()
                begin
                    Rec.ShowAsmToOrderLines();
                end;
            }
        }
        modify("Roll Up &Price")
        {
            Visible = false;
        }
        addafter("Roll Up &Price")
        {
            action("DMS Roll Up &Price")
            {
                AccessByPermission = TableData "BOM Component" = R;
                ApplicationArea = Assembly;
                Caption = 'Roll Up &Price';
                Ellipsis = true;
                Image = RollUpCosts;
                ToolTip = 'Update the unit price of the assembly item according to any changes that you have made to the assembly components.';

                trigger OnAction()
                begin
                    Rec.RollupAsmPrice();
                end;
            }
        }
        modify("Roll Up &Cost")
        {
            Visible = false;
        }
        addafter("Roll Up &Cost")
        {
            action("DMS Roll Up &Cost")
            {
                AccessByPermission = TableData "BOM Component" = R;
                ApplicationArea = Assembly;
                Caption = 'Roll Up &Cost';
                Ellipsis = true;
                Image = RollUpCosts;
                ToolTip = 'Update the unit cost of the assembly item according to any changes that you have made to the assembly components.';

                trigger OnAction()
                begin
                    Rec.RollUpAsmCost();
                end;
            }
        }
        addafter("O&rder")
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
                    //10.05.2016 EB.P7 #PAR_28 >>
                    ItemSubstSync.ReplaceSalesLineItemNo(Rec);
                    //10.05.2016 EB.P7 #PAR_28 <<
                    CurrPage.Update;
                end;
            }
        }
    }
    trigger OnDeleteRecord(): Boolean
    var
        SalesLineReserve: Codeunit "Sales Line-Reserve";
    begin
        // if (Rec.Quantity <> 0) and Rec.ItemExists(Rec."No.") then begin
        //     Commit();
        //     if not SalesLineReserve.DeleteLineConfirm(Rec) then
        //         exit(false);

        //     OnBeforeDeleteReservationEntries(Rec);
        //     SalesLineReserve.DeleteLine(Rec);
        // end;
        LostSalesMgt.OnSalesLineDelete(Rec); //EDMS
        DocumentTotals.SalesDocTotalsNotUpToDate();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        //11.05.2016 EB.P7 #PAR_28 >>
        CheckHasReplacement;
        //11.05.2016 EB.P7 #PAR_28 <<
        DocumentTotals.SalesCheckIfDocumentChanged(Rec, xRec);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        SalesHeader: Record "Sales Header";
    begin
        Rec.InitType();
        //18.06.2021 EB.P7 >>
        if Rec."Document No." <> '' then
            if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then
                Rec."Document Profile" := SalesHeader."Document Profile";
        //18.06.2021 EB.P7 <<

        Clear(ShortcutDimCode);
        UpdateTypeText();
    end;

    trigger OnOpenPage()
    var
        ServerSetting: Codeunit "Server Setting";
        PriceCalculationMgt: Codeunit "Price Calculation Mgt.";
        Location: Record Location;
    begin
        Rec.AddLoadFields(
            "Price Calculation Method", "Sell-to Customer No.", "Customer Disc. Group", "Customer Price Group",
            "VAT %", "VAT Calculation Type", "VAT Bus. Posting Group", "VAT Prod. Posting Group",
            "Dimension Set ID", "Currency Code", "Qty. per Unit of Measure", "Allow Line Disc.");

        if Location.ReadPermission then
            LocationCodeVisible := not Location.IsEmpty();

        IsSaaSExcelAddinEnabled := ServerSetting.GetIsSaasExcelAddinEnabled();
        LSuppressTotals := CurrentClientType() = ClientType::ODataV4;
        ExtendedPriceEnabled := PriceCalculationMgt.IsExtendedPriceCalculationEnabled();

        SetDimensionsVisibility();
        SetItemReferenceVisibility();

        Clear(DocumentTotals);
        StyleTxt := Rec.GetReservationColor;                                  // 12.05.2014 Elva Baltic P21 #S0104 MMG7.00

        //11.05.2016 EB.P7 #PAR_28 >>
        CheckHasReplacement;
        //11.05.2016 EB.P7 #PAR_28 <<
    end;

    Var
        [InDataSet]
        ItemPanelVisible: Boolean;
        LostSalesMgt: Codeunit "Lost Sales Management";
        DocumentTotals: Codeunit "Document Totals";
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";


        StyleTxt: Text[30];
        TypeChosen: Boolean;
        TotalAmountStyle: Text;
        RefreshMessageEnabled: Boolean;
        RefreshMessageText: Text;
        ItemNoAttention: Text[20];
        LookUpMgt: Codeunit LookUpManagement;
        LocationCodeVisible: Boolean;
        IsSaaSExcelAddinEnabled: Boolean;
        ExtendedPriceEnabled: Boolean;

    protected var

        LSuppressTotals: Boolean;
        CreateReqLines: Codeunit "Capable to Promise EDMS";

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

}