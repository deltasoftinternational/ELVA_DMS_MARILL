Codeunit 25006782 "Inventory Mgt. EDMS"
{
    // #Owner EDMS.Integration


    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Nonstock Item", 'OnModifyOnBeforeError', '', false, false)]
    local procedure OnModifyOnBeforeError(var NonstockItem: Record "Nonstock Item"; var IsHandled: Boolean);
    var
        NonstockItemSetup: Record "Nonstock Item Setup";
    begin
        NonstockItemSetup.get();
        If NonstockItemSetup."Updt. Nonstock with Item rel." then
            IsHandled := true;
    end;

    local procedure CalledByFieldNoChangedEDMS(NonstockItem: Record "Nonstock Item"; xNonstockItem: Record "Nonstock Item"; CalledByFieldNo: Integer): Boolean
    begin
        case CalledByFieldNo of
            NonstockItem.FieldNo("Manufacturer Code"):
                exit(NonstockItem."Manufacturer Code" <> NonstockItem."Manufacturer Code");
            NonstockItem.FieldNo("Vendor No."):
                exit(NonstockItem."Vendor No." <> xNonstockItem."Vendor No.");
            NonstockItem.FieldNo("Vendor Item No."):
                exit(NonstockItem."Vendor Item No." <> xNonstockItem."Vendor Item No.");
            NonstockItem.FieldNo(Description):
                exit(NonstockItem.Description <> xNonstockItem.Description);
            NonstockItem.FieldNo("Unit of Measure"):
                exit(NonstockItem."Unit of Measure" <> xNonstockItem."Unit of Measure");
            NonstockItem.FieldNo("Published Cost"):
                exit(NonstockItem."Published Cost" <> xNonstockItem."Published Cost");
            NonstockItem.FieldNo("Negotiated Cost"):
                exit(NonstockItem."Negotiated Cost" <> xNonstockItem."Negotiated Cost");
            NonstockItem.FieldNo("Unit Price"):
                exit(NonstockItem."Unit Price" <> xNonstockItem."Unit Price");
            NonstockItem.FieldNo("Gross Weight"):
                exit(NonstockItem."Gross Weight" <> xNonstockItem."Gross Weight");
            NonstockItem.FieldNo("Net Weight"):
                exit(NonstockItem."Net Weight" <> xNonstockItem."Net Weight");
            NonstockItem.FieldNo("Bar Code"):
                exit(NonstockItem."Bar Code" <> xNonstockItem."Bar Code");
            NonstockItem.FieldNo("Item No."):
                exit(NonstockItem."Item No." <> xNonstockItem."Item No.");
            NonstockItem.FieldNo("Item Templ. Code"):
                exit(NonstockItem."Item Templ. Code" <> xNonstockItem."Item Templ. Code");
        end;

        exit(false);
    end;


    [EventSubscriber(ObjectType::Table, Database::"Nonstock Item", 'OnBeforeValidateField', '', false, false)]
    local procedure OnBeforeValidateField(var NonstockItem: Record "Nonstock Item"; xNonstockItem: Record "Nonstock Item"; CalledByFieldNo: Integer; var IsHandled: Boolean);
    VAR
        NonstockItemSetup: Record "Nonstock Item Setup";
    begin
        NonstockItemSetup.get();
        IF CalledByFieldNoChangedEDMS(NonstockItem, xNonstockItem, CalledByFieldNo) then
            If NonstockItemSetup."Updt. Nonstock with Item rel." then
                IsHandled := true;
    end;



}

