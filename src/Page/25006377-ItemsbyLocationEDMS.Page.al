Page 25006377 "Items by Location EDMS"
{
    Caption = 'Items by Location';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPlus;
    SaveValues = true;
    SourceTable = Item;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                field(ShowInTransit; ShowInTransit)
                {
                    ApplicationArea = Advanced;
                    Caption = 'Show Items in Transit';
                    ToolTip = 'Specifies the items in transit between locations.';

                    trigger OnValidate()
                    begin
                        ShowInTransitOnAfterValidate;
                    end;
                }
                field(ShowServiceLocation; ShowServiceLocation)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Items in Service Locations';
                    ToolTip = 'Shows items in Service Locations';

                    trigger OnValidate()
                    begin
                        ShowInTransitOnAfterValidate;
                    end;
                }
                field(ShowColumnName; ShowColumnName)
                {
                    ApplicationArea = Location;
                    Caption = 'Show Column Name';
                    ToolTip = 'Specifies that the names of columns are shown in the matrix window.';

                    trigger OnValidate()
                    begin
                        ShowColumnNameOnAfterValidate;
                    end;
                }
                field(ColumnSet; MATRIX_CaptionRange)
                {
                    ApplicationArea = Location;
                    Caption = 'Column Set';
                    Editable = false;
                    ToolTip = 'Specifies the range of values that are displayed in the matrix window, for example, the total period.';
                }
            }
            part(MatrixForm; "Items by Location Matrix EDMS")
            {
                ApplicationArea = Location;
                ShowFilter = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(PreviousSet)
            {
                ApplicationArea = Location;
                Caption = 'Previous Set';
                Image = PreviousSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Go to the previous set of data.';

                trigger OnAction()
                begin
                    SetColumns(Matrix_setwanted::Previous);
                end;
            }
            action(NextSet)
            {
                ApplicationArea = Location;
                Caption = 'Next Set';
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Go to the next set of data.';

                trigger OnAction()
                begin
                    SetColumns(Matrix_setwanted::Next);
                end;
            }
        }
    }

    trigger OnInit()
    begin
        TempMatrixLocation.GetLocationsIncludingUnspecifiedLocation(false, false);
    end;

    trigger OnOpenPage()
    begin
        CurrPage.MatrixForm.Page.FillData(SourceType, SourceSubType, SourceID);
        SetColumns(Matrix_setwanted::Initial);
    end;

    var
        TempMatrixLocation: Record Location temporary;
        MatrixRecords: array[32] of Record Location;
        MatrixRecordRef: RecordRef;
        MATRIX_SetWanted: Option Initial,Previous,Same,Next;
        ShowColumnName: Boolean;
        ShowInTransit: Boolean;
        MATRIX_CaptionSet: array[32] of Text[80];
        MATRIX_CaptionRange: Text[100];
        MATRIX_PKFirstRecInCurrSet: Text[80];
        MATRIX_CurrSetLength: Integer;
        UnspecifiedLocationCodeTxt: label 'UNSPECIFIED', Comment = 'Code for unspecified location';
        SourceType: Integer;
        SourceSubType: Integer;
        SourceID: Code[20];
        ShowServiceLocation: Boolean;


    procedure SetColumns(SetWanted: Option Initial,Previous,Same,Next)
    var
        MatrixMgt: Codeunit "Matrix Management";
        CaptionFieldNo: Integer;
        CurrentMatrixRecordOrdinal: Integer;
    begin
        TempMatrixLocation.SetRange("Use As In-Transit", ShowInTransit);
        TempMatrixLocation.SetRange("Use As Service Location", ShowServiceLocation);

        Clear(MATRIX_CaptionSet);
        Clear(MatrixRecords);
        CurrentMatrixRecordOrdinal := 1;

        MatrixRecordRef.GetTable(TempMatrixLocation);
        MatrixRecordRef.SetTable(TempMatrixLocation);

        if ShowColumnName then
            CaptionFieldNo := TempMatrixLocation.FieldNo(Name)
        else
            CaptionFieldNo := TempMatrixLocation.FieldNo(Code);

        MatrixMgt.GenerateMatrixData(MatrixRecordRef, SetWanted, ArrayLen(MatrixRecords), CaptionFieldNo, MATRIX_PKFirstRecInCurrSet,
          MATRIX_CaptionSet, MATRIX_CaptionRange, MATRIX_CurrSetLength);

        if MATRIX_CaptionSet[1] = '' then begin
            MATRIX_CaptionSet[1] := UnspecifiedLocationCodeTxt;
            MATRIX_CaptionRange := StrSubstNo('%1%2', MATRIX_CaptionSet[1], MATRIX_CaptionRange);
        end;

        if MATRIX_CurrSetLength > 0 then begin
            TempMatrixLocation.SetPosition(MATRIX_PKFirstRecInCurrSet);
            TempMatrixLocation.Find;
            repeat
                MatrixRecords[CurrentMatrixRecordOrdinal].Copy(TempMatrixLocation);
                CurrentMatrixRecordOrdinal := CurrentMatrixRecordOrdinal + 1;
            until (CurrentMatrixRecordOrdinal > MATRIX_CurrSetLength) or (TempMatrixLocation.Next <> 1);
        end;

        UpdateMatrixSubform;
    end;

    local procedure ShowColumnNameOnAfterValidate()
    begin
        SetColumns(Matrix_setwanted::Same);
    end;

    local procedure ShowInTransitOnAfterValidate()
    begin
        SetColumns(Matrix_setwanted::Initial);
    end;

    local procedure UpdateMatrixSubform()
    begin
        CurrPage.MatrixForm.Page.Load(MATRIX_CaptionSet, MatrixRecords, TempMatrixLocation, MATRIX_CurrSetLength);
        CurrPage.MatrixForm.Page.SetRecord(Rec);
        CurrPage.Update;
    end;


    procedure SetParams(SourceTypePar: Integer; SourceSubTypePar: Integer; SourceIDPar: Code[20])
    begin
        SourceType := SourceTypePar;
        SourceSubType := SourceSubTypePar;
        SourceID := SourceIDPar;
    end;

    local procedure ShowServiceLocationOnAfterValidate()
    begin
        SetColumns(Matrix_setwanted::Initial);
    end;
}

