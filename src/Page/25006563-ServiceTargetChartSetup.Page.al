Page 25006563 "Service Target Chart Setup"
{
    Caption = 'Service Target Chart Setup';
    PageType = Card;
    SourceTable = "Service Target Chart Setup";

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
                field(ChartType; Rec."Chart Type")
                {
                    ApplicationArea = Basic;
                }
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

