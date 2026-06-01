pageextension 25006066 "Req. Worksheet Template List" extends "Req. Worksheet Template List"//292
{
    layout
    {
        modify("Page ID")
        {
            visible = true;
        }
        addafter("Page ID")
        {
            field(DocumentProfile; Rec."Document Profile")
            {
                ApplicationArea = All;
            }

            field("Page Caption"; Rec."Page Caption")
            {
                ApplicationArea = Planning;
                DrillDown = false;
                ToolTip = 'Specifies the displayed name of the journal or worksheet that uses the template.';
            }
        }
    }
}