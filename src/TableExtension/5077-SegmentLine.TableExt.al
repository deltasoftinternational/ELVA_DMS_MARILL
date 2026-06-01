tableextension 25006129 "Segment Line" extends "Segment Line" //5077
{
    // 10.11.2015 EB.P30 #T065
    //   Added field "Vehicle Serial No."
    // 
    // 17.07.2013 EDMS P8
    //   * added fenction ShowContactVehicles, GetFirstVehicleNo
    // 
    // 01-08-2007 EDMS P3
    //   * AutoFill of description on interaction template change
    fields
    {
        field(25006000; "Vehicles Count"; Integer)
        {
            CalcFormula = count("Segment SubLine" where("Segment No." = field("Segment No."),
                                                         "Line No." = field("Line No.")));
            FieldClass = FlowField;
        }
        field(25006010; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
    }


    procedure CreateInteractionFromVehicle(var Vehicle: Record Vehicle)
    var
        UserSetup: Record "User Setup";
        PurchSlsPer: Record "Salesperson/Purchaser";
    begin
        //19.07.2013 EDMS P8

        DeleteAll;
        Init;
        SetRange("Vehicle Serial No.", Vehicle."Serial No.");
        Validate("Vehicle Serial No.", Vehicle."Serial No.");
        if UserSetup.Get(UserId) then;
        if PurchSlsPer.Get(UserSetup."Salespers./Purch. Code") then
            "Salesperson Code" := UserSetup."Salespers./Purch. Code";
        StartWizardVehicle;
    end;


    procedure StartWizardVehicle()
    var
        Opp: Record Opportunity;
    begin
        if Campaign.Get("Campaign No.") then
            "Campaign Description" := Campaign.Description;
        if Opp.Get("Opportunity No.") then
            "Opportunity Description" := Opp.Description;
        "Wizard Step" := "wizard step"::"1";
        "Interaction Successful" := true;
        Validate(Date, WorkDate);
        Insert;
        Page.RunModal(Page::"Create Interaction", Rec, "Interaction Template Code");
    end;


    procedure ShowContactVehicles()
    var
        VehicleContactL: Record "Vehicle Contact";
        ContactL: Record Contact;
        VehicleL: Record Vehicle;
        SegmentSubLineL: Record "Segment SubLine";
        VehNoFilter: Text[1024];
    begin
        /*
        IF ContactL.GET("Contact No.") THEN BEGIN
          VehicleContactL.RESET;
          VehicleContactL.SETRANGE("Contact No.", "Contact No.");
          IF VehicleContactL.FINDFIRST THEN BEGIN
            REPEAT
              VehNoFilter += VehicleContactL."Vehicle Serial No." + '|';
            UNTIL VehicleContactL.NEXT = 0;
            VehNoFilter := COPYSTR(VehNoFilter, 1, STRLEN(VehNoFilter)-1);
            VehicleL.RESET;
            VehicleL.SETFILTER("Serial No.", VehNoFilter);
            PAGE.RUN(0, VehicleL);
          END;
        END;
         */
        SegmentSubLineL.Reset;
        SegmentSubLineL.SetRange("Segment No.", "Segment No.");
        SegmentSubLineL.SetRange("Line No.", "Line No.");
        Page.Run(0, SegmentSubLineL);

    end;


    procedure VehicleRangeToSublines(VehiclePar: Record Vehicle)
    var
        SegmentSubLineL: Record "Segment SubLine";
        NextLineNo: Integer;
    begin
        //it supposed that VehiclePar is filtered or temporary record
        if VehiclePar.FindFirst then begin
            SegmentSubLineL.Reset;
            SegmentSubLineL.SetRange("Segment No.", "Segment No.");
            SegmentSubLineL.SetRange("Line No.", "Line No.");
            if SegmentSubLineL.FindLast then
                NextLineNo := SegmentSubLineL."SubLine No." + 10000
            else
                NextLineNo := 10000;

            repeat
                VehicleAddToSublines(VehiclePar."Serial No.", NextLineNo);
                NextLineNo += 10000;
            until VehiclePar.Next = 0;
        end;
    end;


    procedure VehicleAddToSublines(VehSerNo: Code[20]; NextLineNo: Integer)
    var
        SegmentSubLineL: Record "Segment SubLine";
    begin
        if NextLineNo = 0 then begin
            SegmentSubLineL.Reset;
            SegmentSubLineL.SetRange("Segment No.", "Segment No.");
            SegmentSubLineL.SetRange("Line No.", "Line No.");
            if SegmentSubLineL.FindLast then
                NextLineNo := SegmentSubLineL."SubLine No." + 10000
            else
                NextLineNo := 10000;
        end;
        SegmentSubLineL.Init;
        SegmentSubLineL.Validate("Segment No.", "Segment No.");
        SegmentSubLineL.Validate("Line No.", "Line No.");
        SegmentSubLineL.Validate("SubLine No.", NextLineNo);
        SegmentSubLineL.Validate("Vehicle Serial No.", VehSerNo);
        SegmentSubLineL.Insert(true);
    end;


    procedure GetFirstVehicleNo(): Code[20]
    var
        SegmentSubLineL: Record "Segment SubLine";
    begin
        SegmentSubLineL.Reset;
        SegmentSubLineL.SetRange("Segment No.", "Segment No.");
        SegmentSubLineL.SetRange("Line No.", "Line No.");
        if SegmentSubLineL.FindFirst then
            exit(SegmentSubLineL."Vehicle Serial No.")
        else
            exit('');
    end;

    /*local procedure CreateSegInteractLanguages(InteractTemplCode: Code[10])
    var
        SegInteractLanguage: Record "Segment Interaction Language";
        InteractTemplLanguage: Record "Interaction Tmpl. Language";
        Attachment: Record Attachment;
    begin
        SegInteractLanguage.Reset;
        SegInteractLanguage.SetRange("Segment No.", "Segment No.");
        SegInteractLanguage.SetRange("Segment Line No.", "Line No.");
        SegInteractLanguage.DeleteAll(true);

        if SegHeader.Get("Segment No.") then
            if "Interaction Template Code" <> SegHeader."Interaction Template Code" then begin
                InteractTemplLanguage.Reset;
                InteractTemplLanguage.SetRange("Interaction Template Code", InteractTemplCode);
                if InteractTemplLanguage.Find('-') then
                    repeat
                        SegInteractLanguage.Init;
                        SegInteractLanguage."Segment No." := "Segment No.";
                        SegInteractLanguage."Segment Line No." := "Line No.";
                        SegInteractLanguage."Language Code" := InteractTemplLanguage."Language Code";
                        SegInteractLanguage.Description := Description;
                        if Attachment.Get(InteractTemplLanguage."Attachment No.") then
                            SegInteractLanguage."Attachment No." := AttachmentManagement.InsertAttachment(InteractTemplLanguage."Attachment No."); //FIXME
                        SegInteractLanguage.Insert(true);
                    until InteractTemplLanguage.Next = 0;
            end;
    end;*/

    var
        Campaign: Record Campaign;
        SegHeader: Record "Segment Header";
        AttachmentManagement: Codeunit AttachmentManagement;

}