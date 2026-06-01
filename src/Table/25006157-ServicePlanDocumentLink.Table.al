Table 25006157 "Service Plan Document Link"
{
    // 28.01.2010 EDMSB P2
    //   * Added code "Document No."-OnValidate

    Caption = 'Service Plan Document Link';

    fields
    {
        field(10; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(30; "Serv. Plan No."; Code[10])
        {
            Caption = 'Serv. Plan No.';
            TableRelation = "Vehicle Service Plan"."No." where("Vehicle Serial No." = field("Vehicle Serial No."));
        }
        field(35; "Plan Stage Recurrence"; Integer)
        {
            Caption = 'Plan Stage Recurrence';
        }
        field(40; "Serv. Plan Stage Code"; Code[10])
        {
            Caption = 'Serv. Plan Stage Code';
            TableRelation = "Vehicle Service Plan Stage".Code where("Vehicle Serial No." = field("Vehicle Serial No."),
                                                                     Recurrence = field("Plan Stage Recurrence"),
                                                                     "Plan No." = field("Serv. Plan No."));
        }
        field(50; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Order,Return Order,Posted Order,Posted Return Order,Quote,Booking';
            OptionMembers = "Order","Return Order","Posted Order","Posted Return Order",Quote,Booking;
        }
        field(60; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = if ("Document Type" = const(Order)) "Service Header EDMS"."No." where("Document Type" = const(Order))
            else
            if ("Document Type" = const("Return Order")) "Service Header EDMS"."No." where("Document Type" = const("Return Order"))
            else
            if ("Document Type" = const("Posted Order")) "Posted Serv. Order Header"."No."
            else
            if ("Document Type" = const("Posted Return Order")) "Posted Serv. Ret. Order Header"."No.";

            trigger OnValidate()
            begin
                ServicePlanManagement.DocLinkApply(Rec);
            end;
        }
    }

    keys
    {
        key(Key1; "Vehicle Serial No.", "Serv. Plan No.", "Plan Stage Recurrence", "Serv. Plan Stage Code", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Document Type", "Document No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        ServicePlanDocumentLink.Reset;
        ServicePlanDocumentLink.SetRange("Vehicle Serial No.", Rec."Vehicle Serial No.");
        ServicePlanDocumentLink.SetRange("Serv. Plan No.", Rec."Serv. Plan No.");
        ServicePlanDocumentLink.SetRange("Plan Stage Recurrence", Rec."Plan Stage Recurrence");
        ServicePlanDocumentLink.SetRange("Serv. Plan Stage Code", Rec."Serv. Plan Stage Code");
        ServicePlanDocumentLink.SetRange("Document Type", Rec."Document Type");
        ServicePlanDocumentLink.SetRange("Document No.", Rec."Document No.");
        if ServicePlanDocumentLink.Count <= 1 then begin
            VehicleServicePlanStage.Reset;
            if VehicleServicePlanStage.Get(Rec."Vehicle Serial No.", Rec."Serv. Plan No.",
                Rec."Plan Stage Recurrence", Rec."Serv. Plan Stage Code") then
                if VehicleServicePlanStage.Status = VehicleServicePlanStage.Status::"In Process" then begin
                    VehicleServicePlanStage.Status := VehicleServicePlanStage.Status::Pending;
                    VehicleServicePlanStage."Service Date" := 0D;
                    VehicleServicePlanStage.Modify;
                end;
        end;
    end;

    var
        ServicePlanDocumentLink: Record "Service Plan Document Link";
        VehicleServicePlanStage: Record "Vehicle Service Plan Stage";
        ServicePlanManagement: Codeunit "Service Plan Management";
}

