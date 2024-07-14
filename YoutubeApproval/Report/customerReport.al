report 60000 "Testing Fields"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = CustomReport;

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", Name;
            DataItemTableView = sorting(Name);
            column(No_; "No.")
            {

            }
            column(Name; Name)
            {

            }
        }
    }



    rendering
    {
        layout(CustomReport)
        {
            Type = RDLC;
            LayoutFile = 'CustomeReport.rdl';
        }
    }

    var
        myInt: Integer;
}