Page 25006354 "Service Lines - Allocation"
{
    Caption = 'Service Lines - Allocation';
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Service Line EDMS";
    SourceTableView = sorting("Document Type", "Document No.", "Line No.")
                      order(ascending)
                      where("Document Type" = filter(Quote | Order),
                            Type = const(Labor));

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
                field(DocumentNo; Rec."Document No.")
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
                field(Description2; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Resources; Resources)
                {
                    ApplicationArea = Basic;
                    Caption = 'Resources';
                    Enabled = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(StandardTime; Rec."Standard Time")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SelltoCustomerNo; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SelltoCustomerName; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoCustomerNo; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(BilltoName; Rec."Bill-to Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(CreateServiceQuote)
            {
                ApplicationArea = Basic;
                Caption = 'Create Service Quote';
                Image = Quote;
                Promoted = true;

                trigger OnAction()
                begin
                    DocumentNo := ServiceScheduleMgt.CreateNewServiceDocument(Documenttype::Quote);
                    Rec.SetRange("Document Type", Rec."document type"::Quote);
                    Rec.SetRange("Document No.", DocumentNo);
                    if Rec.FindFirst then;
                    Rec.SetRange("Document Type");
                    Rec.SetRange("Document No.");
                end;
            }
            action(CreateServiceOrder)
            {
                ApplicationArea = Basic;
                Caption = 'Create Service Order';
                Image = NewOrder;
                Promoted = true;

                trigger OnAction()
                begin
                    DocumentNo := ServiceScheduleMgt.CreateNewServiceDocument(Documenttype::Order);
                    Rec.SetRange("Document Type", Rec."document type"::Order);
                    Rec.SetRange("Document No.", DocumentNo);
                    if Rec.FindFirst then;
                    Rec.SetRange("Document Type");
                    Rec.SetRange("Document No.");
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Resources := ServiceScheduleMgt.GetRelatedResources(Rec."Document Type", Rec."Document No.", Rec.Type, Rec."Line No.", 0);
    end;

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetRange(Type, Rec.Type::Labor);
        Rec.FilterGroup(0);

        if SingleInstanceMgt.GetServiceHeader(ServiceHeader) then begin
            Rec.SetRange("Document Type", ServiceHeader."Document Type");
            Rec.SetRange("Document No.", ServiceHeader."No.");
            if Rec.FindFirst then;
            Rec.SetRange("Document Type");
            Rec.SetRange("Document No.");
        end;
        //SETRANGE("Document Type","Document Type"::Order); //!!
        //SETRANGE("Document Type",ServiceHeader."Document Type"); //!!
    end;

    var
        SingleInstanceMgt: Codeunit SingleInstanceManagement;
        ServiceHeader: Record "Service Header EDMS";
        [InDataSet]
        Resources: Text[250];
        ServiceScheduleMgt: Codeunit "Service Schedule Mgt.";
        DocumentNo: Code[20];
        DocumentType: Option Quote,"Order","Return Order";


    procedure SetSelectionFilter1(var ServLine: Record "Service Line EDMS")
    begin
        CurrPage.SetSelectionFilter(ServLine);
    end;


    procedure SetDocumentType(DocumentTypeForFilter: Option)
    begin
        DocumentType := DocumentTypeForFilter;
    end;
}

