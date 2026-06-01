tableextension 25006132 "Marketing Setup" extends "Marketing Setup" //5075
{
    // 06.06.2013 EDMS P8
    //   * DELETED FIELD "Calendar Code"
    // 
    // 01-08-2007 EDMS P3
    //   * New field "PopUp Questionaire on new cont"
    fields
    {
        field(25006000; "PopUp Questionaire on new cont"; Boolean)
        {
            Caption = 'PopUp Questionaire on new contact';
        }
        field(25006010; "Workday Starting Time"; Time)
        {
            Caption = 'Workday Starting Time';
        }
        field(25006020; "Working Week Length"; Integer)
        {
            Caption = 'Working Week Length';
            MaxValue = 7;
            MinValue = 1;
        }
        field(25006030; "First Day of Week"; Option)
        {
            Caption = 'First day of week';
            OptionCaption = 'Sun,Mon';
            OptionMembers = Sun,Mon;
        }
        field(25006040; "Move To-dos on Non-Working Day"; Option)
        {
            Caption = 'Move To-dos on Non-Working Day';
            OptionCaption = 'Forward,Backward';
            OptionMembers = Forward,Backward;
        }
    }

}