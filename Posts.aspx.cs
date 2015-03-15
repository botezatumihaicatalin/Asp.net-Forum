using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Web.Hosting;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class Posts : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
        if (!Page.IsPostBack)
        {
            if (Request["Subject"] == null)
            {
                Response.Redirect("MainPage.aspx");
                return;
            }
            Guid subjectId;
            if (!Guid.TryParse(Request["Subject"], out subjectId))
            {
                Response.Redirect("MainPage.aspx");
                return;
            }
            if (!PopulateSubjectData(subjectId))
            {
                Response.Redirect("MainPage.aspx");
                return;
            }
        }
    }

    private bool PopulateSubjectData(Guid subjectId)
    {
        const string commandText = "SELECT * FROM Subjects WHERE ID = @SubjectID";
        var fetchCommand = new SqlCommand(commandText, DatabaseHandler.GetInstance().DatabaseConnection);
        fetchCommand.Parameters.AddWithValue("SubjectID", subjectId);
        var sqlReader = fetchCommand.ExecuteReader();
        
        if (sqlReader.Read())
        {
            var subjectName = Convert.ToString(sqlReader["Name"]);
            var subjectDescription = Convert.ToString(sqlReader["Description"]);
            lblSubjectDescription.Text = Server.HtmlEncode(subjectDescription);
            lblSubjectName.Text = Server.HtmlEncode(subjectName);
            sqlReader.Close();
            return true;
        }
        sqlReader.Close();
        return false;
    }

    public void CreateNewPostIntoDbButtonClick(object sender, EventArgs args)
    {
        if (Request["Subject"] == null)
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "ErrorMessage", "alert('Unable to create post because no subject is specified in query.')", true);
            return;
        }
        Guid subjectId;
        if (!Guid.TryParse(Request["Subject"], out subjectId))
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "ErrorMessage", "alert('Unable to create post because subject query is in incorrect format.')", true);
            return;
        }
        if (!User.Identity.IsAuthenticated)
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "ErrorMessage", "alert('Unable to create post because no user is logged in.')", true);
            return;
        }
        var membershipUser = Membership.GetUser(User.Identity.Name);
        if (membershipUser == null || membershipUser.ProviderUserKey == null)
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "ErrorMessage", "alert('Unable to create post because no logged user cant be found.')", true);
            return;
        }

        var postTitleTextBox = lvPostDialogLoginView.FindControl("tbPostTitle") as TextBox;
        var postContentTextBox = lvPostDialogLoginView.FindControl("tbPostText") as TextBox;
        if (postTitleTextBox == null || postContentTextBox == null)
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "ErrorMessage", "alert('Unable to create post because no title or text cannot be found.')", true);
            return;
        }
        if (!CreateNewPostIntoDb(subjectId, (Guid) membershipUser.ProviderUserKey, postTitleTextBox.Text,
            postContentTextBox.Text))
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "ErrorMessage",
                "alert('Unable to create post. Please contact the administrator.')", true);
        }
        else
        {
            gvPostsList.DataBind();
            postTitleTextBox.Text = string.Empty;
            postContentTextBox.Text = string.Empty;
        }
    }

    private bool CreateNewPostIntoDb(Guid subjectId, Guid userId, string title, string postText)
    {

        var currentTransaction =
            DatabaseHandler.GetInstance().DatabaseConnection.BeginTransaction("CreateNewPostTransaction");

        var currentDate = DateTime.Now;
        var newId = Guid.NewGuid();

        try
        {
            const string insertPostCommandText = "INSERT INTO Posts(ID, SubjectID, Title, CreateDate, CreateBy, LastUpdateBy, LastUpdateDate) VALUES (@ID, @SubjectID, @Title, @CreateDate, @CreateBy, @LastUpdateBy, @LastUpdateDate)";

            var insertPostCommand = new SqlCommand(insertPostCommandText, DatabaseHandler.GetInstance().DatabaseConnection, currentTransaction);
            insertPostCommand.Parameters.AddWithValue("ID", newId);
            insertPostCommand.Parameters.AddWithValue("CreateBy", userId);
            insertPostCommand.Parameters.AddWithValue("CreateDate", currentDate);
            insertPostCommand.Parameters.AddWithValue("LastUpdateBy", userId);
            insertPostCommand.Parameters.AddWithValue("LastUpdateDate", currentDate);
            insertPostCommand.Parameters.AddWithValue("SubjectID", subjectId);
            insertPostCommand.Parameters.AddWithValue("Title", title);

            insertPostCommand.ExecuteNonQuery();

            const string insertReplyCommandText = "INSERT INTO Replies(ID, PostID, Text, CreateDate, CreateBy, LastUpdateDate, LastUpdateBy, IsReply) VALUES (NEWID(), @PostID, @Text, @CreateDate, @CreateBy, @LastUpdateDate, @LastUpdateBy, @IsReply)";
            var insertReplyCommand = new SqlCommand(insertReplyCommandText, DatabaseHandler.GetInstance().DatabaseConnection, currentTransaction);
            insertReplyCommand.Parameters.AddWithValue("PostID", newId);
            insertReplyCommand.Parameters.AddWithValue("Text", postText);
            insertReplyCommand.Parameters.AddWithValue("CreateDate", currentDate);
            insertReplyCommand.Parameters.AddWithValue("CreateBy", userId);
            insertReplyCommand.Parameters.AddWithValue("LastUpdateDate", currentDate);
            insertReplyCommand.Parameters.AddWithValue("LastUpdateBy", userId);
            insertReplyCommand.Parameters.AddWithValue("IsReply", false);

            insertReplyCommand.ExecuteNonQuery();

            currentTransaction.Commit();
            return true;
        }
        catch (Exception)
        {
            try
            {
                currentTransaction.Rollback();
            }
            // Supress errors such as conneciton closed.
            catch (Exception er)
            {
                
            }
            return false;
        }
    }

    public Control CreateEditRemovePostControl()
    {
        var topDivElement = new HtmlGenericControl("div");
        topDivElement.Attributes["class"] = "padding-top10";

        var editButton = new LinkButton
        {
            ID = "lbtnEdit",
            CausesValidation = false,
            CommandName = "Edit",
            CssClass = "btn btn-sm btn-warning margin-bottom-1em",
            Text = "Edit"
        };

        var editGlyphicon = new HtmlGenericControl("span");
        editGlyphicon.Attributes["class"] = "glyphicon glyphicon-edit";
        editButton.Controls.Add(editGlyphicon);

        var deleteButton = new LinkButton
        {
            ID = "lbtnDelete",
            CausesValidation = false,
            CommandName = "Delete",
            CssClass = "btn btn-sm btn-danger margin-bottom-1em",
            Text = "Delete"
        };

        var deleteGlyphicon = new HtmlGenericControl("span");
        editGlyphicon.Attributes["class"] = "glyphicon glyphicon-remove";
        deleteButton.Controls.Add(deleteGlyphicon);
        
        topDivElement.Controls.Add(editButton);
        topDivElement.Controls.Add(deleteButton);

        return topDivElement;
    }

    public void SortGridView(object sender, EventArgs e)
    {
        SortDirection sortDirection;
        if (!Enum.TryParse(ddlOrderDirection.SelectedValue, out sortDirection))
        {
            return;
        }
        gvPostsList.Sort(ddlOrderBy.SelectedValue, sortDirection);
    }

}