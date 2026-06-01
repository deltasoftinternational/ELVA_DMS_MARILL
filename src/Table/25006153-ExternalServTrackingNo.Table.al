Table 25006153 "External Serv. Tracking No."
{
    // 15.07.2008. EDMS P2
    //   * Added fields "Purchase Amount", "Sale Amount"

    Caption = 'External Serv. Tracking No.';
    LookupPageID = "Ext. Service Tracking No. List";

    fields
    {
        field(1; "External Service No."; Code[20])
        {
            Caption = 'External Service No.';
            NotBlank = true;
            TableRelation = "External Service";
        }
        field(2; "External Serv. Tracking No."; Code[20])
        {
            Caption = 'External Serv. Tracking No.';

            trigger OnValidate()
            begin
                if "External Serv. Tracking No." <> xRec."External Serv. Tracking No." then begin
                    ExtService.Get("External Service No.");
                    NoSeriesMgt.TestManual(ExtService."Tracking Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(5; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(10; "Purchase Amount"; Decimal)
        {
            CalcFormula = sum("External Serv. Ledger Entry".Amount where("External Serv. No." = field("External Service No."),
                                                                          "External Serv. Tracking No." = field("External Serv. Tracking No."),
                                                                          "Entry Type" = const(Purchase)));
            Caption = 'Purchase Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Sales Amount"; Decimal)
        {
            CalcFormula = sum("External Serv. Ledger Entry".Amount where("External Serv. No." = field("External Service No."),
                                                                          "External Serv. Tracking No." = field("External Serv. Tracking No."),
                                                                          "Entry Type" = const(Sale)));
            Caption = 'Sales Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; "Service Order No."; Code[20])
        {
            Caption = 'Service Order No.';
        }
        field(40; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            FieldClass = Normal;
            TableRelation = Vehicle;
        }
        field(50; "Vehicle Registration No."; Code[20])
        {
            CalcFormula = Lookup("Vehicle"."Registration No." where("Serial No." = field("Vehicle Serial No.")));
            FieldClass = FlowField;
        }
        field(60; "VIN"; Code[20])
        {
            CalcFormula = Lookup("Vehicle".VIN where("Serial No." = field("Vehicle Serial No.")));
            FieldClass = FlowField;
        }
        field(70; "Make Code"; Code[20])
        {
            CalcFormula = Lookup("Vehicle"."Make Code" where("Serial No." = field("Vehicle Serial No.")));
            FieldClass = FlowField;
        }
        field(80; "Model Code"; Code[20])
        {
            CalcFormula = Lookup("Vehicle"."Model Code" where("Serial No." = field("Vehicle Serial No.")));
            FieldClass = FlowField;
        }
        field(90; "Purchase Lines"; Integer)
        {
            CalcFormula = count("Purchase Line" where("External Serv. Tracking No." = field("External Serv. Tracking No."),
                                                                          "Type" = const("External Service")));

            Caption = 'Purchase Lines';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "External Service No.", "External Serv. Tracking No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        ExtService.Get("External Service No.");
        Description := ExtService.Description;

        if "External Serv. Tracking No." = '' then begin
            ExtService.TestField("Tracking Nos.");
            "No. Series" := ExtService."Tracking Nos.";
            "External Serv. Tracking No." := NoSeriesMgt.GetNextNo("No. Series", 0D, true);
        end;
    end;

    var
        ExtService: Record "External Service";
        NoSeriesMgt: Codeunit "No. Series";
}

