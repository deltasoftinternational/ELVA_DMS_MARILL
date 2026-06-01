Table 25006050 "Make Setup"
{
    // #Include EDMS.Integration
    // 
    // 22.08.2018 EB.ASM EDMS.Integration EDMS
    //   Added field:
    //     25006770 "Integration Connector Code"
    // 
    // 12.05.2008. EDMS P2
    //   * Added field "Vehicle Evaluation No. Series"
    // 
    // 10.09.2007 EDMS P3
    //   * Added fields for PutInTakeOut Source Codes: Service PutInTakeOut SC and Sale PutInTakeOut SC

    Caption = 'Make Setup';

    fields
    {
        field(10; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(40; "Standard Option Nos."; Code[10])
        {
            Caption = 'Standard Option Nos.';
            TableRelation = "No. Series";
        }
        field(50; "Default CM VAT Prod. Post. Grp"; Code[10])
        {
            Caption = 'Default CM VAT Prod. Posting Group';
            Description = 'If it is filled - Prepmt. CM posting use it for non-correction CMs';
            TableRelation = "VAT Product Posting Group";
        }
        field(60; "Vehicle Assembly Mandatory"; Boolean)
        {
            Caption = 'Vehicle Assembly Mandatory';
        }
        field(70; "Process IC Inbox Documents"; Boolean)
        {
            Caption = 'Process IC Inbox Documents';
            Description = 'When checked - is activated additional B2B processing when importing IC Purch. Orders in CU 427';
        }
        field(80; "PDI Service Package No."; Code[20])
        {
            Caption = 'PDI Service Package';
            TableRelation = "Service Package"."No." where("Make Code" = field("Make Code"));
        }
        field(25006770; "Integration Connector Code"; Code[20])
        {
            Caption = 'Integration Connector Code';
            Description = 'EDMS.Integration';
            TableRelation = "Integration Connector EDMS"."Connector Code";
        }
    }

    keys
    {
        key(Key1; "Make Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

