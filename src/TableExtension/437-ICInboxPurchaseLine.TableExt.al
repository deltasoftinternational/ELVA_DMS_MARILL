tableextension 25006121 "IC Inbox Purchase Line" extends "IC Inbox Purchase Line" //437
{
    fields
    {
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006372; "Line Type"; Option)
        {
            Caption = 'Line Type';
            OptionCaption = ' ,Vehicle,,,Charge (Item),G/L Account';
            OptionMembers = " ",Vehicle,,Item,"Charge (Item)","G/L Account";
        }
        field(25006373; VIN; Code[20])
        {
            Caption = 'VIN';
            Editable = false;
        }
        field(25006386; "Vehicle Body Colour Code"; Code[10])
        {
            Caption = 'Vehicle Body Colour Code';
            TableRelation = "Body Color";
        }
        field(25006388; "Vehicle Interior Code"; Code[10])
        {
            Caption = 'Vehicle Interior Code';
            TableRelation = "Vehicle Interior";
        }
        field(25006390; "Vendor Order No."; Text[30])
        {
            Caption = 'Vendor Order No.';
        }
        field(25006400; "Your Serial No."; Code[20])
        {
            Caption = 'Your Serial No.';
        }
    }
}
