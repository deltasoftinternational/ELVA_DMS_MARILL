tableextension 25006068 "Resource" extends Resource //156
{
    // 10.10.2016 EB.P7 #WSH16
    //   25006292"On Task Start"
    // 
    // 04.11.2013 EDMS P8
    //   * changed name of field 25006286
    fields
    {
        field(25006275; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            Description = 'Service Schedule';
            TableRelation = Employee;
        }
        field(25006276; "Serv. Schedule Password"; Text[20])
        {
            Caption = 'Serv. Schedule Password';
            Description = 'Service Schedule';
        }
        field(25006282; "Date Time Filter"; Decimal)
        {
            Caption = 'Date Time Filter';
            Description = 'Service Schedule';
            FieldClass = FlowFilter;
        }
        field(25006286; "Service Work Group Code"; Code[20])
        {
            Caption = 'Service Work Group Code';
            TableRelation = "Service Work Group";
        }
        field(25006290; "Allow Simultaneous Work"; Boolean)
        {
            Caption = 'Allow Simultaneous Work';
        }
        field(25006291; "Non Productive Hours"; Decimal)
        {
            FieldClass = FlowField;
        }
        field(25006292; "On Task Start"; Option)
        {
            OptionCaption = 'Do Nothing,Hold Other Tasks,Complete Other Tasks';
            OptionMembers = "Do Nothing","Hold Other Tasks","Complete Other Tasks";
        }

    }

}