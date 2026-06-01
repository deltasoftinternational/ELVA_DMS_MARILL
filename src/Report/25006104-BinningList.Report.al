Report 25006104 "Binning List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/BinningList.rdlc';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            column(ReportForNavId_25006000; 25006000)
            {
            }
            column(Company_Name; CompanyInformation.Name)
            {
            }
            column(Buyfrom_Vendor_No; "Buy-from Vendor No.")
            {
            }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name")
            {
            }
            column(VendorShipmentNo; "Vendor Shipment No.")
            {
                IncludeCaption = true;
            }
            column(VendorInvoiceNo; "Vendor Invoice No.")
            {
                IncludeCaption = true;
            }
            column(Document_Type; "Document Type")
            {
            }
            column(Order_No; "No.")
            {
            }
            column(Location_Code; "Location Code")
            {
                IncludeCaption = true;
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Shipment Package No.");
                column(ReportForNavId_25006001; 25006001)
                {
                }
                column(LineNo; LineNo)
                {
                }
                column(No_; "No.")
                {
                }
                column(Description; Description)
                {
                    IncludeCaption = true;
                }
                column(Bin_Code; "Bin Code")
                {
                    IncludeCaption = true;
                }
                column(Vendor_Item_No; "Vendor Item No.")
                {
                    IncludeCaption = true;
                }
                column(Quantity; Quantity)
                {
                    IncludeCaption = true;
                }
                column(Shipment_Package_No; "Shipment Package No.")
                {
                    IncludeCaption = true;
                }
                column(AllocatedDispatch; AllocatedDispatch)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if "Shipment Package No." <> PreviosShipmPackgNo then
                        LineNo := 0;

                    AllocatedDispatch := '';
                    ReservationEntry.Reset;
                    ReservationEntry.SetRange("Source ID", "Document No.");
                    ReservationEntry.SetRange("Source Ref. No.", "Line No.");
                    if ReservationEntry.Find('-') then begin
                        n := 0;
                        repeat
                            if ReservationEntry2.Get(ReservationEntry."Entry No.", false) then
                                if n = 0 then
                                    AllocatedDispatch := ReservationEntry2."Source ID"
                                else
                                    AllocatedDispatch += Format(Char13) + Format(Char10) + ReservationEntry2."Source ID";
                            n += 1;
                        until ReservationEntry.Next = 0;
                    end;

                    LineNo += 1;
                    PreviosShipmPackgNo := "Shipment Package No.";
                end;

                trigger OnPreDataItem()
                begin
                    "Purchase Line".SetRange(Type, Type::Item);
                    Char10 := 10;
                    Char13 := 13;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                LineNo := 0;
            end;
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

    labels
    {
        ReportNameTxt = 'BINNING LIST';
        SignatureLbl = 'SIGNATURE';
        VendorLbl = 'Vendor No.';
        StoredQtyLbl = 'Stored Quantity';
        AllocatedDispatchLbl = 'Allocated Dispatch';
        LineNoLbl = 'Line No.';
        ItemNoLbl = 'Item No.';
        DocumentNoLbl = 'Document No.';
    }

    trigger OnPreReport()
    begin
        CompanyInformation.Get;
    end;

    var
        LineNo: Integer;
        AllocatedDispatch: Text;
        CompanyInformation: Record "Company Information";
        ReservationEntry: Record "Reservation Entry";
        ReservationEntry2: Record "Reservation Entry";
        Char10: Char;
        Char13: Char;
        PreviosShipmPackgNo: Code[20];
        n: Integer;
}

