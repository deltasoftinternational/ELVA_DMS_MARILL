Page 25006084 "Deal Document Application"
{
    Caption = 'Deal Document Application';
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Deal Application Entry";

    layout
    {
        area(content)
        {
            field(DocType; DocType)
            {
                ApplicationArea = Basic;
                Caption = 'Document Type';
                Editable = false;
            }
            field(DocNo; DocNo)
            {
                ApplicationArea = Basic;
                Caption = 'Document No.';
                Editable = false;
            }
            field(Descr; Descr)
            {
                ApplicationArea = Basic;
                Caption = 'Description';
                Editable = false;
            }
            field(Amount; Amount)
            {
                ApplicationArea = Basic;
                Caption = 'Amount';
                Editable = false;
            }
            field(CurrCode; CurrCode)
            {
                ApplicationArea = Basic;
                Caption = 'Currency Code';
                Editable = false;
            }
            repeater(Control1190000)
            {
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(LineNo; Rec."Doc. Line No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Line No.';
                    Editable = false;
                }
                field(LineDescr; LineDescr)
                {
                    ApplicationArea = Basic;
                    Caption = 'Description';
                    Editable = false;
                }
                field(LineCurrCode; LineCurrCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Currency Code';
                    Editable = false;
                }
                field(LineAmount; LineAmount)
                {
                    ApplicationArea = Basic;
                    Caption = 'Line Amount';
                    Editable = false;
                }
                field(Application; Rec.Application)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action(FindDocuments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Find Documents';
                    Image = Find;
                    Promoted = true;
                    ShortCutKey = 'Ctrl+F';

                    trigger OnAction()
                    begin
                        Rec.FindDocs(DealApplEntry)
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Rec."Det. Cust. Ledg. Entry EDMS" = 0 then begin
            SalesLine.Get(Rec."Document Type", Rec."Document No.", Rec."Doc. Line No.");
            LineDescr := SalesLine.Description;
            if SalesLine."Amount Including VAT" = 0 then
                LineAmount := SalesLine."Line Amount"
            else
                LineAmount := SalesLine."Amount Including VAT";
            LineCurrCode := SalesLine."Currency Code";
        end else begin
            DCLedgEntry.Get(Rec."Det. Cust. Ledg. Entry EDMS");
            //CustLedgEntry.GET(DCLedgEntry."Cust. Ledger Entry No.");
            LineDescr := DCLedgEntry.Description;
            LineAmount := DCLedgEntry.Amount;
            LineCurrCode := ''
        end
    end;

    trigger OnClosePage()
    begin
        DealApplEntry.Copy(Rec);
        //DealApplEntry.SETRANGE("Entry No.");
        DealApplEntry.SetRange(Application, true);
        if DealApplEntry.Count > 1 then begin
            DealApplEntry.SetRange(Application, false)
        end else
            DealApplEntry.SetRange(Application);
        DealApplEntry.DeleteAll
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Applies-to Entry No." := DealApplEntry."Applies-to Entry No."
    end;

    trigger OnOpenPage()
    begin
        DealApplEntry.InitApplication(DealType, DCLedgEntryNo, DocType, DocNo, DocLineNo);
        Rec.SetCurrentkey("Applies-to Entry No.");
        Rec.SetRange("Applies-to Entry No.", DealApplEntry."Applies-to Entry No.");

        //SETFILTER("Entry No.",'<>%1',DealApplEntry."Entry No.");

        FillFields;
    end;

    var
        DCLedgEntryNo: Integer;
        DealType: Option " ",Leasing;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Posted Invoice","Posted C.Memo";
        DocNo: Code[20];
        DocLineNo: Integer;
        Amount: Decimal;
        DealApplEntry: Record "Deal Application Entry";
        Descr: Text[50];
        LineDescr: Text[50];
        LineAmount: Decimal;
        SalesLine: Record "Sales Line";
        DCLedgEntry: Record "Cust. Ledg. Entry Link";
        LineCurrCode: Code[10];
        CustLedgEntry: Record "Cust. Ledger Entry";
        CurrCode: Code[10];


    procedure SetApplication(NewType: Option " ",Leasing; NewDCLedgEntryNo: Integer; NewDocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; NewDocNo: Code[20]; NewDocLineNo: Integer)
    begin
        DealType := NewType;
        DCLedgEntryNo := NewDCLedgEntryNo;
        DocType := NewDocType;
        DocNo := NewDocNo;
        DocLineNo := NewDocLineNo
    end;


    procedure FillFields()
    begin
        if DCLedgEntryNo = 0 then begin
            if SalesLine.Get(DocType, DocNo, DocLineNo) then begin
                Descr := SalesLine.Description;
                if SalesLine."Amount Including VAT" = 0 then
                    Amount := SalesLine."Line Amount"
                else
                    Amount := SalesLine."Amount Including VAT";
                CurrCode := SalesLine."Currency Code"
            end
        end else begin
            DCLedgEntry.Get(DCLedgEntryNo);
            CustLedgEntry.Get(DCLedgEntry."Cust. Ledger Entry No.");
            Descr := DCLedgEntry.Description;
            DocType := DCLedgEntry."Document Type";
            DocNo := DCLedgEntry."Document No.";
            Amount := DCLedgEntry.Amount;
            CurrCode := CustLedgEntry."Currency Code"
        end
    end;
}

