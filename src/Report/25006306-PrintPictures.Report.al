Report 25006306 "Print Pictures"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PrintPictures.rdlc';

    dataset
    {
        dataitem(Picture; Picture)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(Image; Picture.Blob)
            {
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

    labels
    {
    }
}

