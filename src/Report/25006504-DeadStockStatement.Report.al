Report 25006504 "Dead Stock Statement"
{
    // 06.06.2014 Elva Baltic P8
    //   * For a while Dead Stock solution is not ready
    // 
    // 15.05.2014 Elva Baltic P21 #S0105 MMG7.00
    //   Modified triggers:
    //     OnPostReport()
    //     Item - OnPostDataItem()
    //   Added Request Page

    Caption = 'Dead Stock Statement';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Location Filter", "Date Filter", "Item Category Code";
            column(ReportForNavId_8129; 8129)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.Break;
            end;

            trigger OnPostDataItem()
            begin
                DeadStockMgt.FillDeadStockList(Item, DeadStockBuffer, ShowAllItems);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Option)
                {
                    field(HideSums; ShowAllItems)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show All Items';
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
    }

    trigger OnPostReport()
    begin
        //PAGE.RUNMODAL(PAGE::"Dead Stock Statement",DeadStockBuffer);  //06.06.2014 Elva Baltic P8
    end;

    var
        DeadStockBuffer: Record "Dead Stock Statement Buffer" temporary;
        DeadStockMgt: Codeunit "Dead Stock Management";
        ShowAllItems: Boolean;
}

