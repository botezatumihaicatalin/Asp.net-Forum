using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CustomParameters
{
    public class LoginParameter : Parameter
    {
        public LoginParameter()
        {
        }

        public LoginParameter(string name)
            : base(name)
        {
        }

        protected override object Evaluate(HttpContext context, Control control)
        {
            var membership = Membership.GetUser(context.User.Identity.Name);
            if (membership == null)
            {
                return null;
            }
            return membership.ProviderUserKey;
        }
    }
}

