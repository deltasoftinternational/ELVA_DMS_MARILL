Page 25006103 "Service Techn. Orders"
{
    Caption = 'Service Orders';
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'aaa,bbb,ccc,ddd,Task,Card';
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
            group(ActionGroup25006007)
            {
                action("Start Task")
                {
                    ApplicationArea = Basic;
                    Image = "Action";
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
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
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunPageMode = View;

                    trigger OnAction()
                    begin
                        ResourceTimeRegMgt.StartNewTaskFromHeader(Rec, ResourceTimeRegMgt.GetCurrentUserResourceNo, WorkDate, Time, true);
                        CurrPage.Update;
                    end;
                }
            }
        }
        area(navigation)
        {
            group(ActionGroup25006011)
            {
                action(Open)
                {
                    ApplicationArea = Basic;
                    Image = ViewDetails;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    RunObject = Page "Service Order EDMS";
                    RunPageLink = "No." = field("No."),
                                  "Document Type" = field("Document Type");
                }
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

