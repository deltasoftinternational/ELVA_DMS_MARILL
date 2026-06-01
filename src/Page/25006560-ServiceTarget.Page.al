Page 25006560 "Service Target"
{
    ApplicationArea = Basic;
    Caption = 'Service Target';
    PageType = List;
    SourceTable = "Service Target";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(Control12)
            {
                Visible = false;
                field(TotalAmount; TotalAmount)
                {
                    ApplicationArea = Basic;
                    Caption = 'Total Amount';
                    Editable = false;
                    Enabled = false;
                }
                field(TotalQuantity; TotalQuantity)
                {
                    ApplicationArea = Basic;
                    Caption = 'Total Quantity';
                    Editable = false;
                    Enabled = false;
                }
            }
            repeater(Group)
            {
                field(Location; Rec.Location)
                {
                    ApplicationArea = Basic;
                }
                field(ServiceAdvisor; Rec."Service Advisor")
                {
                    ApplicationArea = Basic;
                }
                field(Resource; Rec.Resource)
                {
                    ApplicationArea = Basic;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(SetTarget)
            {
                ApplicationArea = Basic;
                Caption = 'Set Target';
                Image = Planning;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Clear(TargetSettingsPage);
                    TargetSettingsPage.RunModal;
                end;
            }
        }
    }

    var
        StartDate: Date;
        EndDate: Date;
        TotalAmount: Decimal;
        TotalQuantity: Decimal;
        TargetSettingsPage: Page "Service Target Settings";
}

