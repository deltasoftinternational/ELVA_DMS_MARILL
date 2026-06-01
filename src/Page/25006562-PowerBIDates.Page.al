Page 25006562 "Power BI Dates"
{
    Caption = 'Power BI Dates';
    PageType = List;
    SourceTable = Date;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date; Rec."Period Start")
                {
                    ApplicationArea = Basic;
                    Caption = 'Date';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        CurrDate: Date;
    begin
        Rec.SetRange("Period Type", Rec."period type"::Date);
        if UpperCase(CopyStr(COMPANYNAME, 1, 6)) = 'CRONUS' then
            CurrDate := Dmy2date(26, 1, 2017)
        else
            CurrDate := Today();

        Rec.SetRange(Rec."Period Start", Dmy2date(1, 1, Date2dmy(CurrDate, 3) - 1), Dmy2date(31, 12, Date2dmy(CurrDate, 3)));
    end;
}

