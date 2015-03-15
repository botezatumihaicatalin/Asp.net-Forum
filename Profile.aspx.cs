using System;
using System.Globalization;
using System.IO;
using System.Security.Permissions;
using System.Security.Policy;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserProfile : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (Request["User"] == null)
            {
                Response.Redirect("MainPage.aspx");
                return;
            }
            Guid userId;
            if (!Guid.TryParse(Request["User"], out userId))
            {
                Response.Redirect("MainPage.aspx");
                return;
            }

            var membershipUser = Membership.GetUser(userId);
            if (membershipUser == null)
            {
                Response.Redirect("MainPage.aspx");
                return;
            }

            InitControlsVisibility(userId);
            PopulateShowProfileControls(membershipUser);
            PopulateEditProfileControls(membershipUser);
            
        }
    }

    private void InitControlsVisibility(Guid userId)
    {
        pnlEditProfile.Visible = false;
        pnlShowProfile.Visible = true;
        lvShowChecker.Visible = UserInteraction.CheckIfIdIsLoggedUser(userId);
        lvEditChecker.Visible = lvShowChecker.Visible;
    }

    private void PopulateShowProfileControls(MembershipUser membershipUser)
    {
        if (membershipUser == null)
        {
            return;
        }
        var userProfile = Profile.GetProfile(membershipUser.UserName);
        lblUsernameShow.Text = membershipUser.UserName;
        lblFirstNameShow.Text = userProfile.FirstName;
        lblLastNameShow.Text = userProfile.LastName;
        lblBirthDateShow.Text = userProfile.BirthDate.HasValue ? userProfile.BirthDate.Value.ToString("dd MMMMM yyyy", CultureInfo.CreateSpecificCulture("en-us")) : string.Empty;
        lblAgeShow.Text = userProfile.BirthDate.HasValue
            ? ((DateTime.Now - userProfile.BirthDate.Value).Days / 365).ToString()
            : string.Empty;
        hlEmailShow.Text = membershipUser.Email;
        hlEmailShow.NavigateUrl = string.Format("mailto:{0}", membershipUser.Email);
        lblRoleShow.Text = Roles.GetRolesForUser(membershipUser.UserName)[0];
        if (membershipUser.ProviderUserKey != null)
        {
            imgUserProfileImageShow.ImageUrl = UserInteraction.MakeProfileUrl((Guid)membershipUser.ProviderUserKey);            
        }
        imgUserProfileImageShow.ImageAlign = ImageAlign.Middle;

    }

    private void PopulateEditProfileControls(MembershipUser membershipUser)
    {
        if (membershipUser == null)
        {
            return;
        }
        var userProfile = Profile.GetProfile(membershipUser.UserName);
        lblUsernameEdit.Text = membershipUser.UserName;
        tbFirstNameEdit.Text = userProfile.FirstName;
        tbLastNameEdit.Text = userProfile.LastName;
        tbBirthDateEdit.Text = userProfile.BirthDate.HasValue ? userProfile.BirthDate.Value.ToString("dd MMMMM yyyy", CultureInfo.CreateSpecificCulture("en-us")) : string.Empty;
        lblAgeEdit.Text = userProfile.BirthDate.HasValue
            ? ((DateTime.Now - userProfile.BirthDate.Value).Days / 365).ToString()
            : string.Empty;
        tbEmailEdit.Text = membershipUser.Email;
        lblRoleEdit.Text = Roles.GetRolesForUser(membershipUser.UserName)[0];
        if (membershipUser.ProviderUserKey != null)
        {
            imgUserProfileImageEdit.ImageUrl = UserInteraction.MakeProfileUrl((Guid)membershipUser.ProviderUserKey);            
        }
        imgUserProfileImageEdit.ImageAlign = ImageAlign.Middle;
    }

    protected void EditButtonClick(object sender, EventArgs e)
    {
        pnlEditProfile.Visible = true;
        pnlShowProfile.Visible = false;
    }

    protected void CancelButtonClick(object sender, EventArgs e)
    {
        if (Request["User"] == null)
        {
            return;
        }
        Guid userId;
        if (!Guid.TryParse(Request["User"], out userId))
        {
            return;
        }
        var membershipUser = Membership.GetUser(userId);
        if (membershipUser == null)
        {
            return;
        }

        PopulateEditProfileControls(membershipUser);
        pnlEditProfile.Visible = false;
        pnlShowProfile.Visible = true;
    }

    protected void UpdateButtonClick(object sender, EventArgs e)
    {
        if (Request["User"] == null)
        {
            return;
        }
        Guid userId;
        if (!Guid.TryParse(Request["User"], out userId))
        {
            return;
        }
        var membershipUser = Membership.GetUser(userId);
        if (membershipUser == null)
        {
            return;
        }

        membershipUser.Email = tbEmailEdit.Text;
        var userProfile = Profile.GetProfile(membershipUser.UserName);
        
        userProfile.FirstName = tbFirstNameEdit.Text;
        userProfile.LastName = tbLastNameEdit.Text;
        
        if (!string.IsNullOrWhiteSpace(tbBirthDateEdit.Text))
        {
            userProfile.BirthDate = DateTime.Parse(tbBirthDateEdit.Text);            
        }

        if (fuUserProfileImage.HasFile)
        {
           
            var filePath = Server.MapPath("ProfileImages") + Path.DirectorySeparatorChar + membershipUser.ProviderUserKey;
            fuUserProfileImage.SaveAs(filePath);
            userProfile.ProfilePicture = "/ForumWebsite" + "/" + "ProfileImages" + "/" + membershipUser.ProviderUserKey;
        }

        userProfile.Save();

        PopulateEditProfileControls(membershipUser);
        PopulateShowProfileControls(membershipUser);
        pnlEditProfile.Visible = false;
        pnlShowProfile.Visible = true;
    }
}