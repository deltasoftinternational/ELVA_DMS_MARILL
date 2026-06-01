Page 25006858 "Lost Sales Entries"
{
    ApplicationArea = Basic;
    Caption = 'Lost Sales Entries';
    Editable = false;
    PageType = List;
    SourceTable = "Lost Sales Entry";
    UsageCategory = ReportsAndAnalysis;

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                }
                field(ItemNo; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                }
                field(ItemCategoryCode; Rec."Item Category Code")
                {
                    ApplicationArea = Basic;
                }
                //field(ProductGroupCode;"Product Group Code")
                //{
                //    ApplicationArea = Basic;
                //}
                //field(ProductSubgroupCode;"Product Subgroup Code")
                //{
                //    ApplicationArea = Basic;
                //}
                field(CustomerNo; Rec."Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Description2; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ReasonCode; Rec."Reason Code")
                {
                    ApplicationArea = Basic;
                }
                field(ReasonDescription; Rec."Reason Description")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ReasonDescription2; Rec."Reason Description 2")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = Basic;
                }
                field(Automatic; Rec.Automatic)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(EntryNo; Rec."Entry No.")
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
        area(reporting)
        {
            action(LostSales)
            {
                ApplicationArea = All;
                Caption = '&Report';
                Image = Report;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var

                begin
                    Report.Run(Report::"Lost Sales");
                end;
            }
        }
    }
}

