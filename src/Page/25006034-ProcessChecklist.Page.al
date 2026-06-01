Page 25006034 "Process Checklist"
{
    Caption = 'Process Checklist';
    DataCaptionFields = "No.", "Template Code";
    PageType = Card;
    PopulateAllFields = true;
    SourceTable = "Process Checklist Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(TemplateCode; Rec."Template Code")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        TemplateCodeOnAfterValidate;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(ProcessDate; Rec."Process Date")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;
                }
            }
            part(Lines; "Process Checklist Subform")
            {
                SubPageLink = "Process Checklist No." = field("No.");
            }
            group(Details)
            {
                Caption = 'Details';
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
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Print)
            {
                ApplicationArea = Basic;
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    DocMgt: Codeunit DocumentManagementDMS;
                    RepSelect: Record "Document Report";
                begin
                    DocMgt.PrintCurrentDoc(0, 0, 14, RepSelect);
                    DocMgt.SelectProcessChklistDocReport(RepSelect, Rec);
                end;
            }
        }
    }

    local procedure TemplateCodeOnAfterValidate()
    begin
        CurrPage.Update;
    end;
}

