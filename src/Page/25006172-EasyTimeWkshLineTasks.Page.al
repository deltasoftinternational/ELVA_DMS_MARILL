Page 25006172 "Easy Time Wksh. Line Tasks"
{
    Caption = 'Service Order Lines';
    Editable = false;
    PageType = List;
    SourceTable = "Service Line EDMS";
    SourceTableView = where(Type = const(Labor));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(UnitofMeasure; Rec."Unit of Measure")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field(Resources; Resources)
                {
                    ApplicationArea = Basic;
                    Caption = 'Resource';
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
                    ResourceTimeRegMgt.StartNewTaskFromLine(Rec, ResourceTimeRegMgt.GetCurrentUserResourceNo, WorkDate, Time, false);
                    CurrPage.Update;
                end;
            }
            action("Open Document")
            {
                ApplicationArea = Basic;
                Image = ViewDetails;
                RunObject = Page "Service Order EDMS";
                RunPageLink = "Document Type" = field("Document Type"),
                              "No." = field("Document No.");
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
        Cust: Record Customer;
        Resources: Text;
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
}

