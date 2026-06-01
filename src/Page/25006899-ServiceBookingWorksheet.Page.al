Page 25006899 "Service Booking Worksheet"
{
    DataCaptionExpression = PageCaptionText;
    PageType = Worksheet;
    PromotedActionCategories = 'Test1,Test2,Test3,Booking,Period';
    SourceTable = "Service Header EDMS";
    SourceTableView = where("Document Type" = const(Booking));

    layout
    {
        area(content)
        {
            group(Control25006032)
            {
                field(SelectedDate; SelectedDateTxt)
                {
                    ApplicationArea = Basic;
                    AssistEdit = true;
                    Caption = 'Selected Date';
                    Editable = false;
                    Lookup = true;

                    trigger OnAssistEdit()
                    var
                        BookingCalendar: Page "Service Booking Calendar";
                    begin
                        BookingCalendar.SetSelectedDate(SelectedDate);
                        BookingCalendar.SetLocationCode(LocationCode);

                        if BookingCalendar.RunModal = Action::OK then begin
                            SelectedDate := BookingCalendar.GetSelectedDate();
                            SelectedDateTxt := Format(SelectedDate);
                            CurrPage.ServiceBookingChart.Page.SetSelectedDate(SelectedDate);
                            CurrPage.ServiceBookingChart.Page.SetLocationCode(LocationCode);
                            CurrPage.ServiceBookingChart.Page.UpdateChart;

                            rec.FilterGroup(2);
                            rec.SetFilter("Requested Starting Date", '..%1', SelectedDate);
                            rec.SetFilter("Requested Finishing Date", '%1..', SelectedDate);
                            rec.SetRange("Location Code", LocationCode);
                            rec.FilterGroup(0);
                            CurrPage.Update(false);
                        end;
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        BookingCalendar: Page "Service Booking Calendar";
                    begin
                        BookingCalendar.SetSelectedDate(SelectedDate);
                        BookingCalendar.SetLocationCode(LocationCode);

                        if BookingCalendar.RunModal = Action::OK then begin
                            SelectedDate := BookingCalendar.GetSelectedDate();
                            SelectedDateTxt := Format(SelectedDate);
                            CurrPage.ServiceBookingChart.Page.SetSelectedDate(SelectedDate);
                            CurrPage.ServiceBookingChart.Page.SetLocationCode(LocationCode);
                            CurrPage.ServiceBookingChart.Page.UpdateChart;

                            rec.FilterGroup(2);
                            rec.SetFilter("Requested Starting Date", '..%1', SelectedDate);
                            rec.SetFilter("Requested Finishing Date", '%1..', SelectedDate);
                            rec.SetRange("Location Code", LocationCode);
                            rec.FilterGroup(0);
                            CurrPage.Update(false);
                        end;
                    end;
                }
                field(LocationCode; LocationCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Location Code';

                    trigger OnAssistEdit()
                    var
                        SelectedLocation: Record Location;
                        ServiceBooking: Record "Service Header EDMS";
                    begin
                        SelectedLocation.SetRange("Use As Service Location", true);
                        if LocationCode <> '' then
                            SelectedLocation.Get(LocationCode);

                        if Page.RunModal(Page::"Location List", SelectedLocation) = Action::LookupOK then
                            LocationCode := SelectedLocation.Code;

                        SetPageCaption;
                        rec.FilterGroup(2);
                        rec.SetFilter("Requested Starting Date", '..%1', SelectedDate);
                        rec.SetFilter("Requested Finishing Date", '%1..', SelectedDate);
                        rec.SetRange("Location Code", LocationCode);
                        rec.FilterGroup(0);
                        CurrPage.Update(false);

                        CurrPage.ServiceBookingChart.Page.SetSelectedDate(SelectedDate);
                        CurrPage.ServiceBookingChart.Page.SetLocationCode(LocationCode);
                        CurrPage.ServiceBookingChart.Page.UpdateChart;
                    end;

                    trigger OnValidate()
                    begin
                        SetPageCaption;
                        rec.FilterGroup(2);
                        rec.SetFilter("Requested Starting Date", '..%1', SelectedDate);
                        rec.SetFilter("Requested Finishing Date", '%1..', SelectedDate);
                        rec.SetRange("Location Code", LocationCode);
                        rec.FilterGroup(0);
                        CurrPage.Update(false);

                        CurrPage.ServiceBookingChart.Page.SetSelectedDate(SelectedDate);
                        CurrPage.ServiceBookingChart.Page.SetLocationCode(LocationCode);
                        CurrPage.ServiceBookingChart.Page.UpdateChart;
                    end;
                }
            }
            repeater(Control25006011)
            {
                field(RequestedStartingDate; rec."Requested Starting Date")
                {
                    ApplicationArea = Basic;
                }
                field(RequestedStartingTime; rec."Requested Starting Time")
                {
                    ApplicationArea = Basic;
                }
                field(RequestedFinishingDate; rec."Requested Finishing Date")
                {
                    ApplicationArea = Basic;
                }
                field(RequestedFinishingTime; rec."Requested Finishing Time")
                {
                    ApplicationArea = Basic;
                }
                field(DealType; rec."Deal Type")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleRegistrationNo; rec."Vehicle Registration No.")
                {
                    ApplicationArea = Basic;
                }
                field(MakeCode; rec."Make Code")
                {
                    ApplicationArea = Basic;
                }
                field(ModelCode; rec."Model Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(TotalWorkHours; rec."Total Work (Hours)")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCustomerNo; rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCustomerName; rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field(WorkStatusCode; rec."Work Status Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(DueDate; rec."Due Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Control25006016; rec."Location Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ServiceAdvisor; rec."Service Advisor")
                {
                    ApplicationArea = Basic;
                }
                field(No; rec."No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(TCardContainerEntryNo; rec."TCard Container Entry No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ResourceNo; rec."Booking Resource No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Resource No.';
                }
            }
            group(Control25006001)
            {
                Caption = '';
                part(ServiceBookingChart; "Service Booking Chart")
                {
                    ApplicationArea = All;
                    UpdatePropagation = Both;
                }
            }
        }
        area(factboxes)
        {
            part(Control25006006; "Service Document FactBox EDMS")
            {
                ApplicationArea = All;
                SubPageLink = "Document Type" = field("Document Type"),
                              "No." = field("No.");
                Visible = true;
            }
            part("Vehicle Pictures"; "Object Picture FactBox")
            {
                ApplicationArea = All;
                Caption = 'Vehicle Pictures';
                SubPageLink = "Source Type" = const(Database::Vehicle),
                              "Source Subtype" = const("0"),
                              "Source ID" = field("Vehicle Serial No."),
                              "Source Ref. No." = const(0);
                SubPageView = sorting("Source Type", "Source Subtype", "Source ID", "Source Ref. No.", "No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Booking)
            {
                Caption = 'Booking';
                action(Refresh)
                {
                    ApplicationArea = Basic;
                    Image = Refresh;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        CurrPage.ServiceBookingChart.Page.SetSelectedDate(SelectedDate);
                        CurrPage.ServiceBookingChart.Page.SetLocationCode(LocationCode);
                        CurrPage.ServiceBookingChart.Page.UpdateChart;
                    end;
                }
            }
            group(Period)
            {
                Caption = 'Period';
                action(Previous)
                {
                    ApplicationArea = Basic;
                    Image = PreviousSet;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        SelectedDate := SelectedDate - 1;
                        SelectedDateTxt := Format(SelectedDate);
                        rec.FilterGroup(2);
                        rec.SetFilter("Requested Starting Date", '..%1', SelectedDate);
                        rec.SetFilter("Requested Finishing Date", '%1..', SelectedDate);
                        rec.SetRange("Location Code", LocationCode);
                        rec.FilterGroup(0);

                        CurrPage.ServiceBookingChart.Page.SetSelectedDate(SelectedDate);
                        CurrPage.ServiceBookingChart.Page.SetLocationCode(LocationCode);
                        CurrPage.ServiceBookingChart.Page.UpdateChart;
                    end;
                }
                action(Next)
                {
                    ApplicationArea = Basic;
                    Image = NextSet;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        SelectedDate := SelectedDate + 1;
                        SelectedDateTxt := Format(SelectedDate);
                        rec.FilterGroup(2);
                        rec.SetFilter("Requested Starting Date", '..%1', SelectedDate);
                        rec.SetFilter("Requested Finishing Date", '%1..', SelectedDate);
                        rec.SetRange("Location Code", LocationCode);
                        rec.FilterGroup(0);

                        CurrPage.ServiceBookingChart.Page.SetSelectedDate(SelectedDate);
                        CurrPage.ServiceBookingChart.Page.SetLocationCode(LocationCode);
                        CurrPage.ServiceBookingChart.Page.UpdateChart;
                    end;
                }
            }
        }
        area(navigation)
        {
            group(ActionGroup25006033)
            {
                Caption = 'Booking';
                action("Booking Card")
                {
                    ApplicationArea = Basic;
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Service Booking";
                    RunPageLink = "Document Type" = field("Document Type"),
                                  "No." = field("No.");
                    RunPageMode = View;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        if RecordModified = true then begin
            RecordModified := false;
            CurrPage.ServiceBookingChart.Page.SetSelectedDate(SelectedDate);
            CurrPage.ServiceBookingChart.Page.SetLocationCode(LocationCode);
            CurrPage.ServiceBookingChart.Page.UpdateChart;
        end;
    end;

    trigger OnInit()
    begin
        LocationCode := BookingMgt.GetDefaultLocationCode;
        SelectedDate := WorkDate;
        SelectedDateTxt := Format(SelectedDate);
        SetPageCaption;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        RecordModified := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        rec."Requested Starting Date" := xRec.GetRangemax("Requested Starting Date");
        rec."Requested Finishing Date" := xRec.GetRangemax("Requested Starting Date");
        rec."Requested Starting Time" := Time;
        rec."Requested Finishing Time" := Time;
    end;

    trigger OnOpenPage()
    begin
        rec.FilterGroup(2);
        rec.SetFilter("Requested Starting Date", '..%1', SelectedDate);
        rec.SetFilter("Requested Finishing Date", '%1..', SelectedDate);
        rec.SetRange("Location Code", LocationCode);
        rec.FilterGroup(0);
        CurrPage.Update(false);
    end;

    var
        LocationCode: Code[20];
        BookingDashboardLbl: label 'Booking Dashboard';
        PageCaptionText: Text[255];
        BookingMgt: Codeunit "Booking Management";
        ChartIsReady: Boolean;
        BookingChartMgt: Codeunit "Service Booking Chart Mgt.";
        BusChartBuf: Record "Business Chart Buffer";
        SelectedDate: Date;
        SelectedDateTxt: Text[10];
        RecordModified: Boolean;

    local procedure SetPageCaption()
    var
        EditModeCaption: Text[20];
        Location: Record Location;
        PageCaptionSep: Text[3];
    begin
        if LocationCode <> '' then
            PageCaptionSep := ' - '
        else
            PageCaptionSep := '';

        if Location.Get(LocationCode) then
            PageCaptionText := BookingDashboardLbl + PageCaptionSep + Location.Name
        else
            PageCaptionText := BookingDashboardLbl + PageCaptionSep + LocationCode;
    end;


    procedure GetSelectedDate(): Date
    begin
        exit(SelectedDate);
    end;
}

