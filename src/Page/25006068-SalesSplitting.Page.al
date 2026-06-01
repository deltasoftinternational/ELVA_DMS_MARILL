Page 25006068 "Sales Splitting"
{
    Caption = 'Sales Splitting';
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Sales Splitting Line";
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
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field(QuantityShare; Rec."Quantity Share %")
                {
                    ApplicationArea = Basic;
                }
                field(AmountShare; Rec."Amount Share %")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(NewAmount; Rec."New Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
            }
            part(Control1101904002; "Sales Spliting Lines SubForm")
            {
                ApplicationArea = All;
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("Document No."),
                              "Temp. Document No." = field("Temp. Document No.");
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("<Action1101904006>")
            {
                ApplicationArea = Basic;
                Caption = 'New document';
                Image = NewDocument;
                Promoted = true;

                trigger OnAction()
                begin
                    SalesSplittingHeaderTmp := Rec;
                    Rec.ApplyInsertAsWholeDoc;
                    ApplyFilter2(SalesSplittingHeaderTmp);
                    Rec.FindLast;
                end;
            }
        }
        area(processing)
        {
            action(Split)
            {
                ApplicationArea = Basic;
                Caption = 'Split';
                Image = Apply;
                Promoted = true;

                trigger OnAction()
                begin
                    //at first do compare values
                    DiffAmt := Rec.CheckDocTotalAmount(SrcAmt, DstAmt);
                    GLSetup.Get;
                    if DiffAmt <> 0 then
                        if not Confirm(StrSubstNo(Text104, SrcAmt, DstAmt, GLSetup."LCY Code"), true) then
                            exit;
                    Rec.ProceedDocSplit;
                    CurrPage.Close;
                end;
            }
        }
    }

    trigger OnClosePage()
    begin
        SalesSplittingLine.SetRange(Line, false);
        SalesSplittingLine.SetRange("Document Type", Rec."Document Type");
        SalesSplittingLine.SetRange("Document No.", Rec."Document No.");
        if SalesSplittingLine.FindFirst then begin
            if Confirm(Text103, true) then begin
                Rec.DeleteDocSplit;
            end;
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
        SalesSplittingLine: Record "Sales Splitting Line";
        SalesSplittingHeaderTmp: Record "Sales Splitting Line" temporary;
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
        Rec.SetRange("Document Type", rec."Document Type");
        Rec.SetRange("Document No.", rec."Document No.");
    end;


    procedure ApplyFilter2(SalesSplittingLinePar: Record "Sales Splitting Line")
    var
        ServiceSplittingLineTmpL: Record "Service Splitting Line";
    begin
        Rec.SetRange(Line, false);
        Rec.SetRange("Document Type", SalesSplittingLinePar."Document Type");
        Rec.SetRange("Document No.", SalesSplittingLinePar."Document No.");
    end;


    procedure CreateSpliting(var SalesHeaderPar: Record "Sales Header")
    begin
        SalesSplittingLine.Reset;
        SalesSplittingLine.SetRange(Line, false);
        SalesSplittingLine.SetRange("Document Type", SalesHeaderPar."Document Type".AsInteger());
        SalesSplittingLine.SetRange("Document No.", SalesHeaderPar."No.");
        if not SalesSplittingLine.FindFirst then
            Rec.ApplyInsertAsHeaderByDoc(SalesHeaderPar."Document Type".AsInteger(), SalesHeaderPar."No.");
        if SalesSplittingLine.FindFirst then begin
            Rec.Get(SalesSplittingLine."Document Type", SalesSplittingLine."Document No.",
              SalesSplittingLine."Temp. Document No.", SalesSplittingLine.Line, SalesSplittingLine."Temp. Line No.");
        end;
        ApplyFilter;
    end;
}

