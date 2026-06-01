Page 25006297 "Modify Res. Time Reg. Entry"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    SourceTable = "Resource Time Reg. Entry";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(Control25006001)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                }
                field(Time; Rec.Time)
                {
                    ApplicationArea = Basic;
                }
                field(TimeSpent; Rec."Time Spent")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }


    procedure SetEntry(ResourceTimeRegEntry: Record "Resource Time Reg. Entry")
    begin
        Rec := ResourceTimeRegEntry;
        Rec.Insert;
    end;
}

