<%@ Page Title="" Language="C#" MasterPageFile="~/NavbarMasterPage.master" AutoEventWireup="true"
    CodeFile="Profile.aspx.cs" Inherits="UserProfile" UICulture="en" Culture="en-us" %>

<asp:Content ID="cntProfileHead" ContentPlaceHolderID="HeadPlaceHolder" runat="Server">
    <link href="Styles/mainpage-styles.css" rel="stylesheet" type="text/css" />
    <link href="Styles/repliespage-styles.css" rel="stylesheet" type="text/css" />
    <link href="Styles/subjectspage-styles.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            $("#" + "<%= fuUserProfileImage.ClientID %>").change(function (event) {
                var tmppath = URL.createObjectURL(event.target.files[0]);
                $("#" + "<%= imgUserProfileImageEdit.ClientID %>").fadeIn("fast").attr('src', tmppath);
            });
        });
    </script>
</asp:Content>
<asp:Content ID="cntProfileBody" ContentPlaceHolderID="ContentPlaceHolder" runat="Server">
    <asp:Panel ID="pnlShowProfile" CssClass="container-fluid" runat="server">
        <div class="panel panel-default">
            <div class="panel-heading">
                <asp:Label ID="lblUsernameShow" Font-Size="XX-Large" runat="server">
                </asp:Label>
            </div>
            <div class="panel-body">
                <div class="container-fluid" align="center">
                    <asp:Table ID="tbProfileShow" runat="server" Width="100%">
                        <asp:TableRow runat="server">
                            <asp:TableCell ID="cell1ProfileShow" runat="server" HorizontalAlign="Center" VerticalAlign="Top"
                                Width="1px" Wrap="False">
                                <div class="container-fluid padding-top10 padding-bottom10">
                                    <asp:Image ID="imgUserProfileImageShow" runat="server" Width="100px" Height="100px" />
                                </div>
                            </asp:TableCell>
                            <asp:TableCell ID="cell2ProfileShow" runat="server" HorizontalAlign="Left" VerticalAlign="Top">
                                <table class="table">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <asp:Label Font-Size="X-Large" ID="lblFirstNamePlaceholderShow" runat="server">
                                            First name:
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label Font-Size="X-Large" ID="lblFirstNameShow" runat="server">
                                                </asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label Font-Size="X-Large" ID="lblLastNamePlaceholderShow" runat="server">
                                            Last name:
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label Font-Size="X-Large" ID="lblLastNameShow" runat="server">
                                                </asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label Font-Size="X-Large" ID="lblEmailPlaceholderShow" runat="server">
                                             Email:
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:HyperLink Font-Size="X-Large" ID="hlEmailShow" runat="server">
                                                </asp:HyperLink>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label Font-Size="X-Large" ID="lblBirthDatePlaceholderShow" runat="server">
                                             Date of Birth:
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label Font-Size="X-Large" ID="lblBirthDateShow" runat="server">
                                                </asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label Font-Size="X-Large" ID="lblAgePlaceholderShow" runat="server">
                                             Age:
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label Font-Size="X-Large" ID="lblAgeShow" runat="server">
                                                </asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label Font-Size="X-Large" ID="lblRolePlaceholderShow" runat="server">
                                             Role:
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label Font-Size="X-Large" ID="lblRoleShow" runat="server">
                                                </asp:Label>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </asp:TableCell>
                        </asp:TableRow>
                    </asp:Table>
                </div>
            </div>
            <div class="panel-footer">
                <asp:LoginView runat="server" ID="lvShowChecker">
                    <LoggedInTemplate>
                        <asp:Button ID="btnEdit" runat="server" Text="Edit profile" CssClass="btn btn-info"
                            CausesValidation="False" OnClick="EditButtonClick" />
                    </LoggedInTemplate>
                </asp:LoginView>
            </div>
        </div>
    </asp:Panel>
    <asp:Panel ID="pnlEditProfile" CssClass="container-fluid" runat="server">
        <div class="panel panel-default">
            <div class="panel-heading">
                <asp:Label ID="lblUsernameEdit" Font-Size="XX-Large" runat="server">
                </asp:Label>
            </div>
            <div class="panel-body">
                <div class="container-fluid" align="center">
                    <asp:Table ID="tblProfileEdit" runat="server" Width="100%">
                        <asp:TableRow runat="server">
                            <asp:TableCell runat="server" HorizontalAlign="Center" VerticalAlign="Top" Width="1px"
                                Wrap="True">
                                <div class="container-fluid">
                                    <div class="padding-top10 padding-bottom5">
                                        <asp:Image ID="imgUserProfileImageEdit" runat="server" Width="100px" Height="100px" />
                                    </div>
                                    <div class="padding-top5 padding-bottom10">
                                        <label for="<%= fuUserProfileImage.ClientID %>">
                                            <a class="btn btn-sm btn-default">Select profile image</a>
                                        </label>
                                        <asp:FileUpload ID="fuUserProfileImage" runat="server" CssClass="display-none"></asp:FileUpload>
                                    </div>
                                </div>
                                <asp:RegularExpressionValidator runat="server" Display="Dynamic" ValidationGroup="UserProfileEdit"
                                    ControlToValidate="fuUserProfileImage" ValidationExpression="(.*?)\.(jpg|jpeg|png|gif|JPG|JPEG|PNG|GIF)">
                                    Only file with jpg, jpe, png, gif format are allowed.
                                </asp:RegularExpressionValidator>
                            </asp:TableCell>
                            <asp:TableCell runat="server" HorizontalAlign="Left">
                                <table class="table">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <asp:Label Font-Size="X-Large" ID="lblFirstNamePlaceholderEdit" runat="server">
                                            First name:
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:TextBox Font-Size="X-Large" ID="tbFirstNameEdit" runat="server" CssClass="form-control">
                                                </asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label Font-Size="X-Large" ID="lblLastNamePlaceholderEdit" runat="server">
                                            Last name:
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:TextBox Font-Size="X-Large" ID="tbLastNameEdit" runat="server" CssClass="form-control">
                                                </asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label Font-Size="X-Large" ID="lblEmailPlaceholderEdit" runat="server">
                                             Email:
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:TextBox Font-Size="X-Large" ID="tbEmailEdit" runat="server" CssClass="form-control">
                                                </asp:TextBox>
                                                <asp:RequiredFieldValidator ID="rfvEmailEdit" runat="server" ControlToValidate="tbEmailEdit"
                                                    Display="Dynamic" ValidationGroup="UserProfileEdit">
                                                    Email cannot be empty or whitespace.
                                                </asp:RequiredFieldValidator>
                                                <asp:RegularExpressionValidator ID="revEmailEdit" runat="server" ValidationExpression="^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
                                                    ControlToValidate="tbEmailEdit" Display="Dynamic" ValidationGroup="UserProfileEdit">
                                                    Email must be like name@domain.com
                                                </asp:RegularExpressionValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label Font-Size="X-Large" ID="lblBirthDatePlaceholderEdit" runat="server">
                                             Date of Birth:
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="tbBirthDateEdit" runat="server" Font-Size="X-Large" CssClass="form-control datepicker date">
                                                </asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label Font-Size="X-Large" ID="lblAgePlaceholderEdit" runat="server">
                                             Age:
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label Font-Size="X-Large" ID="lblAgeEdit" runat="server">
                                                </asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label Font-Size="X-Large" ID="lblRolePlaceholderEdit" runat="server">
                                             Role:
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label Font-Size="X-Large" ID="lblRoleEdit" runat="server">
                                                </asp:Label>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </asp:TableCell>
                        </asp:TableRow>
                    </asp:Table>
                </div>
            </div>
            <div class="panel-footer">
                <asp:LoginView runat="server" ID="lvEditChecker">
                    <LoggedInTemplate>
                        <asp:Button ID="btnUpdate" runat="server" Text="Update" CssClass="btn btn-success"
                            CausesValidation="True" ValidationGroup="UserProfileEdit" OnClick="UpdateButtonClick" />
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-info" CausesValidation="False"
                            OnClick="CancelButtonClick" />
                    </LoggedInTemplate>
                </asp:LoginView>
            </div>
        </div>
    </asp:Panel>
</asp:Content>
