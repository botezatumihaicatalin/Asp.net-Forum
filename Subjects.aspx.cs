using System;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Globalization;
using System.Web.UI.WebControls;

public partial class Subjects : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (Request["Category"] == null)
            {
                Response.Redirect("MainPage.aspx");
                return;
            }
            Guid categoryId;
            if (!Guid.TryParse(Request["Category"], out categoryId))
            {
                Response.Redirect("MainPage.aspx");
                return;
            }
            if (!PopulateCategoryData(categoryId))
            {
                Response.Redirect("MainPage.aspx");
                return;
            }
        }
        
    }

    private bool PopulateCategoryData(Guid categoryId)
    {
        const string commandText = "SELECT * FROM Category WHERE ID = @CategoryID";
        var fetchCommand = new SqlCommand(commandText, DatabaseHandler.GetInstance().DatabaseConnection);
        fetchCommand.Parameters.AddWithValue("CategoryID", categoryId);
        var sqlReader = fetchCommand.ExecuteReader();
        if (sqlReader.Read())
        {
            var description = Convert.ToString(sqlReader["Description"]);
            var categoryName = Convert.ToString(sqlReader["Name"]);
            lblCategoryName.Text = Server.HtmlEncode(categoryName);
            lblCategoryDescription.Text = Server.HtmlEncode(description);
            sqlReader.Close();
            return true;
        }
        sqlReader.Close();
        return false;
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
            var labelControl = new Label { Text = "No recent posts" };
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

    public void CreateNewSubjectClick(object sender, EventArgs args)
    {
        if (Request["Category"] == null)
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "ErrorMessage", "alert('Unable to create subject because no subject is specified in query.')", true);
            return;
        }
        Guid categoryId;
        if (!Guid.TryParse(Request["Category"], out categoryId))
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "ErrorMessage", "alert('Unable to create subject because subject query is in incorrect format.')", true);
            return;
        }
        if (!User.Identity.IsAuthenticated)
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "ErrorMessage", "alert('Unable to create subject because no user is logged in.')", true);
            return;
        }
        var membershipUser = Membership.GetUser(User.Identity.Name);
        if (membershipUser == null || membershipUser.ProviderUserKey == null)
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "ErrorMessage", "alert('Unable to create subject because no logged user cant be found.')", true);
            return;
        }

        if (!User.IsInRole("administrator"))
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "ErrorMessage", "alert('Unable to create subject because logged user isn't administrator.')", true);
            return;
        }

        var subjectNameTextBox = lvSubjectDialogLoginView.FindControl("tbSubjectName") as TextBox;
        var subjectDescriptionTextBox = lvSubjectDialogLoginView.FindControl("tbSubjectDescription") as TextBox;
        if (subjectNameTextBox == null || subjectDescriptionTextBox == null)
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "ErrorMessage", "alert('Unable to create subject because no title or text cannot be found.')", true);
            return;
        }
        if (!CreateNewSubjectIntoDb(categoryId, (Guid) membershipUser.ProviderUserKey, subjectNameTextBox.Text,
            subjectDescriptionTextBox.Text))
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "ErrorMessage",
                "alert('Unable to create subject. Please contact the administrator.')", true);
        }
        else
        {
            gvSubjectList.DataBind();
            subjectNameTextBox.Text = string.Empty;
            subjectDescriptionTextBox.Text = string.Empty;
        }
    }

    private bool CreateNewSubjectIntoDb(Guid categoryId, Guid userId, string subjectName, string subjectDescription)
    {
        var currentTransaction =
            DatabaseHandler.GetInstance().DatabaseConnection.BeginTransaction("InsertSubjectTransaction");

        try
        {
            var currentDate = DateTime.Now;

            const string insertSubjectCommandText = "INSERT INTO Subjects(ID, CategoryID , Description, Name, CreateDate, CreateBy, LastUpdateDate, LastUpdateBy) VALUES (@ID, @CategoryID, @Description, @Name, @CreateDate, @CreateBy, @LastUpdateDate, @LastUpdateBy)";

            var insertSubjectCommand = new SqlCommand(insertSubjectCommandText, DatabaseHandler.GetInstance().DatabaseConnection, currentTransaction);

            insertSubjectCommand.Parameters.AddWithValue("ID", Guid.NewGuid());
            insertSubjectCommand.Parameters.AddWithValue("CategoryID", categoryId);
            insertSubjectCommand.Parameters.AddWithValue("Name", subjectName);
            insertSubjectCommand.Parameters.AddWithValue("Description", subjectDescription);
            insertSubjectCommand.Parameters.AddWithValue("CreateDate", currentDate);
            insertSubjectCommand.Parameters.AddWithValue("CreateBy", userId);
            insertSubjectCommand.Parameters.AddWithValue("LastUpdateDate", currentDate);
            insertSubjectCommand.Parameters.AddWithValue("LastUpdateBy", userId);


            insertSubjectCommand.ExecuteNonQuery();

            currentTransaction.Commit();
            return true;
        }
        catch (Exception er)
        {
            currentTransaction.Rollback();
            return false;
        }
    }
}