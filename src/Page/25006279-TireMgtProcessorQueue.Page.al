Page 25006279 "Tire Mgt. Processor Queue"
{
    Caption = 'Tire Mgt. Processor Queue';
    PageType = CardPart;
    SourceTable = "Tire Mgt Cue";

    layout
    {
        area(content)
        {
            cuegroup(Inprocess)
            {
                Caption = 'In process';
                field(ServiceLinesCount; Rec."Service Lines Count")
                {
                    ApplicationArea = Basic;
                }

                actions
                {
                    action(NewServiceOrder)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Service Order';
                        RunObject = Page "Service Order";
                        RunPageMode = Create;
                    }
                }
            }
            cuegroup(Postedinfo)
            {
                Caption = 'Posted info';
                field(PutonTiresCount; Rec."Put on Tires Count")
                {
                    ApplicationArea = Basic;
                }

                actions
                {
                    action(NewTire)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Tire';
                        RunObject = Page Tires;
                        RunPageMode = Create;
                    }
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

