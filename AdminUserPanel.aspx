<%@ Page Title="" Language="C#" MasterPageFile="~/NavbarMasterPage.master" AutoEventWireup="true"
    CodeFile="AdminUserPanel.aspx.cs" Inherits="AdminUserPanel" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Globalization" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadPlaceHolder" runat="Server">
    <link href="Styles/repliespage-styles.css" rel="stylesheet" type="text/css" />
    <link href="Styles/subjectspage-styles.css" rel="stylesheet" type="text/css" />
    <link href="Styles/mainpage-styles.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder" runat="Server">
    <asp:LoginView ID="lvUserLoginValidator" runat="server">
        <RoleGroups>
            <asp:RoleGroup Roles="administrator">
                <ContentTemplate>
                    <div id="dUsersContainerPanel" runat="server" class="container-fluid">
                        <asp:GridView ID="gvUsersList" runat="server" AutoGenerateColumns="False" DataKeyNames="UserId"
                            DataSourceID="SqlUsersDataSource" ShowHeader="True" CssClass="custom-table table table-bordered categories-width-fill margin-top-1em background-whitesmoke">
                            <Columns>
                                <asp:TemplateField HeaderText="Profile image" ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" ItemStyle-Width="1px" ItemStyle-Wrap="False">
                                    <ItemTemplate>
                                        <div class="container-fluid">
                                            <asp:Image ID="imgUserProfileImage" runat="server" Width="40px" Height="40px" ImageUrl='<%# UserInteraction.MakeProfileUrl((Guid)((DataRowView)Container.DataItem)["UserId"]) %>'/>                                            
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Username" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="1px"
                                    ItemStyle-Wrap="False">
                                    <ItemTemplate>
                                        <div class="container-fluid">
                                            <asp:HyperLink ID="hlUsername" runat="server" Font-Size="Large" Font-Bold="True"
                                                NavigateUrl='<%# string.Format("Profile.aspx?User={0}", ((DataRowView)Container.DataItem)["UserId"]) %>'>
                                                    <%# ((DataRowView)Container.DataItem)["Username"] %>
                                            </asp:HyperLink>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Email" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="1px"
                                    ItemStyle-Wrap="false">
                                    <ItemTemplate>
                                        <div class="container-fluid">
                                            <asp:Label ID="lblEmail" runat="server" Font-Size="Large">
                                                    <%# ((DataRowView)Container.DataItem)["Email"] %>
                                            </asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <div class="container-fluid">
                                            <asp:TextBox ID="tbEditEmail" runat="server" Text='<%# Bind ("Email") %>' CssClass="form-control width-auto" Font-Size="Large">
                                            </asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="tbEditEmail"
                                                Display="Dynamic">Email cannot be empty or whitespace.</asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ValidationExpression="^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
                                                ControlToValidate="tbEditEmail" Display="Dynamic">Email must be like name@domain.om</asp:RegularExpressionValidator>
                                        </div>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Role" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="1px"
                                    ItemStyle-Wrap="false">
                                    <ItemTemplate>
                                        <div class="container-fluid">
                                            <asp:Label ID="lblRoleName" runat="server" Font-Size="Large">
                                                    <%# ((DataRowView)Container.DataItem)["RoleName"] %>
                                            </asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <div class="container-fluid">
                                            <asp:DropDownList ID="ddlRoles" runat="server" DataSourceID="SqlDataSourceDropDown"
                                                SelectedValue='<%# Bind("RoleId") %>' DataTextField='RoleName' DataValueField='RoleId' Font-Size="Large"
                                                CssClass="form-control width-auto">
                                            </asp:DropDownList>
                                        </div>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Register date" ItemStyle-HorizontalAlign="Center"
                                    ItemStyle-Width="1px" ItemStyle-Wrap="false">
                                    <ItemTemplate>
                                        <div class="container-fluid">
                                            <asp:Label ID="lblRegisterDate" runat="server" Font-Size="Large" Font-Italic="True">
                                                    <%# ((DateTime)((DataRowView)Container.DataItem)["CreateDate"]).ToString("dd MMMM yyyy HH:mm", CultureInfo.CreateSpecificCulture("en-us"))%>
                                            </asp:Label>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Last successfull login" ItemStyle-HorizontalAlign="Center"
                                    ItemStyle-Width="1px" ItemStyle-Wrap="false">
                                    <ItemTemplate>
                                        <div class="container-fluid">
                                            <asp:Label ID="lblLastLoginDate" runat="server" Font-Size="Large" Font-Italic="True">
                                                    <%# ((DateTime)((DataRowView)Container.DataItem)["LastLoginDate"]).ToString("dd MMMM yyyy HH:mm", CultureInfo.CreateSpecificCulture("en-us")) %>
                                            </asp:Label>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Edit/Update" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="1px"
                                    ItemStyle-Wrap="false">
                                    <ItemTemplate>
                                        <div class="container-fluid">
                                            <asp:LinkButton ID="lbtnEdit" runat="server" CommandName="Edit">
                                                Edit
                                            </asp:LinkButton>
                                        </div>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <div class="container-fluid">
                                            <asp:LinkButton ID="lbtnUpdate" runat="server" CommandName="Update">
                                                Update
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="lbtnCancel" runat="server" CommandName="Cancel">
                                                Cancel
                                            </asp:LinkButton>
                                        </div>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                    <asp:SqlDataSource ID="SqlUsersDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
                        ProviderName="System.Data.SqlClient" 
                        SelectCommand="
                          SELECT aspnet_Users.UserId, aspnet_Users.UserName, aspnet_Users.LoweredUserName, aspnet_Users.MobileAlias, aspnet_Users.IsAnonymous, aspnet_Users.LastActivityDate, aspnet_Membership.Password, 
                          aspnet_Membership.PasswordFormat, aspnet_Membership.PasswordSalt, aspnet_Membership.MobilePIN, aspnet_Membership.Email, aspnet_Membership.LoweredEmail, aspnet_Membership.PasswordQuestion, 
                          aspnet_Membership.PasswordAnswer, aspnet_Membership.IsApproved, aspnet_Membership.IsLockedOut, aspnet_Membership.CreateDate, aspnet_Membership.LastLoginDate, 
                          aspnet_Membership.LastPasswordChangedDate, aspnet_Membership.LastLockoutDate, aspnet_Membership.FailedPasswordAttemptCount, aspnet_Membership.FailedPasswordAttemptWindowStart, 
                          aspnet_Membership.FailedPasswordAnswerAttemptCount, aspnet_Membership.FailedPasswordAnswerAttemptWindowStart, aspnet_Membership.Comment, aspnet_Roles.RoleId, aspnet_Roles.RoleName
                          FROM aspnet_Users 
                          INNER JOIN aspnet_Membership ON aspnet_Membership.UserId = aspnet_Users.UserId
                          INNER JOIN aspnet_UsersInRoles ON aspnet_UsersInRoles.UserId = aspnet_Users.UserId
                          INNER JOIN aspnet_Roles ON aspnet_Roles.RoleId = aspnet_UsersInRoles.RoleId
                          ORDER BY aspnet_Roles.RoleName" 
                        UpdateCommand="UPDATE aspnet_UsersInRoles SET RoleId = @RoleId WHERE UserId = @UserId; 
                           UPDATE aspnet_Membership SET Email = @Email WHERE UserId = @UserId">
                    </asp:SqlDataSource>
                    <asp:SqlDataSource ID="SqlDataSourceDropDown" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
                        ProviderName="System.Data.SqlClient" SelectCommand="SELECT * FROM aspnet_Roles">
                    </asp:SqlDataSource>
                </ContentTemplate>
            </asp:RoleGroup>
        </RoleGroups>
    </asp:LoginView>
</asp:Content>
