tableextension 25006034 "Source Code Setup" extends "Source Code Setup" //242
{
    // 02.08.2018 EB.P30 EDMS Rent
    //   Added field:
    //     25006600 "Rent Journal"
    //     25006601 "Rent Management"
    fields
    {
        field(25006100; "Service Management EDMS"; Code[10])
        {
            Caption = 'Service Management EDMS';
            TableRelation = "Source Code";
        }
        field(25006110; "Service G/L WIP EDMS"; Code[10])
        {
        }
        field(25006600; "Rent Journal"; Code[10])
        {
            Caption = 'Rent Journal';
        }
        field(25006601; "Rent Management"; Code[10])
        {
        }
    }
}