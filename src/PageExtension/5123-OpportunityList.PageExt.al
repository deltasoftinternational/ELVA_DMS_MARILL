pageextension 25006024 "Opportunity List" extends "Opportunity List"//5123
{
    layout
    {
        addafter("Campaign Description")
        {
            field(Type; Rec.Type)
            {
                ApplicationArea = Basic;
            }
        }
    }
}