report 25006324 "Lost Sales"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'LostSales.rdl';
    dataset
    {
        dataitem(LostSalesReason; "Lost Sales Reason")
        {
            trigger OnAfterGetRecord()
            begin
                TmpLostSalesReason.Init();
                TmpLostSalesReason := LostSalesReason;
                TmpLostSalesReason.Insert();
            end;
        }

        dataitem(Item; Item)
        {
            dataitem(LostSalesEntry; "Lost Sales Entry")
            {
                DataItemLink = "Item No." = field("No.");
                trigger OnPreDataItem()

                begin
                    if TmpLostSalesReason.Get("Reason Code") or (LostSalesReason.GetFilters() = '') then begin
                        DataBuffer.Reset();
                        case GroupingType of
                            GroupingType::Item:
                                DataBuffer.SetRange("Code field 1", "Item No.");
                            GroupingType::Reason:
                                DataBuffer.SetRange("Code field 1", "Reason Code");
                        end;
                        if not DataBuffer.FindFirst() then begin
                            n += 1;
                            DataBuffer.Init();
                            DataBuffer."Entry No." := n;
                            case GroupingType of
                                GroupingType::Item:
                                    begin
                                        DataBuffer."Code Field 1" := "Item No.";
                                        DataBuffer."Text field 1" := "Description";
                                        ItemNoReasonCodeLbl := ItemNoCaptionLbl;
                                    end;
                                GroupingType::Reason:
                                    begin
                                        DataBuffer."Code Field 1" := "Reason Code";
                                        DataBuffer."Text field 1" := "Reason Description";
                                        ItemNoReasonCodeLbl := ReasonCaptionLbl;
                                    end;
                            end;
                            DataBuffer."Integer Field 1" := 1;
                            DataBuffer.Insert();
                        end else begin
                            DataBuffer."Integer Field 1" += 1;
                            DataBuffer.Modify();
                        end;

                    end;
                    CurrReport.Break();
                end;
            }
        }


        dataitem(DataBuffer; "Data Buffer")
        {
            UseTemporary = true;
            column(ItemNoReasonCode; "Code Field 1")
            {

            }
            column(Description; "Text Field 1")
            {

            }
            column(Quantity; "Integer Field 1")
            {

            }
            column(LostSalesCaption; LostSalesCaptionLbl)
            {

            }
            column(ReportFilterLbl; ReportFilterLbl)
            {

            }
            column(DescrCaptionLbl; DescrCaptionLbl)
            {

            }
            column(ReasonCaptionLbl; ReasonCaptionLbl)
            {

            }
            column(LostDealsCaptionLbl; LostDealsCaptionLbl)
            {

            }
            column(ItemNoReasonCodeLbl; ItemNoReasonCodeLbl)
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
                field(GroupingType; GroupingType)
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    OptionCaption = 'Item,Reason';
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
    var
        TmpLostSalesReason: Record "Lost Sales Reason" temporary;
        GroupingType: Option Item,Reason;
        LostSalesCaptionLbl: Label 'Lost Sales';
        ReportFilterLbl: Label 'Filter';
        ItemNoCaptionLbl: Label 'Item No.';
        DescrCaptionLbl: Label 'Description';
        ReasonCaptionLbl: Label 'Reason Code';
        LostDealsCaptionLbl: Label 'Lost Deals';
        ReportFilter: Text;
        ItemNoReasonCodeLbl: Text;
        n: integer;
}