Page 25006782 "Integration Message Lines Sub"
{
    PageType = ListPart;
    SourceTable = "Integration Message Line EDMS";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                FreezeColumn = ParentLineNo;
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(ParentLineNo; Rec."Parent Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(SourceType; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                }
                field(SourceSubtype; Rec."Source Subtype")
                {
                    ApplicationArea = Basic;
                }
                field(SourceID; Rec."Source ID")
                {
                    ApplicationArea = Basic;
                }
                field(SourceRefNo; Rec."Source Ref. No.")
                {
                    ApplicationArea = Basic;
                }
                field(SourceBatchName; Rec."Source Batch Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SourceProdOrderLine; Rec."Source Prod. Order Line")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ItemLedgerEntryNo; Rec."Item Ledger Entry No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ResponseStatus; Rec."Response Status")
                {
                    ApplicationArea = Basic;
                }
                field(ItemNo; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                }
                field(VariantCode; Rec."Variant Code")
                {
                    ApplicationArea = Basic;
                }
                field(ItemCategoryCode; Rec."Item Category Code")
                {
                    ApplicationArea = Basic;
                }
                field(UnitOfMeasureCode; Rec."Unit Of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(BinCode; Rec."Bin Code")
                {
                    ApplicationArea = Basic;
                }
                field(LocationCodeOriginal; Rec."Location Code Original")
                {
                    ApplicationArea = Basic;
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field(OrderingPriceTypeCode; Rec."Ordering Price Type Code")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(VehicleNo; Rec."Vehicle No.")
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
                field(ModelVersionNo; Rec."Model Version No.")
                {
                    ApplicationArea = Basic;
                }
                field(ModelCommercialName; Rec."Model Commercial Name")
                {
                    ApplicationArea = Basic;
                }
                field(ProdSerialNo; Rec."Prod. Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;
                }
                field(MakeVehicleID; Rec."Make Vehicle ID")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleRegistrationNo; Rec."Vehicle Registration No.")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerNo; Rec."Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerID; Rec."Customer ID")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerName; Rec."Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerRegNo; Rec."Customer Reg. No.")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerAddress; Rec."Customer Address")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerAddress2; Rec."Customer Address 2")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerCity; Rec."Customer City")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerPostCode; Rec."Customer Post Code")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerCountryCode; Rec."Customer Country Code")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerCounty; Rec."Customer County")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerPhoneNo; Rec."Customer Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerFaxNo; Rec."Customer Fax No.")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerEMail; Rec."Customer E-Mail")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerCategoryCode; Rec."Customer Category Code")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerLanguageCode; Rec."Customer Language Code")
                {
                    ApplicationArea = Basic;
                }
                field(VendorNo; Rec."Vendor No.")
                {
                    ApplicationArea = Basic;
                }
                field(VendorID; Rec."Vendor ID")
                {
                    ApplicationArea = Basic;
                }
                field(MakeID; Rec."Make ID")
                {
                    ApplicationArea = Basic;
                }
                field(DealerID; Rec."Dealer ID")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(ExternalDocumentNo; Rec."External Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(InvoiceNo; Rec."Invoice No.")
                {
                    ApplicationArea = Basic;
                }
                field(OrderNo; Rec."Order No.")
                {
                    ApplicationArea = Basic;
                }
                field(ExternalOrderNo; Rec."External Order No.")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentDate; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                }
                field(InvoiceDate; Rec."Invoice Date")
                {
                    ApplicationArea = Basic;
                }
                field(OrderDate; Rec."Order Date")
                {
                    ApplicationArea = Basic;
                }
                field(ReceiptDate; Rec."Receipt Date")
                {
                    ApplicationArea = Basic;
                }
                field(CountryCode; Rec."Country Code")
                {
                    ApplicationArea = Basic;
                }
                field(RecallCampaignCode; Rec."Recall Campaign Code")
                {
                    ApplicationArea = Basic;
                }
                field(RecallCampaignName; Rec."Recall Campaign Name")
                {
                    ApplicationArea = Basic;
                }
                field(RecallCampaignDefectCode; Rec."Recall Campaign Defect Code")
                {
                    ApplicationArea = Basic;
                }
                field(Code1; Rec.Code1)
                {
                    ApplicationArea = Basic;
                }
                field(Code2; Rec.Code2)
                {
                    ApplicationArea = Basic;
                }
                field(Code3; Rec.Code3)
                {
                    ApplicationArea = Basic;
                }
                field(Code4; Rec.Code4)
                {
                    ApplicationArea = Basic;
                }
                field(Code5; Rec.Code5)
                {
                    ApplicationArea = Basic;
                }
                field(Code6; Rec.Code6)
                {
                    ApplicationArea = Basic;
                }
                field(Code7; Rec.Code7)
                {
                    ApplicationArea = Basic;
                }
                field(Code8; Rec.Code8)
                {
                    ApplicationArea = Basic;
                }
                field(Code9; Rec.Code9)
                {
                    ApplicationArea = Basic;
                }
                field(Code10; Rec.Code10)
                {
                    ApplicationArea = Basic;
                }
                field(Date1; Rec.Date1)
                {
                    ApplicationArea = Basic;
                }
                field(Date2; Rec.Date2)
                {
                    ApplicationArea = Basic;
                }
                field(Date3; Rec.Date3)
                {
                    ApplicationArea = Basic;
                }
                field(Date4; Rec.Date4)
                {
                    ApplicationArea = Basic;
                }
                field(Date5; Rec.Date5)
                {
                    ApplicationArea = Basic;
                }
                field(Date6; Rec.Date6)
                {
                    ApplicationArea = Basic;
                }
                field(Date7; Rec.Date7)
                {
                    ApplicationArea = Basic;
                }
                field(Date8; Rec.Date8)
                {
                    ApplicationArea = Basic;
                }
                field(Date9; Rec.Date9)
                {
                    ApplicationArea = Basic;
                }
                field(Date10; Rec.Date10)
                {
                    ApplicationArea = Basic;
                }
                field(Int1; Rec.Int1)
                {
                    ApplicationArea = Basic;
                }
                field(Int2; Rec.Int2)
                {
                    ApplicationArea = Basic;
                }
                field(Int3; Rec.Int3)
                {
                    ApplicationArea = Basic;
                }
                field(Int4; Rec.Int4)
                {
                    ApplicationArea = Basic;
                }
                field(Int5; Rec.Int5)
                {
                    ApplicationArea = Basic;
                }
                field(Dec1; Rec.Dec1)
                {
                    ApplicationArea = Basic;
                }
                field(Dec11; Rec.Dec11)
                {
                    ApplicationArea = Basic;
                }
                field(Dec2; Rec.Dec2)
                {
                    ApplicationArea = Basic;
                }
                field(Dec12; Rec.Dec12)
                {
                    ApplicationArea = Basic;
                }
                field(Dec3; Rec.Dec3)
                {
                    ApplicationArea = Basic;
                }
                field(Dec13; Rec.Dec13)
                {
                    ApplicationArea = Basic;
                }
                field(Dec4; Rec.Dec4)
                {
                    ApplicationArea = Basic;
                }
                field(Dec14; Rec.Dec14)
                {
                    ApplicationArea = Basic;
                }
                field(Dec5; Rec.Dec5)
                {
                    ApplicationArea = Basic;
                }
                field(Dec15; Rec.Dec15)
                {
                    ApplicationArea = Basic;
                }
                field(Dec6; Rec.Dec6)
                {
                    ApplicationArea = Basic;
                }
                field(Dec7; Rec.Dec7)
                {
                    ApplicationArea = Basic;
                }
                field(Dec8; Rec.Dec8)
                {
                    ApplicationArea = Basic;
                }
                field(Dec9; Rec.Dec9)
                {
                    ApplicationArea = Basic;
                }
                field(Dec10; Rec.Dec10)
                {
                    ApplicationArea = Basic;
                }
                field(Text1; Rec.Text1)
                {
                    ApplicationArea = Basic;
                }
                field(Text2; Rec.Text2)
                {
                    ApplicationArea = Basic;
                }
                field(Text3; Rec.Text3)
                {
                    ApplicationArea = Basic;
                }
                field(Text4; Rec.Text4)
                {
                    ApplicationArea = Basic;
                }
                field(Text5; Rec.Text5)
                {
                    ApplicationArea = Basic;
                }
                field(Bool1; Rec.Bool1)
                {
                    ApplicationArea = Basic;
                }
                field(Bool2; Rec.Bool2)
                {
                    ApplicationArea = Basic;
                }
                field(Bool3; Rec.Bool3)
                {
                    ApplicationArea = Basic;
                }
                field(Bool4; Rec.Bool4)
                {
                    ApplicationArea = Basic;
                }
                field(Bool5; Rec.Bool5)
                {
                    ApplicationArea = Basic;
                }
                field(Bool6; Rec.Bool6)
                {
                    ApplicationArea = Basic;
                }
                field(Bool7; Rec.Bool7)
                {
                    ApplicationArea = Basic;
                }
                field(Bool8; Rec.Bool8)
                {
                    ApplicationArea = Basic;
                }
                field(Bool9; Rec.Bool9)
                {
                    ApplicationArea = Basic;
                }
                field(Bool10; Rec.Bool10)
                {
                    ApplicationArea = Basic;
                }
                field(ShortText1; Rec.ShortText1)
                {
                    ApplicationArea = Basic;
                }
                field(ShortText2; Rec.ShortText2)
                {
                    ApplicationArea = Basic;
                }
                field(ShortText3; Rec.ShortText3)
                {
                    ApplicationArea = Basic;
                }
                field(ShortText4; Rec.ShortText4)
                {
                    ApplicationArea = Basic;
                }
                field(ShortText5; Rec.ShortText5)
                {
                    ApplicationArea = Basic;
                }
                field(ShortText6; Rec.ShortText6)
                {
                    ApplicationArea = Basic;
                }
                field(ShortText7; Rec.ShortText7)
                {
                    ApplicationArea = Basic;
                }
                field(ShortText8; Rec.ShortText8)
                {
                    ApplicationArea = Basic;
                }
                field(ShortText9; Rec.ShortText9)
                {
                    ApplicationArea = Basic;
                }
                field(ShortText10; Rec.ShortText10)
                {
                    ApplicationArea = Basic;
                }
                field(DateTime1; Rec.DateTime1)
                {
                    ApplicationArea = Basic;
                }
                field(DateTime2; Rec.DateTime2)
                {
                    ApplicationArea = Basic;
                }
                field(DateTime3; Rec.DateTime3)
                {
                    ApplicationArea = Basic;
                }
                field(DateTime4; Rec.DateTime4)
                {
                    ApplicationArea = Basic;
                }
                field(DateTime5; Rec.DateTime5)
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
            action("1stLevel")
            {
                ApplicationArea = Basic;
                Caption = '1st Level';

                trigger OnAction()
                begin
                    SetLevel1;
                end;
            }
            action(ParentLevel)
            {
                ApplicationArea = Basic;
                Caption = 'Parent Level';

                trigger OnAction()
                begin
                    SetLevelParent;
                end;
            }
            action(ChildLevel)
            {
                ApplicationArea = Basic;
                Caption = 'Child Level';

                trigger OnAction()
                begin
                    SetLevelChild;
                end;
            }
            action(AllLevels)
            {
                ApplicationArea = Basic;
                Caption = 'All Levels';

                trigger OnAction()
                begin
                    ClearLevel;
                end;
            }
        }
    }


    procedure SetLevel1()
    begin
        Rec.SetRange("Parent Line No.", 0);
    end;


    procedure SetLevelParent()
    begin
        if Rec."Parent Line No." = 0 then
            ClearLevel
        else
            Rec.SetRange("Parent Line No.", Rec."Parent Line No.");
    end;


    procedure SetLevelChild()
    var
        xMessageLine: Record "Integration Message Line EDMS";
    begin
        xMessageLine := Rec;
        Rec.SetRange("Parent Line No.", Rec."Line No.");
        if Rec.IsEmpty then
            Rec.SetRange("Parent Line No.", Rec."Parent Line No.");
    end;


    procedure ClearLevel()
    begin
        Rec.SetRange("Parent Line No.");
    end;
}

