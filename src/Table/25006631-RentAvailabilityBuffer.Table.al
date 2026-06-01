Table 25006631 "Rent Availability Buffer"
{
    Caption = 'Rent Availability Buffer';

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
        }
        field(20; Type; Option)
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Rented,Reserved,Requested,Scheduled Service,In Service,Received';
            OptionMembers = " ",Rented,Reserved,Requested,"Scheduled Service","In Service",Recieved;
        }
        field(30; "Rent Item No."; Code[20])
        {
            Caption = 'Rent Item No.';
            DataClassification = ToBeClassified;
        }
        field(40; "Rent Item Total Qty."; Decimal)
        {
            Caption = 'Rent Item Total Qty.';
            DataClassification = ToBeClassified;
        }
        field(50; "Rent Asset No."; Code[20])
        {
            Caption = 'Rent Asset No.';
            DataClassification = ToBeClassified;
        }
        field(60; "Rent Asset Total Qty."; Decimal)
        {
            Caption = 'Rent Asset Total Qty.';
            DataClassification = ToBeClassified;
        }
        field(70; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
        }
        field(80; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = ToBeClassified;
        }
        field(90; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            DataClassification = ToBeClassified;
        }
        field(100; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = ToBeClassified;
        }
        field(110; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = ToBeClassified;
        }
        field(120; "Service Order No."; Code[20])
        {
            Caption = 'Service Order No.';
            DataClassification = ToBeClassified;
        }
        field(125; "Rent Document Type"; Option)
        {
            Caption = 'Rent Document Type';
            DataClassification = ToBeClassified;
            OptionMembers = Quote,"Order","Return Order";
        }
        field(130; "Rent Document No."; Code[20])
        {
            Caption = 'Rent Document No.';
            DataClassification = ToBeClassified;
        }
        field(140; "Rent Document Line No."; Integer)
        {
            Caption = 'Rent Document Line No.';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

