Page 25006488 "Vehicle Req. Worksheet"
{
    ApplicationArea = Basic;
    AutoSplitKey = true;
    Caption = 'Vehicle Req. Worksheet';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Requisition Line";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                ApplicationArea = Basic;
                Caption = 'Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    ReqJnlManagement.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    ReqJnlManagement.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Control1)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ReqJnlManagement.GetDescriptionAndRcptName(Rec, Description2, BuyFromVendorName);
                    end;
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
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ReqJnlManagement.GetDescriptionAndRcptName(Rec, Description2, BuyFromVendorName);
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field(ActionMessage; Rec."Action Message")
                {
                    ApplicationArea = Basic;
                }
                field(AcceptActionMessage; Rec."Accept Action Message")
                {
                    ApplicationArea = Basic;
                }
                field(VariantCode; Rec."Variant Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
                field(TransferfromCode; Rec."Transfer-from Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(OriginalQuantity; Rec."Original Quantity")
                {
                    ApplicationArea = Basic;
                }
                field(Reserved; Rec.Reserved)
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;
                }
                field(VehicleAssemblyID; Rec."Vehicle Assembly ID")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field(DirectUnitCost; Rec."Direct Unit Cost")
                {
                    ApplicationArea = Basic;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    AssistEdit = true;
                    Visible = false;

                    trigger OnAssistEdit()
                    begin
                        ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", WorkDate);
                        if ChangeExchangeRate.RunModal = Action::OK then begin
                            Rec.Validate("Currency Factor", ChangeExchangeRate.GetParameter);
                        end;
                        Clear(ChangeExchangeRate);
                    end;
                }
                field(LineDiscount; Rec."Line Discount %")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(OriginalDueDate; Rec."Original Due Date")
                {
                    ApplicationArea = Basic;
                }
                field(DueDate; Rec."Due Date")
                {
                    ApplicationArea = Basic;
                }
                field(OrderDate; Rec."Order Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VendorNo; Rec."Vendor No.")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        ReqJnlManagement.GetDescriptionAndRcptName(Rec, Description2, BuyFromVendorName);
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field(VendorItemNo; Rec."Vendor Item No.")
                {
                    ApplicationArea = Basic;
                }
                field(OrderAddressCode; Rec."Order Address Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SelltoCustomerNo; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ShiptoCode; Rec."Ship-to Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ProdOrderNo; Rec."Prod. Order No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(RequesterID; Rec."Requester ID")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Confirmed; Rec.Confirmed)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
                field(RefOrderNo; Rec."Ref. Order No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(RefOrderType; Rec."Ref. Order Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ReplenishmentSystem; Rec."Replenishment System")
                {
                    ApplicationArea = Basic;
                }
                field(RefLineNo; Rec."Ref. Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PlanningFlexibility; Rec."Planning Flexibility")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Control20)
            {
                ShowCaption = false;
                fixed(Control1901776201)
                {
                    group(Control1902759801)
                    {
                        Caption = 'Description';
                        field(Control21; Description2)
                        {
                            ShowCaption = false;
                            ApplicationArea = Basic;
                            Editable = false;
                        }
                    }
                    group(BuyfromVendorNameGroup)
                    {
                        Caption = 'Buy-from Vendor Name';
                        field(BuyFromVendorName; BuyFromVendorName)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Buy-from Vendor Name';
                            Editable = false;
                        }
                    }
                }
            }
        }
        area(factboxes)
        {
            part(Control1903326807; "Item Replenishment FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
                Visible = true;
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Line)
            {
                Caption = '&Line';
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Codeunit "Req. Wksh.-Show Card";
                    ShortCutKey = 'Shift+F7';
                }
                action("<Action1101904006>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle Assembly';
                    Image = CheckList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;

                    trigger OnAction()
                    begin
                        Rec.VehicleAssembly
                    end;
                }
                action("<Action1101904008>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Reservation Entries';
                    Image = ReservationLedger;

                    trigger OnAction()
                    begin
                        Rec.ShowVehReservationEntries(true)
                    end;
                }
            }
        }
        area(processing)
        {
            group(Functions)
            {
                Caption = 'F&unctions';
                group(DropShipment)
                {
                    Caption = 'Drop Shipment';
                    Image = Delivery;
                    action(GetSalesOrders)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Get &Sales Orders';
                        Ellipsis = true;
                        Image = "Order";

                        trigger OnAction()
                        begin
                            GetSalesOrder.SetReqWkshLine(Rec, 0);
                            GetSalesOrder.RunModal;
                            Clear(GetSalesOrder);
                        end;
                    }
                    action(SalesOrder)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Sales &Order';
                        Image = Document;

                        trigger OnAction()
                        begin
                            SalesHeader.SetRange("No.", Rec."Sales Order No.");
                            SalesOrder.SetTableview(SalesHeader);
                            SalesOrder.Editable := false;
                            SalesOrder.Run;
                        end;
                    }
                }
                group(SpecialOrder)
                {
                    Caption = 'Special Order';
                    Image = SpecialOrder;
                    action(Action53)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Get &Sales Orders';
                        Ellipsis = true;
                        Image = "Order";

                        trigger OnAction()
                        begin
                            GetSalesOrder.SetReqWkshLine(Rec, 1);
                            GetSalesOrder.RunModal;
                            Clear(GetSalesOrder);
                        end;
                    }
                    action(Action75)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Sales &Order';
                        Image = Document;

                        trigger OnAction()
                        begin
                            SalesHeader.SetRange("No.", Rec."Sales Order No.");
                            SalesOrder.SetTableview(SalesHeader);
                            SalesOrder.Editable := false;
                            SalesOrder.Run;
                        end;
                    }
                }
                action(CarryOutActionMessage)
                {
                    ApplicationArea = Basic;
                    Caption = 'Carry &Out Action Message';
                    Ellipsis = true;
                    Image = CarryOutActionMessage;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        PerformAction: Report "EDMS CarryOut Action Msg.-Req.";
                    begin
                        PerformAction.SetReqWkshLine(Rec);
                        PerformAction.RunModal;
                        PerformAction.GetReqWkshLine(Rec);
                        CurrentJnlBatchName := Rec.GetRangemax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
                action(Reserve)
                {
                    ApplicationArea = Basic;
                    Caption = '&Reserve';
                    Image = Reserve;

                    trigger OnAction()
                    begin
                        CurrPage.SaveRecord;
                        Rec.ShowVehReservation;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
        OnAfterGetCurrRecord;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Rec."Accept Action Message" := false;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ReqJnlManagement.SetUpNewLine(Rec, xRec);
        Clear(ShortcutDimCode);
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        OpenedFromBatch := (Rec."Journal Batch Name" <> '') and (Rec."Worksheet Template Name" = '');
        if OpenedFromBatch then begin
            CurrentJnlBatchName := Rec."Journal Batch Name";
            ReqJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
            exit;
        end;
        PurchasePostEventManagement.TemplateSelection(Page::"Vehicle Req. Worksheet", false, 0, Rec, JnlSelected);
        if not JnlSelected then
            Error('');
        CurrentJnlBatchName := Rec."Journal Batch Name";
        ReqJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
    end;

    var
        SalesHeader: Record "Sales Header";
        GetSalesOrder: Report "Get Sales Orders";
        ReqJnlManagement: Codeunit ReqJnlManagement;
        SalesOrder: Page "Sales Order";
        ChangeExchangeRate: Page "Change Exchange Rate";
        CurrentJnlBatchName: Code[10];
        Description2: Text[30];
        BuyFromVendorName: Text[50];
        ShortcutDimCode: array[8] of Code[20];
        OpenedFromBatch: Boolean;
        PurchasePostEventManagement: Codeunit "Purchase Post Event Management";

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        ReqJnlManagement.SetName(CurrentJnlBatchName, Rec);
        CurrPage.Update(false);
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        ReqJnlManagement.GetDescriptionAndRcptName(Rec, Description2, BuyFromVendorName);
    end;
}

