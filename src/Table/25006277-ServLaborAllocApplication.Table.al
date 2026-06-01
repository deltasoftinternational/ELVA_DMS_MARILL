Table 25006277 "Serv. Labor Alloc. Application"
{
    // 12.05.2015 EB.P30 #T030
    //   Added fields:
    //     "Finished Cost Amount"
    //     "Remaining Cost Amount"
    //     "Total Cost Amount"
    // 
    // 12.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified OptionCaptionML property for field:
    //     "Document Type"
    // 
    // 2012.04.02 EDMS P8
    //   * add code to be used separatly from SS add-on
    // 
    // 10.01.2008. EDMS P2
    //   * Added field "Resource No."

    Caption = 'Serv. Labor Alloc. Application';
    DrillDownPageID = "Serv. Labor Alloc. Application";
    LookupPageID = "Serv. Labor Alloc. Application";

    fields
    {
        field(1; "Allocation Entry No."; Integer)
        {
            Caption = 'Allocation Entry No.';
            TableRelation = "Serv. Labor Allocation Entry";
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Return Order,Invoice,Credit Memo,Blanket Order,Booking';
            OptionMembers = Quote,"Order","Return Order",Invoice,"Credit Memo","Blanket Order",Booking;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
        field(5; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            NotBlank = true;
            TableRelation = Resource;

            trigger OnValidate()
            var
                Resource: Record Resource;
            begin
                Resource.Get("Resource No.");
                Validate("Unit Cost", Resource."Unit Cost");
            end;
        }
        field(20; "Finished Quantity (Hours)"; Decimal)
        {
            Caption = 'Finished Quantity (Hours)';

            trigger OnValidate()
            begin
                Validate("Finished Cost Amount", "Finished Quantity (Hours)" * "Unit Cost");
            end;
        }
        field(30; "Remaining Quantity (Hours)"; Decimal)
        {
            Caption = 'Remaining Quantity (Hours)';

            trigger OnValidate()
            begin
                Validate("Remaining Cost Amount", "Remaining Quantity (Hours)" * "Unit Cost");
            end;
        }
        field(40; "Time Line"; Boolean)
        {
            Caption = 'Time Line';
        }
        field(50; Posted; Boolean)
        {
            Caption = 'Posted';
        }
        field(60; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';

            trigger OnValidate()
            begin
                Validate("Finished Cost Amount", "Finished Quantity (Hours)" * "Unit Cost");
                Validate("Remaining Cost Amount", "Remaining Quantity (Hours)" * "Unit Cost");
            end;
        }
        field(70; "Finished Cost Amount"; Decimal)
        {
            Caption = 'Finished Cost Amount';

            trigger OnValidate()
            begin
                "Cost Amount" := "Finished Cost Amount" + "Remaining Cost Amount";
            end;
        }
        field(80; "Remaining Cost Amount"; Decimal)
        {
            Caption = 'Remaining Cost Amount';

            trigger OnValidate()
            begin
                "Cost Amount" := "Finished Cost Amount" + "Remaining Cost Amount";
            end;
        }
        field(90; "Cost Amount"; Decimal)
        {
            Caption = 'Total Cost Amount';
        }
        field(120; Travel; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Allocation Entry No.", "Document Type", "Document No.", "Document Line No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Finished Quantity (Hours)", "Remaining Quantity (Hours)";
        }
        key(Key2; "Document Type", "Document No.")
        {
            SumIndexFields = "Finished Quantity (Hours)", "Remaining Quantity (Hours)";
        }
        key(Key3; "Document Type", "Document No.", "Document Line No.")
        {
            SumIndexFields = "Finished Quantity (Hours)", "Remaining Quantity (Hours)";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        Found: Boolean;
    begin
        ServLaborAllocApplication.Reset;
        ServLaborAllocApplication.SetRange("Allocation Entry No.", "Allocation Entry No.");
        if ServLaborAllocApplication.Count = 1 then
            if ServLaborAllocationEntry.Get("Allocation Entry No.") then
                ServLaborAllocationEntry.Delete;

        // 18.12.2014 Elva Baltic P21 #E0003 >>
        // Need to pass time line to other
        if "Time Line" and (ServLaborAllocApplication.Count > 1) then begin
            ServLaborAllocApplication.FindSet(true);
            repeat
                if not ((ServLaborAllocApplication."Allocation Entry No." = "Allocation Entry No.") and
                        (ServLaborAllocApplication."Document Type" = "Document Type") and
                        (ServLaborAllocApplication."Document No." = "Document No.") and
                        (ServLaborAllocApplication."Document Line No." = "Document Line No.") and
                        (ServLaborAllocApplication."Line No." = "Line No.")) then begin
                    Found := true;
                    ServLaborAllocApplication."Time Line" := true;
                    ServLaborAllocApplication."Remaining Quantity (Hours)" := "Remaining Quantity (Hours)";
                    ServLaborAllocApplication."Finished Quantity (Hours)" := "Finished Quantity (Hours)";
                    ServLaborAllocApplication.Modify(true);
                end;
            until Found or (ServLaborAllocApplication.Next = 0);
        end;
        // 18.12.2014 Elva Baltic P21 #E0003 <<
    end;

    trigger OnInsert()
    begin
        //2012.04.02 EDMS P8 >>
        if "Line No." = 0 then
            "Line No." := 10000;
        //IF "Allocation Entry No." = 0 THEN BEGIN
        if ServLaborAllocApplication.Get("Allocation Entry No.", "Document Type", "Document No.", "Document Line No.",
            "Line No.") then begin
            ServLaborAllocApplication.Reset;
            ServLaborAllocApplication.SetRange("Allocation Entry No.", "Allocation Entry No.");
            ServLaborAllocApplication.SetRange("Document Type", "Document Type");
            ServLaborAllocApplication.SetRange("Document No.", "Document No.");
            ServLaborAllocApplication.SetRange("Document Line No.", "Document Line No.");
            if ServLaborAllocApplication.FindLast then
                "Line No." := ServLaborAllocApplication."Line No.";
            "Line No." += 10000;
        end;
        //2012.04.02 EDMS P8 <<
    end;

    var
        ServLaborAllocApplication: Record "Serv. Labor Alloc. Application";
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
}

