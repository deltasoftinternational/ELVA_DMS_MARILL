tableextension 25006152 "Transfer Receipt Header" extends "Transfer Receipt Header" //5746
{
    // 20.01.2017 EDMS Upgrade 2017
    //   Modified function CopyFromTransferHeader
    fields
    {
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = " ","Spare Parts Trade","Vehicles Trade",Service;
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
    Keys
    {
        key(Key3; "Document Profile")
        {
        }
        key(Key4; "Document Profile", "Source Type", "Source Subtype", "Source No.")
        {
        }
    }
}
