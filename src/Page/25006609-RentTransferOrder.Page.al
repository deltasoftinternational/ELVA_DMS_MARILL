Page 25006609 "Rent Transfer Order"
{
    Caption = 'Rent Transfer Order';
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Documents,History,Print';
    SourceTable = "Rent Transfer Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCustomerNo; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoContactNo; Rec."Sell-to Contact No.")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCustomerName; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoAddress; Rec."Sell-to Address")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoAddress2; Rec."Sell-to Address 2")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoPostCode; Rec."Sell-to Post Code")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCity; Rec."Sell-to City")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoContact; Rec."Sell-to Contact")
                {
                    ApplicationArea = Basic;
                }
                field(RentOrderNo; Rec."Rent Order No.")
                {
                    ApplicationArea = Basic;
                }
                field(ContractNo; Rec."Contract No.")
                {
                    ApplicationArea = Basic;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(ShipmentDate; Rec."Shipment Date")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field(TransferfromCode; Rec."Transfer-from Code")
                {
                    ApplicationArea = Basic;
                }
                field(TransfertoCode; Rec."Transfer-to Code")
                {
                    ApplicationArea = Basic;
                }
                field(TransferType; Rec."Transfer Type")
                {
                    ApplicationArea = Basic;
                }
                field(ShipmentTime; Rec."Shipment Time")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentStatus; Rec."Document Status")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control25006043; "Rent Transfer Order Subpage")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
            group(Invoicing)
            {
                Visible = false;
                field(BilltoCustomerNo; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoName; Rec."Bill-to Name")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoAddress; Rec."Bill-to Address")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoAddress2; Rec."Bill-to Address 2")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoPostCode; Rec."Bill-to Post Code")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoCity; Rec."Bill-to City")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoContact; Rec."Bill-to Contact")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoMobilePhoneNo; Rec."Bill-to Mobile Phone No.")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Shipping)
            {
                field(ShiptoCode; Rec."Ship-to Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShiptoName; Rec."Ship-to Name")
                {
                    ApplicationArea = Basic;
                }
                field(ShiptoAddress; Rec."Ship-to Address")
                {
                    ApplicationArea = Basic;
                }
                field(ShiptoAddress2; Rec."Ship-to Address 2")
                {
                    ApplicationArea = Basic;
                }
                field(ShiptoPostCode; Rec."Ship-to Post Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShiptoCity; Rec."Ship-to City")
                {
                    ApplicationArea = Basic;
                }
                field(ShiptoContact; Rec."Ship-to Contact")
                {
                    ApplicationArea = Basic;
                }
                field(ShiptoMobilePhoneNo; Rec."Ship-to Mobile Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field(ShipmentMethodCode; Rec."Shipment Method Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShippingAgentCode; Rec."Shipping Agent Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShippingAgentServiceCode; Rec."Shipping Agent Service Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shipment Date2"; Rec."Shipment Date")
                {
                    ApplicationArea = Basic;
                }
            }
        }

        area(factboxes)
        {
            part("Attached Documents"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(25006625),
                              "No." = FIELD("No.");
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Release)
            {
                ApplicationArea = Basic;
                Caption = 'Release';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Released;
                    Rec.Modify;
                    CurrPage.Update;
                end;
            }
            action(Reopen)
            {
                ApplicationArea = Basic;
                Caption = 'Reopen';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Open;
                    Rec.Modify;
                    CurrPage.Update;
                end;
            }
            action(Post)
            {
                ApplicationArea = Basic;
                Caption = 'Post';
                Image = PostDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Codeunit.Run(Codeunit::"RentTransfer-Post (Yes/No)", Rec);
                end;
            }
        }
        area(navigation)
        {
            action(Dimensions)
            {
                ApplicationArea = Basic;
                Caption = 'Dimensions';
                Image = Dimensions;

                trigger OnAction()
                begin
                    Rec.ShowDocDim;
                    CurrPage.SaveRecord;
                end;
            }
            action(ProcessChecklists)
            {
                ApplicationArea = Basic;
                Caption = 'Process Checklists';
                Image = CheckList;
                RunObject = Page "Process Checklist List";
                RunPageLink = "Source Type" = const(25006625),
                              "Source ID" = field("No.");
            }

            action(Print)
            {
                ApplicationArea = Basic;
                Caption = 'Print';
                Image = ServiceAgreement;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    DocMgt: Codeunit DocumentManagementDMS;
                    DocReport: Record "Document Report";
                begin
                    DocMgt.PrintCurrentDoc(4, 4, 7, DocReport);
                    DocMgt.SelectRentTransferHeaderReport(DocReport, Rec, false);
                end;
            }
            action(Email)
            {
                ApplicationArea = Basic;
                Caption = 'Email';
                Image = SendEmailPDF;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    DocMgt: Codeunit DocumentManagementDMS;
                    DocReport: Record "Document Report";
                begin
                    DocMgt.PrintCurrentDoc(4, 4, 7, DocReport);
                    DocMgt.SelectRentTransferHeaderReport(DocReport, Rec, true);
                end;
            }
            action(PrintSign)
            {
                ApplicationArea = Basic;
                Caption = 'Print & Sign';
                Image = Signature;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SignManagement: Codeunit "Sign Management";
                begin
                    SignManagement.CallSignAndPrintPageRentTransfer(Rec);
                end;
            }
            action(EmailSign)
            {
                ApplicationArea = Basic;
                Caption = 'Email & Sign';
                Image = Signature;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SignManagement: Codeunit "Sign Management";
                begin
                    SignManagement.CallSignAndEmailPageRentTransfer(Rec);
                end;
            }
        }
    }
}