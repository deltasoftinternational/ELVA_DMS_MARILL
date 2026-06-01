tableextension 25006570 "Contact Profile Answer" extends "Contact Profile Answer" //5089
{
    // 09-08-2007 EDMS P3
    //   * New flowfield - comment to access to comments of answer
    // 10-08-2007 EDMS P3
    //   * Deleteing of unneded comments
    fields
    {
        field(25006000; Comment; Date)
        {
            CalcFormula = max("Profile Answer Comment Line".Date where("Contact No." = field("Contact No."),
                                                                        "Profile Questionnaire Code" = field("Profile Questionnaire Code"),
                                                                        "Answer Line No." = field("Line No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}