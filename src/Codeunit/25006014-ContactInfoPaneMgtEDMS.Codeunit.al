Codeunit 25006014 "Contact Info-Pane Mgt. EDMS"
{

    trigger OnRun()
    begin
    end;


    procedure LookupOpportunities(Cont: Record Contact)
    var
        Opp: Record Opportunity;
    begin
        FilterOpp(Opp, Cont);
        Page.RunModal(Page::"Opportunity List", Opp)
    end;


    procedure CalcNoOfOpportunities(Cont: Record Contact): Decimal
    var
        Opp: Record Opportunity;
    begin
        FilterOpp(Opp, Cont);
        exit(Opp.Count);
    end;


    procedure FilterOpp(var Opp: Record Opportunity; Cont: Record Contact)
    begin
        Opp.Reset;
        Opp.SetCurrentkey("Contact Company No.", "Contact No.");
        Opp.SetRange("Contact Company No.", Cont."Company No.");
        if Cont."Lookup Contact No." <> '' then
            Opp.SetRange("Contact No.", Cont."Lookup Contact No.");
    end;


    procedure LookupToDos(Cont: Record Contact)
    var
        ToDo: Record "To-do";
    begin
        FilterToDo(ToDo, Cont);
        Page.RunModal(Page::"Task List", ToDo)
    end;


    procedure CalcNoOfToDos(Cont: Record Contact): Decimal
    var
        ToDo: Record "To-do";
    begin
        FilterToDo(ToDo, Cont);
        exit(ToDo.Count)
    end;


    procedure FilterToDo(var ToDo: Record "To-do"; Cont: Record Contact)
    begin
        ToDo.Reset;
        ToDo.SetCurrentkey("Contact Company No.", Date, "Contact No.", Closed);
        ToDo.SetRange("Contact Company No.", Cont."Company No.");
        if Cont."Lookup Contact No." <> '' then
            ToDo.SetRange("Contact No.", Cont."Lookup Contact No.");
        ToDo.SetRange("System To-do Type", ToDo."system to-do type"::"Contact Attendee");
        ToDo.SetRange(Closed, false)
    end;


    procedure LookupVehicles(Cont: Record Contact)
    var
        Vehicle: Record Vehicle;
        Cont2: Record Contact;
    begin
        Vehicle.Reset;
        MarkContVehicles(Vehicle, Cont."No.");
        if (Cont.Type = Cont.Type::Person) and
           (Cont."Company No." <> '') then
            if Cont2.Get(Cont."Company No.") then
                MarkContVehicles(Vehicle, Cont2."No.");

        Vehicle.MarkedOnly(true);
        Page.RunModal(Page::"Vehicle List", Vehicle);
    end;


    procedure CalcNoOfVehicles(Cont: Record Contact): Decimal
    var
        Vehicle: Record Vehicle;
        Cont2: Record Contact;
    begin
        Vehicle.Reset;
        MarkContVehicles(Vehicle, Cont."No.");
        if (Cont.Type = Cont.Type::Person) and
           (Cont."Company No." <> '') then
            if Cont2.Get(Cont."Company No.") then
                MarkContVehicles(Vehicle, Cont2."No.");

        Vehicle.MarkedOnly(true);
        exit(Vehicle.Count);
    end;


    procedure LookupSalesDocs(Cont: Record Contact; Type: Integer)
    var
        SalesHeader: Record "Sales Header";
    begin
        FilterSalesDocs(SalesHeader, Cont, Type);
        case Type of
            0:
                begin
                    SalesHeader.SetRange("Document Profile", SalesHeader."document profile"::"Vehicles Trade");
                    Page.RunModal(Page::"Sales Quote", SalesHeader);
                end;
            1:
                Page.RunModal(Page::"Sales Quote", SalesHeader);
            2:
                begin
                    SalesHeader.SetRange("Document Profile", SalesHeader."document profile"::"Vehicles Trade");
                    Page.RunModal(Page::"Sales Order", SalesHeader);
                end;
            3:
                Page.RunModal(Page::"Sales Order", SalesHeader);
        end;
    end;


    procedure CalcNoOfSalesDocs(Cont: Record Contact; Type: Integer): Decimal
    var
        SalesHeader: Record "Sales Header";
    begin
        FilterSalesDocs(SalesHeader, Cont, Type);
        case Type of
            0, 1:
                SalesHeader.SetRange("Document Type", SalesHeader."document type"::Quote);
            2, 3:
                SalesHeader.SetRange("Document Type", SalesHeader."document type"::Order);
        end;
        case Type of
            0, 2:
                SalesHeader.SetRange("Document Profile", SalesHeader."document profile"::"Vehicles Trade");
            1, 3:
                SalesHeader.SetRange("Document Profile", SalesHeader."document profile"::"Spare Parts Trade");
        end;
        exit(SalesHeader.Count)
    end;


    procedure FilterSalesDocs(var SalesHeader: Record "Sales Header"; Cont: Record Contact; Type: Integer)
    begin
        SalesHeader.Reset;
        SalesHeader.SetCurrentkey("Document Type", "Sell-to Contact No.");
        SalesHeader.SetRange("Sell-to Contact No.", Cont."No.");
    end;


    procedure LookupPostponedInt(Cont: Record Contact)
    var
        PostponedInt: Record "Interaction Log Entry";
    begin
        FilterPostponedInt(PostponedInt, Cont);
        Page.RunModal(Page::"Postponed Interactions", PostponedInt)
    end;


    procedure CalcNoOfPostponedInt(Cont: Record Contact): Decimal
    var
        PostponedInt: Record "Interaction Log Entry";
    begin
        FilterPostponedInt(PostponedInt, Cont);
        exit(PostponedInt.Count)
    end;


    procedure FilterPostponedInt(var PostponedInt: Record "Interaction Log Entry"; Cont: Record Contact)
    begin
        PostponedInt.Reset;
        PostponedInt.SetCurrentkey("Contact Company No.", Date, "Contact No.", Canceled, "Initiated By", "Attempt Failed");
        PostponedInt.SetRange("Contact Company No.", Cont."Company No.");
        PostponedInt.SetRange(Postponed, true);
        if Cont."Lookup Contact No." <> '' then
            PostponedInt.SetRange("Contact No.", Cont."Lookup Contact No.");
    end;


    procedure LookupServiceDocs(Cont: Record Contact; Type: Integer)
    var
        ServiceHeader: Record "Service Header EDMS";
    begin
        FilterServiceDocs(ServiceHeader, Cont, Type);
        case Type of
            0:
                Page.RunModal(Page::"Service Quote EDMS", ServiceHeader);
            1:
                Page.RunModal(Page::"Service Order EDMS", ServiceHeader);
        end;
    end;


    procedure CalcNoOfServiceDocs(Cont: Record Contact; Type: Integer): Decimal
    var
        ServiceHeader: Record "Service Header EDMS";
    begin
        FilterServiceDocs(ServiceHeader, Cont, Type);
        exit(ServiceHeader.Count)
    end;


    procedure FilterServiceDocs(var ServiceHeader: Record "Service Header EDMS"; Cont: Record Contact; Type: Integer)
    begin
        ServiceHeader.Reset;
        ServiceHeader.SetCurrentkey("Document Type", "Sell-to Contact No.");
        case Type of
            0:
                ServiceHeader.SetRange("Document Type", ServiceHeader."document type"::Quote);
            1:
                ServiceHeader.SetRange("Document Type", ServiceHeader."document type"::Order);
        end;
        ServiceHeader.SetRange("Sell-to Contact No.", Cont."No.");
    end;


    procedure MarkContVehicles(var Vehicle: Record Vehicle; ContNo: Code[20])
    var
        VehicleContact: Record "Vehicle Contact";
    begin
        VehicleContact.Reset;
        VehicleContact.SetCurrentkey("Contact No.");
        VehicleContact.SetRange("Contact No.", ContNo);
        if VehicleContact.FindFirst then
            repeat
                if Vehicle.Get(VehicleContact."Vehicle Serial No.") then
                    Vehicle.Mark := true;
            until VehicleContact.Next = 0;
    end;
}

