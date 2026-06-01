tableextension 25006133 "To-do" extends "To-do" //5080
{
    // 19.01.2009. EDMS P2
    //   * Added function ClosedFromForm
    //   * Added code Closed - OnValidate
    // 
    // 30.05.2008. EDMS P2
    //   * Added code CheckDateForHoliday

    fields
    {
        field(25006000; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(25006010; "Service Source Type"; Integer)
        {
            Caption = 'Service Source Type';
        }
        field(25006020; "Service Source ID"; Code[20])
        {
            Caption = 'Service Source ID';

            trigger OnLookup()
            begin
                LookupServiceSourceID
            end;
        }
        field(25006030; VIN; Code[20])
        {
            CalcFormula = lookup(Vehicle.VIN where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006040; "Make Code"; Code[20])
        {
            CalcFormula = lookup(Vehicle."Make Code" where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Make Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006050; "Model Code"; Code[20])
        {
            CalcFormula = lookup(Vehicle."Model Code" where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Model Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006060; "Model Version No."; Code[20])
        {
            CalcFormula = lookup(Vehicle."Model Version No." where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Model Version No.';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    procedure LookupServiceSourceID()
    var
        ServiceHeader: Record "Service Header EDMS";
        PostedServiceHeader: Record "Posted Serv. Order Header";
        PstRetServiceHdr: Record "Posted Serv. Ret. Order Header";
    begin
        case "Service Source Type" of
            Database::"Service Header EDMS":
                begin
                    ServiceHeader."No." := "Service Source ID";
                    if Page.RunModal(0, ServiceHeader) = Action::LookupOK then
                        "Service Source ID" := ServiceHeader."No.";
                end;
            Database::"Posted Serv. Order Header":
                begin
                    PostedServiceHeader."No." := "Service Source ID";
                    if Page.RunModal(0, PostedServiceHeader) = Action::LookupOK then
                        "Service Source ID" := PostedServiceHeader."No.";
                end;
            Database::"Posted Serv. Ret. Order Header":
                begin
                    PstRetServiceHdr."No." := "Service Source ID";
                    if Page.RunModal(0, PstRetServiceHdr) = Action::LookupOK then
                        "Service Source ID" := PstRetServiceHdr."No.";
                end
        end;
    end;
}