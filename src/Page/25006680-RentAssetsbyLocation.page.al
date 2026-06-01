page 25006680 "Rent Assets by Location"
{
    Caption = 'Rent Assets by Location';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPlus;
    SaveValues = true;
    SourceTable = "Rent Asset";

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                /*
                field(ShowInTransit; ShowInTransit)
                {
                    ApplicationArea = Location;
                    Caption = 'Show Items in Transit';
                    ToolTip = 'Specifies the items in transit between locations.';

                    trigger OnValidate()
                    begin
                        ShowInTransitOnAfterValidate;
                    end;
                }
                */

                field(ShowOnlyMultiple; ShowOnlyMultiple)
                {
                    ApplicationArea = Location;
                    Caption = 'Show Only Multiple';

                    trigger OnValidate()
                    begin
                        ShowOnlyMultipleOnAfterValidate;
                    end;
                }
                field(ShowOnlyAvailable; ShowOnlyAvailable)
                {
                    ApplicationArea = Location;
                    Caption = 'Show Available Quantity';

                    trigger OnValidate()
                    begin
                        ShowOnlyAvailableOnAfterValidate;
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
                field(MATRIX_CaptionRange; MATRIX_CaptionRange)
                {
                    ApplicationArea = Location;
                    Caption = 'Column Set';
                    Editable = false;
                    ToolTip = 'Specifies the range of values that are displayed in the matrix window, for example, the total period. To change the contents of the field, choose Next Set or Previous Set.';
                }
            }
            part(MatrixForm; "Rent Assets by Location Matrix")
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
            action("Previous Set")
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
                    SetColumns(MATRIX_SetWanted::Previous);
                end;
            }
            action("Next Set")
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
                    SetColumns(MATRIX_SetWanted::Next);
                end;
            }
        }
    }

    trigger OnInit()
    begin
        //TempMatrixLocation.GetLocationsIncludingUnspecifiedLocation(false, false);
        TempMatrixLocation.GetRentItemLocations();
        SetMatrix();
    end;

    trigger OnOpenPage()
    begin
        SetColumns(MATRIX_SetWanted::Initial);
    end;


    var
        TempMatrixLocation: Record Location temporary;
        MatrixRecords: array[32] of Record Location;
        MatrixRecordRef: RecordRef;
        MATRIX_SetWanted: Option Initial,Previous,Same,Next;
        ShowColumnName: Boolean;
        ShowInTransit: Boolean;
        ShowOnlyMultiple: Boolean;
        ShowOnlyAvailable: Boolean;
        MATRIX_CaptionSet: array[32] of Text[80];
        MATRIX_CaptionRange: Text;
        MATRIX_PKFirstRecInCurrSet: Text;
        MATRIX_CurrSetLength: Integer;
        UnspecifiedLocationCodeTxt: Label 'UNSPECIFIED', Comment = 'Code for unspecified location';
        RentItemNo: Code[20];


    procedure SetColumns(SetWanted: Option Initial,Previous,Same,Next)
    var
        MatrixMgt: Codeunit "Matrix Management";
        CaptionFieldNo: Integer;
        CurrentMatrixRecordOrdinal: Integer;
    begin
        TempMatrixLocation.SetRange("Use As In-Transit", ShowInTransit);

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
        SetColumns(MATRIX_SetWanted::Same);
    end;

    local procedure ShowInTransitOnAfterValidate()
    begin
        SetColumns(MATRIX_SetWanted::Initial);
    end;

    local procedure SetMatrix()
    var
        RentAssetFilter: Record "Rent Asset";
        RentItemRelation: Record "Rent Item Relation";

    begin
        if RentItemNo <> '' then begin
            RentItemRelation.Reset();
            RentItemRelation.SetRange("Rent Item No.", RentItemNo);
            CurrPage.MatrixForm.PAGE.SetRentRelationFilter(RentItemRelation);
        end else begin
            CurrPage.MatrixForm.PAGE.SetRentAssetFilter(Rec);
        end;
        CurrPage.MatrixForm.PAGE.Load(MATRIX_CaptionSet, MatrixRecords, TempMatrixLocation, MATRIX_CurrSetLength);
    end;

    local procedure UpdateMatrix()
    begin
        CurrPage.MatrixForm.Page.UpdateMatrix();
    end;

    local procedure UpdateMatrixSubform()
    begin
        SetMatrix();
        UpdateMatrix();
        CurrPage.Update(false);
    end;



    local procedure ShowOnlyMultipleOnAfterValidate()
    begin
        if ShowOnlyMultiple then
            CurrPage.MatrixForm.Page.SetOnlyMultiple(true)
        else
            CurrPage.MatrixForm.Page.SetOnlyMultiple(false);
        UpdateMatrixSubform;
    end;

    local procedure ShowOnlyAvailableOnAfterValidate()
    begin
        if ShowOnlyAvailable then
            CurrPage.MatrixForm.Page.SetOnlyAvailable(true)
        else
            CurrPage.MatrixForm.Page.SetOnlyAvailable(false);
        UpdateMatrixSubform;
    end;

    procedure SetRentItemNo(RentItemNoToSet: Code[20])
    begin
        RentItemNo := RentItemNoToSet;
    end;
}

