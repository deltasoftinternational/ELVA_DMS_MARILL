report 25006129 "Calc. Sales Price From Purch P"
{
    Caption = 'Calc. Sales Price From Purchase Price';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Price Worksheet"; "Sales Price Worksheet")
        {
            column(ReportForNavId_5995; 5995)
            {
            }

            trigger OnAfterGetRecord()
            begin
                FilePosition += 1;
                CalcNewPriceFromPurchasePrice();
                ;
                Modify;

                Window.Update(1, ROUND(FilePosition / NumberLines * 10000, 1));
            end;

            trigger OnPostDataItem()
            begin
                Message(Text001);
            end;

            trigger OnPreDataItem()
            begin
                NumberLines := Count;
                Window.Open(Text002 + '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
                Window.Update(1, 0);
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
    }

    var
        Text001: label 'Calculated new price.';
        Window: Dialog;
        NumberLines: Integer;
        FilePosition: Integer;
        Text002: label 'Calculate new price.\\';
}

