tableextension 25006005 "Vendor" extends Vendor //23
{
    // #Include EDMS.Integration
    // 
    // 22.08.2018 EB.ASM EDMS.Integration EDMS
    //   Added field:
    //     25006770 "Integration Connector Code"
    fields
    {
        field(25006770; "Integration Connector Code"; Code[20])
        {
            Caption = 'Integration Connector Code';
            Description = 'EDMS.Integration';
            TableRelation = "Integration Connector EDMS"."Connector Code";

        }
        field(25006771; "Non Stock Item Price List Code"; Code[20])
        {
            TableRelation = "Price List Header".Code where("Source Type" = Filter(Vendor), "Source No." = field("No."));
        }
    }

}