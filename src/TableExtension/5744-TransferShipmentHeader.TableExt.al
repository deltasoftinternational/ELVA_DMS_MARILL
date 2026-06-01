tableextension 25006148 "Transfer Shipment Header" extends "Transfer Shipment Header" //5744
{
    fields
    {
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = " ","Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006100; "Transfer-to Customer No."; Code[20])
        {
            Caption = 'Transfer-to Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            var
                Cust: Record Customer;
            begin
                if "Transfer-to Customer No." = '' then begin
                    "Transfer-to Customer Name" := '';
                    exit;
                end;
                if Cust.Get("Transfer-to Customer No.") then
                    "Transfer-to Customer Name" := Cust.Name;
            end;
        }
        field(25006110; "Transfer-to Customer Name"; Text[100])
        {
            Caption = 'Transfer-to Customer Name';
        }
        field(25006160; "Source Type"; Integer)
        {
            Caption = 'Source Type';
            Editable = false;
        }
        field(25006166; "Source Subtype"; Option)
        {
            Caption = 'Source Subtype';
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(25006200; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = if ("Source Type" = const(25006145)) "Service Header EDMS"."No." where("Document Type" = field("Source Subtype"));
            //This property is currently not supported
            //TestTableRelation = false;
        }
    }

    keys
    {
        key(Key3; "Document Profile")
        {
        }
        key(Key4; "Document Profile", "Source Type", "Source Subtype", "Source No.")
        {
        }
    }

}