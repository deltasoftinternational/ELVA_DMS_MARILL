XmlPort 25006200 "Export Alloc. Events"
{
    Caption = 'Export Alloc. Events';
    Direction = Both;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = false;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            MaxOccurs = Once;
            textelement(headerstartdt)
            {
                XmlName = 'StartDT';
            }
            textelement(headerenddt)
            {
                XmlName = 'EndDT';
            }
            textelement(showntimestart)
            {
                XmlName = 'ShownTimeStart';
            }
            textelement(showntimeend)
            {
                XmlName = 'ShownTimeEnd';
            }
            textelement(timerinterval)
            {
                XmlName = 'TimerInterval';

                trigger OnBeforePassVariable()
                begin
                    TimerInterval := Format(RefreshInterval); //in milliseconds
                end;
            }
            textelement(timestep)
            {
                XmlName = 'TimeStep';

                trigger OnBeforePassVariable()
                begin
                    TimeStep := Format(EventTimeStep); // in minutes
                end;
            }
            textelement(timeformat)
            {
                XmlName = 'TimeFormat';
            }

            textelement(WeekType)
            {
                trigger OnBeforePassVariable()
                begin
                    WeekType := WeekTypeGlobal;
                end;
            }
            textelement(TimeGridItems)
            {
                tableelement(timegriditem; "Time Grid Item")
                {
                    XmlName = 'TimeGridItem';
                    UseTemporary = true;
                    fieldelement(Description; TimeGridItem.Description)
                    {
                    }
                    textelement(timestart)
                    {
                        XmlName = 'TimeStart';

                        trigger OnBeforePassVariable()
                        begin
                            TimeStart := Format(DatetimeMgt.Datetime(0D, TimeGridItem."Time Start"), 0, 9);
                        end;
                    }
                    textelement(timeend)
                    {
                        XmlName = 'TimeEnd';

                        trigger OnBeforePassVariable()
                        begin
                            TimeEnd := Format(DatetimeMgt.Datetime(0D, TimeGridItem."Time End"), 0, 9);
                        end;
                    }
                    textelement("''")
                    {
                        XmlName = 'GroupingCode';
                    }

                    trigger OnPreXmlItem()
                    begin
                        if TimeGridItem."Grid Code" = '' then begin
                            currXMLport.Break;
                        end;
                    end;
                }
            }
            textelement(ScheduleCaptions)
            {
                tableelement("Schedule Caption"; "Schedule Caption")
                {
                    XmlName = 'ScheduleCaption';
                    UseTemporary = true;
                    fieldelement(ID; "Schedule Caption".ID)
                    {
                    }
                    fieldelement(Caption; "Schedule Caption".Caption)
                    {
                    }
                    fieldelement(Sequence; "Schedule Caption".SequenceNo)
                    {
                    }
                    fieldelement(GroupingCode; "Schedule Caption".GroupingCode)
                    {
                    }
                }
            }
            textelement(Items)
            {
                tableelement("Schedule Item"; "Schedule Item")
                {
                    XmlName = 'Item';
                    UseTemporary = true;
                    fieldelement(ItemID; "Schedule Item".ItemID)
                    {
                    }
                    fieldelement(ItemNo; "Schedule Item".ItemNo)
                    {
                    }
                    fieldelement(Description; "Schedule Item".Description)
                    {
                    }
                    fieldelement(Sequence; "Schedule Item".Sequence)
                    {
                    }
                    fieldelement(Level; "Schedule Item".Level)
                    {
                    }
                    fieldelement(Current; "Schedule Item".Current)
                    {
                    }
                    fieldelement(Parent; "Schedule Item".Parent)
                    {
                    }
                    fieldelement(Collapsed; "Schedule Item".Collapsed)
                    {
                    }
                    textelement(itemforecolor)
                    {
                        XmlName = 'ForeColor';
                        fieldattribute(R; "Schedule Item".ForeColorR)
                        {
                        }
                        fieldattribute(G; "Schedule Item".ForeColorG)
                        {
                        }
                        fieldattribute(B; "Schedule Item".ForeColorB)
                        {
                        }
                    }
                    textelement(ScrollBar)
                    {
                        fieldattribute(Position; "Schedule Item".ScrollBarPosition)
                        {
                        }
                        fieldattribute(TotalCount; "Schedule Item".ScrollBarTotalCount)
                        {
                        }
                    }
                    fieldelement(GroupingCode; "Schedule Item".GroupingCode)
                    {
                    }
                }
            }
            textelement(Allocations)
            {
                tableelement("Schedule Allocation"; "Schedule Allocation")
                {
                    XmlName = 'Allocation';
                    UseTemporary = true;
                    fieldelement(EntryNo; "Schedule Allocation".OriginalEntryNo)
                    {
                    }
                    fieldelement(ItemID; "Schedule Allocation".ItemID)
                    {
                    }
                    fieldelement(ItemNo; "Schedule Allocation".ItemNo)
                    {
                    }
                    fieldelement(Description; "Schedule Allocation".Text)
                    {
                    }
                    textelement(startingdt)
                    {
                        XmlName = 'StartDT';

                        trigger OnBeforePassVariable()
                        begin
                            StartingDT := Format("Schedule Allocation".StartDT, 0, 9);
                        end;
                    }
                    textelement(endingdt)
                    {
                        XmlName = 'EndDT';

                        trigger OnBeforePassVariable()
                        begin
                            EndingDT := Format("Schedule Allocation".EndDT, 0, 9);
                        end;
                    }
                    textelement(displaystartdt)
                    {
                        XmlName = 'DisplayStartDT';

                        trigger OnBeforePassVariable()
                        begin
                            DisplayStartDT := Format("Schedule Allocation".StartDT, 0, 9);
                        end;
                    }
                    textelement(displayenddt)
                    {
                        XmlName = 'DisplayEndDT';

                        trigger OnBeforePassVariable()
                        begin
                            DisplayEndDT := Format("Schedule Allocation".EndDT, 0, 9);
                        end;
                    }
                    textelement(BackColor)
                    {
                        fieldattribute(R; "Schedule Allocation".BackColorR)
                        {
                        }
                        fieldattribute(G; "Schedule Allocation".BackColorG)
                        {
                        }
                        fieldattribute(B; "Schedule Allocation".BackColorB)
                        {
                        }
                    }
                    textelement(forecolor)
                    {
                        XmlName = 'ForeColor';
                        fieldattribute(R; "Schedule Allocation".ForeColorR)
                        {
                        }
                        fieldattribute(G; "Schedule Allocation".ForeColorG)
                        {
                        }
                        fieldattribute(B; "Schedule Allocation".ForeColorB)
                        {
                        }
                    }
                    fieldelement(Editable; "Schedule Allocation".Editable)
                    {
                    }
                    fieldelement(AllocType; "Schedule Allocation".AllocType)
                    {
                    }
                    fieldelement(GroupingCode; "Schedule Allocation".GroupingCode)
                    {
                    }
                    fieldelement(Travel; "Schedule Allocation".Travel)
                    {
                    }
                    textelement(TimeRegEntries)
                    {
                        MinOccurs = Once;
                        tableelement("Resource Time Reg. Entry"; "Resource Time Reg. Entry")
                        {
                            MinOccurs = Zero;
                            XmlName = 'TimeRegEntry';
                            SourceTableView = sorting("Entry No.") order(ascending) where(Canceled = const(false));
                            UseTemporary = true;
                            fieldelement(EntryNo; "Resource Time Reg. Entry"."Entry No.")
                            {
                            }
                            fieldelement(AllocationEntryNo; "Resource Time Reg. Entry"."Allocation Entry No.")
                            {
                            }
                            fieldelement(ItemID; "Resource Time Reg. Entry"."Resource No.")
                            {
                            }
                            fieldelement(EntryType; "Resource Time Reg. Entry"."Entry Type")
                            {
                            }
                            fieldelement(TimeSpent; "Resource Time Reg. Entry"."Time Spent")
                            {
                            }
                            fieldelement(Date; "Resource Time Reg. Entry".Date)
                            {
                            }
                            fieldelement(Time; "Resource Time Reg. Entry".Time)
                            {
                            }

                            trigger OnPreXmlItem()
                            begin
                                "Resource Time Reg. Entry".SetRange("Allocation Entry No.", "Schedule Allocation".OriginalEntryNo);
                            end;
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

    var
        DatetimeMgt: Codeunit "Datetime Mgt.";
        RefreshInterval: Integer;
        EventTimeStep: Integer;
        WeekTypeGlobal: Text;


    procedure SetParam(pHeaderStartDT: Decimal; pHeaderEndDT: Decimal; pRefreshInterval: Integer; pEventTimeStep: Integer)
    begin
        /*HeaderFromDate := DT2DATE(pHeaderFromDate);
        StartingDateTimeDec := DatetimeMgt.Datetime(DT2DATE(pHeaderFromDate), DT2TIME(pHeaderFromDate));
        HeaderFromDateText := FORMAT(StartingDateTimeDec, 0, 9);
        
        HeaderToDate := DT2DATE(pHeaderToDate);
        //subtract 1 millisecond
        EndingDateTimeDec := DatetimeMgt.Datetime(DT2DATE(pHeaderToDate), DT2TIME(pHeaderToDate));
        EndingDateTimeDec -= DatetimeMgt.Datetime(0D, 000000.001T);
        HeaderToDateText := FORMAT(EndingDateTimeDec, 0, 9);
        */
        HeaderStartDT := Format(pHeaderStartDT, 0, 9);
        HeaderEndDT := Format(pHeaderEndDT, 0, 9);
        ShownTimeStart := Format(pHeaderStartDT - DatetimeMgt.Datetime(DatetimeMgt.Datetime2Date(pHeaderStartDT), 0T), 0, 9);
        ShownTimeEnd := Format(pHeaderEndDT - DatetimeMgt.Datetime(DatetimeMgt.Datetime2Date(pHeaderEndDT), 0T), 0, 9);

        RefreshInterval := pRefreshInterval;
        EventTimeStep := pEventTimeStep;

    end;


    procedure SetCaptions(var ScheduleCaption: Record "Schedule Caption")
    begin
        "Schedule Caption".Reset;
        "Schedule Caption".DeleteAll;

        ScheduleCaption.Reset;
        if ScheduleCaption.FindFirst then
            repeat
                "Schedule Caption" := ScheduleCaption;
                "Schedule Caption".Insert;
            until ScheduleCaption.Next = 0;
    end;


    procedure SetItems(var ScheduleItem: Record "Schedule Item")
    begin
        "Schedule Item".Reset;
        "Schedule Item".DeleteAll;

        ScheduleItem.Reset;
        if ScheduleItem.FindFirst then
            repeat
                "Schedule Item" := ScheduleItem;
                "Schedule Item".Insert;
            until ScheduleItem.Next = 0;
    end;


    procedure SetItemAllocations(var ScheduleAllocation: Record "Schedule Allocation")
    begin
        "Schedule Allocation".Reset;
        "Schedule Allocation".DeleteAll;

        ScheduleAllocation.Reset;
        if ScheduleAllocation.FindFirst then
            repeat
                "Schedule Allocation" := ScheduleAllocation;
                "Schedule Allocation".Insert;
            until ScheduleAllocation.Next = 0;
    end;


    procedure SetTimeGrid(var TimeGridItemPar: Record "Time Grid Item")
    begin

        TimeGridItem.Reset;
        TimeGridItem.DeleteAll;

        TimeGridItemPar.Reset;
        if TimeGridItemPar.FindFirst then
            repeat
                TimeGridItem := TimeGridItemPar;
                TimeGridItem.Insert;
            until TimeGridItemPar.Next = 0;

    end;


    procedure SetTimeRegEntry(var TimeRegEntry: Record "Resource Time Reg. Entry")
    begin
        "Resource Time Reg. Entry".Reset;
        "Resource Time Reg. Entry".DeleteAll;

        TimeRegEntry.Reset;
        if TimeRegEntry.FindFirst then
            repeat
                "Resource Time Reg. Entry" := TimeRegEntry;
                "Resource Time Reg. Entry".Insert;
            until TimeRegEntry.Next = 0;
    end;


    procedure SetTimeFormat(TimeFormatToSet: Option "24H","12H")
    begin
        case Format(TimeFormatToSet) of
            '24H':
                begin
                    TimeFormat := '%H:%i';
                end;
            '12H':
                begin
                    TimeFormat := '%g:%i %A';
                end;
        end
    end;


    procedure SetWeekType(WeekTypeToSet: Text)
    begin
        //Available options: workweek,week
        WeekTypeGlobal := WeekTypeToSet;
    end;
}

