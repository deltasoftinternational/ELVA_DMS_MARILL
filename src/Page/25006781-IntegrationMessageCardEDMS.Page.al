Page 25006781 "Integration Message Card EDMS"
{
    Caption = 'Integration Message Card';
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Integration Message EDMS";

    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'General';
                field(ID; Rec.ID)
                {
                    ApplicationArea = Basic;
                }
                field(MethodCode; Rec."Method Code")
                {
                    ApplicationArea = Basic;
                }
                field(ConnectorCode; Rec."Connector Code")
                {
                    ApplicationArea = Basic;
                }
                field(ExternalID; Rec."External ID")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field(EntryCount; Rec."Entry Count")
                {
                    ApplicationArea = Basic;
                }
                field(EntryCount1stLevel; Rec."Entry Count (1st Level)")
                {
                    ApplicationArea = Basic;
                }
                field(ErrorDescription; Rec."Error Description")
                {
                    ApplicationArea = Basic;
                }
                field(StartedAt; Rec."Started At")
                {
                    ApplicationArea = Basic;
                }
                field(WaitingAt; Rec."Waiting At")
                {
                    ApplicationArea = Basic;
                }
                field(FinishedAt; Rec."Finished At")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Source)
            {
                Caption = 'Source';
                field(SourceType; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                }
                field(SourceSubtype; Rec."Source Subtype")
                {
                    ApplicationArea = Basic;
                }
                field(SourceID; Rec."Source ID")
                {
                    ApplicationArea = Basic;
                }
                field(SourceBatchName; Rec."Source Batch Name")
                {
                    ApplicationArea = Basic;
                }
                field(SourceProdOrderLine; Rec."Source Prod. Order Line")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SourceRefNo; Rec."Source Ref. No.")
                {
                    ApplicationArea = Basic;
                }
                field(ItemLedgerEntryNo; Rec."Item Ledger Entry No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
            part(Control25006010; "Integration Message Lines Sub")
            {
                ApplicationArea = All;
                Caption = 'Message Lines';
                SubPageLink = "Message ID" = field(ID);
            }
            group(MessageLineInfo)
            {
                Caption = 'Message Line Info';
                part(Control25006035; "Integration Message Info Sub")
                {
                    ApplicationArea = All;
                    Caption = 'Line Info Messages';
                    Provider = Control25006010;
                    SubPageLink = "Message ID" = field("Message ID"),
                                  "Message Line No." = field("Line No.");
                }
                part(Control25006036; "Integration Message Params Sub")
                {
                    ApplicationArea = All;
                    Caption = 'Line Params';
                    Provider = Control25006010;
                    SubPageLink = "Message ID" = field("Message ID"),
                                  "Message Line No." = field("Line No.");
                }
            }
            group(Additional)
            {
                Caption = 'Additional';
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field(InitiatorSide; Rec."Initiator Side")
                {
                    ApplicationArea = Basic;
                }
                field(SingleInstance; Rec."Single Instance")
                {
                    ApplicationArea = Basic;
                }
                field(CallNextMethodCode; Rec."Call Next Method Code")
                {
                    ApplicationArea = Basic;
                }
                field(PreviouseMessageID; Rec."Previouse Message ID")
                {
                    ApplicationArea = Basic;
                }
                field(IterationNo; Rec."Iteration No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            part(Control25006026; "Integration Message Info Sub")
            {
                ApplicationArea = All;
                Caption = 'Message Header Info Messages';
                SubPageLink = "Message ID" = field(ID);
            }
            part(Control25006012; "Integration Message Params Sub")
            {
                ApplicationArea = All;
                Caption = 'Message Header Params';
                SubPageLink = "Message ID" = field(ID),
                              "Message Line No." = const(0);
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Process)
            {
                Caption = 'Process';
                action(StartHandling)
                {
                    ApplicationArea = Basic;
                    Caption = 'Start Handling';
                    Image = Start;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Integration Message-Start", Rec);
                    end;
                }
                action(FinalizeHandling)
                {
                    ApplicationArea = Basic;
                    Caption = 'Finalize Handling';
                    Image = Stop;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Integration Message-Finalize", Rec);
                    end;
                }
            }
            group(Blobs)
            {
                Caption = 'Blobs';
                action(ImportRequestBlob)
                {
                    ApplicationArea = Basic;
                    Caption = 'Import Request Blob';
                    Image = Import;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;

                    trigger OnAction()
                    var
                        FileMgt: Codeunit "File Management";
                        ServerFileName: Text;
                        FileName: Text;
                    begin
                        Rec.ImportFile(0);
                    end;
                }
                action(ImportResponseBlob)
                {
                    ApplicationArea = Basic;
                    Caption = 'Import Response Blob';
                    Image = Import;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;

                    trigger OnAction()
                    var
                        FileMgt: Codeunit "File Management";
                        ServerFileName: Text;
                        FileName: Text;
                    begin
                        Rec.ImportFile(1);
                    end;
                }
                action(ExportRequestBlob)
                {
                    ApplicationArea = Basic;
                    Caption = 'Export Request Blob';
                    Image = Export;

                    trigger OnAction()
                    var
                        FileMgt: Codeunit "File Management";
                        ServerFileName: Text;
                        ExportToFile: Text;
                        Path: Text;
                    begin
                        Rec.ExportFile(0);
                    end;
                }
                action(ExportResponseBlob)
                {
                    ApplicationArea = Basic;
                    Caption = 'Export Response Blob';
                    Image = Export;

                    trigger OnAction()
                    var
                        FileMgt: Codeunit "File Management";
                        ServerFileName: Text;
                        ExportToFile: Text;
                        Path: Text;
                    begin
                        Rec.ExportFile(1);
                    end;
                }
            }
        }
    }
}

