tableextension 25006047 "Sales & Receivables Setup" extends "Sales & Receivables Setup" //311
{
    // 23.08.2018 EB.P7
    //   Added field:
    //     "Enable Stock Avail. Selection"
    // 
    // 26.03.2014 MMG7.1.00 P7 #Marginal VAT
    //   * Added fields: Veh. Marg. VAT Item Charge
    // 
    // 20.03.2013 EDMS P8
    //   * Added fields "Vehicle Service Plan on Sales"
    // 
    // 01.09.2008. EDMS P2
    //   * Added fields "Veh.Interdep. Incoming Account"
    //                  "Veh.Interdep. Expenses Account"
    // 
    // 09.05.2008. EDMS P2
    //   * Added field "Compress Prepayment"
    // 
    // 27.08.2007. EDMS P2
    //   * Added new field "Contract Nos."
    // 
    // 15.08.2007. EDMS P2
    //   * Added new field "Print Only Posted Doc."
    // 
    // 29.05.2007. EDMS P2
    //   * Added field Trade-In Sales Account No.

    fields
    {
        field(25006001; "Def. Ordering Price Type Code"; Code[10])
        {
            Caption = 'Def. Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }
        field(25006009; "Deal Type Mandatory"; Boolean)
        {
            Caption = 'Deal Type Mandatory';
        }
        field(25006010; "Trade-In Sales Account No."; Code[20])
        {
            Caption = 'Trade-In Sales Account No.';
            TableRelation = "G/L Account";
        }
        field(25006014; "Veh. Marginal VAT Account No."; Code[20])
        {
            Caption = 'Veh. Marginal VAT Account No.';
            TableRelation = "G/L Account";
        }
        field(25006015; "Payment Method Mandatory"; Boolean)
        {
            Caption = 'Payment Method Mandatory';
        }
        field(25006016; "Veh. Marg.VAT Gen.Bus.Grp."; Code[20])
        {
            Caption = 'Veh. Marg.VAT Gen.Bus.Posting Grp.';
            TableRelation = "Gen. Business Posting Group";
        }
        field(25006018; "Veh. Marg.VAT Gen.Prod.Grp."; Code[20])
        {
            Caption = 'Veh. Marg.VAT Gen.Prod.Posting Grp.';
            TableRelation = "Gen. Product Posting Group";
        }
        field(25006030; "Vehicle Warranty on Sales"; Boolean)
        {
            Caption = 'Vehicle Warranty on Sales';
        }
        field(25006031; "Vehicle Service Plan on Sales"; Boolean)
        {
            Caption = 'Vehicle Service Plan on Sales';
        }
        field(25006032; "Vehicle Sale Register on"; Option)
        {
            Caption = 'Vehicle Sale Register on';
            OptionCaption = 'Shipment,Invoice';
            OptionMembers = Shipment,Invoice;
        }
        field(25006150; "Vehicle Sales Item Charge"; Code[20])
        {
            Caption = 'Vehicle Sales Item Charge';
            TableRelation = "Item Charge"."No.";
        }
        field(25006170; "Contract Nos."; Code[10])
        {
            Caption = 'Contract Nos.';
            TableRelation = "No. Series";
        }
        field(25006190; "Def. Sales Price Include VAT"; Boolean)
        {
            Caption = 'Def. Sales Price Include VAT';
        }
        field(25006196; "Item No. Replacement Warnings"; Boolean)
        {
            Caption = 'Item No. Replacement Warnings';
        }
        field(25006200; "Def.S.Price VAT Bus.Post.Grp."; Code[20])
        {
            Caption = 'Def. Sales Price VAT Bus. Post. Grp.';
            TableRelation = "VAT Business Posting Group".Code;
        }
        field(25006210; "Def.S.Price VAT Prod.Post.Grp."; Code[20])
        {
            Caption = 'Def. Sales Price VAT Prod. Post. Grp.';
            TableRelation = "VAT Product Posting Group".Code;
        }
        field(25006220; "Def.Sales Price AllowLineDisc."; Boolean)
        {
            Caption = 'Def. Sales Price Allow Line Disc.';
        }
        field(25006230; "Def.Sales Price Include Disc."; Boolean)
        {
            Caption = 'Def. Sales Price Include Disc.';
        }
        field(25006240; "Def.S.Price Currency Code"; Code[10])
        {
            Caption = 'Def. Sales Price Currency Code';
            TableRelation = Currency.Code;
        }
        field(25006260; "Def.S.Price Rounding Precision"; Decimal)
        {
            Caption = 'Def. Sales Price Rounding Precision';
        }
        field(25006270; "Compress Prepayment"; Boolean)
        {
            Caption = 'Compress Prepayment';
        }
        field(25006300; "Def.Vehicle-Contact Rel."; Code[10])
        {
            Caption = 'Def.Vehicle-Contact Rel.';
            TableRelation = "Vehicle-Contact Relationship";
        }
        field(25006310; "Offer Link Vehicle and Contact"; Boolean)
        {
            Caption = 'Offer Link Vehicle and Contact';
        }
        field(25006320; "Link Relationship Code"; Code[10])
        {
            Caption = 'Link Relationship Code';
            TableRelation = "Vehicle-Contact Relationship";
        }
        field(25006330; "Veh. Marg. VAT Item Charge"; Code[20])
        {
            Caption = 'Veh. Marg. VAT Item Charge';
            TableRelation = "Item Charge";
        }
        field(25006419; "Auto Apply Replacements"; Boolean)
        {
            Caption = 'Automatically Apply Replacements';
        }
        field(25006422; "Enable Stock Avail. Selection"; Boolean)
        {
            Caption = 'Enable Stock Availability Selection';
            DataClassification = ToBeClassified;
        }
        field(25006423; "Non Stock Item Price List Code"; Code[20])
        {
            TableRelation = "Price List Header".Code where("Source Type" = Filter(Customer));
            trigger OnLookup()
            VAR
                PriceListHeader: Record "Price List Header";
            begin
                PriceListHeader.SetRange("Source Type", PriceListHeader."Source Type"::Customer);
                IF page.RunModal(page::"Sales Price Lists", PriceListHeader) = action::LookupOK then
                    rec."Non Stock Item Price List Code" := PriceListHeader.Code;

            end;
        }
    }


}