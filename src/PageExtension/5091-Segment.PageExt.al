pageextension 25006476 "Segment" extends Segment//5091
{

    actions
    {
        modify(AddContacts)
        {
            Visible = false;
        }
        addafter(AddContacts)
        {
            action(DMSAddContacts)
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Add Contacts';
                Ellipsis = true;
                Image = AddContacts;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Select which contacts to add to the segment.';

                trigger OnAction()
                var
                    SegHeader: Record "Segment Header";
                begin
                    SegHeader := Rec;
                    SegHeader.SetRecFilter;
                    REPORT.RunModal(REPORT::"EDMS Add Contacts", true, false, SegHeader);
                end;
            }
        }
        modify(ReduceContacts)
        {
            visible = false;
        }
        addafter(ReduceContacts)
        {
            action(DMSReduceContacts)
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Reduce Contacts';
                Ellipsis = true;
                Image = RemoveContacts;
                ToolTip = 'Select which contacts to remove from your segment.';

                trigger OnAction()
                var
                    SegHeader: Record "Segment Header";
                begin
                    SegHeader := Rec;
                    SegHeader.SetRecFilter;
                    REPORT.RunModal(REPORT::"EDMS Remove Contacts - Reduce", true, false, SegHeader);
                end;
            }
        }
        modify(RefineContacts)
        {
            Visible = false;
        }
        addafter(RefineContacts)
        {
            action(DMSRefineContacts)
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Re&fine Contacts';
                Ellipsis = true;
                Image = ContactFilter;
                ToolTip = 'Select which contacts to keep in your segment.';

                trigger OnAction()
                var
                    SegHeader: Record "Segment Header";
                begin
                    SegHeader := Rec;
                    SegHeader.SetRecFilter;
                    REPORT.RunModal(REPORT::"EDMS Remove Contacts - Refine", true, false, SegHeader);
                end;
            }
        }
        modify(ReuseCriteria)
        {
            Visible = false;
        }
        addafter(ReuseCriteria)
        {
            action(DMSReuseCriteria)
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Reuse Criteria';
                Ellipsis = true;
                Image = Reuse;
                ToolTip = 'Reuse a saved segment criteria.';

                trigger OnAction()
                begin
                    DMSReuseCriteria;
                end;
            }

        }
    }
    var
        SegHeader: Record "Segment Header";
        Text006: Label 'Segment %1 already contains %2 %3.\Are you sure you want to reuse a %4?';


    procedure DMSReuseCriteria()
    var
        SavedSegCriteria: Record "Saved Segment Criteria";
        SavedSegCriteriaLineAction: Record "Saved Segment Criteria Line";
        SavedSegCriteriaLineFilter: Record "Saved Segment Criteria Line";
        Cont: Record Contact;
        ContProfileAnswer: Record "Contact Profile Answer";
        ContMailingGrp: Record "Contact Mailing Group";
        InteractLogEntry: Record "Interaction Log Entry";
        ContJobResp: Record "Contact Job Responsibility";
        ContIndustGrp: Record "Contact Industry Group";
        ContBusRel: Record "Contact Business Relation";
        ValueEntry: Record "Value Entry";
        AddContacts: Report "EDMS Add Contacts";
        ReduceContacts: Report "EDMS Remove Contacts - Reduce";
        RefineContacts: Report "EDMS Remove Contacts - Refine";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeReuseCriteria(Rec, IsHandled);
        if IsHandled then
            exit;

        Rec.CalcFields(Rec."No. of Criteria Actions");
        if Rec."No. of Criteria Actions" <> 0 then
            if not Confirm(
                 Text006, false,
                 Rec."No.", Rec."No. of Criteria Actions", Rec.FieldCaption(Rec."No. of Criteria Actions"), SavedSegCriteria.TableCaption)
            then
                exit;

        if PAGE.RunModal(PAGE::"Saved Segment Criteria List", SavedSegCriteria) <> ACTION::LookupOK then
            exit;

        SavedSegCriteriaLineAction.SetRange("Segment Criteria Code", SavedSegCriteria.Code);
        SavedSegCriteriaLineAction.SetRange(Type, SavedSegCriteriaLineAction.Type::Action);
        if SavedSegCriteriaLineAction.Find('-') then
            repeat
                SegHeader.SetRange("No.", Rec."No.");
                Cont.Reset();
                ContProfileAnswer.Reset();
                ContMailingGrp.Reset();
                InteractLogEntry.Reset();
                ContJobResp.Reset();
                ContIndustGrp.Reset();
                ContBusRel.Reset();
                ValueEntry.Reset();
                SavedSegCriteriaLineFilter.SetRange("Segment Criteria Code", SavedSegCriteria.Code);
                SavedSegCriteriaLineFilter.SetRange(
                  "Line No.", SavedSegCriteriaLineAction."Line No." + 1,
                  SavedSegCriteriaLineAction."Line No." + SavedSegCriteriaLineAction."No. of Filters");
                if SavedSegCriteriaLineFilter.Find('-') then
                    repeat
                        case SavedSegCriteriaLineFilter."Table No." of
                            DATABASE::Contact:
                                Cont.SetView(SavedSegCriteriaLineFilter."Table View");
                            DATABASE::"Contact Profile Answer":
                                ContProfileAnswer.SetView(SavedSegCriteriaLineFilter."Table View");
                            DATABASE::"Contact Mailing Group":
                                ContMailingGrp.SetView(SavedSegCriteriaLineFilter."Table View");
                            DATABASE::"Interaction Log Entry":
                                InteractLogEntry.SetView(SavedSegCriteriaLineFilter."Table View");
                            DATABASE::"Contact Job Responsibility":
                                ContJobResp.SetView(SavedSegCriteriaLineFilter."Table View");
                            DATABASE::"Contact Industry Group":
                                ContIndustGrp.SetView(SavedSegCriteriaLineFilter."Table View");
                            DATABASE::"Contact Business Relation":
                                ContBusRel.SetView(SavedSegCriteriaLineFilter."Table View");
                            DATABASE::"Value Entry":
                                ValueEntry.SetView(SavedSegCriteriaLineFilter."Table View");
                        end;
                    until SavedSegCriteriaLineFilter.Next() = 0;
                case SavedSegCriteriaLineAction.Action of
                    SavedSegCriteriaLineAction.Action::"Add Contacts":
                        begin
                            Clear(AddContacts);
                            AddContacts.SetTableView(SegHeader);
                            AddContacts.SetTableView(Cont);
                            AddContacts.SetTableView(ContProfileAnswer);
                            AddContacts.SetTableView(ContMailingGrp);
                            AddContacts.SetTableView(InteractLogEntry);
                            AddContacts.SetTableView(ContJobResp);
                            AddContacts.SetTableView(ContIndustGrp);
                            AddContacts.SetTableView(ContBusRel);
                            AddContacts.SetTableView(ValueEntry);
                            AddContacts.SetOptions(
                              SavedSegCriteriaLineAction."Allow Existing Contacts",
                              SavedSegCriteriaLineAction."Expand Contact",
                              SavedSegCriteriaLineAction."Allow Company with Persons",
                              SavedSegCriteriaLineAction."Ignore Exclusion");
                            AddContacts.UseRequestPage(false);
                            AddContacts.RunModal;
                        end;
                    SavedSegCriteriaLineAction.Action::"Remove Contacts (Reduce)":
                        begin
                            Clear(ReduceContacts);
                            ReduceContacts.SetTableView(SegHeader);
                            ReduceContacts.SetTableView(Cont);
                            ReduceContacts.SetTableView(ContProfileAnswer);
                            ReduceContacts.SetTableView(ContMailingGrp);
                            ReduceContacts.SetTableView(InteractLogEntry);
                            ReduceContacts.SetTableView(ContJobResp);
                            ReduceContacts.SetTableView(ContIndustGrp);
                            ReduceContacts.SetTableView(ContBusRel);
                            ReduceContacts.SetTableView(ValueEntry);
                            ReduceContacts.SetOptions(SavedSegCriteriaLineAction."Entire Companies");
                            ReduceContacts.UseRequestPage(false);
                            ReduceContacts.RunModal;
                        end;
                    SavedSegCriteriaLineAction.Action::"Remove Contacts (Refine)":
                        begin
                            Clear(RefineContacts);
                            RefineContacts.SetTableView(SegHeader);
                            RefineContacts.SetTableView(Cont);
                            RefineContacts.SetTableView(ContProfileAnswer);
                            RefineContacts.SetTableView(ContMailingGrp);
                            RefineContacts.SetTableView(InteractLogEntry);
                            RefineContacts.SetTableView(ContJobResp);
                            RefineContacts.SetTableView(ContIndustGrp);
                            RefineContacts.SetTableView(ContBusRel);
                            RefineContacts.SetTableView(ValueEntry);
                            ReduceContacts.SetOptions(SavedSegCriteriaLineAction."Entire Companies");
                            RefineContacts.UseRequestPage(false);
                            RefineContacts.RunModal;
                        end;
                    else
                        OnReuseCriteriaSavedSegmentCriteriaLineCaseElse(SegHeader, SavedSegCriteriaLineAction);
                end;
            until SavedSegCriteriaLineAction.Next() = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeReuseCriteria(var SegmentHeader: Record "Segment Header"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnReuseCriteriaSavedSegmentCriteriaLineCaseElse(var SegmentHeader: Record "Segment Header"; var SavedSegmentCriteriaLine: Record "Saved Segment Criteria Line")
    begin
    end;
}