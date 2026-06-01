table 25006758 "BLS Leasing Schedule Line"
{


    fields
    {
        field(10; "Leasing Schedule No."; Code[20])
        {
            Caption = 'Leasing Schedule No.';
            TableRelation = "BLS Leasing Schedule Header"."No.";
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(110; "Payment Date"; Date)
        {
            Caption = 'Payment Date';
        }

        field(330; "Add. Service Amount Incl. VAT"; Decimal)
        {
            Caption = 'Add. Service Amount Incl. VAT';
        }

        field(490; "Begining Balance"; Decimal)
        {
            Caption = 'Begining Balance';
        }
        field(500; "Ending Balance"; Decimal)
        {
            Caption = 'Ending Balance';
        }
        field(600; "Base Amount"; Decimal)
        {
            Caption = 'Base Amount';
        }
        field(610; "Interest Amount"; Decimal)
        {
            Caption = 'Interest Amount';
        }
        field(611; "Lease Amount"; Decimal)
        {
            Caption = 'Total Amount';
        }
        field(615; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
        }
        field(620; "Sales Document No."; Code[20])
        {
            CalcFormula = lookup("Sales Line"."Document No." where("Leasing Schedule No." = field("Leasing Schedule No."),
                                                                           "Leasing Schedule Line No." = field("Line No.")));
            Caption = 'Sales Document No.';
            FieldClass = FlowField;
        }

        field(630; "Sales Document Type"; Enum "Sales Document Type")
        {
            CalcFormula = lookup("Sales Line"."Document Type" where("Leasing Schedule No." = field("Leasing Schedule No."),
                                                                           "Leasing Schedule Line No." = field("Line No.")));
            Caption = 'Sales Document Type';
            FieldClass = FlowField;
        }
        field(640; "Sales Invoice No."; Code[20])
        {
            CalcFormula = lookup("Sales Invoice Line"."Document No." where("Leasing Schedule No." = field("Leasing Schedule No."),
                                                                           "Leasing Schedule Line No." = field("Line No.")));
            Caption = 'Sales Invoice No.';
            FieldClass = FlowField;
        }
        field(650; "Sales Credit Memo No."; Code[20])
        {
            CalcFormula = lookup("Sales Cr.Memo Line"."Document No." where("Leasing Schedule No." = field("Leasing Schedule No."),
                                                                           "Leasing Schedule Line No." = field("Line No.")));
            Caption = 'Sales Credit Memo No.';
            FieldClass = FlowField;
        }

    }

    keys
    {
        key(Key1; "Leasing Schedule No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    var
        BLSLeasingScheduleHeader: Record "BLS Leasing Schedule Header";
    begin
        BLSLeasingScheduleHeader.Get("Leasing Schedule No.");
        BLSLeasingScheduleHeader.TESTFIELD(Status, BLSLeasingScheduleHeader.Status::Open);

    end;

    procedure CalcTotals()
    begin

        "Total Amount" := "Lease Amount" + "Add. Service Amount Incl. VAT";
    end;


    procedure CreateNewSchedule()
    var
        LeasingSchedule: Record "BLS Leasing Schedule Header";
        NewLeasingSchedule: Record "BLS Leasing Schedule Header";
    begin
        TESTFIELD("Leasing Schedule No.");
        TESTFIELD("Line No.");
        LeasingSchedule.GET("Leasing Schedule No.");

        NewLeasingSchedule := LeasingSchedule;
        NewLeasingSchedule.Status := NewLeasingSchedule.Status::Open;
        NewLeasingSchedule."No." := '';
        NewLeasingSchedule."No. Series" := '';
        NewLeasingSchedule."Loan Amount" := "Ending Balance" + "Lease Amount";
        NewLeasingSchedule."Term Of Lease, Months" := NewLeasingSchedule."Term Of Lease, Months" - "Line No." + 1;
        NewLeasingSchedule.VALIDATE("Loan Amount");
        NewLeasingSchedule.INSERT(TRUE);

        NewLeasingSchedule.CreateScheduleLines;

        PAGE.RUN(PAGE::"BLS Leasing Schedule Card", NewLeasingSchedule);
    end;

    procedure GetSalesDocumentType(): Integer
    var
        DocumentType: Option " ",Invoice,"Credit Memo","Posted Invoice","Posted Credit Memo";
        DocumentNo: Code[20];
    begin
        GetSalesDocument(DocumentType, DocumentNo);
        exit(DocumentType);
    end;

    procedure GetSalesDocumentNo(): Code[20]
    var
        DocumentType: Option " ",Invoice,"Credit Memo","Posted Invoice","Posted Credit Memo";
        DocumentNo: Code[20];
    begin
        GetSalesDocument(DocumentType, DocumentNo);
        exit(DocumentNo);
    end;

    procedure GetSalesDocument(var DocumentType: Option " ",Invoice,"Credit Memo","Posted Invoice","Posted Credit Memo"; var DocumentNo: Code[20])
    var

    begin
        Rec.CalcFields("Sales Document Type", "Sales Document No.", "Sales Invoice No.", "Sales Credit Memo No.");
        if "Sales Document No." <> '' then begin
            DocumentType := DocumentType::Invoice;
            DocumentNo := "Sales Document No.";
        end else
            if "Sales Credit Memo No." <> '' then begin
                DocumentNo := "Sales Credit Memo No.";
                DocumentType := DocumentType::"Posted Credit Memo";
            end else
                if "Sales Invoice No." <> '' then begin
                    DocumentNo := "Sales Invoice No.";
                    DocumentType := DocumentType::"Posted Invoice";
                end;
    end;
}

