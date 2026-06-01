Report 25006518 "Invent. Status by Item Cat.off"
{
    // 07.02.2014 Elva Baltic P7 #R094 MMG7.00
    //   * New field added XRate (Aprites koeficients)
    // 
    // 04.04.2013 Elva Baltic P15
    //   * Created (based on NAV2009 respective report)
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/InventStatusbyItemCatoff.rdlc';


    dataset
    {
        dataitem(dtItemCategory_Filter; "Item Category")
        {
            CalcFields = "Cost Amount Net Change";
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code", "Location Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter";
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if dfCompareDate <> dfEmpty then begin
                    SetFilter("Date Filter", '..%1', datCompDate);
                    CalcFields("Cost Amount Net Change");
                    decCompTotalCost += dtItemCategory_Filter."Cost Amount Net Change";
                    ShowCompareData := true;
                end;

                SetFilter("Date Filter", '..%1', datStatusDate);
                CalcFields("Cost Amount Net Change");

                decTotalCost += dtItemCategory_Filter."Cost Amount Net Change";
            end;

            trigger OnPreDataItem()
            begin
                SetFilter("Date Filter", '..%1', datStatusDate);
            end;
        }
        dataitem(dtItemCategory_Output; "Item Category")
        {
            CalcFields = "Cost Amount Net Change", "Sales (LCY)";
            DataItemTableView = sorting(Code);
            column(ReportForNavId_2; 2)
            {
            }
            column(Code_dtItemCategoryOutput; dtItemCategory_Output.Code)
            {
                IncludeCaption = true;
            }
            column(Description_dtItemCategoryOutput; dtItemCategory_Output.Description)
            {
                IncludeCaption = true;
            }
            column(CostAmountNetChange_dtItemCategoryOutput; dtItemCategory_Output."Cost Amount Net Change")
            {
                IncludeCaption = true;
            }
            column(CostPercentPerTotal_dtItemCategoryOutput; decCostPercentPerTotal)
            {
            }
            column(CurrCompCostAmount_dtItemCategoryOutput; decCurrCompCostAmount)
            {
            }
            column(CompCostPercentPerTotal_dtItemCategoryOutput; decCompCostPercentPerTotal)
            {
            }
            column(CostMarginPercent_dtItemCategoryOutput; decCostMarginPercent)
            {
            }
            column(TotalCost_dtItemCategoryOutput; decTotalCost)
            {
            }
            column(CompTotalCost_dtItemCategoryOutput; decCompTotalCost)
            {
            }
            column(TotalCostMarginPercent_dtItemCategoryOutput; decTotalCostMarginPercent)
            {
            }
            column(DateFilterExpr; DateFilterExprLbl)
            {
            }
            column(DatCompDate; datCompDate)
            {
            }
            column(ShowCompareData; ShowCompareData)
            {
            }
            column(XRate; Format(decXRate, 0, '<Precision,2:2><Standard Format,0>'))
            {
            }
            column(ShowCategory; ShowCategory)
            {
            }
            /* FIXME
            dataitem("Product Group";"Product Group")
            {
                DataItemLink = "Item Category Code"=field(Code);
                DataItemTableView = sorting("Item Category Code",Code);
                RequestFilterFields = "Code";
                column(ReportForNavId_3; 3)
                {
                }
                column(Code_ProductGroup;"Product Group".Code)
                {
                }
                column(Description_ProductGroup;"Product Group".Description)
                {
                }
                column(CostAmountNetChange_ProductGroup;"Product Group"."Cost Amount Net Change")
                {
                }
                column(CostPercentPerTotal2_ProductGroup;CostPercentPerTotal2)
                {
                }
                column(CurrCompCostAmount2_ProductGroup;CurrCompCostAmount2)
                {
                }
                column(CompCostPercentPerTotal2_ProductGroup;CompCostPercentPerTotal2)
                {
                }
                column(CostMarginPercent2_ProductGroup;CostMarginPercent2)
                {
                }
                column(XRate2;Format(XRate2,0,'<Precision,2:2><Standard Format,0>'))
                {
                }
                column(ShowGroup;ShowGroup)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CalcFields("Sales (LCY)");
                    CalcFields("Cost Amount Net Change");

                    if dtItemCategory_Output."Cost Amount Net Change" <> 0 then
                     CostPercentPerTotal2 := "Cost Amount Net Change" / dtItemCategory_Output."Cost Amount Net Change" * 100
                    else
                     CostPercentPerTotal2 := 0;

                    if "Cost Amount Net Change" <> 0 then
                     XRate2 := "Sales (LCY)" / "Cost Amount Net Change"
                    else
                     XRate2 := 0;



                    if dfCompareDate <> dfEmpty then
                     begin
                      CurrCompCostAmount2 := 0;
                      ProductGroup.Reset;
                      ProductGroup.Get("Item Category Code", Code);
                      ProductGroup.CopyFilters("Product Group");
                      ProductGroup.SetFilter("Date Filter",'..%1',datCompDate);
                      ProductGroup.CalcFields("Cost Amount Net Change");
                      CurrCompCostAmount2 := ProductGroup."Cost Amount Net Change";

                      if decCurrCompCostAmount <> 0 then
                       CompCostPercentPerTotal2 := CurrCompCostAmount2 / decCurrCompCostAmount * 100
                      else
                       CompCostPercentPerTotal2 := 0;

                      CostMarginPercent2 := 0;
                      if "Cost Amount Net Change" <> 0 then
                       CostMarginPercent2 := (CurrCompCostAmount2 - "Cost Amount Net Change") / "Cost Amount Net Change" * 100
                      else
                       begin
                        if CurrCompCostAmount2 <> 0 then
                         CostMarginPercent2 := 100
                        else
                         CostMarginPercent2 := 0;
                       end;
                     end;

                    if (XRate2 = 0) and ("Cost Amount Net Change" = 0 ) and (CostPercentPerTotal2 = 0) then
                      ShowGroup := 'FALSE'
                    else
                      ShowGroup := 'TRUE';
                end;

                trigger OnPreDataItem()
                begin
                    SetFilter("Global Dimension 1 Filter", dtItemCategory_Output.GetFilter("Global Dimension 1 Filter"));
                    SetFilter("Global Dimension 2 Filter", dtItemCategory_Output.GetFilter("Global Dimension 2 Filter"));
                    SetFilter("Date Filter", dtItemCategory_Output.GetFilter("Date Filter"));
                    SetFilter("Location Filter", dtItemCategory_Output.GetFilter("Location Filter"));

                    if dtItemCategory_Output."Cost Amount Net Change" <> 0 then
                     decTotalCostMarginPercent := (decCurrCompCostAmount - dtItemCategory_Output."Cost Amount Net Change") /
                                                   dtItemCategory_Output."Cost Amount Net Change" * 100
                    else
                     begin
                      if CurrCompCostAmount2 <> 0 then
                       TotalCostMarginPercent2 := 100
                      else
                       TotalCostMarginPercent2 := 0;
                     end;
                end;
            }
            */
            trigger OnAfterGetRecord()
            begin
                if decTotalCost <> 0 then
                    decCostPercentPerTotal := "Cost Amount Net Change" / decTotalCost * 100
                else
                    decCostPercentPerTotal := 0;

                if "Cost Amount Net Change" <> 0 then
                    decXRate := "Sales (LCY)" / "Cost Amount Net Change"
                else
                    decXRate := 0;

                if dfCompareDate <> dfEmpty then begin
                    decCurrCompCostAmount := 0;
                    recItemCategory.Reset;
                    recItemCategory.Get(Code);
                    recItemCategory.CopyFilters(dtItemCategory_Output);
                    recItemCategory.SetFilter("Date Filter", '..%1', datCompDate);
                    recItemCategory.CalcFields("Cost Amount Net Change");
                    decCurrCompCostAmount := recItemCategory."Cost Amount Net Change";

                    if decCompTotalCost <> 0 then
                        decCompCostPercentPerTotal := decCurrCompCostAmount / decCompTotalCost * 100
                    else
                        decCompCostPercentPerTotal := 0;

                    decCostMarginPercent := 0;
                    if "Cost Amount Net Change" <> 0 then
                        decCostMarginPercent := (decCurrCompCostAmount - "Cost Amount Net Change") / "Cost Amount Net Change" * 100
                    else begin
                        if decCurrCompCostAmount <> 0 then
                            decCostMarginPercent := 100
                        else
                            decCostMarginPercent := 0;
                    end;
                end;

                if (decCostPercentPerTotal = 0) and ("Cost Amount Net Change" = 0) then
                    ShowCategory := 'FALSE'
                else
                    ShowCategory := 'TRUE';
            end;

            trigger OnPostDataItem()
            begin

                //CurrReport.SHOWOUTPUT(NOT (dfCompareDate = dfEmpty)); //not supported in NAV2013
                if decTotalCost <> 0 then
                    decTotalCostMarginPercent := (decCompTotalCost - decTotalCost) / decTotalCost * 100
                else begin
                    if decCompTotalCost <> 0 then
                        decTotalCostMarginPercent := 100
                    else
                        decTotalCostMarginPercent := 0;
                end;
            end;

            trigger OnPreDataItem()
            begin
                CopyFilters(dtItemCategory_Filter);

                if decTotalCost <> 0 then
                    decTotalCostMarginPercent := (decCompTotalCost - decTotalCost) / decTotalCost * 100
                else begin
                    if decCompTotalCost <> 0 then
                        decTotalCostMarginPercent := 100
                    else
                        decTotalCostMarginPercent := 0;
                end;

                DateFilterExprLbl := GetFilters;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StatusDate; datStatusDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Status Date';
                    }
                    field(CompareDate; dfCompareDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Compare Date Formula';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if datStatusDate = 0D then
                datStatusDate := WorkDate;
        end;
    }

    labels
    {
        CostPercPerTotalLbl = 'Cost % per Total';
        CostAmountOnLbl = 'Cost Amount on';
        CostPercPerTotalOnLbl = 'Cost % per Total on';
        CostChangePercLbl = 'Cost Change %';
        ReportTitleLbl = 'Inventory Status by Item Categories';
        XRateLbl = 'X Rate';
    }

    trigger OnPreReport()
    begin
        datCompDate := CalcDate(dfCompareDate, datStatusDate);
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        decCostSum: Decimal;
        decSalesSum: Decimal;
        decTotalSalesSum: Decimal;
        decPercOfTotalCostSum: Decimal;
        txtFilters: Text[1000];
        decTotalCOGS: Decimal;
        decTotalSales: Decimal;
        decTotalProfit: Decimal;
        decProfitPercent: Decimal;
        decSalesPercentPerTotal: Decimal;
        decProfitPercentPerTotal: Decimal;
        decTotalProfitPercent: Decimal;
        decTotalCost: Decimal;
        decCostPercentPerTotal: Decimal;
        datStatusDate: Date;
        dfCompareDate: DateFormula;
        dfEmpty: DateFormula;
        datCompDate: Date;
        decCompTotalCost: Decimal;
        decCurrCompCostAmount: Decimal;
        recItemCategory: Record "Item Category";
        //ProductGroup: Record "Product Group"; //FIXME
        decCompCostPercentPerTotal: Decimal;
        decCostMarginPercent: Decimal;
        decTotalCostMarginPercent: Decimal;
        decXRate: Decimal;
        CurrCompCostAmount2: Decimal;
        TotalCostMarginPercent2: Decimal;
        CostPercentPerTotal2: Decimal;
        XRate2: Decimal;
        CompCostPercentPerTotal2: Decimal;
        CostMarginPercent2: Decimal;
        tcREZ001: label 'Cost Amount on';
        tcREZ002: label 'Cost % per Total on';
        DateFilterExprLbl: Text[100];
        ShowCompareData: Boolean;
        ShowGroup: Text;
        ShowCategory: Text;
}

