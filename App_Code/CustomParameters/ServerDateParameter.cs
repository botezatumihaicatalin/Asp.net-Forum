using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CustomParameters
{
    public class ServerDateParameter : Parameter
    {
        public ServerDateParameter()
        {
        }

        public ServerDateParameter(string name) : base(name)
        {
        }

        protected override object Evaluate(HttpContext context, Control control)
        {
            return DateTime.Now;
        }
    }
}