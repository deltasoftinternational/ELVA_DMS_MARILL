Report 25006014 "Serv. Orders by Customers+ R10"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ServOrdersbyCustomersR10.rdlc';
    Caption = 'Posted Service Orders by Sell-to Customers';

    dataset
    {
        dataitem("Posted Serv. Order Header"; "Posted Serv. Order Header")
        {
            RequestFilterFields = "Make Code", "Model Code", "Service Advisor", "Location Code", "Sell-to Customer No.";
            column(ReportForNavId_1; 1)
            {
            }
            column(MakeCode_PostedServOrderHeader; "Posted Serv. Order Header"."Make Code")
            {
                IncludeCaption = true;
            }
            column(ModelCode_PostedServOrderHeader; "Posted Serv. Order Header"."Model Code")
            {
                IncludeCaption = true;
            }
            column(ServicePerson_PostedServOrderHeader; "Posted Serv. Order Header"."Service Advisor")
            {
                IncludeCaption = true;
            }
            column(LocationCode_PostedServOrderHeader; "Posted Serv. Order Header"."Location Code")
            {
                IncludeCaption = true;
            }
            column(SelltoCustomerNo_PostedServOrderHeader; "Posted Serv. Order Header"."Sell-to Customer No.")
            {
                IncludeCaption = true;
            }
            column(GetFiltersExpr; GetFiltersExpr)
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
        ReportTitleLbl = 'Posted Service Orders by Sell-to Customers';
    }

    var
        GetFiltersExpr: Text[250];
}

