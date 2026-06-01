tableextension 25006046 "Detailed CV Ledg. Entry Buffer" extends "Detailed CV Ledg. Entry Buffer" //383
{
    // 20.06.2019 EB.P30 EDMS
    //   Added field:
    //     383 "Document Profile"

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
