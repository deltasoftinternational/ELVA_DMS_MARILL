/*
Page 25006760 "SIE Journal"
{
    // 19.06.2013 EDMS P8
    //   * Merged with NAV2009

    ApplicationArea = Basic;
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "SIE Journal Line";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                ApplicationArea = Basic;
                Caption = 'Batch Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    SIEExchMgt.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    SIEExchMgt.CheckName(CurrentJnlBatchName, Rec);
                    //CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Group)
            {
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(SIENo; Rec."SIE No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Int1; Rec."Int 1")
                {
                    ApplicationArea = Basic;
                    Visible = Int1Visible;
                }
                field(Int2; Rec."Int 2")
                {
                    ApplicationArea = Basic;
                    Visible = Int2Visible;
                }
                field(Int3; Rec."Int 3")
                {
                    ApplicationArea = Basic;
                    Visible = Int3Visible;
                }
                field(Int4; Rec."Int 4")
                {
                    ApplicationArea = Basic;
                    Visible = Int4Visible;
                }
                field(Int5; Rec."Int 5")
                {
                    ApplicationArea = Basic;
                    Visible = Int5Visible;
                }
                field(Int6; Rec."Int 6")
                {
                    ApplicationArea = Basic;
                    Visible = Int6Visible;
                }
                field(Int7; Rec."Int 7")
                {
                    ApplicationArea = Basic;
                    Visible = Int7Visible;
                }
                field(Int8; Rec."Int 8")
                {
                    ApplicationArea = Basic;
                    Visible = Int8Visible;
                }
                field(Decimal1; Rec."Decimal 1")
                {
                    ApplicationArea = Basic;
                    Visible = Dec1Visible;
                }
                field(Decimal2; Rec."Decimal 2")
                {
                    ApplicationArea = Basic;
                    Visible = Dec2Visible;
                }
                field(Decimal3; Rec."Decimal 3")
                {
                    ApplicationArea = Basic;
                    Visible = Dec3Visible;
                }
                field(Decimal4; Rec."Decimal 4")
                {
                    ApplicationArea = Basic;
                    Visible = Dec4Visible;
                }
                field(Decimal5; Rec."Decimal 5")
                {
                    ApplicationArea = Basic;
                    Visible = Dec5Visible;
                }
                field(Decimal6; Rec."Decimal 6")
                {
                    ApplicationArea = Basic;
                    Visible = Dec6Visible;
                }
                field(Decimal7; Rec."Decimal 7")
                {
                    ApplicationArea = Basic;
                    Visible = Dec7Visible;
                }
                field(Decimal8; Rec."Decimal 8")
                {
                    ApplicationArea = Basic;
                    Visible = Dec8Visible;
                }
                field(Date1; Rec."Date 1")
                {
                    ApplicationArea = Basic;
                    Visible = Date1Visible;
                }
                field(Date2; Rec."Date 2")
                {
                    ApplicationArea = Basic;
                    Visible = Date2Visible;
                }
                field(Date3; Rec."Date 3")
                {
                    ApplicationArea = Basic;
                    Visible = Date3Visible;
                }
                field(Date4; Rec."Date 4")
                {
                    ApplicationArea = Basic;
                    Visible = Date4Visible;
                }
                field(Time1; Rec."Time 1")
                {
                    ApplicationArea = Basic;
                    Visible = Time1Visible;
                }
                field(Time2; Rec."Time 2")
                {
                    ApplicationArea = Basic;
                    Visible = Time2Visible;
                }
                field(Text501; Rec."Text50 1")
                {
                    ApplicationArea = Basic;
                    Visible = Text50_1Visible;
                }
                field(Text502; Rec."Text50 2")
                {
                    ApplicationArea = Basic;
                    Visible = Text50_2Visible;
                }
                field(Text1001; Rec."Text100 1")
                {
                    ApplicationArea = Basic;
                    Visible = Text100_1Visible;
                }
                field(Code101; Rec."Code10 1")
                {
                    ApplicationArea = Basic;
                    Visible = Code10_1Visible;
                }
                field(Code102; Rec."Code10 2")
                {
                    ApplicationArea = Basic;
                    Visible = Code10_2Visible;
                }
                field(Code103; Rec."Code10 3")
                {
                    ApplicationArea = Basic;
                    Visible = Code10_3Visible;
                }
                field(Code201; Rec."Code20 1")
                {
                    ApplicationArea = Basic;
                    Visible = Code20_1Visible;
                }
                field(Code202; Rec."Code20 2")
                {
                    ApplicationArea = Basic;
                    Visible = Code20_2Visible;
                }
                field(Code203; Rec."Code20 3")
                {
                    ApplicationArea = Basic;
                    Visible = Code20_3Visible;
                }
                field(Text101; Rec."Text10 1")
                {
                    ApplicationArea = Basic;
                    Visible = Text10_1Visible;
                }
                field(Text102; Rec."Text10 2")
                {
                    ApplicationArea = Basic;
                    Visible = Text10_2Visible;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action61>")
            {
                Caption = '&Line';
                action("<Action62>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                        CurrPage.SaveRecord;
                    end;
                }
            }
            group("<Action37>")
            {
                Caption = '&SIE';
                action("<Action42>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Special Invt. Equipment Card";
                    RunPageLink = "No." = field("SIE No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("<Action45>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ledger E&ntries';
                    Image = ResourceLedger;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "SIE Ledger Entries";
                    RunPageLink = "SIE No." = field("SIE No.");
                    ShortCutKey = 'Ctrl+F7';
                }
            }
        }
        area(processing)
        {
            group("<Action36>")
            {
                Caption = 'P&osting';
                action("<Action48>")
                {
                    ApplicationArea = Basic;
                    Caption = 'P&ost';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        SIEMgt.SIEPostJnl(Rec);
                        CurrentJnlBatchName := Rec.GetRangemax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetVariableFields;
        SIEExchMgt.GetSIE(Rec."SIE No.", SIEDescription);
        OpenedFromBatch := (Rec."Journal Batch Name" <> '') and (Rec."Journal Template Name" = '');
        if OpenedFromBatch then begin
            CurrentJnlBatchName := Rec."Journal Batch Name";
            SIEExchMgt.OpenJournal(CurrentJnlBatchName, Rec);
            exit;
        end;
        SIEExchMgt.TemplateSelection(Page::"SIE Journal", false, Rec, JnlSelected);
        if not JnlSelected then
            Error('');
        SIEExchMgt.OpenJournal(CurrentJnlBatchName, Rec);
    end;

    var
        CurrentJnlBatchName: Code[20];
        SIEExchMgt: Codeunit "SIE Exchange Mgt.";
        SIEDescription: Text[50];
        SIEMgt: Codeunit "SIE Management";
        [InDataSet]
        Int1Visible: Boolean;
        [InDataSet]
        Int2Visible: Boolean;
        [InDataSet]
        Int3Visible: Boolean;
        [InDataSet]
        Int4Visible: Boolean;
        [InDataSet]
        Int5Visible: Boolean;
        [InDataSet]
        Int6Visible: Boolean;
        [InDataSet]
        Int7Visible: Boolean;
        [InDataSet]
        Int8Visible: Boolean;
        [InDataSet]
        Dec1Visible: Boolean;
        [InDataSet]
        Dec2Visible: Boolean;
        [InDataSet]
        Dec3Visible: Boolean;
        [InDataSet]
        Dec4Visible: Boolean;
        [InDataSet]
        Dec5Visible: Boolean;
        [InDataSet]
        Dec6Visible: Boolean;
        [InDataSet]
        Dec7Visible: Boolean;
        [InDataSet]
        Dec8Visible: Boolean;
        [InDataSet]
        Date1Visible: Boolean;
        [InDataSet]
        Date2Visible: Boolean;
        [InDataSet]
        Date3Visible: Boolean;
        [InDataSet]
        Date4Visible: Boolean;
        [InDataSet]
        Time1Visible: Boolean;
        [InDataSet]
        Time2Visible: Boolean;
        [InDataSet]
        Text50_1Visible: Boolean;
        [InDataSet]
        Text50_2Visible: Boolean;
        [InDataSet]
        Text100_1Visible: Boolean;
        [InDataSet]
        Code10_1Visible: Boolean;
        [InDataSet]
        Code10_2Visible: Boolean;
        [InDataSet]
        Code10_3Visible: Boolean;
        [InDataSet]
        Code20_1Visible: Boolean;
        [InDataSet]
        Code20_2Visible: Boolean;
        [InDataSet]
        Code20_3Visible: Boolean;
        [InDataSet]
        Text10_1Visible: Boolean;
        [InDataSet]
        Text10_2Visible: Boolean;
        OpenedFromBatch: Boolean;
        JnlSelected: Boolean;


    procedure SetVariableFields()
    begin
        Int1Visible := Rec.IsVFActive(Rec.FieldNo("Int 1"));
        Int2Visible := Rec.IsVFActive(Rec.FieldNo("Int 2"));
        Int3Visible := Rec.IsVFActive(Rec.FieldNo("Int 3"));
        Int4Visible := Rec.IsVFActive(Rec.FieldNo("Int 4"));
        Int5Visible := Rec.IsVFActive(Rec.FieldNo("Int 5"));
        Int6Visible := Rec.IsVFActive(Rec.FieldNo("Int 6"));
        Int7Visible := Rec.IsVFActive(Rec.FieldNo("Int 7"));
        Int8Visible := Rec.IsVFActive(Rec.FieldNo("Int 8"));

        Dec1Visible := Rec.IsVFActive(Rec.FieldNo("Decimal 1"));
        Dec2Visible := Rec.IsVFActive(Rec.FieldNo("Decimal 2"));
        Dec3Visible := Rec.IsVFActive(Rec.FieldNo("Decimal 3"));
        Dec4Visible := Rec.IsVFActive(Rec.FieldNo("Decimal 4"));
        Dec5Visible := Rec.IsVFActive(Rec.FieldNo("Decimal 5"));
        Dec6Visible := Rec.IsVFActive(Rec.FieldNo("Decimal 6"));
        Dec7Visible := Rec.IsVFActive(Rec.FieldNo("Decimal 7"));
        Dec8Visible := Rec.IsVFActive(Rec.FieldNo("Decimal 8"));

        Date1Visible := Rec.IsVFActive(Rec.FieldNo("Date 1"));
        Date2Visible := Rec.IsVFActive(Rec.FieldNo("Date 2"));
        Date3Visible := Rec.IsVFActive(Rec.FieldNo("Date 3"));
        Date4Visible := Rec.IsVFActive(Rec.FieldNo("Date 4"));

        Time1Visible := Rec.IsVFActive(Rec.FieldNo("Time 1"));
        Time2Visible := Rec.IsVFActive(Rec.FieldNo("Time 2"));

        Text50_1Visible := Rec.IsVFActive(Rec.FieldNo("Text50 1"));
        Text50_2Visible := Rec.IsVFActive(Rec.FieldNo("Text50 2"));

        Text100_1Visible := Rec.IsVFActive(Rec.FieldNo("Text100 1"));

        Code10_1Visible := Rec.IsVFActive(Rec.FieldNo("Code10 1"));
        Code10_2Visible := Rec.IsVFActive(Rec.FieldNo("Code10 2"));
        Code10_3Visible := Rec.IsVFActive(Rec.FieldNo("Code10 3"));

        Code20_1Visible := Rec.IsVFActive(Rec.FieldNo("Code20 1"));
        Code20_2Visible := Rec.IsVFActive(Rec.FieldNo("Code20 2"));
        Code20_3Visible := Rec.IsVFActive(Rec.FieldNo("Code20 3"));

        Text10_1Visible := Rec.IsVFActive(Rec.FieldNo("Text10 1"));
        Text10_2Visible := Rec.IsVFActive(Rec.FieldNo("Text10 2"));
    end;
}
*/