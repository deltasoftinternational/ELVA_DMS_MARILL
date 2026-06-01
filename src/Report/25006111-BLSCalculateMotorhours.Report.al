Report 25006111 "BLS Calculate Motorhours"
{
    // 07.11.2017 EB.AKR Suggest Lines From EDMS
    //   Modified function:
    //     "DMS Contract Line - OnAfterGetRecord"

    Caption = 'Calculate Motorhours';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.";
            column(ReportForNavId_50000; 50000)
            {
            }
            dataitem(Contract; Contract)
            {
                DataItemLink = "Bill-to Customer No." = field("No.");
                DataItemTableView = where("Use For Billing" = const(true));
                RequestFilterFields = "Contract No.";
                column(ReportForNavId_50002; 50002)
                {
                }
                dataitem("DMS Contract Line"; "DMS Contract Line")
                {
                    DataItemLink = "DMS Contract No." = field("Contract No.");
                    DataItemTableView = where("Quantity Source" = const("Service Ledger"));
                    RequestFilterFields = "Vehicle Serial No.";
                    column(ReportForNavId_50001; 50001)
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        Contract: Record Contract;
                        Vehicle: Record Vehicle;
                    begin
                        if "DMS Contract Line"."Last Calculation Date" >= "DMS Contract Line"."Ending Date" then
                            exit;
                        StartMotorHours := "Variable Field Run Start 1";
                        EndMotorHours := 0;
                        BLSLedgerEntry.Reset;
                        BLSLedgerEntry.SetCurrentkey("Posting Date");
                        BLSLedgerEntry.SetRange("Contract No.", "DMS Contract No.");
                        BLSLedgerEntry.SetRange("Vehicle Serial No.", "Vehicle Serial No.");
                        BLSLedgerEntry.SetFilter("Posting Date", '..%1', PeriodEndingDate);
                        BLSLedgerEntry.SetRange(Correction, false);
                        if BLSLedgerEntry.FindLast then
                            StartMotorHours := BLSLedgerEntry."Variable Field Run End 1";

                        ServiceLedgerEDMS.Reset;
                        ServiceLedgerEDMS.SetCurrentkey("Posting Date");
                        ServiceLedgerEDMS.SetRange("Vehicle Serial No.", "Vehicle Serial No.");
                        ServiceLedgerEDMS.SetRange("Entry Type", ServiceLedgerEDMS."entry type"::Usage);
                        ServiceLedgerEDMS.SetFilter("Variable Field Run 1", '<>0');    //07.11.2017 EB.AKR Suggest Lines From EDMS
                        ServiceLedgerEDMS.SetFilter("Posting Date", '..%1', PeriodEndingDate);

                        ////07.11.2017 EB.AKR Suggest Lines From EDMS >>
                        if ServiceLedgerEDMS.FindLast then begin
                            ServiceLedgerEDMS.SetRange("Posting Date", ServiceLedgerEDMS."Posting Date");
                            if ServiceLedgerEDMS.Count > 1 then begin
                                ServiceLedgerEDMS.SetCurrentkey("Variable Field Run 1");
                                if ServiceLedgerEDMS.FindLast then
                                    EndMotorHours := ServiceLedgerEDMS."Variable Field Run 1";
                                ServiceLedgerEDMS.SetCurrentkey("Posting Date");
                            end else
                                EndMotorHours := ServiceLedgerEDMS."Variable Field Run 1";
                        end;
                        //07.11.2017 EB.AKR Suggest Lines From EDMS <<

                        //02.03.2018 EB.AMU POD.DMS.Service P439 >>
                        VehicleTelematics.RESET;
                        VehicleTelematics.SETCURRENTKEY("Date Stamp");
                        VehicleTelematics.SETRANGE("Vehicle Serial No.", "Vehicle Serial No.");
                        VehicleTelematics.SETFILTER("Date Stamp", '..%1', PeriodEndingDate);
                        VehicleTelematics.SETFILTER("Variable Field Run 1", '<>0');
                        IF VehicleTelematics.FINDLAST THEN BEGIN
                            IF VehicleTelematics."Date Stamp" > ServiceLedgerEDMS."Posting Date" THEN BEGIN
                                VehicleTelematics.SETRANGE("Date Stamp", VehicleTelematics."Date Stamp");
                                VehicleTelematics.SETCURRENTKEY("Variable Field Run 1");
                                IF VehicleTelematics.FINDLAST THEN
                                    EndMotorHours := ROUND(VehicleTelematics."Variable Field Run 1", 1, '<');      // 14.03.2018 EB.AMU POD.DMS.Service P439
                            END ELSE
                                IF VehicleTelematics."Date Stamp" = ServiceLedgerEDMS."Posting Date" THEN BEGIN
                                    VehicleTelematics.SETRANGE("Date Stamp", VehicleTelematics."Date Stamp");
                                    VehicleTelematics.SETCURRENTKEY("Variable Field Run 1");
                                    IF VehicleTelematics.FINDLAST THEN BEGIN
                                        IF EndMotorHours < VehicleTelematics."Variable Field Run 1" THEN
                                            EndMotorHours := ROUND(VehicleTelematics."Variable Field Run 1", 1, '<');      // 14.03.2018 EB.AMU POD.DMS.Service P439
                                    END;
                                END;
                        END;
                        //02.03.2018 EB.AMU POD.DMS.Service P439 <<

                        if EndMotorHours <> StartMotorHours then begin
                            LineNo += 10000;
                            BLSJournalLine.Init;
                            if FirstLine then begin
                                Clear(NoSeriesMgt);
                                DocumentNo := NoSeriesMgt.PeekNextNo(BLSJnlBatch."No. Series", PeriodEndingDate);
                            end;

                            BLSJournalLine."Journal Template Name" := BLSJnlTemplate.Name;
                            BLSJournalLine."Journal Batch Name" := BLSJnlBatch.Name;
                            BLSJournalLine."Document No." := DocumentNo;
                            BLSJournalLine."Line No." := LineNo;
                            BLSJournalLine."Source Code" := BLSJnlTemplate."Source Code";
                            BLSJournalLine."Reason Code" := BLSJnlBatch."Reason Code";
                            BLSJournalLine."Posting No. Series" := BLSJnlBatch."Posting No. Series";
                            BLSJournalLine.Validate("Contract No.", "DMS Contract No.");
                            BLSJournalLine.Validate("Posting Date", PeriodEndingDate);
                            BLSJournalLine.Validate("Document Date", PeriodEndingDate);
                            BLSJournalLine.Validate(BLSJournalLine."Entry Type", BLSJournalLine."entry type"::Sale);
                            BLSJournalLine.Validate("Object Code", "Object Code");
                            BLSJournalLine.Validate("Variable Field Run Start 1", StartMotorHours);
                            BLSJournalLine.Validate("Variable Field Run End 1", EndMotorHours);
                            BLSJournalLine.Validate("Service Code", "Service Code");
                            BLSJournalLine.Validate(Quantity, EndMotorHours - StartMotorHours);
                            BLSJournalLine.Validate("Unit Price", Price);
                            BLSJournalLine.Validate("Vehicle Serial No.", "Vehicle Serial No.");
                            if Contract.Get("DMS Contract No.") then
                                BLSJournalLine."External Contract No." := Contract."External Contract No.";
                            BLSJournalLine.Insert(true);
                            FirstLine := false;
                        end;
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                CP += 1;
                Window.Update(2, ROUND(CP / RC * 10000, 1, '<'));
            end;

            trigger OnPreDataItem()
            begin
                Window.Open(StrSubstNo('%1',
                                       WindowContractTxt));
                RC := Count;
                CP := 0;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Parameters)
                {
                    Caption = 'Parameters';
                    field(PeriodStartingDate; PeriodStartingDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Starting Date';
                    }
                    field(PeriodEndingDate; PeriodEndingDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Ending Date';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        Window.Close;
        Message(CalcCompletedTxt);
    end;

    trigger OnPreReport()
    begin
        DocumentNo := '';

        if BLSJournalLine.FindLast then
            LineNo := BLSJournalLine."Line No."
        else
            LineNo := 0;
        FirstLine := true;
    end;

    var
        ServiceLedgerEDMS: Record "Service Ledger Entry EDMS";
        BLSJournalLine: Record "BLS Journal Line";
        PeriodStartingDate: Date;
        PeriodEndingDate: Date;
        BLSLedgerEntry: Record "BLS Ledger Entry";
        StartMotorHours: Integer;
        EndMotorHours: Integer;
        LineNo: Integer;
        FirstLine: Boolean;
        NoSeriesMgt: Codeunit "No. Series";
        BLSJnlTemplate: Record "BLS Journal Template";
        BLSJnlBatch: Record "BLS Journal Batch";
        Window: Dialog;
        WindowContractTxt: label 'Contracts                 @2@@@@@@@@@@@@@@@@@@@';
        RC: Integer;
        CP: Integer;
        CalcCompletedTxt: label 'Calculation completed.';
        DocumentNo: Code[20];
        VehicleTelematics: Record "Vehicle Telematics";


    procedure SetParam(BLSJournalLinePar: Record "BLS Journal Line")
    begin
        BLSJnlTemplate.Get(BLSJournalLinePar."Journal Template Name");
        BLSJnlBatch.Get(BLSJournalLinePar."Journal Template Name", BLSJournalLinePar."Journal Batch Name");
        BLSJournalLine.SetRange("Journal Template Name", BLSJournalLinePar."Journal Template Name");
        BLSJournalLine.SetRange("Journal Batch Name", BLSJournalLinePar."Journal Batch Name");
    end;
}

