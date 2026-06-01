Page 25006356 "Service Documents - Allocation"
{
    Caption = 'Service Documents - Allocation';
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Service Header EDMS";
    SourceTableView = where("Document Type" = filter(Quote | Order));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCustomerNo; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCustomerName; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field(VIN; Rec.VIN)
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
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("<Action1101904012>")
            {
                ApplicationArea = Basic;
                Caption = 'Create Service Quote';
                Image = Quote;
                Promoted = true;

                trigger OnAction()
                begin
                    DocumentNo := ServiceScheduleMgt.CreateNewServiceDocument(Documenttype::Quote);
                    Rec.SetRange("Document Type", Rec."document type"::Quote);
                    Rec.SetRange("No.", DocumentNo);
                    if Rec.FindFirst then;
                    Rec.SetRange("Document Type");
                    Rec.SetRange("No.");
                end;
            }
            action("<Action1101904021>")
            {
                ApplicationArea = Basic;
                Caption = 'Create Service Order';
                Image = NewOrder;
                Promoted = true;

                trigger OnAction()
                begin
                    DocumentNo := ServiceScheduleMgt.CreateNewServiceDocument(Documenttype::Order);
                    Rec.SetRange("Document Type", Rec."document type"::Order);
                    Rec.SetRange("No.", DocumentNo);
                    if Rec.FindFirst then;
                    Rec.SetRange("Document Type");
                    Rec.SetRange("No.");
                end;
            }
        }
        area(processing)
        {
            action("<Action1101904013>")
            {
                ApplicationArea = Basic;
                Caption = '&Edit';
                Image = Edit;
                Promoted = true;
                ShortCutKey = 'Shift+Ctrl+E';

                trigger OnAction()
                begin
                    if Rec."Document Type" = Rec."document type"::Quote then
                        Page.Run(Page::"Service Quote EDMS", Rec)
                    else
                        Page.Run(Page::"Service Order EDMS", Rec);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if SingleInstanceMgt.GetServiceHeader(ServiceHeader) then begin
            Rec."Document Type" := ServiceHeader."Document Type";
            Rec."No." := ServiceHeader."No.";
        end;
        //SETRANGE("Document Type",ServiceHeader."Document Type"); //!!
    end;

    var
        SingleInstanceMgt: Codeunit SingleInstanceManagement;
        ServiceHeader: Record "Service Header EDMS";
        DocumentNo: Code[20];
        DocumentType: Option Quote,"Order","Return Order";
        ServiceScheduleMgt: Codeunit "Service Schedule Mgt.";


    procedure SetDocumentType(DocumentTypeForFilter: Option)
    begin
        DocumentType := DocumentTypeForFilter;
    end;
}

