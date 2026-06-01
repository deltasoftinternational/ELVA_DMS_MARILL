Page 25006571 "Res. Performance Chart Setup"
{
    Caption = 'Resource Performance Chart Setup';
    PageType = Card;
    SourceTable = "Res. Performance Chart Setup";

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
                field(ServicePerson; Rec."Service Person")
                {
                    ApplicationArea = Basic;
                }
                field(ResourceNo; Rec."Resource No.")
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

