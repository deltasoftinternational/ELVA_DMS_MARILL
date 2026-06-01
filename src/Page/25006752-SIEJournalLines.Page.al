/*
Page 25006752 "SIE Journal Lines"
{
    Caption = 'SIE Journal Lines';
    Editable = false;
    PageType = List;
    SourceTable = "SIE Journal Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(SIENo; Rec."SIE No.")
                {
                    ApplicationArea = Basic;
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
                field(Int7; Rec."Int 7")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleInt7;
                }
                field(Int8; Rec."Int 8")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleInt8;
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
                field(Decimal7; Rec."Decimal 7")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleDec7;
                }
                field(Decimal8; Rec."Decimal 8")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleDec8;
                }
                field(Date1; Rec."Date 1")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleDate1;
                }
                field(Date2; Rec."Date 2")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleDate2;
                }
                field(Date3; Rec."Date 3")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleDate3;
                }
                field(Date4; Rec."Date 4")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleDate4;
                }
                field(Time1; Rec."Time 1")
                {
                    ApplicationArea = Basic;
                    Visible = IsVisibleTime1;
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
                field(Posted; Rec.Posted)
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
        IsVisibleDate2: Boolean;
        IsVisibleDate3: Boolean;
        IsVisibleDate4: Boolean;
        IsVisibleTime1: Boolean;
        IsVisibleTime2: Boolean;
        IsVisibleCode10_1: Boolean;
        IsVisibleCode10_2: Boolean;
        IsVisibleCode10_3: Boolean;
        IsVisibleCode20_1: Boolean;
        IsVisibleCode20_2: Boolean;
        IsVisibleCode20_3: Boolean;
        IsVisibleInt1: Boolean;
        IsVisibleInt2: Boolean;
        IsVisibleInt3: Boolean;
        IsVisibleInt4: Boolean;
        IsVisibleInt5: Boolean;
        IsVisibleInt6: Boolean;
        IsVisibleInt7: Boolean;
        IsVisibleInt8: Boolean;
        IsVisibleDec1: Boolean;
        IsVisibleDec2: Boolean;
        IsVisibleDec3: Boolean;
        IsVisibleDec4: Boolean;
        IsVisibleDec5: Boolean;
        IsVisibleDec6: Boolean;
        IsVisibleDec7: Boolean;
        IsVisibleDec8: Boolean;
        IsVisibleText50_1: Boolean;
        IsVisibleText50_2: Boolean;
        IsVisibleText100_1: Boolean;
        IsVisibleText10_1: Boolean;
        IsVisibleText10_2: Boolean;


    procedure SetVariableFields()
    begin
        IsVisibleDate1 := Rec.IsVFActive(Rec.FieldNo("Date 1"));
        IsVisibleDate2 := Rec.IsVFActive(Rec.FieldNo("Date 2"));
        IsVisibleDate3 := Rec.IsVFActive(Rec.FieldNo("Date 3"));
        IsVisibleDate4 := Rec.IsVFActive(Rec.FieldNo("Date 4"));
        IsVisibleTime1 := Rec.IsVFActive(Rec.FieldNo("Time 1"));
        IsVisibleTime2 := Rec.IsVFActive(Rec.FieldNo("Time 2"));
        IsVisibleCode10_1 := Rec.IsVFActive(Rec.FieldNo("Code10 1"));
        IsVisibleCode10_2 := Rec.IsVFActive(Rec.FieldNo("Code10 2"));
        IsVisibleCode10_3 := Rec.IsVFActive(Rec.FieldNo("Code10 3"));
        IsVisibleCode20_1 := Rec.IsVFActive(Rec.FieldNo("Code20 1"));
        IsVisibleCode20_2 := Rec.IsVFActive(Rec.FieldNo("Code20 2"));
        IsVisibleCode20_3 := Rec.IsVFActive(Rec.FieldNo("Code20 3"));
        IsVisibleInt1 := Rec.IsVFActive(Rec.FieldNo("Int 1"));
        IsVisibleInt2 := Rec.IsVFActive(Rec.FieldNo("Int 2"));
        IsVisibleInt3 := Rec.IsVFActive(Rec.FieldNo("Int 3"));
        IsVisibleInt4 := Rec.IsVFActive(Rec.FieldNo("Int 4"));
        IsVisibleInt5 := Rec.IsVFActive(Rec.FieldNo("Int 5"));
        IsVisibleInt6 := Rec.IsVFActive(Rec.FieldNo("Int 6"));
        IsVisibleInt7 := Rec.IsVFActive(Rec.FieldNo("Int 7"));
        IsVisibleInt8 := Rec.IsVFActive(Rec.FieldNo("Int 8"));
        IsVisibleDec1 := Rec.IsVFActive(Rec.FieldNo("Decimal 1"));
        IsVisibleDec2 := Rec.IsVFActive(Rec.FieldNo("Decimal 2"));
        IsVisibleDec3 := Rec.IsVFActive(Rec.FieldNo("Decimal 3"));
        IsVisibleDec4 := Rec.IsVFActive(Rec.FieldNo("Decimal 4"));
        IsVisibleDec5 := Rec.IsVFActive(Rec.FieldNo("Decimal 5"));
        IsVisibleDec6 := Rec.IsVFActive(Rec.FieldNo("Decimal 6"));
        IsVisibleDec7 := Rec.IsVFActive(Rec.FieldNo("Decimal 7"));
        IsVisibleDec8 := Rec.IsVFActive(Rec.FieldNo("Decimal 8"));
        IsVisibleText50_1 := Rec.IsVFActive(Rec.FieldNo("Text50 1"));
        IsVisibleText50_2 := Rec.IsVFActive(Rec.FieldNo("Text50 2"));
        IsVisibleText100_1 := Rec.IsVFActive(Rec.FieldNo("Text100 1"));
        IsVisibleText10_1 := Rec.IsVFActive(Rec.FieldNo("Text50 1"));
        IsVisibleText10_2 := Rec.IsVFActive(Rec.FieldNo("Text50 2"));
    end;
}
*/