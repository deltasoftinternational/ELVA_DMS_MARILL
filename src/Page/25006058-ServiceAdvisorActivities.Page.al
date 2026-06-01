Page 25006058 "Service Advisor Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = "Service Cue EDMS";

    layout
    {
        area(content)
        {
            cuegroup(ServiceOrders)
            {
                Caption = 'Service Orders';
                field(ServiceOrdersInactive; Rec."Service Orders - Unplanned")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Service Orders EDMS";
                }
                field(ServiceOrdersPlaned; Rec."Service Orders - Planned")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Service Orders EDMS";
                }
                field(ServiceOrdersInProcess; Rec."Service Orders - In Process")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Service Orders EDMS";
                }
                field(ServiceOrdersOnHold; Rec."Service Orders - OnHold")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Service Orders EDMS";
                }
                field(ServiceOrdersFinished; Rec."Service Orders - Finished")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Service Orders EDMS";
                }

                actions
                {
                    action(NewServiceOrder)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Service Order';
                        Image = Document;
                        RunObject = Page "Service Order EDMS";
                        RunPageMode = Create;
                    }
                    action("<Action1>")
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Vehicle';
                        Image = New;
                        RunObject = Page "Vehicle Card";
                        RunPageMode = Create;
                    }
                    action("<Action3>")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Schedule';
                        Image = Allocations;
                        RunObject = Page "Service Schedule";
                    }
                }
            }
            cuegroup(ReturnOrders)
            {
                Caption = 'Service Return Orders';
                field(ServiceReturnOrders; Rec."Service Return Orders")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Service Return Orders EDMS";
                }

                actions
                {
                    action(NewServiceReturnOrder)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Service Return Order';
                        RunObject = Page "Service Return Order EDMS";
                        RunPageMode = Create;
                    }
                }
            }
            cuegroup(ServiceQuotes)
            {
                Caption = 'Service Quotes';
                field(OpenServiceQuotes; Rec."Open Service Quotes")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Service Quotes EDMS";
                }

                actions
                {
                    action(NewServiceQuote)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Service Quote';
                        RunObject = Page "Service Quote EDMS";
                        RunPageMode = Create;
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        StandardEvent: Record "Serv. Standard Event";
    begin
    end;

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;

        Rec.SetRange("Date Filter", 0D, WorkDate);
    end;
}

