Report 25006012 "Serv. Ord. by Serv. Pers.+ R08"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ServOrdbyServPersR08.rdlc';
    Caption = 'Service Orders by Service Persons';

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
        ReportTitleLbl = 'Service Orders by Service Persons';
    }

    var
        GetFiltersExpr: Text[250];
}

