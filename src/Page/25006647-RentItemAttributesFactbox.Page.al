Page 25006647 "Rent Item Attributes Factbox"
{
    Caption = 'Rent Item Attributes';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Item Attribute Value";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field(Attribute; Rec.GetAttributeNameInCurrentLanguage)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Attribute';
                    ToolTip = 'Specifies the name of the item attribute.';
                    Visible = TranslatedValuesVisible;
                }
                field(Value; Rec.GetValueInCurrentLanguage)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Value';
                    ToolTip = 'Specifies the value of the item attribute.';
                    Visible = TranslatedValuesVisible;
                }
                field(AttributeName; Rec."Attribute Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Attribute';
                    ToolTip = 'Specifies the name of the item attribute.';
                    Visible = not TranslatedValuesVisible;
                }
                field(RawValue; Rec.Value)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Value';
                    ToolTip = 'Specifies the value of the item attribute.';
                    Visible = not TranslatedValuesVisible;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Edit)
            {
                AccessByPermission = TableData "Item Attribute" = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Edit';
                Image = Edit;
                ToolTip = 'Edit item''s attributes, such as color, size, or other characteristics that help to describe the item.';
                Visible = IsItem;

                trigger OnAction()
                var
                    Item: Record Item;
                begin
                    if not IsItem then
                        exit;
                    if not Item.Get(ContextValue) then
                        exit;
                    Page.RunModal(Page::"Item Attribute Value Editor", Item);
                    CurrPage.SaveRecord;
                    LoadItemAttributesData(ContextValue);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetAutocalcFields("Attribute Name");
        TranslatedValuesVisible := CurrentClientType() <> Clienttype::Phone;

    end;

    var
        TranslatedValuesVisible: Boolean;
        ContextType: Option "None",Item,Category;
        ContextValue: Code[20];
        IsItem: Boolean;

    procedure LoadItemAttributesData(KeyValue: Code[20])
    begin
        Rec.LoadIRenttemAttributesFactBoxData(KeyValue);
        SetContext(Contexttype::Item, KeyValue);
        CurrPage.Update(false);
    end;

    local procedure SetContext(NewType: Option; NewValue: Code[20])
    begin
        ContextType := NewType;
        ContextValue := NewValue;
        IsItem := ContextType = Contexttype::Item;
    end;
}

