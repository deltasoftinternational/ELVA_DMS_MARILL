Page 25006805 "Item Order Overview"
{
    // 10.06.2014 Elva Baltic P8 #F0003 EDMS7.10
    //   * ADDED "Quantity Shipped"

    ApplicationArea = Basic;
    Caption = 'Item Order Overview';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Document;
    SaveValues = true;
    SourceTable = "Item Order Overview Entry";
    SourceTableTemporary = true;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(DocProfileFilter; DocProfileFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Document Profile';
                    OptionCaption = ' ,Spare Part Sale,Vehicle Service,Transfer Order';

                    trigger OnValidate()
                    begin
                        SetSourceType(DocProfileFilter);
                    end;
                }
                field(DocNoFilter; DocNoFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Document No.';

                    trigger OnValidate()
                    begin
                        SetDocNo(DocNoFilter);
                    end;
                }
                field(DateFilter; DateFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Date Filter';


                    trigger OnValidate()
                    var
                        DataBuffer: Record "Data Buffer";
                    begin
                        DataBuffer.Reset;
                        DataBuffer.SetFilter("Date Field 1", DateFilter);
                        DateFilter := DataBuffer.GetFilter("Date Field 1");
                    end;
                }
            }
            group(Customer)
            {
                Caption = 'Customer';
                field(SellToCustomerFilter; SellToCustomerFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sell-to Customer No.';
                    TableRelation = Customer;

                    trigger OnValidate()
                    begin
                        SellToCustomerFilterOnAfterVal;
                    end;
                }
                field(BillToCustomerFilter; BillToCustomerFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Bill-to Customer No.';
                    TableRelation = Customer;

                    trigger OnValidate()
                    begin
                        BillToCustomerFilterOnAfterVal;
                    end;
                }
            }
            group(Item)
            {
                Caption = 'Item';
                field(ItemNoFilter; ItemNoFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item No.';
                    TableRelation = Item;
                }
            }
            group(Vehicle)
            {
                Caption = 'Vehicle';
                field(VehicleFilter; VehSerialNoFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle Serial No.';
                    Editable = VehicleFilterEditable;
                    TableRelation = Vehicle;

                    trigger OnValidate()
                    begin
                        VehSerialNoFilterOnAfterValida;
                    end;
                }
                field(VehicleFilter1; VINNumber)
                {
                    ApplicationArea = Basic;
                    Caption = 'VIN';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        VINNumberOnAfterValidate;
                    end;
                }
            }
            repeater(Control1101904020)
            {
                Editable = false;
                field(SourceDescription; ItemOrderOverviewMgt.GetSourceDescription(Rec))
                {
                    ApplicationArea = Basic;
                    Caption = 'Source Description';

                    trigger OnDrillDown()
                    var
                        ReservEntry: Record "Reservation Entry";
                    begin
                        ReservEntry.Reset;
                        ReservEntry.SetCurrentkey("Source ID");
                        ReservEntry.SetRange("Source ID", Rec."Document No.");
                        ReservEntry.SetRange("Source Type", Rec."Document Profile");
                        ReservEntry.SetRange("Source Subtype", Rec."Document Type");
                        ReservEntry.SetRange("Source Ref. No.", Rec."Line No.");

                        Page.RunModal(Page::"Reservation Entries", ReservEntry);
                    end;
                }
                field("2ndLevelSourceDescription"; ItemOrderOverviewMgt.GetSourceDescription2(Rec))
                {
                    ApplicationArea = Basic;
                    Caption = '2nd Level Source Description';

                    trigger OnDrillDown()
                    var
                        ReservationEntry: Record "Reservation Entry";
                        ReservationEntry2: Record "Reservation Entry";
                        ReservationEntry3: Record "Reservation Entry";
                        ReservationEntry4: Record "Reservation Entry";
                    begin
                        ReservationEntry.Reset;
                        ReservationEntry.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
                        ReservationEntry.SetRange("Source ID", Rec."Document No.");
                        ReservationEntry.SetRange("Source Ref. No.", Rec."Line No.");
                        ReservationEntry.SetRange("Source Type", Rec."Document Profile");
                        ReservationEntry.SetRange("Source Subtype", Rec."Document Type");
                        ReservationEntry.SetRange("Reservation Status", ReservationEntry."reservation status"::Reservation);
                        if ReservationEntry.FindFirst then
                            repeat
                                if ReservationEntry2.Get(ReservationEntry."Entry No.", true) then begin
                                    if ReservationEntry2."Source Type" = Database::"Transfer Line" then begin
                                        ReservationEntry3.Reset;
                                        ReservationEntry3.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
                                        ReservationEntry3.SetRange("Source ID", ReservationEntry2."Source ID");
                                        ReservationEntry3.SetRange("Source Ref. No.", ReservationEntry2."Source Ref. No.");
                                        ReservationEntry3.SetRange("Source Type", ReservationEntry2."Source Type");
                                        ReservationEntry3.SetRange("Reservation Status", ReservationEntry3."reservation status"::Reservation);
                                        ReservationEntry3.SetRange(Positive, false);
                                        if ReservationEntry3.FindFirst then
                                            repeat
                                                ReservationEntry4.Get(ReservationEntry3."Entry No.", ReservationEntry3.Positive);
                                                ReservationEntry4.Mark(true);
                                            until ReservationEntry3.Next = 0;
                                    end;
                                end;
                            until ReservationEntry.Next = 0;

                        ReservationEntry4.MarkedOnly(true);
                        Page.RunModal(Page::"Reservation Entries", ReservationEntry4);
                    end;
                }
                field(DocumentProfile; ItemOrderOverviewMgt.CreateText(Rec."Document Profile"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Document Profile';
                }
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    Style = StandardAccent;
                    StyleExpr = StatusMark;
                }
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ItemNo; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(UnitofMeasure; Rec."Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(ReservedQtyBase; Rec."Reserved Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PlannedAvailDate; Rec."Planned Avail. Date")
                {
                    ApplicationArea = Basic;
                }
                field(RequestedDeliveryDate; Rec."Requested Delivery Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PromisedDeliveryDate; Rec."Promised Delivery Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PlannedDeliveryDate; Rec."Planned Delivery Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PlannedShipmentDate; Rec."Planned Shipment Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SelltoCustomerNo; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
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
                field(QuantityShipped; Rec."Quantity Shipped")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Find)
            {
                ApplicationArea = Basic;
                Caption = 'Fi&nd';
                Image = Find;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FindRec
                end;
            }
            action(Show)
            {
                ApplicationArea = Basic;
                Caption = '&Show';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ShowRec;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StatusMark := false;
        if IOOSetup."Highlight Statuses" then
            if ItemOrderOverviewMgt.GetSourceDescription(Rec) = '' then
                StatusMark := true;
    end;

    trigger OnInit()
    begin
        VehicleFilterEditable := true;
    end;

    trigger OnOpenPage()
    begin
        IOOSetup.Get;
        SetFilters;
        FindRec;
    end;

    var
        ItemOrderOverviewMgt: Codeunit "Item Order Overview Mgt.";
        SellToCustomerFilter: Code[20];
        BillToCustomerFilter: Code[20];
        ItemNoFilter: Code[20];
        VehSerialNoFilter: Code[20];
        VehSerialNoFilter2: Code[20];
        VINNumber: Code[20];
        DocNoFilter: Text[250];
        DocNoFilter2: Text[250];
        DateFilter: Text[100];
        DocProfileFilter: Option " ","Spare Part Sale","Vehicle Service","Transfer Order";
        DocProfileFilter2: Option " ","Spare Part Sale","Vehicle Service","Transfer Order";
        [InDataSet]
        VehicleFilterEditable: Boolean;
        [InDataSet]
        StatusMark: Boolean;
        IOOSetup: Record "Item Order Overview Setup";


    procedure FindRec()
    begin
        ItemOrderOverviewMgt.FindRec(Rec, DocProfileFilter, DocNoFilter, SellToCustomerFilter,
                                     BillToCustomerFilter, ItemNoFilter, VehSerialNoFilter, DateFilter);
    end;

    local procedure SetDocNo(DocNo: Text[250])
    begin
        Rec.SetFilter("Document No.", DocNo);
        DocNoFilter := Rec.GetFilter("Document No.");
        ClearCustomerInformation;
    end;


    procedure ClearCustomerInformation()
    begin
        SellToCustomerFilter := '';
        BillToCustomerFilter := '';
    end;


    procedure ClearDocumentInformation()
    begin
        Rec.SetFilter("Document No.", '');
        DocNoFilter := Rec.GetFilter("Document No.");
    end;


    procedure GetVIN()
    var
        Vehicle: Record Vehicle;
    begin
        if Vehicle.Get(VehSerialNoFilter) then
            VINNumber := Vehicle.VIN
        else
            VINNumber := '';
    end;


    procedure ShowRec()
    begin
        ItemOrderOverviewMgt.ShowRec(Rec);
    end;


    procedure GetRec(var ItemOrderEntry: Record "Item Order Overview Entry")
    begin
        if ItemOrderEntry.FindFirst then
            repeat
                Rec := ItemOrderEntry;
                Rec.Insert;
            until ItemOrderEntry.Next = 0;
    end;


    procedure SetSourceType(DocProfileFilter1: Option " ",Sale,Service)
    begin
        DocProfileFilter := DocProfileFilter1;

        if DocProfileFilter = Docprofilefilter::"Spare Part Sale" then begin
            VehSerialNoFilter := '';
            VINNumber := '';
            VehicleFilterEditable := false;
        end else
            VehicleFilterEditable := true;
    end;


    procedure SetDocumentFilter(DocNoFilter1: Text[30])
    begin
        DocNoFilter2 := DocNoFilter1;
    end;


    procedure SetVehicleSerialNo(VehSerialNo: Code[20])
    begin
        VehSerialNoFilter2 := VehSerialNo;
    end;


    procedure SetSourceType2(DocProfileFilter1: Option " ",Sale,Service)
    begin
        DocProfileFilter2 := DocProfileFilter1;
    end;


    procedure SetFilters()
    begin
        if DocProfileFilter2 > 0 then
            SetSourceType(DocProfileFilter2);

        if DocNoFilter2 <> '' then begin
            DocNoFilter := DocNoFilter2;
            ClearCustomerInformation;
        end;

        if VehSerialNoFilter2 <> '' then begin
            VehSerialNoFilter := VehSerialNoFilter2;
            GetVIN;
        end;
    end;

    local procedure BillToCustomerFilterOnAfterVal()
    begin
        ClearDocumentInformation
    end;

    local procedure SellToCustomerFilterOnAfterVal()
    begin
        ClearDocumentInformation
    end;

    local procedure VehSerialNoFilterOnAfterValida()
    begin
        DocProfileFilter := Docprofilefilter::"Vehicle Service";
        GetVIN
    end;

    local procedure VINNumberOnAfterValidate()
    begin
        DocProfileFilter := Docprofilefilter::"Vehicle Service";
    end;
}

