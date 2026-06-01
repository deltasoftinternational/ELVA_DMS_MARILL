Codeunit 25006004 "Variable Field Management"
{
    // 04.03.2014 Elva Baltic P7 #R114 MMG7.00
    //   * New function GetVFCodeByCode added
    // 
    // 26.06.2013 EDMS P8
    //   * Fix


    trigger OnRun()
    begin
    end;

    var
        Text001: label 'Undefined Variable Field';


    procedure GetVFCaption(TableNo: Integer; FieldNo: Integer; LanguageCode: Code[10]): Text[30]
    var
        VFUsage: Record "Variable Field Usage";
        VF: Record "Variable Field";
        VFTranslation: Record "Variable Field Translation";
    begin
        if VFUsage.Get(TableNo, FieldNo) then begin
            if VF.Get(VFUsage."Variable Field Code") then begin
                if not VF."Use Translations" then
                    exit(CopyStr(VF.Caption, 1, 30));
                if VFTranslation.Get(VF.Code, LanguageCode) then
                    exit(CopyStr(VFTranslation.Description, 1, 30))
                else
                    exit(CopyStr(VF.Caption, 1, 30));
            end;
        end;

        exit(Text001);
    end;


    procedure IsVFActive(TableNo: Integer; FieldNo: Integer): Boolean
    var
        VFUsage: Record "Variable Field Usage";
    begin
        VFUsage.Reset;
        if VFUsage.Get(TableNo, FieldNo) then
            exit(true);

        exit(false);
    end;


    procedure GetVFCaptionEx(TableNumber: Integer; FieldNumber: Integer; VFGroupCode: Code[10]): Text[80]
    var
        VFUsage: Record "Variable Field Usage";
    begin
        VFUsage.Reset;
        VFUsage.SetRange("Table No.", TableNumber);
        VFUsage.SetRange("Field No.", FieldNumber);
        //SETRANGE("Variable Field Group Code",VFGroupCode);  //26.11.2012 EB P1 - SIE Hotfix
        if VFUsage.FindFirst then
            exit(VFUsage."Variable Field Code"); //26.11.2012 EB P1 - SIE Hotfix
        exit(Text001);  //26.06.2013 EDMS P8
    end;


    procedure IsVFActiveEx(TableNumber: Integer; FieldNumber: Integer; VFGroupCode: Code[10]): Boolean
    var
        VFUsage: Record "Variable Field Usage";
    begin
        VFUsage.Reset;
        VFUsage.SetRange("Table No.", TableNumber);
        VFUsage.SetRange("Field No.", FieldNumber);
        //SETRANGE("Variable Field Group Code",VFGroupCode); //26.11.2012 EB P1 - SIE Hotfix
        exit(VFUsage.FindFirst);
        exit(false);
    end;


    procedure AssignFilterSPVerToVeh(var Vehicle: Record Vehicle; var ServicePackageVersionPar: Record "Service Package Version")
    var
        RecordRef1: RecordRef;
        RecordRef2: RecordRef;
        FieldRef1: FieldRef;
        FieldRef2: FieldRef;
        VFUsage1: Record "Variable Field Usage";
        VFUsage2: Record "Variable Field Usage";
        VariableField: Record "Variable Field";
        DocNoFieldRef: FieldRef;
        DocAmountFieldRef: FieldRef;
    begin
        // filter variable fields
        RecordRef2.Open(Database::Vehicle);
        RecordRef2.GetTable(Vehicle);

        RecordRef1.Open(Database::"Sales Header");
        DocNoFieldRef := RecordRef1.Field(3);
        DocAmountFieldRef := RecordRef1.Field(140);
        RecordRef1.Close;

        RecordRef1.Open(Database::"Service Package Version");

        VFUsage1.Reset;
        VFUsage1.SetRange("Table No.", Database::"Service Package Version");
        if VFUsage1.FindFirst then
            repeat
                VFUsage2.Reset;
                VFUsage2.SetCurrentkey("Variable Field Code");
                VFUsage2.SetRange("Table No.", Database::Vehicle);
                VFUsage2.SetRange("Variable Field Code", VFUsage1."Variable Field Code");
                if VFUsage2.FindFirst then begin
                    VariableField.Get(VFUsage1."Variable Field Code");
                    if VariableField."Use In Filtering" then begin
                        FieldRef1 := RecordRef2.Field(VFUsage2."Field No.");
                        RecordRef1.SetView(ServicePackageVersionPar.GetView);
                        FieldRef2 := RecordRef1.Field(VFUsage1."Field No.");
                        if FieldRef2.Type = DocNoFieldRef.Type then
                            FieldRef2.SetFilter('''''|%1', Format(FieldRef1.Value));
                        if FieldRef2.Type = DocAmountFieldRef.Type then
                            FieldRef2.SetFilter('0|%1', Format(FieldRef1.Value));
                        ServicePackageVersionPar.SetView(RecordRef1.GetView);
                    end;
                end;
            until VFUsage1.Next = 0;
    end;


    procedure GetVFCodeByCode(FieldCode: Code[10]): Integer
    var
        VFUsage: Record "Variable Field Usage";
        VF: Record "Variable Field";
        VFTranslation: Record "Variable Field Translation";
    begin
        if VF.Get(FieldCode) then begin
            VFUsage.Reset;
            VFUsage.SetRange("Variable Field Code", FieldCode);
            if VFUsage.FindFirst then begin
                exit(VFUsage."Field No.");
            end;
        end;
    end;
}

