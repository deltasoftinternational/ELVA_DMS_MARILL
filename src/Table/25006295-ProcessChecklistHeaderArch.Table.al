Table 25006295 "Process Checklist Header Arch."
{
    // 09/08/2018 EB.P30 GH
    //   Created

    Caption = 'Process Checklist Header';
    //DrillDownPageID = UnknownPage25006903;
    LookupPageID = "Process Checklist List";

    fields
    {
        field(10; "No."; Code[10])
        {
            Caption = 'No.';
        }
        field(20; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;

            trigger OnValidate()
            var
                Vehicle: Record Vehicle;
            begin
            end;
        }
        field(30; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(40; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
        }
        field(50; VIN; Code[20])
        {
            CalcFormula = lookup(Vehicle.VIN where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "Source Type"; Integer)
        {
            Caption = 'Source Type';
        }
        field(70; "Source Subtype"; Option)
        {
            Caption = 'Source Subtype';
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(80; "Source ID"; Code[20])
        {
            Caption = 'Source ID';
        }
        field(100; "Template Code"; Code[20])
        {
            Caption = 'Template Code';
            TableRelation = "Questionary Template";

            trigger OnValidate()
            var
                ChecklistLine: Record "Process Checklist Line";
            begin
            end;
        }
        field(140; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = ' ,Released,Canceled';
            OptionMembers = " ",Released,Canceled;
        }
        field(150; "Checklist Category"; Code[20])
        {
            Caption = 'Checklist Category';
            TableRelation = "Checklist Category";
        }
        field(200; "Process Date"; Date)
        {
            Caption = 'Process Date';
        }
        field(5044; "Time Archived"; Time)
        {
            Caption = 'Time Archived';
            DataClassification = ToBeClassified;
        }
        field(5045; "Date Archived"; Date)
        {
            Caption = 'Date Archived';
            DataClassification = ToBeClassified;
        }
        field(5046; "Archived By"; Code[20])
        {
            Caption = 'Archived By';
            DataClassification = ToBeClassified;
        }
        field(5047; "Version No."; Integer)
        {
            Caption = 'Version No.';
            DataClassification = ToBeClassified;
        }
        field(5048; "Doc. No. Occurrence"; Integer)
        {
            Caption = 'Doc. No. Occurrence';
            DataClassification = ToBeClassified;
        }
        field(25006650; "Process Status"; Option)
        {
            Caption = 'Process Status';
            OptionMembers = Pending,"In Progress",Completed;
        }
        field(25006660; "Creation Date"; Date)
        {
        }
        field(25006662; "Creation Time"; Time)
        {
        }
        field(25006670; "Completion Date"; Date)
        {
        }
        field(25006672; "Completion Time"; Time)
        {
        }
        field(25006680; "Completed by User ID"; Code[50])
        {
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(25006690; Type; Option)
        {
            OptionMembers = " ","Vehicle Inspection";
        }
        field(25006692; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(25006693; "Vehicle Registration No."; Code[20])
        {
            Caption = 'Vehicle Registration No.';

            trigger OnValidate()
            var
                Vehicle: Record Vehicle;
                TextConfirmVehManualCreate: label 'There is no vehicle with Registration No. %1 in the database. Do you want to create a new vehicle manually?';
                NewVehicleSerialNo: Code[20];
                VehicleSelected: Boolean;
            begin
            end;
        }
        field(25006695; "Confirmed by Advisor"; Boolean)
        {
        }
        field(25006697; "VHC No."; Code[20])
        {
            TableRelation = "Service Header EDMS"."No." where("Document Type" = const(VHC));
        }
        field(25006698; "VHC Doc. No. Occurrence"; Integer)
        {
            Caption = 'VHC Doc. No. Occurrence';
            DataClassification = ToBeClassified;
        }
        field(25006699; "VHC Version No."; Integer)
        {
            Caption = 'VHC Version No.';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.", "Doc. No. Occurrence", "Version No.")
        {
            Clustered = true;
        }
        key(Key2; "Vehicle Serial No.")
        {
        }
        key(Key3; "Source Type", "Source Subtype", "Source ID")
        {
        }
        key(Key4; Type, "Process Status", "Location Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ProcessChecklistLine: Record "Process Checklist Line";
    begin
    end;

    trigger OnInsert()
    var
        ProcessChecklistTemplate: Record "Questionary Template";
    begin
    end;


    procedure VehicleDescription(): Text
    var
        Vehicle: Record Vehicle;
    begin
        if "Vehicle Serial No." = '' then
            exit('');
        Vehicle.Get("Vehicle Serial No.");
        exit(Vehicle."Make Code" + ' ' + Vehicle."Model Code");
    end;
}

