report 25006112 "BLS Leasing Schedule"
{

    DefaultLayout = RDLC;
    RDLCLayout = './BLSLeasingSchedule.rdl';


    dataset
    {
        dataitem(ScheduleHeader; "BLS Leasing Schedule Header")
        {
            CalcFields = "Veh. Model Code";
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            column(CompanyLogo; CompanyInfo.Picture)
            {
            }
            column(No_ScheduleHeader; "No.")
            {
                IncludeCaption = true;
            }
            column(PrintDate; FORMAT(WORKDATE))
            {
            }
            column(CustomerNo_ScheduleHeader; "Customer No.")
            {
            }
            column(CustomerName_ScheduleHeader; "Customer Name")
            {
            }
            column(CustAddr; Customer.Address)
            {
            }
            column(CustAddr2; Customer."Address 2")
            {
            }
            column(CustCounty; Customer.County)
            {
            }
            column(CustCity; Customer.City)
            {
            }
            column(CustPostCode; Customer."Post Code")
            {
            }
            column(CustCountryName; Country.Name)
            {
            }
            column(CurrCode; "Currency Code")
            {
            }
            column(ContractNo; "Contract No.")
            {
                IncludeCaption = true;
            }
            column(VehicleSerialNo; Vehicle."Serial No.")
            {
            }
            column(VehModelCode; "Veh. Model Code")
            {
            }
            column(Description; Description)
            {
            }
            column(FooterTxt; STRSUBSTNO(FooterTxt, LeasePeriodFrom, LeasePeriodTo))
            {
            }
            column(ShowNewVATAmt; ShowNewVATAmt)
            {
            }
            dataitem(ScheduleLine; "BLS Leasing Schedule Line")
            {
                DataItemLink = "Leasing Schedule No." = FIELD("No.");
                DataItemTableView = SORTING("Leasing Schedule No.", "Line No.")
                                    ORDER(Ascending);
                RequestFilterFields = "Payment Date";
                column(ToDate_ScheduleLine; FORMAT("Payment Date"))
                {
                }

                column(AddServiceAmountInclVAT_ScheduleLine; "Add. Service Amount Incl. VAT")
                {
                }

                column(RemainingAmount_ScheduleLine; "Ending Balance")
                {
                }
            }

            trigger OnAfterGetRecord()
            var
                SchedLine: Record "BLS Leasing Schedule Line";
            begin
                CLEAR(Customer);
                CLEAR(Country);
                CLEAR(DMSContractLine);
                CLEAR(Vehicle);

                IF "Customer No." <> '' THEN
                    Customer.GET("Customer No.");

                IF "Customer Name" = '' THEN
                    "Customer Name" := Customer.Name;

                IF Customer."Country/Region Code" <> '' THEN
                    Country.GET(Customer."Country/Region Code");

                "Currency Code" := GLSetup.GetCurrencyCode("Currency Code");

                IF "Vehicle Serial No." <> '' THEN
                    Vehicle.GET("Vehicle Serial No.");

            end;

            trigger OnPreDataItem()
            begin
                FINDFIRST;
                SETRANGE("No.", "No.");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(LeasePeriodFrom; LeasePeriodFrom)
                    {
                        Caption = 'Lease Period From';
                        ApplicationArea = All;
                    }
                    field(LeasePeriodTo; LeasePeriodTo)
                    {
                        Caption = 'Lease Period To';
                        ApplicationArea = All;
                    }
                    field(ShowNewVATAmt; ShowNewVATAmt)
                    {
                        Caption = 'Show New VAT Amount';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        ReportNameCaption = 'VAT SCHEDULE';
        PageCaption = 'Page';
        DateCaption = 'Date';
        ModelCodeCaption = 'Model Code';
        SerialNoCaption = 'Serial No.';
        InvPmtDateCaption = 'Invoice / Payment Date';
        AmtExclVATCaption = 'Amount Nett of VAT';
        VATCaption = 'VAT';
        AmtInclVATCaption = 'Total Incl. VAT';
        PeriodFromCaption = 'Period From';
        PeriodToCaption = 'Period To';
    }

    trigger OnPreReport()
    begin
        IF (LeasePeriodFrom = 0D) OR (LeasePeriodTo = 0D) THEN
            ERROR(EmptyLeasePeriodErr);

        GLSetup.GET;
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        DMSContractLine: Record "DMS Contract Line";
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        Country: Record "Country/Region";
        Customer: Record "Customer";
        EmptyLeasePeriodErr: Label 'Empty Lease Period';
        FooterTxt: Label 'These are your invoices on the above lease for the period %1 to %2 inclusive. Please retain them carefully. If you are registered for VAT, you may be entitled to claim an input credit for the VAT content of the rental charged in respect of this lease agreement. Please note that in respect of any particular VAT accounting period, input credit can only be claimed in respect of the VAT content on the rentals invoiced during that VAT accounting period. In the event that the VAT rate is altered rental entries for subsequent dates shall not have effect, rental entries for subsequent dates will be credited and re-invoiced.';
        Vehicle: Record Vehicle;
        LeasePeriodFrom: Date;
        LeasePeriodTo: Date;
        ShowNewVATAmt: Boolean;
}