tableextension 25006138 "Sales Header Archive" extends "Sales Header Archive" //5107
{
    // 27.05.2016 EB.P30 #T086
    //   Added fields:
    //     "Phone No."
    //     "Mobile Phone No."
    // 
    // 20.02.2015 EB.P7 #Arch Ret.Orders
    //   Renewed EDMS fields from Sales Header
    // 
    // 28.07.2008. EDMS P2
    //   * Added fields:
    //               Guarranty Claim No.
    //               Vehicle Item Charge No.
    //               DMS Variable Field 25006800
    //               DMS Variable Field 25006801
    //               DMS Variable Field 25006802
    //               Kilometrage
    //               Automatic CM Item Return

    fields
    {
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006001; "Deal Type Code"; Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";

            trigger OnValidate()
            var
                recSalesLine: Record "Sales Line";
                tcDMS001: label 'Do you want to change lines too?';
            begin
            end;
        }
        field(25006005; "Prepmt. Bill-to Cust. Changed"; Boolean)
        {
            Caption = 'Prepmt. Bill-to Cust. Changed';
        }
        field(25006120; "Service Document No."; Code[20])
        {
            Caption = 'Service Document No.';
        }
        field(25006130; "Service Document"; Boolean)
        {
            Caption = 'Service Document';
        }
        field(25006140; "Order Creator"; Code[10])
        {
            Caption = 'Order Creator';
            Description = 'Internal';
            TableRelation = "Salesperson/Purchaser";
        }
        field(25006150; "Vehicle Status Code"; Code[20])
        {
            Caption = 'Vehicle Status Code';
            Description = 'Only For Service or Spare Parts Trade';
            TableRelation = "Vehicle Status".Code;
        }
        field(25006170; "Vehicle Registration No."; Code[20])
        {
            CalcFormula = lookup(Vehicle."Registration No." where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Vehicle Registration No.';
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            var
                Vehicle: Record Vehicle;
            begin
            end;
        }
        field(25006276; "Warranty Claim No."; Code[20])
        {
            Caption = 'Warranty Claim No.';
        }
        field(25006370; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            Description = 'Only For Service or Spare Parts Trade';
            TableRelation = Make;
        }
        field(25006371; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            Description = 'Only For Service or Spare Parts Trade';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(25006372; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            Description = 'Only For Service or Spare Parts Trade';
            TableRelation = Item."No." where("Item Type" = const("Model Version"),
                                              "Make Code" = field("Make Code"),
                                              "Model Code" = field("Model Code"));

            trigger OnLookup()
            var
                recModelVersion: Record Item;
            begin
            end;
        }
        field(25006377; "Quote Applicable To Date"; Date)
        {
            Caption = 'Quote Applicable To Date';
        }
        field(25006378; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            Description = 'Not for Vehicle Trade';
            TableRelation = Vehicle;

            trigger OnValidate()
            var
                Vehicle: Record Vehicle;
            begin
            end;
        }
        field(25006379; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Description = 'Only For Service or Spare Parts Trade';
            TableRelation = "Vehicle Accounting Cycle"."No.";
        }
        field(25006390; "Vehicle Item Charge No."; Code[20])
        {
            Caption = 'Vehicle Item Charge No.';
            TableRelation = "Item Charge";
        }
        field(25006391; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
        }
        field(25006392; "Mobile Phone No."; Text[30])
        {
            Caption = 'Mobile Phone No.';
        }
        field(25006670; VIN; Code[20])
        {
            Caption = 'VIN';
            Description = 'Only For Service or Spare Parts Trade';
            TableRelation = Vehicle;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                Vehicle: Record Vehicle;
                VehicleCard: Page "Vehicle Card";
            begin
            end;
        }
        field(25006680; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract."Contract No.";

            trigger OnLookup()
            var
                Customer: Record Customer;
                ContractTemp: Record Contract temporary;
            begin
            end;
        }
        field(25006800; "Variable Field 25006800"; Code[20])
        {
            CaptionClass = '7,36,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
            end;
        }
        field(25006801; "Variable Field 25006801"; Code[20])
        {
            CaptionClass = '7,36,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
            end;
        }
        field(25006802; "Variable Field 25006802"; Code[20])
        {
            CaptionClass = '7,36,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
            end;
        }
        field(25006995; "Variable Field Run 1"; Decimal)
        {
            CaptionClass = '7,36,25006995';
        }
        field(25006996; "Variable Field Run 2"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,36,25006996';
        }
        field(25006997; "Variable Field Run 3"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,36,25006997';
        }
    }

    keys
    {
        key(Key4; "Document Profile")
        {
        }
    }

    var
        cuLookUpMgt: Codeunit LookUpManagement;
}
