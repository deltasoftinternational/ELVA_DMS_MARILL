Report 25006134 "Split Service Line"
{
    Caption = 'Split Service Line';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Service Line EDMS"; "Service Line EDMS")
        {
            column(ReportForNavId_2689; 2689)
            {
            }

            trigger OnAfterGetRecord()
            var
                iLineNo: Integer;
                Window: Dialog;
                DiagText: label 'Quantity: #1#####\Quantity to Transfer: #2#####';
                QtyToTransfer: Decimal;
                ErrWrongValue: label 'Wrong Value!';
                QtyToTransferR: Decimal;
            begin
            end;

            trigger OnPostDataItem()
            begin
                DocumentMgt.ServiceSplitLine("Service Line EDMS", SplitQty);
            end;

            trigger OnPreDataItem()
            var
                PurchHeader: Record "Purchase Header";
            begin
                IsSingleLine := Count = 1;
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
                    field(SplitQty; SplitQty)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Line Count';
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

    trigger OnInitReport()
    begin
        SplitQty := 2;
    end;

    var
        ConfirmTransferAll: label 'Do you want to transfer whole line?';
        EDMS001: label 'There is not such service order!';
        EDMS002: label 'You have to choose order No.';
        EDMS003: label 'Not able to transfer because there are entries ir Scheduler!';
        NewServLine: Record "Service Line EDMS";
        DocumentMgt: Codeunit DocumentManagementDMS;
        IsSingleLine: Boolean;
        SplitQty: Integer;
}

