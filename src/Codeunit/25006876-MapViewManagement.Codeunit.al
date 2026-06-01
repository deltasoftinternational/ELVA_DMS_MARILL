Codeunit 25006876 "MapView Management"
{

    trigger OnRun()
    begin
    end;

    var
        DataBuffer: Record "Data Buffer" temporary;


    procedure FillAddInData(var AddInDataToFill: Text)
    var
        OutStreamData: OutStream;
        InStreamData: InStream;
        ExportXmlPort: XmlPort "Export MapView Data";
        TempBlob: Codeunit "Temp Blob";
    // StreamReader: dotnet StreamReader;
    begin
        Clear(AddInDataToFill);
        //TempBlob.Init;
        //TempBlob.Insert;
        //TempBlob.Blob.CreateOutstream(OutStreamData);
        TempBlob.CreateOutStream(OutStreamData);
        ExportXmlPort.SetApiWebsource(GetApiWebsource);
        ExportXmlPort.SetZoomLevel(GetZoomLevel);
        ExportXmlPort.SetDataBuffer(DataBuffer);
        ExportXmlPort.SetDestination(OutStreamData);
        if ExportXmlPort.Export then begin
            if ExportXmlPort.Export then begin
                //TempBlob.CalcFields(Blob);
                //TempBlob.Blob.CreateInstream(InStreamData);
                TempBlob.CreateInstream(InStreamData);
                // StreamReader := StreamReader.StreamReader(InStreamData, true);
                // AddInDataToFill.AddText(StreamReader.ReadToEnd());
                InStreamData.Read(AddInDataToFill);
            end;
        end;
    end;


    procedure AddVehicleToMap(VehicleSerialNo: Code[20])
    var
        EntryNo: Integer;
        Vehicle: Record Vehicle;
        VehicleTelematics: Record "Vehicle Telematics";
    begin
        if Vehicle.Get(VehicleSerialNo) then begin
            VehicleTelematics.Reset;
            VehicleTelematics.SetCurrentkey("Date Stamp", "Entry No.");
            VehicleTelematics.SetRange("Vehicle Serial No.", Vehicle."Serial No.");
            if VehicleTelematics.FindLast then begin
                DataBuffer.Reset;
                if DataBuffer.FindLast then
                    EntryNo := DataBuffer."Entry No.";

                DataBuffer.Init;
                DataBuffer."Entry No." := EntryNo + 1;
                DataBuffer."Text Field 1" := Format(VehicleTelematics.Longitude);
                DataBuffer."Text Field 2" := Format(VehicleTelematics.Latitude);
                DataBuffer."Text Field 4" := Vehicle."Make Code" + ' ' + Vehicle."Model Code";
                DataBuffer.Insert;
            end;
        end;
    end;

    local procedure GetApiWebsource(): Text
    var
        WebSource: Record "Web Source";
        ServiceMgtSetup: Record "Service Mgt. Setup EDMS";
    begin
        ServiceMgtSetup.Get;
        if WebSource.Get(ServiceMgtSetup."Map Websource Code") then
            exit(WebSource.URL);
    end;


    procedure ClearVehiclesFromMap()
    begin
        DataBuffer.DeleteAll;
    end;

    local procedure GetZoomLevel(): Integer
    var
        WebSource: Record "Web Source";
        ServiceMgtSetup: Record "Service Mgt. Setup EDMS";
    begin
        ServiceMgtSetup.Get;
        exit(ServiceMgtSetup."Map Zoom Level");
    end;
}

