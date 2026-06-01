tableextension 25006003 "G/L Entry" extends "G/L Entry" //17
{
    fields
    {
        field(25006001; VIN; Code[20])
        {
            CalcFormula = lookup(Vehicle.VIN where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Vehicle;
        }
        field(25006010; "Deal Type Code"; Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
        }
        field(25006050; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No';
        }
        field(25006170; "Vehicle Registration No."; Code[20])
        {
            CalcFormula = lookup(Vehicle."Registration No." where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Vehicle Registration No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006379; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            TableRelation = "Vehicle Accounting Cycle"."No.";
        }
        field(25006400; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract."Contract No.";
        }
    }

    keys
    {
        key(DMS1; "G/L Account No.", "Source Type", "Source Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date")
        {
        }
        key(DMS2; "G/L Account No.", "Source Type", "Source No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date")
        {
            SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount";
        }
        //  Create a combination key from BaseApp & extension !!!

        /*   key(DMS3; "G/L Account No.", "Vehicle Serial No.", "Vehicle Accounting Cycle No.", "Posting Date")
           {
               SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount";
           }
   */
    }

}