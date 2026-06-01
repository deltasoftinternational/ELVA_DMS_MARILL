page 25006576 "BLS Leasing Sched. Serv. Subp."
{

    PageType = ListPart;
    SourceTable = "BLS Leasing Sched. Serv. Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                ShowCaption = false;
                /*
                field("DMS Contract No."; Rec."DMS Contract No.")
                {
                    ApplicationArea = All;
                }
                */
                field("Service Code"; Rec."Service Code")
                {
                    ApplicationArea = All;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                }
                field("Service Description"; Rec."Service Description")
                {
                    ApplicationArea = All;
                }
                field("Price"; Rec."Price")
                {
                    ApplicationArea = All;
                }
                field("Price Including VAT"; Rec."Price Including VAT")
                {
                    ApplicationArea = All;
                }
                /*
                field("Leasing Schedule No."; Rec."Leasing Schedule No.")
                {
                    ApplicationArea = All;
                }
                */
            }
        }
    }

    actions
    {

    }
    trigger OnAfterGetRecord()
    begin

    end;

    var


}

