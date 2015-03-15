using System;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class NavbarMasterPage : MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            SetUserDetails();
        }
    }

    private void SetUserDetails()
    {
        if (!HttpContext.Current.User.Identity.IsAuthenticated)
        {
            return;
        }
        var userHyperlink = lvLoggedInUser.FindControl("hlUserLink") as HyperLink;
        var userImage = lvLoggedInUser.FindControl("imgUserImage") as Image;
        if (userHyperlink == null || userImage == null)
        {
            return;
        }
        var currentUser = Membership.GetUser();
        if (currentUser == null)
        {
            return;
        }
        userHyperlink.NavigateUrl = string.Format("Profile.aspx?User={0}", currentUser.ProviderUserKey);
        userImage.ImageUrl = UserInteraction.MakeProfileUrl((Guid)currentUser.ProviderUserKey);

    }

    public void OpenLoginDialog(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, GetType(), "OpenLoginDialog", "$(function () { $(\"#dLoginDialog\").dialog(\"open\"); } );", true);
    }

    public void CloseLoginDialog(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, GetType(), "CloseLoginDialog", "$(function () { $(\"#dLoginDialog\").dialog(\"close\"); } );", true);
    }

    public void OpenRegisterDialog(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, GetType(), "OpenRegisterDialog", "$(function () { $(\"#dRegistrationDialog\").dialog(\"open\"); } );", true);
    }

    public void CloseRegisterDialog(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, GetType(), "CloseRegisterDialog", "$(function () { $(\"#dRegistrationDialog\").dialog(\"close\"); } );", true);
    }

    public void OpenUsersPanelDialog(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, GetType(), "OpenRegisterDialog", "$(function () { $(\"#dUsersPanelDialog\").dialog(\"open\"); } );", true);
    }

    public void CloseUsersPanelDialog(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, GetType(), "OpenRegisterDialog", "$(function () { $(\"#dUsersPanelDialog\").dialog(\"close\"); } );", true);
    }

    public void RegistrationDialogOnUserCreated(object sender, EventArgs e)
    {
        Roles.AddUserToRole(cuwRegister.UserName, "user");

        var firstNameTextBox = cuwRegister.CreateUserStep.ContentTemplateContainer.FindControl("tbFirstName") as TextBox;
        var lastNameTextBox = cuwRegister.CreateUserStep.ContentTemplateContainer.FindControl("tbLastName") as TextBox;
        var birthDateTextBox = cuwRegister.CreateUserStep.ContentTemplateContainer.FindControl("tbBirthDate") as TextBox;

        var newlyCreatedUserProfile = Profile.GetProfile(cuwRegister.UserName);

        if (firstNameTextBox != null)
        {
            newlyCreatedUserProfile.FirstName = firstNameTextBox.Text;
        }
        if (lastNameTextBox != null)
        {
            newlyCreatedUserProfile.LastName = lastNameTextBox.Text;
        }
        if (birthDateTextBox != null)
        {
            DateTime birthDate;
            if (DateTime.TryParse(birthDateTextBox.Text, out birthDate))
            {
                newlyCreatedUserProfile.BirthDate = birthDate;                
            }
        }
        newlyCreatedUserProfile.Save();
    }

    public void SearchClick(object sender, EventArgs e)
    {
        if (string.IsNullOrWhiteSpace(tbSearch.Text))
        {
            return;
        }

        var queryString = tbSearch.Text;
        tbSearch.Text = string.Empty;
        Response.Redirect(string.Format("Search.aspx?Query={0}",queryString));
    }
}
