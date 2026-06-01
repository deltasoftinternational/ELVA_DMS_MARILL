tableextension 25006066 "Nonstock Item" extends "Nonstock Item" //5718
{
    // 10.10.2018 EB.RC DE012WAE3-15
    //   Field modified - Discontinued
    // 
    // 21.08.2018 EB EDMS
    //   Added field:
    //     25006730 "Country/Region of Origin Code"
    //     25006740 "Item Tracking Code"
    //     25006750 "Returnable"
    //     25006760 "Discontinued"
    //     25006770 "Blocked"
    //   Updated sinchronization with Item
    // 
    // 06.12.2017 EB.P7 #T007
    //   Removed field "Product Subgroup Code"
    // 
    // 21.11.2017 EB.P30
    //   Modified triggers
    //     "Vendor No.".OnValidate
    //     "Vendor Item No.".OnValidate
    // 
    // 07.02.2017 EB.P7 EDMS Upgrade 2017
    //   Field added "Item Category Code"
    // 
    // 25.11.2015 EB.P7 #T017
    //   OnDeleted code moved to events
    // 
    // 11.02.2014 EDMS P21
    //   Added field:
    //     25006910 "Item Disc. Group"
    // 
    // 28.08.2014 EDMS P8
    //   * Added field "Replacements Exist"
    // 
    // 03.01.2008. EDMS P2
    //   Addded field "Tariff No."

    fields
    {
        field(25006005; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(25006670; "Item Type"; Option)
        {
            Caption = 'Item Type';
            OptionCaption = ',Item,Vehicle';
            OptionMembers = " ",Item,Vehicle;
        }
        field(25006672; "Published Cost Currency Code"; Code[10])
        {
            AutoFormatType = 1;
            Caption = 'Published Cost Currency Code';
            TableRelation = Currency;
        }
        field(25006673; "Unit Volume"; Decimal)
        {
            Caption = 'Unit Volume';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(25006674; "Replacements Exist"; Boolean)
        {
            CalcFormula = exist("Item Substitution" where(Type = const("Nonstock Item"),
                                                           "No." = field("Entry No."),
                                                           "Entry Type" = const(Replacement),
                                                           "Substitute Type" = const("Nonstock Item")));
            Caption = 'Replacements Exist';
            FieldClass = FlowField;
        }
        field(25006675; "Replacement Status"; Option)
        {
            Caption = 'Replacement Status';
            OptionCaption = ' ,Is Being Replaced,Replaced';
            OptionMembers = " ",Replaced;
        }
        field(25006679; "Market Recomended Sales Price"; Decimal)
        {
            Caption = 'Market Recomended Sales Price';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(25006680; "MRSP Currency Code"; Code[10])
        {
            AutoFormatType = 1;
            Caption = 'Market Recomended Sales Price Currency Code';
            TableRelation = Currency;
        }
        field(25006685; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(25006686; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(25006687; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(25006688; "Location Filter"; Code[10])
        {
            Caption = 'Location Filter';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(25006689; Inventory; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Entry No."),
                                                                  "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                  "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                  "Location Code" = field("Location Filter")));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006690; "Exchange Unit"; Boolean)
        {
            Caption = 'Exchange Unit';

            trigger OnValidate()
            var
                recItem: Record Item;
            begin
                if "Item No." <> '' then begin
                    recItem.Get("Item No.");
                    recItem."Exchange Unit" := "Exchange Unit";
                    recItem.Modify;
                end;
            end;
        }
        field(25006696; "Reserved Qty. on Inventory"; Decimal)
        {
            CalcFormula = sum("Reservation Entry"."Quantity (Base)" where("Item No." = field("Item No."),
                                                                           "Source Type" = const(32),
                                                                           "Source Subtype" = const(0),
                                                                           "Reservation Status" = const(Reservation),
                                                                           "Location Code" = field("Location Filter")));
            Caption = 'Reserved Qty. on Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006700; "Substitutes Exist"; Boolean)
        {
            CalcFormula = exist("Item Substitution" where(Type = const("Nonstock Item"),
                                                           "No." = field("Entry No.")));
            Caption = 'Substitutes Exist';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006710; "No. of Substitutes"; Integer)
        {
            CalcFormula = count("Item Substitution" where(Type = const("Nonstock Item"),
                                                           "No." = field("Entry No.")));
            Caption = 'No. of Substitutes';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006720; "Tariff No."; Code[10])
        {
            Caption = 'Tariff No.';
            TableRelation = "Tariff Number";
        }
        field(25006730; "Country/Region of Origin Code"; Code[10])
        {
            Caption = 'Country/Region of Origin Code';
        }
        field(25006740; "Item Tracking Code"; Code[10])
        {
            Caption = 'Item Tracking Code';
            TableRelation = "Item Tracking Code";
        }
        field(25006750; Returnable; Boolean)
        {
        }
        field(25006760; Discontinued; Boolean)
        {
            CalcFormula = exist("Item Substitution" where("No." = field("Entry No."),
                                                           "Entry Type" = const(Discontinued),
                                                           Type = const("Nonstock Item")));
            Caption = 'Discontinued';
            FieldClass = FlowField;
        }
        field(25006770; Blocked; Boolean)
        {
        }
        field(25006900; "Item Price Group Code"; Code[10])
        {
            Caption = 'Item Price Group Code';
            TableRelation = "Item Price Group";
        }
        field(25006910; "Item Disc. Group"; Code[20])
        {
            Caption = 'Item Disc. Group';
            TableRelation = "Item Discount Group";
        }
        field(25006911; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";

            trigger OnValidate()
            begin
                /*IF ("Item Category Code" <> xRec."Item Category Code") AND
                   ("Item No." <> '')
                THEN
                  ERROR(Text001);*/

                //"Product Group Code" := '';
            end;
        }
        field(25006912; "EDMS Published Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Published Cost';
        }
        field(25006913; "EDMS Negotiated Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Negotiated Cost';
        }


    }

    procedure CheckVendorItemNo(VendorNo: Code[20]; VendorItemNo: Code[50]): Boolean
    Var
        NonStockItem: Record "Nonstock Item";
    begin
        NonStockItem.Reset();
        NonStockItem.SetCurrentKey("Vendor No.", "Vendor Item No.");
        NonStockItem.SetRange("Vendor No.", VendorNo);
        NonStockItem.SetRange("Vendor Item No.", VendorItemNo);
        exit(NonStockItem.FindFirst);
    end;

    procedure ShowVehModels()
    var
        ItemVehicleModel: Record "Item Vehicle Model";
    begin
        ItemVehicleModel.SetRange(Type, ItemVehicleModel.Type::"Nonstock Item");
        ItemVehicleModel.SetRange("No.", "Entry No.");
        if (not ItemVehicleModel.FindFirst) and ("Item No." <> '') then begin
            ItemVehicleModel.Reset;
            ItemVehicleModel.SetRange(Type, ItemVehicleModel.Type::Item);
            ItemVehicleModel.SetRange("No.", "Item No.");
        end;
        Page.Run(Page::"Item Vehicle Models", ItemVehicleModel);
    end;

}