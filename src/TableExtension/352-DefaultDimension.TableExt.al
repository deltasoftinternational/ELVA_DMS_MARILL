tableextension 25006065 "Default Dimension" extends "Default Dimension" //352
{
    // 24.02.2010 EDMS P2
    //   * Added code UpdateGlobalDimCode

    fields
    {

    }

    procedure UpdateServiceLaborEDMSGLobalDimCode(GlobalDimCodeNo: Integer; ServiceLaborNo: Code[20]; NewDimValue: Code[20])
    var
        ServiceLabor: Record "Service Labor";
    begin
        if ServiceLabor.Get(ServiceLaborNo) then begin
            case GlobalDimCodeNo of
                1:
                    ServiceLabor."Global Dimension 1 Code" := NewDimValue;
                2:
                    ServiceLabor."Global Dimension 2 Code" := NewDimValue;
            end;
            ServiceLabor.Modify(true);
        end;
    end;
}