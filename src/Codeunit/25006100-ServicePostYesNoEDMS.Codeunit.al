Codeunit 25006100 "Service-Post (Yes/No) EDMS"
{
    TableNo = "Service Header EDMS";
    EventSubscriberInstance = Manual;

    trigger OnRun()
    begin
        ServiceHeader.Copy(Rec);
        Code;
        Rec := ServiceHeader;
    end;

    var
        ServicePost: Codeunit "Service-Post EDMS";
        ServiceHeader: Record "Service Header EDMS";
        Text001: label 'Do you want to post the %1?';

        ServicePostYesNo: Codeunit "Service-Post (Yes/No) EDMS";
        IsHandled: Boolean;

    procedure "Code"()
    var
        ReleaseServDoc: Codeunit "Release Service Document EDMS";
    begin
        OnBeforeCodeServicePostYesNoEDMS(ServiceHeader, IsHandled);
        if not IsHandled then
            case ServiceHeader."Document Type" of
                ServiceHeader."document type"::Order:
                    begin
                        OnBeforeConfirmPostServiceOrder(ServiceHeader, IsHandled);
                        if not IsHandled then
                            if Confirm(Text001, false, ServiceHeader."Document Type") then begin
                                ReleaseServDoc.PerformManualRelease(ServiceHeader);
                                ServicePost.Run(ServiceHeader);
                            end;
                    end;
                ServiceHeader."document type"::"Return Order":
                    if Confirm(Text001, false, ServiceHeader."Document Type") then begin
                        ReleaseServDoc.PerformManualRelease(ServiceHeader);
                        ServicePost.Run(ServiceHeader);
                    end;
            end
    end;

    procedure "Preview"(var ServiceHeaderEDMS: Record "Service Header EDMS")
    var

        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
    begin
        BINDSUBSCRIPTION(ServicePostYesNo);
        GenJnlPostPreview.Preview(ServicePostYesNo, ServiceHeaderEDMS);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Preview", 'OnRunPreview', '', false, false)]
    procedure OnRunPreview(var Result: Boolean; Subscriber: Variant; RecVar: Variant)
    var
        ServiceHeaderEDMS: Record "Service Header EDMS";
        ServicePostEDMS: Codeunit "Service-Post EDMS";
    begin
        ServicePostEDMS.SetPreviewMode(TRUE);
        ServiceHeaderEDMS.COPY(RecVar);
        Result := ServicePostEDMS.RUN(ServiceHeaderEDMS);

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeConfirmPostServiceOrder(var ServiceHeader: Record "Service Header EDMS"; var IsHandled: boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCodeServicePostYesNoEDMS(var ServiceHeader: Record "Service Header EDMS"; var IsHandled: boolean)
    begin
    end;
}

