Table 25006228 "BLS Leasing Sched. Serv. Line"
{
    Caption = 'Leasing Schedule Additional Service Line';

    fields
    {
        /*
        field(10; "DMS Contract No."; Code[20])
        {
            Caption = 'DMS Contract No.';
            NotBlank = true;
            TableRelation = Contract."Contract No.";
        }
        */
        field(20; "Service Code"; Code[20])
        {
            Caption = 'Service Code';
            NotBlank = true;
            TableRelation = "BLS Service".Code;

            trigger OnValidate()
            begin
                if xRec."Service Code" <> "Service Code" then begin
                    "Service Description" := '';
                end;

                if "Service Code" <> '' then begin
                    Service.Get("Service Code");
                    "Service Description" := Service.Description;
                end;
            end;
        }

        field(40; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                TestField("Starting Date");

                if not DateRangeIsCorrect("Starting Date", "Ending Date") then
                    Error(IncorrectDateRangeErr, "Starting Date", "Ending Date");

                if not DateInContractPeriod("Starting Date") then
                    Error(DateOutOfContractErr, "Starting Date");
            end;
        }
        field(100; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                if not DateRangeIsCorrect("Starting Date", "Ending Date") then
                    Error(IncorrectDateRangeErr, "Starting Date", "Ending Date");


                if not DateInContractPeriod("Ending Date") then
                    Error(DateOutOfContractErr, "Ending Date");
            end;
        }
        field(200; "Service Description"; Text[50])
        {
            Caption = 'Service Description';
        }
        field(2010; Price; Decimal)
        {
            Caption = 'Price';
            DecimalPlaces = 2 : 5;


        }
        field(2020; "Price Including VAT"; Boolean)
        {
            Caption = 'Price Including VAT';
        }

        field(7000; "Leasing Schedule No."; Code[20])
        {
            Caption = 'Leasing Schedule No.';
            TableRelation = "BLS Leasing Schedule Header"."No.";
        }
    }

    keys
    {
        //key(Key1; "DMS Contract No.", "Service Code", "Leasing Schedule No.")
        key(Key1; "Service Code", "Leasing Schedule No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin

    end;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnRename()
    begin

    end;

    var
        ApplicationManagement: Codeunit DocumentManagementDMS;
        BLSObject: Record "BLS Object";
        Contract: Record Contract;
        Service: Record "BLS Service";
        ContractVehicle: Record "Contract Vehicle";
        BLSMgt: Codeunit "BLS Management";
        DateOutOfContractErr: label 'Date %1 is out of contract active period.';
        IncorrectDateRangeErr: label 'Starting date (%1) must be before Ending Date (%2).';
        NotModifyErr: label 'Contract No. %1 modification or deleting is not allowed.';
        ObjCodeMustBeEmptyErr: label 'Object must be empty for object type %1.';
        ServiceLineExistErr: label 'Contract line has special conditions. Contract No. %1, Service Code %2,  %3 %4, From Date %5';
        Text001: label 'Would you like to change %1 as well?';
        Text002: label 'Would you like to recalculate %1 in other stages?';

    local procedure DateRangeIsCorrect(FromDate: Date; ToDate: Date): Boolean
    begin
        if (FromDate = 0D) or (ToDate = 0D) then
            exit(true);

        exit(FromDate <= ToDate);
    end;

    local procedure IsAllowedModification(): Boolean
    begin
        //if not GetContract then
        //    exit(false);

        // EXIT(Contract.IsAllowedModification);
        exit(true);
    end;

    /*
        local procedure GetContract(): Boolean
        begin
            if "DMS Contract No." = '' then
                exit(false);

            exit(Contract.Get("DMS Contract No."));
        end;
    */
    local procedure DateInContractPeriod(Date: Date): Boolean
    begin
        if Date = 0D then
            exit(true);

        //if not GetContract then
        //    exit(false);

        exit(true);
        Contract.TestField("Starting Date");
        exit(
             (Date >= Contract."Starting Date") and
             ((Date <= Contract."Expiration Date") or (Contract."Expiration Date" = 0D))
            );
    end;
}

