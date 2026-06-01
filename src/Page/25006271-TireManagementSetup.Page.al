Page 25006271 "Tire Management Setup"
{
    ApplicationArea = Basic;
    Caption = 'Tire Management Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Tire Management Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(CheckTireUnique; Rec."Check Tire Unique")
                {
                    ApplicationArea = Basic;
                }
                field(TireManagementActive; Rec."Tire Management Active")
                {
                    ApplicationArea = Basic;
                }
                field(DefaultPlatformTemplate; Rec."Default Platform Template")
                {
                    ApplicationArea = Basic;
                }
                field(SetFirstValues; Rec."Set First Values")
                {
                    ApplicationArea = Basic;
                }
                field(TireNos; Rec."Tire Nos.")
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
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
    end;
}

