<%@ Page Title="" Language="C#" MasterPageFile="~/NavbarMasterPage.master" AutoEventWireup="true"
    CodeFile="Posts.aspx.cs" Inherits="Posts" ValidateRequest="false" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Globalization" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadPlaceHolder" runat="Server">
    <link href="Styles/mainpage-styles.css" rel="stylesheet" type="text/css" />
    <link href="Styles/repliespage-styles.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            var newPostDialog = $("#"+ "<%= dPostDialog.ClientID %>").dialog({
                autoOpen: false,
                modal: true,
                draggable: true,
                height: "auto",
                width: "auto",
                resizable: false
            });
            newPostDialog.parent().appendTo($("form:first"));
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder" runat="Server">
    <div id="dPostDialog" title="New post dialog" runat="server">
        <asp:LoginView ID="lvPostDialogLoginView" runat="server">
            <LoggedInTemplate>
                <asp:Label ID="lblPostTitle" Font-Size="x-large" runat="server">Topic title</asp:Label>
                <br/>
                <asp:TextBox ID="tbPostTitle" runat="server" CssClass="form-control margin-top-1em" Font-Size="X-Large"
                    Columns="40"></asp:TextBox>
                <br/>
                <br/>
                <asp:Label ID="lblPostText" Font-Size="medium" runat="server">Topic content</asp:Label>
                <asp:TextBox ID="tbPostText" runat="server" TextMode="multiline" CssClass="form-control margin-top-1em rich-text-editor"
                    Columns="40" Rows="10" Font-Size="Medium"/>
                <br />
                <div class="pull-left">
                    <asp:RequiredFieldValidator ID="rfvPostTitle" runat="server" ControlToValidate="tbPostTitle"
                        Display="Dynamic" ValidationGroup="PostValidationGroup">
                        Topic title cannot be empty or whitespace. <br/>
                    </asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revPostTitle" ControlToValidate="tbPostTitle"
                        ValidationExpression="^[\s\S]{0,100}$" runat="server" Display="Dynamic" ValidationGroup="PostValidationGroup">
                        Topic title must have maximum 100 characters. <br/>
                    </asp:RegularExpressionValidator>
                    <asp:RequiredFieldValidator ID="rfvPostText" runat="server" ControlToValidate="tbPostText"
                        Display="Dynamic" ValidationGroup="PostValidationGroup">
                        Topic text cannot be empty or whitespace.
                    </asp:RequiredFieldValidator>
                </div>
                <div class="pull-right" style="margin-left: 15px;">
                    <asp:Button ID="btnPost" runat="server" ValidationGroup="PostValidationGroup" CssClass="btn btn-primary" Text="Post" OnClick="CreateNewPostIntoDbButtonClick" />
                </div>
            </LoggedInTemplate>
        </asp:LoginView>
    </div>
    <div id="dSubjectDescriptionContainer" class="container-fluid">
        <asp:Label id="lblSubjectName" Font-Size="XX-Large" Font-Bold="True" runat="server">Category name</asp:Label>
        <br/>
        <asp:Label id="lblSubjectDescription" Font-Size="Large" runat="server">Category description</asp:Label>
        <br/>
        <br/>
    </div>
    <table class="pull-left margin-top-1em" >
        <tr>
            <td style="vertical-align: middle">
                <div class="container-fluid">
                    <asp:Label ID="lblSortBy" Font-Bold="True" runat="server">
                        Sort by
                    </asp:Label>
                </div>
            </td>
            <td style="vertical-align: middle">
                <asp:DropDownList ID="ddlOrderBy" runat="server" CssClass="form-control width-auto"
                    AutoPostBack="true" EnableViewState="true" OnSelectedIndexChanged="SortGridView">
                    <Items>
                        <asp:ListItem Selected="True" Value="CreateDate"> Create date </asp:ListItem>
                        <asp:ListItem Value="LastUpdateDate"> Last update date </asp:ListItem>
                        <asp:ListItem Value="NumberOfReplies"> Number of replies </asp:ListItem>
                        <asp:ListItem Value="Title"> Title </asp:ListItem>
                    </Items>
                </asp:DropDownList>
            </td>
            <td style="vertical-align: middle">
                <div class="container-fluid">
                    <asp:Label ID="lblOrder" Font-Bold="True" runat="server">
                        order
                    </asp:Label>
                </div>
            </td>
            <td style="vertical-align: middle">
                <asp:DropDownList ID="ddlOrderDirection" runat="server" CssClass="form-control width-auto"
                    AutoPostBack="true" EnableViewState="true" OnSelectedIndexChanged="SortGridView">
                    <Items>
                        <asp:ListItem Selected="True" Value="Descending"> Descending </asp:ListItem>
                        <asp:ListItem Value="Ascending"> Ascending </asp:ListItem>
                    </Items>
                </asp:DropDownList>
            </td>
        </tr>
    </table>
    <asp:LoginView ID="lvButtonNewPost" runat="server">
        <LoggedInTemplate>
            <div id="dNewPostContainer" class="container-fluid">
                <a onclick="$('#' + '<%= dPostDialog.ClientID %>').dialog('open');" class="btn btn-primary pull-right margin-top-1em">
                    <span class="glyphicon glyphicon-plus" style="margin-right: 10px"></span>Start new post </a>
            </div>
        </LoggedInTemplate>
        <AnonymousTemplate>
            <div class="container-fluid">
                <asp:Label ID="lblSignInPlaceholder" CssClass="pull-right margin-top-1em" runat="server">
                    You need to sign in to add a new post.
                </asp:Label>
            </div>
        </AnonymousTemplate>
    </asp:LoginView>
    <div id="dPostsContainer" runat="server" class="container-fluid">
        <asp:GridView ID="gvPostsList" runat="server" AllowPaging="true" PageSize="20" AutoGenerateColumns="False"
            DataKeyNames="ID" DataSourceID="SqlDataSource1" ShowHeader="True" HeaderStyle-BackColor="#344E87" CssClass="table-bordered categories-width-fill margin-top-1em background-whitesmoke">
            <Columns>
                <asp:TemplateField HeaderText="Post" HeaderStyle-CssClass="text-align-left" ItemStyle-HorizontalAlign="Left">
                    <HeaderTemplate>
                        <div class="container-fluid padding-bottom5 padding-top5">
                            <asp:Label ID="lblHeaderSubject" runat="server" Font-Size="medium" ForeColor="White">
                                Post
                            </asp:Label>
                        </div>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="container-fluid padding-top10">
                            <asp:HyperLink ID="lblPostTitle" Font-Size="large" Font-Bold="True" runat="server" NavigateUrl=<%# string.Format("Replies.aspx?Post={0}", ((DataRowView)Container.DataItem)["ID"]) %>> <%# Server.HtmlEncode((string)((DataRowView)Container.DataItem)["Title"]) %> </asp:HyperLink>
                            <hr class="post-hr" />
                            <div class="container-fluid pull-right padding-bottom10">
                                <asp:Label ID="lblCreateByDate" runat="server" Font-Size="0.75em">
                                    Added by 
                                    <asp:HyperLink ID="hlCreateBy" NavigateUrl=<%# string.Format("Profile.aspx?User={0}", ((DataRowView)Container.DataItem)["CreateBy"] ) %> runat="server"><%# ((DataRowView)Container.DataItem)["CreateByUsername"] %></asp:HyperLink> 
                                    on
                                    <asp:Label ID="lblCreateDate" runat="server" Font-Italic="True">
                                        <%# ((DateTime)((DataRowView)Container.DataItem)["CreateDate"]).ToString("dd MMMM yyyy HH:mm", CultureInfo.CreateSpecificCulture("en-us"))%>
                                    </asp:Label>
                                </asp:Label>
                                <br/>
                                <asp:Label ID="lblLastUpdateByDate" runat="server" Font-Size="0.75em">
                                    Last updated by 
                                    <asp:HyperLink ID="hlLastUpdatbeBy" NavigateUrl=<%# string.Format("Profile.aspx?User={0}", ((DataRowView)Container.DataItem)["LastUpdateBy"]) %> runat="server"><%# ((DataRowView)Container.DataItem)["LastUpdateByUsername"]%></asp:HyperLink> 
                                    on
                                    <asp:Label ID="lblLastUpdateDate" runat="server" Font-Italic="True">
                                        <%# ((DateTime)((DataRowView)Container.DataItem)["LastUpdateDate"]).ToString("dd MMMM yyyy HH:mm", CultureInfo.CreateSpecificCulture("en-us"))%>
                                    </asp:Label>
                                </asp:Label>
                            </div>
                            <div class="padding-top15">
                                <asp:LoginView ID="lvAdminModeratorValidatorLogin" runat="server">
                                    <RoleGroups>
                                        <asp:RoleGroup Roles="administrator,moderator">
                                            <ContentTemplate>
                                                <asp:LinkButton ID="lbtnEdit" runat="server" CausesValidation="False" CommandName="Edit"
                                                    Text="Edit" CssClass="btn btn-xs btn-link color-black scale-hover" ToolTip="Edit">
                                                <span class="glyphicon glyphicon-pencil"></span>
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="lbtnDelete" runat="server" CausesValidation="False" CommandName="Delete"
                                                    Text="Delete" CssClass="btn btn-sm btn-link color-black scale-hover" ToolTip="Delete"
                                                    OnClientClick="return confirm('Are you sure you want to delete this post?');">
                                                <span class="glyphicon glyphicon-trash"></span> 
                                                </asp:LinkButton>
                                            </ContentTemplate>
                                        </asp:RoleGroup>
                                    </RoleGroups>
                                </asp:LoginView>
                                <asp:LoginView ID="lvUserValidatorLogin" runat="server" Visible='<%# UserInteraction.CheckIfIdIsLoggedUser((Guid)((DataRowView)Container.DataItem)["CreateBy"]) %>'>
                                    <RoleGroups>
                                        <asp:RoleGroup Roles="user">
                                            <ContentTemplate>
                                                <asp:LinkButton ID="lbtnEdit" runat="server" CausesValidation="False" CommandName="Edit"
                                                    Text="Edit" CssClass="btn btn-xs btn-link color-black scale-hover" ToolTip="Edit">
                                                <span class="glyphicon glyphicon-pencil"></span>
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="lbtnDelete" runat="server" CausesValidation="False" CommandName="Delete"
                                                    Text="Delete" CssClass="btn btn-sm btn-link color-black scale-hover" ToolTip="Delete"
                                                    OnClientClick="return confirm('Are you sure you want to delete this post?');">
                                                <span class="glyphicon glyphicon-trash"></span> 
                                                </asp:LinkButton>
                                            </ContentTemplate>
                                        </asp:RoleGroup>
                                    </RoleGroups>
                                </asp:LoginView>
                            </div>
                        </div>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <div class="container-fluid">
                            <asp:TextBox ID="tbEditName" runat="server" Text='<%# Bind ("Title") %>' CssClass="form-control margin-top-1em"
                                MaxLength="100" Font-Size="Large"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvPostTitle" runat="server" ControlToValidate="tbEditName"
                                Display="Dynamic">
                                Topic title cannot be empty or whitespace. <br/>
                            </asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revPostTitle" ControlToValidate="tbEditName"
                                ValidationExpression="^[\s\S]{0,100}$" runat="server" Display="Dynamic">
                                Topic title must have maximum 100 characters. <br/>
                            </asp:RegularExpressionValidator>
                            <hr class="post-hr" />
                            <div class="container-fluid pull-right padding-bottom10">
                                <asp:Label ID="lblCreateByDate" runat="server" Font-Size="0.75em">
                                    Added by 
                                    <asp:HyperLink ID="hlCreateBy" NavigateUrl=<%# string.Format("Profile.aspx?User={0}", ((DataRowView)Container.DataItem)["CreateBy"] ) %> runat="server"><%# ((DataRowView)Container.DataItem)["CreateByUsername"] %></asp:HyperLink> 
                                    on
                                    <asp:Label ID="lblCreateDate" runat="server" Font-Italic="True">
                                        <%# ((DateTime)((DataRowView)Container.DataItem)["CreateDate"]).ToString("dd MMMM yyyy HH:mm", CultureInfo.CreateSpecificCulture("en-us"))%>
                                    </asp:Label>
                                </asp:Label>
                                <br/>
                                <asp:Label ID="lblLastUpdateByDate" runat="server" Font-Size="0.75em">
                                    Last updated by 
                                    <asp:HyperLink ID="hlLastUpdatbeBy" NavigateUrl=<%# string.Format("Profile.aspx?User={0}", ((DataRowView)Container.DataItem)["LastUpdateBy"]) %> runat="server"><%# ((DataRowView)Container.DataItem)["LastUpdateByUsername"]%></asp:HyperLink> 
                                    on
                                    <asp:Label ID="lblLastUpdateDate" runat="server" Font-Italic="True">
                                        <%# ((DateTime)((DataRowView)Container.DataItem)["LastUpdateDate"]).ToString("dd MMMM yyyy HH:mm", CultureInfo.CreateSpecificCulture("en-us"))%>
                                    </asp:Label>
                                </asp:Label>
                            </div>
                            <div class="padding-top15">
                                <asp:LoginView ID="lvModeratorValidatorLogin" runat="server">
                                    <RoleGroups>
                                        <asp:RoleGroup Roles="administrator,moderator">
                                            <ContentTemplate>
                                                <asp:LinkButton ID="lbtnUpdate" runat="server" CausesValidation="True" CommandName="Update"
                                                    Text="Update" CssClass="btn btn-sm btn-link color-black scale-hover" ToolTip="Update">
                                                <span class="glyphicon glyphicon-ok"></span>
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="lbtnCancel" runat="server" CausesValidation="False" CommandName="Cancel"
                                                    Text="Cancel" CssClass="btn btn-sm btn-link color-black scale-hover" ToolTip="Cancel">
                                                <span class="glyphicon glyphicon-remove"></span>
                                                </asp:LinkButton>
                                            </ContentTemplate>
                                        </asp:RoleGroup>
                                    </RoleGroups>
                                </asp:LoginView>
                                <asp:LoginView ID="lvUserValidatorLogin" runat="server" Visible='<%# UserInteraction.CheckIfIdIsLoggedUser((Guid)((DataRowView)Container.DataItem)["LastUpdateBy"]) %>'>
                                    <RoleGroups>
                                        <asp:RoleGroup Roles="user">
                                            <ContentTemplate>
                                                <asp:LinkButton ID="lbtnUpdate" runat="server" CausesValidation="True" CommandName="Update"
                                                    Text="Update" CssClass="btn btn-sm btn-link color-black scale-hover" ToolTip="Update">
                                                <span class="glyphicon glyphicon-ok"></span>
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="lbtnCancel" runat="server" CausesValidation="False" CommandName="Cancel"
                                                    Text="Cancel" CssClass="btn btn-sm btn-link color-black scale-hover" ToolTip="Cancel">
                                                <span class="glyphicon glyphicon-remove"></span>
                                                </asp:LinkButton>
                                            </ContentTemplate>
                                        </asp:RoleGroup>
                                    </RoleGroups>
                                </asp:LoginView>
                            </div>
                        </div>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="RepliesCount" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="text-align-center" ItemStyle-Width="1px"
                    ItemStyle-Wrap="False">
                    <HeaderTemplate>
                        <div class="container-fluid padding-bottom5 padding-top5">
                            <asp:Label ID="lblHeaderSubject" runat="server" Font-Size="medium" ForeColor="White">
                                Replies
                            </asp:Label>
                        </div>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="container-fluid">
                            <div class="container-fluid">
                                <asp:Label ID="lblNumReplies" Font-Size="medium" runat="server"><%# ((DataRowView)Container.DataItem)["NumberOfReplies"] + @" replies"%></asp:Label>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
            ProviderName="System.Data.SqlClient" SelectCommand="
            
            SELECT PostID, COUNT(ID) AS NumReplies
            INTO #RepliesCount
            FROM Replies
            GROUP BY PostID

            SELECT Posts.ID, Posts.CreateBy, Posts.CreateDate,
                   CreateByUser.UserName as CreateByUsername,
                   LastUpdateByUser.UserName as LastUpdateByUsername,
                   Posts.LastUpdateBy, Posts.LastUpdateDate, Posts.Title, ISNULL(RepliesCount.NumReplies, 0) as NumberOfReplies
            FROM Posts
            INNER JOIN aspnet_Users AS CreateByUser ON CreateByUser.UserId = Posts.CreateBy
            INNER JOIN aspnet_Users AS LastUpdateByUser ON LastUpdateByUser.UserId = Posts.LastUpdateBy
            LEFT OUTER JOIN #RepliesCount AS RepliesCount ON RepliesCount.PostID = Posts.ID
            WHERE SubjectID = @SubjectID
            ORDER BY Posts.CreateDate DESC;" UpdateCommand="UPDATE Posts SET Title = @Title , LastUpdateBy = @LastUpdateBy , LastUpdateDate = @LastUpdateDate WHERE ID = @ID;"
            DeleteCommand="DELETE FROM Replies WHERE PostID = @ID;
                           DELETE FROM Posts WHERE ID = @ID;">
            <SelectParameters>
                <asp:QueryStringParameter Name="SubjectID" QueryStringField="Subject" Type="String" />
            </SelectParameters>
            <UpdateParameters>
                <customAsp:LoginParameter Name="LastUpdateBy" />
                <customAsp:ServerDateParameter Name="LastUpdateDate" />
            </UpdateParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>
