Page 25006033 "Vehicle List"
{
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified OnOpenPage(), Usert Profile Setup to Branch Profile Setup
    // 
    // 26.03.2014 Elva Baltic P18 #F011 MMG7.00
    //   Added Page Action "Dimensions"
    // 
    // 27.02.2014 Elva Baltic P15 #F016 MMG7.00
    //   * Modified "Current Location Code"

    ApplicationArea = Basic;
    Caption = 'Vehicle List';
    CardPageID = "Vehicle Card";
    Editable = true;
    PageType = List;
    SourceTable = Vehicle;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(SerialNo; Rec."Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the vehicle entry in system, according to the specified number series.';
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the VIN of the vehicle.';
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the make code this vehicle belongs to.';
                }
                field(ModelCode; Rec."Model Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the model code this vehicle belongs to.';
                }
                field(ModelVersionNo; Rec."Model Version No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the model version of this vehicle. Model version is an item record and is required for vehicles when they are traded.';
                }
                field(RegistrationNo; Rec."Registration No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the registration number of this vehicle.';
                }
                field(Reserved; Rec.Reserved)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Shows whether vehicle is reserved in sales order.';
                }
                field(StatusCode; Rec."Status Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the status of the vehicle. This defines status/ownership of the vehicle. For example, New vehicle for sale, Customer owned vehicles, vehicles for rent.';
                }
                field(TrackingCode; Rec."Tracking Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the tracking code for vehicle. This can be used, for example, to specify the stage in delivery chain where vehicle currently is.';
                }
                field(TrackingDescription; Rec."Tracking Description")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the tracking description for vehicle. This can be used, for example, to specify the stage in delivery chain where vehicle currently is.';
                }
                field(TypeCode; Rec."Type Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the type of the vehicle. Users can define vehicle types depending on the kinds of vehicles used in system and how detailed this categories should be.';
                }
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Shows whether vehicle is in the inventory or not.';
                }
                field(GetLocation; Rec.GetLocation)
                {
                    ApplicationArea = Basic;
                    Caption = 'Current Location Code';
                }
                field(BodyColorCode; Rec."Body Color Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies a color of this vehicle.';
                }
                field(InteriorCode; Rec."Interior Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies an interior of this vehicle.';
                }
                field(SalesDate; Rec."Sales Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the date when the vehicle was first sold. System fills this date automatically when a sales order is posted or user can enter it manually.';
                }
                field(ProductionYear; Rec."Production Year")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the production year of this vehicle.';
                }
                field(FirstRegistrationDate; Rec."First Registration Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the date ehn this vehicle has been first registered.';
                }
                field(NextVehicleInspectionDate; Rec."Next Vehicle Inspection Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the date when the next inspection for vehicle is due.';
                }
                field(Assembly; rec.GetAssemblyDescr(Rec."Serial No."))
                {
                    ApplicationArea = Basic;
                    Caption = 'Assembly';
                    Visible = false;
                    ToolTip = 'Shows what options are in vehicle assembly.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies if the vehicle card is blocked so that it can''t be used in documents.';
                }
                field(GetCurrentPrice; Rec.GetCurrentPrice)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Price';
                    Visible = false;
                    ToolTip = 'Shows current price of the vehicle. If a specific price is defined for vehicle it will be shown here, otherwise system will show model version base price.';
                }
                field(VariableField25006800; Rec."Variable Field 25006800")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006801; Rec."Variable Field 25006801")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006802; Rec."Variable Field 25006802")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006803; Rec."Variable Field 25006803")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006804; Rec."Variable Field 25006804")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006805; Rec."Variable Field 25006805")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006806; Rec."Variable Field 25006806")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006807; Rec."Variable Field 25006807")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006808; Rec."Variable Field 25006808")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006809; Rec."Variable Field 25006809")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006810; Rec."Variable Field 25006810")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006811; Rec."Variable Field 25006811")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006812; Rec."Variable Field 25006812")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006813; Rec."Variable Field 25006813")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006814; Rec."Variable Field 25006814")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006815; Rec."Variable Field 25006815")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006816; Rec."Variable Field 25006816")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006817; Rec."Variable Field 25006817")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006818; Rec."Variable Field 25006818")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006819; Rec."Variable Field 25006819")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006820; Rec."Variable Field 25006820")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006821; Rec."Variable Field 25006821")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006822; Rec."Variable Field 25006822")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006823; Rec."Variable Field 25006823")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006824; Rec."Variable Field 25006824")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006825; Rec."Variable Field 25006825")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(CustomerNo; Rec."Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer number for customer that is linked to this vehicle. It will be used when vehicle is in service.';
                }
                field(CustomerName; Rec."Customer Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Shows the name of the linked customer.';
                }
                field(CustomerServiceAddressCode; Rec."Customer Service Address Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the default vehicle service address, if it has been defined.';
                }
                field(CustomerVehicleID; Rec."Customer Vehicle ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the vehicle identification number used by customer.';
                }
                field("Parent Component"; Rec."Parent Component")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Shows the main vehicle card number if there are linked vehicles and this vehicle is a child in the link. For example, if this is a trailer it could show the card for the truck.';
                }
                field(Components; Rec.Components)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Shows whether there are any child vehicle cards linked to this vehicle. For example, if it is a truck then it could show thether there is a linked trailer.';
                }
            }
        }
        area(factboxes)
        {
            part(Control25006006; "Vehicle MapView FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Serial No." = field("Serial No.");
            }
            part(Control1101904004; "Vehicle Service FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Serial No." = field("Serial No.");
                Visible = true;
            }
            part(Control11; "Vehicle Info FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Serial No." = field("Serial No.");
            }
            part("Vehicle Pictures"; "Object Picture FactBox")
            {
                ApplicationArea = All;
                Caption = 'Vehicle Pictures';
                SubPageLink = "Source Type" = const(Database::Vehicle),
                              //"Source Subtype" = const("0"),
                              "Vehicle Serial No." = field("Serial No.");
                //"Source Ref. No." = const(0);
                SubPageView = sorting("Source Type", "Source Subtype", "Source ID", "Source Ref. No.", "No.");
            }
            systempart(Control1101904003; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Control1101904002; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Vehicle)
            {
                Caption = 'Vehicle';
            }
            group(General)
            {
                Caption = 'General';
                action("<Action1101904016>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'View statistical information, such as the value of posted purchase and sales entries, total amount in service.';
                    RunObject = Page "Vehicle Statistics";
                    RunPageLink = "Serial No." = field("Serial No.");
                }
                action("<Action96>")
                {
                    ApplicationArea = Basic;
                    Caption = 'T&o-dos';
                    Image = TaskList;
                    ToolTip = 'View to-dos that are related to this vehicle.';
                    RunObject = Page "Task List";
                    RunPageLink = "System To-do Type" = filter("Contact Attendee"),
                                  "Vehicle Serial No." = field("Serial No.");
                    RunPageView = sorting("Contact Company No.", Date, "Contact No.", Closed);
                }
                action("<Action157>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Options';
                    Image = Reconcile;
                    ToolTip = 'View information on vehicle options.';
                    RunObject = Page "Vehicle Option Overview";
                    RunPageLink = "Vehicle Serial No." = field("Serial No.");
                    RunPageView = sorting("Vehicle Serial No.", "Entry Type", "Option Type", "Option Code", Open);
                }
                action("<Action1101904011>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Reservation Entries';
                    Image = ReservationLedger;
                    ToolTip = 'View reservation entries for this vehicle.';

                    trigger OnAction()
                    begin
                        Rec.ShowVehReservationEntries(true);
                    end;
                }
                action("<Action1101904031>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Change Log';
                    Image = ChangeLog;
                    ToolTip = 'View vehicle change log entries.';
                    RunObject = Page "Vehicle Change Log";
                    RunPageLink = "Vehicle Serial No." = field("Serial No.");
                }
                action("<Action1101904010>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Process Checklists';
                    Image = CheckList;
                    ToolTip = 'View or or create vehicle''s checklist. Chacklists can be used to record cases when vehicles are checked based on standartized list of checks.';
                    RunObject = Page "Process Checklist List";
                    RunPageLink = "Vehicle Serial No." = field("Serial No.");
                }
                action("<Action1101904003>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Warranties';
                    Image = ListPage;
                    ToolTip = 'View or edit the vehicle''s warranties. You can register differet warranty types.';
                    RunObject = Page "Vehicle Warranty List";
                    RunPageLink = "Vehicle Serial No." = field("Serial No.");
                }
                action("<Action1101914011>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Recall Campaigns';
                    Image = ListPage;
                    ToolTip = 'View information on recalls where this vehicle is included. You can see statuses whether those are pending or cmpleted.';
                    RunObject = Page "Recall Campaign Vehicles";
                    RunPageLink = VIN = field(VIN);
                }
                action("<Action1101904007>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Insurances';
                    Image = ListPage;
                    ToolTip = 'View information on insurances for the vehicle.';
                    RunObject = Page "Vehicle Insurance";
                    RunPageLink = "Vehicle Serial No." = field("Serial No.");
                }
                action(PageDimensionsAction)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ToolTip = 'View or edit default vehicle dimensions.';
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = const(Database::Vehicle),
                                  "No." = field("Serial No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action("<Page Object Picture>")
                {
                    ApplicationArea = Basic;
                    Caption = '&Pictures';
                    Image = Picture;
                    ToolTip = 'View or add pictures for the vehicle.';
                    RunObject = Page Pictures;
                    RunPageLink = "Vehicle Serial No." = field("Serial No.");
                    RunPageMode = View;

                    trigger OnAction()
                    begin
                        // 1st par 25006005 - Vehicle
                        //PictureMgt.ShowObjectPictures(25006005,0,"Serial No.",0)
                    end;
                }
            }
            group(Plan)
            {
                Caption = 'Plan';
                action("<Action1101904002>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Plans';
                    Image = MaintenanceLedgerEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'View or edit the vehicle''s service plans. Service Plans allows to track vehicle standard maintenance schedule.';
                    RunObject = Page "Vehicle Service Plans";
                    RunPageLink = "Vehicle Serial No." = field("Serial No.");
                }
                action(ItemOrderOverview)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Order Overview';
                    Image = ItemTrackingLines;
                    ToolTip = 'Item Order Overview screen shows information on all items ordered in relation with this vehicle and their order status.';

                    trigger OnAction()
                    var
                        ItemOrderOverview: Page "Item Order Overview";
                    begin
                        ItemOrderOverview.SetSourceType2(2); //Service
                        ItemOrderOverview.SetVehicleSerialNo(Rec."Serial No.");
                        ItemOrderOverview.SetFilters;
                        ItemOrderOverview.FindRec;
                        ItemOrderOverview.Run;
                    end;
                }
            }
            group(Contact)
            {
                Caption = 'Contact';
                action("<Action1101904013>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Contacts';
                    Image = ContactPerson;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'View or edit contacts related to this vehicle.';
                    RunObject = Page "Vehicle Contacts";
                    RunPageLink = "Vehicle Serial No." = field("Serial No.");
                }
                action("<Action95>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Interaction Log E&ntries';
                    Image = InteractionLog;
                    ToolTip = 'View log of interactions that are related to this vehicle.';
                    RunObject = Page "Interaction Log Entries";
                    RunPageLink = "Contact No." = filter(<> ''),
                                  "Vehicle Serial No." = field("Serial No.");
                    RunPageView = sorting("Vehicle Serial No.");
                    ShortCutKey = 'Ctrl+F7';
                }
            }
            group("<Action79>")
            {
                Caption = 'S&ales';
                action("<Action82>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Prices';
                    Image = SalesPrices;
                    ToolTip = 'View or edit sales prices for this vehicle.';
                    RunObject = Page "Model Version Sales Prices";
                    RunPageLink = "Item No." = field("Model Version No."),
                                  "Vehicle Serial No." = field("Serial No.");
                }
                action("<Action80>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Line Discounts';
                    Image = SalesLineDisc;
                    ToolTip = 'View or edit sales line discounts for this vehicle.';
                    RunObject = Page "Model Version Sales Line Disc.";
                    RunPageLink = Type = const(Item),
                                  Code = field("Model Version No."),
                                  "Vehicle Serial No." = field("Serial No.");
                }
                action("<Action1101904021>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Orders';
                    Image = Document;
                    ToolTip = 'View sales orders created for this vehicle.';

                    trigger OnAction()
                    begin
                        Rec.ShowSalesOrders
                    end;
                }
                action("<Action1101904025>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Return Orders';
                    Image = ReturnOrder;
                    ToolTip = 'View sales return orders created for this vehicle.';

                    trigger OnAction()
                    begin
                        Rec.ShowSalesReturnOrders
                    end;
                }
            }
            group("<Action84>")
            {
                Caption = '&Purchases';
                action("<Action1101914021>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Orders';
                    Image = "Order";
                    ToolTip = 'View purchase orders created for this vehicle.';

                    trigger OnAction()
                    begin
                        Rec.ShowPurchOrders
                    end;
                }
                action("<Action1101914025>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Return Orders';
                    Image = ReturnOrder;
                    ToolTip = 'View purchase return orders created for this vehicle.';

                    trigger OnAction()
                    begin
                        Rec.ShowPurchReturnOrders
                    end;
                }
            }
            group("<Action179>")
            {
                Caption = 'Service';
                action("<Action40>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Ledger E&ntries';
                    Image = ServiceLedger;
                    ToolTip = 'View vehicle service history.';
                    RunObject = Page "Service Ledger Entries EDMS";
                    RunPageLink = "Entry Type" = const(Usage),
                                  "Vehicle Serial No." = field("Serial No.");
                    RunPageView = sorting("Vehicle Serial No.", "Entry Type", "Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                }
                action("<Action1101924021>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Orders';
                    Image = "Order";
                    ToolTip = 'View service orders created for this vehicle.';

                    trigger OnAction()
                    begin
                        Rec.ShowServOrders
                    end;
                }
                action("<Action1101924025>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Return Orders';
                    Image = ReturnOrder;
                    ToolTip = 'View service return orders created for this vehicle.';

                    trigger OnAction()
                    begin
                        Rec.ShowServReturnOrders
                    end;
                }
            }
            group(Tires)
            {
                Caption = 'Tires';
                action(Axles)
                {
                    ApplicationArea = Basic;
                    Caption = 'Axles';
                    Image = ListPage;
                    ToolTip = 'View information on axles for the vehicle.';
                    RunObject = Page "Vehicle Tire Positions";
                    RunPageLink = "Vehicle Serial No." = field("Serial No.");
                }
                action(Action1101904009)
                {
                    ApplicationArea = Basic;
                    Caption = 'Tires';
                    Image = ListPage;
                    ToolTip = 'View information on tires for the vehicle.';
                    RunObject = Page "Tire Entries";
                    RunPageLink = "Vehicle Serial No." = field("Serial No."),
                                  Open = const(true);
                }
            }
        }
        area(processing)
        {
            action(CreateInteract)
            {
                AccessByPermission = TableData Attachment = R;
                ApplicationArea = Basic;
                Caption = 'Create &Interact';
                Image = CreateInteraction;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Create an interaction with a specified vehicle.';

                trigger OnAction()
                begin
                    Rec.CreateInteraction;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //28.04.2014 Elva Baltic P8 #S0058 MMG7.00 >>
        VehicleContact.Reset;
        VehicleContact.SetRange("Vehicle Serial No.", Rec."Serial No.");
        if VehicleContact.FindFirst then begin
            VehicleContact.CalcFields("Contact Name");
            ContactName := VehicleContact."Contact Name";
        end else
            ContactName := '';
        //28.04.2014 Elva Baltic P8 #S0058 MMG7.00 <<
    end;

    trigger OnInit()
    begin
        tCountVisible := true;
        cCountVisible := true;
    end;

    trigger OnOpenPage()
    begin
        if UserProfileMgt.CurrProfileID <> '' then begin
            if recWorkPlace.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) then begin
                if recWorkPlace."Show Vehicle Count" then begin
                    cCountVisible := true;
                    tCountVisible := true;
                end
                else begin
                    cCountVisible := false;
                    tCountVisible := false;
                end;
            end;
        end;
    end;

    var
        VehicleContact: Record "Vehicle Contact";
        recWorkPlace: Record "Branch Profile Setup";
        [InDataSet]
        cCountVisible: Boolean;
        [InDataSet]
        tCountVisible: Boolean;
        PictureMgt: Codeunit "Picture Management";
        [InDataSet]
        ContactName: Text[100];
        UserProfileMgt: Codeunit UserProfileManagement;
}

