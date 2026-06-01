Codeunit 25006874 "Service Calendar Management"
{

    trigger OnRun()
    begin
    end;

    var
        DateFrom: Date;
        DateTo: Date;
        LocationCode: Code[20];
        SelectedDate: Date;
        SelectedDealType: Code[10];

    procedure FillAddInData(var AddInDataToFill: Text)
    var
        OutStreamData: OutStream;
        InStreamData: InStream;
        ExportXmlPort: XmlPort "Export Calendar Data";
        TempBlob: Codeunit "Temp Blob";
    // StreamReader: dotnet StreamReader;
    begin
        Clear(AddInDataToFill);
        //TempBlob.Init;
        //TempBlob.Insert;
        //TempBlob.Blob.CreateOutstream(OutStreamData);
        TempBlob.CreateOutStream(OutStreamData);
        ExportXmlPort.SetSelectedDate(SelectedDate);
        ExportXmlPort.SetLocationCode(LocationCode);
        ExportXmlPort.SetCalendarPeriod(DateFrom, DateTo);
        ExportXmlPort.SetDestination(OutStreamData);
        OnBeforeExportXmlPortCalendar(ExportXmlPort, SelectedDealType);
        if ExportXmlPort.Export then begin
            //TempBlob.CalcFields(Blob);
            //TempBlob.Blob.CreateInstream(InStreamData);
            TempBlob.CreateInstream(InStreamData);
            // StreamReader := StreamReader.StreamReader(InStreamData, true);
            // AddInDataToFill.AddText(StreamReader.ReadToEnd());
            InStreamData.Read(AddInDataToFill);
        end;
    end;


    procedure SetCalendarPeriod(DateFromToSet: Date; DateToToSet: Date)
    begin
        DateFrom := DateFromToSet;
        DateTo := DateToToSet;
    end;


    procedure SetLocationCode(LocationCodeToSet: Code[20])
    begin
        LocationCode := LocationCodeToSet;
    end;


    procedure SetSelectedDate(SelectedDateToSet: Date)
    begin
        SelectedDate := SelectedDateToSet;
    end;

    procedure SetSelectedDealType(SelectedDealTypeToSet: Code[10])
    begin
        SelectedDealType := SelectedDealTypeToSet;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeExportXmlPortCalendar(var ExportXmlPort: XmlPort "Export Calendar Data"; SelectedDealType: Code[10])
    begin
    end;
}

