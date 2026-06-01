Codeunit 25006138 "Checklist AddIn Management"
{
    // 10/08/2018 EB.P30 GH
    //   Added function:
    //     FillCheckListArch


    trigger OnRun()
    begin
    end;

    var
        ItemNotFoundByBarcodeErr: label 'Item barcode not found';
        ItemNotSelectedErr: label 'No item selected';
        ActLineNoSelected: Integer;
        CallBackName: Text;
        CallBackParam1: Text;
        CallBackParam2: Text;
        CallBackParam3: Text;
        CallBackParam4: Text;
        CallBackParam5: Text;
        CheckListBuff: Record "Checklist Buffer" temporary;


    procedure CheckListControlAddInReady(var AddInData: Text)
    begin
        FillAddInData(AddInData);
    end;


    procedure FillAddInData(var AddInDataToFill: Text)
    var
        OutStreamData: OutStream;
        InStreamData: InStream;
        ExportXmlPort: XmlPort "Export Checklist Data";
        //TempBlob: Record TempBlob temporary;
        TempBlob: Codeunit "Temp Blob";
        // StreamReader: dotnet StreamReader;
        WhsActivityHeader: Record "Warehouse Activity Header";
    begin
        Clear(AddInDataToFill);
        //TempBlob.Init;
        //TempBlob.Insert;
        //TempBlob.Blob.CreateOutstream(OutStreamData);
        TempBlob.CreateOutStream(OutStreamData);

        ExportXmlPort.FillItemCheckList(CheckListBuff);
        ExportXmlPort.SetDestination(OutStreamData);

        if ExportXmlPort.Export then begin
            //TempBlob.CalcFields(Blob);
            //TempBlob.Blob.CreateInstream(InStreamData);
            InStreamData := TempBlob.CreateInstream(TextEncoding::UTF8);
            InStreamData.Read(AddInDataToFill);
            // StreamReader := StreamReader.StreamReader(InStreamData, true);
            // AddInDataToFill.AddText(StreamReader.ReadToEnd());
        end;
    end;


    procedure ClearListData(KeepSelectedLineNo: Boolean)
    begin
        CallBackName := '';
        CallBackParam1 := '';
        CallBackParam2 := '';
        CallBackParam3 := '';
        CallBackParam4 := '';
        CallBackParam5 := '';

        CheckListBuff.Reset;
        CheckListBuff.DeleteAll;

        if not KeepSelectedLineNo then
            ActLineNoSelected := 0;
    end;


    procedure CheckListRequestRefreshPage(var AddInData: Text; ActLineNo: Integer)
    begin
        FillAddInData(AddInData);
    end;


    procedure FillCheckList(ChecklistHeader: Record "Process Checklist Header"; var GHCheckList: Record "Checklist Buffer")
    var
        ChecklistLine: Record "Process Checklist Line";
        LastQuestionLineNo: Integer;
        BuffRecref: RecordRef;
        FieldRef: FieldRef;
        FieldNo: Integer;
    begin

        ClearListData(false);

        ChecklistLine.Reset;
        ChecklistLine.SetRange("Process Checklist No.", ChecklistHeader."No.");
        if ChecklistLine.FindFirst then
            repeat
                CheckListBuff.Init;
                CheckListBuff."Line No." := ChecklistLine."Line No.";
                CheckListBuff.Caption := ChecklistLine."Question Text";
                case ChecklistLine."Line Type" of
                    ChecklistLine."line type"::Group:
                        begin
                            CheckListBuff.Type := CheckListBuff.Type::Group;
                        end;
                    ChecklistLine."line type"::Line:
                        begin
                            CheckListBuff.Type := CheckListBuff.Type::Item;
                            LastQuestionLineNo := ChecklistLine."Line No.";
                            CheckListBuff.IsBold := ChecklistLine.IsBold;
                            CheckListBuff.IsMandatory := ChecklistLine.IsMandatory;
                        end;
                    ChecklistLine."line type"::Control:
                        begin
                            IF ChecklistHeader."Process Status" = ChecklistHeader."Process Status"::Completed THEN
                                CheckListBuff.IsDisabled := TRUE;
                            CheckListBuff.Type := CheckListBuff.Type::" ";
                            case ChecklistLine.SubType of
                                ChecklistLine.Subtype::"Textbox-Small":
                                    begin
                                        CheckListBuff."Sub Type" := CheckListBuff."sub type"::TextSmall;
                                        CheckListBuff.Value := ChecklistLine."Value Description";

                                        FieldNo := ChecklistLine.FieldNo("Value Description");
                                        if BuffRecref.Number = 0 then
                                            BuffRecref.Open(Database::"Process Checklist Line");
                                        FieldRef := BuffRecref.Field(FieldNo);
                                        CheckListBuff.TextLength := FieldRef.Length;
                                    end;
                                ChecklistLine.Subtype::"Textbox-Standard":
                                    begin
                                        CheckListBuff."Sub Type" := CheckListBuff."sub type"::TextNormal;
                                        CheckListBuff.Value := ChecklistLine."Value Description";

                                        FieldNo := ChecklistLine.FieldNo("Value Description");
                                        if BuffRecref.Number = 0 then
                                            BuffRecref.Open(Database::"Process Checklist Line");
                                        FieldRef := BuffRecref.Field(FieldNo);
                                        CheckListBuff.TextLength := FieldRef.Length;
                                    end;
                                ChecklistLine.Subtype::"Radio Button":
                                    begin
                                        CheckListBuff."Sub Type" := CheckListBuff."sub type"::Radio;
                                        CheckListBuff.Selected := ChecklistLine."Value Bool";
                                        //CheckListBuff.Value := ChecklistLine."Question Text";
                                    end;
                                ChecklistLine.Subtype::Checkbox:
                                    begin
                                        CheckListBuff."Sub Type" := CheckListBuff."sub type"::Check;
                                        CheckListBuff.Selected := ChecklistLine."Value Bool";
                                        //CheckListBuff.Value := ChecklistLine."Question Text";
                                    end;
                                ChecklistLine.Subtype::Button:
                                    CheckListBuff."Sub Type" := CheckListBuff."sub type"::Button;
                            end;
                            CheckListBuff."Parent Line No." := LastQuestionLineNo;
                            CheckListBuff.Color := ChecklistLine."Control Color";
                            CheckListBuff."Assist Edit" := ChecklistLine."Control AssistEdit";
                        end;
                end;
                //IF ChecklistLine."Line Type" = ChecklistLine."Line Type"::Group THEN
                //  CheckListBuff.Group := TRUE;
                //CheckListBuff.Value := ChecklistLine."Value Int" +1;

                CheckListBuff.Insert;
                GHCheckList.Init;
                GHCheckList := CheckListBuff;
                GHCheckList.Insert;
            until ChecklistLine.Next = 0;
        /*
        
        ClearListData(FALSE);
        
        CheckListBuff.INIT;
        CheckListBuff."Line No." := 1;
        CheckListBuff.Caption := 'Group Number 1';
        CheckListBuff.Type := CheckListBuff.Type::Group;
        CheckListBuff.INSERT;
        
        CheckListBuff.INIT;
        CheckListBuff."Line No." := 2;
        CheckListBuff.Caption := 'Item Number 1';
        CheckListBuff.Type := CheckListBuff.Type::Item;
        CheckListBuff.INSERT;
        
        CheckListBuff.INIT;
        CheckListBuff."Line No." := 3;
        CheckListBuff."Parent Line No." := 2;
        CheckListBuff.Caption := 'Control 1';
        CheckListBuff.Value := '1';
        CheckListBuff.Color := '#FFBB00';
        CheckListBuff."Sub Type" := CheckListBuff."Sub Type"::Radio;
        CheckListBuff.INSERT;
        
        CheckListBuff.INIT;
        CheckListBuff."Line No." := 4;
        CheckListBuff."Parent Line No." := 2;
        CheckListBuff.Caption := 'Control 2';
        CheckListBuff.Value := '2';
        CheckListBuff.Color := '#00A1F1';
        CheckListBuff."Sub Type" := CheckListBuff."Sub Type"::Radio;
        CheckListBuff.INSERT;
        
        CheckListBuff.INIT;
        CheckListBuff."Line No." := 5;
        CheckListBuff."Parent Line No." := 2;
        CheckListBuff.Caption := 'Control 3';
        CheckListBuff.Value := '3';
        CheckListBuff.Color := '#7CBB00';
        CheckListBuff."Sub Type" := CheckListBuff."Sub Type"::Radio;
        CheckListBuff.Selected := TRUE;
        CheckListBuff.INSERT;
        
        CheckListBuff.INIT;
        CheckListBuff."Line No." := 6;
        CheckListBuff."Parent Line No." := 2;
        CheckListBuff.Caption := 'Control 4';
        CheckListBuff.Value := '4';
        CheckListBuff.Color := '#F65314';
        CheckListBuff."Sub Type" := CheckListBuff."Sub Type"::Radio;
        CheckListBuff.INSERT;
        
        CheckListBuff.INIT;
        CheckListBuff."Line No." := 7;
        CheckListBuff."Parent Line No." := 2;
        CheckListBuff.Caption := 'Test Caption 7';
        CheckListBuff.Value := 'Test Value 7';
        CheckListBuff.Color := '#F65314';
        CheckListBuff."Sub Type" := CheckListBuff."Sub Type"::TextNormal;
        CheckListBuff."Assist Edit" := TRUE;
        CheckListBuff.INSERT;
        
        CheckListBuff.INIT;
        CheckListBuff."Line No." := 8;
        CheckListBuff.Caption := 'Item Number 2';
        CheckListBuff.Type := CheckListBuff.Type::Item;
        CheckListBuff.INSERT;
        
        CheckListBuff.INIT;
        CheckListBuff."Line No." := 9;
        CheckListBuff."Parent Line No." := 8;
        CheckListBuff.Caption := 'Control 1';
        CheckListBuff.Value := '1';
        CheckListBuff.Color := '#FFBB00';
        CheckListBuff."Sub Type" := CheckListBuff."Sub Type"::Check;
        CheckListBuff.INSERT;
        
        CheckListBuff.INIT;
        CheckListBuff."Line No." := 10;
        CheckListBuff."Parent Line No." := 8;
        CheckListBuff.Caption := 'Control 2';
        CheckListBuff.Value := '2';
        CheckListBuff.Color := '#00A1F1';
        CheckListBuff."Sub Type" := CheckListBuff."Sub Type"::Check;
        CheckListBuff.Selected := TRUE;
        CheckListBuff.INSERT;
        
        CheckListBuff.INIT;
        CheckListBuff."Line No." := 11;
        CheckListBuff."Parent Line No." := 8;
        CheckListBuff.Caption := 'Test Caption 11';
        CheckListBuff.Value := 'Test Value 11';
        CheckListBuff.Color := '#00A1F1';
        CheckListBuff."Sub Type" := CheckListBuff."Sub Type"::TextSmall;
        CheckListBuff."Assist Edit" := TRUE;
        CheckListBuff.INSERT;
        
        CheckListBuff.INIT;
        CheckListBuff."Line No." := 12;
        CheckListBuff."Parent Line No." := 8;
        CheckListBuff.Caption := 'Test Caption 12';
        CheckListBuff.Value := 'Test Value 12';
        CheckListBuff.Color := '#00A1F1';
        CheckListBuff."Sub Type" := CheckListBuff."Sub Type"::TextSmall;
        CheckListBuff."Assist Edit" := TRUE;
        CheckListBuff.INSERT;
        
        CheckListBuff.INIT;
        CheckListBuff."Line No." := 13;
        CheckListBuff."Parent Line No." := 8;
        CheckListBuff.Caption := 'Test Caption 13';
        CheckListBuff.Value := '';
        CheckListBuff.Color := '#00A1F1';
        CheckListBuff."Sub Type" := CheckListBuff."Sub Type"::TextSmall;
        CheckListBuff."Assist Edit" := TRUE;
        CheckListBuff.INSERT;
        
        CheckListBuff.INIT;
        CheckListBuff."Line No." := 14;
        CheckListBuff.Caption := 'Group Number 2';
        CheckListBuff.Type := CheckListBuff.Type::Group;
        CheckListBuff.INSERT;
        
        CheckListBuff.INIT;
        CheckListBuff."Line No." := 15;
        CheckListBuff.Caption := 'Item Number 3';
        CheckListBuff.Type := CheckListBuff.Type::Item;
        CheckListBuff.INSERT;
        
        CheckListBuff.INIT;
        CheckListBuff."Line No." := 16;
        CheckListBuff."Parent Line No." := 15;
        CheckListBuff.Caption := 'Button 1';
        CheckListBuff.Value := 'val1';
        CheckListBuff.Color := '#00A1F1';
        CheckListBuff."Sub Type" := CheckListBuff."Sub Type"::Button;
        CheckListBuff.INSERT;
        
        CheckListBuff.INIT;
        CheckListBuff."Line No." := 17;
        CheckListBuff."Parent Line No." := 15;
        CheckListBuff.Caption := 'Button 2';
        CheckListBuff.Value := 'val1';
        CheckListBuff.Color := '#00A1F1';
        CheckListBuff."Sub Type" := CheckListBuff."Sub Type"::Button;
        CheckListBuff.INSERT;
        */

    end;


    procedure FillCheckListArch(ChecklistHeader: Record "Process Checklist Header Arch."; var GHCheckList: Record "Checklist Buffer")
    var
        ChecklistLine: Record "Process Checklist Line Arch.";
        LastQuestionLineNo: Integer;
    begin

        ClearListData(false);

        ChecklistLine.Reset;
        ChecklistLine.SetRange("Process Checklist No.", ChecklistHeader."No.");
        ChecklistLine.SetRange("Doc. No. Occurrence", ChecklistHeader."Doc. No. Occurrence");
        ChecklistLine.SetRange("Version No.", ChecklistHeader."Version No.");
        if ChecklistLine.FindFirst then
            repeat
                CheckListBuff.Init;
                CheckListBuff."Line No." := ChecklistLine."Line No.";
                CheckListBuff.Caption := ChecklistLine."Question Text";
                case ChecklistLine."Line Type" of
                    ChecklistLine."line type"::Group:
                        begin
                            CheckListBuff.Type := CheckListBuff.Type::Group;
                        end;
                    ChecklistLine."line type"::Line:
                        begin
                            CheckListBuff.Type := CheckListBuff.Type::Item;
                            LastQuestionLineNo := ChecklistLine."Line No.";
                        end;
                    ChecklistLine."line type"::Control:
                        begin
                            CheckListBuff.Type := CheckListBuff.Type::" ";
                            case ChecklistLine.SubType of
                                ChecklistLine.Subtype::"Textbox-Small":
                                    begin
                                        CheckListBuff."Sub Type" := CheckListBuff."sub type"::TextSmall;
                                        CheckListBuff.Value := ChecklistLine."Value Description";
                                    end;
                                ChecklistLine.Subtype::"Textbox-Standard":
                                    begin
                                        CheckListBuff."Sub Type" := CheckListBuff."sub type"::TextNormal;
                                        CheckListBuff.Value := ChecklistLine."Value Description";
                                    end;
                                ChecklistLine.Subtype::"Radio Button":
                                    begin
                                        CheckListBuff."Sub Type" := CheckListBuff."sub type"::Radio;
                                        CheckListBuff.Selected := ChecklistLine."Value Bool";
                                    end;
                                ChecklistLine.Subtype::Checkbox:
                                    begin
                                        CheckListBuff."Sub Type" := CheckListBuff."sub type"::Check;
                                        CheckListBuff.Selected := ChecklistLine."Value Bool";
                                    end;
                                ChecklistLine.Subtype::Button:
                                    CheckListBuff."Sub Type" := CheckListBuff."sub type"::Button;
                            end;
                            CheckListBuff."Parent Line No." := LastQuestionLineNo;
                            CheckListBuff.Color := ChecklistLine."Control Color";
                            CheckListBuff."Assist Edit" := ChecklistLine."Control AssistEdit";
                        end;
                end;

                CheckListBuff.Insert;
                GHCheckList.Init;
                GHCheckList := CheckListBuff;
                GHCheckList.Insert;
            until ChecklistLine.Next = 0;
    end;


    procedure "RequestTextChange"(DocumenNo: Code[20]; LineNo: Integer; Val: Text)
    var
        ChecklistLine: Record "Process Checklist Line";
        Checklist: Record "Process Checklist Header";
    begin
        if Checklist.Get(DocumenNo) then begin
            ChecklistLine.Get(DocumenNo, LineNo);
            ChecklistLine.Validate("Value Description", CopyStr(Val, 1, MaxStrLen(ChecklistLine."Value Description")));
            ChecklistLine.Modify(true);

            if Checklist."Process Status" <> Checklist."process status"::"In Progress" then
                Checklist.Validate("Process Status", Checklist."process status"::"In Progress");
        end;
    end;

    procedure "RequestRadioChange"(DocumenNo: Code[20]; LineNo: Integer; Val: Text)
    var
        ChecklistLine: Record "Process Checklist Line";
        Checklist: Record "Process Checklist Header";
    begin
        if Checklist.Get(DocumenNo) then begin
            ChecklistLine.Get(DocumenNo, LineNo);
            ChecklistLine.Validate("Value Bool", true);
            ChecklistLine.Modify(true);
            ChecklistLine.SetRange("Process Checklist No.", DocumenNo);
            ChecklistLine.SetRange("Parent Line No.", ChecklistLine."Parent Line No.");
            ChecklistLine.SetFilter("Line No.", '<>%1', ChecklistLine."Line No.");
            ChecklistLine.ModifyAll("Value Bool", false);

            if Checklist."Process Status" <> Checklist."process status"::"In Progress" then
                Checklist.Validate("Process Status", Checklist."process status"::"In Progress");
        end;
    end;

    procedure "RequestCheckChange"(DocumenNo: Code[20]; LineNo: Integer; Val: Text)
    var
        ChecklistLine: Record "Process Checklist Line";
        Checklist: Record "Process Checklist Header";
    begin
        if Checklist.Get(DocumenNo) then begin
            ChecklistLine.Get(DocumenNo, LineNo);
            ChecklistLine.Validate("Value Bool", not ChecklistLine."Value Bool");
            ChecklistLine.Modify(true);

            if Checklist."Process Status" <> Checklist."process status"::"In Progress" then
                Checklist.Validate("Process Status", Checklist."process status"::"In Progress");
        end;
    end;

    procedure "RequestExtendedText"(DocumenNo: Code[20]; LineNo: Integer; Val: Text)
    var
        ChecklistLine: Record "Process Checklist Line";
        Checklist: Record "Process Checklist Header";
        ExtendedText: Page "Service Extended Text";
    begin
        if Checklist.Get(DocumenNo) then begin
            ExtendedText.SetFieldLabel('');
            ExtendedText.SetFieldLength(10);
            ExtendedText.RunModal;
        end;
    end;


}

