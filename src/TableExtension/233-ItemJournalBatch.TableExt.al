tableextension 25006023 "Item Journal Batch" extends "Item Journal Batch" //233
{
    fields
    {
        field(25006100; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(25006110; "New Location Code"; Code[10])
        {
            Caption = 'New Location Code';
            TableRelation = Location;
        }
        field(25006120; "Salespers./Purch. Mandatory"; Boolean)
        {
            Caption = 'Salespers./Purch. Mandatory';
        }
    }
}