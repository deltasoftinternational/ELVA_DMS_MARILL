XmlPort 25006870 "Export TCard Data"
{
    Direction = Export;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            textelement(Containers)
            {
                textattribute(editmode)
                {
                    XmlName = 'EditMode';
                }
                tableelement("TCard Container"; "TCard Container")
                {
                    XmlName = 'Container';
                    SourceTableView = where(Enabled = const(true));
                    fieldelement(EntryNo; "TCard Container"."No.")
                    {
                    }
                    fieldelement(Name; "TCard Container".Name)
                    {
                    }
                    fieldelement(Size; "TCard Container"."Configured Size")
                    {

                        trigger OnBeforePassField()
                        begin
                            if "TCard Container"."Configured Size" = 0 then
                                "TCard Container"."Configured Size" := TCardMgt.GetContainerDefaultSize("TCard Container"."Container Size");
                        end;
                    }
                    textelement(bodycolor)
                    {
                        XmlName = 'Color';
                    }
                    textelement(headercolor)
                    {
                        XmlName = 'HeaderColor';
                    }
                    fieldelement(PositionX; "TCard Container".PositionX)
                    {
                    }
                    fieldelement(PositionY; "TCard Container".PositionY)
                    {
                    }
                    fieldelement(EntryType; "TCard Container".Type)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin

                        TCardMgt.GetContainerColorCodes("TCard Container"."Container Color", HeaderColor, BodyColor);
                    end;

                    trigger OnPreXmlItem()
                    begin
                        if LocationCode = '' then
                            LocationCode := TCardMgt.GetDefaultLocationCode;
                        "TCard Container".SetRange("TCard Container"."Location Code", LocationCode);
                    end;
                }
            }
            textelement(Items)
            {
                tableelement("Service Header EDMS"; "Service Header EDMS")
                {
                    XmlName = 'Item';
                    SourceTableView = sorting("TCardContSortIdx", "Document Type", "No.") order(Ascending) where("Document Type" = filter(Booking | Order), "TCard Container Entry No." = filter(<> 0));
                    textelement(ItemNo)
                    {
                    }
                    textelement(ItemType)
                    {
                    }
                    textelement(ItemContainerNo)
                    {
                    }
                    textelement(ItemLabel1)
                    {
                    }
                    textelement(ItemText1)
                    {
                    }
                    textelement(ItemText2)
                    {
                    }
                    textelement(ItemText3)
                    {
                    }
                    textelement(ItemText4)
                    {
                    }
                    textelement(TooltipText1)
                    {
                    }
                    textelement(TooltipText2)
                    {
                    }
                    textelement(ItemImage1)
                    {
                        TextType = Text;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        ItemNo := TCardMgt.FormatItemNo("Service Header EDMS");
                        ItemType := TCardMgt.FormatItemType("Service Header EDMS");
                        ItemContainerNo := TCardMgt.FormatItemContainerNo("Service Header EDMS");
                        ItemLabel1 := TCardMgt.FormatItemLabel1("Service Header EDMS");
                        ItemText1 := TCardMgt.FormatItemText1("Service Header EDMS");
                        ItemText2 := TCardMgt.FormatItemText2("Service Header EDMS");
                        ItemText3 := TCardMgt.FormatItemText3("Service Header EDMS");
                        TCardMgt.FormatItemImage1("Service Header EDMS", ItemImage1);
                        TooltipText1 := 'Tooltip Header';
                        TooltipText2 := 'Tooltip Description';
                        ItemText4 := 'Custom Title';
                    end;
                }
            }
            textelement(Status)
            {
                textelement(RefreshInterval)
                {

                    trigger OnBeforePassVariable()
                    begin
                        RefreshInterval := Format(RefreshIntervalGlobal)
                    end;
                }
                textelement(StartRefresh)
                {

                    trigger OnBeforePassVariable()
                    begin
                        StartRefresh := Format(StartRefreshGlobal);
                    end;
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    var
        TCardMgt: Codeunit "TCard Management";
        LocationCode: Code[20];
        RefreshIntervalGlobal: Integer;
        StartRefreshGlobal: Boolean;


    procedure SetLocationCode(LocationCodeToSet: Code[20])
    begin
        LocationCode := LocationCodeToSet;
    end;


    procedure SetEditMode(EditModeToSet: Boolean)
    begin
        EditMode := Format(EditModeToSet);
    end;

    procedure SetRefreshInterval(RefreshIntervalToSet: Integer)
    begin
        RefreshIntervalGlobal := RefreshIntervalToSet;
    end;

    procedure SetStartRefresh(StartRefreshToSet: Boolean)
    begin
        StartRefreshGlobal := StartRefreshToSet;
    end;

}

