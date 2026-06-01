/*
Page 25006759 "SIE Object Categories"
{
    Caption = 'SIE Object Categories';
    PageType = List;
    SourceTable = "SIE Object Category";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action56>")
            {
                Caption = 'Category';
                action("<Action58>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Objects';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "SIE Object List";
                    RunPageLink = "SIE No." = field("SIE No."),
                                  Category = field("No.");
                    ShortCutKey = 'F7';
                }
            }
        }
    }
}
*/