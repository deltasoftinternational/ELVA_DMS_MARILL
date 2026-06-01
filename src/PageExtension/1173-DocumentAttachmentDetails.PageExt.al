pageextension 25006079 "Document Attachment Details" extends "Document Attachment Details"//1173
{
    layout
    {
        addafter("Document Flow Sales")
        {
            field(IncludeInEmail; Rec.IncludeInEmail)
            {
                ApplicationArea = All;
            }
        }
    }
}