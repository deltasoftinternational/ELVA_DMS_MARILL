Codeunit 25006009 "Vehicle Change Log Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        recVehChangeLog: Record "Vehicle Change Log";
        recVehChangeLog2: Record "Vehicle Change Log";


    procedure fRegisterChange(var recVehicle: Record Vehicle; var xrecVehicle: Record Vehicle; intFieldNo: Integer)
    var
        ishandled: Boolean;
    begin
        OnbeforefRegisterChange(ishandled);
        if ishandled then
            exit;
        case intFieldNo of
            recVehicle.FieldNo("Status Code"):
                begin
                    fInitEntry(recVehicle);
                    recVehChangeLog."Field No." := recVehicle.FieldNo("Status Code");
                    recVehChangeLog."Field Description" := recVehicle.FieldCaption("Status Code");
                    recVehChangeLog."Old Value" := xrecVehicle."Status Code";
                    recVehChangeLog."New Value" := recVehicle."Status Code";
                    fInsertEntry(recVehicle);
                end;
            recVehicle.FieldNo("Tracking Code"):
                begin
                    fInitEntry(recVehicle);
                    recVehChangeLog."Field No." := recVehicle.FieldNo("Tracking Code");
                    recVehChangeLog."Field Description" := recVehicle.FieldCaption("Tracking Code");
                    recVehChangeLog."Old Value" := xrecVehicle."Tracking Code";
                    recVehChangeLog."New Value" := recVehicle."Tracking Code";
                    fInsertEntry(recVehicle);
                end;
            recVehicle.FieldNo(VIN):
                begin
                    fInitEntry(recVehicle);
                    recVehChangeLog."Field No." := recVehicle.FieldNo(VIN);
                    recVehChangeLog."Field Description" := recVehicle.FieldCaption(VIN);
                    recVehChangeLog."Old Value" := xrecVehicle.VIN;
                    recVehChangeLog."New Value" := recVehicle.VIN;
                    fInsertEntry(recVehicle);
                end;
            recVehicle.FieldNo("Registration No."):
                begin
                    fInitEntry(recVehicle);
                    recVehChangeLog."Field No." := recVehicle.FieldNo("Registration No.");
                    recVehChangeLog."Field Description" := recVehicle.FieldCaption("Registration No.");
                    recVehChangeLog."Old Value" := xrecVehicle."Registration No.";
                    recVehChangeLog."New Value" := recVehicle."Registration No.";
                    fInsertEntry(recVehicle);
                end;
        end;
    end;


    procedure fInitEntry(var recVehicle: Record Vehicle)
    begin
        recVehChangeLog.Init;
        recVehChangeLog."Vehicle Serial No." := recVehicle."Serial No.";
        recVehChangeLog."User ID" := UserId;
        recVehChangeLog."Date of Change" := WorkDate;
        recVehChangeLog."Time of Change" := Time;
    end;


    procedure fInsertEntry(var recVehicle: Record Vehicle)
    begin
        recVehChangeLog."Change No." := fGetLastChangeNo(recVehicle) + 1;

        recVehChangeLog."Type of Change" := recVehChangeLog."type of change"::Modify;
        if recVehChangeLog."Old Value" = '' then
            recVehChangeLog."Type of Change" := recVehChangeLog."type of change"::Insert;
        if recVehChangeLog."New Value" = '' then
            recVehChangeLog."Type of Change" := recVehChangeLog."type of change"::Delete;

        recVehChangeLog.Insert;
    end;


    procedure fGetLastChangeNo(var recVehicle: Record Vehicle): Integer
    begin
        recVehChangeLog2.Reset;
        recVehChangeLog2.SetRange("Vehicle Serial No.", recVehicle."Serial No.");
        if recVehChangeLog2.FindLast then
            exit(recVehChangeLog2."Change No.")
        else
            exit(0)
    end;

    [IntegrationEvent(false, false)]
    local procedure OnbeforefRegisterChange(var ishandled: Boolean)
    begin
    end;
}

