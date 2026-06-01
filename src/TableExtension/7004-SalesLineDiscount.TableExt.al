tableextension 25006024 "Sales Line Discount" extends "Sales Line Discount" //7004
{
    // 06.12.2017 EB.P7 #T007
    //   Removed fields
    //     25006390"Item Category Code"
    //     25006400"Product Group Code"
    //     25006401"Product Subgroup Code"
    // 
    // 04.02.2016 EB.P30 #T032
    //   Change relations for fields:
    //     "Item Category Code"
    //     "Product Group Code"
    //     "Product Subgroup Code"
    //   Modified triggers:
    //     OnInsert
    //     OnRename
    // 
    // 26.11.2015 EB.P7 #T017
    //   Code from triggers moved to events
    // 
    // 05.12.2013 EDMS P8
    //   * Added options to Type field
    // 
    // 21.11.2013 EDMS P8
    //   * Added EDMS fields
    fields
    {
        modify("code")
        {
            TableRelation = if (Type = const(Item)) Item
            else
            if (Type = const("Item Disc. Group")) "Item Discount Group"
            else
            if (Type = const(All)) "Item Category".Code;
        }
        modify("Sales Code")
        {
            TableRelation = if ("Sales Type" = const("Customer Disc. Group")) "Customer Discount Group"
            else
            if ("Sales Type" = const(Customer)) Customer
            else
            if ("Sales Type" = const(Campaign)) Campaign
            else
            if ("Sales Type" = const("All Customers"), "Sales Type Elva" = const(Contract)) Contract."Contract No."
            else
            if ("Sales Type" = const("All Customers"), "Sales Type Elva" = const(Assembly)) "Vehicle Assembly Header"."Assembly ID"
            else
            if ("Sales Type" = const("All Customers"), "Sales Type Elva" = const(SPackage)) "Service Package"."No.";

        }

        modify("type")
        {
            trigger onaftervalidate()
            begin
                /* if Type = Type::All then TO verify
                     Validate(Code, '');*/
            end;

        }

        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006002; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(25006003; "Vehicle Status Code"; Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;
        }
        field(25006007; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(25006010; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item."No." where("Item Type" = const("Model Version"),
                                              "Make Code" = field("Make Code"),
                                              "Model Code" = field("Model Code"));
        }
        field(25006120; "Source Type"; Option)
        {
            Caption = 'Source Type';
            Editable = false;
            OptionCaption = 'User,Contract';
            OptionMembers = User,Contract;
        }
        field(25006130; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            Editable = false;
        }
        field(25006140; "Source Ref. No."; Integer)
        {
            Caption = 'Source Ref. No.';
        }
        field(25006373; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
        }

        //>>ADDED TO REPLACE  SALES TYPE
        field(25006020; "Sales Type Elva"; ENUM "Sales type elva price")
        {
            Caption = 'Sales Type';
            trigger onvalidate()
            begin
                rec.TestField("Sales Type", "Sales Type"::"All Customers");
            end;
        }



    }

    keys
    {
        /*
          key(Key1; Type, "Code", "Sales Type", "Sales Code", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Vehicle Status Code", "Document Profile", "Vehicle Serial No.", "Make Code")
         {
             Clustered = true;
         }
         */
    }
}