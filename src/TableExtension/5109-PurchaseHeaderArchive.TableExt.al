tableextension 25006143 "Purchase Header Archive" extends "Purchase Header Archive" //5109
{
    // 20.02.2015 EB.P7 #Arch Ret.Ord.
    //   Renewed EDMS fields from Purchase Header

    fields
    {
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade";
        }
        field(25006001; "Deal Type Code"; Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
        }
        field(25006020; "Auto Created Doc"; Boolean)
        {
            Caption = 'Auto Created Document';
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
            Editable = true;
            TableRelation = "Vehicle Accounting Cycle"."No.";
        }
        field(25006700; "Ordering Price Type Code"; Code[20])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }
    }

    keys
    {
        key(Key4; "Document Profile")
        {
        }
    }
}
