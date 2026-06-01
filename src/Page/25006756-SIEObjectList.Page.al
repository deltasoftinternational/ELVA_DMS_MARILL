/*
Page 25006756 "SIE Object List"
{
    ApplicationArea = Basic;
    Caption = 'SIE Object List';
    CardPageID = "SIE Object Card";
    Editable = false;
    PageType = List;
    SourceTable = "SIE Object";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(SIENo; Rec."SIE No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(NAVNo; Rec."NAV No.")
                {
                    ApplicationArea = Basic;
                }
                field(NAVNo2; Rec."NAV No. 2")
                {
                    ApplicationArea = Basic;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}
*/