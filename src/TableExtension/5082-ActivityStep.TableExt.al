tableextension 25006131 "Activity Step" extends "Activity Step" //5082
{
    fields
    {
        field(25006000; Location; Text[50])
        {
            Caption = 'Location';
        }
        field(25006010; "All Day Event"; Boolean)
        {
            Caption = 'All Day Event';
        }
        field(25006020; Duration; Duration)
        {
            Caption = 'Duration';
        }
        field(25006030; "Interaction Template Code"; Code[10])
        {
            Caption = 'Interaction Template Code';
            TableRelation = "Interaction Template";
        }
    }
}