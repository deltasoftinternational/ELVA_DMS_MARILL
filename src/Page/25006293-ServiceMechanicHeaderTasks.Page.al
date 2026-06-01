Page 25006293 "Service Mechanic Header Tasks"
{
    Caption = 'Service Orders';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Service Header EDMS";
    SourceTableView = sorting("Document Type", "Order Date")
                      order(descending)
                      where("Document Type" = const(Order));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                }
                field(ModelCode; Rec."Model Code")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleRegistrationNo; Rec."Vehicle Registration No.")
                {
                    ApplicationArea = Basic;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCustomerName; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field(Resources; Resources)
                {
                    ApplicationArea = Basic;
                    Caption = 'Resources';
                }
                field(WorkStatusCode; Rec."Work Status Code")
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
            action("Start Task")
            {
                ApplicationArea = Basic;
                Image = "Action";
                RunPageMode = View;

                trigger OnAction()
                begin
                    ResourceTimeRegMgt.StartNewTaskFromHeader(Rec, ResourceTimeRegMgt.GetCurrentUserResourceNo, WorkDate, Time, false);
                    CurrPage.Update;
                end;
            }
            action("Start Travel Task")
            {
                ApplicationArea = Basic;
                Image = "Action";
                RunPageMode = View;

                trigger OnAction()
                begin
                    ResourceTimeRegMgt.StartNewTaskFromHeader(Rec, ResourceTimeRegMgt.GetCurrentUserResourceNo, WorkDate, Time, true);
                    CurrPage.Update;
                end;
            }
            action(Open)
            {
                ApplicationArea = Basic;
                Image = ViewDetails;
                RunObject = Page "Service Order EDMS";
                RunPageLink = "No." = field("No."),
                              "Document Type" = field("Document Type");
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        //
    end;

    trigger OnAfterGetRecord()
    begin
        Resources := Rec.GetResourceTextFieldValue;
    end;

    var
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
        Resources: Text;
}

