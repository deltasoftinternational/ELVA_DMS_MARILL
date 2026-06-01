Page 25006171 "Easy Time Wksh. Doc. Tasks"
{
    // 27/07/2017 GP1 P1
    //  *added Deal Type field (called Service Type)
    //  *added Vehicle Serial No. field (called Vehicle No.)
    //  *VIN field made visible=false
    //  *Added field "External Document No."

    Caption = 'Service Orders';
    Editable = false;
    PageType = List;
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
                field(ServiceType; Rec."Deal Type")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Type';
                }
                field(VehicleNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle No.';
                }
                field(VehicleRegistrationNo; Rec."Vehicle Registration No.")
                {
                    ApplicationArea = Basic;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
                field(ScheduleStartDateTime; DateTimeMgt.Datetime2Date(Rec."Schedule Start Date Time"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Start Date Time';
                    Visible = false;
                }
                field(ExternalDocumentNo; Rec."External Document No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
        Rec.CalcFields("Schedule Start Date Time");
    end;

    var
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
        Resources: Text;
        DateTimeMgt: Codeunit "Datetime Mgt.";
}

