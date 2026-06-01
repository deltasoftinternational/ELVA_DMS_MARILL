Page 25006010 "Process Checklist List"
{
    // 13/02/2018 GH P1
    //   *Changed Card Page ID to open GH page

    ApplicationArea = Basic;
    Caption = 'Process Checklist List';
    CardPageID = "Checklist Card";
    PageType = List;
    SourceTable = "Process Checklist Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1101908000)
            {
                Editable = false;
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(TemplateCode; Rec."Template Code")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleRegistrationNo; Rec."Vehicle Registration No.")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Visible = VehicleSerialNoVisible;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;
                }
                field(ProcessStatus; Rec."Process Status")
                {
                    ApplicationArea = Basic;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field(ConfirmedbyAdvisor; Rec."Confirmed by Advisor")
                {
                    ApplicationArea = Basic;
                }
                field(Make; Rec.Make)
                {
                    ApplicationArea = Basic;
                }
                field(Model; Rec.Model)
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field("Checklist Category"; Rec."Checklist Category")
                {
                    ToolTip = 'Specifies the Category of this checklist. It comes from Template.';
                    ApplicationArea = All;
                }
                field(CreationDate; Rec."Creation Date")
                {
                    ApplicationArea = All;
                }
                field(CompletionDate; Rec."Completion Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Checklist)
            {
                Caption = 'Checklist';
                action("Show Lines")
                {
                    ApplicationArea = Basic;
                    Image = CheckList;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //TESTFIELD("Template Code");
                        //PAGE.RUN(PAGE::"GH Checklist Lines",Rec);
                        Rec.ShowLines;
                    end;
                }
                action(Confirm)
                {
                    ApplicationArea = Basic;
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        GHFeatureMgt: Codeunit "Checklist Features Mgt.";
                    begin
                        //GHFeatureMgt.ConfirmChecklist(Rec);
                        Rec.Validate("Confirmed by Advisor", true);
                        Rec.Modify(true);
                    end;
                }
                action(DocPictureList)
                {
                    ApplicationArea = Basic;
                    Caption = 'Document Pictures';
                    Image = Picture;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page Pictures;
                    RunPageLink = "Source Type" = const(25006025),
                                  "Source ID" = field("No.");
                }
                action(VehPictureList)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle Pictures';
                    Image = Picture;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page Pictures;
                    RunPageLink = "Vehicle Serial No." = field("Vehicle Serial No.");
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        ServiceMgtSetup: Record "Service Mgt. Setup EDMS";
        UserProfileMgt: Codeunit UserProfileManagement;
        BranchProfileSetup: Record "Branch Profile Setup";
    begin
        ServiceMgtSetup.Get;
        VehicleSerialNoVisible := ServiceMgtSetup."Vehicle No. Promoted";

        if UserProfileMgt.CurrProfileID <> '' then
            if BranchProfileSetup.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) then
                if BranchProfileSetup."Service Location Filter" <> '' then
                    Rec.SetFilter("Location Code", BranchProfileSetup."Service Location Filter");

        Rec.SetRange(Type, Rec.Type::"Vehicle Inspection");
    end;

    var
        VehicleSerialNoVisible: Boolean;
}

