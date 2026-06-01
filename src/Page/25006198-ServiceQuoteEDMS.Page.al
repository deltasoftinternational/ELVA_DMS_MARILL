Page 25006198 "Service Quote EDMS"
{
    // 07.04.2022 EDMS EB.KN
    //   Added Field:
    //      Customer Vehicle ID
    //
    // 13.10.2017 EMDS P30
    //   Added action:
    //     QuoteAnalysis
    // 
    // 23.04.2015 EDMS P21
    //   Modified triggers:
    //     VIN - OnLookup
    //     Vehicle Registration No. - OnLookup
    // 
    // 16.03.2015 EDMS P21
    //   Modified triggers:
    //     OnAfterGetCurrRecord
    //     Vehicle Serial No. - OnValidate
    //   Modified Editable property for fields:
    //     "Make Code"
    //     "Model Code"
    //     "Model Version No."
    // 
    // 20.02.2015 EDMS P21
    //   Added field:
    //     "Model Version No."
    // 
    // 31.03.2014 Elva Baltic P18 MMG7.00
    //   Added fields
    //     ShortcutDimCode[3]..[8]
    //   Added Code to
    //     OnAfterGetRecord()
    // 
    // 24.03.2014 Elva Baltic P1 #RX MMG7.00
    //   *Fixed "Document Info" FactBox link
    // 
    // 24.03.2014 Elva Baltic P1 #RX MMG7.00
    //   *Action "Schedule" set VISIBLE=FALSE
    // 
    // 22.03.2014 Elva Baltic P1 #X01 MMG7.00
    //   *"Deal Type" field moved to the general tab
    //   *Changed FactBox order
    //   *The following fields set Visible=FALSE:
    //    - Description
    //    - "Responsibility Center"
    //    - "No. of Archived Versions"
    //   *Importance property set to Standard for fields:
    //    - Order Date
    //    - Order Time
    //    - Phone No.
    //    - "Sell-to Contact No."
    //    - "Sell-to Contact"
    //   *Importance property set to Additional for fields:
    //    - Posting Date
    //    - Sell-to City
    //    *"Foreign Trade" & Advanced tabs set Visible=FALSE
    // 
    // 20.03.2014 Elva Baltic P1 #X01 MMG7.00
    //   * Added LVI captions
    // 
    // 19.02.2014 Elva Baltic P7 #R130 MMG7.00
    //   * Service Quote fore Body work report added
    // 
    // 12.08.2013 EDMS P8
    //   * REMOVED MILLISECONDS
    // 
    // 2012.07.31 EDMS P8
    //   * added fields: Variable Field Run 2, Variable Field Run 3

    Caption = 'Service Quote';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Print';
    RefreshOnActivate = true;
    SourceTable = "Service Header EDMS";
    SourceTableView = where("Document Type" = filter(Quote));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
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
                field(YourReference; Rec."Your Reference")
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
                    Enabled = SelltoCustomerNoEnable;
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        SelltoCustomerNoOnAfterValidat;
                    end;
                }
                field(SelltoCustomerTemplateCode; Rec."Sell-to Customer Template Code")
                {
                    ApplicationArea = Basic;
                    Enabled = SelltoCustomerTemplateCodeEnab;
                    Importance = Additional;

                    trigger OnValidate()
                    begin
                        SelltoCustomerTemplateCodeOnAf;
                    end;
                }
                field(SelltoCustomerName; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoAddress; Rec."Sell-to Address")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(SelltoAddress2; Rec."Sell-to Address 2")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(SelltoPostCode; Rec."Sell-to Post Code")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(SelltoCity; Rec."Sell-to City")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
                    Importance = Standard;
                }
                field(MobilePhoneNo; Rec."Mobile Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field(NoofArchivedVersions; Rec."No. of Archived Versions")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    Visible = false;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;    // 16.03.2015 EDMS P21
                    end;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        // 23.04.2015 EDMS P21 >>
                        Rec.OnLookupVIN;
                        CurrPage.Update;
                        // 23.04.2015 EDMS P21 <<
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;   // 23.04.2015 EDMS P21
                    end;
                }
                field(VehicleRegistrationNo; Rec."Vehicle Registration No.")
                {
                    ApplicationArea = Basic;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        // 23.04.2015 EDMS P21 >>
                        Rec.OnLookupVehicleRegistrationNo;
                        CurrPage.Update;
                        // 23.04.2015 EDMS P21 <<
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;   // 23.04.2015 EDMS P21
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
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
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
                }
                field(ServiceAdvisor; Rec."Service Advisor")
                {
                    ApplicationArea = Basic;
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(QuoteApplicableToDate; Rec."Quote Applicable To Date")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(DocumentStatus; Rec."Document Status")
                {
                    ApplicationArea = Basic;
                }
                field("Customer Vehicle ID"; Rec."Customer Vehicle ID")
                {
                    ToolTip = 'Specifies the Customer Vehicle identification number.';
                    ApplicationArea = All;
                }
                group(WorkDescription)
                {
                    Caption = 'Work Description';
                    field(Control25006020; WorkDescription)
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                        MultiLine = true;
                        ShowCaption = false;
                        ToolTip = 'Specifies the products or service being offered';

                        trigger OnValidate()
                        begin
                            Rec.SetWorkDescription(WorkDescription);
                        end;
                    }
                }
            }
            part(ServiceLines; "Service Quote Subform EDMS")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
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
                    //Enabled = BilltoCustomerNoEnable;
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
                    Importance = Additional;
                    Editable = (BillToOptions = BillToOptions::"Custom Address") OR (rec."Bill-to Customer No." <> rec."Sell-to Customer No.");
                    Enabled = (BillToOptions = BillToOptions::"Custom Address") OR (rec."Bill-to Customer No." <> rec."Sell-to Customer No.");
                }
                field(BilltoAddress; Rec."Bill-to Address")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    Editable = (BillToOptions = BillToOptions::"Custom Address") OR (rec."Bill-to Customer No." <> rec."Sell-to Customer No.");
                    Enabled = (BillToOptions = BillToOptions::"Custom Address") OR (rec."Bill-to Customer No." <> rec."Sell-to Customer No.");
                }
                field(BilltoAddress2; Rec."Bill-to Address 2")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    Editable = (BillToOptions = BillToOptions::"Custom Address") OR (rec."Bill-to Customer No." <> rec."Sell-to Customer No.");
                    Enabled = (BillToOptions = BillToOptions::"Custom Address") OR (rec."Bill-to Customer No." <> rec."Sell-to Customer No.");
                }
                field(BilltoPostCode; Rec."Bill-to Post Code")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    Editable = (BillToOptions = BillToOptions::"Custom Address") OR (rec."Bill-to Customer No." <> rec."Sell-to Customer No.");
                    Enabled = (BillToOptions = BillToOptions::"Custom Address") OR (rec."Bill-to Customer No." <> rec."Sell-to Customer No.");
                }
                field(BilltoCity; Rec."Bill-to City")
                {
                    ApplicationArea = Basic;
                    Editable = (BillToOptions = BillToOptions::"Custom Address") OR (rec."Bill-to Customer No." <> rec."Sell-to Customer No.");
                    Enabled = (BillToOptions = BillToOptions::"Custom Address") OR (rec."Bill-to Customer No." <> rec."Sell-to Customer No.");
                }
                field(BilltoContact; Rec."Bill-to Contact")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    Editable = (BillToOptions = BillToOptions::"Custom Address") OR (rec."Bill-to Customer No." <> rec."Sell-to Customer No.");
                    Enabled = (BillToOptions = BillToOptions::"Custom Address") OR (rec."Bill-to Customer No." <> rec."Sell-to Customer No.");
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
                field(PaymentMethodCode; Rec."Payment Method Code")
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
            }
            group(ForeignTrade)
            {
                Caption = 'Foreign Trade';
                Visible = true;
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
                field("<Posting Date 2>"; Rec."Posting Date")
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
                field(RemainingQuantityHours; Rec."Remaining Quantity (Hours)")
                {
                    ApplicationArea = Basic;
                }
                field(PlanningPolicy; Rec."Planning Policy")
                {
                    ApplicationArea = Basic;
                }
                field("<No. of Archived Versions 2>"; Rec."No. of Archived Versions")
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
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the value of the User ID field.';
                    ApplicationArea = All;
                    Visible = false;
                }
            }
            group(Advanced)
            {
                Caption = 'Advanced';
                Visible = true;
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
                field(Control25006013; Rec."Service Address")
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
            }

            part(Control25006018; "Vehicle MapView FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Serial No." = field("Vehicle Serial No.");
            }
            part(Control1101904010; "Service Document FactBox EDMS")
            {
                ApplicationArea = All;
                SubPageLink = "Document Type" = field("Document Type"),
                              "No." = field("No.");
                Visible = true;
            }
            part(Control33; "Service Doc Info FactBox")
            {
                ApplicationArea = All;
                Caption = 'Document Info';
                SubPageLink = "Document Type" = field("Document Type"),
                              "No." = field("No.");
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
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = All;
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action59>")
            {
                Caption = 'Q&uote';
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
                action("<Action1102601029>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer Card';
                    Image = CustomerCode;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No." = field("Sell-to Customer No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("<Action1102601030>")
                {
                    ApplicationArea = Basic;
                    Caption = 'C&ontact Card';
                    Image = ContactPerson;
                    RunObject = Page "Contact List";
                    RunPageLink = "No." = field("Sell-to Contact No.");
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
                    RunPageLink = Type = const("Service Quote"),
                                  "No." = field("No.");
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
                action("<Action78>")
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
            }
            group(Vehicle)
            {
                Caption = 'Vehicle';
                action(ProcessChecklists)
                {
                    ApplicationArea = Basic;
                    Caption = 'Process Checklists';
                    Image = CheckList;
                    RunObject = Page "Process Checklist List";
                    RunPageLink = "Source Type" = const(25006145),
                                  "Source Subtype" = field("Document Type"),
                                  "Source ID" = field("No.");
                }
                action(Pictures)
                {
                    ApplicationArea = Basic;
                    Caption = 'Pictures';
                    Image = Picture;
                    RunObject = Page Pictures;
                    RunPageLink = "Source Type" = const(Database::Vehicle),
                                  "Source Subtype" = const("0"),
                                  "Source ID" = field("Vehicle Serial No."),
                                  "Source Ref. No." = const(0);
                    RunPageMode = View;
                }
            }
        }
        area(processing)
        {
            group(Release)
            {
                Caption = 'Release';
                action(Reopen)
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ReleaseServiceDoc: Codeunit "Release Service Document EDMS";
                    begin
                        ReleaseServiceDoc.PerformManualReopen(Rec);
                    end;
                }
                action(Action3)
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    var
                        ReleaseServiceDoc: Codeunit "Release Service Document EDMS";
                    begin
                        ReleaseServiceDoc.PerformManualRelease(Rec);
                    end;
                }
            }
            group(Print)
            {
                Caption = 'Print';
                action("<Action169>")
                {
                    ApplicationArea = Basic;
                    Caption = '&Print';
                    Ellipsis = true;
                    Image = ServiceAgreement;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        ServLine: Record "Service Line EDMS";
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                    begin
                        //DocPrint.PrintSalesHeader(Rec);
                        ServLine.Reset;
                        DocMgt.PrintCurrentDoc(3, 3, 0, DocReport);
                        DocMgt.SelectServDocReport(DocReport, Rec, ServLine, false);
                    end;
                }
                action(Email)
                {
                    ApplicationArea = Basic;
                    Caption = 'Email';
                    Image = SendEmailPDF;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ServLine: Record "Service Line EDMS";
                        DocMgt: Codeunit DocumentManagementDMS;
                        DocReport: Record "Document Report";
                    begin
                        ServLine.Reset;
                        DocMgt.PrintCurrentDoc(3, 3, 0, DocReport);
                        DocMgt.SelectServDocReport(DocReport, Rec, ServLine, true);
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
                action(CopyDocument)
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy Document';
                    Ellipsis = true;
                    Image = CopyDocument;
                    Promoted = true;
                    PromotedCategory = Process;

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
                        SendSMS.SetDocumentType(1);
                        SendSMS.SetSalespersonCode(SalespersonCode);
                        SendSMS.SetContactNo(Rec."Sell-to Contact No.");
                        SendSMS.SetPhoneNo(Rec."Mobile Phone No.");
                        SendSMS.Run;
                    end;
                }
                action(CopyDocumenttoSalesQuote)
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy Document to Sales Quote';
                    Image = Copy;

                    trigger OnAction()
                    var
                        SalesQuote: Record "Sales Header";
                        "DocumentManagementDMS": Codeunit "DocumentManagementDMS";
                    begin
                        DocumentManagementDMS.CopyServQuoteToSalesQuote(SalesQuote, Rec."No.");
                    end;
                }
                action(QuoteAnalysis)
                {
                    ApplicationArea = Basic;
                    Image = AnalysisView;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        QuoteAnalysis: Page "Sales Offer Analysis";
                    begin
                        QuoteAnalysis.SetParams(Rec."No.", 2);
                        QuoteAnalysis.Run;
                    end;
                }
            }
            group(Create)
            {
                Caption = 'Create';
                action("<Action168>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Make &Order';
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                    begin
                        //IF ApprovalMgt.PrePostApprovalCheck(Rec,PurchaseHeader) THEN
                        Codeunit.Run(Codeunit::"Serv-Quote to Order (Y/N) EDMS", Rec);
                    end;
                }
                action("<Action1688>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Add to Existing Order';
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                        AddToOrder: Codeunit "Serv-Quote to Order (Y/N) EDMS";
                    begin
                        AddToOrder.AddToExistingOrderYN(Rec);
                    end;
                }
                action("<Action1102601015>")
                {
                    ApplicationArea = Basic;
                    Caption = 'C&reate Contact';
                    Image = NewCustomer;

                    trigger OnAction()
                    begin
                        if Rec.CheckContactCreated(false) then
                            CurrPage.Update(true);
                    end;
                }
                action("<Action1102701015>")
                {
                    ApplicationArea = Basic;
                    Caption = 'C&reate Customer';
                    Image = NewCustomer;

                    trigger OnAction()
                    begin
                        if Rec.CheckCustomerCreated(false) then
                            CurrPage.Update(true);
                    end;
                }
                action("<Action1102801015>")
                {
                    ApplicationArea = Basic;
                    Caption = 'C&reate Vehicle';
                    Image = New;

                    trigger OnAction()
                    begin
                        if Rec.CheckVehicleCreated(false) then
                            CurrPage.Update(true);
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
                    Image = Allocations;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Service Schedule";
                    RunPageLink = "Document Type" = field("Document Type"),
                                  "No." = field("No.");
                    RunPageOnRec = true;
                    //Visible = false;

                    trigger OnAction()
                    var
                        ServiceSchedule: Page "Service Schedule";
                    begin
                        //ServiceSchedule.SetServiceHeader(Rec);
                        //ServiceSchedule.RUN;
                    end;
                }
            }
            group(Request)
            {
                Caption = 'Request';
                action("<Action250>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;

                    trigger OnAction()
                    begin
                        //IF ApprovalMgt.SendSalesApprovalRequest(Rec) THEN;
                    end;
                }
                action("<Action251>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;

                    trigger OnAction()
                    begin
                        //IF ApprovalMgt.CancelSalesApprovalRequest(Rec,TRUE,TRUE) THEN;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        MakeModelEditable := Rec."Vehicle Serial No." = '';        // 16.03.2015 EDMS P21
    end;

    trigger OnAfterGetRecord()
    begin
        Resources := ServiceScheduleMgt.GetRelatedResources(Rec."Document Type", Rec."No.", ServiceLine.Type::Labor, 0, 0);
        ActivateFields;
        Resources := Rec.GetResourceTextFieldValue;
        //EVALUATE("Order Time", COPYSTR(FORMAT("Order Time", 0, '<Hours24,2>:<Minutes,2>:<Seconds,2>'), 1, 8));  //12.08.2013 EDMS P8
        Rec.ShowShortcutDimCode(ShortcutDimCode); // 31.03.2014 Elva Baltic P18 MMG7.00
        Rec.CalcFields("Schedule Start Date Time", "Schedule End Date Time");
        WorkDescription := Rec.GetWorkDescription;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        LostSaleMgt.OnServHeaderDelete(Rec);
        CurrPage.SaveRecord;
        exit(Rec.ConfirmDeletion);
    end;

    trigger OnInit()
    begin
        BilltoCustomerNoEnable := true;
        SelltoCustomerNoEnable := true;
        SelltoCustomerTemplateCodeEnab := true;
        BilltoCustomerTemplateCodeEnab := true;
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
        if UserMgtedms.GetServiceFilterEDMS <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgtEDMS.GetServiceFilterEDMS);
            Rec.FilterGroup(0);
        end;

        Rec.SetRange("Date Filter", 0D, WorkDate - 1);
        ActivateFields;

        SetDocNoVisible;
    end;

    var
        Text000: label 'Unable to execute this function while in view only mode.';
        CopyServDoc: Report "Copy Service Document EDMS";
        DocPrint: Codeunit "Document-Print";
        ArchiveManagement: Codeunit ArchiveManagement;
        EDMSMGT: codeunit "Vehicle Proposal Mgt. EDMS";
        UserMgt: Codeunit "User Setup Management";
        UserMgtEDMS: Codeunit "UserProfileManagement";
        ApprovalEntries: Page "Approval Entries";
        ChangeExchangeRate: Page "Change Exchange Rate";
        LostSaleMgt: Codeunit "Lost Sales Management";
        [InDataSet]

        BilltoCustomerTemplateCodeEnab: Boolean;
        [InDataSet]
        SelltoCustomerTemplateCodeEnab: Boolean;
        [InDataSet]
        SelltoCustomerNoEnable: Boolean;
        [InDataSet]
        BilltoCustomerNoEnable: Boolean;
        ServiceScheduleMgt: Codeunit "Service Schedule Mgt.";
        [InDataSet]
        Resources: Text[250];
        ServiceLine: Record "Service Line EDMS";
        [InDataSet]
        IsVFRun1Visible: Boolean;
        [InDataSet]
        IsVFRun2Visible: Boolean;
        [InDataSet]
        IsVFRun3Visible: Boolean;
        ShortcutDimCode: array[8] of Code[20];
        DocNoVisible: Boolean;
        MakeModelEditable: Boolean;
        DateTimeMgt: Codeunit "Datetime Mgt.";
        CopyDocMgt: Codeunit "Copy Document Mgt.";
        WorkDescription: Text;

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

    local procedure SelltoCustomerTemplateCodeOnAf()
    begin
        ActivateFields;
        CurrPage.Update;
    end;

    local procedure BilltoCustomerTemplateCodeOnAf()
    begin
        ActivateFields;
        CurrPage.Update;
    end;


    procedure ActivateFields()
    begin
        BilltoCustomerTemplateCodeEnab := Rec."Bill-to Customer No." = '';
        SelltoCustomerTemplateCodeEnab := Rec."Sell-to Customer No." = '';
        SelltoCustomerNoEnable := Rec."Sell-to Customer Template Code" = '';
        BilltoCustomerNoEnable := Rec."Bill-to Customer Template Code" = '';
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order","Return Order";
        EDMSMGT: Codeunit "Vehicle Proposal Mgt. EDMS";
    begin
        DocNoVisible := EDMSMGT.ServiceDocumentNoIsVisible(Doctype::Quote, Rec."No.");
    end;
}

