//>>DELTA 03 RC (28/12/2021) desactivation du code pour la recherche du remplacement
//>>DELTA 02 RC (30/11/2021) ADD EVENT OnAfterInitHeaderDefaults
Table 25006146 "Service Line EDMS"
{
    // 10.10.2018 EB.P7 DE012WAE3-15
    //   Modified trigger No. - OnValidate();
    // 
    // 06.12.2017 EB.P7 #T007
    //   Removed field "Product Subgroup Code"
    // 
    // 06.10.2017 EB.AKR Warranty
    //   Added Field:
    //     51212Labor Type
    // 
    // 05.07.2016 EB.P7 #PAR28
    //   "No." OnLookup() trigger code moved to page
    //   "No." OnValidate trigger modified
    // 
    // 30.05.2016 EB.P7 #PAR28
    //   Added field:
    //     25006998Has Replacement
    // 
    // 12.05.2016 EB.P30 GH
    //   Modified procedure:
    //     UpdateAmounts
    // 
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified ItemAvailability(), Usert Profile Setup to Branch Profile Setup
    // 
    // 12.05.2015 EB.P30 #T030
    //   Added fields:
    //     "Res. Cost Amount Finished"
    //     "Res. Cost Amount Remaining"
    //     "Res. Cost Amount Total"
    // 
    // 16.03.2015 EDMS P21
    //   Modified triggers:
    //     No. - OnValidate
    // 
    // 10.03.2015 EDMS P21
    //   Modified procedures:
    //     CreateDim
    //     CallCreateDim
    //   Modified trigger:
    //     Location Code - OnValidate
    // 
    // 25.02.2015 EDMS P21
    //   Modified TableRelation property for field:
    //     5407 "Unit of Measure Code"
    //   Modified trigger:
    //     Standard Time - OnValidate
    // 
    // 26.01.2015 EB.P7 E0060 MMG7.00
    //   Modified "VAT Prod Posting Group" field tirgger
    // 
    // 12.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified trigger:
    //     OnDelete()     (For Return Order need to Delete Allocation too)
    // 
    // 15.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified trigger:
    //     No. - OnValidate()
    // 
    // 14.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified procedure:
    //     TestStatusOpen
    //   Modified triggers:
    //     OnDelete()
    //     Location Code - OnValidate()
    //     Gen. Prod. Posting Group - OnValidate()
    //     Variant Code - OnValidate()
    //     Unit of Measure Code - OnValidate()
    //     Model Code - OnValidate()
    //     Make Code - OnValidate()
    //     VIN - OnValidate()
    // 
    // 04.04.2014 Elva Baltic P15 # MMG7.00
    //  * Added Description filling with the "Service Labor Translation".Description
    // 
    // 03.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added code to:
    //     Quantity - OnValidate()
    // 
    // 01.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added code to:
    //     No. - OnValidate()
    // 
    // 31.03.2014 Elva Baltic P18 MMG7.00
    //   Added Functions
    //     LookupShortcutDimCode()
    //     ShowShortcutDimCode()
    //   Corrected Function "ValidateShortcutDimCode()"
    // 
    // 31.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added field:
    //     5811 Appl.-from Item Entry
    //   Added function:
    //     CheckApplFromItemLedgEntry
    //   Modified function:
    //     SelectItemEntry
    // 
    // 28.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added function:
    //     DeleteAssignedTransfLine
    // 
    // 19.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added function:
    //     ItemIsMaterial
    //   Added Code to function:
    //      GetReservationColor
    // 
    // 11.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added functions:
    //     GetReservationColor
    //     FilterTransferRes
    // 
    // 25.10.2013 EDMS P8
    //   * Added use of new Vehicle dimetnsion

    Caption = 'Service Line EDMS';
    DrillDownPageID = "Service Line EDMS List";
    LookupPageID = "Service Line EDMS List";

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Return Order,Booking';
            OptionMembers = Quote,"Order","Return Order",Booking;
        }
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Service Header EDMS"."No." where("Document Type" = field("Document Type"));
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Comment,G/L Account,Item,Labor,External Service,Resource';
            OptionMembers = Comment,"G/L Account",Item,Labor,"External Service",Resource;

            trigger OnValidate()
            var
                ServiceHeader: Record "Service Header EDMS";
                recMarkup: Record "Sales/Serv. Item Markup";
                recItemDisc: Record "Sales Line Discount";
                recLabTransl: Record "Service Labor Translation";
                recItemTransl: Record "Item Translation";
            begin
                TestStatusOpen;

                GetServiceHeader;

                TestField("Prepmt. Amt. Inv.", 0);  //08-05-2007 EDMS P3 PREPMT

                if Type <> xRec.Type then begin
                    if Quantity <> 0 then begin
                        CalcFields("Reserved Qty. (Base)");
                        TestField("Reserved Qty. (Base)", 0);
                        ReserveServiceLine.VerifyChange(Rec, xRec);
                    end;
                end;

                TempServLine := Rec;
                Init;
                Type := TempServLine.Type;
                "System-Created Entry" := TempServLine."System-Created Entry";
                "Make Code" := TempServLine."Make Code";
                Group := TempServLine.Group;
                "Group ID" := TempServLine."Group ID";
                VIN := TempServLine.VIN;
            end;
        }
        field(6; "No."; Code[20])
        {
            Caption = 'No.';
            ValidateTableRelation = false;
            TableRelation = if (Type = const(Comment)) "Standard Text"
            else
            if (Type = const("G/L Account")) "G/L Account"
            else
            if (Type = const(Item)) Item
            else
            if (Type = const(Labor)) "Service Labor"
            else
            if (Type = const("External Service")) "External Service"
            else
            if (Type = const("Resource")) Resource;



            trigger OnValidate()
            var
                Markup: Record "Sales/Serv. Item Markup";
                ItemDisc: Record "Sales Line Discount";
                LabTransl: Record "Service Labor Translation";
                ItemTransl: Record "Item Translation";
                VariableFieldUsage: Record "Variable Field Usage";
                NewItemNo: Code[20];
                PrepaymentMgt: Codeunit "Prepayment Mgt.";
                ItemSubstSync: Codeunit "Item Substitution Sync";
                DealType: Record "Deal Type";
                VehicleNotMandatory: Boolean;
            begin
                TestStatusOpen;
                GetServiceHeader;
                if type = type::item then
                    "No." := FindOrCreateRecordByNo("No.");
                if (xRec."No." <> "No.") and (Quantity <> 0) then begin
                    CalcFields("Reserved Qty. (Base)");
                    TestField("Reserved Qty. (Base)", 0);
                end;

                NewItemNo := "No.";
                "No." := xRec."No.";
                TestField("Prepmt. Amt. Inv.", 0); //08-05-2007 EDMS P3 PREPMT

                "No." := NewItemNo;

                TempServLine := Rec;
                Init;
                Type := TempServLine.Type;
                "No." := TempServLine."No.";
                OnAfterAssignNoFromTempServLine(Rec, TempServLine);
                "Make Code" := TempServLine."Make Code";
                Group := TempServLine.Group;
                "Group ID" := TempServLine."Group ID";
                VIN := TempServLine.VIN;
                "Package No." := TempServLine."Package No.";
                "Package Version No." := TempServLine."Package Version No.";
                "Package Version Spec. Line No." := TempServLine."Package Version Spec. Line No.";
                "Contract No." := TempServLine."Contract No.";
                "System-Created Entry" := TempServLine."System-Created Entry";
                "Standard Time" := TempServLine."Standard Time";                                      // 01.04.2014 Elva Baltic P21
                "Standard Time Line No." := TempServLine."Standard Time Line No.";                    // 01.04.2014 Elva Baltic P21
                "Deal Type Code" := TempServLine."Deal Type Code";

                if "No." = '' then exit;

                "Line Discount %" := TempServLine."Line Discount %";

                "Gen. Bus. Posting Group" := ServiceHeader."Gen. Bus. Posting Group";
                "VAT Bus. Posting Group" := ServiceHeader."VAT Bus. Posting Group";
                "Location Code" := ServiceHeader."Location Code";
                "Planned Service Date" := ServiceHeader."Planned Service Date";

                "Tax Area Code" := ServiceHeader."Tax Area Code";
                "Tax Liable" := ServiceHeader."Tax Liable";
                //08-05-2007 EDMS P3 PREPMT >>
                if not "System-Created Entry" and ("Document Type" = "document type"::Order) and (Type <> Type::Comment) then
                    "Prepayment %" := ServiceHeader."Prepayment %";
                "Prepayment Tax Area Code" := ServiceHeader."Tax Area Code";
                "Prepayment Tax Liable" := ServiceHeader."Tax Liable";
                //08-05-2007 EDMS P3 PREPMT <<

                "Responsibility Center" := ServiceHeader."Responsibility Center";

                if ServiceHeader."Document Type" = ServiceHeader."document type"::Quote then begin
                    if (ServiceHeader."Sell-to Customer No." = '') and
                       (ServiceHeader."Sell-to Customer Template Code" = '')
                    then
                        Error(
                          Text031,
                          ServiceHeader.FieldCaption("Sell-to Customer No."),
                          ServiceHeader.FieldCaption("Sell-to Customer Template Code"));
                    if (ServiceHeader."Bill-to Customer No." = '') and
                       (ServiceHeader."Bill-to Customer Template Code" = '')
                    then
                        Error(
                          Text031,
                          ServiceHeader.FieldCaption("Bill-to Customer No."),
                          ServiceHeader.FieldCaption("Bill-to Customer Template Code"));
                end else
                    ServiceHeader.TestField("Sell-to Customer No.");


                "Sell-to Customer No." := ServiceHeader."Sell-to Customer No.";
                "Bill-to Customer No." := ServiceHeader."Bill-to Customer No.";

                "Customer Price Group" := ServiceHeader."Customer Price Group";
                "Customer Disc. Group" := ServiceHeader."Customer Disc. Group";
                "Allow Line Disc." := ServiceHeader."Allow Line Disc.";
                "Currency Code" := ServiceHeader."Currency Code";
                "Vehicle Serial No." := ServiceHeader."Vehicle Serial No.";
                "Make Code" := ServiceHeader."Make Code";                                         // 16.03.2015 EDMS P21
                "Vehicle Accounting Cycle No." := ServiceHeader."Vehicle Accounting Cycle No.";   // 16.03.2015 EDMS P21

                "Contract No." := ServiceHeader."Contract No.";                                   // 15.04.2014 Elva Baltic P21
                //>>DELTA 02
                OnAfterInitHeaderDefaults(Rec, ServiceHeader);
                //<<DELTA 02

                case Type of
                    Type::Comment:
                        begin
                            StdTxt.Get("No.");
                            Description := StdTxt.Description;
                        end;

                    Type::"G/L Account":
                        begin
                            GLAcc.Get("No.");
                            GLAcc.CheckGLAcc;
                            GLAcc.TestField("Direct Posting", true);
                            Description := GLAcc.Name;

                            "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
                            "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
                        end;

                    Type::Item:
                        begin
                            GetItem;

                            Item.TestField(Blocked, false);
                            if Item.Type = Item.Type::Inventory then
                                Item.TestField("Inventory Posting Group");

                            Item.TestField("Gen. Prod. Posting Group");
                            if ItemTransl.Get("No.", "Variant Code", ServiceHeader."Language Code") then begin
                                Description := ItemTransl.Description;
                                "Description 2" := ItemTransl."Description 2";
                            end
                            else begin
                                Description := Item.Description;
                                "Description 2" := Item."Description 2";
                            end;

                            GetUnitCost;
                            "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                            "VAT Prod. Posting Group" := Item."VAT Prod. Posting Group";

                            "Item Category Code" := Item."Item Category Code";
                            //"Product Group Code" := Item."Product Group Code"; // 30.05.2019 BC UPGRADE groupcode first level of categeory children
                            //"Product Subgroup Code" := Item."Product Subgroup Code";
                            Nonstock := Item."Created From Nonstock Item";
                            "Unit of Measure Code" := Item."Sales Unit of Measure";
                            "Profit %" := Item."Profit %";

                            //PrepaymentMgt.SetServPrepaymentPct(Rec,ServiceHeader."Posting Date");

                            ServiceSetup.Get;
                            "Ordering Price Type Code" := ServiceSetup."Def. Ordering Price Type Code";

                            if ServiceHeader."Language Code" <> '' then
                                GetItemTranslation;

                            //06.02.2009 Elva DMS P1 >>
                            if ServiceSetup."Item No. Replacement Warnings" then
                                if Item."Item Type" = Item."item type"::Item then begin
                                    //ItemSubstitutionMgt.CheckReplacements("No.");
                                    ItemSubstitutionSync.CheckReplacements("No.");
                                end;
                            //06.02.2009 Elva DMS P1 <<

                            ServiceHeader.TestField("Order Date");
                            if ServiceSetup."Cust. Price Group Mandatory" then
                                ServiceHeader.TestField("Customer Price Group");
                            //22.03.2014 Elva Baltic P1 #RX MMG7.00 - commented>>
                            //IF ServiceSetup."Payment Method Mandatory" THEN
                            //  ServiceHeader.TESTFIELD("Payment Method Code");
                            //22.03.2014 Elva Baltic P1 #RX MMG7.00 <<
                            VehicleNotMandatory := false;
                            if "Deal Type Code" <> '' then
                                if DealType.Get("Deal Type Code") then
                                    VehicleNotMandatory := DealType."Vehicle Not Mandatory";
                            if (not VehicleNotMandatory) and ServiceSetup."Make and Model Mandatory" then
                                ServiceHeader.TestField(ServiceHeader."Make Code");

                            if Item.Reserve = Item.Reserve::Optional then
                                Reserve := ServiceHeader.Reserve
                            else
                                Reserve := Item.Reserve;

                        end;

                    Type::Labor:
                        begin
                            Labor.Get("No.");
                            Labor.TestField(Blocked, false);
                            Labor.TestField("Gen. Prod. Posting Group");
                            Labor.TestField("VAT Prod. Posting Group");

                            Description := Labor.Description;
                            "Description 2" := Labor."Description 2";

                            // 04.04.2014 Elva Baltic P15 # MMG7.00 >>
                            ////18.02.2010 EDMSB P2>>
                            ////Get description from Service Labor Text
                            //GetDescriptionFromLaborText("No.", ServiceHeader."Vehicle Serial No.");
                            ////18.02.2010 EDMSB P2 <<

                            //>>DELTA Validate Unit Cost (LCY)
                            Validate("Unit Cost (LCY)", Labor."Unit Cost");
                            //<<DELTA Validate Unit Cost (LCY)

                            if LabTransl.Get("No.", ServiceHeader."Language Code") then begin
                                Description := LabTransl.Description;
                                "Description 2" := LabTransl."Description 2";
                            end else begin
                                ServiceSetup.Get;
                                ServiceSetup.TestField("Def. Translation Language Code");
                                if LabTransl.Get("No.", ServiceSetup."Def. Translation Language Code") then begin
                                    Description := LabTransl.Description;
                                    "Description 2" := LabTransl."Description 2";
                                end;
                            end;
                            // 04.04.2014 Elva Baltic P15 # MMG7.00 <<

                            "Unit of Measure Code" := Labor."Unit of Measure Code";
                            "Gen. Prod. Posting Group" := Labor."Gen. Prod. Posting Group";
                            "VAT Prod. Posting Group" := Labor."VAT Prod. Posting Group";
                            "Labor Type" := Labor."Labor Type";

                            //Finding standard time
                            if not (Recreate) and ("Package No." = '') and ("Standard Time" = 0) then
                                GetStandardTime;

                            //29.08.2007. EDMS P2 >>
                            ServiceSetup.Get;
                            if not ServiceSetup."Quantity Equals Standard Time" then
                                Validate(Quantity, 1);
                            //29.08.2007. EDMS P2 <<
                        end;

                    Type::"External Service":
                        begin
                            ExtServ.Get("No.");
                            ExtServ.TestField(Blocked, false);
                            ExtServ.TestField("Gen. Prod. Posting Group");
                            ExtServ.TestField("VAT Prod. Posting Group");
                            Description := ExtServ.Description;
                            "Description 2" := ExtServ."Description 2";
                            "Unit of Measure Code" := ExtServ."Unit of Measure Code";
                            "Gen. Prod. Posting Group" := ExtServ."Gen. Prod. Posting Group";
                            "VAT Prod. Posting Group" := ExtServ."VAT Prod. Posting Group";

                            //03.07.2008. EDMS P2 >>
                            "Unit of Measure Code" := ExtServ."Unit of Measure Code";
                            //03.07.2008. EDMS P2 >>

                        end;

                    Type::Resource:
                        CopyFromResource();
                end;

                Validate("Prepayment %");  //08-05-2007 EDMS P3 PREPMT

                if Type <> Type::Comment then begin
                    Validate("VAT Prod. Posting Group");
                    Validate("Unit of Measure Code");
                    UpdateUnitPrice(FieldNo("No."));
                end;

                if "No." <> xRec."No." then begin
                    if Type = Type::Item then
                        if (Quantity <> 0) and ItemExists(xRec."No.") then begin
                            ReserveServiceLine.VerifyChange(Rec, xRec);
                        end;
                end;

                CallCreateDim;

                GetVehicleVariableFields(ServiceHeader."Vehicle Serial No.");

                Validate("Unit of Measure Code");
                Validate("Transfer From Location Code", GetDefaultSparePartLocation("Location Code"));
            end;
        }
        field(7; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));

            trigger OnValidate()
            var
                codNewLocationCode: Code[20];
            begin
                TestStatusOpen;                                                                  // 14.04.2014 Elva Baltic P21
                if "Location Code" <> xRec."Location Code" then begin //10.05.2008. EDMS P2
                    codNewLocationCode := "Location Code";
                    "Location Code" := xRec."Location Code";
                    "Location Code" := codNewLocationCode;
                    if Quantity <> 0 then begin
                        ReserveServiceLine.VerifyChange(Rec, xRec);
                    end;
                end;

                if Type = Type::Item then
                    GetUnitCost;

                CallCreateDim;     // 10.03.2015 EDMS P21
            end;
        }
        field(10; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';

            trigger OnValidate()
            var
                CheckDateConflict: Codeunit "Reservation-Check Date Confl.";
                ApplicationEventManagement: Codeunit "Application Event Management";
                CustomCalendarChange: Array[1] of Record "Customized Calendar Change";
            begin
                TestStatusOpen;
                //IF CurrFieldNo <> 0 THEN
                //AddOnIntegrMgt.CheckReceiptOrderStatus(Rec);

                if "Shipment Date" <> 0D then begin
                    if Reserve <> Reserve::Always then
                        if CurrFieldNo in [
                                           FieldNo("Planned Shipment Date"),
                                           FieldNo("Planned Delivery Date"),
                                           FieldNo("Shipment Date"),
                                           FieldNo("Shipping Time"),
                                           FieldNo("Requested Delivery Date")]
                        then
                            CheckItemAvailable(FieldNo("Shipment Date"));

                    if ("Shipment Date" < WorkDate) and (Type <> Type::Comment) then
                        if not (HideValidationDialog or HasBeenShown) and GuiAllowed then begin
                            Message(
                              Text014,
                              FieldCaption("Shipment Date"), "Shipment Date", WorkDate);
                            HasBeenShown := true;
                        end;
                end;

                if (xRec."Shipment Date" <> "Shipment Date") and
                   (Quantity <> 0) and
                   (Reserve <> Reserve::Never) and
                   not StatusCheckSuspended
                then
                    ApplicationEventManagement.ServicLineEDMSCheck(Rec, CurrFieldNo <> 0);

                if "Shipment Date" <> 0D then begin
                    if not PlannedShipmentDateCalculated then
                        "Planned Shipment Date" := CalcPlannedShptDate(FieldNo("Shipment Date"));

                    if not PlannedDeliveryDateCalculated then
                        "Planned Delivery Date" := CalcPlannedDeliveryDate(FieldNo("Shipment Date"));
                end;
            end;
        }
        field(11; Description; Text[100])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                if "No." = '' then
                    Type := Type::Comment;
            end;
        }
        field(12; "Description 2"; Text[100])
        {
            Caption = 'Description 2';
        }
        field(13; "Unit of Measure"; Text[50])
        {
            Caption = 'Unit of Measure';

            trigger OnValidate()
            begin
                if Type = Type::Item then
                    if (xRec."Unit of Measure Code" <> "Unit of Measure Code") and (Quantity <> 0) then;
            end;
        }
        field(15; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                TransferLine: Record "Transfer Line";
                ItemSubstSync: Codeunit "Item Substitution Sync";
                IsHandled: Boolean;
            begin
                //>>DELTA 03
                //ItemSubstSync.ReplaceServiceLineItemNo(Rec);
                //<<DELTA 03
                if CheckItemAvailabilityOnValidateServiceLineQty(false, false) then
                    exit;

                //>>DELTA 03
                //10.10.2018 EB.P7 DE012WAE3-15 >>
                //if ServiceSetup."Item No. Replacement Warnings" and (Type = Type::Item) then
                //    ItemSubstitutionMgt.CheckDiscontinued("No.", Quantity);
                //10.10.2018 EB.P7 DE012WAE3-15 <<
                //<<DELTA 03

                TestStatusOpen;

                IsHandled := false;
                OnBeforeCheckResrevedQuantityOnValidateServiceLineQuantity(Rec, xRec, IsHandled);
                if not IsHandled then begin
                    // 03.04.2014 Elva Baltic P21 >>
                    if (Type = Type::Item) and (Quantity < xRec.Quantity) and ItemExists("No.") then begin
                        if (Quantity < CalcTransferedQuantity) then
                            Error(Text125);
                        CalcFields("Reserved Qty. (Base)");
                        if (Quantity < "Reserved Qty. (Base)") then begin
                            ServiceTransferMgt.FindTransferLine(Rec, TransferLine);
                            Error(Text126, TransferLine."Document No.");
                        end;
                    end;
                    // 03.04.2014 Elva Baltic P21 <<
                end;

                "Quantity (Base)" := CalcBaseQty(Quantity);

                CheckSPackage(FieldNo(Quantity), 0); //02.01.2008 EDMS P3

                if Type <> Type::Comment then
                    TestField("No.");

                if Reserve <> Reserve::Always then
                    CheckItemAvailable(FieldNo(Quantity));

                UpdateUnitPrice(FieldNo(Quantity));
                UpdateAmounts;

                if (xRec.Quantity <> Quantity) or (xRec."Quantity (Base)" <> "Quantity (Base)") then
                    InitOutstanding;

                if Type = Type::Item then begin
                    UpdateUnitPrice(FieldNo(Quantity));
                    if (xRec.Quantity <> Quantity) or (xRec."Quantity (Base)" <> "Quantity (Base)") then
                        ReserveServiceLine.VerifyQuantity(Rec, xRec);
                end;

                UpdateQtyHours(FieldNo(Quantity));
            end;
        }
        field(16; "Outstanding Quantity"; Decimal)
        {
            Caption = 'Outstanding Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(22; "Unit Price"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            CaptionClass = GetCaptionClass(FIELDNO("Unit Price"));
            Caption = 'Unit Price';

            trigger OnValidate()
            begin
                TestStatusOpen;

                CheckSPackage(FieldNo("Unit Price"), 0); //02.01.2008 EDMS P3

                Validate("Line Discount %");
            end;
        }
        field(23; "Unit Cost (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost (LCY)';
            trigger OnValidate()
            var
                CurrExchRate: Record "Currency Exchange Rate";
            begin
                //>>Delta MGR Update "Unit Cost"
                GetServiceHeader;
                if ServiceHeader."Currency Code" <> '' then begin
                    Currency.TestField("Unit-Amount Rounding Precision");
                    "Unit Cost" :=
                      Round(
                        CurrExchRate.ExchangeAmtLCYToFCY(
                          ServiceHeader."Posting Date", ServiceHeader."Currency Code",
                          "Unit Cost (LCY)", ServiceHeader."Currency Factor"),
                        Currency."Unit-Amount Rounding Precision")
                end else
                    "Unit Cost" := "Unit Cost (LCY)";
                //<<Delta MGR 
            end;
        }
        field(25; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(27; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            var
                ServiceHeader: Record "Service Header EDMS";
            begin
                TestStatusOpen;

                CheckSPackage(FieldNo("Line Discount %"), 0); //02.01.2008 EDMS P3

                "Line Discount Amount" :=
                  ROUND(
                    ROUND(Quantity * "Unit Price", Currency."Amount Rounding Precision") *
                    "Line Discount %" / 100, Currency."Amount Rounding Precision");
                "Inv. Discount Amount" := 0;
                "Inv. Disc. Amount to Invoice" := 0;
                UpdateAmounts;
            end;
        }
        field(28; "Line Discount Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';

            trigger OnValidate()
            var
                ServiceHeader: Record "Service Header EDMS";
                decAmount: Decimal;
            begin
                TestStatusOpen;

                CheckSPackage(FieldNo("Line Discount Amount"), 0); //02.01.2008 EDMS P3

                TestField(Quantity);
                if ROUND(Quantity * "Unit Price", Currency."Amount Rounding Precision") <> 0 then
                    "Line Discount %" :=
                      ROUND(
                       "Line Discount Amount" / ROUND(Quantity * "Unit Price", Currency."Amount Rounding Precision") * 100,
                        0.00001)
                else
                    "Line Discount %" := 0;
                "Inv. Discount Amount" := 0;
                "Inv. Disc. Amount to Invoice" := 0;
                UpdateAmounts;
            end;
        }
        field(29; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
            Editable = false;

            trigger OnValidate()
            begin
                TestStatusOpen;
                Amount := ROUND(Amount, Currency."Amount Rounding Precision");
                if "VAT Calculation Type" in ["vat calculation type"::"Normal VAT", "vat calculation type"::"Reverse Charge VAT"] then
                    "Amount Including VAT" := ROUND(Amount + Amount * "VAT %" / 100, Currency."Amount Rounding Precision");
            end;
        }
        field(30; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
            Editable = false;

            trigger OnValidate()
            begin
                TestStatusOpen;

                "Amount Including VAT" := ROUND("Amount Including VAT", Currency."Amount Rounding Precision");
                case "VAT Calculation Type" of
                    "vat calculation type"::"Normal VAT",
                    "vat calculation type"::"Reverse Charge VAT":
                        begin
                            Amount :=
                              ROUND(
                                "Amount Including VAT" /
                                (1 + (1 - ServiceHeader."VAT Base Discount %" / 100) * "VAT %" / 100),
                                Currency."Amount Rounding Precision");
                            "VAT Base Amount" :=
                              ROUND(Amount * (1 - ServiceHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
                        end;
                    "vat calculation type"::"Full VAT":
                        begin
                            Amount := 0;
                            "VAT Base Amount" := 0;
                        end;
                    "vat calculation type"::"Sales Tax":
                        begin
                            ServiceHeader.TestField("VAT Base Discount %", 0);
                            Amount :=
                              SalesTaxCalculate.ReverseCalculateTax(
                                "Tax Area Code", "Tax Group Code", "Tax Liable", ServiceHeader."Posting Date",
                                "Amount Including VAT", "Quantity (Base)", ServiceHeader."Currency Factor");
                            if Amount <> 0 then
                                "VAT %" :=
                                  ROUND(100 * ("Amount Including VAT" - Amount) / Amount, 0.00001)
                            else
                                "VAT %" := 0;
                            Amount := ROUND(Amount, Currency."Amount Rounding Precision");
                            "VAT Base Amount" := Amount;
                        end;
                end;
            end;
        }
        field(32; "Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;

            trigger OnValidate()
            begin
                TestStatusOpen;
                if ("Allow Invoice Disc." <> xRec."Allow Invoice Disc.") and
                   (not "Allow Invoice Disc.")
                then begin
                    "Inv. Discount Amount" := 0;
                    "Inv. Disc. Amount to Invoice" := 0;
                    UpdateAmounts;
                end;
            end;
        }
        field(38; "Appl.-to Item Entry"; Integer)
        {
            Caption = 'Appl.-to Item Entry';

            trigger OnLookup()
            begin
                SelectItemEntry(FieldNo("Appl.-to Item Entry"));
            end;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
            begin
                if "Appl.-to Item Entry" <> 0 then begin
                    TestField(Type, Type::Item);
                    TestField(Quantity);
                    ItemLedgEntry.Get("Appl.-to Item Entry");
                    ItemLedgEntry.TestField(Positive, true);
                    ItemLedgEntry.TestField(Open, true);
                    Validate("Unit Cost (LCY)", CalcUnitCost(ItemLedgEntry));

                    "Location Code" := ItemLedgEntry."Location Code";
                end;
            end;
        }
        field(40; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                TestStatusOpen;
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(41; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                TestStatusOpen;
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(42; "Customer Price Group"; Code[20])
        {
            Caption = 'Customer Price Group';
            Editable = false;
            TableRelation = "Customer Price Group";
        }
        field(56; "Recalculate Invoice Disc."; Boolean)
        {
            Caption = 'Recalculate Invoice Disc.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(67; "Profit %"; Decimal)
        {
            Caption = 'Profit %';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(68; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer."No.";
        }
        field(69; "Inv. Discount Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Inv. Discount Amount';
            Editable = false;

            trigger OnValidate()
            begin
                TestField(Quantity);
                CalcInvDiscToInvoice;
                UpdateAmounts;
            end;
        }
        field(71; "Purchase Order No."; Code[20])
        {
            Caption = 'Purchase Order No.';
            Editable = false;
            TableRelation = if ("Drop Shipment" = const(true)) "Purchase Header"."No." where("Document Type" = const(Order));
        }
        field(72; "Purch. Order Line No."; Integer)
        {
            Caption = 'Purch. Order Line No.';
            Editable = false;
            TableRelation = if ("Drop Shipment" = const(true)) "Purchase Line"."Line No." where("Document Type" = const(Order),
                                                                                               "Document No." = field("Purchase Order No."));
        }
        field(73; "Drop Shipment"; Boolean)
        {
            Caption = 'Drop Shipment';
            Editable = true;
        }
        field(74; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(75; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            begin
                TestStatusOpen;                                                                  // 14.04.2014 Elva Baltic P21
            end;
        }
        field(77; "VAT Calculation Type"; Enum "Tax Calculation Type")
        {
            Caption = 'VAT Calculation Type';
            Editable = false;
        }
        field(80; "Attached to Line No."; Integer)
        {
            Caption = 'Attached to Line No.';
            Editable = false;
            TableRelation = "Service Line EDMS"."Line No." where("Document Type" = field("Document Type"),
                                                                  "Document No." = field("Document No."));
        }
        field(85; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";

            trigger OnValidate()
            begin
                UpdateAmounts;
            end;
        }
        field(86; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';

            trigger OnValidate()
            begin
                UpdateAmounts;
            end;
        }
        field(87; "Tax Group Code"; Code[10])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";

            trigger OnValidate()
            begin
                TestStatusOpen;
                UpdateAmounts;
            end;
        }
        field(89; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                TestStatusOpen;
                Validate("VAT Prod. Posting Group");
            end;
        }
        field(90; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            var
                ServiceHeader: Record "Service Header EDMS";
            begin
                TestStatusOpen;
                GetServiceHeader;
                VATPostingSetup.Get("VAT Bus. Posting Group", "VAT Prod. Posting Group");
                "VAT Difference" := 0;
                "VAT %" := VATPostingSetup."VAT %";
                "VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
                "VAT Identifier" := VATPostingSetup."VAT Identifier";
                case "VAT Calculation Type" of
                    "vat calculation type"::"Reverse Charge VAT",
                  "vat calculation type"::"Sales Tax":
                        "VAT %" := 0;
                    "vat calculation type"::"Full VAT":
                        begin
                            TestField(Type, Type::"G/L Account");
                            VATPostingSetup.TestField("Sales VAT Account");
                            TestField("No.", VATPostingSetup."Sales VAT Account");
                        end;
                end;

                if ServiceHeader."Prices Including VAT" and (Type in [Type::Item]) then
                    "Unit Price" :=
                      ROUND(
                        "Unit Price" * (100 + "VAT %") / (100 + xRec."VAT %"),
                        Currency."Unit-Amount Rounding Precision");

                //26.01.2015 EB.P7 E0060 MMG7.00 >>
                Validate("Unit Price");
                //26.01.2015 EB.P7 E0060 MMG7.00 <<
                Validate("Prepayment %");
            end;
        }
        field(91; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;
        }
        field(95; "Reserved Quantity"; Decimal)
        {
            CalcFormula = - sum("Reservation Entry".Quantity where("Source ID" = field("Document No."),
                                                                   "Source Ref. No." = field("Line No."),
                                                                   "Source Type" = const(25006146),
                                                                   "Source Subtype" = field("Document Type"),
                                                                   "Reservation Status" = const(Reservation)));
            Caption = 'Reserved Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(96; Reserve; Enum "Reserve Method")
        {
            Caption = 'Reserve';

            trigger OnValidate()
            begin
                if Reserve <> Reserve::Never then begin
                    TestField(Type, Type::Item);
                    TestField("No.");
                end;
                CalcFields("Reserved Qty. (Base)");
                if (Reserve = Reserve::Never) and ("Reserved Qty. (Base)" > 0) then
                    TestField("Reserved Qty. (Base)", 0);

                if xRec.Reserve = Reserve::Always then begin
                    GetItem;
                    if Item.Reserve = Item.Reserve::Always then
                        TestField(Reserve, Reserve::Always);
                end;
            end;
        }
        field(99; "VAT Base Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'VAT Base Amount';
            Editable = false;
        }
        field(100; "Unit Cost"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            Editable = false;
        }
        field(101; "System-Created Entry"; Boolean)
        {
            Caption = 'System-Created Entry';
            Editable = false;
        }
        field(103; "Line Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Line Amount"));
            Caption = 'Line Amount';

            trigger OnValidate()
            var
                ServHeader: Record "Service Header EDMS";
            begin
                TestField(Type);
                TestField(Quantity);
                TestField("Unit Price");
                GetServiceHeader;

                "Line Amount" := ROUND("Line Amount", Currency."Amount Rounding Precision");
                Validate(
                  "Line Discount Amount", ROUND(Quantity * "Unit Price", Currency."Amount Rounding Precision") - "Line Amount");
            end;
        }
        field(104; "VAT Difference"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'VAT Difference';
            Editable = false;
        }
        field(105; "Inv. Disc. Amount to Invoice"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Inv. Disc. Amount to Invoice';
            Editable = false;
        }
        field(106; "VAT Identifier"; Code[20])
        {
            Caption = 'VAT Identifier';
            Editable = false;
        }
        field(109; "Prepayment %"; Decimal)
        {
            Caption = 'Prepayment %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            var
                GenPostingSetup: Record "General Posting Setup";
                GLAcc: Record "G/L Account";
                GenLedgSetup: Record "General Ledger Setup";
            begin
                if "Prepayment %" <> 0 then begin
                    TestField("Document Type", "document type"::Order);
                    TestField(Type);
                    TestField("No.");
                    GenLedgSetup.Get;
                    GenPostingSetup.Get("Gen. Bus. Posting Group", "Gen. Prod. Posting Group");
                    if GenPostingSetup."Service Prepayments Account" <> '' then begin
                        if GenLedgSetup."Calc.Prepmt.VAT by Line PostGr" then
                            VATPostingSetup.Get("VAT Bus. Posting Group", "VAT Prod. Posting Group")
                        else begin
                            GLAcc.Get(GenPostingSetup."Service Prepayments Account");
                            VATPostingSetup.Get("VAT Bus. Posting Group", GLAcc."VAT Prod. Posting Group");
                        end
                    end else begin
                        Clear(VATPostingSetup);
                        Error(Text104, GenPostingSetup.FieldCaption("Service Prepayments Account"),
                         GenPostingSetup.TableCaption, "Gen. Bus. Posting Group", "Gen. Prod. Posting Group");
                    end;
                    "Prepayment VAT %" := VATPostingSetup."VAT %";
                    "Prepmt. VAT Calc. Type" := VATPostingSetup."VAT Calculation Type";
                    "Prepayment VAT Identifier" := VATPostingSetup."VAT Identifier";
                    case "Prepmt. VAT Calc. Type" of
                        "vat calculation type"::"Reverse Charge VAT",
                      "vat calculation type"::"Sales Tax":
                            "Prepayment VAT %" := 0;
                        "vat calculation type"::"Full VAT":
                            FieldError("Prepmt. VAT Calc. Type", StrSubstNo(Text041, "Prepmt. VAT Calc. Type"));
                    end;
                    "Prepayment Tax Group Code" := GLAcc."Tax Group Code";
                end;

                TestStatusOpen;

                if Type <> Type::Comment then
                    UpdateAmounts;
            end;
        }
        field(110; "Prepmt. Line Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Prepmt. Line Amount"));
            Caption = 'Prepmt. Line Amount';
            Description = 'total amount that should be in "Prepmt. Amt. Inv." after post';
            MinValue = 0;

            trigger OnValidate()
            begin
                TestStatusOpen;
                TestField("Line Amount");
                if "Prepmt. Line Amount" < "Prepmt. Amt. Inv." then
                    FieldError("Prepmt. Line Amount", StrSubstNo(Text044, "Prepmt. Amt. Inv."));
                if "Prepmt. Line Amount" > "Line Amount" then
                    FieldError("Prepmt. Line Amount", StrSubstNo(Text043, "Line Amount"));
                Validate("Prepayment %", ROUND("Prepmt. Line Amount" * 100 / "Line Amount", 0.00001));
            end;
        }
        field(111; "Prepmt. Amt. Inv."; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Prepmt. Amt. Inv."));
            Caption = 'Prepmt. Amt. Inv.';
            Description = 'total amount invoiced already by prepayments';
            Editable = false;
        }
        field(112; "Prepmt. Amt. Incl. VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. Amt. Incl. VAT';
            Description = 'total amount invoiced already by prepayments. Actually name should be "Prepmt. Amt. Inv. Incl. VAT" but it left due to T37 analogue';
            Editable = false;
        }
        field(113; "Prepayment Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepayment Amount';
            Description = 'used in post process, after pont means last prepayment amount';
            Editable = false;
        }
        field(114; "Prepmt. VAT Base Amt."; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. VAT Base Amt.';
            Editable = false;
        }
        field(115; "Prepayment VAT %"; Decimal)
        {
            Caption = 'Prepayment VAT %';
            DecimalPlaces = 0 : 5;
            Editable = false;
            MinValue = 0;
        }
        field(116; "Prepmt. VAT Calc. Type"; Enum "Tax Calculation Type")
        {
            Caption = 'Prepmt. VAT Calc. Type';
            Editable = false;
        }
        field(117; "Prepayment VAT Identifier"; Code[10])
        {
            Caption = 'Prepayment VAT Identifier';
            Editable = false;
        }
        field(118; "Prepayment Tax Area Code"; Code[20])
        {
            Caption = 'Prepayment Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(119; "Prepayment Tax Liable"; Boolean)
        {
            Caption = 'Prepayment Tax Liable';

            trigger OnValidate()
            begin
                UpdateAmounts;
            end;
        }
        field(120; "Prepayment Tax Group Code"; Code[20])
        {
            Caption = 'Prepayment Tax Group Code';
            TableRelation = "Tax Group";

            trigger OnValidate()
            begin
                TestStatusOpen;
                UpdateAmounts;
            end;
        }
        field(121; "Prepmt Amt to Deduct"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Prepmt Amt to Deduct"));
            Caption = 'Prepmt Amt to Deduct';
            Description = 'amount that should substituted from "Line Amount" for next payment';
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Prepmt Amt to Deduct" > "Prepmt. Amt. Inv." - "Prepmt Amt Deducted" then
                    FieldError(
                      "Prepmt Amt to Deduct",
                      StrSubstNo(Text045, "Prepmt. Amt. Inv." - "Prepmt Amt Deducted"));
            end;
        }
        field(122; "Prepmt Amt Deducted"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Prepmt Amt Deducted"));
            Caption = 'Prepmt Amt Deducted';
            Description = 'it is used for rule: "Prepmt Amt to Deduct" = "Prepmt. Amt. Inv." - "Prepmt Amt Deducted"';
            Editable = false;
        }
        field(123; "Prepayment Line"; Boolean)
        {
            Caption = 'Prepayment Line';
            Editable = false;
        }
        field(124; "Prepayment Amount Incl. VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepayment Amount Incl. VAT';
            Description = 'used in post process,  side by side with "Prepayment Amount".';
            Editable = false;
        }
        field(125; "User ID"; Text[132])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
            TableRelation = User."User Name";
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(5402; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = if (Type = const(Item)) "Item Variant".Code where("Item No." = field("No."));

            trigger OnValidate()
            begin
                if "Variant Code" <> '' then                                                // 14.04.2014 Elva Baltic P21
                    TestField(Type, Type::Item);                                               // 14.04.2014 Elva Baltic P21
                TestStatusOpen;                                                             // 14.04.2014 Elva Baltic P21
            end;
        }
        field(5403; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
        }
        field(5404; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(5405; Planned; Boolean)
        {
            Caption = 'Planned';
            Editable = false;
        }
        field(5407; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = if (Type = const(Item)) "Item Unit of Measure".Code where("Item No." = field("No."))
            else
            "Unit of Measure".Code;

            trigger OnValidate()
            var
                UnitOfMeasureTranslation: Record "Unit of Measure Translation";
                ResUnitofMeasure: Record "Resource Unit of Measure";
            begin
                TestStatusOpen;                                                             // 14.04.2014 Elva Baltic P21

                if Type in [Type::Item, Type::Labor] then
                    UpdateUnitPrice(FieldNo("Unit of Measure Code"));

                UpdateQtyHours(FieldNo("Unit of Measure Code"));

                if "Unit of Measure Code" = '' then
                    "Unit of Measure" := ''
                else begin
                    if not UnitOfMeasure.Get("Unit of Measure Code") then
                        UnitOfMeasure.Init;
                    "Unit of Measure" := UnitOfMeasure.Description;
                    GetServiceHeader;
                    if ServiceHeader."Language Code" <> '' then begin
                        UnitOfMeasureTranslation.SetRange(Code, "Unit of Measure Code");
                        UnitOfMeasureTranslation.SetRange("Language Code", ServiceHeader."Language Code");
                        if UnitOfMeasureTranslation.FindFirst then
                            "Unit of Measure" := UnitOfMeasureTranslation.Description;
                    end;
                end;
                case Type of
                    Type::Item:
                        begin
                            GetItem();
                            GetUnitCost();
                            CheckItemAvailable(FieldNo("Unit of Measure Code"));
                        end;
                end;
                validate(Quantity);
                UpdateUnitPrice(FieldNo("Unit of Measure Code"));
            end;
        }
        field(5415; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                TestField("Qty. per Unit of Measure", 1);
                Validate(Quantity, "Quantity (Base)");
                UpdateUnitPrice(FieldNo("Quantity (Base)"));
            end;
        }
        field(5416; "Outstanding Qty. (Base)"; Decimal)
        {
            Caption = 'Outstanding Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5495; "Reserved Qty. (Base)"; Decimal)
        {
            CalcFormula = - sum("Reservation Entry"."Quantity (Base)" where("Source ID" = field("Document No."),
                                                                            "Source Ref. No." = field("Line No."),
                                                                            "Source Type" = const(25006146),
                                                                            "Source Subtype" = field("Document Type"),
                                                                            "Reservation Status" = const(Reservation)));
            Caption = 'Reserved Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                TestField("Qty. per Unit of Measure");
                CalcFields("Reserved Quantity");
                Planned := "Reserved Quantity" = "Outstanding Quantity";
            end;
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            Editable = false;
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin
                CallCreateDim;
            end;
        }
        field(5706; "Unit of Measure (Cross Ref.)"; Code[10])
        {
            Caption = 'Unit of Measure (Cross Ref.)';
            TableRelation = if (Type = const(Item)) "Item Unit of Measure".Code where("Item No." = field("No."));
        }
        field(5709; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(5710; Nonstock; Boolean)
        {
            Caption = 'Nonstock';
            Editable = false;
        }
        field(5711; "Purchasing Code"; Code[10])
        {
            Caption = 'Purchasing Code';
            TableRelation = Purchasing;

            trigger OnValidate()
            begin
                TestStatusOpen;
                TestField(Type, Type::Item);
                CheckAssocPurchOrder(FieldCaption(Type));

                if PurchasingCode.Get("Purchasing Code") then begin
                    "Drop Shipment" := PurchasingCode."Drop Shipment";
                    "Special Order" := PurchasingCode."Special Order";
                    if "Drop Shipment" or "Special Order" then begin
                        Reserve := Reserve::Never;
                        Validate(Quantity, Quantity);
                        if "Drop Shipment" then begin
                            //EVALUATE("Outbound Whse. Handling Time",'<0D>');
                            Evaluate("Shipping Time", '<0D>');
                            UpdateDates;
                            "Bin Code" := '';
                        end;
                    end;
                end else begin
                    "Drop Shipment" := false;
                    "Special Order" := false;

                    GetItem;
                    if Item.Reserve = Item.Reserve::Optional then begin
                        GetServiceHeader;
                        Reserve := ServiceHeader.Reserve;
                    end else
                        Reserve := Item.Reserve;
                end;

                if ("Purchasing Code" <> xRec."Purchasing Code") and
                   (not "Drop Shipment") and
                   ("Drop Shipment" <> xRec."Drop Shipment")
                then begin
                    /*
                    IF "Location Code" = '' THEN BEGIN
                      IF InvtSetup.GET THEN
                        "Outbound Whse. Handling Time" := InvtSetup."Outbound Whse. Handling Time";
                    END ELSE
                      IF Location.GET("Location Code") THEN
                        "Outbound Whse. Handling Time" := Location."Outbound Whse. Handling Time";
                    */
                    if ShippingAgentServices.Get("Shipping Agent Code", "Shipping Agent Service Code") then
                        "Shipping Time" := ShippingAgentServices."Shipping Time"
                    else begin
                        GetServiceHeader;
                        "Shipping Time" := ServiceHeader."Shipping Time";
                    end;
                    UpdateDates;
                end;

            end;
        }
        field(5712; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
        }
        field(5713; "Special Order"; Boolean)
        {
            Caption = 'Special Order';
            Editable = false;
        }
        field(5714; "Special Order Purchase No."; Code[20])
        {
            Caption = 'Special Order Purchase No.';
            TableRelation = if ("Special Order" = const(true)) "Purchase Header"."No." where("Document Type" = const(Order));
        }
        field(5715; "Special Order Purch. Line No."; Integer)
        {
            Caption = 'Special Order Purch. Line No.';
            TableRelation = if ("Special Order" = const(true)) "Purchase Line"."Line No." where("Document Type" = const(Order),
                                                                                               "Document No." = field("Special Order Purchase No."));
        }
        field(5790; "Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';

            trigger OnValidate()
            begin
                TestStatusOpen;
                if ("Requested Delivery Date" <> xRec."Requested Delivery Date") and
                   ("Promised Delivery Date" <> 0D)
                then
                    Error(
                      Text028,
                      FieldCaption("Requested Delivery Date"),
                      FieldCaption("Promised Delivery Date"));

                if "Requested Delivery Date" <> 0D then
                    Validate("Planned Delivery Date", "Requested Delivery Date")
                else begin
                    GetServiceHeader;
                    Validate("Shipment Date", ServiceHeader."Shipment Date");
                end;
            end;
        }
        field(5791; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';

            trigger OnValidate()
            begin
                TestStatusOpen;
                if "Promised Delivery Date" <> 0D then
                    Validate("Planned Delivery Date", "Promised Delivery Date")
                else
                    Validate("Requested Delivery Date");
            end;
        }
        field(5792; "Shipping Time"; DateFormula)
        {
            Caption = 'Shipping Time';

            trigger OnValidate()
            begin
                TestStatusOpen;
                UpdateDates;
            end;
        }
        field(5794; "Planned Delivery Date"; Date)
        {
            Caption = 'Planned Delivery Date';

            trigger OnValidate()
            begin
                TestStatusOpen;
                if "Planned Delivery Date" <> 0D then begin
                    PlannedDeliveryDateCalculated := true;
                    Validate(
                        "Planned Shipment Date",
                        CalcPlannedShptDate(FieldNo("Planned Delivery Date"))
                    );

                    if "Planned Shipment Date" > "Planned Delivery Date" then
                        "Planned Delivery Date" := "Planned Shipment Date";
                end;
            end;
        }
        field(5795; "Planned Shipment Date"; Date)
        {
            Caption = 'Planned Shipment Date';

            trigger OnValidate()
            begin
                TestStatusOpen;
                if "Planned Shipment Date" <> 0D then begin
                    PlannedShipmentDateCalculated := true;
                    Validate(
                      "Shipment Date",
                      CalcShipmentDate()
                    );
                end;

            end;
        }
        field(5796; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";

            trigger OnValidate()
            begin
                TestStatusOpen;
                if "Shipping Agent Code" <> xRec."Shipping Agent Code" then
                    Validate("Shipping Agent Service Code", '');
            end;
        }
        field(5797; "Shipping Agent Service Code"; Code[10])
        {
            Caption = 'Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code where("Shipping Agent Code" = field("Shipping Agent Code"));

            trigger OnValidate()
            begin
                TestStatusOpen;
                if "Shipping Agent Service Code" <> xRec."Shipping Agent Service Code" then
                    Evaluate("Shipping Time", '<>');

                if "Drop Shipment" then begin
                    Evaluate("Shipping Time", '<0D>');
                    UpdateDates;
                end else begin
                    if ShippingAgentServices.Get("Shipping Agent Code", "Shipping Agent Service Code") then
                        "Shipping Time" := ShippingAgentServices."Shipping Time"
                    else begin
                        GetServiceHeader;
                        "Shipping Time" := ServiceHeader."Shipping Time";
                    end;
                end;

                if ShippingAgentServices."Shipping Time" <> xRec."Shipping Time" then
                    Validate("Shipping Time", "Shipping Time");
            end;
        }
        field(5811; "Appl.-from Item Entry"; Integer)
        {
            Caption = 'Appl.-from Item Entry';
            MinValue = 0;

            trigger OnLookup()
            begin
                SelectItemEntry(FieldNo("Appl.-from Item Entry"));
            end;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
            begin
                if "Appl.-from Item Entry" <> 0 then begin
                    CheckApplFromItemLedgEntry(ItemLedgEntry);
                    Validate("Unit Cost (LCY)", CalcUnitCost(ItemLedgEntry));
                end;
            end;
        }
        field(5917; "Qty. to Consume"; Decimal)
        {
            BlankZero = true;
            Caption = 'Qty. to Consume';
            DecimalPlaces = 0 : 5;
        }
        field(5918; "Quantity Consumed"; Decimal)
        {
            Caption = 'Quantity Consumed';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5919; "Qty. to Consume (Base)"; Decimal)
        {
            BlankZero = true;
            Caption = 'Qty. to Consume (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(5920; "Qty. Consumed (Base)"; Decimal)
        {
            Caption = 'Qty. Consumed (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(7000; "Price Calculation Method"; Enum "Price Calculation Method")
        {
            Caption = 'Price Calculation Method';
        }
        field(7001; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(7002; "Customer Disc. Group"; Code[20])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";
        }
        field(51212; "Labor Type"; Option)
        {
            Caption = 'Labor Type';
            OptionCaption = 'Labor,Travel Time,Travel Distance,Travel Other,Meal Allowance,Other';
            OptionMembers = Labor,"Travel Time","Travel Distance","Travel Other","Meal Allowance",Other;
        }
        field(60000; "External No."; Code[20])
        {
            Caption = 'External No.';
        }
        field(60100; Group; Boolean)
        {
            Caption = 'Group';
        }
        field(60110; "Group ID"; Integer)
        {
            Caption = 'Group ID';
            TableRelation = "Service Line EDMS"."Line No." where("Document Type" = field("Document Type"),
                                                                  "Document No." = field("Document No."),
                                                                  Group = const(true));

            trigger OnLookup()
            var
                ServLine: Record "Service Line EDMS";
            begin
                if Group then
                    exit;

                ServLine.Reset;
                ServLine.SetRange("Document Type", "Document Type");
                ServLine.SetRange("Document No.", "Document No.");

                if LookUpMgt.LookUpServLineGroup(ServLine, "Group ID") then
                    Validate("Group ID");
                CalcFields("Group Description");
            end;

            trigger OnValidate()
            begin
                CalcFields("Group Description");
            end;
        }
        field(60120; "Group Description"; Text[100])
        {
            CalcFormula = lookup("Service Line EDMS".Description where("Document Type" = field("Document Type"),
                                                                        "Document No." = field("Document No."),
                                                                        "Line No." = field("Group ID")));
            Caption = 'Group Description';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            var
                ServLine: Record "Service Line EDMS";
            begin
                if Group then
                    exit;

                ServLine.Reset;
                ServLine.SetRange("Document Type", "Document Type");
                ServLine.SetRange("Document No.", "Document No.");

                if LookUpMgt.LookUpServLineGroup(ServLine, "Group ID") then
                    Validate("Group ID");

                CalcFields("Group Description");
            end;
        }
        field(80200; "Quote No."; Code[20])
        {
            Caption = 'Quote No.';
        }
        field(90000; "Posting Date"; Date)
        {
            CalcFormula = lookup("Service Header EDMS"."Posting Date" where("Document Type" = field("Document Type"),
                                                                             "No." = field("Document No.")));
            Caption = 'Posting Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90200; "Planned Service Date"; Date)
        {
            Caption = 'Planned Service Date';
        }
        field(25006001; "Deal Type Code"; Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
        }
        field(25006005; "Minutes Per UoM"; Decimal)
        {
            Caption = 'Minutes Per UoM';

            trigger OnValidate()
            begin
                UpdateQtyHours(0);
            end;
        }
        field(25006006; "Quantity (Hours)"; Decimal)
        {
            Caption = 'Quantity (Hours)';

            trigger OnValidate()
            begin
                UpdateQtyHours(FieldNo("Quantity (Hours)"));
            end;
        }
        field(25006010; "Symptom Code"; Code[20])
        {
            Caption = 'Symptom Code';
            TableRelation = "Symptom Code EDMS".Code where("Make Code" = field("Make Code"));
        }
        field(25006030; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
            ValidateTableRelation = false;
        }
        field(25006100; "Vehicle Axle Code"; Code[10])
        {
            Caption = 'Vehicle Axle Code';
            TableRelation = "Vehicle Axle".Code where("Vehicle Serial No." = field("Vehicle Serial No."));
        }
        field(25006110; "Tire Position Code"; Code[10])
        {
            Caption = 'Tire Position Code';
            TableRelation = "Vehicle Tire Position".Code where("Vehicle Serial No." = field("Vehicle Serial No."),
                                                                "Axle Code" = field("Vehicle Axle Code"));

            trigger OnValidate()
            begin
                if Rec."Tire Position Code" <> '' then begin
                    if "Tire Operation Type" in ["tire operation type"::"Take off", "tire operation type"::"Position Change"] then
                        "Tire Code" := '';
                    GetTire;
                    if Tire.FindFirst then
                        FillTireFields(Tire);
                end;
            end;
        }
        field(25006120; "Tire Code"; Code[20])
        {
            Caption = 'Tire Code';
            TableRelation = Tire.Code;

            trigger OnLookup()
            begin
                if "Tire Operation Type" <> "tire operation type"::" " then begin
                    if "Tire Operation Type" in ["tire operation type"::"Take off", "tire operation type"::"Position Change"] then
                        "Tire Position Code" := '';
                    GetTire;
                    if Page.RunModal(0, Tire) = Action::LookupOK then begin
                        "Tire Code" := Tire.Code;
                        FillTireFields(Tire);
                    end;
                end;
            end;

            trigger OnValidate()
            begin
                if Rec."Tire Code" <> '' then begin
                    if "Tire Operation Type" in ["tire operation type"::"Take off", "tire operation type"::"Position Change"] then
                        "Tire Position Code" := '';
                    GetTire;
                    Tire.SetRange(Code, "Tire Code");
                    if Tire.FindFirst then
                        FillTireFields(Tire);
                end;
            end;
        }
        field(25006125; "Tire Operation Type"; Option)
        {
            Caption = 'Tire Operation Type';
            OptionCaption = ' ,Put on,Take off,Position Change';
            OptionMembers = " ","Put on","Take off","Position Change";
        }
        field(25006126; "New Vehicle Axle Code"; Code[10])
        {
            Caption = 'New Vehicle Axle Code';
            TableRelation = "Vehicle Axle".Code where("Vehicle Serial No." = field("Vehicle Serial No."));
        }
        field(25006127; "New Tire Position Code"; Code[10])
        {
            Caption = 'New Tire Position Code';
            TableRelation = "Vehicle Tire Position".Code where("Vehicle Serial No." = field("Vehicle Serial No."),
                                                                "Axle Code" = field("Vehicle Axle Code"));
        }
        field(25006128; "Tire Description"; Text[250])
        {
            CalcFormula = lookup(Tire.Description where(Code = field("Tire Code")));
            Caption = 'Tire Description';
            FieldClass = FlowField;
        }
        field(25006130; "External Serv. Tracking No."; Code[20])
        {
            Caption = 'External Serv. Tracking No.';
            TableRelation = if (Type = filter("External Service")) "External Serv. Tracking No."."External Serv. Tracking No." where("External Service No." = field("No."), "Service Order No." = field("Document No."), "Vehicle Serial No." = field("Vehicle Serial No."));
        }
        field(25006140; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            Editable = false;
            FieldClass = Normal;
            TableRelation = Vehicle;
        }
        field(25006142; "Qty. to Return"; Decimal)
        {
            Caption = 'Qty. to Return';
            DecimalPlaces = 0 : 5;
        }
        field(25006150; "Standard Time"; Decimal)
        {
            BlankZero = true;
            Caption = 'Standard Time (Hours)';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                // 25.02.2015 EDMS P21 >>
                UnitOfMeasure.Get("Unit of Measure Code");
                if UnitOfMeasure."Minutes Per UoM" = 0 then
                    Error(StrSubstNo(Text127, UnitOfMeasure.FieldCaption("Minutes Per UoM"), FieldCaption("Unit of Measure Code"), "Unit of Measure Code"));
                // 25.02.2015 EDMS P21 <<

                Validate(Quantity, "Standard Time");
                //08.04.2014 Elva Baltic P1 #RX MMG7.00 >>
                UpdateUnitPrice(FieldNo("Standard Time"));
                //08.04.2014 Elva Baltic P1 #RX MMG7.00 <<
            end;
        }
        field(25006160; "Standard Time Line No."; Integer)
        {
            BlankZero = true;
            Caption = 'Standard Time Line No.';
            Editable = false;
        }
        field(25006170; "Vehicle Registration No."; Code[20])
        {
            CalcFormula = lookup("Service Header EDMS"."Vehicle Registration No." where("Document Type" = field("Document Type"),
                                                                                         "No." = field("Document No.")));
            Caption = 'Vehicle Registration No.';
            FieldClass = FlowField;
        }
        field(25006190; "Model Code"; Code[20])
        {
            CalcFormula = lookup("Service Header EDMS"."Model Code" where("Document Type" = field("Document Type"),
                                                                           "No." = field("Document No.")));
            Caption = 'Model Code';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Model.Code;

            trigger OnValidate()
            begin
                TestStatusOpen;                                                             // 14.04.2014 Elva Baltic P21
            end;
        }
        field(25006210; "Package No."; Code[20])
        {
            Caption = 'Package No.';
            Editable = false;
            TableRelation = "Service Package"."No.";
        }
        field(25006220; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;

            trigger OnValidate()
            begin
                TestStatusOpen;                                                             // 14.04.2014 Elva Baltic P21
            end;
        }
        field(25006250; "Service Work Shift Code"; Code[10])
        {
            Caption = 'Service Work Shift Code';
            //TableRelation = Table0;
        }
        field(25006300; "Package Version No."; Integer)
        {
            Caption = 'Package Version No.';
            Editable = false;
            TableRelation = "Service Package Version"."Version No." where("Package No." = field("Package No."));
        }
        field(25006310; "Package Version Spec. Line No."; Integer)
        {
            Caption = 'Package Version Spec. Line No.';
            Editable = false;
            NotBlank = true;
            TableRelation = "Service Package Version Line"."Line No." where("Package No." = field("Package No."),
                                                                             "Version No." = field("Package Version No."));

            trigger OnValidate()
            begin
                UpdateUnitPrice(FieldNo("Package Version Spec. Line No."));
            end;
        }
        field(25006373; VIN; Code[20])
        {
            CalcFormula = lookup("Service Header EDMS".VIN where("Document Type" = field("Document Type"),
                                                                  "No." = field("Document No.")));
            Caption = 'VIN';
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                TestStatusOpen;                                                             // 14.04.2014 Elva Baltic P21
            end;
        }
        field(25006379; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle"."No.";
        }
        field(25006700; "Ordering Price Type Code"; Code[10])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";

            trigger OnValidate()
            begin
                UpdateUnitPrice(FieldNo("Ordering Price Type Code"));
            end;
        }
        field(25006800; "Variable Field 25006800"; Code[20])
        {
            CaptionClass = '7,25006146,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookUpMgt.LookUpVariableField(VFOptions, Database::"Service Line EDMS", FieldNo("Variable Field 25006800"),
                  '', "Variable Field 25006800") then begin
                    Validate("Variable Field 25006800", VFOptions.Code);
                end;
            end;
        }
        field(25006801; "Variable Field 25006801"; Code[20])
        {
            CaptionClass = '7,25006146,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookUpMgt.LookUpVariableField(VFOptions, Database::"Service Line EDMS", FieldNo("Variable Field 25006801"),
                  '', "Variable Field 25006801") then begin
                    Validate("Variable Field 25006801", VFOptions.Code);
                end;
            end;
        }
        field(25006802; "Variable Field 25006802"; Code[20])
        {
            CaptionClass = '7,25006146,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookUpMgt.LookUpVariableField(VFOptions, Database::"Service Line EDMS", FieldNo("Variable Field 25006802"),
                  '', "Variable Field 25006802") then begin
                    Validate("Variable Field 25006802", VFOptions.Code);
                end;
            end;
        }
        field(25006950; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(25006951; "Do Not Print on Invoice"; Boolean)
        {
            Caption = 'Don''t Print on Invoice';
            DataClassification = ToBeClassified;
        }
        field(25006955; "Smart Code"; Code[20])
        {
            Caption = 'Smart Code';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                SmartCodeMgt: Codeunit "Smart Code Mgt";
                NewNo: Code[20];
                LiteTypeError: label 'Line Type must be Item';
            begin
                if Type <> Type::Item then
                    Error(LiteTypeError);

                //IF Type = Type::Item THEN
                if SmartCodeMgt.ProcessSmartCode("Smart Code", NewNo, true) then begin
                    Validate("No.", NewNo);
                    UpdateUnitPrice(FieldNo("Smart Code"));                                         // 06/12/2017 GP1 P30
                end;

                "Smart Code" := '';
            end;
        }
        field(25006960; "Purchase (Special)"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Purchasing: Record Purchasing;
            begin
                if "Purchase (Special)" then begin
                    Purchasing.Reset;
                    Purchasing.SetRange("Special Order", true);
                    Purchasing.FindFirst;
                    Validate("Purchasing Code", Purchasing.Code);
                end else
                    Validate("Purchasing Code", '');
            end;
        }
        field(25006970; "Include in Price Calculation"; Boolean)
        {
            Caption = 'Include in Price Calculation';
            DataClassification = ToBeClassified;
        }
        field(25006971; "Customer Authorised"; Boolean)
        {
            Caption = 'Customer Authorised';
            DataClassification = ToBeClassified;
        }
        field(25006972; "VHC Service Order No."; Code[20])
        {
            Caption = 'VHC Service Order No.';
            DataClassification = ToBeClassified;
            TableRelation = "Service Header EDMS"."No." where("Document Type" = const(Order));
            ValidateTableRelation = false;
        }
        field(25006973; "Reminder Date"; Date)
        {
            Caption = 'Reminder Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                RestrictFieldIfTypeIsBlank(FieldCaption("Reminder Date"));
            end;
        }
        field(25006974; "Inventory Comment"; Text[50])
        {
            Caption = 'Inventory Comment';
            DataClassification = ToBeClassified;
        }
        field(25006998; "Has Replacement"; Boolean)
        {
            Caption = 'Has Replacement';
            DataClassification = ToBeClassified;
        }
        field(25007110; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract."Contract No." where("Bill-to Customer No." = field("Bill-to Customer No."));
        }
        field(25007150; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job."No." where("Bill-to Customer No." = field("Bill-to Customer No."));
        }
        field(25007180; Split; Boolean)
        {
            Caption = 'Split';
        }
        field(25007190; Status; Code[10])
        {
            Caption = 'Status';
            TableRelation = "Service Work Status EDMS";

            trigger OnValidate()
            var
                ServiceHdrLoc: Record "Service Header EDMS";
                ServiceLineTemp: Record "Service Line EDMS" temporary;
                ServiceLine: Record "Service Line EDMS";
            begin
                ServiceScheduleSetup.Get;
                if ServiceScheduleSetup."Control Document Statuses" and (CurrFieldNo = FieldNo(Status)) then
                    Error(Text103);

                if Status <> xRec.Status then begin
                    ServiceLineTemp.Reset;
                    ServiceLineTemp.DeleteAll;

                    ServiceLine.Reset;
                    ServiceLine.SetRange("Document Type", "Document Type");
                    ServiceLine.SetRange("Document No.", "Document No.");
                    if ServiceLine.FindFirst then
                        repeat
                            ServiceLineTemp.Init;
                            ServiceLineTemp := ServiceLine;
                            ServiceLineTemp.Insert;
                        until ServiceLine.Next = 0;


                    //Updating service line status in temp variable
                    ServiceLineTemp.Get("Document Type", "Document No.", "Line No.");
                    ServiceLineTemp.Status := Status;
                    ServiceLineTemp.Modify(true);

                    ServiceHdrLoc.Get("Document Type", "Document No.");
                    ServScheduleMgt.ChangeServiceHeaderStatusOld(ServiceHdrLoc, ServiceLineTemp);
                end;
            end;
        }
        field(25007195; "BOM Item No."; Code[20])
        {
            Caption = 'BOM Item No.';
            TableRelation = Item;
        }
        field(25007200; "Finished Quantity (Hours)"; Decimal)
        {
            BlankZero = true;
            CalcFormula = sum("Serv. Labor Alloc. Application"."Finished Quantity (Hours)" where("Document Type" = field("Document Type"),
                                                                                                  "Document No." = field("Document No."),
                                                                                                  "Document Line No." = field("Line No.")));
            Caption = 'Finished Quantity (Hours)';
            Description = 'Service Schedule';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25007210; "Remaining Quantity (Hours)"; Decimal)
        {
            BlankZero = true;
            CalcFormula = sum("Serv. Labor Alloc. Application"."Remaining Quantity (Hours)" where("Document Type" = field("Document Type"),
                                                                                                   "Document No." = field("Document No."),
                                                                                                   "Document Line No." = field("Line No.")));
            Caption = 'Remaining Quantity (Hours)';
            Description = 'Service Schedule';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25007220; "Sell-to Customer Name"; Text[100])
        {
            CalcFormula = lookup("Service Header EDMS"."Sell-to Customer Name" where("Sell-to Customer No." = field("Sell-to Customer No.")));
            Caption = 'Sell-to Customer Name';
            FieldClass = FlowField;
        }
        field(25007230; "Bill-to Name"; Text[100])
        {
            CalcFormula = lookup("Service Header EDMS"."Bill-to Name" where("Bill-to Customer No." = field("Bill-to Customer No.")));
            Caption = 'Bill-to Name';
            FieldClass = FlowField;
        }
        field(25007240; "Plan No."; Code[10])
        {
            Caption = 'Plan No.';
            TableRelation = "Vehicle Service Plan"."No." where("Vehicle Serial No." = field("Vehicle Serial No."));
        }
        field(25007245; "Plan Stage Recurrence"; Integer)
        {
            Caption = 'Plan Stage Recurrence';
        }
        field(25007250; "Plan Stage Code"; Code[10])
        {
            Caption = 'Plan Stage Code';
            TableRelation = "Vehicle Service Plan Stage".Code where("Vehicle Serial No." = field("Vehicle Serial No."),
                                                                     "Plan No." = field("Plan No."));
        }
        field(25007260; "Res. Cost Amount Finished"; Decimal)
        {
            CalcFormula = sum("Serv. Labor Alloc. Application"."Finished Cost Amount" where("Document Type" = field("Document Type"),
                                                                                             "Document No." = field("Document No."),
                                                                                             "Document Line No." = field("Line No.")));
            Caption = 'Resource Cost Amount Finished';
            FieldClass = FlowField;
        }
        field(25007270; "Res. Cost Amount Remaining"; Decimal)
        {
            CalcFormula = sum("Serv. Labor Alloc. Application"."Remaining Cost Amount" where("Document Type" = field("Document Type"),
                                                                                              "Document No." = field("Document No."),
                                                                                              "Document Line No." = field("Line No.")));
            Caption = 'Resource Cost Amount Remaining';
            FieldClass = FlowField;
        }
        field(25007280; "Res. Cost Amount Total"; Decimal)
        {
            CalcFormula = sum("Serv. Labor Alloc. Application"."Cost Amount" where("Document Type" = field("Document Type"),
                                                                                    "Document No." = field("Document No."),
                                                                                    "Document Line No." = field("Line No.")));
            Caption = 'Resource Cost Amount Total';
            FieldClass = FlowField;
        }
        field(25007281; "Requested Item No."; Code[20])
        {
            Caption = 'Requested Item No.';
        }
        field(25007282; "Transfer From Location Code"; Code[20])
        {
            Caption = 'Transfer From Location Code';
            DataClassification = ToBeClassified;
            TableRelation = Location;

            trigger OnValidate()
            var
                TransferLine: Record "Transfer Line";
            begin
                if "Reserved Quantity" <> 0 then begin
                    ServiceTransferMgt.FindTransferLine(Rec, TransferLine);
                    Error(Text128, TransferLine."Document No.");
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
            MaintainSIFTIndex = false;
            SumIndexFields = Amount, "Amount Including VAT";
        }
        key(Key2; Type, "No.")
        {
        }
        key(Key3; Type, "No.", "Variant Code", "Location Code", "Document Type", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Planned Service Date")
        {
            SumIndexFields = Quantity;
        }
        key(Key4; "Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Planned Service Date")
        {
            SumIndexFields = "Outstanding Qty. (Base)";
        }
        key(Key5; Type)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        CapableToPromise: Codeunit "Capable to Promise";
        ServiceHeader: Record "Service Header EDMS";
        recSalesLine: Record "Sales Line";
        recSalesHeader: Record "Sales Header";
        recServOrderAlloc: Record "Serv. Labor Alloc. Application";
        recResourceAlloc: Record "Serv. Labor Allocation Entry";
        //SIEAssgnt: Record "SIE Assignment";
        ItemJnlLine: Record "Item Journal Line";
    begin
        if not ServiceHeader.Get("Document Type", "Document No.") then
            exit;

        TestStatusOpen;                                                                  // 14.04.2014 Elva Baltic P21
        /*
        if Type = Type::Item then begin
            //11-06-2007 EDMS P3 SIE
            if "Line No." <> 0 then
                with SIEAssgnt do begin
                    Reset;
                    SetCurrentkey("Applies-to Type", "Applies-to Doc. Type", "Applies-to Doc. No.", "Applies-to Doc. Line No.");
                    SetRange("Applies-to Type", Database::"Service Line EDMS");
                    SetRange("Applies-to Doc. Type", "Document Type");
                    SetRange("Applies-to Doc. No.", "Document No.");
                    SetRange("Applies-to Doc. Line No.", xRec."Line No.");
                    DeleteAll
                end
        end;
        */
        if (Quantity <> 0) and ItemExists("No.") then begin
            ReserveServiceLine.DeleteLine(Rec);
            CalcFields("Reserved Qty. (Base)");
            TestField("Reserved Qty. (Base)", 0);
        end;

        CheckSPackage(FieldNo("Unit Price"), 1); //20.02.2012 EDMS P8

        TestField("Prepmt. Amt. Inv.", 0);   //08-05-2007 EDMS P3 PREPMT

        if (not Recreate) and
           // ("Document Type" IN ["Document Type"::Quote,"Document Type"::Order]) AND                    // 12.05.2014 Elva Baltic P21
           (Type = Type::Labor)
        then begin
            ServScheduleMgt.DontModifySalesLine(true);
            ServScheduleMgt.DeleteAllocationFromServLines(Rec);
            DeleteResourcesOfLine;
        end;

        //09.04.2014 Elva Baltic P1 #RX MMG7.00 >>
        //Commented because this is not letting to change bill-to customer
        //NonstockItemMgt.DelNonStockServEDMS(Rec);
        //09.04.2014 Elva Baltic P1 #RX MMG7.00 <<
    end;

    trigger OnInsert()
    var
        ServiceHeader: Record "Service Header EDMS";
    begin

        TestStatusOpen;

        if Quantity <> 0 then
            ReserveServiceLine.VerifyQuantity(Rec, xRec);
        LockTable;
        ServiceHeader."No." := '';
        "User ID" := UserId;
    end;

    trigger OnModify()
    begin
        if ((Quantity <> 0) or (xRec.Quantity <> 0)) and ItemExists(xRec."No.") then
            ReserveServiceLine.VerifyChange(Rec, xRec);
    end;

    var
        UserSetup: Record "User Setup";
        GLAcc: Record "G/L Account";
        Currency: Record Currency;
        StdTxt: Record "Standard Text";
        UnitOfMeasure: Record "Unit of Measure";
        Resource: Record Resource;
        PurchasingCode: Record Purchasing;
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        VATPostingSetup: Record "VAT Posting Setup";
        UOMMgt: Codeunit "Unit of Measure Management";
        DimMgt: Codeunit DimensionManagement;
        ServScheduleMgt: Codeunit "Service Schedule Mgt.";
        SalesPrice: Record "Sales Price";
        ExtServ: Record "External Service";
        Item: Record Item;
        Location: Record Location;
        ShortcutDimCode: array[8] of Code[20];
        Text028: label 'You cannot change the %1 when the %2 has been filled in.';
        Text000: label 'You cannot delete the order line because it is associated with purchase order %1 line %2.';
        Text001: label 'You cannot rename a %1.';
        Text002: label 'You cannot change %1 because the order line is associated with purchase order %2 line %3.';
        Text012: label 'Change %1 from %2 to %3?';
        Text014: label '%1 %2 is before work date %3';
        tcSER001: label 'You must set payment type dimension';
        tcSER002: label 'Standard times are not set for labor %1';
        Labor: Record "Service Labor";
        TempServLine: Record "Service Line EDMS";
        ExchRate: Record "Currency Exchange Rate";
        Recreate: Boolean;
        tcRD001: label 'Item sales amount cannot be less then cost amount';
        tcSER005: label 'Resource %1 %2 has lower skill level than it''s required for labor %3 %4.';
        CreateInv: Codeunit "Service-Post EDMS";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        tcSER006: label 'Can''t delete order line, because mechanic %1 have not finished allocation %2';
        LookUpMgt: Codeunit LookUpManagement;
        SingleInstanceMgt: Codeunit SingleInstanceManagement;
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        ServiceScheduleSetup: Record "Service Schedule Setup";
        Text029: label 'must be positive';
        Text030: label 'must be negative';
        Text031: label 'You must either specify %1 or %2.';
        Text041: label 'You must cancel the existing approval for this document to be able to change the %1 field.';
        Text043: label 'cannot be %1';
        Text044: label 'cannot be less than %1';
        Text045: label 'cannot be more than %1';
        Text047: label 'must be positive when %1 is not 0';
        ServiceHeader: Record "Service Header EDMS";
        Text048: label 'Cannnot put-in/take-out item with sie assignments. Use SIE assignments.';
        Text120: label 'Can not transfer if invoice exists!';
        EDMS001: label 'Do you want to delete unfinished works for this order in service scheduler?';
        Text100: label 'There is nothing to transfer!';
        PriceCalcMgt: Codeunit "Sales Price Calc. Mgt. EDMS";
        Text101: label 'This line is assigned to a service package. If you change this field you''ll lose all special prices and discounts for this package. Are you sure?';
        LicensePermission: Record "License Permission";
        Text102: label '%1 cannot be greater than %2';
        Text103: label 'You cannot change Service Line Status.';
        HasBeenShown: Boolean;
        Text104: label '%1 isn''t set in table %2 for combination %3 and %4.';
        Reservation: Page Reservation;
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        ReservEntry: Record "Reservation Entry";
        ReserveServiceLine: Codeunit "Service Line EDMS-Reserve";
        ReservMgt: Codeunit "Reservation Management";
        ReservationMgtEDMS: Codeunit "Reservation Management EDMS";
        FullAutoReservation: Boolean;
        Text011: label 'Automatic reservation is not possible.\Reserve items manually?';
        StatusCheckSuspended: Boolean;
        ItemSubstitutionMgt: Codeunit "Item Subst.";
        ItemSubstitutionSync: Codeunit "Item Substitution Sync";
        NonstockItemMgt: Codeunit "Catalog Item Management";
        VFMgt: Codeunit "Variable Field Management";
        Tire: Record Tire;
        Text105: label 'This line is assigned to a service package. If you delete this line you''ll lose all special prices and discounts for this package. Are you sure?';
        PlannedShipmentDateCalculated: Boolean;
        PlannedDeliveryDateCalculated: Boolean;
        AddOnIntegrMgt: Codeunit AddOnIntegrManagement;
        CalendarMgmt: Codeunit "Calendar Management";
        CalChange: Record "Customized Calendar Change";
        ShippingAgentServices: Record "Shipping Agent Services";
        ResourceTextFieldValue: Text[250];
        ResourceTextFieldModified: Boolean;
        ServiceLinePrevParcedRsc: Record "Service Line EDMS" temporary;
        ServLaborApplicationGlobTmp: Record "Serv. Labor Alloc. Application" temporary;
        Text121: label 'There prepayment part of Sell-To is bigger than amount of total document split.';
        Text122: label 'There prepayment part of Bill-To is bigger than amount of total document split.';
        ServiceTransferMgt: Codeunit "Service Transfer Mgt.";
        Text123: label 'Do you wish to delete assigned Transfer Line %1 %2, %3 %4?';
        Text124: label 'You can''t delete Service Line if exist assigned Transfer Line!';
        Text040: label 'You must use form %1 to enter %2, if item tracking is used.';
        Text039: label '%1 units for %2 %3 have already been returned. Therefore, only %4 units can be returned.';
        Text046: label 'You cannot return more than the %1 units that you have shipped for %2 %3.';
        Text125: label 'Quantity can''t be less than Transfered Quantity!';
        Text126: label 'Quantity can''t be changed if exist Transfer Order No.%1! First change Quantity in Transfer Order.';
        Text127: label '%1 cannot be zero for %2 %3';
        CheckItemAvailabilityDone: Boolean;
        Text128: label 'Value can''t be changed if exist Transfer Order No.%1!';
        Text129: label 'Item is under stocktaking';

    protected var
        HideValidationDialog: Boolean;

    local procedure GetItem()
    begin
        TestField("No.");
        if "No." <> Item."No." then
            Item.Get("No.");
    end;

    local procedure GetServiceHeader()
    begin
        TestField("Document No.");
        if ("Document Type" <> ServiceHeader."Document Type") or ("Document No." <> ServiceHeader."No.") then begin
            ServiceHeader.Get("Document Type", "Document No.");
            if ServiceHeader."Currency Code" = '' then
                Currency.InitRoundingPrecision
            else begin
                ServiceHeader.TestField("Currency Factor");
                Currency.Get(ServiceHeader."Currency Code");
                Currency.TestField("Amount Rounding Precision");
            end;
        end;
    end;

    local procedure GetUnitCost()
    begin
        TestField(Type, Type::Item);
        TestField("No.");
        GetItem;
        "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item, "Unit of Measure Code");
        Validate("Unit Cost (LCY)", Item."Unit Cost" * "Qty. per Unit of Measure");
    end;

    local procedure TestStatusOpen()
    begin
        GetServiceHeader;
        if not "System-Created Entry" then
            if Type <> Type::Comment then
                ServiceHeader.TestField(Status, ServiceHeader.Status::Open);
        OnAfterTestStatusOpen(Rec, ServiceHeader);
    end;


    procedure GetItemTranslation()
    var
        ItemTranslation: Record "Item Translation";
    begin
        GetServiceHeader;
        if ItemTranslation.Get("No.", "Variant Code", ServiceHeader."Language Code") then begin
            Description := ItemTranslation.Description;
            "Description 2" := ItemTranslation."Description 2";
        end;
    end;


    procedure UpdateAmounts()
    begin
        GetServiceHeader;
        if "Line Amount" <> xRec."Line Amount" then
            "VAT Difference" := 0;
        if "Line Amount" <> ROUND(Quantity * "Unit Price", Currency."Amount Rounding Precision") - "Line Discount Amount" then begin
            "Line Amount" := ROUND(Quantity * "Unit Price", Currency."Amount Rounding Precision") - "Line Discount Amount";
            "VAT Difference" := 0;
        end;

        //27.01.2010 EDMSB P2 >>
        if ((CurrFieldNo = FieldNo("Line Discount %")) or (CurrFieldNo = FieldNo("Line Discount Amount"))) then
            CheckDiscount;
        //27.01.2010 EDMSB P2 <<

        // IF ServiceHeader.Status = ServiceHeader.Status::Released THEN  // 12.05.2016 EB.P30 GH
        UpdateVATAmounts;
        //08-05-2007 EDMS P3 PREPMT >>
        if "Prepayment %" <> 0 then begin
            if Quantity < 0 then
                FieldError(Quantity, StrSubstNo(Text047, FieldCaption("Prepayment %")));
            if "Unit Price" < 0 then
                FieldError("Unit Price", StrSubstNo(Text047, FieldCaption("Prepayment %")));
        end;
        "Prepmt. Line Amount" := ROUND("Line Amount" * "Prepayment %" / 100, Currency."Amount Rounding Precision");
        if "Prepmt. Line Amount" < "Prepmt. Amt. Inv." then
            FieldError("Prepmt. Line Amount", StrSubstNo(Text044, "Prepmt. Amt. Inv."));
        //08-05-2007 EDMS P3 PREPMT <<
        //>>DELTA
        OnAfterUpdateAmounts(Rec, xRec, CurrFieldNo);
        //<<DELTA
        InitOutstandingAmount;

        //23.10.2007. EDMS P2 >>
        ApplyMarkupRestrictions(0)
        //23.10.2007. EDMS P2 <<
    end;


    procedure UpdateVATAmounts()
    var
        ServLine2: Record "Service Line EDMS";
        TotalLineAmount: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalQuantityBase: Decimal;
        TotalInvDiscAmount: Decimal;
    begin

        ServLine2.SetRange("Document Type", "Document Type");
        ServLine2.SetRange("Document No.", "Document No.");
        ServLine2.SetFilter("Line No.", '<>%1', "Line No.");
        if "Line Amount" = 0 then
            if xRec."Line Amount" >= 0 then
                ServLine2.SetFilter(Amount, '>%1', 0)
            else
                ServLine2.SetFilter(Amount, '<%1', 0)
        else
            if "Line Amount" > 0 then
                ServLine2.SetFilter(Amount, '>%1', 0)
            else
                ServLine2.SetFilter(Amount, '<%1', 0);
        ServLine2.SetRange("VAT Identifier", "VAT Identifier");
        ServLine2.SetRange("Tax Group Code", "Tax Group Code");

        if "Line Amount" = "Inv. Discount Amount" then begin
            Amount := 0;
            "VAT Base Amount" := 0;
            "Amount Including VAT" := 0;
            if "Line No." <> 0 then
                if Modify then
                    if ServLine2.FindLast then begin
                        ServLine2.UpdateAmounts;
                        ServLine2.Modify;
                    end;
        end else begin
            TotalLineAmount := 0;
            TotalInvDiscAmount := 0;
            TotalAmount := 0;
            TotalAmountInclVAT := 0;
            TotalQuantityBase := 0;
            if ("VAT Calculation Type" = "vat calculation type"::"Sales Tax") or
             (("VAT Calculation Type" in
             ["vat calculation type"::"Normal VAT", "vat calculation type"::"Reverse Charge VAT"]) and ("VAT %" <> 0))
          then begin
                if ServLine2.FindSet then
                    repeat
                        TotalLineAmount := TotalLineAmount + ServLine2."Line Amount";
                        TotalInvDiscAmount := TotalInvDiscAmount + ServLine2."Inv. Discount Amount";
                        TotalAmount := TotalAmount + ServLine2.Amount;
                        TotalAmountInclVAT := TotalAmountInclVAT + ServLine2."Amount Including VAT";
                        TotalQuantityBase := TotalQuantityBase + ServLine2."Quantity (Base)";
                    until ServLine2.Next = 0;
            end;

            if ServiceHeader."Prices Including VAT" then
                case "VAT Calculation Type" of
                    "vat calculation type"::"Normal VAT",
                    "vat calculation type"::"Reverse Charge VAT":
                        begin
                            Amount :=
                              ROUND(
                                (TotalLineAmount - TotalInvDiscAmount + "Line Amount" - "Inv. Discount Amount") / (1 + "VAT %" / 100),
                                Currency."Amount Rounding Precision") -
                              TotalAmount;
                            "VAT Base Amount" :=
                              ROUND(
                                Amount * (1 - ServiceHeader."VAT Base Discount %" / 100),
                                Currency."Amount Rounding Precision");
                            "Amount Including VAT" :=
                              TotalLineAmount + "Line Amount" +
                              ROUND(
                                (TotalAmount + Amount) * (ServiceHeader."VAT Base Discount %" / 100) * "VAT %" / 100,
                                Currency."Amount Rounding Precision", Currency.VATRoundingDirection) -
                              TotalAmountInclVAT;
                        end;
                    "vat calculation type"::"Full VAT":
                        begin
                            Amount := 0;
                            "VAT Base Amount" := 0;
                        end;
                    "vat calculation type"::"Sales Tax":
                        begin
                            ServiceHeader.TestField("VAT Base Discount %", 0);
                            Amount :=
                              SalesTaxCalculate.ReverseCalculateTax(
                                "Tax Area Code", "Tax Group Code", "Tax Liable", ServiceHeader."Posting Date",
                                TotalAmountInclVAT + "Amount Including VAT", TotalQuantityBase + "Quantity (Base)",
                                ServiceHeader."Currency Factor") -
                              TotalAmount;
                            if Amount <> 0 then
                                "VAT %" :=
                                  ROUND(100 * ("Amount Including VAT" - Amount) / Amount, 0.00001)
                            else
                                "VAT %" := 0;
                            Amount := ROUND(Amount, Currency."Amount Rounding Precision");
                            "VAT Base Amount" := Amount;
                        end;
                end
            else
                case "VAT Calculation Type" of
                    "vat calculation type"::"Normal VAT",
                    "vat calculation type"::"Reverse Charge VAT":
                        begin
                            Amount := ROUND("Line Amount" - "Inv. Discount Amount", Currency."Amount Rounding Precision");
                            "VAT Base Amount" :=
                               ROUND(Amount * (1 - ServiceHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
                            "Amount Including VAT" :=
                              TotalAmount + Amount +
                              ROUND(
                                (TotalAmount + Amount) * (1 - ServiceHeader."VAT Base Discount %" / 100) * "VAT %" / 100,
                                Currency."Amount Rounding Precision", Currency.VATRoundingDirection) -
                              TotalAmountInclVAT;
                        end;
                    "vat calculation type"::"Full VAT":
                        begin
                            Amount := 0;
                            "VAT Base Amount" := 0;
                            "Amount Including VAT" := "Line Amount" - "Inv. Discount Amount";
                        end;
                    "vat calculation type"::"Sales Tax":
                        begin
                            Amount := ROUND("Line Amount" - "Inv. Discount Amount", Currency."Amount Rounding Precision");
                            "VAT Base Amount" := Amount;
                            "Amount Including VAT" :=
                              TotalAmount + Amount +
                              ROUND(
                                SalesTaxCalculate.CalculateTax(
                                  "Tax Area Code", "Tax Group Code", "Tax Liable", ServiceHeader."Posting Date",
                                  (TotalAmount + Amount), (TotalQuantityBase + "Quantity (Base)"),
                                  ServiceHeader."Currency Factor"), Currency."Amount Rounding Precision") -
                              TotalAmountInclVAT;
                            if "VAT Base Amount" <> 0 then
                                "VAT %" :=
                                  ROUND(100 * ("Amount Including VAT" - "VAT Base Amount") / "VAT Base Amount", 0.00001)
                            else
                                "VAT %" := 0;
                        end;
                end;
        end;
    end;


    procedure ShowNonstock()
    var
        NonstockItem: Record "Nonstock Item";
        ItemCategory: Record "Item Category";
    begin
        //Upgrade 2017 >>
        // TESTFIELD(Type,Type::Item);
        // TESTFIELD("No.",'');
        // IF PAGE.RUNMODAL(PAGE::"Nonstock Item List",NonstockItem) = ACTION::LookupOK THEN BEGIN
        //  NonstockItem.TESTFIELD("Item Category Code");
        //
        //  ItemCategory.GET(NonstockItem."Item Category Code");
        //  ItemCategory.TESTFIELD("Def. Gen. Prod. Posting Group");
        //  ItemCategory.TESTFIELD("Def. Inventory Posting Group");
        //
        //  IF NonstockItem."Item No." = '' THEN
        //   BEGIN
        //    NonstockItemMgt.NonstockAutoItem(NonstockItem);
        //    NonstockItem.GET(NonstockItem."Entry No.");
        //    VALIDATE("No.", NonstockItem."Item No.");
        //   END
        //  ELSE
        //   BEGIN
        //    VALIDATE("No.", NonstockItem."Item No.");
        //   END;
        // END;
        //Upgrade 2017 <<
    end;

    local procedure GetDefaultBin()
    var
        WMSManagement: Codeunit "WMS Management";
        WorkplaceMgt: Codeunit UserProfileManagement;
    begin
        if not (Type = Type::Item) then //in [, Type::"5"]
            exit;

        if (Quantity * xRec.Quantity > 0) and
           ("No." = xRec."No.") and
           ("Location Code" = xRec."Location Code") and
           ("Variant Code" = xRec."Variant Code")
        then
            exit;

        "Bin Code" := '';

        if ("Location Code" <> '') and ("No." <> '') then begin
            GetLocation("Location Code");
            if Location."Bin Mandatory" and not Location."Directed Put-away and Pick" then
                WMSManagement.GetDefaultBin("No.", "Variant Code", "Location Code", "Bin Code");
        end;
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
            Clear(Location)
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;


    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2 %3', "Document Type", "Document No.", "Line No."));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;


    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]; Type3: Integer; No3: Code[20]; Type4: Integer; No4: Code[20]; Type5: Integer; No5: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        OldDimSetID: Integer;
        Dimsource: List of [Dictionary of [Integer, code[20]]];
        IsHandled: Boolean;
    begin
        SourceCodeSetup.Get;
        /* TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;
        TableID[4] := Type4;  //25.10.2013 EDMS P8
        No[4] := No4;
        // 10.03.2015 EDMS P21 >>
        TableID[5] := Type5;
        No[5] := No5;*/
        // 10.03.2015 EDMS P21 <<

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        Clear(Dimsource);
        DimMgt.AddDimSource(Dimsource, Type1, No1);
        DimMgt.AddDimSource(Dimsource, Type2, No2);
        DimMgt.AddDimSource(Dimsource, Type3, No3);
        DimMgt.AddDimSource(Dimsource, Type4, No4);
        DimMgt.AddDimSource(Dimsource, Type5, No5);
        GetServiceHeader;
        OnBeforeGetDefaultDimID(Dimsource, ServiceHeader, rec, IsHandled);
        if not IsHandled then
            "Dimension Set ID" :=
              DimMgt.GetDefaultDimID(Dimsource, SourceCodeSetup."Service Management EDMS",
                                 "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code",
                                  ServiceHeader."Dimension Set ID", Database::Customer);
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;


    procedure ShowCard()
    var
        Item: Record Item;
        Labor: Record "Service Labor";
        External: Record "External Service";
        GLAccount: Record "G/L Account";
    begin
        TestField("No.");
        case Type of
            Type::"G/L Account":
                begin
                    GLAccount.Get("No.");
                    Page.RunModal(Page::"G/L Account Card", GLAccount);
                end;
            Type::Item: //, Type::"5"
                begin
                    Item.Get("No.");
                    Page.RunModal(Page::"Item Card", Item);
                end;
            Type::Labor:
                begin
                    Labor.Get("No.");
                    Page.RunModal(Page::"Service Labor Card", Labor);
                end;
            Type::"External Service":
                begin
                    External.Get("No.");
                    Page.RunModal(Page::"External Service Card", External);
                end;
        end;
    end;


    procedure GetStandardTime()
    var
        ServiceLaborStandardTime: Record "Service Labor Standard Time";
        ServiceHeaderLocal: Record "Service Header EDMS";
        Vehicle: Record Vehicle;
        RecordRef1: RecordRef;
        RecordRef2: RecordRef;
        FieldRef1: FieldRef;
        FieldRef2: FieldRef;
        VFUsage1: Record "Variable Field Usage";
        VFUsage2: Record "Variable Field Usage";
        VariableField: Record "Variable Field";
    begin
        ServiceHeaderLocal.Reset;
        ServiceHeaderLocal.Get("Document Type", "Document No.");
        Vehicle.Reset;
        if not Vehicle.Get(ServiceHeaderLocal."Vehicle Serial No.") then
            exit;

        ServiceLaborStandardTime.SetFilter("Labor No.", "No.");
        if ServiceLaborStandardTime.IsEmpty then
            exit;

        ServiceLaborStandardTime.SetFilter("Make Code", '''''|%1', "Make Code");
        ServiceLaborStandardTime.SetFilter("Model Code", '''''|%1', Vehicle."Model Code");

        ServiceLaborStandardTime.SetFilter("Prod. Year From", '..%1', Vehicle."Production Year");
        ServiceLaborStandardTime.SetFilter("Prod. Year To", '''''|%1..', Vehicle."Production Year");

        RecordRef2.Open(Database::Vehicle);
        RecordRef2.GetTable(Vehicle);

        RecordRef1.Open(Database::"Service Labor Standard Time");

        VFUsage1.Reset;
        VFUsage1.SetRange("Table No.", Database::"Service Labor Standard Time");
        if VFUsage1.FindFirst then
            repeat
                VFUsage2.Reset;
                VFUsage2.SetCurrentkey("Variable Field Code");
                VFUsage2.SetRange("Table No.", Database::Vehicle);
                VFUsage2.SetRange("Variable Field Code", VFUsage1."Variable Field Code");
                if VFUsage2.FindFirst then begin
                    VariableField.Get(VFUsage1."Variable Field Code");
                    if VariableField."Use In Filtering" then begin
                        FieldRef1 := RecordRef2.Field(VFUsage2."Field No.");
                        RecordRef1.SetView(ServiceLaborStandardTime.GetView);
                        FieldRef2 := RecordRef1.Field(VFUsage1."Field No.");
                        FieldRef2.SetFilter('''''|%1', Format(FieldRef1.Value));
                        ServiceLaborStandardTime.SetView(RecordRef1.GetView);
                    end;
                end;
            until VFUsage1.Next = 0;

        if ServiceLaborStandardTime.Count > 1 then begin
            if LookUpMgt.LookUpLaborStandardTime(ServiceLaborStandardTime, "Make Code", "No.", "Standard Time Line No.") then begin
                "Standard Time Line No." := ServiceLaborStandardTime."Line No.";
                Validate("Standard Time", ServiceLaborStandardTime."Standard Time (Hours)");
            end;
        end else begin
            if ServiceLaborStandardTime.FindFirst then begin
                "Standard Time Line No." := ServiceLaborStandardTime."Line No.";
                Validate("Standard Time", ServiceLaborStandardTime."Standard Time (Hours)");
            end;
        end;
    end;



    procedure CallCreateDim()
    var
        ServicePostEDMS: codeunit "Service-Post EDMS";
    begin
        CreateDim(
          Database::"Responsibility Center", "Responsibility Center",
          ServicePostEDMS.EDMSTypeToTableID5(Type), "No.",
          Database::Resource, '',
          Database::Vehicle, "Vehicle Serial No.", //25.10.2013 EDMS P8
          Database::Location, "Location Code"      // 10.03.2015 EDMS P21
          );
    end;


    procedure SetRecreate(NewRecreate: Boolean)
    begin
        Recreate := NewRecreate
    end;

    procedure GetRecreate(): Boolean
    begin
        exit(Recreate);
    end;

    procedure GetDescrLang()
    var
        ServiceHeader: Record "Service Header EDMS";
    begin
        ServiceHeader.Get("Document Type", "Document No.");
        if ServiceHeader."Language Code" = '' then exit;
    end;


    procedure ShowResEntry()
    var
        ResEntry: Record "Reservation Entry";
    begin
        if Type <> Type::Item then exit;
        ResEntry.SetCurrentkey("Reservation Status", "Item No.", "Variant Code", "Location Code");
        ResEntry.SetRange("Reservation Status", ResEntry."reservation status"::Reservation);
        ResEntry.SetRange("Item No.", "No.");
        Page.RunModal(Page::"Reservation Entries", ResEntry);
    end;

    procedure UpdateUnitPrice(CalledByFieldNo: Integer)
    begin
        if (CalledByFieldNo <> CurrFieldNo) and (CurrFieldNo <> 0) then
            exit;

        GetServiceHeader;
        case Type of
            Type::Item:
                begin
                    TestField("Qty. per Unit of Measure");
                end;
            Type::"External Service", Type::Labor:
                begin

                end;
        end;

        if Type in [Type::Item, Type::Labor, Type::"External Service"] then begin
            Clear(PriceCalcMgt);
            // DELTA SALESPRICE
            PriceCalcMgt.FindDMSServLineLineDisc(ServiceHeader, Rec);
            PriceCalcMgt.FindDMSServLinePrice(ServiceHeader, Rec, CalledByFieldNo);
        end;
        OnAfterUpdateUnitPriceOnBeforeValidate(Rec);
        Validate("Unit Price");
    end;

    local procedure UpdateQtyHours(CalledByFieldNo: Integer)
    begin
        if CalledByFieldNo = 0 then
            CalledByFieldNo := CurrFieldNo;

        case Type of
            Type::Item:
                begin
                    exit;
                end;
            Type::Labor:
                begin
                    case CalledByFieldNo of
                        FieldNo("Unit of Measure Code"), FieldNo(Quantity), FieldNo("Minutes Per UoM"), FieldNo("No."):
                            begin
                                if CalledByFieldNo in [FieldNo("Unit of Measure Code"), FieldNo("No.")] then begin
                                    if UnitOfMeasure.Get("Unit of Measure Code") then
                                        "Minutes Per UoM" := UnitOfMeasure."Minutes Per UoM";
                                end;
                                "Quantity (Hours)" := (Quantity * "Minutes Per UoM") / 60;
                            end;
                        FieldNo("Quantity (Hours)"):
                            begin
                                if Quantity = 0 then begin
                                    if "Minutes Per UoM" > 0 then
                                        Quantity := ("Quantity (Hours)" * 60 / "Minutes Per UoM")
                                    else
                                        Quantity := "Quantity (Hours)";
                                end;
                            end;
                    end;
                end;
        end;
    end;

    local procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    var
        ServPricesIncVar: Integer;
        ServHeader: Record "Service Header EDMS";
    begin
        if not ServHeader.Get("Document Type", "Document No.") then begin
            ServHeader."No." := '';
            ServHeader.Init;
        end;
        if ServHeader."Prices Including VAT" then
            ServPricesIncVar := 1
        else
            ServPricesIncVar := 0;
        Clear(ServHeader);
        exit('2,' + Format(ServPricesIncVar) + ',' + GetFieldCaption(FieldNumber));
    end;

    local procedure GetFieldCaption(FieldNumber: Integer): Text[100]
    var
        "Field": Record "Field";
    begin
        Field.Get(Database::"Service Line EDMS", FieldNumber);
        exit(Field."Field Caption");
    end;


    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;


    procedure SetServHeader(NewServHeader: Record "Service Header EDMS")
    begin
        ServiceHeader := NewServHeader;

        if ServiceHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else begin
            ServiceHeader.TestField("Currency Factor");
            Currency.Get(ServiceHeader."Currency Code");
            Currency.TestField("Amount Rounding Precision");
        end;
    end;


    procedure CalcVATAmounts()
    var
        ServLine2: Record "Service Line EDMS";
    begin
        if ServiceHeader.Status <> ServiceHeader.Status::Released then exit;
        SetRange("Document Type", ServiceHeader."Document Type");
        SetRange("Document No.", ServiceHeader."No.");
        if FindFirst then
            repeat
                UpdateVATAmounts;
                Modify
            until Next = 0;
    end;

    /*
    procedure ShowSIEAssgnt()
    var
        SIEAssgnt: Record "SIE Assignment";
        SIEAssgntsForm: Page "SIE Assignment";
    begin
        if "Line No." = 0 then exit;
        Get("Document Type", "Document No.", "Line No.");
        TestField("No.");
        TestField(Type, Type::Item);

        Clear(SIEAssgnt);
        SIEAssgnt."Applies-to Type" := Database::"Service Line EDMS";
        SIEAssgnt."Applies-to Doc. Type" := "Document Type";
        SIEAssgnt."Applies-to Doc. No." := "Document No.";
        SIEAssgnt."Applies-to Doc. Line No." := "Line No.";
        SIEAssgnt."Item No." := "No.";

        SIEAssgntsForm.Initialize(SIEAssgnt);
        SIEAssgntsForm.RunModal;
    end;
    */
    local procedure CalcUnitCost(ItemLedgEntry: Record "Item Ledger Entry"): Decimal
    var
        ValueEntry: Record "Value Entry";
        UnitCost: Decimal;
    begin
        ValueEntry.SetCurrentkey("Item Ledger Entry No.");
        ValueEntry.SetRange("Item Ledger Entry No.", ItemLedgEntry."Entry No.");
        ValueEntry.CalcSums("Cost Amount (Actual)", "Cost Amount (Expected)");
        UnitCost :=
          (ValueEntry."Cost Amount (Expected)" + ValueEntry."Cost Amount (Actual)") / ItemLedgEntry.Quantity;

        exit(Abs(UnitCost * "Qty. per Unit of Measure"));
    end;

    local procedure SelectItemEntry(CurrentFieldNo: Integer)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        ServLine3: Record "Service Line EDMS";
    begin
        ItemLedgEntry.SetRange("Item No.", "No.");
        ItemLedgEntry.SetRange(Correction, false);
        if "Location Code" <> '' then
            ItemLedgEntry.SetRange("Location Code", "Location Code");

        if CurrentFieldNo = FieldNo("Appl.-to Item Entry") then begin
            ItemLedgEntry.SetCurrentkey("Item No.", Open);
            ItemLedgEntry.SetRange(Positive, true);
            ItemLedgEntry.SetRange(Open, true);
        end else begin
            ItemLedgEntry.SetCurrentkey("Item No.", Positive);
            ItemLedgEntry.SetRange(Positive, false);
        end;
        if Page.RunModal(Page::"Item Ledger Entries", ItemLedgEntry) = Action::LookupOK then begin
            ServLine3 := Rec;
            if CurrentFieldNo = FieldNo("Appl.-to Item Entry") then
                ServLine3.Validate("Appl.-to Item Entry", ItemLedgEntry."Entry No.")
            else                                                                                               // 31.03.2014 Elva Baltic P21
                ServLine3.Validate("Appl.-from Item Entry", ItemLedgEntry."Entry No.");                           // 31.03.2014 Elva Baltic P21

            Rec := ServLine3;
        end;
    end;


    procedure NoAssistEdit()
    var
        NonstockItem: Record "Nonstock Item";
        NonstockItemMgt: Codeunit "Catalog Item Management";
    begin
        //EDMS
        if Type = Type::Item then begin
            NonstockItem.Reset;
            if LookUpMgt.LookUpNonstockItem(NonstockItem, "No.") then begin
                if NonstockItem."Item No." = '' then begin
                    NonstockItemMgt.NonstockAutoItem(NonstockItem);
                    NonstockItem.Get(NonstockItem."Entry No.");
                    Validate("No.", NonstockItem."Item No.");
                end
                else begin
                    Validate("No.", NonstockItem."Item No.");
                end;
            end;
        end;
    end;


    procedure TransferLinePrepayment()
    var
        // PrepMgt: Codeunit "Prepayment Mgt.";
        ApplicationEventManagement: Codeunit "Application Event Management";
    begin
        TestField("Document No.");
        TestField("No.");
        TestField("Prepmt. Line Amount");
        ApplicationEventManagement.ServTranfLinePrep(Rec);
    end;


    procedure ApplyMarkupRestrictions(ActionType: Integer)
    var
        CurrencyExch: Record "Currency Exchange Rate";
        LineSalesPrice: Decimal;
        LineCost: Decimal;
        Item: Record Item;
        LineMarkupPercent: Decimal;
        UserSetup: Record "User Setup";
        ItemMarkupRestriction: Record "Item Markup Restriction";
        TextPercent: label '%';
        TextMarkupRestriced: label 'Item No. %1 must have at least %2 %3 markup.';
        ItemMarkupRestrictionGroup: Record "Item Markup Restriction Group";
        ItemLedgEntry: Record "Item Ledger Entry";
        ReservationEntry: Record "Reservation Entry";
        ReservationEntry2: Record "Reservation Entry";
        ItemCost2: Decimal;
        handled: Boolean;
    begin
        //ActioType = 0 => Value validation
        //ActioType = 1 => Document Release

        onBeforeApplyMarkupRestrictions(ActionType, handled);
        if handled then
            exit;
        if (Type <> Type::Item) or ("Quantity (Base)" = 0) then
            exit;

        if "No." = '' then
            exit;

        //ServiceHeader.GET("Document Type","Document No.");            // 07/12/2017 P30 GP1
        GetServiceHeader;                                               // 07/12/2017 P30 GP1

        if UserSetup.Get(UserId) then begin
            if UserSetup."Item Markup Restriction Group" = '' then
                exit;
        end else
            exit;

        if not ItemMarkupRestrictionGroup.get(UserSetup."Item Markup Restriction Group") Then
            exit;

        onBeforefilterItemMarkupRestriction(ItemMarkupRestriction, rec, UserSetup."Item Markup Restriction Group", handled);


        if not handled then begin
            ItemMarkupRestriction.Reset;
            ItemMarkupRestriction.SetFilter("Group Code", '%1|''''', UserSetup."Item Markup Restriction Group");
            ItemMarkupRestriction.SetFilter("Customer Price Group", '%1|''''', "Customer Price Group");
            ItemMarkupRestriction.SetFilter("Item Category Code", '%1|''''', "Item Category Code");
            if not ItemMarkupRestriction.FindFirst then
                exit;
        end;

        //22.10.2007. EDMS P2 >>
        ItemMarkupRestrictionGroup.Get(ItemMarkupRestriction."Group Code");
        //22.10.2007. EDMS P2 <<

        LineCost := 0;

        case ItemMarkupRestriction.Base of
            ItemMarkupRestriction.Base::"Unit Cost":
                begin
                    //02.07.2008. EMDS P2 >>
                    if "Appl.-to Item Entry" <> 0 then begin
                        ItemLedgEntry.Get("Appl.-to Item Entry");
                        ItemLedgEntry.CalcFields("Cost Amount (Actual)");
                        LineCost := ItemLedgEntry."Cost Amount (Actual)" / ItemLedgEntry.Quantity;
                    end else begin
                        if Item.Get("No.") then
                            LineCost := Item."Unit Cost";
                    end;
                    //02.07.2008. EDMS P2 <<

                    if "Currency Code" <> '' then
                        LineSalesPrice := "Line Amount" / ServiceHeader."Currency Factor" / "Quantity (Base)"
                    else
                        LineSalesPrice := "Line Amount" / "Quantity (Base)";

                end;
        end;

        LineCost := ROUND(LineCost, 0.01, '<');
        if LineCost = 0 then
            exit;

        //Calculating Sales Price
        if ServiceHeader."Prices Including VAT" then
            LineSalesPrice := ROUND(LineSalesPrice / (1 + "VAT %" / 100), 0.00001);

        //Aprēķinam uzcenojumu
        LineMarkupPercent := 0;
        if LineCost <> 0 then
            LineMarkupPercent := (LineSalesPrice - LineCost) / LineCost * 100;

        case ActionType of
            0: //validation
                begin
                    if LineMarkupPercent < ItemMarkupRestriction."Min. Markup %" then
                        if ItemMarkupRestrictionGroup."Notification Type" = ItemMarkupRestrictionGroup."notification type"::Error then
                            Error(TextMarkupRestriced, "No.", ItemMarkupRestriction."Min. Markup %", TextPercent)
                        else
                            Message(TextMarkupRestriced, "No.", ItemMarkupRestriction."Min. Markup %", TextPercent);
                end;
            1: //release
                begin
                    if LineMarkupPercent < ItemMarkupRestriction."Min. Markup %" then
                        //22.10.2007. EDMS P2 >>
                        if ItemMarkupRestrictionGroup."Notification Type" = ItemMarkupRestrictionGroup."notification type"::Error then
                            Error(TextMarkupRestriced, "No.", ItemMarkupRestriction."Min. Markup %", TextPercent)
                        else
                            Message(TextMarkupRestriced, "No.", ItemMarkupRestriction."Min. Markup %", TextPercent);
                    //22.10.2007. EDMS P2 <<
                end;
        end;
    end;


    procedure CalcBaseQty(Qty: Decimal): Decimal
    begin
        TestField("Qty. per Unit of Measure");
        exit(ROUND(Qty * "Qty. per Unit of Measure", 0.00001));
    end;


    procedure ItemAvailability(AvailabilityType: Option Date,Variant,Location,Bin)
    var
        Item: Record Item;
        ServiceHeader: Record "Service Header EDMS";
        UserProfile: Record "Branch Profile Setup";
        SingleInstanceMgt: Codeunit SingleInstanceManagement;
        LocationCode: Code[20];
        ItemAvailByDate: Page "Item Availability by Periods";
        ItemAvailByVar: Page "Item Availability by Variant";
        ItemAvailByLoc: Page "Item Availability by Location";
        UserProfileMgt: Codeunit UserProfileManagement;
    begin
        ServiceHeader.Get("Document Type", "Document No.");

        TestField(Type, Type::Item);
        TestField("No.");
        Item.Reset;
        Item.Get("No.");
        Item.SetRange("No.", "No.");
        Item.SetRange("Date Filter", 0D, ServiceHeader."Document Date");

        //24.02.2010 EDMSB P2 >>
        LocationCode := "Location Code";
        if UserProfile.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) and (UserProfile."Def. Spare Part Location Code" <> '') then
            LocationCode := UserProfile."Def. Spare Part Location Code";
        //24.02.2010 EDMSB P2 <<

        case AvailabilityType of
            Availabilitytype::Date:
                begin
                    Item.SetRange("Variant Filter", "Variant Code");
                    Item.SetRange("Location Filter", LocationCode);
                    Clear(ItemAvailByDate);
                    ItemAvailByDate.LookupMode(true);
                    ItemAvailByDate.SetRecord(Item);
                    ItemAvailByDate.SetTableview(Item);
                    if ItemAvailByDate.RunModal = Action::LookupOK then
                        if ServiceHeader."Document Date" <> ItemAvailByDate.GetLastDate then
                            if Confirm(
                                 Text012, true, ServiceHeader.FieldCaption("Document Date"), ServiceHeader."Document Date",
                                 ItemAvailByDate.GetLastDate)
                            then begin
                                if CurrFieldNo <> 0 then
                                    xRec := Rec;
                                //serviceheader.VALIDATE("document Date",ItemAvailByDate.GetLastDate);
                            end;
                end;
            Availabilitytype::Variant:
                begin
                    Item.SetRange("Location Filter", LocationCode);
                    Clear(ItemAvailByVar);
                    ItemAvailByVar.LookupMode(true);
                    ItemAvailByVar.SetRecord(Item);
                    ItemAvailByVar.SetTableview(Item);
                    if ItemAvailByVar.RunModal = Action::LookupOK then
                        if "Variant Code" <> ItemAvailByVar.GetLastVariant then
                            if Confirm(
                                 Text012, true, FieldCaption("Variant Code"), "Variant Code",
                                 ItemAvailByVar.GetLastVariant)
                            then begin
                                if CurrFieldNo = 0 then
                                    xRec := Rec;
                                //VALIDATE("Variant Code",ItemAvailByVar.GetLastVariant);
                            end;
                end;
            Availabilitytype::Location:
                begin
                    Item.SetRange("Variant Filter", "Variant Code");
                    Clear(ItemAvailByLoc);
                    ItemAvailByLoc.LookupMode(true);
                    ItemAvailByLoc.SetRecord(Item);
                    ItemAvailByLoc.SetTableview(Item);
                    if ItemAvailByLoc.RunModal = Action::LookupOK then
                        if "Location Code" <> ItemAvailByLoc.GetLastLocation then
                            if Confirm(
                                 Text012, true, FieldCaption("Location Code"), "Location Code",
                                 ItemAvailByLoc.GetLastLocation)
                            then begin
                                if CurrFieldNo = 0 then
                                    xRec := Rec;
                                //VALIDATE("Location Code",ItemAvailByLoc.GetLastLocation);
                            end;
                end;
        end;
    end;


    procedure ShowItemSub()
    var
        ItemSubstitutionMgt: Codeunit "Item Subst.";
        ItemSubstitutionSync: Codeunit "Item Substitution Sync";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        ServiceTransferMgt: Codeunit "Service Transfer Mgt.";
    begin
        TestStatusOpen;
        //ItemSubstitutionMgt.ItemSubstGetService(Rec);
        ItemSubstitutionSync.ItemSubstGetService(Rec);
        if ServiceTransferMgt.ServCheckIfAnyExtTextEDMS(Rec, true) then
            ServiceTransferMgt.InsertServExtTextEDMS(Rec);
    end;


    procedure CheckSPackage(ChangedField: Integer; RunMode: Integer)
    var
        ServLine: Record "Service Line EDMS";
        ServicePackage: Record "Service Package";
        ConfirmText: Text[250];
    begin
        OnBeforeCheckPackage(rec, RunMode);
        //RunMode = 0, evaluated at line modify, 1 - deletion of line process;
        ServiceSetup.Get;

        if not ServiceSetup."Control Package Consistency" then
            exit;

        //IF ("Package No." <> '') AND (CurrFieldNo = ChangedField) AND (CurrFieldNo <> 0) THEN BEGIN
        if ("Package No." <> '') and ((CurrFieldNo = ChangedField) or (RunMode = 1)) then begin
            ServicePackage.Get("Package No.");
            if not ServicePackage."Fixed Prices and Discounts" then
                exit;
            case RunMode of
                0:
                    begin
                        ConfirmText := Text101;
                    end;
                1:
                    begin
                        ConfirmText := Text105;
                    end;
            end;
            if Confirm(ConfirmText, true) then begin
                ServLine.SetRange("Document Type", "Document Type");
                ServLine.SetRange("Document No.", "Document No.");
                ServLine.SetRange("Package No.", "Package No.");
                ServLine.SetRange("Package Version No.", "Package Version No.");
                ServLine.SetFilter("Line No.", '<>%1', "Line No.");
                if ServLine.FindSet then
                    repeat
                        ServLine."Package No." := '';
                        ServLine."Package Version No." := 0;
                        ServLine."Package Version Spec. Line No." := 0;
                        ServLine.Validate("Package Version Spec. Line No.");
                        ServLine.Modify
                    until ServLine.Next = 0;
                "Package No." := '';
                "Package Version No." := 0;
                "Package Version Spec. Line No." := 0;
                Modify;
                Validate("Package Version Spec. Line No.");
            end else
                Error('');
        end;
    end;


    procedure CalcVATAmountLines(QtyType: Option General,Invoicing,Shipping; var ServiceHeader: Record "Service Header EDMS"; var ServiceLine: Record "Service Line EDMS"; var VATAmountLine: Record "VAT Amount Line")
    var
        PrevVatAmountLine: Record "VAT Amount Line";
        Currency: Record Currency;
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        QtyFactor: Decimal;
        SalesSetup: Record "Sales & Receivables Setup";
        ServiceLine2: Record "Service Line EDMS";
        RoundingLineInserted: Boolean;
        TotalVATAmount: Decimal;
    begin
        if ServiceHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else
            Currency.Get(ServiceHeader."Currency Code");

        VATAmountLine.DeleteAll;

        ServiceLine.SetRange("Document Type", ServiceHeader."Document Type");
        ServiceLine.SetRange("Document No.", ServiceHeader."No.");
        ServiceLine.SetFilter(Type, '>0');
        ServiceLine.SetFilter(Quantity, '<>0');
        ServiceLine.SetRange("Prepayment Line", false);
        ServiceSetup.Get;
        if SalesSetup."Invoice Rounding" then begin
            ServiceLine2.CopyFilters(ServiceLine);
            RoundingLineInserted := ServiceLine.Count <> ServiceLine2.Count;
        end;
        ServiceLine.SetRange("Prepayment Line");
        if ServiceLine.FindSet then
            repeat
                if ServiceLine."VAT Calculation Type" in
                   [ServiceLine."vat calculation type"::"Reverse Charge VAT", ServiceLine."vat calculation type"::"Sales Tax"]
                then
                    ServiceLine."VAT %" := 0;
                if not VATAmountLine.Get(
                  ServiceLine."VAT Identifier", ServiceLine."VAT Calculation Type", ServiceLine."Tax Group Code", false, ServiceLine."Line Amount" >= 0)
                then begin
                    VATAmountLine.Init;
                    VATAmountLine."VAT Identifier" := ServiceLine."VAT Identifier";
                    VATAmountLine."VAT Calculation Type" := ServiceLine."VAT Calculation Type";
                    VATAmountLine."Tax Group Code" := ServiceLine."Tax Group Code";
                    VATAmountLine."VAT %" := ServiceLine."VAT %";
                    VATAmountLine.Modified := true;
                    VATAmountLine.Positive := ServiceLine."Line Amount" >= 0;
                    VATAmountLine.Insert;
                end;
                case QtyType of
                    Qtytype::General:
                        begin
                            VATAmountLine.Quantity := VATAmountLine.Quantity + ServiceLine."Quantity (Base)";
                            VATAmountLine."Line Amount" := VATAmountLine."Line Amount" + ServiceLine."Line Amount";
                            if ServiceLine."Allow Invoice Disc." then
                                VATAmountLine."Inv. Disc. Base Amount" :=
                                  VATAmountLine."Inv. Disc. Base Amount" + ServiceLine."Line Amount";
                            VATAmountLine."Invoice Discount Amount" :=
                              VATAmountLine."Invoice Discount Amount" + ServiceLine."Inv. Discount Amount";
                            VATAmountLine."VAT Difference" := VATAmountLine."VAT Difference" + ServiceLine."VAT Difference";

                            if ServiceLine."Prepayment Line" then
                                VATAmountLine."Includes Prepayment" := true;  //08-05-2007 EDMS P3 PREPMT

                            VATAmountLine.Modify;
                        end;
                    Qtytype::Invoicing:
                        begin
                            case true of
                                (ServiceLine."Document Type" in [ServiceLine."document type"::Order]) and
                                ServiceHeader.Invoice:
                                    begin
                                        QtyFactor := ServiceLine.Quantity / ServiceLine.Quantity;
                                        VATAmountLine.Quantity := VATAmountLine.Quantity + ServiceLine."Quantity (Base)";
                                    end;
                                (ServiceLine."Document Type" in [ServiceLine."document type"::"Return Order"]) and
                                ServiceHeader.Invoice:
                                    begin
                                        QtyFactor := ServiceLine.Quantity / ServiceLine.Quantity;
                                        VATAmountLine.Quantity :=
                                          VATAmountLine.Quantity + ServiceLine.Quantity;
                                    end;
                                else begin
                                    QtyFactor := ServiceLine.Quantity / ServiceLine.Quantity;
                                    VATAmountLine.Quantity := VATAmountLine.Quantity + ServiceLine.Quantity;
                                end;
                            end;
                            VATAmountLine."Line Amount" :=
                              VATAmountLine."Line Amount" +
                              ROUND(ServiceLine."Line Amount" * QtyFactor, Currency."Amount Rounding Precision");
                            if ServiceLine."Allow Invoice Disc." then
                                VATAmountLine."Inv. Disc. Base Amount" :=
                                  VATAmountLine."Inv. Disc. Base Amount" +
                                  ROUND(ServiceLine."Line Amount" * QtyFactor, Currency."Amount Rounding Precision");
                            VATAmountLine."Invoice Discount Amount" :=
                              VATAmountLine."Invoice Discount Amount" +
                              ROUND(ServiceLine."Inv. Discount Amount" * QtyFactor, Currency."Amount Rounding Precision");
                            VATAmountLine."VAT Difference" := VATAmountLine."VAT Difference" + ServiceLine."VAT Difference";

                            if ServiceLine."Prepayment Line" then
                                VATAmountLine."Includes Prepayment" := true;  //08-05-2007 EDMS P3 PREPMT

                            VATAmountLine.Modify;
                        end;
                end;
                if RoundingLineInserted then
                    TotalVATAmount := TotalVATAmount + ServiceLine."Amount Including VAT" - ServiceLine.Amount + ServiceLine."VAT Difference";
            until ServiceLine.Next = 0;
        ServiceLine.SetRange(Type);
        ServiceLine.SetRange(Quantity);

        if VATAmountLine.FindSet then
            repeat
                if (PrevVatAmountLine."VAT Identifier" <> VATAmountLine."VAT Identifier") or
                   (PrevVatAmountLine."VAT Calculation Type" <> VATAmountLine."VAT Calculation Type") or
                   (PrevVatAmountLine."Tax Group Code" <> VATAmountLine."Tax Group Code") or
                   (PrevVatAmountLine."Use Tax" <> VATAmountLine."Use Tax")
                then
                    PrevVatAmountLine.Init;
                if ServiceHeader."Prices Including VAT" then begin
                    case VATAmountLine."VAT Calculation Type" of
                        VATAmountLine."vat calculation type"::"Normal VAT",
                        VATAmountLine."vat calculation type"::"Reverse Charge VAT":
                            begin
                                VATAmountLine."VAT Base" :=
                                  ROUND(
                                    (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount") / (1 + VATAmountLine."VAT %" / 100),
                                    Currency."Amount Rounding Precision") - VATAmountLine."VAT Difference";
                                VATAmountLine."VAT Amount" :=
                                  VATAmountLine."VAT Difference" +
                                  ROUND(
                                    PrevVatAmountLine."VAT Amount" +
                                    (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount" - VATAmountLine."VAT Base" - VATAmountLine."VAT Difference") *
                                    (1 - ServiceHeader."VAT Base Discount %" / 100),
                                    Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                VATAmountLine."Amount Including VAT" := VATAmountLine."VAT Base" + VATAmountLine."VAT Amount";
                                if VATAmountLine.Positive then
                                    PrevVatAmountLine.Init
                                else begin
                                    PrevVatAmountLine := VATAmountLine;
                                    PrevVatAmountLine."VAT Amount" :=
                                      (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount" - VATAmountLine."VAT Base" - VATAmountLine."VAT Difference") *
                                      (1 - ServiceHeader."VAT Base Discount %" / 100);
                                    PrevVatAmountLine."VAT Amount" :=
                                      PrevVatAmountLine."VAT Amount" -
                                      ROUND(PrevVatAmountLine."VAT Amount", Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                end;
                            end;
                        VATAmountLine."vat calculation type"::"Full VAT":
                            begin
                                VATAmountLine."VAT Base" := 0;
                                VATAmountLine."VAT Amount" := VATAmountLine."VAT Difference" + VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount";
                                VATAmountLine."Amount Including VAT" := VATAmountLine."VAT Amount";
                            end;
                        VATAmountLine."vat calculation type"::"Sales Tax":
                            begin
                                VATAmountLine."Amount Including VAT" := VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount";
                                VATAmountLine."VAT Base" :=
                                  ROUND(
                                    SalesTaxCalculate.ReverseCalculateTax(
                                      ServiceHeader."Tax Area Code", VATAmountLine."Tax Group Code", ServiceHeader."Tax Liable",
                                      ServiceHeader."Posting Date", VATAmountLine."Amount Including VAT", VATAmountLine.Quantity, ServiceHeader."Currency Factor"),
                                    Currency."Amount Rounding Precision");
                                VATAmountLine."VAT Amount" := VATAmountLine."VAT Difference" + VATAmountLine."Amount Including VAT" - VATAmountLine."VAT Base";
                                if VATAmountLine."VAT Base" = 0 then
                                    VATAmountLine."VAT %" := 0
                                else
                                    VATAmountLine."VAT %" := ROUND(100 * VATAmountLine."VAT Amount" / VATAmountLine."VAT Base", 0.00001);
                            end;
                    end;
                end else begin
                    case VATAmountLine."VAT Calculation Type" of
                        VATAmountLine."vat calculation type"::"Normal VAT",
                        VATAmountLine."vat calculation type"::"Reverse Charge VAT":
                            begin
                                VATAmountLine."VAT Base" := VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount";
                                VATAmountLine."VAT Amount" :=
                                  VATAmountLine."VAT Difference" +
                                  ROUND(
                                    PrevVatAmountLine."VAT Amount" +
                                    VATAmountLine."VAT Base" * VATAmountLine."VAT %" / 100 * (1 - ServiceHeader."VAT Base Discount %" / 100),
                                    Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                VATAmountLine."Amount Including VAT" := VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount" + VATAmountLine."VAT Amount";
                                if VATAmountLine.Positive then
                                    PrevVatAmountLine.Init
                                else begin
                                    PrevVatAmountLine := VATAmountLine;
                                    PrevVatAmountLine."VAT Amount" :=
                                      VATAmountLine."VAT Base" * VATAmountLine."VAT %" / 100 * (1 - ServiceHeader."VAT Base Discount %" / 100);
                                    PrevVatAmountLine."VAT Amount" :=
                                      PrevVatAmountLine."VAT Amount" -
                                      ROUND(PrevVatAmountLine."VAT Amount", Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                end;
                            end;
                        VATAmountLine."vat calculation type"::"Full VAT":
                            begin
                                VATAmountLine."VAT Base" := 0;
                                VATAmountLine."VAT Amount" := VATAmountLine."VAT Difference" + VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount";
                                VATAmountLine."Amount Including VAT" := VATAmountLine."VAT Amount";
                            end;
                        VATAmountLine."vat calculation type"::"Sales Tax":
                            begin
                                VATAmountLine."VAT Base" := VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount";
                                VATAmountLine."VAT Amount" :=
                                  SalesTaxCalculate.CalculateTax(
                                    ServiceHeader."Tax Area Code", VATAmountLine."Tax Group Code", ServiceHeader."Tax Liable",
                                    ServiceHeader."Posting Date", VATAmountLine."VAT Base", VATAmountLine.Quantity, ServiceHeader."Currency Factor");
                                if VATAmountLine."VAT Base" = 0 then
                                    VATAmountLine."VAT %" := 0
                                else
                                    VATAmountLine."VAT %" := ROUND(100 * VATAmountLine."VAT Amount" / VATAmountLine."VAT Base", 0.00001);
                                VATAmountLine."VAT Amount" :=
                                  VATAmountLine."VAT Difference" +
                                  ROUND(VATAmountLine."VAT Amount", Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                VATAmountLine."Amount Including VAT" := VATAmountLine."VAT Base" + VATAmountLine."VAT Amount";
                            end;
                    end;
                end;
                if RoundingLineInserted then
                    TotalVATAmount := TotalVATAmount - VATAmountLine."VAT Amount";
                VATAmountLine."Calculated VAT Amount" := VATAmountLine."VAT Amount" - VATAmountLine."VAT Difference";
                VATAmountLine.Modify;
            until VATAmountLine.Next = 0;

        if RoundingLineInserted and (TotalVATAmount <> 0) then
            if VATAmountLine.Get(ServiceLine."VAT Identifier", ServiceLine."VAT Calculation Type",
                 ServiceLine."Tax Group Code", false, ServiceLine."Line Amount" >= 0)
            then begin
                VATAmountLine."VAT Amount" := VATAmountLine."VAT Amount" + TotalVATAmount;
                VATAmountLine."Amount Including VAT" := VATAmountLine."Amount Including VAT" + TotalVATAmount;
                VATAmountLine."Calculated VAT Amount" := VATAmountLine."Calculated VAT Amount" + TotalVATAmount;
                VATAmountLine.Modify;
            end;
    end;

    local procedure GetAbsMin(QtyToHandle: Decimal; QtyHandled: Decimal): Decimal
    begin
        if Abs(QtyHandled) < Abs(QtyToHandle) then
            exit(QtyHandled)
        else
            exit(QtyToHandle);
    end;


    procedure SetHasBeenShown()
    begin
        HasBeenShown := true;
    end;


    procedure UpdateVATOnLines(QtyType: Option General,Invoicing,Shipping; var ServiceHeader: Record "Service Header EDMS"; var ServiceLine: Record "Service Line EDMS"; var VATAmountLine: Record "VAT Amount Line")
    var
        TempVATAmountLineRemainder: Record "VAT Amount Line" temporary;
        Currency: Record Currency;
        RecRef: RecordRef;
        xRecRef: RecordRef;
        ChangeLogMgt: Codeunit "Change Log Management";
        NewAmount: Decimal;
        NewAmountIncludingVAT: Decimal;
        NewVATBaseAmount: Decimal;
        VATAmount: Decimal;
        VATDifference: Decimal;
        InvDiscAmount: Decimal;
        LineAmountToInvoice: Decimal;
    begin
        if QtyType = Qtytype::Shipping then
            exit;
        if ServiceHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else
            Currency.Get(ServiceHeader."Currency Code");

        TempVATAmountLineRemainder.DeleteAll;

        ServiceLine.SetRange("Document Type", ServiceHeader."Document Type");
        ServiceLine.SetRange("Document No.", ServiceHeader."No.");
        ServiceLine.SetFilter(Type, '>0');
        ServiceLine.SetFilter(Quantity, '<>0');
        ServiceLine.LockTable;
        if ServiceLine.FindSet then
            repeat
                VATAmountLine.Get(ServiceLine."VAT Identifier", ServiceLine."VAT Calculation Type", ServiceLine."Tax Group Code", false, ServiceLine."Line Amount" >= 0);
                if VATAmountLine.Modified then begin
                    xRecRef.GetTable(ServiceLine);
                    if not TempVATAmountLineRemainder.Get(
                      ServiceLine."VAT Identifier", ServiceLine."VAT Calculation Type", ServiceLine."Tax Group Code", false, ServiceLine."Line Amount" >= 0)
                    then begin
                        TempVATAmountLineRemainder := VATAmountLine;
                        TempVATAmountLineRemainder.Init;
                        TempVATAmountLineRemainder.Insert;
                    end;

                    if QtyType = Qtytype::General then
                        LineAmountToInvoice := ServiceLine."Line Amount"
                    else
                        LineAmountToInvoice :=
                          ROUND(ServiceLine."Line Amount" * ServiceLine.Quantity / ServiceLine.Quantity, Currency."Amount Rounding Precision");

                    if ServiceLine."Allow Invoice Disc." then begin
                        if VATAmountLine."Inv. Disc. Base Amount" = 0 then
                            InvDiscAmount := 0
                        else begin
                            TempVATAmountLineRemainder."Invoice Discount Amount" :=
                              TempVATAmountLineRemainder."Invoice Discount Amount" +
                              VATAmountLine."Invoice Discount Amount" * LineAmountToInvoice /
                              VATAmountLine."Inv. Disc. Base Amount";
                            InvDiscAmount :=
                              ROUND(
                                TempVATAmountLineRemainder."Invoice Discount Amount", Currency."Amount Rounding Precision");
                            TempVATAmountLineRemainder."Invoice Discount Amount" :=
                              TempVATAmountLineRemainder."Invoice Discount Amount" - InvDiscAmount;
                        end;
                        if QtyType = Qtytype::General then begin
                            ServiceLine."Inv. Discount Amount" := InvDiscAmount;
                            CalcInvDiscToInvoice;
                        end else
                            ServiceLine."Inv. Disc. Amount to Invoice" := InvDiscAmount;
                    end else
                        InvDiscAmount := 0;

                    if QtyType = Qtytype::General then
                        if ServiceHeader."Prices Including VAT" then begin
                            if (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount" = 0) or
                               (ServiceLine."Line Amount" = 0)
                            then begin
                                VATAmount := 0;
                                NewAmountIncludingVAT := 0;
                            end else begin
                                VATAmount :=
                                  TempVATAmountLineRemainder."VAT Amount" +
                                  VATAmountLine."VAT Amount" *
                                  (ServiceLine."Line Amount" - ServiceLine."Inv. Discount Amount") /
                                  (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount");
                                NewAmountIncludingVAT :=
                                  TempVATAmountLineRemainder."Amount Including VAT" +
                                  VATAmountLine."Amount Including VAT" *
                                  (ServiceLine."Line Amount" - ServiceLine."Inv. Discount Amount") /
                                  (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount");
                            end;
                            NewAmount :=
                              ROUND(NewAmountIncludingVAT, Currency."Amount Rounding Precision") -
                              ROUND(VATAmount, Currency."Amount Rounding Precision");
                            NewVATBaseAmount :=
                              ROUND(
                                NewAmount * (1 - ServiceHeader."VAT Base Discount %" / 100),
                                Currency."Amount Rounding Precision");
                        end else begin
                            if ServiceLine."VAT Calculation Type" = ServiceLine."vat calculation type"::"Full VAT" then begin
                                VATAmount := ServiceLine."Line Amount" - ServiceLine."Inv. Discount Amount";
                                NewAmount := 0;
                                NewVATBaseAmount := 0;
                            end else begin
                                NewAmount := ServiceLine."Line Amount" - ServiceLine."Inv. Discount Amount";
                                NewVATBaseAmount :=
                                  ROUND(
                                    NewAmount * (1 - ServiceHeader."VAT Base Discount %" / 100),
                                    Currency."Amount Rounding Precision");
                                if VATAmountLine."VAT Base" = 0 then
                                    VATAmount := 0
                                else
                                    VATAmount :=
                                      TempVATAmountLineRemainder."VAT Amount" +
                                      VATAmountLine."VAT Amount" * NewAmount / VATAmountLine."VAT Base";
                            end;
                            NewAmountIncludingVAT := NewAmount + ROUND(VATAmount, Currency."Amount Rounding Precision");
                        end
                    else begin
                        if (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount") = 0 then
                            VATDifference := 0
                        else
                            VATDifference :=
                              TempVATAmountLineRemainder."VAT Difference" +
                              VATAmountLine."VAT Difference" * (LineAmountToInvoice - InvDiscAmount) /
                              (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount");
                        if LineAmountToInvoice = 0 then
                            ServiceLine."VAT Difference" := 0
                        else
                            ServiceLine."VAT Difference" := ROUND(VATDifference, Currency."Amount Rounding Precision");
                    end;
                    if (QtyType = Qtytype::General) /*AND (ServiceHeader.Status = ServiceHeader.Status::Released)*/ then begin
                        ServiceLine.Amount := NewAmount;
                        ServiceLine."Amount Including VAT" := ROUND(NewAmountIncludingVAT, Currency."Amount Rounding Precision");
                        ServiceLine."VAT Base Amount" := NewVATBaseAmount;
                    end;
                    ServiceLine.InitOutstanding;
                    ServiceLine.Modify;
                    RecRef.GetTable(ServiceLine);

                    ChangeLogMgt.LogModification(RecRef);//30.10.2012 EDMS

                    TempVATAmountLineRemainder."Amount Including VAT" :=
                      NewAmountIncludingVAT - ROUND(NewAmountIncludingVAT, Currency."Amount Rounding Precision");
                    TempVATAmountLineRemainder."VAT Amount" := VATAmount - NewAmountIncludingVAT + NewAmount;
                    TempVATAmountLineRemainder."VAT Difference" := VATDifference - ServiceLine."VAT Difference";
                    TempVATAmountLineRemainder.Modify;
                end;
            until ServiceLine.Next = 0;
        ServiceLine.SetRange(Type);
        ServiceLine.SetRange(Quantity);

    end;

    local procedure CalcInvDiscToInvoice()
    var
        OldInvDiscAmtToInv: Decimal;
    begin
        GetServiceHeader;
        OldInvDiscAmtToInv := "Inv. Disc. Amount to Invoice";
        if Quantity = 0 then
            Validate("Inv. Disc. Amount to Invoice", 0)
        else
            Validate(
              "Inv. Disc. Amount to Invoice",
              ROUND(
                "Inv. Discount Amount",
                Currency."Amount Rounding Precision"));

        if OldInvDiscAmtToInv <> "Inv. Disc. Amount to Invoice" then begin
            if ServiceHeader.Status = ServiceHeader.Status::Released then
                "Amount Including VAT" := "Amount Including VAT" - "VAT Difference";
            "VAT Difference" := 0;
        end;
    end;


    procedure InitOutstanding()
    begin
        if "Document Type" in ["document type"::"Return Order"] then begin
            "Outstanding Quantity" := Quantity;
            "Outstanding Qty. (Base)" := "Quantity (Base)";
        end else begin
            "Outstanding Quantity" := Quantity;
            "Outstanding Qty. (Base)" := "Quantity (Base)";
        end;
        CalcFields("Reserved Quantity");
        Planned := "Reserved Quantity" = "Outstanding Quantity";

        InitOutstandingAmount;
    end;


    procedure InitOutstandingAmount()
    var
        AmountInclVAT: Decimal;
    begin
        if Quantity <> 0 then begin
            GetServiceHeader;
            if ServiceHeader.Status = ServiceHeader.Status::Released then
                AmountInclVAT := "Amount Including VAT"
            else
                if ServiceHeader."Prices Including VAT" then
                    AmountInclVAT := "Line Amount"
                else
                    if "VAT Calculation Type" = "vat calculation type"::"Sales Tax" then
                        AmountInclVAT :=
                          "Line Amount" - "Inv. Discount Amount" +
                          ROUND(
                            SalesTaxCalculate.CalculateTax(
                              "Tax Area Code", "Tax Group Code", "Tax Liable", ServiceHeader."Posting Date",
                              "Line Amount" - "Inv. Discount Amount", "Quantity (Base)", ServiceHeader."Currency Factor"),
                            Currency."Amount Rounding Precision")
                    else
                        AmountInclVAT :=
                          ROUND(
                            ("Line Amount" - "Inv. Discount Amount") *
                            (1 + "VAT %" / 100 * (1 - ServiceHeader."VAT Base Discount %" / 100)),
                            Currency."Amount Rounding Precision");
        end;
    end;


    procedure ShowReservation()
    var
        Reservation: Page Reservation;
    begin
        TestField(Type, Type::Item);
        TestField("No.");
        TestField(Reserve);
        Clear(Reservation);
        Reservation.SetReservSource(Rec);
        Reservation.RunModal;
    end;

    procedure GetSourceCaption(): Text
    begin
        exit(StrSubstNo('%1 %2 %3', "Document Type", "Document No.", "No."));
    end;


    procedure ShowReservationEntries(Modal: Boolean)
    begin
        TestField(Type, Type::Item);
        TestField("No.");
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry, true);
        ReserveServiceLine.FilterReservFor(ReservEntry, Rec);
        if Modal then
            Page.RunModal(Page::"Reservation Entries", ReservEntry)
        else
            Page.Run(Page::"Reservation Entries", ReservEntry);
    end;


    procedure AutoReserve()
    var
        Location: Record Location;
        HideResMsg: Boolean;
    begin
        TestField(Type, Type::Item);
        TestField("No.");

        if ReserveServiceLine.ReservQuantity(Rec) <> 0 then begin
            //ReservMgt.SetServLineEDMS(Rec);
            ReservationMgtEDMS.SetReservSource(Rec);
            ReservationMgtEDMS.AutoReserve(FullAutoReservation, '', "Planned Service Date", ReserveServiceLine.ReservQuantity(Rec),
            0); //30.10.2012 EDMS
            Find;
            if not FullAutoReservation then begin
                Commit;
                if Rec."Location Code" <> '' then begin
                    Location.get(Rec."Location Code");
                    if Location."Hide Automatic Serv. Res. Msg." then
                        HideResMsg := true;
                end;
                if not HideResMsg then
                    if Confirm(Text011, true) then begin
                        ShowReservation;
                        Find;
                    end;
            end;
        end;
    end;


    procedure ItemExists(ItemNo: Code[20]): Boolean
    var
        Item2: Record Item;
    begin
        if Type = Type::Item then
            if not Item2.Get(ItemNo) then
                exit(false);
        exit(true);
    end;


    procedure OpenItemTrackingLines()
    var
        Job: Record Job;
    begin
        TestField(Type, Type::Item);
        TestField("No.");
        TestField("Quantity (Base)");
        ReserveServiceLine.CallItemTracking(Rec);
    end;


    procedure SuspendStatusCheck(Suspend: Boolean)
    begin
        StatusCheckSuspended := Suspend;
    end;


    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Service Line EDMS", intFieldNo));
    end;


    procedure CheckDiscount()
    var
        SalesDiscount: Record "SP Sales Disc. Group Items";
        Ishandled: Boolean;
        errorexit: Boolean;
    begin
        if not (Type in [Type::Item, Type::Labor]) then
            exit;
        errorexit := true;
        if UserSetup.Get(UserId) then begin
            if UserSetup."SP Sales Disc. Group Code" <> '' then begin
                SalesDiscount.Reset;
                SalesDiscount.SetRange("Sales Disc. Group Code", UserSetup."SP Sales Disc. Group Code");
                if Type = Type::Labor then begin
                    SalesDiscount.SetRange(Type, SalesDiscount.Type::Labor);
                    OnbeforefilterCheckDiscount(rec, SalesDiscount, Ishandled);
                    if not Ishandled then
                        SalesDiscount.SetFilter("No.", '%1|%2', '', "No.");
                end;
                if Type = Type::Item then begin
                    SalesDiscount.SetRange(Type, SalesDiscount.Type::"Item Category");
                    OnbeforefilterCheckDiscount(rec, SalesDiscount, Ishandled);
                    if not Ishandled then
                        SalesDiscount.SetFilter("No.", '%1|%2', '', "Item Category Code");
                end;
                if SalesDiscount.FindLast then begin
                    OnbeforeCheckDiscount(rec, SalesDiscount, errorexit);
                    if errorexit then
                        if "Line Discount %" > SalesDiscount."Max. Discount %" then
                            Error(Text102, FieldCaption("Line Discount %"), SalesDiscount."Max. Discount %");
                end;
            end;
        end;
    end;


    procedure GetDescriptionFromLaborText(LaborNo: Code[20]; VehicleSerialNo: Code[20])
    var
        VariableFieldUsage: Record "Variable Field Usage";
        ServLaborText: Record "Service Labor Text";
        VehicleLoc: Record Vehicle;
        VariableValue: Text[30];
    begin
        ServLaborText.Reset;
        ServLaborText.SetRange("Service Labor No.", LaborNo);

        if not VehicleLoc.Get(VehicleSerialNo) then
            exit;

        VariableFieldUsage.Reset;
        VariableFieldUsage.SetRange("Table No.", Database::"Service Labor Text");
        VariableFieldUsage.SetRange("Field No.", 25006800);
        if VariableFieldUsage.FindFirst then begin
            VariableValue := GetVariableValue(VehicleLoc, VariableFieldUsage."Variable Field Code");
            if VariableValue <> '' then
                ServLaborText.SetRange("Variable Field 25006800", VariableValue);
        end;

        VariableFieldUsage.SetRange("Field No.", 25006801);
        if VariableFieldUsage.FindFirst then begin
            VariableValue := GetVariableValue(VehicleLoc, VariableFieldUsage."Variable Field Code");
            if VariableValue <> '' then
                ServLaborText.SetRange("Variable Field 25006801", VariableValue);
        end;

        if ServLaborText.FindFirst then begin
            Description := ServLaborText.Description;
            "Description 2" := ServLaborText."Description 2";
        end;
    end;


    procedure GetVehicleVariableFields(VehicleSerialNo: Code[20])
    var
        VariableFieldUsage: Record "Variable Field Usage";
        VariableFieldUsage2: Record "Variable Field Usage";
        VehicleLoc: Record Vehicle;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
        VariableValue: Text[30];
    begin
        if not VehicleLoc.Get(VehicleSerialNo) then
            exit;
        VariableFieldUsage.Reset;
        VariableFieldUsage.SetRange("Table No.", Database::"Service Line EDMS");
        if VariableFieldUsage.FindFirst then begin
            repeat
                VariableValue := GetVariableValue(VehicleLoc, VariableFieldUsage."Variable Field Code");
                if VariableValue <> '' then begin
                    case VariableFieldUsage."Field No." of
                        25006800:
                            "Variable Field 25006800" := VariableValue;
                        25006801:
                            "Variable Field 25006801" := VariableValue;
                        25006802:
                            "Variable Field 25006802" := VariableValue;
                    end;
                end;
            until VariableFieldUsage.Next = 0;
        end;
    end;


    procedure GetVariableValue(Vehicle: Record Vehicle; "Field": Text[30]) FieldValue: Text[30]
    var
        RecordRef1: RecordRef;
        FieldRef1: FieldRef;
        VariableFieldUsage: Record "Variable Field Usage";
    begin
        FieldValue := '';

        if Field = '' then
            exit;

        RecordRef1.Open(Database::Vehicle);
        RecordRef1.GetTable(Vehicle);
        VariableFieldUsage.Reset;
        VariableFieldUsage.SetCurrentkey("Variable Field Code");
        VariableFieldUsage.SetRange("Table No.", Database::Vehicle);
        VariableFieldUsage.SetRange("Variable Field Code", Field);

        if VariableFieldUsage.FindFirst then begin
            FieldRef1 := RecordRef1.Field(VariableFieldUsage."Field No.");
            FieldValue := FieldRef1.Value;
        end;
        RecordRef1.SetTable(Vehicle);
    end;


    procedure FullyReservedToInventory(): Boolean
    var
        ReservEntry: Record "Reservation Entry";
        ReservEntry2: Record "Reservation Entry";
    begin
        if Quantity = 0 then
            exit(false);

        CalcFields("Reserved Quantity");
        if "Reserved Quantity" <> Quantity then
            exit(false);

        ReservEntry.Reset;
        ReservEntry.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type");
        ReservEntry.SetRange("Source ID", "Document No.");
        ReservEntry.SetRange("Source Ref. No.", "Line No.");
        ReservEntry.SetRange("Source Type", Database::"Service Line EDMS");
        ReservEntry.SetRange("Source Subtype", "Document Type");
        if ReservEntry.FindFirst then
            repeat
                if not ReservEntry2.Get(ReservEntry."Entry No.", not ReservEntry.Positive) then
                    exit(false);
                if ReservEntry2."Source Type" <> Database::"Item Ledger Entry" then
                    exit(false);
            until ReservEntry.Next = 0;

        exit(true);
    end;


    procedure RegLostSales()
    var
        LostSalesRegItem: Page "Register Item Lost Sale";
    begin
        Clear(LostSalesRegItem);
        if Type = Type::Item then
            LostSalesRegItem.SetItem("No.");
        LostSalesRegItem.SetCustomer("Sell-to Customer No.");
        LostSalesRegItem.SetLocationCode("Location Code");
        LostSalesRegItem.LookupMode(TRUE);
        LostSalesRegItem.RunModal();
    end;


    procedure MoveLines(var ServiceLineRec: Record "Service Line EDMS")
    var
        EDMS001: label '%1 lines will be processed.\Do you want to proceed?';
    begin
        TestStatusOpen;
        if ServiceLineRec.Count = 0 then
            exit;

        if Confirm(EDMS001, false, ServiceLineRec.Count) then
            Report.RunModal(Report::"Service Order-Move Line", true, false, ServiceLineRec);
    end;


    procedure SplitLine(var ServiceLine: Record "Service Line EDMS")
    begin
        TestStatusOpen;
        Report.RunModal(Report::"Split Service Line", true, false, ServiceLine);
    end;


    procedure CalcTransferedQuantity() TransfQty: Decimal
    var
        ResEntry: Record "Reservation Entry";
    begin
        FilterTransferedResEntries(ResEntry);
        if ResEntry.FindFirst then
            repeat
                TransfQty += -ResEntry.Quantity;
            until ResEntry.Next = 0;
    end;


    procedure ShowTransferedQuantity()
    var
        ResEntry: Record "Reservation Entry";
    begin
        FilterTransferedResEntries(ResEntry);
        if Page.RunModal(Page::"Reservation Entries", ResEntry) = Action::OK then;
    end;


    procedure FilterTransferedResEntries(var ResEntryNegative: Record "Reservation Entry")
    var
        ResEntryPositive: Record "Reservation Entry";
    begin
        ResEntryNegative.Reset;
        ResEntryNegative.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
        ResEntryNegative.SetRange("Source ID", "Document No.");
        ResEntryNegative.SetRange("Source Ref. No.", "Line No.");
        ResEntryNegative.SetRange("Source Type", Database::"Service Line EDMS");
        ResEntryNegative.SetRange("Source Subtype", "Document Type");
        if ResEntryNegative.FindFirst then
            repeat
                if ResEntryPositive.Get(ResEntryNegative."Entry No.", true) then
                    if ResEntryPositive."Source Type" = Database::"Item Ledger Entry" then
                        ResEntryNegative.Mark(true);
            until ResEntryNegative.Next = 0;
        ResEntryNegative.MarkedOnly(true);
    end;


    procedure FilterOutboundTransferRes(var FilteredResEntry: Record "Reservation Entry")
    var
        ResEntryPositive: Record "Reservation Entry";
        ResEntryNegative: Record "Reservation Entry";
        ResEntryTransferOutg: Record "Reservation Entry";
    begin
        ResEntryNegative.Reset;
        ResEntryNegative.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
        ResEntryNegative.SetRange("Source ID", "Document No.");
        ResEntryNegative.SetRange("Source Ref. No.", "Line No.");
        ResEntryNegative.SetRange("Source Type", Database::"Service Line EDMS");
        ResEntryNegative.SetRange("Source Subtype", "Document Type");
        if ResEntryNegative.FindFirst then
            repeat
                if ResEntryPositive.Get(ResEntryNegative."Entry No.", true) then
                    if ResEntryPositive."Source Type" = Database::"Transfer Line" then begin
                        ResEntryTransferOutg.Reset;
                        ResEntryTransferOutg.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
                        ResEntryTransferOutg.SetRange("Source ID", ResEntryPositive."Source ID");
                        ResEntryTransferOutg.SetRange("Source Ref. No.", ResEntryPositive."Source Ref. No.");
                        ResEntryTransferOutg.SetRange("Source Type", ResEntryPositive."Source Type");
                        ResEntryTransferOutg.SetRange("Source Subtype", 0);
                        ResEntryTransferOutg.SetRange("Reservation Status", ResEntryTransferOutg."reservation status"::Reservation);
                        if ResEntryTransferOutg.FindFirst then
                            repeat
                                FilteredResEntry.Get(ResEntryTransferOutg."Entry No.", ResEntryTransferOutg.Positive);
                                FilteredResEntry.Mark(true);
                            until ResEntryTransferOutg.Next = 0;
                    end;
            until ResEntryNegative.Next = 0;
        FilteredResEntry.MarkedOnly(true)
    end;


    procedure ShowOutboundTransferRes()
    var
        ResEntry: Record "Reservation Entry";
    begin
        FilterOutboundTransferRes(ResEntry);
        if Page.RunModal(Page::"Reservation Entries", ResEntry) = Action::OK then;
    end;


    procedure CalcOutboundTransferRes() TransfQty: Decimal
    var
        ResEntry: Record "Reservation Entry";
    begin
        FilterOutboundTransferRes(ResEntry);
        if ResEntry.FindFirst then
            repeat
                TransfQty += -ResEntry.Quantity;
            until ResEntry.Next = 0;
    end;


    procedure AutoReserveToILE(QtyToReserve: Decimal)
    begin
        //EDMS function
        TestField(Type, Type::Item);
        TestField("No.");

        if QtyToReserve <> 0 then begin
            //ReservMgt.SetServLineEDMS(Rec);
            ReservationMgtEDMS.SetReservSource(Rec);
            ReservationMgtEDMS.SetSpecSummEntryNo(1); //Limitation to Item Ledger Entries only
            ReservationMgtEDMS.AutoReserve(FullAutoReservation, '', Rec."Planned Service Date", QtyToReserve,
            QtyToReserve);//30.10.2012 EDMS
            Find;
        end;
    end;


    procedure CheckReservationCancelation()
    var
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        Text001: label 'Deletion of Service Line will cancel exiting reservations. Do you want to proceed?';
        Text002: label 'Service Line deletion is interrupted';
        TransferedQty: Decimal;
        Text003: label 'You cannot delete a Service Line where Transferred Quantity is not 0';
    begin
        TransferedQty := CalcTransferedQuantity;
        if TransferedQty = 0 then
            exit;
        ServiceSetup.Get;
        case ServiceSetup."Check Transfered Qty.On Delete" of
            ServiceSetup."check transfered qty.on delete"::No:
                exit;
            ServiceSetup."check transfered qty.on delete"::Confirm:
                if not Confirm(Text001, false) then
                    Error(Text002);
            ServiceSetup."check transfered qty.on delete"::Restrict:
                Error(Text003);
        end;
    end;


    procedure GetTimeQty() RetValue: Decimal
    begin
        //returns hours
        if "Quantity (Hours)" > 0 then
            RetValue := "Quantity (Hours)"
        else begin
        end;
        exit(RetValue);
    end;


    procedure SetTimeQty(Qty: Decimal; ValidatePar: Boolean; RecalcMainQty: Boolean) RetValue: Integer
    begin
        //returns STATUS: 0 means OK
        if "Minutes Per UoM" = 0 then begin
            Quantity := Qty;
            if ValidatePar then
                Validate(Quantity);
        end else begin
            "Quantity (Hours)" := Qty;
            if ValidatePar then begin
                if RecalcMainQty then
                    Quantity := 0;
                Validate("Quantity (Hours)");
            end;
        end;
        exit(0);
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        //31.03.2014 Elva Baltic P18 MMG7.00 >>
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        //31.03.2014 Elva Baltic P18 MMG7.00 <<
    end;


    procedure CheckAssocPurchOrder(TheFieldCaption: Text[250])
    begin
        if TheFieldCaption = '' then begin // If line is being deleted
            if "Purch. Order Line No." <> 0 then
                Error(
                  Text000,
                  "Purchase Order No.",
                  "Purch. Order Line No.");
            if "Special Order Purch. Line No." <> 0 then
                Error(
                  Text000,
                  "Special Order Purchase No.",
                  "Special Order Purch. Line No.");
        end;
        if "Purch. Order Line No." <> 0 then
            Error(
              Text002,
              TheFieldCaption,
              "Purchase Order No.",
              "Purch. Order Line No.");
        if "Special Order Purch. Line No." <> 0 then
            Error(
              Text002,
              TheFieldCaption,
              "Special Order Purchase No.",
              "Special Order Purch. Line No.");
    end;


    procedure UpdateDates()
    begin
        if CurrFieldNo = 0 then begin
            PlannedShipmentDateCalculated := false;
            PlannedDeliveryDateCalculated := false;
        end;
        if "Promised Delivery Date" <> 0D then
            Validate("Promised Delivery Date")
        else
            if "Requested Delivery Date" <> 0D then
                Validate("Requested Delivery Date")
            else begin
                Validate("Shipment Date");
                Validate("Planned Delivery Date");
            end;
    end;


    procedure RowID1(): Text[250]
    var
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    begin
        exit(ItemTrackingMgt.ComposeRowID(Database::"Service Line EDMS", "Document Type",
            "Document No.", '', 0, "Line No."));
    end;

    local procedure CheckItemAvailable(CalledByFieldNo: Integer)
    begin
    end;


    procedure "--SERVICE RESOURCES--"()
    begin
    end;


    procedure SetResourceTextFieldValue(TextValue: Text)
    begin
        if not ResourceTextFieldModified then
            ResourceTextFieldModified := (ResourceTextFieldValue <> TextValue);
        ResourceTextFieldValue := TextValue;
        SaveRelatedResourcesToDB(0);
    end;


    procedure GetResourceTextFieldValue(): Text
    var
        NewValueFromDB: Text;
    begin
        //ServiceScheduleMgt.SetRelatedResources("Document Type", "Document No.", Type, "Line No.", Resources, 0);
        //Resources := ServiceScheduleMgt.GetRelatedResources("Document Type", "Document No.", Type, "Line No.", 0);
        if (ServiceLinePrevParcedRsc."Line No." <> "Line No.") or (ServiceLinePrevParcedRsc."Document Type" <> "Document Type") or
            (ServiceLinePrevParcedRsc."Document No." <> "Document No.") then begin
            ResourceTextFieldModified := false;
            ServiceLinePrevParcedRsc.TransferFields(Rec);
            NewValueFromDB := GetRelatedResourcesFromDB(0);
            if "Line No." > 0 then
                ResourceTextFieldValue := NewValueFromDB
            else begin
                if ResourceTextFieldValue = '' then
                    ResourceTextFieldValue := NewValueFromDB;
            end;

        end;
        exit(ResourceTextFieldValue);
    end;


    procedure GetRelatedResourcesFromDB(RunMode: Integer) RetValue: Text
    var
        ServLaborApplication: Record "Serv. Labor Alloc. Application";
        ServiceLine: Record "Service Line EDMS";
        isItDocAllocation: Boolean;
        StatusArray: array[10] of Integer;
        isTempTableUse: Boolean;
    begin
        RetValue := '';
        if (Type = Type::Labor) and ("Line No." > 0) then begin
            ServLaborApplicationGlobTmp.Reset;
            ServLaborApplicationGlobTmp.DeleteAll;
            ServLaborApplication.Reset;
            ServLaborApplication.SetRange("Document Type", "Document Type");
            ServLaborApplication.SetRange("Document No.", "Document No.");
            ServLaborApplication.SetRange("Document Line No.", "Line No.");
            if ServLaborApplication.FindFirst then begin
                repeat
                    ServLaborApplicationGlobTmp.SetRange("Resource No.", ServLaborApplication."Resource No.");
                    if not ServLaborApplicationGlobTmp.FindLast then begin
                        if (StrLen(RetValue) + StrLen(ServLaborApplication."Resource No." + ',') <= MaxStrLen(RetValue)) then
                            RetValue += ServLaborApplication."Resource No." + ',';
                        ServLaborApplicationGlobTmp.Init;
                        ServLaborApplicationGlobTmp.TransferFields(ServLaborApplication);
                        ServLaborApplicationGlobTmp.Insert;
                    end;
                until ServLaborApplication.Next = 0;
                if StrLen(RetValue) > 1 then
                    RetValue := CopyStr(RetValue, 1, StrLen(RetValue) - 1);
            end;
        end;
        exit(RetValue);
    end;


    procedure SetRelatedResources(RecourcesTextSource: Text; RunMode: Integer) ResourcesCount: Integer
    var
        ServLaborApplication: Record "Serv. Labor Alloc. Application";
        Posit: Integer;
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        ResourceToAdd: Text[30];
        Resource: Record Resource;
        RecourcesText: Text;
        RecourcesTextToModify: Text;
        AllocEntryNo: Integer;
        isItDocAllocation: Boolean;
        divResult: Integer;
        isItAllowedMessage: Boolean;
        ServiceLine: Record "Service Line EDMS";
        StatusArray: array[10] of Integer;
        LineNo: Integer;
    begin
        //RunMode = 0 - normal; 1 - no messages; second digit (tens) - is it document allocation
        // THAT FUNCTION SAVE IT ONLY INTO TEMPORARY TABLE
        // for now it stores only resources uniquely (one certain resource - one line)
        ServiceSetup.Get;
        AdjustFlagsToArray(RunMode, StatusArray);
        isItAllowedMessage := (StatusArray[1] = 1);
        isItDocAllocation := (StatusArray[2] = 1);

        RecourcesText := RecourcesTextSource;
        ResourcesCount := 0;
        if (Type = Type::Labor) then begin
            //Allocation Entry No.,Document Type,Document No.,Line No.
            ServLaborApplicationGlobTmp.Reset;
            ServLaborApplicationGlobTmp.DeleteAll;
            repeat
                Posit := StrPos(RecourcesText, ',');
                if Posit > 0 then begin
                    ResourceToAdd := CopyStr(RecourcesText, 1, Posit - 1);
                    RecourcesText := CopyStr(RecourcesText, Posit + 1, StrLen(RecourcesText) - Posit);
                end else begin
                    ResourceToAdd := RecourcesText;
                    RecourcesText := '';
                end;
                if Resource.Get(ResourceToAdd) then begin
                    ServLaborApplicationGlobTmp.SetRange("Resource No.", ResourceToAdd);
                    if not ServLaborApplicationGlobTmp.FindLast then begin
                        Resource.TestField(Blocked, false);
                        LineNo := 0;
                        ServLaborApplicationGlobTmp.Reset;
                        if ServLaborApplicationGlobTmp.FindLast then
                            LineNo := ServLaborApplicationGlobTmp."Line No.";
                        ServLaborApplicationGlobTmp.Init;
                        ServLaborApplicationGlobTmp."Allocation Entry No." := 0;
                        ServLaborApplicationGlobTmp."Document Type" := "Document Type";
                        ServLaborApplicationGlobTmp."Document No." := "Document No.";
                        ServLaborApplicationGlobTmp."Document Line No." := "Line No.";
                        ServLaborApplicationGlobTmp."Resource No." := ResourceToAdd;
                        ServLaborApplicationGlobTmp."Line No." := LineNo + 10000;
                        ServLaborApplicationGlobTmp.Insert;
                    end;
                end;
            until RecourcesText = '';
            ServLaborApplicationGlobTmp.SetRange("Resource No.");
        end;
        exit(ServLaborApplicationGlobTmp.Count);
    end;


    procedure SaveRelatedResourcesToDB(RunMode: Integer) ResourcesCount: Integer
    var
        ServLaborApplication: Record "Serv. Labor Alloc. Application";
        ServLaborAllocationEntryLoc: Record "Serv. Labor Allocation Entry";
        ServiceScheduleMgt: Codeunit "Service Schedule Mgt.";
        Posit: Integer;
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        ResourceToAdd: Text[30];
        Resource: Record Resource;
        RecourcesTextToModify: Text;
        AllocEntryNo: Integer;
        isItDocAllocation: Boolean;
        divResult: Integer;
        isItAllowedMessage: Boolean;
        ServiceLine: Record "Service Line EDMS";
        isFound: Boolean;
    begin
        //RunMode = 0 - normal; 1 - no messages; second digit (tens) - is it document allocation
        ResourcesCount := 0;
        if (Type = Type::Labor) and (ResourceTextFieldModified) and ("Line No." > 0) then begin

            SetRelatedResources(ResourceTextFieldValue, 0);

            ServLaborApplication.Reset;
            ServLaborApplication.SetRange("Document Type", "Document Type");
            ServLaborApplication.SetRange("Document No.", "Document No.");
            if ServLaborApplicationGlobTmp.FindFirst then begin
                repeat
                    if Resource.Get(ServLaborApplicationGlobTmp."Resource No.") then begin
                        ServLaborApplication.SetRange("Document Line No.", "Line No.");
                        ServLaborApplication.SetRange("Resource No.", ServLaborApplicationGlobTmp."Resource No.");
                        isFound := ServLaborApplication.FindLast;
                        if not isFound then begin
                            Resource.TestField(Blocked, false);

                            ServLaborApplication.Init;
                            ServLaborApplication."Allocation Entry No." := 0;
                            ServLaborApplication."Document Type" := "Document Type";
                            ServLaborApplication."Document No." := "Document No.";
                            ServLaborApplication."Document Line No." := "Line No.";
                            ServLaborApplication."Resource No." := ServLaborApplicationGlobTmp."Resource No.";
                            ServLaborApplication.Insert(true);
                        end;
                    end;
                until ServLaborApplicationGlobTmp.Next = 0;
            end;
            ServLaborApplication.SetRange("Document Line No.", "Line No.");
            ServLaborApplication.SetRange("Resource No.");
            ServLaborApplicationGlobTmp.Reset;
            // here get remove unneed records
            if ServLaborApplication.FindFirst then
                repeat
                    ServLaborApplicationGlobTmp.SetRange("Resource No.", ServLaborApplication."Resource No.");
                    if not ServLaborApplicationGlobTmp.FindLast then
                        if not ServLaborAllocationEntryLoc.Get(ServLaborApplication."Allocation Entry No.") then begin
                            ServLaborApplication.Delete(true);
                            if ServLaborApplication.FindFirst then;
                        end else begin
                            // MESSAGE('IT is not allowed to delete allocated records');
                        end;
                until ServLaborApplication.Next = 0;
            if ServLaborApplication.FindFirst then begin
                ServLaborApplicationGlobTmp.SetRange("Resource No.", ServLaborApplication."Resource No.");
                if not ServLaborApplicationGlobTmp.FindLast then
                    if not ServLaborAllocationEntryLoc.Get(ServLaborApplication."Allocation Entry No.") then
                        ServLaborApplication.Delete(true);
            end;

            //ServiceScheduleMgt.RemoveDuplicates(ServLaborApplication);

        end;
        Clear(ResourceTextFieldModified);
        Clear(ServiceLinePrevParcedRsc);
        exit(ServLaborApplication.Count);
    end;


    procedure RelatedResourcesList(var RelatedResources: Text)
    var
        ServLaborAllocApplication: Record "Serv. Labor Alloc. Application";
    begin
        Commit;
        ServLaborAllocApplication.Reset;
        ServLaborAllocApplication.SetRange("Document Type", "Document Type");
        ServLaborAllocApplication.SetRange("Document No.", "Document No.");
        ServLaborAllocApplication.SetRange("Document Line No.", "Line No.");
        if (Type = Type::Labor) and ("Line No." > 0) then
            Page.RunModal(Page::"Service Line Resources", ServLaborAllocApplication);
        RelatedResources := GetRelatedResourcesFromDB(0);
        SetResourceTextFieldValue(RelatedResources);
    end;


    procedure DeleteResourcesOfLine()
    var
        ServLaborAllocApplication: Record "Serv. Labor Alloc. Application";
    begin
        ServLaborAllocApplication.Reset;
        ServLaborAllocApplication.SetRange("Document Type", "Document Type");
        ServLaborAllocApplication.SetRange("Document No.", "Document No.");
        ServLaborAllocApplication.SetRange("Document Line No.", "Line No.");
        if "Line No." > 0 then
            ServLaborAllocApplication.DeleteAll(true);
    end;


    procedure "--SMALL TECHN--"()
    begin
    end;


    procedure CutNextDigit(var Flags: Integer) RetValue: Integer
    begin
        RetValue := Flags MOD 10;
        Flags := Flags DIV 10;
        exit(RetValue);
    end;


    procedure AdjustFlagsToArray(Flags: Integer; var ArrayEDMS: array[10] of Integer)
    var
        i: Integer;
    begin
        for i := 1 to 10 do begin
            if (CutNextDigit(Flags) > 0) then
                ArrayEDMS[i] := i - 1
            else
                ArrayEDMS[i] := -1;
        end;
    end;


    procedure IsIntInArrayTen(CheckValue: Integer; var ArrayEDMS: array[10] of Integer) RetValue: Boolean
    var
        i: Integer;
    begin
        for i := 1 to 10 do begin
            if (CheckValue = ArrayEDMS[i]) then
                RetValue := true;
        end;

        exit(RetValue);
    end;


    procedure GetReservationColor(): Text[20]
    var
        ResEntry: Record "Reservation Entry";
        CheckItem: Record Item;
    begin
        // 19.03.2014 Elva Baltic P21 >>
        if (Type <> Type::Item) or ("No." = '') then
            exit('None');

        if CheckItem.Get(Rec."No.") then
            if CheckItem.Type <> CheckItem.Type::Inventory then
                exit('None');

        if CalcTransferedQuantity = Quantity then
            exit('None');
        // 19.03.2014 Elva Baltic P21 <<

        FilterTransferRes(ResEntry);

        if ResEntry.IsEmpty then
            exit('Unfavorable');

        ResEntry.SetRange("Source Type", 246);
        if ResEntry.FindFirst then
            exit('StrongAccent');

        ResEntry.SetFilter("Source Type", '%1|%2', 39, 5741);
        if ResEntry.FindFirst then
            exit('Ambiguous');

        ResEntry.SetRange("Source Type", 32);
        if ResEntry.FindFirst then
            exit('Favorable');
    end;


    procedure FilterTransferRes(var FilteredResEntry: Record "Reservation Entry")
    var
        ResEntryPositive: Record "Reservation Entry";
        ResEntryNegative: Record "Reservation Entry";
        ResEntryTransferOutg: Record "Reservation Entry";
    begin
        ResEntryNegative.Reset;
        ResEntryNegative.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
        ResEntryNegative.SetRange("Source ID", "Document No.");
        ResEntryNegative.SetRange("Source Ref. No.", "Line No.");
        ResEntryNegative.SetRange("Source Type", Database::"Service Line EDMS");
        ResEntryNegative.SetRange("Source Subtype", "Document Type");
        if ResEntryNegative.FindFirst then
            repeat
                if ResEntryPositive.Get(ResEntryNegative."Entry No.", true) then
                    if ResEntryPositive."Source Type" = Database::"Transfer Line" then begin
                        ResEntryTransferOutg.Reset;
                        ResEntryTransferOutg.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
                        ResEntryTransferOutg.SetRange("Source ID", ResEntryPositive."Source ID");
                        ResEntryTransferOutg.SetRange("Source Ref. No.", ResEntryPositive."Source Ref. No.");
                        ResEntryTransferOutg.SetRange("Source Type", ResEntryPositive."Source Type");
                        ResEntryTransferOutg.SetRange("Source Subtype", 0);
                        ResEntryTransferOutg.SetRange("Reservation Status", ResEntryTransferOutg."reservation status"::Reservation);
                        if ResEntryTransferOutg.FindFirst then
                            repeat
                                FilteredResEntry.Get(ResEntryTransferOutg."Entry No.", true);
                                FilteredResEntry.Mark(true);
                            until ResEntryTransferOutg.Next = 0;
                    end;
            until ResEntryNegative.Next = 0;
        FilteredResEntry.MarkedOnly(true)
    end;


    procedure DeleteAssignedTransfLine()
    var
        TransferLine: Record "Transfer Line";
    begin
        if ServiceTransferMgt.FindTransferLine(Rec, TransferLine) then begin
            if Confirm(Text123, false, TransferLine.FieldCaption("Document No."), TransferLine."Document No.",
                       TransferLine.FieldCaption("Line No."), TransferLine."Line No.") then
                ServiceTransferMgt.DeleteTransferLine(Rec)
            else
                Error(Text124);
        end;
    end;

    local procedure CheckApplFromItemLedgEntry(var ItemLedgEntry: Record "Item Ledger Entry")
    var
        ItemTrackingLines: Page "Item Tracking Lines";
        QtyBase: Decimal;
        QtyNotReturned: Decimal;
        QtyReturned: Decimal;
    begin
        if "Appl.-from Item Entry" = 0 then
            exit;

        // IF "Shipment No." <> '' THEN
        //   EXIT;

        TestField(Type, Type::Item);
        TestField(Quantity);
        if "Document Type" in ["document type"::"Return Order"] then begin
            if Quantity < 0 then
                FieldError(Quantity, Text029);
        end else begin
            if Quantity > 0 then
                FieldError(Quantity, Text030);
        end;

        ItemLedgEntry.Get("Appl.-from Item Entry");
        ItemLedgEntry.TestField(Positive, false);
        ItemLedgEntry.TestField("Item No.", "No.");
        ItemLedgEntry.TestField("Variant Code", "Variant Code");
        // IF NOT (("Line Type" = "Line Type"::Vehicle) AND (Quantity = 1)) THEN //29.08.2013 EDMS P8
        if (ItemLedgEntry."Lot No." <> '') or (ItemLedgEntry."Serial No." <> '') then
            Error(Text040, ItemTrackingLines.Caption, FieldCaption("Appl.-from Item Entry"));

        case true of
            CurrFieldNo = FieldNo(Quantity):
                QtyBase := "Quantity (Base)";
        /*
        "Document Type" IN ["Document Type"::"Return Order"]:
          QtyBase := "Return Qty. to Receive (Base)"
        ELSE
          QtyBase := "Qty. to Ship (Base)";
        */
        end;

        if Abs(QtyBase) > -ItemLedgEntry.Quantity then
            Error(
              Text046,
              -ItemLedgEntry.Quantity, ItemLedgEntry.FieldCaption("Document No."),
              ItemLedgEntry."Document No.");

        if Abs(QtyBase) > -ItemLedgEntry."Shipped Qty. Not Returned" then begin
            if "Qty. per Unit of Measure" = 0 then begin
                QtyNotReturned := ItemLedgEntry."Shipped Qty. Not Returned";
                QtyReturned := ItemLedgEntry.Quantity - ItemLedgEntry."Shipped Qty. Not Returned";
            end else begin
                QtyNotReturned :=
                  ROUND(ItemLedgEntry."Shipped Qty. Not Returned" / "Qty. per Unit of Measure", 0.00001);
                QtyReturned :=
                  ROUND(
                    (ItemLedgEntry.Quantity - ItemLedgEntry."Shipped Qty. Not Returned") /
                    "Qty. per Unit of Measure", 0.00001);
            end;
            Error(
              Text039,
              -QtyReturned, ItemLedgEntry.FieldCaption("Document No."),
              ItemLedgEntry."Document No.", -QtyNotReturned);
        end;

    end;


    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        //31.03.2014 Elva Baltic P18 MMG7.00 >>
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
        //31.03.2014 Elva Baltic P18 MMG7.00 <<
    end;


    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    local procedure GetTire()
    var
        TireManagementSetup: Record "Tire Management Setup";
    begin
        Tire.Reset;
        if "Tire Operation Type" in ["tire operation type"::"Take off", "tire operation type"::"Position Change"] then begin
            Tire.SetRange("Current Vehicle Serial No.", "Vehicle Serial No.");
        end else begin
            TireManagementSetup.Get;
            if TireManagementSetup."Check Tire Unique" then begin
                Tire.SetRange(Available, true);
            end;
        end;
    end;

    local procedure FillTireFields(TireChanged: Record Tire)
    var
        TireEntry: Record "Tire Entry";
    begin
        if "Tire Operation Type" in ["tire operation type"::"Take off", "tire operation type"::"Position Change"] then begin
            TireEntry.Reset;
            TireEntry.SetRange("Vehicle Serial No.", "Vehicle Serial No.");
            if "Tire Code" <> '' then
                TireEntry.SetRange("Tire Code", TireChanged.Code);
            if "Tire Position Code" <> '' then
                TireEntry.SetRange("Tire Position Code", "Tire Position Code");
            TireEntry.SetRange(Open, true);
            TireEntry.SetRange("Entry Type", TireEntry."entry type"::"Put on");
            if TireEntry.FindFirst then begin
                "Vehicle Axle Code" := TireEntry."Vehicle Axle Code";
                "Tire Position Code" := TireEntry."Tire Position Code";
                "Tire Code" := TireEntry."Tire Code";
            end;
        end;
    end;


    procedure CheckItemAvailabilityOnValidateServiceLineQty(DoNotCheckCurrField: Boolean; DoNotCheckItemAvailDone: Boolean) InteruptValidateTrigger: Boolean
    var
        Location: Record Location;
        Options: Text[250];
        SelectedOption: Integer;
        QtyLocation: Decimal;
        QtySum: Decimal;
        i: Integer;
        LocationArr: array[50] of Code[20];
        ServiceTransferMgt: Codeunit "Service Transfer Mgt.";
        ItemLocationQtyBuffer: Record "Item Location Qty. Buffer" temporary;
        ChoseItemLocQtyDialog: Page "Chose Item Loc. Qty. Dialog";
        ItemLocationQtyBufferSelected: Record "Item Location Qty. Buffer" temporary;
        ServiceLineToCreate: Record "Service Line EDMS";
        ServiceLineNo: Integer;
        ItemJournalLine: Record "Item Journal Line";
        SourceCodeSetup: Record "Source Code Setup";
        ItemAddInfo: Record Item;
        AvailabilityDate: Date;
    begin
        ServiceSetup.Get;
        if not ServiceSetup."Enable Stock Avail. Selection" then
            exit;
        if Type <> Type::Item then
            exit;

        if not (CurrFieldNo = Rec.FieldNo(Quantity)) and not DoNotCheckCurrField then
            exit;

        if CheckItemAvailabilityDone and not DoNotCheckItemAvailDone then
            exit;

        CheckItemAvailabilityDone := true;

        ItemLocationQtyBuffer.DeleteAll;
        if (ServiceTransferMgt.GetItemAvailableQtyOnLocationService(Rec, Rec."Transfer From Location Code") < Rec.Quantity) or (ServiceTransferMgt.GetItemAvailableQtyOnLocationService(Rec, Rec."Transfer From Location Code") = 0) then begin
            //Check Item Qty on other locations
            Location.Reset;
            Location.SetRange("Use As Parts Location Code", true);
            if Location.FindFirst then
                repeat
                    QtyLocation := ServiceTransferMgt.GetItemAvailableQtyOnLocationService(Rec, Location.Code);
                    //IF (QtyLocation > 0) OR (Location.Code = Rec."Location Code") THEN BEGIN
                    if (QtyLocation > 0) or (Location.Code = Rec."Location Code") or (Location.Code = Rec."Transfer From Location Code") then begin
                        if Rec."Shipment Date" <> 0D then
                            AvailabilityDate := Rec."Shipment Date"
                        else
                            AvailabilityDate := WorkDate;
                        ItemAddInfo.Reset;
                        ItemAddInfo.SetRange("No.", Rec."No.");
                        ItemAddInfo.SetRange("Date Filter", 0D, AvailabilityDate);
                        ItemAddInfo.SetRange("Variant Filter", Rec."Variant Code");
                        ItemAddInfo.SetRange("Location Filter", Location.Code);
                        if ItemAddInfo.FindFirst then;
                        ItemAddInfo.CalcFields(Inventory, "Reserved Qty. on Inventory");
                        ItemLocationQtyBuffer.Init;
                        ItemLocationQtyBuffer."Location Code" := Location.Code;
                        ItemLocationQtyBuffer."Location Description" := Location.Name;
                        ItemLocationQtyBuffer."Available Quantity" := QtyLocation;
                        if (Location.Code = Rec."Transfer From Location Code") then
                            ItemLocationQtyBuffer."Selected Quantity" := Rec.Quantity
                        else
                            ItemLocationQtyBuffer."Selected Quantity" := 0;
                        ItemLocationQtyBuffer."Item No." := Rec."No.";
                        ItemLocationQtyBuffer.Inventory := ItemAddInfo.Inventory;
                        ItemLocationQtyBuffer."Reserved Qty. on Inventory" := ItemAddInfo."Reserved Qty. on Inventory";
                        ItemLocationQtyBuffer.Insert;
                        if QtyLocation > 0 then
                            QtySum += QtyLocation;
                    end;
                until Location.Next = 0;

            if QtySum > 0 then begin
                ServiceLineToCreate.Reset;
                ServiceLineToCreate.SetRange("Document No.", Rec."Document No.");
                ServiceLineToCreate.SetRange("Document Type", Rec."Document Type");
                ServiceLineToCreate.SetCurrentkey("Line No.");
                if ServiceLineToCreate.FindLast then
                    ServiceLineNo := ServiceLineToCreate."Line No.";

                ChoseItemLocQtyDialog.AddDialogData(ItemLocationQtyBuffer);
                // COMMIT;           // 21.02.2018 EB.AMU POD.DMS.Parts P439
                if ChoseItemLocQtyDialog.RunModal = Action::OK then begin
                    ChoseItemLocQtyDialog.GetDialogData(ItemLocationQtyBufferSelected);
                    if ItemLocationQtyBufferSelected.FindFirst then
                        repeat
                            if ItemLocationQtyBufferSelected."Selected Quantity" > 0 then begin
                                i += 1;
                                if i = 1 then begin
                                    ServiceLineNo := ServiceLineNo + 10000;
                                    Rec."Transfer From Location Code" := ItemLocationQtyBufferSelected."Location Code";
                                    Rec.Validate(Quantity, ItemLocationQtyBufferSelected."Selected Quantity");
                                    //Rec.MODIFY;
                                    InteruptValidateTrigger := true;
                                end else begin
                                    ServiceLineNo := ServiceLineNo + 10000;
                                    ServiceLineToCreate.Init;
                                    ServiceLineToCreate := Rec;
                                    ServiceLineToCreate.Validate("Transfer From Location Code", ItemLocationQtyBufferSelected."Location Code");
                                    ServiceLineToCreate.Validate(Quantity, ItemLocationQtyBufferSelected."Selected Quantity");
                                    ServiceLineToCreate."Line No." := ServiceLineNo;
                                    ServiceLineToCreate.Insert;
                                end;
                            end;
                        //MESSAGE(ItemLocationQtyBufferSelected."Location Code"+'-'+FORMAT(ItemLocationQtyBufferSelected."Selected Quantity"));
                        until ItemLocationQtyBufferSelected.Next = 0;
                end;
            end;
        end;
        //Commit;



        //11.11.2016 EB.RC POD.DMS.Parts P439.IM19 >>
        SourceCodeSetup.Get;
        ItemJournalLine.Reset;
        ItemJournalLine.SetRange("Item No.", Rec."No.");
        ItemJournalLine.SetRange("Location Code", Rec."Transfer From Location Code");
        ItemJournalLine.SetRange("Source Code", SourceCodeSetup."Phys. Inventory Journal");
        if ItemJournalLine.FindFirst then
            Message(Text129);
        //11.11.2016 EB.RC POD.DMS.Parts P439.IM19 <<
    end;

    local procedure RestrictFieldIfTypeIsBlank(FieldCaption1: Text)
    begin
        if Type = Type::Comment then
            Error('You can''t change %1 if %2 is blank', FieldCaption1, FieldCaption(Type));
    end;

    local procedure GetDefaultSparePartLocation(LocationCode: Code[20]) SparePartLocation: Code[20]
    var
        UserProfileMgt: Codeunit UserProfileManagement;
        UserProfile: Record "Branch Profile Setup";
        ServiceSetup: Record "Service Mgt. Setup EDMS";
    begin
        if Location.Get("Location Code") then
            if Location."Default Transf. From Loc. Code" <> '' then
                exit(Location."Default Transf. From Loc. Code");

        ServiceSetup.Get;
        if UserProfile.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) then begin
            SparePartLocation := UserProfile."Def. Spare Part Location Code";
            if SparePartLocation = '' then
                SparePartLocation := ServiceSetup."Def. Spare Part Location Code";
        end;
    end;

    procedure CalcPlannedDeliveryDate(CurrFieldNo: Integer) PlannedDeliveryDate: Date
    var
        CustomCalendarChange: Array[2] of Record "Customized Calendar Change";
        CalChange: Record "Customized Calendar Change";
    begin

        PlannedDeliveryDate := "Planned Delivery Date";

        if "Shipment Date" = 0D then
            exit("Planned Delivery Date");

        CustomCalendarChange[1].SetSource(CalChange."Source Type"::"Shipping Agent", "Shipping Agent Code", "Shipping Agent Service Code", '');
        case CurrFieldNo of
            FieldNo("Shipment Date"):
                begin
                    CustomCalendarChange[2].SetSource(CalChange."Source Type"::Customer, "Sell-to Customer No.", '', '');
                    exit(CalendarMgmt.CalcDateBOC(Format("Shipping Time"), "Planned Shipment Date", CustomCalendarChange, true));
                end;
            FieldNo("Planned Delivery Date"):
                begin
                    CustomCalendarChange[2].SetSource(CalChange."Source Type"::Location, "Location Code", '', '');
                    exit(CalendarMgmt.CalcDateBOC2(Format("Shipping Time"), "Planned Delivery Date", CustomCalendarChange, true));
                end;
        end;
    end;

    procedure CalcPlannedShptDate(CurrFieldNo: Integer) PlannedShipmentDate: Date
    var
        CustomCalendarChange: Array[2] of Record "Customized Calendar Change";
        CalChange: Record "Customized Calendar Change";
    begin


        if "Shipment Date" = 0D then
            exit("Planned Shipment Date");

        CustomCalendarChange[2].SetSource(CalChange."Source Type"::"Shipping Agent", "Shipping Agent Code", "Shipping Agent Service Code", '');
        case CurrFieldNo of
            FieldNo("Shipment Date"):
                begin
                    CustomCalendarChange[1].SetSource(CalChange."Source Type"::Location, "Location Code", '', '');
                    exit(CalendarMgmt.CalcDateBOC(Format("Shipping Time"), "Shipment Date", CustomCalendarChange, true));
                end;
            FieldNo("Planned Delivery Date"):
                begin
                    CustomCalendarChange[1].SetSource(CalChange."Source Type"::Customer, "Sell-to Customer No.", '', '');
                    exit(CalendarMgmt.CalcDateBOC(Format(''), "Planned Delivery Date", CustomCalendarChange, true));
                end;
        end;
    end;

    procedure CalcShipmentDate(): Date
    var
        CustomCalendarChange: Array[2] of Record "Customized Calendar Change";
        ShipmentDate: Date;
    begin
        if "Planned Shipment Date" = 0D then
            exit("Shipment Date");

        CustomCalendarChange[1].SetSource(CalChange."Source Type"::"Shipping Agent", "Shipping Agent Code", "Shipping Agent Service Code", '');
        CustomCalendarChange[2].SetSource(CalChange."Source Type"::Location, "Location Code", '', '');
        exit(CalendarMgmt.CalcDateBOC(Format(Format('')), "Planned Shipment Date", CustomCalendarChange, false));
    end;

    local procedure CopyFromResource()
    var
        IsHandled: Boolean;
        Res: Record "Resource";
    begin
        Res.Get("No.");
        Res.CheckResourcePrivacyBlocked(false);
        IsHandled := false;

        if not IsHandled then
            Res.TestField(Blocked, false);
        Res.TestField("Gen. Prod. Posting Group");
        Description := Res.Name;
        "Description 2" := Res."Name 2";
        "Unit of Measure Code" := Res."Base Unit of Measure";
        "Unit Cost (LCY)" := Res."Unit Cost";
        "Gen. Prod. Posting Group" := Res."Gen. Prod. Posting Group";
        "VAT Prod. Posting Group" := Res."VAT Prod. Posting Group";
        "Tax Group Code" := Res."Tax Group Code";
        FindResUnitCost();
    end;

    procedure FindResUnitCost()
    var
        ResCost: Record "Resource Cost";
    begin
        ResCost.Init();
        ResCost.Code := "No.";
        CODEUNIT.Run(CODEUNIT::"Resource-Find Cost", ResCost);
        Validate("Unit Cost (LCY)", ResCost."Unit Cost" * "Qty. per Unit of Measure");
    end;

    procedure SetReservationEntry(var ReservEntry: Record "Reservation Entry")
    begin
        ReservEntry.SetSource(DATABASE::"Service Line EDMS", Rec."Document Type", Rec."Document No.", Rec."Line No.", '', 0);
        ReservEntry.SetItemData(Rec."No.", Rec.Description, Rec."Location Code", Rec."Variant Code", Rec."Qty. per Unit of Measure");
        if Type <> Type::Item then
            ReservEntry."Item No." := '';
        ReservEntry."Expected Receipt Date" := Rec."Planned Service Date";
        ReservEntry."Shipment Date" := Rec."Planned Service Date";
    end;

    procedure SetReservationFilters(var ReservEntry: Record "Reservation Entry")
    begin
        ReservEntry.SetSourceFilter(DATABASE::"Service Line EDMS", "Document Type", "Document No.", "Line No.", false);
        ReservEntry.SetSourceFilter('', 0);

        OnAfterSetReservationFilters(ReservEntry, Rec);
    end;

    procedure ReservEntryExist(): Boolean
    var
        ReservEntry: Record "Reservation Entry";
    begin
        ReservEntry.InitSortingAndFilters(false);
        SetReservationFilters(ReservEntry);
        exit(not ReservEntry.IsEmpty);
    end;

    procedure GetRemainingQty(var RemainingQty: Decimal; var RemainingQtyBase: Decimal)
    begin
        CalcFields("Reserved Quantity", "Reserved Qty. (Base)");
        RemainingQty := "Outstanding Quantity" - Abs("Reserved Quantity");
        RemainingQtyBase := "Outstanding Qty. (Base)" - Abs("Reserved Qty. (Base)");
    end;

    procedure GetReservationQty(var QtyReserved: Decimal; var QtyReservedBase: Decimal; var QtyToReserve: Decimal; var QtyToReserveBase: Decimal): Decimal
    begin
        CalcFields("Reserved Quantity", "Reserved Qty. (Base)");
        if "Document Type" = "Document Type"::"Return Order" then begin
            "Reserved Quantity" := -"Reserved Quantity";
            "Reserved Qty. (Base)" := -"Reserved Qty. (Base)";
        end;
        QtyReserved := "Reserved Quantity";
        QtyReservedBase := "Reserved Qty. (Base)";
        QtyToReserve := "Outstanding Quantity";
        QtyToReserveBase := "Outstanding Qty. (Base)";
        exit("Qty. per Unit of Measure");
    end;

    procedure FilterLinesForReservation(ReservationEntry: Record "Reservation Entry"; DocumentType: Option; AvailabilityFilter: Text; Positive: Boolean)
    begin
        Reset;
        SetCurrentKey("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Planned Service Date");
        SetRange("Document Type", DocumentType);
        SetRange(Type, Type::Item);
        SetRange("No.", ReservationEntry."Item No.");
        SetRange("Variant Code", ReservationEntry."Variant Code");
        SetRange("Drop Shipment", false);
        SetRange("Location Code", ReservationEntry."Location Code");
        SetFilter("Planned Service Date", AvailabilityFilter);
        if DocumentType = "Document Type"::"Return Order" then
            if Positive then
                SetFilter("Quantity (Base)", '>0')
            else
                SetFilter("Quantity (Base)", '<0')
        else
            if Positive then
                SetFilter("Quantity (Base)", '<0')
            else
                SetFilter("Quantity (Base)", '>0');
        SetRange("Job No.", ' ');
    end;


    [IntegrationEvent(false, false)]
    local procedure OnAfterSetReservationFilters(var ReservEntry: Record "Reservation Entry"; ServiceLineEDMS: Record "Service Line EDMS")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckResrevedQuantityOnValidateServiceLineQuantity(var ServiceLine: Record "Service Line EDMS"; xServiceLine: Record "Service Line EDMS"; var IsHandled: Boolean)
    begin
    end;

    //>>DELTA 02
    [IntegrationEvent(false, false)]
    local procedure OnAfterInitHeaderDefaults(var SalesLine: Record "Service Line EDMS"; ServiceHeader: Record "Service Header EDMS")
    begin
    end;
    //<<DELTA 02
    [IntegrationEvent(false, false)]
    local procedure OnAfterAssignNoFromTempServLine(var ServLine: Record "Service Line EDMS"; TempServLine: Record "Service Line EDMS")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateAmounts(var ServiceLine: Record "Service Line EDMS"; var xServiceLine: Record "Service Line EDMS"; CurrentFieldNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetDefaultDimID(var Dimsource: List of [Dictionary of [Integer, code[20]]]; var ServiceHeader: Record "Service Header EDMS"; var rec: Record "Service Line EDMS"; var IsHandled: Boolean)
    begin
    end;

    procedure FindOrCreateRecordByNo(SourceNo: Code[20]): Code[20]  //ADD HT
    var
        Item: Record Item;
        FindRecordManagement: Codeunit "Find Record Management";
        FoundNo: Text;
        IsHandled: Boolean;
        SalesSetup: record "Sales & Receivables Setup";
    begin
        IsHandled := false;

        if Type = Type::Item then begin
            if TryGetItemNoOpenCardWithView(
                 FoundNo, SourceNo, SalesSetup."Create Item from Item No.", true, SalesSetup."Create Item from Item No.", '')
            then
                exit(CopyStr(FoundNo, 1, MaxStrLen("No.")));
        end else
            exit(FindRecordManagement.FindNoFromTypedValue(Type::Item, "No.", not "System-Created Entry"));

        exit(SourceNo);
    end;


    procedure TryGetItemNoOpenCardWithView(var ReturnValue: Text; ItemText: Text; DefaultCreate: Boolean; ShowItemCard: Boolean; ShowCreateItemOption: Boolean; View: Text): Boolean
    var
        Item: Record Item;
        ServiceLine: Record "service Line EDMS";
        FindRecordMgt: Codeunit "Find Record Management";
        ItemNo: Code[20];
        ItemWithoutQuote: Text;
        ItemFilterContains: Text;
        FoundRecordCount: Integer;
    begin
        ReturnValue := CopyStr(ItemText, 1, MaxStrLen(ReturnValue));
        if ItemText = '' then
            exit(DefaultCreate);

        FoundRecordCount :=
            FindRecordMgt.FindRecordByDescription(ReturnValue, ServiceLine.Type::Item, ItemText);

        if FoundRecordCount = 1 then
            exit(true);

        ReturnValue := CopyStr(ItemText, 1, MaxStrLen(ReturnValue));
        if FoundRecordCount = 0 then begin
            if not DefaultCreate then
                exit(false);

            if not GuiAllowed then
                Error(SelectItemErr);

        end;

        if not GuiAllowed then
            Error(SelectItemErr);

        if FoundRecordCount > 0 then begin
            ItemWithoutQuote := ConvertStr(ItemText, '''', '?');
            ItemFilterContains := '''@*' + ItemWithoutQuote + '*''';
            Item.FilterGroup(-1);
            Item.SetFilter("No.", ItemFilterContains);
            Item.SetFilter(Description, ItemFilterContains);
            Item.SetFilter("Base Unit of Measure", ItemFilterContains);

        end;

        if ShowItemCard then
            ItemNo := Item.PickItem(Item)
        else begin
            ReturnValue := '';
            exit(true);
        end;

        if ItemNo <> '' then begin
            ReturnValue := ItemNo;
            exit(true);
        end;

        if not DefaultCreate then
            exit(false);
        Error('');
    end;

    var
        SelectItemErr: Label 'You must select an existing item.';
        ServiceHeaderEDMS: Record "Service Header EDMS";
        PriceType: Enum "Price Type";

    procedure PickDiscount()
    var
        PriceCalculation: Interface "Price Calculation";
    begin
        GetPriceCalculationHandler(PriceType::Sale, ServiceHeaderEDMS, PriceCalculation);
        PriceCalculation.PickDiscount();
        GetLineWithCalculatedPrice(PriceCalculation);

        OnAfterPickDiscount(Rec, PriceCalculation);
    end;

    procedure PickPrice()
    var
        PriceCalculation: Interface "Price Calculation";
    begin
        GetPriceCalculationHandler(PriceType::Sale, ServiceHeaderEDMS, PriceCalculation);
        PriceCalculation.PickPrice();
        GetLineWithCalculatedPrice(PriceCalculation);

        OnAfterPickPrice(Rec, PriceCalculation);
    end;

    procedure GetPriceCalculationHandler(PriceType: Enum "Price Type"; ServiceHeaderEDMS: Record "Service Header EDMS"; var PriceCalculation: Interface "Price Calculation")
    var
        PriceCalculationMgt: codeunit "Price Calculation Mgt.";
        LineWithPrice: Interface "Line With Price";
    begin
        if (ServiceHeaderEDMS."No." = '') and ("Document No." <> '') then
            ServiceHeaderEDMS.Get(Rec."Document Type", Rec."Document No.");
        GetLineWithPrice(LineWithPrice);
        LineWithPrice.SetLine(PriceType, ServiceHeaderEDMS, Rec);
        PriceCalculationMgt.GetHandler(LineWithPrice, PriceCalculation);
    end;

    local procedure GetLineWithCalculatedPrice(var PriceCalculation: Interface "Price Calculation")
    var
        Line: Variant;
    begin
        PriceCalculation.GetLine(Line);
        Rec := Line;
    end;

    procedure GetLineWithPrice(var LineWithPrice: Interface "Line With Price")
    var
        SalesLinePrice: Codeunit "Service Line EDMS - Price";
    begin
        LineWithPrice := SalesLinePrice;
        OnAfterGetLineWithPrice(LineWithPrice);
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterGetLineWithPrice(var LineWithPrice: Interface "Line With Price")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPickPrice(var ServiceLineEDMS: Record "Service Line EDMS"; var PriceCalculation: Interface "Price Calculation")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPickDiscount(var ServiceLineEDMS: Record "Service Line EDMS"; var PriceCalculation: Interface "Price Calculation")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnbeforefilterCheckDiscount("servicelinesEDMS": record "service line EDMS"; var SalesDiscount: Record "SP Sales Disc. Group Items"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnbeforeCheckDiscount("servicelinesEDMS": record "service line EDMS"; var SalesDiscount: Record "SP Sales Disc. Group Items"; var Errorexist: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateUnitPriceOnBeforeValidate(var Rec: record "service line EDMS")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure onBeforefilterItemMarkupRestriction(var ItemMarkupRestriction: Record "Item Markup Restriction"; Rec: record "service line EDMS"; "Item Markup Restriction Group": code[20]; var ishandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure onBeforeApplyMarkupRestrictions(var actiontype: Integer; var handled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckPackage(rec: Record "Service Line EDMS"; RunMode: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterTestStatusOpen(var ServiceLineEDMS: Record "Service Line EDMS"; var ServiceHeaderEDMS: Record "Service Header EDMS")
    begin
    end;



}