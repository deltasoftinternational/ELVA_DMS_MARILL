tableextension 25006013 "Purchases & Payables Setup" extends "Purchases & Payables Setup" //312
{
    // 06.10.2016 EB.P7 #PAR28
    //   Added field:
    //     25006004 "Auto Apply Replacements"
    // 
    // 09.06.2014 Elva Baltic P1 #F0001 EDMS7.10
    //   * Added field:
    //     "Split Order By Price Type"
    // 
    // 21.06.2007. EDMS P2
    //   * Added new fields
    //     Don't Control Vendor Inv. No.
    // 
    // 13.06.2007. EDMS P2
    //   * Added new fields
    //      Presentation Costs
    //      Presentation Costs For VAT 1
    //      Presentation Costs For VAT 2
    //      Pres. Gen. Prod. posting Group 1
    //      Pres. Gen. Prod. posting Group 2
    fields
    {
        field(25006000; "Post Reverse VAT On Prepmt."; Boolean)
        {
            Caption = 'Post Reverse VAT On Prepmt.';
        }
        field(25006001; "Def. Ordering Price Type Code"; Code[10])
        {
            Caption = 'Def. Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }
        field(25006002; "Vehicle Purch. Order Grouping"; Option)
        {
            OptionCaption = 'No Grouping,By Vendor';
            OptionMembers = "No Grouping","By Vendor";
        }
        field(25006003; "Split Order By Price Type"; Boolean)
        {
            Caption = 'Create Diff. Order for Diff. Ordering Price Type of Req. Line';
            Description = 'Create Diff. Order for Diff. Ordering Price Type of Req. Line';
        }
        field(25006004; "Auto Apply Replacements"; Boolean)
        {
            Caption = 'Automatically Apply Replacements';
        }
        field(25006009; "Deal Type Mandatory"; Boolean)
        {
            Caption = 'Deal Type Mandatory';
        }
    }
}