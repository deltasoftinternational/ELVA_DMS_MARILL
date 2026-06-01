pageextension 25006048 "Demand Forecast" extends "Demand Forecast Card" //2901 //old Demand Forecast
{
    Caption = 'Demand Forecast';
    layout
    {
        modify(Name)
        {
            ApplicationArea = All;
        }
        modify("Location Filter")
        {
            ApplicationArea = All;
        }
        modify("View By")
        {
            ApplicationArea = All;
        }
        modify("Quantity Type")
        {
            ApplicationArea = All;
        }
        modify("Forecast Type")
        {
            ApplicationArea = All;
        }
        modify("Date Filter")
        {

            Visible = false;
        }
        addafter("Date Filter")
        {
            field(DMSDateFilter; DateFilter)
            {
                ApplicationArea = Manufacturing;
                Caption = 'Date Filter';
                ToolTip = 'Specifies the dates that will be used to filter the amounts in the window.';

                trigger OnValidate()
                var
                    ApplicationManagement: Codeunit DocumentManagementDMS;
                begin
                    if ApplicationManagement.MakeDateFilter(DateFilter) = 0 then;
                    SetColumns(Setwanted::First);
                end;
            }
        }

        modify(Matrix)
        {
            Visible = false;
        }
        addafter(General)
        {
            part(DMSMatrix; "Demand Forecast Variant Matrix")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        modify("Copy Demand Forecast")
        {
            ApplicationArea = All;
        }
        modify("Previous Set")
        {
            ApplicationArea = All;
        }
        modify("Previous Column")
        {
            ApplicationArea = All;
        }
        modify("Next Column")
        {
            ApplicationArea = All;
        }
        modify("Next Set")
        {
            ApplicationArea = All;
        }
    }
    var
        MatrixRecords: array[32] of Record Date;
        MatrixColumnCaptions: array[32] of Text[1024];
        ColumnSet: Text[1024];


        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        PKFirstRecInCurrSet: Text[100];

        DateFilter: Text[1024];
        SetWanted: Option First,Previous,Same,Next,PreviousColumn,NextColumn;
        CurrSetLength: Integer;

        LocationFilter: Text;


    procedure SetColumns(SetWanted: Option Initial,Previous,Same,Next,PreviousSet,NextSet)
    var
        MatrixMgt: Codeunit "Matrix Management";
    begin
        //MatrixMgt.GeneratePeriodMatrixData(SetWanted, ArrayLen(MatrixRecords), false, PeriodType, Rec."Date Filter", PKFirstRecInCurrSet,
        //MatrixColumnCaptions, ColumnSet, CurrSetLength, MatrixRecords);
        MatrixMgt.GeneratePeriodMatrixData(SetWanted, ArrayLen(MatrixRecords), false, Rec."View By", DateFilter, PKFirstRecInCurrSet, MatrixColumnCaptions, ColumnSet, CurrentSetLength, MatrixRecords);
        SetMatrix;
    end;

    procedure SetMatrix()
    begin
        CurrPage.Matrix.Page.Load(
           MatrixColumnCaptions,
           MatrixRecords, Rec.Name,
          DateFilter, Rec."Forecast Type",
           Rec."Quantity Type", CurrSetLength, Rec.GetItemFilterBlobAsViewFilters(), Rec.GetLocationFilterBlobAsText(), Rec."Forecast By Locations", Rec."Forecast By Variants", Rec.GetVariantFilterBlobAsText());
        CurrPage.Update(false);
    end;
}