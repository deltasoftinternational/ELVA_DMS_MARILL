Page 25006567 "Service MTD Chart Setup"
{
    PageType = Card;
    SourceTable = "Service MTD Chart Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(PeriodLength; Rec."Period Length")
                {
                    ApplicationArea = Basic;
                }
                field(UseWorkDateasBase; Rec."Use Work Date as Base")
                {
                    ApplicationArea = Basic;
                }
                field(ValuetoCalculate; Rec."Value to Calculate")
                {
                    ApplicationArea = Basic;
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ServiceAdvisor; Rec."Service Advisor")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Resource; Rec.Resource)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(GroupBy; Rec."Group By")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange("User ID", UserId);
    end;
}

