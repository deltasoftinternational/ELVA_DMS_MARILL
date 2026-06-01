pageextension 25006151 "Item Lookup" extends "Item Lookup"//32
{
    trigger OnOpenPage()
    var
        TXTFILTER: Text;
        IsHandled: Boolean;
    begin
        OnBeforeFilterItemType(Rec, IsHandled);
        If IsHandled then
            exit;
        TXTFILTER := REC.GetFilter("Item Type");
        if (TXTFILTER <> 'Model Version') then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Item Type", Rec."Item Type"::Item);
            Rec.FilterGroup(0);
        end;

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFilterItemType(Rec: Record Item; var IsHandled: Boolean)
    begin
    end;
}