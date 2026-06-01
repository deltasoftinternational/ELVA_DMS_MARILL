XmlPort 25006202 "Export MapView Data"
{
    Direction = Export;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            textelement(MapView)
            {
                textattribute(ApiWebsource)
                {
                }
                textattribute(ZoomLevel)
                {
                }
                textelement(Locations)
                {
                    tableelement("Data Buffer"; "Data Buffer")
                    {
                        MinOccurs = Zero;
                        XmlName = 'Location';
                        UseTemporary = true;
                        fieldelement(Longitude; "Data Buffer"."Text Field 1")
                        {
                        }
                        fieldelement(Latitude; "Data Buffer"."Text Field 2")
                        {
                        }
                        fieldelement(Address; "Data Buffer"."Text Field 3")
                        {
                        }
                        fieldelement(Description; "Data Buffer"."Text Field 4")
                        {
                        }
                    }
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


    procedure SetApiWebsource(ApiWebsourceToSet: Text)
    begin
        ApiWebsource := ApiWebsourceToSet;
    end;


    procedure SetZoomLevel(ZoomLevelToSet: Integer)
    begin
        ZoomLevel := Format(ZoomLevelToSet);
    end;


    procedure SetDataBuffer(var DataBufferToSet: Record "Data Buffer")
    begin
        DataBufferToSet.Reset;
        if DataBufferToSet.FindFirst then
            repeat
                "Data Buffer".Init;
                "Data Buffer" := DataBufferToSet;
                "Data Buffer".Insert;
            until DataBufferToSet.Next = 0;
    end;
}

