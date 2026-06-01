Page 25006613 "Posted Rent Trans. Order"
{
    Caption = 'Posted Rent Transfer Order';
    CardPageID = "Closed Rent Order";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Posted Rent Transfer Header";
    PromotedActionCategories = 'New,Process,Report,Documents,History,Print';

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
                field(BilltoPostCode; Rec."Bill-to Post Code")
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
            }
            part(Control25006031; "Posted Rent Trans. Order Subp.")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
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
                field(ShipmentDate; Rec."Shipment Date")
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
                SubPageLink = "Table ID" = CONST(25006627),
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
        area(navigation)
        {
            action(Dimensions)
            {
                ApplicationArea = Basic;
                Caption = 'Dimensions';
                Image = Dimensions;

                trigger OnAction()
                begin
                    Rec.ShowDimensions;
                end;
            }
            action(ProcessChecklists)
            {
                ApplicationArea = Basic;
                Caption = 'Process Checklists';
                Image = CheckList;
                RunObject = Page "Process Checklist List";
                RunPageLink = "Source Type" = const(25006613),
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
                    DocMgt.SelectPostedRentTransferHeaderReport(DocReport, Rec, false);
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
                    DocMgt.SelectPostedRentTransferHeaderReport(DocReport, Rec, true);
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
                    SignManagement.CallSignAndPrintPagePostedRentTransfer(Rec);
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
                    SignManagement.CallSignAndEmailPagePostedRentTransfer(Rec);
                end;
            }
        }
    }
}

