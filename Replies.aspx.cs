using System;
using System.Data.SqlClient;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Replies : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (Request["Post"] == null)
            {
                Response.Redirect("MainPage.aspx");
                return;
            }
            Guid postId;
            if (!Guid.TryParse(Request["Post"], out postId))
            {
                Response.Redirect("MainPage.aspx");
                return;
            }
            if (!PopulatePostData(postId))
            {
                Response.Redirect("MainPage.aspx");
                return;
            }
        }
    }

    public void CreateNewReplyIntoDbButtonClick(object sender, EventArgs args)
    {
        if (Request["Post"] == null)
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "ErrorMessage", "alert('Unable to create reply because no post is specified in query.')", true);
            return;
        }
        Guid postId;
        if (!Guid.TryParse(Request["Post"], out postId))
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "ErrorMessage", "alert('Unable to create reply because post query is in incorrect format.')", true);
            return;
        }
        if (!User.Identity.IsAuthenticated)
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "ErrorMessage", "alert('Unable to create reply because no user is logged in.')", true);
            return;
        }
        var membershipUser = Membership.GetUser(User.Identity.Name);
        if (membershipUser == null || membershipUser.ProviderUserKey == null)
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "ErrorMessage", "alert('Unable to create reply because no logged user cant be found.')", true);
            return;
        }

        var replyContentTextBox = lvReplyDialogLoginView.FindControl("tbReplyText") as TextBox;
        if (replyContentTextBox == null)
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "ErrorMessage", "alert('Unable to create reply because text cannot be found.')", true);
            return;
        }
        if (!CreateNewReplyIntoDb(postId, (Guid)membershipUser.ProviderUserKey, replyContentTextBox.Text))
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "ErrorMessage",
                "alert('Unable to create post. Please contact the administrator.')", true);
        }
        else
        {
            gvRepliesList.DataBind();
            replyContentTextBox.Text = string.Empty;
        }
    }

    public bool CreateNewReplyIntoDb(Guid postId, Guid userId, string replyContent)
    {
        var currentTransaction =
            DatabaseHandler.GetInstance().DatabaseConnection.BeginTransaction("InsertReplyTransaction");

        try
        {
            var currentDate = DateTime.Now;
            
            const string insertReplyCommandText = "INSERT INTO Replies(ID, PostID, Text, CreateDate, CreateBy, LastUpdateDate, LastUpdateBy, IsReply) VALUES (NEWID(), @PostID, @Text, @CreateDate, @CreateBy, @LastUpdateDate, @LastUpdateBy, @IsReply)";
            
            var insertReplyCommand = new SqlCommand(insertReplyCommandText, DatabaseHandler.GetInstance().DatabaseConnection, currentTransaction);
            
            insertReplyCommand.Parameters.AddWithValue("PostID", postId);
            insertReplyCommand.Parameters.AddWithValue("Text", replyContent);
            insertReplyCommand.Parameters.AddWithValue("CreateDate", currentDate);
            insertReplyCommand.Parameters.AddWithValue("CreateBy", userId);
            insertReplyCommand.Parameters.AddWithValue("LastUpdateDate", currentDate);
            insertReplyCommand.Parameters.AddWithValue("LastUpdateBy", userId);
            insertReplyCommand.Parameters.AddWithValue("IsReply", true);
            

            insertReplyCommand.ExecuteNonQuery();

            currentTransaction.Commit();
            return true;
        }
        catch (Exception)
        {
            currentTransaction.Rollback();
            return false;
        }

    }

    private bool PopulatePostData(Guid postId)
    {
        const string commandText = "SELECT * FROM Posts WHERE ID = @PostID";
        var fetchCommand = new SqlCommand(commandText, DatabaseHandler.GetInstance().DatabaseConnection);
        fetchCommand.Parameters.AddWithValue("PostID", postId);
        var sqlReader = fetchCommand.ExecuteReader();

        if (sqlReader.Read())
        {
            var postName = Convert.ToString(sqlReader["Title"]);
            lblPostName.Text = Server.HtmlEncode(postName);
            sqlReader.Close();
            return true;
        }
        sqlReader.Close();
        return false;
    }

    protected void RepliesOnRowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        var editTextBox = gvRepliesList.Rows[e.RowIndex].FindControl("tbEditText") as TextBox;
        if (editTextBox == null)
        {
            return;
        }
        editTextBox.Text = Server.HtmlEncode(editTextBox.Text);
    }
}