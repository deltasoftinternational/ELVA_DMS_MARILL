tableextension 25006032 "CV Ledger Entry Buffer" extends "CV Ledger Entry Buffer" //382
{
    // 
    // 20.06.2019 P30 EMDS
    //   Added field:
    //     25006000"Document Profile"
    fields
    {
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
        }
    }

}