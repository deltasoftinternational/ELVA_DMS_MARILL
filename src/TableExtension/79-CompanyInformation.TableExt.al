tableextension 25006018 "Company Information" extends "Company Information" //79
{
    // 15.05.2016 EB.P30 EDMS
    //   Added fields:
    //     "Invoice Header Picture"
    //     "Invoice Footer Picture"

    fields
    {
        field(25006950; "Invoice Header Picture"; Blob)
        {
            Caption = 'Invoice Header Picture';
            SubType = Bitmap;
        }
        field(25006960; "Invoice Footer Picture"; Blob)
        {
            Caption = 'Invoice Footer Picture';
            SubType = Bitmap;
        }
        field(25006970; "Invoice Disclaimer Picture"; Blob)
        {
            Caption = 'Invoice Disclaimer Picture';
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(25006971; "Jobsheet Disclaimer Picture"; Blob)
        {
            Caption = 'Jobsheet Disclaimer Picture';
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(25006975; "Garage Hive Beta"; Boolean)
        {
            Caption = 'Garage Hive Beta';
            DataClassification = ToBeClassified;
        }
    }

}