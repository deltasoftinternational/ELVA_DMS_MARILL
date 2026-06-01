Page 25006259 "Service Splitting"
{
    // 06.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Changed Visible and Editable properties of some fields
    // 
    // 22.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Commented in trigger:
    //     OnClosePage()
    // 
    // 04.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Commented in trigger:
    //     <Action1101904014> - OnAction() (Split)
    // 
    // 05.01.2012 EDMS P8
    //   * Is not supported amount changes, but only quantity

    Caption = 'Service Splitting';
    InsertAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Service Splitting Line";
    SourceTableView = sorting("Document Type", "Document No.", "Temp. Document No.", Line, "Temp. Line No.")
                      order(ascending)
                      where("Document Type" = const(Order),
                            Line = const(false));

    layout
    {
        area(content)
        {

            repeater(Headers)
            {
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                    Visible = false;
                }
                field(TempDocumentNo; Rec."Temp. Document No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(SelltoCustomerNo; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoCustomerNo; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(QuantityShare; Rec."Quantity Share %")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(AmountShare; Rec."Amount Share %")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(DocumentAmount; Rec."Document Amount")
                {
                    ApplicationArea = Basic;
                }
            }

            part(Control1101904002; "Service Spliting Lines SubForm")
            {
                ApplicationArea = All;
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("Document No."),
                              "Temp. Document No." = field("Temp. Document No.");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                action(NewDocument)
                {
                    ApplicationArea = Basic;
                    Caption = 'New document';
                    Image = NewDocument;

                    trigger OnAction()
                    begin
                        ServiceSplittingHeaderTmp := Rec;
                        Rec.ApplyInsertAsWholeDoc;
                        ApplyFilter2(ServiceSplittingHeaderTmp);
                        Rec.FindLast;
                    end;
                }
                action(Split)
                {
                    ApplicationArea = Basic;
                    Caption = 'Split';
                    Image = Apply;

                    trigger OnAction()
                    begin
                        // 04.04.2014 Elva Baltic P21 >>
                        /*
                        //at first do compare values
                        DiffAmt := CheckDocTotalAmount(SrcAmt, DstAmt);
                        GLSetup.GET;
                        IF DiffAmt <> 0 THEN
                          IF NOT CONFIRM(STRSUBSTNO(Text104, SrcAmt, DstAmt, GLSetup."LCY Code"), TRUE) THEN
                            EXIT;
                        */
                        // 04.04.2014 Elva Baltic P21 <<

                        Rec.ProceedDocSplit;
                        CurrPage.Close;

                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(New_Document; NewDocument)
                {
                }
                actionref(Plit_Document; Split)
                {
                }
            }
        }
    }

    trigger OnClosePage()
    begin
        ServiceSplittingLine.SetRange(Line, false);
        ServiceSplittingLine.SetRange("Document Type", Rec."Document Type");
        ServiceSplittingLine.SetRange("Document No.", Rec."Document No.");
        if ServiceSplittingLine.FindFirst then begin
            // IF CONFIRM(Text103, TRUE) THEN BEGIN                             // 22.04.2014 Elva Baltic P21
            Rec.DeleteDocSplit;
            // END;                                                             // 22.04.2014 Elva Baltic P21
        end;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        //ApplyFilter;
    end;

    trigger OnOpenPage()
    begin
        Rec.CreateSpliting;
    end;

    var
        ServiceSplittingLine: Record "Service Splitting Line";
        ServiceSplittingHeaderTmp: Record "Service Splitting Line" temporary;
        FilterText: Text[250];
        GLSetup: Record "General Ledger Setup";
        SrcAmt: Decimal;
        DstAmt: Decimal;
        DiffAmt: Decimal;
        Text103: label 'Would you like to delete created split prepare lines?';
        Text104: label 'There is difference in amounts: in source document %1 %3, in split %2 %3. Are you sure to continue?';


    procedure ApplyFilter()
    var
        ServiceSplittingLineTmpL: Record "Service Splitting Line";
    begin
        Rec.SetRange(Line, false);
        Rec.SetRange("Document Type", Rec."Document Type");
        Rec.SetRange("Document No.", Rec."Document No.");
    end;


    procedure ApplyFilter2(ServiceSplittingLinePar: Record "Service Splitting Line")
    var
        ServiceSplittingLineTmpL: Record "Service Splitting Line";
    begin
        Rec.SetRange(Line, false);
        Rec.SetRange("Document Type", ServiceSplittingLinePar."Document Type");
        Rec.SetRange("Document No.", ServiceSplittingLinePar."Document No.");
    end;


    procedure CreateSpliting(var ServiceHeaderPar: Record "Service Header EDMS")
    begin
        ServiceSplittingLine.Reset;
        ServiceSplittingLine.SetRange(Line, false);
        ServiceSplittingLine.SetRange("Document Type", ServiceHeaderPar."Document Type");
        ServiceSplittingLine.SetRange("Document No.", ServiceHeaderPar."No.");
        if not ServiceSplittingLine.FindFirst then
            Rec.ApplyInsertAsHeaderByServDoc(ServiceHeaderPar."Document Type", ServiceHeaderPar."No.");
        if ServiceSplittingLine.FindFirst then begin
            Rec.Get(ServiceSplittingLine."Document Type", ServiceSplittingLine."Document No.",
              ServiceSplittingLine."Temp. Document No.", ServiceSplittingLine.Line, ServiceSplittingLine."Temp. Line No.");
        end;
        ApplyFilter;
    end;
}

