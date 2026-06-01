/*
Page 25006751 "SIE Ledger Entries"
{
    Caption = 'SIE Ledger Entries';
    Editable = false;
    PageType = List;
    SourceTable = "SIE Ledger Entry";
    SourceTableView = sorting("Date 1", "Time 1");

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(SIENo; Rec."SIE No.")
                {
                    ApplicationArea = Basic;
                }
                field(Date1; Rec."Date 1")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleDate1;
                }
                field(Time1; Rec."Time 1")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleTime1;
                }
                field(EntryType; Rec."Entry Type")
                {
                    ApplicationArea = Basic;
                }
                field(SourceCode; Rec."Source Code")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(QtytoAssign; Rec."Qty. to Assign")
                {
                    ApplicationArea = Basic;
                }
                field(QtyAssigned; Rec."Qty. Assigned")
                {
                    ApplicationArea = Basic;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension2Code; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentDate; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                }
                field(ExternalDocumentNo; Rec."External Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(NoSeries; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                }
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                }
                field(ReasonCode; Rec."Reason Code")
                {
                    ApplicationArea = Basic;
                }
                field(Correction; Rec.Correction)
                {
                    ApplicationArea = Basic;
                }
                field(AutomaticEntry; Rec."Automatic Entry")
                {
                    ApplicationArea = Basic;
                }
                field(JournalBatchName; Rec."Journal Batch Name")
                {
                    ApplicationArea = Basic;
                }
                field(Code101; Rec."Code10 1")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleCode10_1;
                }
                field(Code102; Rec."Code10 2")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleCode10_2;
                }
                field(Code103; Rec."Code10 3")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleCode10_3;
                }
                field(Code104; Rec."Code10 4")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleCode10_4;
                }
                field(Code105; Rec."Code10 5")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleCode10_5;
                }
                field(Code106; Rec."Code10 6")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleCode10_6;
                }
                field(Code201; Rec."Code20 1")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleCode20_1;
                }
                field(Code202; Rec."Code20 2")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleCode20_2;
                }
                field(Code203; Rec."Code20 3")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleCode20_3;
                }
                field(Code204; Rec."Code20 4")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleCode20_4;
                }
                field(Code205; Rec."Code20 5")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleCode20_5;
                }
                field(Code206; Rec."Code20 6")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleCode20_6;
                }
                field(Int1; Rec."Int 1")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleInt1;
                }
                field(Int2; Rec."Int 2")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleInt2;
                }
                field(Int3; Rec."Int 3")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleInt3;
                }
                field(Int4; Rec."Int 4")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleInt4;
                }
                field(Int5; Rec."Int 5")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleInt5;
                }
                field(Int6; Rec."Int 6")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleInt6;
                }
                field(Decimal1; Rec."Decimal 1")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleDec1;
                }
                field(Decimal2; Rec."Decimal 2")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleDec2;
                }
                field(Decimal3; Rec."Decimal 3")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleDec3;
                }
                field(Decimal4; Rec."Decimal 4")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleDec4;
                }
                field(Decimal5; Rec."Decimal 5")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleDec5;
                }
                field(Decimal6; Rec."Decimal 6")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleDec6;
                }
                field(Date2; Rec."Date 2")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleDate2;
                }
                field(Time2; Rec."Time 2")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleTime2;
                }
                field(Text501; Rec."Text50 1")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleText50_1;
                }
                field(Text502; Rec."Text50 2")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleText50_2;
                }
                field(Text1001; Rec."Text100 1")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleText100_1;
                }
                field(Text101; Rec."Text10 1")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleText10_1;
                }
                field(Text102; Rec."Text10 2")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleText10_2;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        SetVariableFields;
    end;

    var
        IsVisibleDate1: Boolean;
        IsVisibleTime1: Boolean;
        IsVisibleCode10_1: Boolean;
        IsVisibleCode10_2: Boolean;
        IsVisibleCode10_3: Boolean;
        IsVisibleCode10_4: Boolean;
        IsVisibleCode10_5: Boolean;
        IsVisibleCode10_6: Boolean;
        IsVisibleCode20_1: Boolean;
        IsVisibleCode20_2: Boolean;
        IsVisibleCode20_3: Boolean;
        IsVisibleCode20_4: Boolean;
        IsVisibleCode20_5: Boolean;
        IsVisibleCode20_6: Boolean;
        IsVisibleInt1: Boolean;
        IsVisibleInt2: Boolean;
        IsVisibleInt3: Boolean;
        IsVisibleInt4: Boolean;
        IsVisibleInt5: Boolean;
        IsVisibleInt6: Boolean;
        IsVisibleDec1: Boolean;
        IsVisibleDec2: Boolean;
        IsVisibleDec3: Boolean;
        IsVisibleDec4: Boolean;
        IsVisibleDec5: Boolean;
        IsVisibleDec6: Boolean;
        IsVisibleDate2: Boolean;
        IsVisibleTime2: Boolean;
        IsVisibleText50_1: Boolean;
        IsVisibleText50_2: Boolean;
        IsVisibleText100_1: Boolean;
        IsVisibleText10_1: Boolean;
        IsVisibleText10_2: Boolean;


    procedure SetVariableFields()
    begin
        IsVisibleDate1 := Rec.IsVFActive(Rec.FieldNo("Date 1"));
        IsVisibleTime1 := Rec.IsVFActive(Rec.FieldNo("Time 1"));
        IsVisibleDate2 := Rec.IsVFActive(Rec.FieldNo("Date 2"));
        IsVisibleTime2 := Rec.IsVFActive(Rec.FieldNo("Time 2"));
        IsVisibleCode10_1 := Rec.IsVFActive(Rec.FieldNo("Code10 1"));
        IsVisibleCode10_2 := Rec.IsVFActive(Rec.FieldNo("Code10 2"));
        IsVisibleCode10_3 := Rec.IsVFActive(Rec.FieldNo("Code10 3"));
        IsVisibleCode10_4 := Rec.IsVFActive(Rec.FieldNo("Code10 4"));
        IsVisibleCode10_5 := Rec.IsVFActive(Rec.FieldNo("Code10 5"));
        IsVisibleCode10_6 := Rec.IsVFActive(Rec.FieldNo("Code10 6"));
        IsVisibleCode20_1 := Rec.IsVFActive(Rec.FieldNo("Code20 1"));
        IsVisibleCode20_2 := Rec.IsVFActive(Rec.FieldNo("Code20 2"));
        IsVisibleCode20_3 := Rec.IsVFActive(Rec.FieldNo("Code20 3"));
        IsVisibleCode20_4 := Rec.IsVFActive(Rec.FieldNo("Code20 4"));
        IsVisibleCode20_5 := Rec.IsVFActive(Rec.FieldNo("Code20 5"));
        IsVisibleCode20_6 := Rec.IsVFActive(Rec.FieldNo("Code20 6"));
        IsVisibleInt1 := Rec.IsVFActive(Rec.FieldNo("Int 1"));
        IsVisibleInt2 := Rec.IsVFActive(Rec.FieldNo("Int 2"));
        IsVisibleInt3 := Rec.IsVFActive(Rec.FieldNo("Int 3"));
        IsVisibleInt4 := Rec.IsVFActive(Rec.FieldNo("Int 4"));
        IsVisibleInt5 := Rec.IsVFActive(Rec.FieldNo("Int 5"));
        IsVisibleInt6 := Rec.IsVFActive(Rec.FieldNo("Int 6"));
        IsVisibleDec1 := Rec.IsVFActive(Rec.FieldNo("Decimal 1"));
        IsVisibleDec2 := Rec.IsVFActive(Rec.FieldNo("Decimal 2"));
        IsVisibleDec3 := Rec.IsVFActive(Rec.FieldNo("Decimal 3"));
        IsVisibleDec4 := Rec.IsVFActive(Rec.FieldNo("Decimal 4"));
        IsVisibleDec5 := Rec.IsVFActive(Rec.FieldNo("Decimal 5"));
        IsVisibleDec6 := Rec.IsVFActive(Rec.FieldNo("Decimal 6"));
        IsVisibleText50_1 := Rec.IsVFActive(Rec.FieldNo("Text50 1"));
        IsVisibleText50_2 := Rec.IsVFActive(Rec.FieldNo("Text50 2"));
        IsVisibleText100_1 := Rec.IsVFActive(Rec.FieldNo("Text100 1"));
        IsVisibleText10_1 := Rec.IsVFActive(Rec.FieldNo("Text50 1"));
        IsVisibleText10_2 := Rec.IsVFActive(Rec.FieldNo("Text50 2"));
    end;
}
*/