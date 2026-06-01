tableextension 25006060 "Item Category" extends "Item Category" //5722
{
    // #Include EDMS.Integration
    // 
    // 22.08.2018 EB.ASM EDMS.Integration EDMS
    //   Added field:
    //     25006770 "Integration Connector Code"
    // 
    // 11.10.2017 EDMS P30
    //   Added field:
    //     25006730 "Quote Analysis Freight %"
    // 
    // 12.03.2015 EDMS P21
    //   Remove field:
    //     25006690 "Item Disc. Group"
    // 
    // 22.10.2008. EDMS P2
    //   * added field Reserve
    // 
    // 03.09.2007. EDMS P2
    //   * Added field "Item Disc. Group"
    // 
    // 18.05.2007. EDMS P2
    //   *Added flowfield "Cost Amount Net Change"
    fields
    {
        field(25006670; "Item Type"; Option)
        {
            Caption = 'Item Type';
            OptionCaption = ' ,Item,Model Version';
            OptionMembers = " ",Item,"Model Version";
        }
        field(25006671; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(25006672; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(25006673; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(25006674; "Location Filter"; Code[10])
        {
            Caption = 'Location Filter';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(25006678; "Description (Sales Document)"; Text[30])
        {
            Caption = 'Description (Sales Document)';
        }
        field(25006681; "Sales (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Value Entry"."Sales Amount (Actual)" where("Item Ledger Entry Type" = const(Sale),
                                                                           "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                           "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                           "Location Code" = field("Location Filter"),
                                                                           "Posting Date" = field("Date Filter"),
                                                                           "Item Category Code" = field(Code)));
            Caption = 'Sales (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006682; "COGS (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - sum("Value Entry"."Cost Amount (Actual)" where("Item Ledger Entry Type" = const(Sale),
                                                                           "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                           "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                           "Location Code" = field("Location Filter"),
                                                                           "Posting Date" = field("Date Filter"),
                                                                           "Item Category Code" = field(Code)));
            Caption = 'COGS (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006683; "Cost Amount Net Change"; Decimal)
        {
            CalcFormula = sum("Value Entry"."Cost Amount (Actual)" where("Posting Date" = field("Date Filter"),
                                                                          "Location Code" = field("Location Filter"),
                                                                          "Item Category Code" = field(Code)));
            Caption = 'Cost Amount Net Change';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006700; Reserve; Option)
        {
            Caption = 'Reserve';
            OptionCaption = 'Never,Optional,Always';
            OptionMembers = Never,Optional,Always;
        }
        field(25006710; "Order Tracking Policy"; Option)
        {
            Caption = 'Order Tracking Policy';
            OptionCaption = 'None,Tracking Only,Tracking & Action Msg.';
            OptionMembers = "None","Tracking Only","Tracking & Action Msg.";
        }
        field(25006720; "Item Tracking Code"; Code[10])
        {
            Caption = 'Item Tracking Code';
            TableRelation = "Item Tracking Code";
        }
        field(25006730; "Quote Analysis Freight %"; Decimal)
        {
            Caption = 'Quote Analysis Freight %';
        }
        field(25006770; "Integration Connector Code"; Code[20])
        {
            Caption = 'Integration Connector Code';
            Description = 'EDMS.Integration';
            TableRelation = "Integration Connector EDMS"."Connector Code";
        }

    }

}