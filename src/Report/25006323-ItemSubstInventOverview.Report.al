Report 25006323 "Item Subst. Invent. Overview"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ItemSubstInventOverview.rdlc';
    Caption = 'Item Substitution Inventory Overview';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Item Substitution"; "Item Substitution")
        {
            DataItemTableView = where("Substitute Type" = const("Nonstock Item"), "Replacement Info." = const(Replace), Type = const("Nonstock Item"));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Posting Date";
            column(ReportForNavId_25006000; 25006000)
            {
            }
            column(No_ItemSubst; "Item Substitution"."No.")
            {
                IncludeCaption = true;
            }
            column(Description_ItemSubst; "Item Substitution".Description)
            {
                IncludeCaption = true;
            }
            column(Type_ItemSubst; "Item Substitution".Type)
            {
                IncludeCaption = true;
            }
            column(Filter_Substitution; 'Yes')
            {
            }
            dataitem("Nonstock Item"; "Nonstock Item")
            {
                DataItemLink = "Entry No." = field("No.");
                PrintOnlyIfDetail = true;
                column(ReportForNavId_25006002; 25006002)
                {
                }
                column(EntryNo_NonstockItem; "Nonstock Item"."Entry No.")
                {
                    IncludeCaption = true;
                }
                column(ItemNo_NonstockItem; "Nonstock Item"."Item No.")
                {
                }
                column(Filter_NonstockItem; 'Yes')
                {
                }
                dataitem(Location; Location)
                {
                    column(ReportForNavId_25006028; 25006028)
                    {
                    }
                    column(LocationCode_ILE; Location.Code)
                    {
                    }
                    column(LocationDescription_ILE; Location.Name)
                    {
                    }
                    column(Qty_ILE; Qty)
                    {
                    }
                    column(QtyOnSalesOrder_ILE; QtyOnSalesOrder)
                    {
                    }
                    column(QtyOnPurchaseOrder_ILE; QtyOnPurchaseOrder)
                    {
                    }
                    column(QtyOnServiceOrder_ILE; QtyOnServiceOrder)
                    {
                    }
                    column(Description_Item; ItemDescription)
                    {
                    }
                    column(ItemNo_ILE; ItemNo)
                    {
                    }
                    column(Filter_ILE; 'Yes')
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        SalesLine: Record "Sales Line";
                        ServiceLine: Record "Service Line EDMS";
                        PurchaseLine: Record "Purchase Line";
                        Item: Record Item;
                    begin
                        if Item.Get("Nonstock Item"."Item No.") then begin
                            Item.SetRange("Location Filter", Location.Code);
                            Item.CalcFields("Qty. on Purch. Order", "Qty. on Sales Order", "Qty. on Service Order EDMS", Inventory);
                            Qty := Item.Inventory;
                            QtyOnPurchaseOrder := Item."Qty. on Purch. Order";
                            QtyOnSalesOrder := Item."Qty. on Sales Order";
                            QtyOnServiceOrder := Item."Qty. on Service Order EDMS";
                            ItemNo := Item."No.";
                            ItemDescription := Item.Description;
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        Qty := 0;
                        QtyOnPurchaseOrder := 0;
                        QtyOnSalesOrder := 0;
                        QtyOnServiceOrder := 0;
                        ItemNo := '';
                        ItemDescription := '';
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                if not ItemTmp.Get("Item Substitution"."No.") then begin
                    ItemTmp.Init;
                    ItemTmp."No." := "Item Substitution"."No.";
                    ItemTmp.Insert;
                end else
                    CurrReport.Skip;
            end;
        }
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = where(Number = const(1));
            column(ReportForNavId_25006012; 25006012)
            {
            }
            column(CompanyName; COMPANYNAME)
            {
            }
            column(ItemTableCaptItemFilter; TableCaption + ': ' + ItemFilter)
            {
            }
            column(ItemFilter; ItemFilter)
            {
            }
            column(ReportCaption; ReportCaptionLbl)
            {
            }
            column(PageCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(QtyOnServiceOrderLbl; QtyOnServiceOrderLbl)
            {
            }
            column(QtyOnPurchaseOrderLbl; QtyOnPurchaseOrderLbl)
            {
            }
            column(QtyOnSalesOrderLbl; QtyOnSalesOrderLbl)
            {
            }
            column(InventoryLbl; InventoryLbl)
            {
            }
            column(LocationDescLbl; LocationDescLbl)
            {
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        ItemFilter := "Item Substitution".GetFilters;
    end;

    var
        ItemFilter: Text;
        ReportCaptionLbl: label 'Item Substitution Inventory Overview';
        CurrReportPageNoCaptionLbl: label 'Page';
        QtyOnSalesOrder: Decimal;
        QtyOnServiceOrder: Decimal;
        QtyOnPurchaseOrder: Decimal;
        QtyOnServiceOrderLbl: label 'Qty. on Service Orders';
        QtyOnPurchaseOrderLbl: label 'Qty. on Purch. Orders';
        QtyOnSalesOrderLbl: label 'Qty. on Sales Orders';
        InventoryLbl: label 'Inventory';
        Qty: Decimal;
        LocationDescription: Text[50];
        LocationDescLbl: label 'Location Desc.';
        ItemDescription: Text[50];
        ItemNo: Code[20];
        ItemTmp: Record Item temporary;
}

