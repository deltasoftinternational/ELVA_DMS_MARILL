tableextension 25006022 "Sales Invoice Header" extends "Sales Invoice Header" //112
{
    // 02.08.2018 EB.P30 EDMS Rent
    //   Modified field "Document Profile":
    //     Added option "Rent"
    //   Added field:
    //     25006600 "Rent Order No."
    // 
    // 05.02.2018 EB.P30 EDMS
    //   Added field:
    //     25006680 "Contract No."
    // 
    // 27.05.2016 EB.P30 #T086
    //   Added fields:
    //     "Phone No."
    //     "Mobile Phone No."
    // 
    // 23.01.2013 EDMS P8
    //   * Added fields: Resources
    // 
    // 21.07.2008. EDMS P2
    //   * Added key "DMS Service Order No.,DMS Service Document"
    // 
    // 24.09.2007. EDMS P2
    //   * Added new field Kilometrage
    // 
    // 06.08.2007. EDMS P2
    //   * Added new key "Posting Date"
    fields
    {
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service,Rent';
            OptionMembers = " ","Spare Parts Trade","Vehicles Trade",Service,Rent;
        }
        field(25006001; "Deal Type Code"; Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
        }
        field(25006005; "Prepmt. Bill-to Cust. Changed"; Boolean)
        {
            Caption = 'Prepmt. Bill-to Cust. Changed';
        }
        field(25006120; "Service Order No."; Code[20])
        {
            Caption = 'Service Order No.';
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
        field(25006400; Resources; Code[100])
        {
        }
        field(25006600; "Rent Order No."; Code[20])
        {
            Description = 'Only for Rent';

            trigger OnLookup()
            var
                RentHeader: Record "Rent Header";
                RentOrdrNotFoundMsg: label 'Rent Order not found.';
            begin
                RentHeader.Reset;
                RentHeader.SetRange("No.", "Rent Order No.");
                if RentHeader.FindFirst then
                    Page.Run(Page::"Rent Order", RentHeader)
                else
                    Message(RentOrdrNotFoundMsg);
            end;
        }
        field(25006670; VIN; Code[20])
        {
            Caption = 'VIN';
            Description = 'Only For Service or Spare Parts Trade';
            TableRelation = Vehicle;
        }
        field(25006680; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract."Contract No.";
        }
        field(25006800; "Variable Field 25006800"; Code[20])
        {
            CaptionClass = '7,112,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if cuLookUpMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006800"),
                  "Make Code", "Variable Field 25006800") then begin
                    Validate("Variable Field 25006800", VFOptions.Code);
                end;
            end;
        }
        field(25006801; "Variable Field 25006801"; Code[20])
        {
            CaptionClass = '7,112,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if cuLookUpMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006801"),
                  "Make Code", "Variable Field 25006801") then begin
                    Validate("Variable Field 25006801", VFOptions.Code);
                end;
            end;
        }
        field(25006802; "Variable Field 25006802"; Code[20])
        {
            CaptionClass = '7,112,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if cuLookUpMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006802"),
                  "Make Code", "Variable Field 25006802") then begin
                    Validate("Variable Field 25006802", VFOptions.Code);
                end;
            end;
        }
        field(25006995; "Variable Field Run 1"; Decimal)
        {
            CaptionClass = '7,112,25006995';
        }
        field(25006996; "Variable Field Run 2"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,112,25006996';
        }
        field(25006997; "Variable Field Run 3"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,112,25006997';
        }

    }
    keys
    {
        key(Key14; "Document Profile")
        {
        }
        key(Key15; "Vehicle Serial No.")
        {
        }
        key(Key16; "Service Order No.", "Service Document")
        {
        }
    }
    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        Clear(cuVFMgt);
        exit(cuVFMgt.IsVFActive(Database::"Sales Invoice Header", intFieldNo));
    end;

    var
        cuLookUpMgt: Codeunit LookUpManagement;
        cuVFMgt: Codeunit "Variable Field Management";
}