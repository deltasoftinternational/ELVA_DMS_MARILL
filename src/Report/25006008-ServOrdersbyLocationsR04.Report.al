Report 25006008 "Serv. Orders by Locations R04"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ServOrdersbyLocationsR04.rdlc';
    Caption = 'Service Orders by Locations';

    dataset
    {
        dataitem("Service Header EDMS"; "Service Header EDMS")
        {
            DataItemTableView = where("Document Type" = const(Order));
            RequestFilterFields = "Make Code", "Model Code", "Service Advisor", "Location Code", "Sell-to Customer No.";
            column(ReportForNavId_1; 1)
            {
            }
            column(MakeCode_ServiceHeaderEDMS; "Service Header EDMS"."Make Code")
            {
                IncludeCaption = true;
            }
            column(ModelCode_ServiceHeaderEDMS; "Service Header EDMS"."Model Code")
            {
                IncludeCaption = true;
            }
            column(ServicePerson_ServiceHeaderEDMS; "Service Header EDMS"."Service Advisor")
            {
                IncludeCaption = true;
            }
            column(LocationCode_ServiceHeaderEDMS; "Service Header EDMS"."Location Code")
            {
                IncludeCaption = true;
            }
            column(SelltoCustomerNo_ServiceHeaderEDMS; "Service Header EDMS"."Sell-to Customer No.")
            {
                IncludeCaption = true;
            }
            column(GetFiltersExpr_ServiceHeaderEDMS; GetFiltersExpr)
            {
            }

            trigger OnPreDataItem()
            begin
                GetFiltersExpr := GetFilters;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        ReportTitleLbl = 'Service Orders by Locations';
    }

    var
        GetFiltersExpr: Text[250];
}

