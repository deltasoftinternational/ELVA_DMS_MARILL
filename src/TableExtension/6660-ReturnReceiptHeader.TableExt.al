tableextension 25006377 "Return Receipt Header" extends "Return Receipt Header" //6660  
{
    // 27.05.2016 EB.P30 #T086
    //   Added fields:
    //     "Phone No."
    // 
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
        }
        field(25006007; "Quote No."; Code[20])
        {
            Caption = 'Quote No.';
        }
        field(25006120; "Service Order No. EDMS"; Code[20])
        {
            Caption = 'Service Order No. EDMS';
        }
        field(25006130; "Service Document EDMS"; Boolean)
        {
            Caption = 'Service Document EDMS';
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
                recModelVersion.Reset;
                if cuLookUpMgt.LookUpModelVersion(recModelVersion, "Model Version No.", "Make Code", "Model Code") then;
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
        }
        field(25006379; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Description = 'Only For Service or Spare Parts Trade';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle"."No.";
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
        }
    }

    keys
    {
        key(Key6; "Document Profile")
        {
        }
    }

    var
        cuLookUpMgt: Codeunit LookUpManagement;
}
