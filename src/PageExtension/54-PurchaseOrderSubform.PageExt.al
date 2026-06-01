pageextension 25006051 "Purchase Order Subform" extends "Purchase Order Subform"//54
{
    layout
    {
        addafter("FA Posting Date")
        {
            field(ExternalServTrackingNo; Rec."External Serv. Tracking No.")
            {
                ApplicationArea = Basic;
                Visible = True;
            }
        }
    }
    actions
    {
        addafter(OrderTracking)
        {
            action(TransferLines)
            {
                ApplicationArea = All;
                Caption = 'Transfer Lines';
                Image = Change;
                trigger OnAction()
                var
                    PurchaseLineLoc: Record "Purchase Line";
                    RepTransferLines: Report "Purch. Order-Transfer Line";
                BEGIN
                    //24.10.2013 EDMS P8
                    CurrPage.SETSELECTIONFILTER(PurchaseLineLoc);
                    IF CONFIRM(Text002, FALSE, PurchaseLineLoc.COUNT) THEN BEGIN
                        // 19.03.2014 P18 >>
                        RepTransferLines.SETTABLEVIEW(PurchaseLineLoc);
                        RepTransferLines.SetParams(PurchaseLineLoc);
                        RepTransferLines.RUN;
                    END;
                    //REPORT.RUNMODAL(REPORT::"Purch. Order-Transfer Line",TRUE,FALSE, PurchaseLineLoc);
                    // 19.03.2014 P18 <<
                END;
            }
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
    }
    var
        Text002: Label 'You have selected %1 record lines.';

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