using System;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Globalization;
using System.Web.UI.WebControls;

public partial class MainPage : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }

    public string RenderControlToHtml(Control control)
    {
        var htmlStringBuilder = new StringBuilder();
        var htmlStringWriter = new StringWriter(htmlStringBuilder);
        var htmlTextWriter = new HtmlTextWriter(htmlStringWriter);
        control.RenderControl(htmlTextWriter);
        return htmlStringBuilder.ToString();
    }

    public Control MakeControlForRecentReply(Guid? recentPostId, Guid? recentPostUserId, string recentPostUsername, string recentPostTitle,
        DateTime? recentPostCreateDate)
    {
        var containerDiv = new HtmlGenericControl("div");
        containerDiv.Attributes["class"] = "container-fluid";

        if (!recentPostId.HasValue || !recentPostUserId.HasValue || string.IsNullOrWhiteSpace(recentPostUsername) ||
            string.IsNullOrWhiteSpace(recentPostTitle) || !recentPostCreateDate.HasValue)
        {
            var labelControl = new Label {Text = "No recent posts"};
            containerDiv.Controls.Add(labelControl);
        }
        else
        {
            var titleHyperlinkControl = new HyperLink();
            if (recentPostTitle.Length > 20)
            {
                titleHyperlinkControl.Text = Server.HtmlEncode(recentPostTitle.Substring(0, 20) + "...");
            }
            else
            {
                titleHyperlinkControl.Text = Server.HtmlEncode(recentPostTitle);
            }
            titleHyperlinkControl.NavigateUrl = string.Format("Replies.aspx?Post={0}", recentPostId);
            titleHyperlinkControl.Font.Size = FontUnit.Medium;
            containerDiv.Controls.Add(titleHyperlinkControl);
            containerDiv.Controls.Add(new LiteralControl("<br>"));

            var createDateLabelControl = new Label
            {
                Text = recentPostCreateDate.Value.ToString("dd MMMM yyyy HH:mm", CultureInfo.CreateSpecificCulture("en-us"))
            };
            containerDiv.Controls.Add(createDateLabelControl);
            containerDiv.Controls.Add(new LiteralControl("<br>"));

            var userLabelControl = new Label
            {
                Text = "by "
            };

            var userHyperLink = new HyperLink
            {
                Text = recentPostUsername,
                NavigateUrl = string.Format("Profile.aspx?User={0}", recentPostUserId)
            };

            containerDiv.Controls.Add(userLabelControl);
            containerDiv.Controls.Add(userHyperLink);
        }

        return containerDiv;
    }

    protected void CreateNewCategoryClick(object sender, EventArgs e)
    {
        if (!User.Identity.IsAuthenticated)
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "ErrorMessage", "alert('Unable to create category because no user is logged in.')", true);
            return;
        }
        var membershipUser = Membership.GetUser(User.Identity.Name);
        if (membershipUser == null || membershipUser.ProviderUserKey == null)
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "ErrorMessage", "alert('Unable to create category because no logged user cant be found.')", true);
            return;
        }

        if (!User.IsInRole("administrator"))
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "ErrorMessage", "alert('Unable to create category because current user is not an administrator.')", true);
            return;
        }

        var categoryNameTextBox = lvCategoryDialogLoginView.FindControl("tbCategoryName") as TextBox;
        var categoryDescriptionTextBox = lvCategoryDialogLoginView.FindControl("tbCategoryDescription") as TextBox;

        if (categoryNameTextBox == null || categoryDescriptionTextBox == null)
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "ErrorMessage", "alert('Unable to create category because text or description cannot be found.')", true);
            return;
        }
        if (!CreateNewCategoryIntoDb((Guid)membershipUser.ProviderUserKey, categoryNameTextBox.Text, categoryDescriptionTextBox.Text))
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "ErrorMessage",
                "alert('Unable to create category. Please contact the sys admin.')", true);
        }
        else
        {
            gvCategoriesContainer.DataBind();
            categoryNameTextBox.Text = string.Empty;
            categoryDescriptionTextBox.Text = string.Empty;
        }
    }

    public bool CreateNewCategoryIntoDb(Guid userId, string categoryName, string categoryDescription)
    {
        var currentTransaction =
            DatabaseHandler.GetInstance().DatabaseConnection.BeginTransaction("InsertCategoryTransaction");

        try
        {
            var currentDate = DateTime.Now;

            const string insertCategoryCommandText = "INSERT INTO Category(ID, Description, Name, CreateDate, CreateBy, LastUpdateDate, LastUpdateBy) VALUES (NEWID(), @Description, @Name, @CreateDate, @CreateBy, @LastUpdateDate, @LastUpdateBy)";

            var insertCategoryCommand = new SqlCommand(insertCategoryCommandText, DatabaseHandler.GetInstance().DatabaseConnection, currentTransaction);

            insertCategoryCommand.Parameters.AddWithValue("Name", categoryName);
            insertCategoryCommand.Parameters.AddWithValue("Description", categoryDescription);
            insertCategoryCommand.Parameters.AddWithValue("CreateDate", currentDate);
            insertCategoryCommand.Parameters.AddWithValue("CreateBy", userId);
            insertCategoryCommand.Parameters.AddWithValue("LastUpdateDate", currentDate);
            insertCategoryCommand.Parameters.AddWithValue("LastUpdateBy", userId);


            insertCategoryCommand.ExecuteNonQuery();

            currentTransaction.Commit();
            return true;
        }
        catch (Exception)
        {
            currentTransaction.Rollback();
            return false;
        }

    }
}