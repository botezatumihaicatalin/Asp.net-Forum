using System;
using System.Activities.Expressions;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CustomValidators
{
    /// <summary>
    /// Summary description for WhitespaceFieldValidator
    /// </summary>
    public class WhitespaceFieldValidator : BaseValidator
    {
        protected override bool EvaluateIsValid()
        {
            var foundControlGeneric = Parent.FindControl(ControlToValidate);
            if (foundControlGeneric == null)
            {
                throw new ArgumentException(string.Format("Cannot find control with id {0}",ControlToValidate));
            }

            if (!(foundControlGeneric is IEditableTextControl))
            {
                throw new ArgumentException(string.Format("Control with id {0} is not an editable text control", ControlToValidate));
            }

            var foundTextControl = foundControlGeneric as IEditableTextControl;

            return (foundTextControl.Text ?? "").Trim().Length != 0;
        }
    }
}