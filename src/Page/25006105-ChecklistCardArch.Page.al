Page 25006105 "Checklist Card Arch."
{
    // 17/08/2018 EB.P30 GH
    //   Modified trigger:
    //     OnAfterGetCurrRecord
    // 
    // 09/08/2018 EB.P30 GH
    //   Created

    Caption = 'Checklist Card Archive';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Process Checklist Header Arch.";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(No; rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(TemplateCode; rec."Template Code")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;

                    trigger OnValidate()
                    var
                        AddInData: Text;
                        Buffer: Record "Checklist Buffer" temporary;
                    begin
                    end;
                }
                field("Checklist Category"; Rec."Checklist Category")
                {
                    ToolTip = 'Specifies the Checklist Category.';
                    ApplicationArea = All;
                }
                field(VehicleRegistrationNo; rec."Vehicle Registration No.")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleSerialNo; rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Visible = VehicleSerialNoVisible;
                }
                field(VehicleDescription; rec.VehicleDescription)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle Description';
                }
                field(LocationCode; rec."Location Code")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(ProcessStatus; rec."Process Status")
                {
                    ApplicationArea = Basic;
                }
                field(ConfirmedbyAdvisor; rec."Confirmed by Advisor")
                {
                    ApplicationArea = Basic;
                }
            }
            usercontrol(CheckList; CheckListAddIn)
            {
                ApplicationArea = Basic;

                trigger ControlAddInReady()
                begin
                    UpdateLines
                end;

                trigger RequestRefreshPage(ActLineNo: Integer)
                var
                    AddInData: Text;
                    Buffer: Record "Checklist Buffer" temporary;
                begin
                    GHCheckListAddInManagement.FillCheckListArch(Rec, Buffer);
                    GHCheckListAddInManagement.CheckListRequestRefreshPage(AddInData, ActLineNo);
                    CurrPage.CheckList.RecieveRefreshCheckListData(AddInData);
                end;

                trigger RequestTextChange(LineNo: Integer; CommentText: Text)
                var
                    ChecklistLine: Record "Process Checklist Line";
                    Buffer: Record "Checklist Buffer" temporary;
                    AddInData: Text;
                begin
                    GHCheckListAddInManagement.FillCheckListArch(Rec, Buffer);
                    GHCheckListAddInManagement.CheckListRequestRefreshPage(AddInData, 0);
                    CurrPage.CheckList.RecieveRefreshCheckListData(AddInData);
                end;

                trigger RequestRadioChange(LineNo: Integer; RadioValue: Text)
                var
                    ChecklistLine: Record "Process Checklist Line";
                    Buffer: Record "Checklist Buffer" temporary;
                    AddInData: Text;
                begin
                    GHCheckListAddInManagement.FillCheckListArch(Rec, Buffer);
                    GHCheckListAddInManagement.CheckListRequestRefreshPage(AddInData, 0);
                    CurrPage.CheckList.RecieveRefreshCheckListData(AddInData);
                end;

                trigger RequestCheckChange(LineNo: Integer; CheckValue: Text)
                var
                    ChecklistLine: Record "Process Checklist Line";
                    Buffer: Record "Checklist Buffer" temporary;
                    AddInData: Text;
                begin
                    GHCheckListAddInManagement.FillCheckListArch(Rec, Buffer);
                    GHCheckListAddInManagement.CheckListRequestRefreshPage(AddInData, 0);
                    CurrPage.CheckList.RecieveRefreshCheckListData(AddInData);
                end;

                trigger RequestAssistEditButton(LineNo: Integer)
                begin
                end;

                trigger RequestButton(LineNo: Integer)
                begin
                end;
            }
            group(Details)
            {
                Caption = 'Details';
                field(CreationDate; rec."Creation Date")
                {
                    ApplicationArea = Basic;
                }
                field(CreationTime; rec."Creation Time")
                {
                    ApplicationArea = Basic;
                }
                field(CompletionDate; rec."Completion Date")
                {
                    ApplicationArea = Basic;
                }
                field(CompletionTime; rec."Completion Time")
                {
                    ApplicationArea = Basic;
                }
                field(CompletedbyUserID; rec."Completed by User ID")
                {
                    ApplicationArea = Basic;
                }
                field(Type; rec.Type)
                {
                    ApplicationArea = Basic;
                }
            }
            group(SourceReference)
            {
                Caption = 'Source Reference';
                field(SourceType; rec."Source Type")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(SourceSubtype; rec."Source Subtype")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(SourceID; rec."Source ID")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(ReferenceDescription; ReferenceDescription)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reference Description';
                }
                field(VHCNo; rec."VHC No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        ReferenceDescription := GHFeaturesMgt.ChecklistReferenceDescription(rec."Source Type", rec."Source Subtype", rec."Source ID");  // 17/08/2018 EB.P30 GH
    end;

    trigger OnAfterGetRecord()
    var
        AddInData: Text;
    begin
    end;

    var
        GHCheckListAddInManagement: Codeunit "Checklist AddIn Management";
        VehicleSerialNoVisible: Boolean;
        GHFeaturesMgt: Codeunit "Checklist Features Mgt.";
        ReferenceDescription: Text;

    local procedure UpdateLines()
    var
        AddInData: Text;
        Buffer: Record "Checklist Buffer" temporary;
    begin
        GHCheckListAddInManagement.FillCheckListArch(Rec, Buffer);
        GHCheckListAddInManagement.CheckListControlAddInReady(AddInData);
        CurrPage.CheckList.RecieveInitCheckListData(AddInData);
    end;
}

