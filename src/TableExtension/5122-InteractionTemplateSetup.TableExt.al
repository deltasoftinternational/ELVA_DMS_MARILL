tableextension 25006147 "Interaction Template Setup" extends "Interaction Template Setup" //5122
{
    // 11.02.2016 EB.P7 Added field SMS
    fields
    {
        field(25006000; SMS; Code[10])
        {
            TableRelation = "Interaction Template" where("Attachment No." = const(0));
        }
    }
}
