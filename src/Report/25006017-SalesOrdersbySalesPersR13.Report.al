Report 25006017 "Sales Orders by SalesPers. R13"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/SalesOrdersbySalesPersR13.rdlc';
    Caption = 'Sales Orders by SalesPersons';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = where("Document Type" = const(Order), "Document Profile" = const("Vehicles Trade"));
            RequestFilterFields = "Make Code", "Model Code", "Salesperson Code", "Location Code", "Sell-to Customer No.";
            column(ReportForNavId_1; 1)
            {
            }
            column(No_SalesHeader; "Sales Header"."No.")
            {
                IncludeCaption = true;
            }
            column(SalesPerson_SalesHeader; "Sales Header"."Salesperson Code")
            {
                IncludeCaption = true;
            }
            column(LocationCode_SalesHeader; "Sales Header"."Location Code")
            {
                IncludeCaption = true;
            }
            column(SelltoCustomerNo_SalesHeader; "Sales Header"."Sell-to Customer No.")
            {
                IncludeCaption = true;
            }
            column(GetFiltersExpr; GetFiltersExpr)
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                column(ReportForNavId_3; 3)
                {
                }
                column(MakeCode_SalesLine; "Sales Line"."Make Code")
                {
                    IncludeCaption = true;
                }
                column(ModelCode_SalesLine; "Sales Line"."Model Code")
                {
                    IncludeCaption = true;
                }
                column(Quantity_SalesLine; "Sales Line".Quantity)
                {
                    IncludeCaption = true;
                }
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
        ReportTitleLbl = 'Sales Orders by SalesPersons';
    }

    var
        GetFiltersExpr: Text[250];
}

