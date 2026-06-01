pageextension 25006473 "Posted Approval Entries" extends "Posted Approval Entries"//659
{

    procedure Setfilters(TableId: Integer; DocumentNo: Code[20])
    begin
        if TableId <> 0 then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Table ID", TableId);
            if DocumentNo <> '' then
                Rec.SetRange("Document No.", DocumentNo);
            Rec.FilterGroup(0);
        end;
    end;
}