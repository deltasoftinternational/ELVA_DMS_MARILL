Page 25006664 "GH Service Order EC"
{
    Caption = 'Service Order';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Release,Posting,Print,Transfer';
    RefreshOnActivate = true;
    SourceTable = "Service Header EDMS";
    //SourceTableView = where("Document Type" = filter(Order));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    Visible = DocNoVisible;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(DealType; Rec."Deal Type")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SelltoCustomerNo; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        SelltoCustomerNoOnAfterValidat;
                    end;
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
                field(SelltoContactNo; Rec."Sell-to Contact No.")
                {
                    ApplicationArea = Basic;
                    Importance = Standard;
                }
                field(SelltoContact; Rec."Sell-to Contact")
                {
                    ApplicationArea = Basic;
                    Importance = Standard;
                }
                field(PhoneNo; Rec."Phone No.")
                {
                    ApplicationArea = Basic;

                }
                field(MobilePhoneNo; Rec."Mobile Phone No.")
                {
                    ApplicationArea = Basic;

                }
                field(NoofArchivedVersions; Rec."No. of Archived Versions")
                {
                    ApplicationArea = Basic;

                    Visible = false;
                }
                field(PlannedServiceDate; Rec."Planned Service Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        SelltoCustomerNoOnAfterValidat;
                    end;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;


                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        // 23.04.2015 EDMS P21 >>
                        Rec.OnLookupVIN;
                        SelltoCustomerNoOnAfterValidat;
                        // 23.04.2015 EDMS P21 <<
                    end;

                    trigger OnValidate()
                    begin
                        SelltoCustomerNoOnAfterValidat;
                    end;
                }
                field(VehicleRegistrationNo; Rec."Vehicle Registration No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.OnLookupVehicleRegistrationNo;
                        SelltoCustomerNoOnAfterValidat;
                    end;

                    trigger OnValidate()
                    begin
                        SelltoCustomerNoOnAfterValidat;
                    end;
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                    Editable = MakeModelEditable;
                }
                field(ModelCode; Rec."Model Code")
                {
                    ApplicationArea = Basic;
                    Editable = MakeModelEditable;
                }
                field(VariableFieldRun1; Rec."Variable Field Run 1")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun1Visible;
                }
                field(VariableFieldRun2; Rec."Variable Field Run 2")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun2Visible;
                }
                field(VariableFieldRun3; Rec."Variable Field Run 3")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun3Visible;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(OrderDate; Rec."Order Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(OrderTime; Rec."Order Time")
                {
                    ApplicationArea = Basic;

                }
                field(WorkStatusCode; Rec."Work Status Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(ServiceAdvisor; Rec."Service Advisor")
                {
                    ApplicationArea = Basic;

                }
                field(LocationCode2; Rec."Location Code")
                {
                    ApplicationArea = Basic;

                }
                field(ServiceAddressCode2; Rec."Service Address Code")
                {
                    ApplicationArea = Basic;

                }
                field(ExternalDocumentNo2; Rec."External Document No.")
                {
                    ApplicationArea = Basic;

                }
                field(YourReference; Rec."Your Reference")
                {
                    ApplicationArea = Basic;

                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;

                    Visible = false;
                }
                field(ContractNo; Rec."Contract No.")
                {
                    ApplicationArea = Basic;
                }
                field(QuoteNo; Rec."Quote No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;

                }
                field(TCardContainerEntryNo; Rec."TCard Container Entry No.")
                {
                    ApplicationArea = Basic;

                }
                field(DocumentStatus; Rec."Document Status")
                {
                    ApplicationArea = Basic;
                }

                field(PaymentMethod; Rec."Payment Method Code")
                {
                    ApplicationArea = Basic;

                }
                field(RentOrderNo; Rec."Rent Order No.")
                {
                    ApplicationArea = All;

                    Editable = false;
                }
                field(RentCustomer; Rec."Rent Customer")
                {
                    ApplicationArea = All;

                    Editable = false;
                }
                group("Work Description")
                {
                    Caption = 'Work Description';
                    field(WorkDescription; WorkDescription)
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Standard;
                        MultiLine = true;
                        ShowCaption = false;
                        ToolTip = 'Specifies a description of work to be done in service.';

                        trigger OnValidate()
                        begin
                            Rec.SetWorkDescription(WorkDescription);
                        end;
                    }
                }
            }
            part(ServiceLines; "Service Order Subform EDMS")
            {
                ApplicationArea = All;

                SubPageLink = "Document No." = field("No.");
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        Clear(ChangeExchangeRate);
                        ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", Rec."Posting Date");
                        if ChangeExchangeRate.RunModal = Action::OK then begin
                            Rec.Validate("Currency Factor", ChangeExchangeRate.GetParameter);
                            CurrPage.Update;
                        end;
                        Clear(ChangeExchangeRate);
                    end;

                    trigger OnValidate()
                    begin
                        CurrencyCodeOnAfterValidate;
                    end;
                }

                field(BillToOptions; BillToOptions)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bill-to';
                    OptionCaption = 'Default (Customer),Another Customer,Custom Address';
                    ToolTip = 'Specifies the customer that the sales invoice will be sent to. Default (Customer): The same as the customer on the sales invoice. Another Customer: Any customer that you specify in the fields below.';

                    trigger OnValidate()
                    begin
                        if BillToOptions = BillToOptions::"Default (Customer)" then begin
                            Rec.Validate("Bill-to Customer No.", Rec."Sell-to Customer No.");
                        end;

                        Rec.CopySellToAddressToBillToAddress;
                    end;
                }
                field(BilltoName; Rec."Bill-to Name")
                {
                    ApplicationArea = Basic;
                    Editable = BillToOptions = BillToOptions::"Another Customer";
                    Enabled = BillToOptions = BillToOptions::"Another Customer";
                }
                field(BilltoCustomerNo; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    Editable = BillToOptions = BillToOptions::"Another Customer";
                    Enabled = BillToOptions = BillToOptions::"Another Customer";

                    trigger OnValidate()
                    begin
                        BilltoCustomerNoOnAfterValidat;
                    end;
                }
                field(BilltoContactNo; Rec."Bill-to Contact No.")
                {
                    ApplicationArea = Basic;

                    Editable = ((BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No."));
                    Enabled = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                }

                field(BilltoAddress; Rec."Bill-to Address")
                {
                    ApplicationArea = Basic;

                    Editable = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                    Enabled = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                }
                field(BilltoAddress2; Rec."Bill-to Address 2")
                {
                    ApplicationArea = Basic;

                    Editable = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                    Enabled = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                }
                field(BilltoPostCode; Rec."Bill-to Post Code")
                {
                    ApplicationArea = Basic;

                    Editable = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                    Enabled = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                }
                field(BilltoCity; Rec."Bill-to City")
                {
                    ApplicationArea = Basic;
                    Editable = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                    Enabled = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                }
                field(BilltoContact; Rec."Bill-to Contact")
                {
                    ApplicationArea = Basic;

                    Editable = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                    Enabled = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        ShortcutDimension1CodeOnAfterV;
                    end;
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        ShortcutDimension2CodeOnAfterV;
                    end;
                }
                field(ShortcutDimCode3; ShortcutDimCode[3])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,3';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(3, ShortcutDimCode[3]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field(ShortcutDimCode4; ShortcutDimCode[4])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,4';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(4, ShortcutDimCode[4]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                field(ShortcutDimCode5; ShortcutDimCode[5])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,5';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(5, ShortcutDimCode[5]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field(ShortcutDimCode6; ShortcutDimCode[6])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,6';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(6, ShortcutDimCode[6]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field(ShortcutDimCode7; ShortcutDimCode[7])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,7';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(7, ShortcutDimCode[7]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field(ShortcutDimCode8; ShortcutDimCode[8])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,8';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(8, ShortcutDimCode[8]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
                field(PaymentTermsCode; Rec."Payment Terms Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(DueDate; Rec."Due Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(PaymentDiscount; Rec."Payment Discount %")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerPriceGroup; Rec."Customer Price Group")
                {
                    ApplicationArea = Basic;
                }
                field(PricesIncludingVAT; Rec."Prices Including VAT")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        PricesIncludingVATOnAfterValid;
                    end;
                }
                field(VATBusPostingGroup; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field(ExternalDocumentNo; Rec."External Document No.")
                {
                    ApplicationArea = Basic;
                }
            }
            group(ForeignTrade)
            {
                Caption = 'Foreign Trade';
                Visible = true;
                field(EU3PartyTrade; Rec."EU 3-Party Trade")
                {
                    ApplicationArea = Basic;
                }
                field(TransactionType; Rec."Transaction Type")
                {
                    ApplicationArea = Basic;
                }
                field(TransactionSpecification; Rec."Transaction Specification")
                {
                    ApplicationArea = Basic;
                }
                field(TransportMethod; Rec."Transport Method")
                {
                    ApplicationArea = Basic;
                }
                field(ExitPoint; Rec."Exit Point")
                {
                    ApplicationArea = Basic;
                }
                field("Area"; Rec.Area)
                {
                    ApplicationArea = Basic;
                }
            }
            group(Details)
            {
                Caption = 'Details';
                field("<Posting Date2>"; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentDate; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                }
                field(RequestedStartingDate; Rec."Requested Starting Date")
                {
                    ApplicationArea = Basic;
                }
                field(RequestedStartingTime; Rec."Requested Starting Time")
                {
                    ApplicationArea = Basic;
                }
                field(RequestedFinishingDate; Rec."Requested Finishing Date")
                {
                    ApplicationArea = Basic;
                }
                field(RequestedFinishingTime; Rec."Requested Finishing Time")
                {
                    ApplicationArea = Basic;
                }
                field(ArrivalDate; Rec."Arrival Date")
                {
                    ApplicationArea = Basic;
                }
                field(ArrivalTime; Rec."Arrival Time")
                {
                    ApplicationArea = Basic;
                }
                field(FinishedQuantityHours; Rec."Finished Quantity (Hours)")
                {
                    ApplicationArea = Basic;
                }
                field(FinishedTravelQtyHours; Rec."Finished Travel Qty (Hours)")
                {
                    ApplicationArea = Basic;
                }
                field(RemainingQuantityHours; Rec."Remaining Quantity (Hours)")
                {
                    ApplicationArea = Basic;
                }
                field(PlanningPolicy; Rec."Planning Policy")
                {
                    ApplicationArea = Basic;
                }
                field("<No. of Archived Versions2>"; Rec."No. of Archived Versions")
                {
                    ApplicationArea = Basic;
                }
                field(InitiatorCode; Rec."Initiator Code")
                {
                    ApplicationArea = Basic;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(VehicleAccountingCycleNo; Rec."Vehicle Accounting Cycle No.")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleStatusCode; Rec."Vehicle Status Code")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleItemChargeNo; Rec."Vehicle Item Charge No.")
                {
                    ApplicationArea = Basic;
                }
                field(WarrantyClaimNo; Rec."Warranty Claim No.")
                {
                    ApplicationArea = Basic;
                }
                field(Resources; Resources)
                {
                    ApplicationArea = Basic;
                    Caption = 'Resources';

                    trigger OnDrillDown()
                    begin
                        CurrPage.SaveRecord;
                        Rec.RelatedResourcesList(Resources);
                        Resources := Rec.GetResourceTextFieldValue;
                    end;

                    trigger OnValidate()
                    begin
                        Rec.SetResourceTextFieldValue(Resources);
                        Resources := Rec.GetResourceTextFieldValue;
                    end;
                }
                field(ModelVersionNo; Rec."Model Version No.")
                {
                    ApplicationArea = Basic;
                    Editable = MakeModelEditable;
                }
            }
            group(Control1900201301)
            {
                Caption = 'Prepayment';
                Visible = true;
                field(Control228; Rec."Prepayment %")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        Prepayment37OnAfterValidate;
                    end;
                }
                field(CompressPrepayment; Rec."Compress Prepayment")
                {
                    ApplicationArea = Basic;
                }
                field(PrepmtPaymentTermsCode; Rec."Prepmt. Payment Terms Code")
                {
                    ApplicationArea = Basic;
                }
                field(PrepaymentDueDate; Rec."Prepayment Due Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(PrepmtPaymentDiscount; Rec."Prepmt. Payment Discount %")
                {
                    ApplicationArea = Basic;
                }
                field(PrepmtPmtDiscountDate; Rec."Prepmt. Pmt. Discount Date")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Advanced)
            {
                Caption = 'Advanced';
                Visible = true;
                field(ScheduleStartDate; DateTimeMgt.Datetime2Date(Rec."Schedule Start Date Time"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Start Date';
                    Editable = false;
                }
                field(ScheduleStartTime; DateTimeMgt.Datetime2Time(Rec."Schedule Start Date Time"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Start Time';
                    Editable = false;
                }
                field(ScheduleEndDate; DateTimeMgt.Datetime2Date(Rec."Schedule End Date Time"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule End Date';
                    Editable = false;
                }
                field(ScheduleEndTime; DateTimeMgt.Datetime2Time(Rec."Schedule End Date Time"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule End Time';
                    Editable = false;
                }
            }
            group(ServiceAddress)
            {
                Caption = 'Service Address';
                field(ShippingOptions; ShipToOptions)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ship-to';
                    OptionCaption = 'Default (Sell-to Address),Alternate Shipping Address,Custom Address';
                    ToolTip = 'Specifies the address that the products on the sales document are shipped to. Default (Sell-to Address): The same as the customer''s sell-to address. Alternate Ship-to Address: One of the customer''s alternate ship-to addresses. Custom Address: Any ship-to address that you specify in the fields below.';

                    trigger OnValidate()
                    var
                        ShipToAddress: Record "Ship-to Address";
                        ShipToAddressList: Page "Ship-to Address List";
                    begin

                        case ShipToOptions of
                            ShipToOptions::"Default (Sell-to Address)":
                                begin
                                    Rec.Validate("Service Address Code", '');
                                    Rec.CopySellToAddressToShipToAddress;
                                end;
                            ShipToOptions::"Alternate Shipping Address":
                                begin
                                    ShipToAddress.SetRange("Customer No.", Rec."Sell-to Customer No.");
                                    ShipToAddressList.LookupMode := true;
                                    ShipToAddressList.SetTableView(ShipToAddress);

                                    if ShipToAddressList.RunModal = ACTION::LookupOK then begin
                                        ShipToAddressList.GetRecord(ShipToAddress);
                                        Rec.Validate("Service Address Code", ShipToAddress.Code);
                                    end else
                                        ShipToOptions := ShipToOptions::"Custom Address";
                                end;
                            ShipToOptions::"Custom Address":
                                begin
                                    Rec.Validate("Service Address Code", '');
                                end;
                        end;
                    end;
                }
                field(ServiceAddressCode; Rec."Service Address Code")
                {
                    ApplicationArea = Basic;
                    Editable = ShipToOptions = ShipToOptions::"Alternate Shipping Address";
                }
                field(ServiceAddressName; Rec."Service Address Name")
                {
                    ApplicationArea = Basic;
                    Editable = ShipToOptions = ShipToOptions::"Custom Address";
                }
                field(Control25006010; Rec."Service Address")
                {
                    ApplicationArea = Basic;
                    Editable = ShipToOptions = ShipToOptions::"Custom Address";
                }
                field(ServiceAddress2; Rec."Service Address 2")
                {
                    ApplicationArea = Basic;
                    Editable = ShipToOptions = ShipToOptions::"Custom Address";
                }
                field(ServiceAddressPostCode; Rec."Service Address Post Code")
                {
                    ApplicationArea = Basic;
                    Editable = ShipToOptions = ShipToOptions::"Custom Address";
                }
                field(ServiceAddressCity; Rec."Service Address City")
                {
                    ApplicationArea = Basic;
                    Editable = ShipToOptions = ShipToOptions::"Custom Address";
                }
                field(ServiceAddressContact; Rec."Service Address Contact")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerEmail; GetCustomerEmail())
                {
                    ApplicationArea = All;
                }
                field(ServiceAdvisorName; GetAdvisorName())
                {
                    ApplicationArea = All;
                }
                field(CustomerPhone; GetCustomerPhone())
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(25006145),
                "No." = FIELD("No."),
                "Document Type" = FIELD("Document Type");
                //    ;
            }

            part(Control25006017; "Vehicle MapView FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Serial No." = field("Vehicle Serial No.");
            }
            part("Service Document FactBox EDMS"; "Service Document FactBox EDMS")
            {
                ApplicationArea = All;
                SubPageLink = "Document Type" = field("Document Type"),
                              "No." = field("No.");
                Visible = true;
            }
            part(Control1903720907; "Serv. Hist. Sell EDMS FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("Sell-to Customer No.");
                Visible = false;
            }
            part(Control1902018507; "Customer Serv. Statis. FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("Bill-to Customer No.");
                Visible = false;
            }
            part(Control1900316107; "Customer Details FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("Sell-to Customer No.");
                Visible = false;
            }
            part(Control1906127307; "Service Line FactBox EDMS")
            {
                ApplicationArea = All;
                Provider = ServiceLines;
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("Document No."),
                              "Line No." = field("Line No.");
                Visible = true;
            }
            part(Control1901314507; "Item Invoicing FactBox")
            {
                ApplicationArea = All;
                Provider = ServiceLines;
                SubPageLink = "No." = field("No.");
                Visible = false;
            }
            part(Control1906354007; "Approval FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Table ID" = const(36),
                              "Document Type" = field("Document Type"),
                              "Document No." = field("No."),
                              Status = const(Open);
                Visible = false;
            }
            part(Control1907012907; "Resource Details FactBox")
            {
                ApplicationArea = All;
                Provider = ServiceLines;
                SubPageLink = "No." = field("No.");
                Visible = false;
            }
            part(Control1901796907; "Item Warehouse FactBox")
            {
                ApplicationArea = All;
                Provider = ServiceLines;
                SubPageLink = "No." = field("No.");
                Visible = false;
            }
            part(Control1907234507; "Serv. Hist. Bill EDMS FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("Bill-to Customer No.");
                Visible = false;
            }
            part("Vehicle Pictures"; "Object Picture FactBox")
            {
                ApplicationArea = All;
                Caption = 'Vehicle Pictures';
                SubPageLink = "Source Type" = const(Database::Vehicle),
                              //"Source Subtype" = const("0"),
                              "Vehicle Serial No." = field("Vehicle Serial No.");
                //"Source Ref. No." = const(0);
                SubPageView = sorting("Source Type", "Source Subtype", "Source ID", "Source Ref. No.", "No.");
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
            group("Order")
            {
                Caption = 'O&rder';
                action("<Action61>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        //CalcInvDiscForHeader;
                        Commit;
                        Page.RunModal(Page::"Service Order Statistics EDMS", Rec);
                    end;
                }
                action("<Action62>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer Card';
                    Image = EditLines;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No." = field("Sell-to Customer No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("<Action1101904005>")
                {
                    ApplicationArea = Basic;
                    Caption = 'V&ehicle Card';
                    Image = EditLines;
                    RunObject = Page "Vehicle List";
                    RunPageLink = "Serial No." = field("Vehicle Serial No.");
                }
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Service Comment Sheet EDMS";
                    RunPageLink = Type = const("Service Order"),
                                  "No." = field("No.");
                }
                action(VehicleComment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Service Comment Sheet EDMS";
                    RunPageLink = Type = const(Vehicle),
                                  "No." = field("Vehicle Serial No.");
                }
                action(BillToCustomerComment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Bill-To Customer Comments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = const(Customer),
                                  "No." = field("Bill-to Customer No.");
                }
                action(SelllToCustomerComment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sell-To Customer Comments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = const(Customer),
                                  "No." = field("Sell-to Customer No.");
                }
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDocDim;
                        CurrPage.SaveRecord;
                    end;
                }
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'A&pprovals';
                    Image = Approvals;

                    trigger OnAction()
                    begin
                        ApprovalEntries.SetRecordFilters(Database::"Service Header EDMS", Rec."Document Type", Rec."No.");
                        ApprovalEntries.Run;
                    end;
                }
                /*
                action(SIEAssigtments)
                {
                    ApplicationArea = Basic;
                    Caption = 'SIE Assigtments';
                    Image = Journals;

                    trigger OnAction()
                    begin
                        Rec.ShowSIEAssgnt;
                    end;
                }
                */
                action(VehicleQuotes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle Quotes';
                    Image = Quote;
                    RunObject = Page "Service Quotes EDMS";
                    RunPageLink = "Vehicle Serial No." = field("Vehicle Serial No.");
                }
                action(WarrantyDocuments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Warranty Documents';
                    Image = Documents;
                    RunObject = Page "Warranty Document List";
                    RunPageLink = "Service Order No." = field("No.");
                }
                action(AvailabilityByLocation)
                {
                    ApplicationArea = Basic;
                    Caption = 'Availability by Location';
                    Image = ItemAvailbyLoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Show a list of items grouped by location.';

                    trigger OnAction()
                    var
                        ItemByLocation: Page "Items by Location EDMS";
                    begin
                        ItemByLocation.SetParams(Database::"Service Header EDMS", Rec."Document Type", Rec."No.");
                        ItemByLocation.RunModal;
                    end;
                }
                action(ItemOrderOverview)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Order Overview';
                    Image = ItemInvoice;

                    trigger OnAction()
                    var
                        ItemOrderOverview: Page "Item Order Overview";
                    begin
                        ItemOrderOverview.SetSourceType2(2);
                        ItemOrderOverview.SetDocumentFilter(Rec."No.");
                        ItemOrderOverview.Run;
                        ItemOrderOverview.FindRec;
                    end;
                }
            }
            group(SpecialOrder)
            {
                Caption = 'Speci&al Order';
                action(SpecPurchOrder)
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase &Order';
                    Image = Document;

                    trigger OnAction()
                    begin
                        CurrPage.ServiceLines.Page.OpenSpecialPurchOrderForm;
                    end;
                }
            }
            group(Transfers)
            {
                Caption = 'Transfers';
                action(TransferOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transfer Orders';
                    Image = Documents;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        ServInfoPaneMgt.LookupOrdTransf(Rec)
                    end;
                }
                action(TransferShipments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transfer Shipments';
                    Image = PostedReceipts;

                    trigger OnAction()
                    begin
                        ServInfoPaneMgt.LookupTransferShipment(Rec)
                    end;
                }
                action(TransferReceipts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transfer Receipts';
                    Image = PostedReceipts;

                    trigger OnAction()
                    begin
                        ServInfoPaneMgt.LookupTransferReceipt(Rec)
                    end;
                }
            }
            group(Prepayment)
            {
                Caption = 'Prepayment';
                Visible = false;
                action("<Action234>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Prepa&yment Invoices';
                    Image = PrepaymentInvoice;
                    RunObject = Page "Posted Sales Invoices";
                    RunPageLink = "Prepayment Order No." = field("No.");
                    RunPageView = sorting("Prepayment Order No.");
                }
                action("<Action235>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Prepayment Credi&t Memos';
                    Image = PrepaymentCreditMemo;
                    RunObject = Page "Posted Sales Credit Memos";
                    RunPageLink = "Prepayment Order No." = field("No.");
                    RunPageView = sorting("Prepayment Order No.");
                }
            }
            group(Schedule)
            {
                Caption = 'Schedule';
                action("<Action1101904014>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Allocation Entries';
                    Image = EntriesList;

                    trigger OnAction()
                    var
                        ServLaborAllocation: Record "Serv. Labor Allocation Entry";
                        ScheduleMgt: Codeunit "Service Schedule Mgt.";
                    begin
                        ServLaborAllocation.Reset;
                        ScheduleMgt.FindServAllocationEntries(ServLaborAllocation, Rec."Document Type", Rec."No.");
                        Page.RunModal(Page::"Serv. Labor Allocation Entries", ServLaborAllocation);
                    end;
                }
                action("<Action1101904015>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule Application Entries';
                    Image = EntriesList;

                    trigger OnAction()
                    var
                        ServLaborAllocAplication: Record "Serv. Labor Alloc. Application";
                        ScheduleMgt: Codeunit "Service Schedule Mgt.";
                    begin
                        ServLaborAllocAplication.Reset;
                        ScheduleMgt.FindServAllocAplicationEntries(ServLaborAllocAplication, Rec."Document Type", Rec."No.");
                        Page.RunModal(Page::"Serv. Labor Alloc. Application", ServLaborAllocAplication);
                    end;
                }
                action(ResourceTimeRegEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Resource Time Reg. Entries';
                    RunObject = Page "Resource Time Reg. Entries";
                    RunPageLink = "Source Type" = const("Service Document"),
                                  "Source Subtype" = const(Order),
                                  "Source ID" = field("No.");
                }
            }
            group(Vehicle)
            {
                Caption = '&Vehicle';
                action(ProcessChecklists)
                {
                    ApplicationArea = Basic;
                    Caption = 'Process Checklists';
                    Image = CheckList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Process Checklist List";
                    RunPageLink = "Source Type" = const(25006145),
                                  "Source Subtype" = field("Document Type"),
                                  "Source ID" = field("No.");
                }
                action("<Page Object Picture>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Document Pictures';
                    Image = Picture;
                    Promoted = true;
                    PromotedCategory = Process;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Page Pictures;
                    RunPageLink = "Source Type" = const(25006145),
                                  "Source Subtype" = field("Document Type"),
                                  "Source ID" = field("No.");
                    RunPageMode = View;

                    trigger OnAction()
                    begin
                        // 1st par 25006005 - Vehicle
                        //PictureMgt.ShowObjectPictures(25006005,0,"Serial No.",0)
                    end;
                }
                action("<Page Vehicle Picture>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle Pictures';
                    Image = Picture;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Page Pictures;
                    RunPageLink = "Vehicle Serial No." = field("Vehicle Serial No.");
                    RunPageMode = View;

                    trigger OnAction()
                    begin
                        // 1st par 25006005 - Vehicle
                        //PictureMgt.ShowObjectPictures(25006005,0,"Serial No.",0)
                    end;
                }
            }
        }
        area(processing)
        {
            group(Release)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action(Action9)
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    var
                        ReleaseServiceDoc: Codeunit "Release Service Document EDMS";
                    begin
                        ReleaseServiceDoc.PerformManualRelease(Rec);
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        ReleaseServiceDoc: Codeunit "Release Service Document EDMS";
                    begin
                        ReleaseServiceDoc.PerformManualReopen(Rec);
                    end;
                }
            }
            group(Functions)
            {
                Caption = 'F&unctions';
                action("<Action67>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Calculate &Invoice Discount';
                    Image = CalculateInvoiceDiscount;

                    trigger OnAction()
                    begin
                        ApproveCalcInvDisc;
                    end;
                }
                action(SplitDocument)
                {
                    ApplicationArea = Basic;
                    Caption = 'Split Document';
                    Ellipsis = true;
                    Image = Splitlines;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        ServiceSplittingLine.LockTable;                                                           // 06.05.2014 Elva Baltic P21
                        ServiceSplittingLine.Reset;                                                               // 06.05.2014 Elva Baltic P21
                        ServiceSplittingLine.OpenFormForServDoc(Rec);
                    end;
                }
                action(CopyDocument)
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy Document';
                    Ellipsis = true;
                    Image = CopyDocument;

                    trigger OnAction()
                    begin
                        CopyServDoc.SetServOrdHeader(Rec);
                        CopyServDoc.RunModal;
                        Clear(CopyServDoc);
                    end;
                }
                action(ArchiveDocument)
                {
                    ApplicationArea = Basic;
                    Caption = 'Archi&ve Document';
                    Image = Archive;

                    trigger OnAction()
                    begin

                        // ArchiveManagement.ArchiveServiceDocument(Rec);
                        EDMSMGT.ArchiveServiceDocument(Rec);
                        CurrPage.Update(false);
                    end;
                }
                action(CreateTransferOrder)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Transfer Order';
                    Image = CreateInventoryPickup;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ServLine: Record "Service Line EDMS";
                        ServTransfMgt: Codeunit "Service Transfer Mgt.";
                    begin
                        CurrPage.ServiceLines.Page.SetRecSelectionFilter(ServLine);

                        ServTransfMgt.SetTransferLineSelection(ServLine);

                        // 07.03.2014 Elva Baltic P21 >>
                        // IF ServTransfMgt.CreateTransferOrder(Rec) THEN
                        //   MESSAGE(Text101);
                        ServTransfMgt.CreateTransferOrder(Rec);
                        // 07.03.2014 Elva Baltic P21 <<

                        if ServTransfMgt.GetServiceChangeInfo then
                            Message(Text102);
                    end;
                }
                action("<Action1101904007>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Order Overview';
                    Image = ItemTrackingLines;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ItemOrderOverview: Page "Item Order Overview";
                    begin
                        ItemOrderOverview.SetSourceType2(2); //Service
                        ItemOrderOverview.SetDocumentFilter(Rec."No.");
                        ItemOrderOverview.SetFilters;
                        ItemOrderOverview.FindRec;
                        ItemOrderOverview.Run;
                    end;
                }
                action(UpdateItemUnitPriceAction)
                {
                    ApplicationArea = Basic;
                    Caption = 'Update Item Unit Price';
                    Image = UpdateUnitCost;

                    trigger OnAction()
                    begin
                        UpdateItemUnitPrice;
                    end;
                }
                action(RegisterTime)
                {
                    ApplicationArea = Basic;
                    Caption = 'Register Time';
                    Image = TimesheetWindowLauncher;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Service Time Journal";
                    RunPageLink = "Source Type" = const("Service Document"),
                                  "Source Subtype" = field("Document Type"),
                                  "Source ID" = field("No.");
                }
                action(CreateQuote)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Quote';
                    Image = Quote;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        ServiceSplittingLine.LockTable;
                        ServiceSplittingLine.Reset;
                        ServiceSplittingLine.DeleteDocQuote(Rec."Document Type", Rec."No.");
                        ServiceSplittingLine.CreateLinesForQuote(Rec);

                        ServiceSplittingLine.Reset;
                        ServiceSplittingLine.SetRange(Line, true);
                        ServiceSplittingLine.SetRange("Document Type", Rec."Document Type");
                        ServiceSplittingLine.SetRange("Document No.", Rec."No.");
                        ServiceSplittingLine.SetRange("Temp. Document No.", 0);
                        Page.Run(Page::"Create Service Quote", ServiceSplittingLine);
                    end;
                }
                action(SendSMS)
                {
                    ApplicationArea = Basic;
                    Caption = 'Send SMS';
                    Image = SendTo;

                    trigger OnAction()
                    var
                        SendSMS: Page "Send SMS Message";
                        UserSetup: Record "User Setup";
                        SalespersonCode: Code[10];
                    begin
                        if UserSetup.Get(UserId) then;
                        if UserSetup."Salespers./Purch. Code" <> '' then
                            SalespersonCode := UserSetup."Salespers./Purch. Code"
                        else
                            SalespersonCode := Rec."Service Advisor";

                        SendSMS.SetDocumentNo(Rec."No.");
                        SendSMS.SetDocumentType(2);
                        SendSMS.SetSalespersonCode(SalespersonCode);
                        SendSMS.SetContactNo(Rec."Sell-to Contact No.");
                        SendSMS.SetPhoneNo(Rec."Mobile Phone No.");
                        SendSMS.Run;
                    end;
                }
                action(RefreshCosts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Refresh Costs';
                    Image = RefreshLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ItemCostManagement: Codeunit "Item Cost Management";
                    begin
                        ItemCostManagement.RefreshCostsService(Rec);
                        CurrPage.Update;
                    end;
                }
                action(CreateWarrantyDocument)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Warranty Document';
                    Image = CreateDocument;

                    trigger OnAction()
                    var
                        WarrantyManagement: Codeunit "Warranty Management";
                    begin
                        WarrantyManagement.CreateWarrantyDocumentService(Rec);
                    end;
                }
            }
            group(Plan)
            {
                Caption = 'Plan';
                action("<Action1101904031>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Schedule';
                    Image = Planning;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Service Schedule";
                    RunPageLink = "Document Type" = field("Document Type"),
                                  "No." = field("No.");
                    RunPageOnRec = true;

                    trigger OnAction()
                    var
                        ServiceSchedule: Page "Service Schedule";
                    begin
                        //ServiceSchedule.SetServiceHeader(Rec);
                        //ServiceSchedule.RUN;
                    end;
                }
                action(OrderPromising)
                {
                    ApplicationArea = Basic;
                    Caption = 'Order &Promising';
                    Image = OrderPromising;

                    trigger OnAction()
                    var
                        OrderPromisingLine: Record "Order Promising Line" temporary;
                    begin
                        OrderPromisingLine.SetRange("Source Type", OrderPromisingLine."source type"::"Service Order EDMS");     // 26.02.2015 EDMS P21
                        OrderPromisingLine.SetRange("Source ID", Rec."No.");
                        Page.RunModal(page::"Order Promising Lines EDMS", OrderPromisingLine);
                    end;
                }
            }
            group(ServicePackages)
            {
                Caption = 'Service Packages';
                action(InsertServicePackage)
                {
                    ApplicationArea = Basic;
                    Caption = 'Insert Service Package';
                    Image = CopyFromTask;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Rec.InsertServPackage
                    end;
                }
                action(InsertPackRecall)
                {
                    ApplicationArea = Basic;
                    Caption = 'Insert Recall Compaign Package';
                    Image = CopyFromTask;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec.InsertServPackageRecall;
                    end;
                }
                action(InsertServicePlanPackage)
                {
                    ApplicationArea = Basic;
                    Caption = 'Insert Service Plan Package';
                    Image = CopyFromTask;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec.InsertServPackagePlaned;
                    end;
                }
            }
            group(Request)
            {
                Caption = 'Request';
                Image = SendApprovalRequest;
                Visible = false;
                action("<Action1250>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;

                    trigger OnAction()
                    begin
                        //IF ApprovalMgt.SendServEDMSApprovalRequest(Rec) THEN;
                    end;
                }
                action("<Action1251>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;

                    trigger OnAction()
                    begin
                        //IF ApprovalMgt.CancelServEDMSApprovalRequest(Rec,TRUE,TRUE) THEN;
                    end;
                }
            }
            group(Posting)
            {
                Caption = 'P&osting';
                action(Post)
                {
                    ApplicationArea = Basic;
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        //IF ApprovalMgt.PrePostServApprCheck(Rec) THEN BEGIN
                        //  IF ApprovalMgt.TestServPrepayment(Rec) THEN
                        //    ERROR(STRSUBSTNO(Text001,"Document Type","No."))
                        //  ELSE BEGIN
                        //    IF ApprovalMgt.TestServPayment(Rec) THEN
                        //      ERROR(STRSUBSTNO(Text002,"Document Type","No."))
                        //    ELSE
                        Codeunit.Run(Codeunit::"Service-Post (Yes/No) EDMS", Rec);
                        //  END;
                        //END;
                    end;
                }
                action(PostandPrint)
                {
                    ApplicationArea = Basic;
                    Caption = 'Post and &Print';
                    Ellipsis = true;
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ShortCutKey = 'Shift+F9';


                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                    begin
                        //IF ApprovalMgt.PrePostServApprCheck(Rec) THEN BEGIN
                        //  IF ApprovalMgt.TestServPrepayment(Rec) THEN
                        //    ERROR(STRSUBSTNO(Text001,"Document Type","No."))
                        //  ELSE BEGIN
                        //    IF ApprovalMgt.TestServPayment(Rec) THEN
                        //      ERROR(STRSUBSTNO(Text002,"Document Type","No."))
                        //    ELSE
                        Codeunit.Run(Codeunit::"Service-Post+Print EDMS", Rec);
                        //  END;
                        //END;
                    end;
                }
                action(PreviewPosting)
                {
                    ApplicationArea = Basic;
                    Caption = 'Preview Posting';
                    Ellipsis = true;
                    Image = ViewPostedOrder;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        ServicePostYesNoEDMS: Codeunit "Service-Post (Yes/No) EDMS";
                    begin
                        ServicePostYesNoEDMS.Preview(Rec);
                    end;
                }
                group(ActionGroup236)
                {
                    Caption = 'Prepa&yment';
                    Image = Prepayment;
                    Visible = false;
                    action(AdvancedPrepayment)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Advanced Prepayment';
                    }
                    action("<Action231>")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Prepayment &Test Report';
                        Ellipsis = true;
                        Image = PrepaymentSimulation;

                        trigger OnAction()
                        var
                            "Item Sales Doc. Mgt. EDMS": Codeunit "Item Sales Doc. Mgt. EDMS";
                        begin
                            "Item Sales Doc. Mgt. EDMS".PrintServiceHeaderPrepmt(Rec);
                        end;
                    }
                    action("<Action232>")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Post Prepayment &Invoice';
                        Ellipsis = true;
                        Image = PrepaymentPost;

                        trigger OnAction()
                        var
                            PurchaseHeader: Record "Purchase Header";
                            SalesPostYNPrepmt: Codeunit "Sales-Post Prepayment (Yes/No)";
                        begin
                            //IF ApprovalMgt.PrePostServApprCheck(Rec) THEN
                            ServPostYNPrepmt.PostPrepmtInvoiceYN(Rec, false);
                        end;
                    }
                    action("<Action237>")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Post and Print Prepmt. Invoic&e';
                        Ellipsis = true;
                        Image = PrepaymentPostPrint;

                        trigger OnAction()
                        var
                            PurchaseHeader: Record "Purchase Header";
                            SalesPostYNPrepmt: Codeunit "Sales-Post Prepayment (Yes/No)";
                        begin
                            //IF ApprovalMgt.PrePostServApprCheck(Rec) THEN
                            ServPostYNPrepmt.PostPrepmtInvoiceYN(Rec, true);
                        end;
                    }
                    action("<Action233>")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Post Prepayment &Credit Memo';
                        Ellipsis = true;
                        Image = PrepaymentPost;

                        trigger OnAction()
                        var
                            OldCorr: Boolean;
                        begin
                            OldCorr := Rec.Correction;
                            Rec.Correction := false;
                            //IF ApprovalMgt.PrePostServApprCheck(Rec) THEN
                            ServPostYNPrepmt.PostPrepmtCrMemoYN(Rec, false);
                            Rec.Correction := OldCorr;
                            Rec.Modify
                        end;
                    }
                    action("<Action238>")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Post and Print Prepmt. Cr. Mem&o';
                        Ellipsis = true;
                        Image = PrepaymentPostPrint;

                        trigger OnAction()
                        var
                            OldCorr: Boolean;
                        begin
                            OldCorr := Rec.Correction;
                            Rec.Correction := false;
                            //IF ApprovalMgt.PrePostServApprCheck(Rec) THEN
                            ServPostYNPrepmt.PostPrepmtCrMemoYN(Rec, true);
                            Rec.Correction := OldCorr;
                            Rec.Modify
                        end;
                    }
                    action("<Action1101901025>")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Post Prepayment C&or. Credit Memo';
                        Image = PrepaymentPost;

                        trigger OnAction()
                        var
                            OldCorr: Boolean;
                        begin
                            OldCorr := Rec.Correction;
                            Rec.Correction := true;
                            //IF ApprovalMgt.PrePostServApprCheck(Rec) THEN
                            ServPostYNPrepmt.PostPrepmtCrMemoYN(Rec, false);
                            Rec.Correction := OldCorr;
                            Rec.Modify
                        end;
                    }
                }
            }
            group(Print)
            {
                Caption = '&Print';
                action(Action1101904032)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print';
                    Image = ServiceAgreement;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ServLine: Record "Service Line EDMS";
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                    begin
                        ServLine.Reset;
                        DocMgt.PrintCurrentDoc(3, 3, 1, DocReport);
                        DocMgt.SelectServDocReport(DocReport, Rec, ServLine, false);
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
                        ServLine: Record "Service Line EDMS";
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                    begin
                        ServLine.Reset;
                        DocMgt.PrintCurrentDoc(3, 3, 1, DocReport);
                        DocMgt.SelectServDocReport(DocReport, Rec, ServLine, true);
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
                        SignManagement.CallSignAndPrintPageService(Rec);
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
                        SignManagement.CallSignAndEmailPageService(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        MakeModelEditable := Rec."Vehicle Serial No." = '';        // 20.02.2015 EDMS P21
    end;

    trigger OnAfterGetRecord()
    begin
        Resources := Rec.GetResourceTextFieldValue;
        Rec.CalcFields("Schedule Start Date Time", "Schedule End Date Time");
        //EVALUATE("Order Time", COPYSTR(FORMAT("Order Time", 0, '<Hours24,2>:<Minutes,2>:<Seconds,2>'), 1, 8));  //12.08.2013 EDMS P8
        //MESSAGE('IsVFRun1Visible='+FORMAT(IsVFRun1Visible));

        Rec.ShowShortcutDimCode(ShortcutDimCode); // 31.03.2014 Elva Baltic P18 MMG7.00
        WorkDescription := Rec.GetWorkDescription;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        LostSaleMgt.OnServHeaderDelete(Rec);

        // 28.03.2014 Elva Baltic P21 >>
        ServiceLine.Reset;
        ServiceLine.SetRange("Document Type", Rec."Document Type");
        ServiceLine.SetRange("Document No.", Rec."No.");
        if ServiceLine.FindFirst then
            repeat
                ServiceLine.DeleteAssignedTransfLine;
            until ServiceLine.Next = 0;
        // 28.03.2014 Elva Baltic P21 <<

        CurrPage.SaveRecord;
        exit(Rec.ConfirmDeletion);
    end;

    trigger OnInit()
    begin
        IsVFRun1Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 1"));
        IsVFRun2Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 2"));
        IsVFRun3Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 3"));
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.CheckCreditMaxBeforeInsert;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetSalesFilter;
        Clear(Resources);
        Rec.SetResourceTextFieldValue(Resources);
    end;

    trigger OnOpenPage()
    begin
        if UserMgtEDMS.GetServiceFilterEDMS <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgtEDMS.GetServiceFilterEDMS);
            Rec.FilterGroup(0);
        end;

        Rec.SetRange("Date Filter", 0D, WorkDate - 1);

        SetDocNoVisible;
    end;

    var
        Text000: label 'Unable to execute this function while in view only mode.';
        ServPostYNPrepmt: Codeunit "Serv.-Post Prepayment Yes/No";
        CopyServDoc: Report "Copy Service Document EDMS";
        ReportPrint: Codeunit "Test Report-Print";
        ArchiveManagement: Codeunit ArchiveManagement;
        EDMSMGT: codeunit "Vehicle Proposal Mgt. EDMS";
        UserMgt: Codeunit "User Setup Management";
        UserMgtEDMS: Codeunit UserProfileManagement;
        ApprovalEntries: Page "Approval Entries";
        ChangeExchangeRate: Page "Change Exchange Rate";
        Text001: label 'There are non posted Prepayment Amounts on %1 %2.';
        Text002: label 'There are unpaid Prepayment Invoices related to %1 %2.';
        Text101: label 'Transfer Order is successfully created.';
        Text102: label 'System changed values in Service Line field Planned Service Date.';
        ServInfoPaneMgt: Codeunit "Service Info-Pane Mgt. EDMS";
        LostSaleMgt: Codeunit "Lost Sales Management";
        ServiceSplittingLine: Record "Service Splitting Line";
        [InDataSet]
        Resources: Text[250];
        ServiceLine: Record "Service Line EDMS";
        [InDataSet]
        IsVFRun1Visible: Boolean;
        [InDataSet]
        IsVFRun2Visible: Boolean;
        [InDataSet]
        IsVFRun3Visible: Boolean;
        DateTimeMgt: Codeunit "Datetime Mgt.";
        Err001: label 'Order already has the invoice.';
        Text103: label 'Item Unit Price is successfully updated!';
        Text104: label 'Please update Item Unit Price!';
        ShortcutDimCode: array[8] of Code[20];
        Text105: label 'Posting Date is not Today! Do you want to continue?';
        DocNoVisible: Boolean;
        [InDataSet]
        MakeModelEditable: Boolean;
        SingleInstanceMgt: Codeunit SingleInstanceManagement;
        WorkDescription: Text;
        CallNotificationCheck: Boolean;
        ormatAddress: Codeunit "Format Address";

    protected var
        ShipToOptions: Option "Default (Sell-to Address)","Alternate Shipping Address","Custom Address";
        BillToOptions: Option "Default (Customer)","Another Customer","Custom Address";




















    procedure UpdateAllowed(): Boolean
    begin
        if CurrPage.Editable = false then
            Error(Text000);
        exit(true);
    end;

    local procedure ApproveCalcInvDisc()
    begin
        CurrPage.ServiceLines.Page.ApproveCalcInvDisc;
    end;

    local procedure SelltoCustomerNoOnAfterValidat()
    begin
        CurrPage.Update;
        CurrPage."Service Document FactBox EDMS".Page.UpdateForm(true);
    end;

    local procedure SalespersonCodeOnAfterValidate()
    begin
        CurrPage.ServiceLines.Page.UpdateForm(true);
    end;

    local procedure BilltoCustomerNoOnAfterValidat()
    begin
        CurrPage.Update;
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.ServiceLines.Page.UpdateForm(true);
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        CurrPage.ServiceLines.Page.UpdateForm(true);
    end;

    local procedure PricesIncludingVATOnAfterValid()
    begin
        CurrPage.Update;
    end;

    local procedure CurrencyCodeOnAfterValidate()
    begin
        CurrPage.ServiceLines.Page.UpdateForm(true);
    end;

    local procedure Prepayment37OnAfterValidate()
    begin
        CurrPage.Update;
    end;


    procedure UpdateItemUnitPrice()
    var
        ServiceLineEDMS: Record "Service Line EDMS";
    begin
        ServiceLineEDMS.Reset;
        ServiceLineEDMS.SetRange("Document Type", Rec."Document Type");
        ServiceLineEDMS.SetRange("Document No.", Rec."No.");
        ServiceLineEDMS.SetRange(Type, ServiceLineEDMS.Type::Item);
        if ServiceLineEDMS.Find('-') then
            repeat
                ServiceLineEDMS.Validate(Quantity);
                ServiceLineEDMS.Modify;
            until ServiceLineEDMS.Next = 0;
        Rec.Modify;
        Message(Text103);
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order","Return Order";
        EDMSMGT: Codeunit "Vehicle Proposal Mgt. EDMS";
    begin
        DocNoVisible := EDMSMGT.ServiceDocumentNoIsVisible(Doctype::Order, Rec."No.");
    end;


    procedure CheckNotificationsOnce()
    begin
        CallNotificationCheck := true;
    end;

    local procedure GetCustomerEmail(): Text
    var
        Customer: Record Customer;
        Contact: Record Contact;
    begin
        if Contact.Get(Rec."Sell-to Contact No.") then begin
            Exit(Contact."E-Mail");
        end else begin
            if (Customer.Get(Rec."Sell-to Customer No.")) then begin
                Exit(Customer."E-Mail");
            end;
        end;
    end;

    local procedure GetCustomerPhone(): Text
    var
        Customer: Record Customer;
        Contact: Record Contact;
    begin
        if Contact.Get(Rec."Sell-to Contact No.") then begin
            Exit(Contact."Phone No.");
        end else begin
            if (Customer.Get(Rec."Sell-to Customer No.")) then begin
                Exit(Customer."Phone No.");
            end;
        end;
    end;

    local procedure GetAdvisorName(): Text
    var
        UserSetup: Record "User Setup";
        User: Record User;
        SalespersonCode: Code[20];
        SalesPerson: Record "Salesperson/Purchaser";
        Customer: Record Customer;
    begin
        User.Reset;
        User.SetRange("User Name", UserId);
        if User.FindFirst then
            exit(User."Full Name");
        /*
        if UserSetup."Salespers./Purch. Code" <> '' then
            SalespersonCode := UserSetup."Salespers./Purch. Code"
        else
            SalespersonCode := Rec."Service Advisor";

        if SalesPerson.Get(SalespersonCode) then
            Exit(SalesPerson.Name);
            */
    end;
}

