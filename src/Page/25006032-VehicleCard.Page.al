Page 25006032 "Vehicle Card"
{
    // 16.02.2015 EB.P7 #T022
    //   Serial No. Hiding functionality added.
    // 
    // 16.05.2014 Elva Baltic P8 #S0038 MMG7.00
    //   * PERFORMANCE ISSUE resolve: FIELD "Serv. Ledger Entry Exist" is removed by variable ServLedgerEntryExist!
    // 
    // 03.04.2014 Elva Baltic P15 # MMG7.00
    //   * Changed Reservation TAB Caption
    // 
    // 26.03.2014 Elva Baltic P18 #RX025 MMG7.00
    //   * Added Page Action "Vehicle Comments"
    // 
    // 04.03.2014 Elva Baltic P7 #S0017 MMG7.00
    //   * Added field: "Fixed Asset No."
    // 
    // 03.03.2014 Elva Baltic P08 #S0016 MMG7.00
    //   * Translate captions of actions
    // 
    // 27.02.2014 Elva Baltic P15 #F016 MMG7.00
    //   * Added "Current Location Code"
    // 
    // 19.06.2013 EDMS P8
    //   * Merged with NAV2009
    // 
    // 14.09.2007. EDMS P2
    //   * Added Menu Item "Functions -> Item Order Overview"
    // 
    // 26.07.2007. EDMS P2
    //   * Added Menu Item "Service -> History"
    // 
    // 12.06.2007. EDMS P2
    //   * Added Menu Item Vehicle -> Guarantee Information

    Caption = 'Vehicle Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Vehicle;
    SourceTableView = sorting(VIN);

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(SerialNo; rec."Serial No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = SerialNoVisible;
                    ToolTip = 'Specifies the number of the vehicle entry in system, according to the specified number series.';

                    trigger OnAssistEdit()
                    begin
                        CurrPage.Update;
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(VIN; rec.VIN)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the VIN of the vehicle.';
                }
                field(MakeCode; rec."Make Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the make code this vehicle belongs to.';
                }
                field(ModelCode; rec."Model Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the model code this vehicle belongs to.';
                }
                field(ModelVersionNo; rec."Model Version No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the model version of this vehicle. Model version is an item record and is required for vehicles when they are traded.';
                }
                field(ProductionYear; rec."Production Year")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the production year of this vehicle.';
                }
                field(FirstRegistrationDate; rec."First Registration Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date ehn this vehicle has been first registered.';
                }
                field(RegistrationNo; rec."Registration No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the registration number of this vehicle.';
                }
                field(RegistrationCertificateNo; rec."Registration Certificate No.")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the registration certificate for this vehicle.';
                }
                field(SalesDate; rec."Sales Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the vehicle was first sold. System fills this date automatically when a sales order is posted or user can enter it manually.';

                }
                field(TypeCode; rec."Type Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of the vehicle. Users can define vehicle types depending on the kinds of vehicles used in system and how detailed this categories should be.';
                }
                field(StatusCode; rec."Status Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the status of the vehicle. This defines status/ownership of the vehicle. For example, New vehicle for sale, Customer owned vehicles, vehicles for rent.';
                }
                field(TrackingCode; rec."Tracking Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the tracking information for vehicle. This can be used, for example, to specify the stage in delivery chain where vehicle currently is.';
                }
                field(InteriorCode; rec."Interior Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an interior of this vehicle.';
                }
                field(BodyColorCode; rec."Body Color Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a color of this vehicle.';
                }
                field(DefaultVehicleAccCycleNo; rec."Default Vehicle Acc. Cycle No.")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies current default accounting cycle of the vehicle. Accounting cycles can be used to distinguish separate trade cycles, for example, when vehicle is sold as new and later returns as trade-in.';
                    Lookup = false;

                    trigger OnDrillDown()
                    var
                        recVehAccCycleNo: Record "Vehicle Accounting Cycle";
                        cuLookupMgt: Codeunit LookUpManagement;
                    begin
                        recVehAccCycleNo.Reset;
                        if cuLookupMgt.LookUpVehicleAccCycle(recVehAccCycleNo, rec."Serial No.", rec."Default Vehicle Acc. Cycle No.") then;
                    end;
                }
                field(Inventory; rec.Inventory)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Shows whether vehicle is in the inventory or not.';
                }
                field(Reserved; rec.Reserved)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Shows whether vehicle is reserved in sales order.';
                }
                field(Blocked; rec.Blocked)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies if the vehicle card is blocked so that it can''t be used in documents.';
                }
                field(ServLedgerEntryExist; ServLedgerEntryExist)
                {
                    ApplicationArea = Basic;
                    Caption = 'Serv. Ledger Entry Exist';
                    DrillDown = true;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Shows whether there are any ervice ledger entries with this vehicle.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        ServiceLedgerEntry.Reset;
                        ServiceLedgerEntry.SetRange("Vehicle Serial No.", Rec."Serial No.");
                        if Format(Rec."Date Filter") <> '' then
                            ServiceLedgerEntry.SetRange("Posting Date", Rec."Date Filter");
                        Page.RunModal(Page::"Service Ledger Entries EDMS", ServiceLedgerEntry);
                    end;
                }
                field(LastDateModified; rec."Last Date Modified")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Shows the date when this vehicle card was last modified.';
                }
                field(ParentComponent; rec."Parent Component")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Shows the main vehicle card number if there are linked vehicles and this vehicle is a child in the link. For example, if this is a trailer it could show the card for the truck.';
                }
                field(Control1101901004; rec.Components)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Shows whether there are any child vehicle cards linked to this vehicle. For example, if it is a truck then it could show thether there is a linked trailer.';
                }
                field(NextVehicleInspectionDate; rec."Next Vehicle Inspection Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the next inspection for vehicle is due.';
                }
                field(CustomerNo; rec."Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer number for customer that is linked to this vehicle. It will be used when vehicle is in service.';
                }
                field(CustomerName; rec."Customer Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Shows the name of the linked customer. ';
                }
                field(CustomerServiceAddressCode; rec."Customer Service Address Code")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the default vehicle service address, if it has been defined.';
                }
                field(CustomerVehicleID; rec."Customer Vehicle ID")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the vehicle identification number used by customer.';
                }
                field(BillToCustomerNo; Rec."Bill-To Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(BillToCustomerName; Rec."Bill-To Customer Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            group(Specification)
            {
                Caption = 'Specification';
                field(VariableField25006800; rec."Variable Field 25006800")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006800Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006801; rec."Variable Field 25006801")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006801Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006802; rec."Variable Field 25006802")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006802Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006803; rec."Variable Field 25006803")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006803Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006804; rec."Variable Field 25006804")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006804Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006805; rec."Variable Field 25006805")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006805Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006806; rec."Variable Field 25006806")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006806Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006807; rec."Variable Field 25006807")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006807Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006808; rec."Variable Field 25006808")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006808Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006809; rec."Variable Field 25006809")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006809Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006810; rec."Variable Field 25006810")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006810Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006811; rec."Variable Field 25006811")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006811Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006812; rec."Variable Field 25006812")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006812Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006813; rec."Variable Field 25006813")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006813Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006814; rec."Variable Field 25006814")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006814Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006815; rec."Variable Field 25006815")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006815Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006816; rec."Variable Field 25006816")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006816Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006817; rec."Variable Field 25006817")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006817Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableFieldRun1; rec."Variable Field Run 1")
                {
                    ApplicationArea = Basic;
                    Visible = VFRun1Visible;
                    ToolTip = 'Specifies the vehicle counter information.';
                }
                field(VariableFieldRun2; rec."Variable Field Run 2")
                {
                    ApplicationArea = Basic;
                    Visible = VFRun2Visible;
                    ToolTip = 'Specifies the vehicle counter information.';
                }
                field(VariableFieldRun3; rec."Variable Field Run 3")
                {
                    ApplicationArea = Basic;
                    Visible = VFRun3Visible;
                    ToolTip = 'Specifies the vehicle counter information.';
                }
            }
            group(Specification2)
            {
                Caption = 'Specification 2';
                Visible = false;
                field(VariableField25006818; rec."Variable Field 25006818")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006818Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006819; rec."Variable Field 25006819")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006819Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006820; rec."Variable Field 25006820")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006820Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006821; rec."Variable Field 25006821")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006821Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006822; rec."Variable Field 25006822")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006822Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006823; rec."Variable Field 25006823")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006823Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006824; rec."Variable Field 25006824")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006824Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
                field(VariableField25006825; rec."Variable Field 25006825")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006825Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields. Values in these fields can be used as filters in labor standard times and service packages.';
                }
            }
            part(VehicleContacts; "Vehicle Contacts Subform")
            {
                ApplicationArea = All;
                Caption = 'Contacts';
                SubPageLink = "Vehicle Serial No." = field("Serial No.");
            }
            part(VehicleSalesPrice; "Vehicle Sales Prices")
            {
                ApplicationArea = All;
                Caption = 'Sales Price';
                SubPageLink = "Item No." = field("Model Version No."),
                              "Make Code" = field("Make Code"),
                              "Model Code" = field("Model Code"),
                              "Model Version No." = field("Model Version No."),
                              "Vehicle Serial No." = field("Serial No."),
                              "Document Profile" = const("Vehicles Trade");
            }
        }
        area(factboxes)
        {
            part(Control25006003; "Vehicle MapView FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Serial No." = field("Serial No.");
            }
            part(Control1101904030; "Vehicle Service FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Serial No." = field("Serial No.");
                Visible = true;
            }
            part(Control1101901006; "Vehicle Info FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Serial No." = field("Serial No.");
                Visible = false;
            }
            part("Vehicle Pictures"; "Object Picture FactBox")
            {
                ApplicationArea = All;
                Caption = 'Vehicle Pictures';
                SubPageLink = "Source Type" = const(Database::Vehicle),
                //              "Source Subtype" = const("0"),
                //"Source ID" = field("Serial No."),
                              "Vehicle Serial No." = field("Serial No.");
                //              "Source Ref. No." = const(0);
                SubPageView = sorting("Source Type", "Source Subtype", "Source ID", "Source Ref. No.", "No.");
            }
            systempart(Control1101904026; Links)
            {
                ApplicationArea = All;
            }
            systempart(Control1101904015; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action103>")
            {
                Caption = '&Vehicle';
                action(ServicePlans)
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Plans';
                    Image = ServiceHours;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Vehicle Service Plans";
                    RunPageLink = "Vehicle Serial No." = field("Serial No.");
                    ToolTip = 'View or edit the vehicle''s service plans. Service Plans allows to track vehicle standard maintenance schedule.';
                }
                action(ProcessChecklists)
                {
                    ApplicationArea = Basic;
                    Caption = 'Process Checklists';
                    Image = CheckList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Process Checklist List";
                    RunPageLink = "Vehicle Serial No." = field("Serial No.");
                    ToolTip = 'View or or create vehicle''s checklist. Chacklists can be used to record cases when vehicles are checked based on standartized list of checks.';
                }
                action("<Action1101904003>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Warranties';
                    Image = WarrantyLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Vehicle Warranty List";
                    RunPageLink = "Vehicle Serial No." = field("Serial No.");
                    ToolTip = 'View or edit the vehicle''s warranties. You can register differet warranty types.';
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
                                  "No." = field("Serial No.");
                    ToolTip = 'View or add comments to vehicles. This information will be visible next time when vehicle is added in service document.';
                }
                group(Entries)
                {
                    Caption = 'Entries';
                    Image = Ledger;
                    action("<Action40>")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Service Ledger E&ntries';
                        Image = ServiceLedger;
                        ShortCutKey = 'Ctrl+F7';
                        ToolTip = 'View vehicle service history.';

                        trigger OnAction()
                        begin
                            ServOrdInfoPaneMgt.LookupServiceHistory2(Rec."Serial No.");
                        end;
                    }
                    action("<Action95>")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Interaction Log E&ntries';
                        Image = InteractionLog;
                        RunObject = Page "Interaction Log Entries";
                        RunPageLink = "Contact No." = filter(<> ''),
                                      "Vehicle Serial No." = field("Serial No.");
                        RunPageView = sorting("Vehicle Serial No.");
                        ShortCutKey = 'Ctrl+F7';
                        ToolTip = 'View log of interactions that are related to this vehicle.';
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
                    action(TireEntries)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Tire Entries';
                        Image = LedgerEntries;
                        RunObject = Page "Tire Entries";
                        RunPageLink = "Vehicle Serial No." = field("Serial No.");
                        ToolTip = 'View vehicle tire entries.';
                    }
                    action("Vehicle Telematics Entries")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Vehicle Telematics Entries';
                        Image = LedgerEntries;
                        RunObject = Page "MapView Vehicle Telematics";
                        RunPageLink = "Vehicle Serial No." = field("Serial No.");
                        ToolTip = 'View vehicle telematics entries, for example, coordinates, mileage or motor hours.';
                    }
                }
                action("<Action1101904016>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Vehicle Statistics";
                    RunPageLink = "Serial No." = field("Serial No.");
                    ToolTip = 'View statistical information, such as the value of posted purchase and sales entries, total amount in service.';
                }
                group(Lists)
                {
                    Caption = 'Lists';
                    Image = Administration;
                    action(Contacts)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Contacts';
                        Image = CustomerContact;
                        RunObject = Page "Vehicle Contacts";
                        RunPageLink = "Vehicle Serial No." = field("Serial No.");
                        ToolTip = 'View or edit contacts related to this vehicle.';
                    }
                    action("<Action157>")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Options';
                        Image = CheckList;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Vehicle Option Overview";
                        RunPageLink = "Vehicle Serial No." = field("Serial No."),
                                      Open = filter(true);
                        RunPageView = sorting("Vehicle Serial No.", "Entry Type", "Option Type", "Option Code", Open);
                        ToolTip = 'View information on vehicle options.';
                    }
                    action(Tires)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Tires';
                        Image = Item;
                        RunObject = Page "Put On Tires";
                        RunPageLink = "Vehicle Serial No." = field("Serial No.");
                        ToolTip = 'View information on tires for the vehicle.';
                    }
                    action(Axles)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Axles';
                        Image = ItemGroup;
                        RunObject = Page "Vehicle Axles";
                        RunPageLink = "Vehicle Serial No." = field("Serial No.");
                        ToolTip = 'View information on axles for the vehicle.';
                    }
                    action("<Action1101914011>")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Recall Campaigns';
                        Image = Campaign;
                        RunObject = Page "Recall Campaign Vehicles";
                        RunPageLink = VIN = field(VIN);
                        ToolTip = 'View information on recalls where this vehicle is included. You can see statuses whether those are pending or cmpleted.';
                    }
                    action(Insurances)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Insurances';
                        Image = Insurance;
                        RunObject = Page "Vehicle Insurance";
                        RunPageLink = "Vehicle Serial No." = field("Serial No.");
                        ToolTip = 'View information on insurances for the vehicle.';
                    }
                    action(Components)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Components';
                        Image = Components;
                        RunObject = Page "Vehicle Components";
                        RunPageLink = "Parent Vehicle Serial No." = field("Serial No.");
                        ToolTip = 'View information on components for the vehicle.';
                    }
                }
                action("<Action1101904007>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Order Overview';
                    Image = "Order";
                    Promoted = true;
                    PromotedCategory = Process;
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
                action("<Page Object Picture>")
                {
                    ApplicationArea = Basic;
                    Caption = '&Pictures';
                    Image = Picture;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page Pictures;
                    RunPageLink = "Vehicle Serial No." = field("Serial No."),
                                    "Source Type" = const(Database::Vehicle);
                    RunPageMode = View;
                    ToolTip = 'View or add pictures for the vehicle.';

                    trigger OnAction()
                    begin
                        // 1st par 25006005 - Vehicle
                        //PictureMgt.ShowObjectPictures(25006005,0,"Serial No.",0)
                    end;
                }
                action(PageDimensionsAction)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = const(Database::Vehicle),
                                  "No." = field("Serial No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit default vehicle dimensions.';
                }
                action("<Action1101904031>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Change Log';
                    Image = ChangeLog;
                    RunObject = Page "Vehicle Change Log";
                    RunPageLink = "Vehicle Serial No." = field("Serial No.");
                    ToolTip = 'View vehicle change log entries.';
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
            }
            group("<Action79>")
            {
                Caption = 'S&ales';
                action("<Action82>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Prices';
                    Image = SalesPrices;
                    ToolTip = 'View or edit sales prices for this vehicle.';
                    RunObject = Page "Model Version Sales Prices";
                    RunPageLink = "Item No." = field("Model Version No."),
                                  "Vehicle Serial No." = field("Serial No.");
                }
                action("<Action80>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Line Discounts';
                    Image = SalesLineDisc;
                    ToolTip = 'View or edit sales line discounts for this vehicle.';
                    RunObject = Page "Model Version Sales Line Disc.";
                    RunPageLink = Type = const(Item),
                                  Code = field("Model Version No."),
                                  "Vehicle Serial No." = field("Serial No.");
                }
                group(VehicleDocuments)
                {
                    Caption = 'Vehicle Documents';
                    Image = Document;
                    action(Quotes)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Quotes';
                        Image = Document;
                        ToolTip = 'View sales quotes created for this vehicle.';

                        trigger OnAction()
                        begin
                            LookupMgt.ShowSalesDocOfVehicle(0, Rec."Serial No.");
                        end;
                    }
                    action("<Action1101904021>")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Orders';
                        Image = Document;
                        ToolTip = 'View sales orders created for this vehicle.';

                        trigger OnAction()
                        begin
                            Rec.ShowSalesOrders
                        end;
                    }
                    action(SaleInvAction)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Invoices';
                        Image = Invoice;
                        ToolTip = 'View sales invoices created for this vehicle.';

                        trigger OnAction()
                        begin
                            LookupMgt.ShowSalesDocOfVehicle(2, Rec."Serial No.");
                        end;
                    }
                    action("<Action1101904025>")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Return Orders';
                        Image = ReturnOrder;
                        ToolTip = 'View sales return orders created for this vehicle.';

                        trigger OnAction()
                        begin
                            Rec.ShowSalesReturnOrders
                        end;
                    }
                    action(PostedInvoices)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posted Invoices';
                        Image = PostedPayment;
                        ToolTip = 'View posted sales invoices created for this vehicle.';

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPostedSalesDocOfVehicle(0, Rec."Serial No.");
                        end;
                    }
                    action(PostedCreditMemos)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posted Credit Memos';
                        Image = PostedCreditMemo;
                        ToolTip = 'View posted sales credit memos created for this vehicle.';

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPostedSalesDocOfVehicle(1, Rec."Serial No.");
                        end;
                    }
                    action(PostedShipments)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posted Shipments';
                        Image = Shipment;
                        ToolTip = 'View posted sales shipments created for this vehicle.';

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPostedSalesDocOfVehicle(2, Rec."Serial No.");
                        end;
                    }
                    action(PostedReturnReceipts)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posted Return Receipts';
                        Image = ReturnReceipt;
                        ToolTip = 'View posted sales return receipts created for this vehicle.';

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPostedSalesDocOfVehicle(3, Rec."Serial No.");
                        end;
                    }
                }
                group(SparePartsDocuments)
                {
                    Caption = 'Spare Parts Documents';
                    Image = Document;
                    action(SparePartsQuotesAction)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Quotes';
                        Image = Quote;
                        ToolTip = 'View spare parts sales quotes related to this vehicle.';

                        trigger OnAction()
                        begin
                            LookupMgt.ShowSPartsSalesDocOfVehicle(0, Rec."Serial No.");
                        end;
                    }
                    action(SparePartsOrdersAction)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Orders';
                        Image = "Order";
                        ToolTip = 'View spare parts sales orders related to this vehicle.';

                        trigger OnAction()
                        begin
                            LookupMgt.ShowSPartsSalesDocOfVehicle(1, Rec."Serial No.");
                        end;
                    }
                    action(SparePartsInvAction)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Invoices';
                        Image = Invoice;
                        ToolTip = 'View spare parts sales invoices related to this vehicle.';

                        trigger OnAction()
                        begin
                            LookupMgt.ShowSPartsSalesDocOfVehicle(2, Rec."Serial No.");
                        end;
                    }
                    action(SparePartsRetAction)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Return Orders';
                        Image = ReturnOrder;
                        ToolTip = 'View spare parts sales return orders related to this vehicle.';

                        trigger OnAction()
                        begin
                            LookupMgt.ShowSPartsSalesDocOfVehicle(3, Rec."Serial No.");
                        end;
                    }
                    action(Action23)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posted Invoices';
                        Image = Invoice;
                        ToolTip = 'View spare parts posted sales invoices related to this vehicle.';

                        trigger OnAction()
                        begin
                            LookupMgt.ShowSPartsPostedSalesDocOfVehicle(0, Rec."Serial No.");
                        end;
                    }
                    action(Action26)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posted Credit Memos';
                        Image = PostedCreditMemo;
                        ToolTip = 'View spare parts posted sales credit memos related to this vehicle.';

                        trigger OnAction()
                        begin
                            LookupMgt.ShowSPartsPostedSalesDocOfVehicle(1, Rec."Serial No.");
                        end;
                    }
                    action(Action35)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posted Shipments';
                        Image = Shipment;
                        ToolTip = 'View spare parts posted sales shipments related to this vehicle.';

                        trigger OnAction()
                        begin
                            LookupMgt.ShowSPartsPostedSalesDocOfVehicle(2, Rec."Serial No.");
                        end;
                    }
                    action(Action36)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posted Return Receipts';
                        Image = ReturnReceipt;
                        ToolTip = 'View spare parts posted sales return receipts related to this vehicle.';

                        trigger OnAction()
                        begin
                            LookupMgt.ShowSPartsPostedSalesDocOfVehicle(3, Rec."Serial No.");
                        end;
                    }
                }
            }
            group("<Action84>")
            {
                Caption = '&Purchases';
                group(ActionGroup56)
                {
                    Caption = 'Vehicle Documents';
                    Image = Document;
                    action(Action55)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Quotes';
                        Image = Document;
                        ToolTip = 'View purchase quotes created for this vehicle.';

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPurchaseDocOfVehicle(0, Rec."Serial No.");
                        end;
                    }
                    action(Orders)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Orders';
                        Image = Document;
                        ToolTip = 'View purchase orders created for this vehicle.';

                        trigger OnAction()
                        begin
                            Rec.ShowPurchOrders
                        end;
                    }
                    action(Invoices)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Invoices';
                        Image = Invoice;
                        ToolTip = 'View purchase invoices created for this vehicle.';

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPurchaseDocOfVehicle(2, Rec."Serial No.");
                        end;
                    }
                    action(ReturnOrders)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Return Orders';
                        Image = ReturnOrder;
                        ToolTip = 'View purchase return orders created for this vehicle.';

                        trigger OnAction()
                        begin
                            Rec.ShowPurchReturnOrders
                        end;
                    }
                    action(Action51)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posted Invoices';
                        Image = PostedPayment;
                        ToolTip = 'View posted purchase invoices created for this vehicle.';

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPostedPurchaseDocOfVehicle(0, Rec."Serial No.");
                        end;
                    }
                    action(Action50)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posted Credit Memos';
                        Image = PostedCreditMemo;
                        ToolTip = 'View posted purchase credit memos created for this vehicle.';

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPostedPurchaseDocOfVehicle(1, Rec."Serial No.");
                        end;
                    }
                    action(PostedReturnShipments)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posted Return Shipments';
                        Image = Shipment;
                        ToolTip = 'View posted purchase return shipments created for this vehicle.';

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPostedPurchaseDocOfVehicle(2, Rec."Serial No.");
                        end;
                    }
                    action(PostedReceipts)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posted Receipts';
                        Image = ReturnReceipt;
                        ToolTip = 'View posted purchase receipts created for this vehicle.';

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPostedPurchaseDocOfVehicle(3, Rec."Serial No.");
                        end;
                    }
                }
            }
            group("<Action179>")
            {
                Caption = 'Service';
                group(ActualDocuments)
                {
                    Caption = 'Actual Documents';
                    Image = Sales;
                    action(Action11)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Quotes';
                        Image = Document;
                        ToolTip = 'View service quotes created for this vehicle.';

                        trigger OnAction()
                        begin
                            LookupMgt.ShowServiceDocOfVehicle(0, Rec."Serial No.");
                        end;
                    }
                    action("<Action1101924021>")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Orders';
                        Image = Document;
                        ToolTip = 'View service orders created for this vehicle.';

                        trigger OnAction()
                        begin
                            Rec.ShowServOrders
                        end;
                    }
                    action(ServInvAction)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Invoices';
                        Image = Invoice;
                        ToolTip = 'View service invoices created for this vehicle.';

                        trigger OnAction()
                        begin
                            LookupMgt.ShowServiceDocOfVehicle(3, Rec."Serial No.");
                        end;
                    }
                    action("<Action1101924025>")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Return Orders';
                        Image = ReturnOrder;
                        ToolTip = 'View service return orders created for this vehicle.';

                        trigger OnAction()
                        begin
                            Rec.ShowServReturnOrders
                        end;
                    }
                }
                group(PostedDocuments)
                {
                    Caption = 'Posted Documents';
                    Image = RegisteredDocs;
                    action(ServPostOrdAction)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posted Orders';
                        Image = PostedServiceOrder;
                        ToolTip = 'View posted service orders created for this vehicle.';

                        trigger OnAction()
                        begin
                            //Order,Invoice,Credit Memo,Return Order
                            LookupMgt.ShowPostedServiceDocOfVehicle(0, Rec."Serial No.");
                        end;
                    }
                    action(ServPostInvAction)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posted Invoices';
                        Image = Invoice;
                        ToolTip = 'View posted service invoices created for this vehicle.';

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPostedServiceDocOfVehicle(1, Rec."Serial No.");
                        end;
                    }
                    action(ServPostCrMemAction)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posted Credit Memos';
                        Image = PostedMemo;
                        ToolTip = 'View posted service credit memos created for this vehicle.';

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPostedServiceDocOfVehicle(2, Rec."Serial No.");
                        end;
                    }
                    action(ServPostRetOrdAction)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posted Return Orders';
                        Image = PostedReturnReceipt;
                        ToolTip = 'View posted service return orders created for this vehicle.';

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPostedServiceDocOfVehicle(3, Rec."Serial No.");
                        end;
                    }
                    action(PostedTransferShipments)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posted Transfer Shipments';
                        Image = Shipment;
                        ToolTip = 'View posted transfer shipments related to service orders created for this vehicle.';

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPostedServiceDocOfVehicle(4, Rec."Serial No.");
                        end;
                    }
                    action(PostedTransferReceipts)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posted Transfer Receipts';
                        Image = ReturnReceipt;
                        ToolTip = 'View posted transfer receipts related to service orders created for this vehicle.';

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPostedServiceDocOfVehicle(5, Rec."Serial No.");
                        end;
                    }
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
        Rec.CalcFields("Serv. Ledger Entry Exist");
        ServLedgerEntryExist := Rec."Serv. Ledger Entry Exist";
    end;

    trigger OnInit()
    begin
        SetVariableFields;
    end;

    trigger OnOpenPage()
    begin
        SetSerialNoVisible;
    end;

    var
        ServiceLedgerEntry: Record "Service Ledger Entry EDMS";
        LookupMgt: Codeunit LookUpManagement;
        EDMSMGT: Codeunit "Vehicle Proposal Mgt. EDMS";
        ServOrdInfoPaneMgt: Codeunit "Service Info-Pane Mgt. EDMS";
        [InDataSet]
        VF25006800Visible: Boolean;
        [InDataSet]
        VF25006801Visible: Boolean;
        [InDataSet]
        VF25006802Visible: Boolean;
        [InDataSet]
        VF25006803Visible: Boolean;
        [InDataSet]
        VF25006804Visible: Boolean;
        [InDataSet]
        VF25006805Visible: Boolean;
        [InDataSet]
        VF25006806Visible: Boolean;
        [InDataSet]
        VF25006807Visible: Boolean;
        [InDataSet]
        VF25006808Visible: Boolean;
        [InDataSet]
        VF25006809Visible: Boolean;
        [InDataSet]
        VF25006810Visible: Boolean;
        [InDataSet]
        VF25006811Visible: Boolean;
        [InDataSet]
        VF25006812Visible: Boolean;
        [InDataSet]
        VF25006813Visible: Boolean;
        [InDataSet]
        VF25006814Visible: Boolean;
        [InDataSet]
        VF25006815Visible: Boolean;
        [InDataSet]
        VF25006816Visible: Boolean;
        [InDataSet]
        VF25006817Visible: Boolean;
        [InDataSet]
        VF25006818Visible: Boolean;
        [InDataSet]
        VF25006819Visible: Boolean;
        [InDataSet]
        VF25006820Visible: Boolean;
        [InDataSet]
        VF25006821Visible: Boolean;
        [InDataSet]
        VF25006822Visible: Boolean;
        [InDataSet]
        VF25006823Visible: Boolean;
        [InDataSet]
        VF25006824Visible: Boolean;
        [InDataSet]
        VF25006825Visible: Boolean;
        [InDataSet]
        VFRun1Visible: Boolean;
        [InDataSet]
        VFRun2Visible: Boolean;
        [InDataSet]
        VFRun3Visible: Boolean;
        ServLedgerEntryExist: Boolean;
        SerialNoVisible: Boolean;


    procedure SetVariableFields()
    begin
        VF25006800Visible := rec.IsVFActive(25006800);
        VF25006801Visible := rec.IsVFActive(25006801);
        VF25006802Visible := rec.IsVFActive(25006802);
        VF25006803Visible := rec.IsVFActive(25006803);
        VF25006804Visible := rec.IsVFActive(25006804);
        VF25006805Visible := rec.IsVFActive(25006805);
        VF25006806Visible := rec.IsVFActive(25006806);
        VF25006807Visible := rec.IsVFActive(25006807);
        VF25006808Visible := rec.IsVFActive(25006808);
        VF25006809Visible := rec.IsVFActive(25006809);
        VF25006810Visible := rec.IsVFActive(25006810);
        VF25006811Visible := rec.IsVFActive(25006811);
        VF25006812Visible := rec.IsVFActive(25006812);
        VF25006813Visible := rec.IsVFActive(25006813);
        VF25006814Visible := rec.IsVFActive(25006814);
        VF25006815Visible := rec.IsVFActive(25006815);
        VF25006816Visible := rec.IsVFActive(25006816);
        VF25006817Visible := rec.IsVFActive(25006817);
        VF25006818Visible := rec.IsVFActive(25006818);
        VF25006819Visible := rec.IsVFActive(25006819);
        VF25006820Visible := rec.IsVFActive(25006820);
        VF25006821Visible := rec.IsVFActive(25006821);
        VF25006822Visible := rec.IsVFActive(25006822);
        VF25006823Visible := rec.IsVFActive(25006823);
        VF25006824Visible := rec.IsVFActive(25006824);
        VF25006825Visible := rec.IsVFActive(25006825);
        VFRun1Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 1"));
        VFRun2Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 2"));
        VFRun3Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 3"));
    end;

    local procedure SetSerialNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
    begin
        // SerialNoVisible := DocumentNoVisibility.VehicleSerialNoIsVisible("Serial No.");
        SerialNoVisible := EDMSMGT.VehicleSerialNoIsVisible(rec."Serial No.");
    end;
}

