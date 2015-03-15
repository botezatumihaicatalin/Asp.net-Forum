using System;
using System.IO;
using System.Web;
using System.Web.Security;

public class UserInteraction
{
	private UserInteraction()
	{
	}

    public static bool CheckIfIdIsLoggedUser(Guid userId)
    {
        if (!HttpContext.Current.User.Identity.IsAuthenticated)
        {
            return false;
        }
        var membership = Membership.GetUser(HttpContext.Current.User.Identity.Name);
        if (membership == null)
        {
            return false;
        }
        if (membership.ProviderUserKey == null)
        {
            return false;
        }

        return userId.CompareTo((Guid)membership.ProviderUserKey) == 0;
    }

    public static bool CheckIfStringIsLoggedUser(string username)
    {
        if (!HttpContext.Current.User.Identity.IsAuthenticated)
        {
            return false;
        }
        return HttpContext.Current.User.Identity.Name.Equals(username);
    }

    public static string MakeProfileUrl(Guid userId)
    {
        var membership = Membership.GetUser(userId);
        if (membership == null)
        {
            return "";
        }
        var profileCommon = HttpContext.Current.Profile as ProfileCommon;
        if (profileCommon == null)
        {
            return "";
        }
        var userProfile = profileCommon.GetProfile(membership.UserName);

        if (string.IsNullOrWhiteSpace(userProfile.ProfilePicture))
        {
            return "https://lh5.googleusercontent.com/-b0-k99FZlyE/AAAAAAAAAAI/AAAAAAAAAAA/eu7opA4byxI/photo.jpg?sz=100";
        }

        if (!File.Exists(HttpContext.Current.Server.MapPath(userProfile.ProfilePicture)))
        {
            return "https://lh5.googleusercontent.com/-b0-k99FZlyE/AAAAAAAAAAI/AAAAAAAAAAA/eu7opA4byxI/photo.jpg?sz=100";
        }

        return userProfile.ProfilePicture;
    }
}