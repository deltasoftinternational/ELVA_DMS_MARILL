Table 25006053 "Deal Application Entry"
{
    Caption = 'Deal Application Entry';

    fields
    {
        field(10; Type; Code[10])
        {
            Caption = 'Type';
            TableRelation = "Deal Application Type"."No.";
        }
        field(20; "Det. Cust. Ledg. Entry EDMS"; Integer)
        {
            Caption = 'Det. Cust. Ledg. Entry EDMS';
        }
        field(30; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Posted Invoice,Posted C.Memo';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Posted Invoice","Posted C.Memo";
        }
        field(40; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = if ("Document Type" = filter(< "Posted Invoice")) "Sales Header"."No." where("Document Type" = field("Document Type"))
            else
            if ("Document Type" = const("Posted Invoice")) "Sales Invoice Header"."No."
            else
            if ("Document Type" = const("Posted C.Memo")) "Sales Cr.Memo Header"."No.";
        }
        field(50; "Doc. Line No."; Integer)
        {
            Caption = 'Doc. Line No.';
            TableRelation = "Sales Line"."Line No." where("Document Type" = field("Document Type"),
                                                           "Document No." = field("Document No."));
        }
        field(60; "Applies-to Entry No."; Integer)
        {
            Caption = 'Applies-to Entry No.';
        }
        field(70; Application; Boolean)
        {
            Caption = 'Application';
        }
        field(80; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
    }

    keys
    {
        key(Key1; Type, "Det. Cust. Ledg. Entry EDMS", "Document Type", "Document No.", "Doc. Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Applies-to Entry No.")
        {
        }
        key(Key3; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        LocDealApplEntry: Record "Deal Application Entry";
    begin
        LocDealApplEntry.Reset;
        LocDealApplEntry.SetCurrentkey("Entry No.");
        if LocDealApplEntry.FindLast then
            "Entry No." := LocDealApplEntry."Entry No." + 1
        else
            "Entry No." := 1
    end;

    var
        DealApplEntry: Record "Deal Application Entry";
        SalesLine: Record "Sales Line";
        DCLedgEntry: Record "Cust. Ledg. Entry Link";
        Text001: label 'There is more than one record with system type %1 in the table %2. Check Setup in the table %2.';
        Text002: label 'Thers is no records with system type %1 in the table %2. Check Setup in the table %2.';


    procedure InitApplication(NewSysType: Option " ",Leasing; DCLedgEntryNo: Integer; DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; DocNo: Code[20]; DocLineNo: Integer)
    var
        DealApplType: Record "Deal Application Type";
        ApplToEntry: Integer;
    begin
        DealApplType.SetRange("System Type", NewSysType);
        if DealApplType.Count > 1 then
            Error(Text001, NewSysType, DealApplType.TableCaption);
        if not DealApplType.FindFirst then
            Error(Text002, NewSysType, DealApplType.TableCaption);

        Reset;
        if not Get(DealApplType."No.", DCLedgEntryNo, DocType, DocNo, DocLineNo) then begin
            Init;
            DealApplEntry.Reset;
            DealApplEntry.SetCurrentkey("Entry No.");
            if DealApplEntry.FindLast then
                ApplToEntry := DealApplEntry."Entry No." + 1
            else
                ApplToEntry := 1;
            "Applies-to Entry No." := 0;
            Type := DealApplType."No.";
            "Det. Cust. Ledg. Entry EDMS" := DCLedgEntryNo;
            "Document Type" := DocType;
            "Document No." := DocNo;
            "Doc. Line No." := DocLineNo;
            //  Application := TRUE;
            Insert(true);
            DealApplEntry := Rec;
            DealApplEntry."Applies-to Entry No." := FindDocs(Rec);
            if DealApplEntry."Applies-to Entry No." <> 0 then
                ApplToEntry := DealApplEntry."Applies-to Entry No."
            else
                DealApplEntry."Applies-to Entry No." := ApplToEntry;
            SetCurrentkey("Applies-to Entry No.");
            SetRange("Applies-to Entry No.", 0);
            ModifyAll("Applies-to Entry No.", ApplToEntry);
            Rec := DealApplEntry;
        end
    end;


    procedure FindDocs(NewDealApplEntry: Record "Deal Application Entry") Result: Integer
    var
        SalesLine2: Record "Sales Line";
        VehSerialNo: Code[20];
        VehAccNo: Code[20];
    begin
        DCLedgEntry.Reset;
        if NewDealApplEntry."Det. Cust. Ledg. Entry EDMS" = 0 then begin
            SalesLine.Get(NewDealApplEntry."Document Type", NewDealApplEntry."Document No.", NewDealApplEntry."Doc. Line No.");
            SalesLine.TestField("Vehicle Serial No.");
            SalesLine.TestField("Vehicle Accounting Cycle No.");
            VehSerialNo := SalesLine."Vehicle Serial No.";
            VehAccNo := SalesLine."Vehicle Accounting Cycle No.";
        end else begin
            DCLedgEntry.Get(NewDealApplEntry."Det. Cust. Ledg. Entry EDMS");
            VehSerialNo := DCLedgEntry."Vehicle Serial No.";
            VehAccNo := DCLedgEntry."Vehicle Accounting Cycle No.";
            DCLedgEntry.SetFilter("Entry No.", '<>%1', DCLedgEntry."Entry No.");
        end;
        DCLedgEntry.SetRange("Vehicle Serial No.", VehSerialNo);
        DCLedgEntry.SetRange("Vehicle Accounting Cycle No.", VehAccNo);
        SetCurrentkey(Type, "Det. Cust. Ledg. Entry EDMS", "Document Type", "Document No.", "Doc. Line No.");
        if DCLedgEntry.FindSet then
            repeat
                Init;
                Type := NewDealApplEntry.Type;
                "Document Type" := DCLedgEntry."Document Type" + 4;
                "Document No." := DCLedgEntry."Document No.";
                "Doc. Line No." := DCLedgEntry."Document Line No.";
                "Applies-to Entry No." := NewDealApplEntry."Applies-to Entry No.";
                "Det. Cust. Ledg. Entry EDMS" := DCLedgEntry."Entry No.";
                if FindFirst then
                    Result := "Applies-to Entry No."
                else
                    Insert(true);
            until DCLedgEntry.Next = 0;

        SalesLine2.SetRange("Vehicle Serial No.", VehSerialNo);
        SalesLine2.SetRange("Vehicle Accounting Cycle No.", VehAccNo);
        if SalesLine2.FindSet then
            repeat
                Init;
                Type := NewDealApplEntry.Type;
                "Document Type" := SalesLine2."Document Type";
                "Document No." := SalesLine2."Document No.";
                "Doc. Line No." := SalesLine2."Line No.";
                "Applies-to Entry No." := NewDealApplEntry."Applies-to Entry No.";
                "Det. Cust. Ledg. Entry EDMS" := 0;
                if Insert(true) then;
            until SalesLine2.Next = 0;
    end;
}

