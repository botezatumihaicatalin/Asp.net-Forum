using System;
using System.Web.UI;

public partial class Search : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (Request["Query"] == null)
            {
                Response.Redirect("MainPage.aspx");
                return;
            }
        }
    }
}