<%@ Page Title="Replies" Language="C#" MasterPageFile="~/NavbarMasterPage.master"
    AutoEventWireup="true" CodeFile="Replies.aspx.cs" Inherits="Replies" ValidateRequest="false" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Globalization" %>

<asp:Content ID="cntRepliesHead" ContentPlaceHolderID="HeadPlaceHolder" runat="Server">
    <link href="Styles/mainpage-styles.css" rel="stylesheet" type="text/css" />
    <link href="Styles/repliespage-styles.css" rel="stylesheet" type="text/css" />
    <script src="Scripts/jquery-te-1.4.0.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
            var newPostDialog = $("#" + "<%= dNewReplyDialog.ClientID %>").dialog({
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
<asp:Content ID="cntRepliesBody" ContentPlaceHolderID="ContentPlaceHolder" runat="Server">
    <div id="dNewReplyDialog" title="New reply dialog" runat="server">
        <asp:LoginView ID="lvReplyDialogLoginView" runat="server">
            <LoggedInTemplate>
                <asp:TextBox ID="tbReplyText" runat="server" TextMode="MultiLine" Font-Size="Medium"
                    Rows="10" Columns="30" CssClass="form-control rich-text-editor">
                </asp:TextBox>
                <br />
                <asp:RequiredFieldValidator ID="rfvReplyText" runat="server" ValidationGroup="ReplyContentValidator"
                    ControlToValidate="tbReplyText" Display="Dynamic">
                    Reply text cannot be empty or whitespace.
                </asp:RequiredFieldValidator>
                <asp:Button ID="btnReply" runat="server" ValidationGroup="ReplyContentValidator"
                    CssClass="btn btn-primary pull-right" Text="Post" OnClick="CreateNewReplyIntoDbButtonClick" />
            </LoggedInTemplate>
        </asp:LoginView>
    </div>
    <div id="dPostDescriptionContainer" class="container-fluid">
        <asp:Label Font-Size="XX-Large" Font-Bold="True" ID="lblPostName" runat="server">Post title</asp:Label>
    </div>
    <asp:LoginView ID="lvButtonNewPost" runat="server">
        <LoggedInTemplate>
            <div id="dReplyContainer" class="container-fluid">
                <a onclick="$('#'+ '<%= dNewReplyDialog.ClientID %>').dialog('open');" class="btn btn-primary pull-right">
                    <span class="glyphicon glyphicon-plus" style="margin-right: 10px"></span>New reply
                </a>
            </div>
        </LoggedInTemplate>
        <AnonymousTemplate>
            <div class="container-fluid">
                <asp:Label ID="lblSignInPlaceholder" CssClass="pull-right" runat="server">
                    You need to sign in to add a new reply.  
                </asp:Label>
            </div>
        </AnonymousTemplate>
    </asp:LoginView>
    <div id="dRepliesContainer" class="container-fluid">
        <asp:GridView ID="gvRepliesList" runat="server" AllowPaging="true" PageSize="15"
            AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="SqlDataSource1" ShowHeader="False"
            CssClass="table-bordered categories-width-fill margin-top-1em " BorderColor="Black"
            OnRowUpdating="RepliesOnRowUpdating">
            <Columns>
                <asp:TemplateField ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Top"
                    ItemStyle-Width="1px" ItemStyle-BackColor="whitesmoke">
                    <ItemTemplate>
                        <div class="container-fluid padding-top10 padding-bottom5">
                            <asp:Image ID="imgProfile" runat="server" ImageUrl='<%# UserInteraction.MakeProfileUrl((Guid)((DataRowView)Container.DataItem)["CreateBy"]) %>'
                                Width="100px" Height="100px" />
                        </div>
                        <div class="container-fluid padding-top5 padding-bottom10">
                            <asp:HyperLink ID="hlCreateBy" runat="server" Font-Size="Medium" Font-Bold="True"
                                NavigateUrl='<%# string.Format("Profile.aspx?User={0}",((DataRowView)Container.DataItem)["CreateBy"]) %>'><%# ((DataRowView)Container.DataItem)["CreateByUsername"]%></asp:HyperLink>
                            <br />
                            <asp:Label ID="lblUserRole" runat="server" Font-Size="Small"><%# Roles.GetRolesForUser(((DataRowView)Container.DataItem)["CreateByUsername"].ToString())[0]%></asp:Label>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField ItemStyle-HorizontalAlign="Left" ItemStyle-BackColor="whitesmoke"
                    ItemStyle-VerticalAlign="Top">
                    <ItemTemplate>
                        <div class="container-fluid background-whiteblue padding-top5 padding-bottom5">
                            <div class="pull-left">
                                <asp:Label ID="lblRe" runat="server" Font-Size="Large" Font-Bold="True">
                                    <%# Convert.ToBoolean(((DataRowView)Container.DataItem)["IsReply"]) ? string.Format("Re: {0}", ((DataRowView)Container.DataItem)["Title"]) : ((DataRowView)Container.DataItem)["Title"]%>
                                </asp:Label>
                                <br />
                                on
                                <asp:Label ID="lblCreateDate" Font-Italic="True" runat="server"><%# ((DateTime)((DataRowView)Container.DataItem)["CreateDate"]).ToString("dd MMMM yyyy HH:mm", CultureInfo.CreateSpecificCulture("en-us"))%></asp:Label>
                            </div>
                            <div class="pull-right">
                                <asp:Label ID="lblRowNum" runat="server"> #<%# Container.DataItemIndex %> </asp:Label>
                            </div>
                        </div>
                        <div class="container-fluid padding-bottom15 padding-top30">
                            <div class="container-fluid">
                                <asp:Label ID="lblReplyText" runat="server" Font-Size="Medium">
                                    <%# ((DataRowView)Container.DataItem)["Text"]%>
                                </asp:Label>
                            </div>
                        </div>
                        <div class="container-fluid padding-top30 padding-bottom10">
                            <asp:LoginView ID="lvEditModAdminValidatorLogin" runat="server">
                                <RoleGroups>
                                    <asp:RoleGroup Roles="moderator,administrator">
                                        <ContentTemplate>
                                            <asp:LinkButton ID="btnEditReply" runat="server" CausesValidation="False" CommandName="Edit"
                                                Text="Edit" CssClass="btn btn-xs btn-link color-black scale-hover" ToolTip="Edit">
                                                <span class="glyphicon glyphicon-pencil"></span>
                                            </asp:LinkButton>
                                        </ContentTemplate>
                                    </asp:RoleGroup>
                                </RoleGroups>
                            </asp:LoginView>
                            <asp:LoginView ID="lvDeleteModAdminValidatorLogin" Visible='<%# Container.DataItemIndex != 0 %>'
                                runat="server">
                                <RoleGroups>
                                    <asp:RoleGroup Roles="moderator,administrator">
                                        <ContentTemplate>
                                            <asp:LinkButton ID="btnDeleteReply" runat="server" CausesValidation="False" CommandName="Delete"
                                                Text="Delete" CssClass="btn btn-xs btn-link color-black scale-hover" ToolTip="Delete"
                                                OnClientClick="return confirm('Are you sure you want to delete this reply?');">
                                                <span class="glyphicon glyphicon-trash"></span>
                                            </asp:LinkButton>
                                        </ContentTemplate>
                                    </asp:RoleGroup>
                                </RoleGroups>
                            </asp:LoginView>
                            <asp:LoginView ID="lvEditUserValidatorLogin" Visible='<%# UserInteraction.CheckIfIdIsLoggedUser((Guid)((DataRowView)Container.DataItem)["CreateBy"]) %>'
                                runat="server">
                                <RoleGroups>
                                    <asp:RoleGroup Roles="user">
                                        <ContentTemplate>
                                            <asp:LinkButton ID="btnEditReply" runat="server" CausesValidation="False" CommandName="Edit"
                                                Text="Edit" CssClass="btn btn-xs btn-link color-black scale-hover" ToolTip="Edit">
                                                <span class="glyphicon glyphicon-pencil"></span>
                                            </asp:LinkButton>
                                        </ContentTemplate>
                                    </asp:RoleGroup>
                                </RoleGroups>
                            </asp:LoginView>
                            <asp:LoginView ID="lvDeleteUserValidatorLogin" Visible='<%# UserInteraction.CheckIfIdIsLoggedUser((Guid)((DataRowView)Container.DataItem)["CreateBy"]) && Container.DataItemIndex != 0 %>'
                                runat="server">
                                <RoleGroups>
                                    <asp:RoleGroup Roles="user">
                                        <ContentTemplate>
                                            <asp:LinkButton ID="btnDeleteReply" runat="server" CausesValidation="False" CommandName="Delete"
                                                Text="Delete" CssClass="btn btn-xs btn-link color-black scale-hover" ToolTip="Delete"
                                                OnClientClick="return confirm('Are you sure you want to delete this reply?');">
                                                <span class="glyphicon glyphicon-trash"></span>
                                            </asp:LinkButton>
                                        </ContentTemplate>
                                    </asp:RoleGroup>
                                </RoleGroups>
                            </asp:LoginView>
                            <div class="pull-right" runat="server" visible='<%# ((DateTime)((DataRowView)Container.DataItem)["LastUpdateDate"]).CompareTo((DateTime)((DataRowView)Container.DataItem)["CreateDate"]) != 0 %>'>
                                <asp:Label ID="lblLastUpdatedByDate" runat="server" Font-Size="0.75em">Last updated
                                    by
                                    <asp:HyperLink ID="hlLastUpdateBy" NavigateUrl='<%# string.Format("Profile.aspx?User={0}", ((DataRowView)Container.DataItem)["LastUpdateBy"]) %>'
                                        runat="server"><%# ((DataRowView)Container.DataItem)["LastUpdateByUsername"]%></asp:HyperLink>
                                    on
                                    <asp:Label ID="lblLastUpdateDate" runat="server" Font-Italic="True">
                                        <%# ((DateTime)((DataRowView)Container.DataItem)["LastUpdateDate"]).ToString("dd MMMM yyyy HH:mm", CultureInfo.CreateSpecificCulture("en-us"))%>
                                    </asp:Label>
                                </asp:Label>
                            </div>
                        </div>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <div class="container-fluid background-whiteblue padding-top5 padding-bottom5">
                            <div class="pull-left">
                                <asp:Label ID="lblRe" runat="server" Font-Size="Large" Font-Bold="True">
                                    <%# Convert.ToBoolean(((DataRowView)Container.DataItem)["IsReply"]) ? string.Format("Re: {0}", ((DataRowView)Container.DataItem)["IsReply"]) : ((DataRowView)Container.DataItem)["IsReply"] %>
                                </asp:Label>
                                <br />
                                on
                                <asp:Label ID="lblCreateDate" Font-Italic="True" runat="server"><%# ((DateTime)((DataRowView)Container.DataItem)["CreateDate"]).ToString("dd MMMM yyyy HH:mm", CultureInfo.CreateSpecificCulture("en-us"))%></asp:Label>
                            </div>
                            <div class="pull-right">
                                <asp:Label ID="lblRowNum" runat="server"> #<%# Container.DataItemIndex %> </asp:Label>
                            </div>
                        </div>
                        <div class="container-fluid padding-bottom15 padding-top30">
                            <div class="container-fluid">
                                <asp:TextBox ID="tbEditText" runat="server" TextMode="MultiLine" Font-Size="Medium"
                                    Text='<%# Bind ("Text") %>' Rows="10" CssClass="form-control rich-text-editor">
                                </asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvEditText" runat="server" ControlToValidate="tbEditText"
                                    Display="Dynamic">
                                    Reply text cannot be empty or whitespace.
                                </asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="container-fluid padding-top30 padding-bottom10">
                            <asp:LoginView ID="lvUpdateCancelModAdminValidatorLogin" runat="server">
                                <RoleGroups>
                                    <asp:RoleGroup Roles="moderator,administrator">
                                        <ContentTemplate>
                                            <asp:LinkButton ID="btnUpdateReply" runat="server" CausesValidation="True" CommandName="Update"
                                                Text="Update" CssClass="btn btn-xs btn-link color-black scale-hover" ToolTip="Update">
                                                <span class="glyphicon glyphicon-ok"></span>
                                                <asp:LinkButton ID="btnCancelUpdateReply" runat="server" CausesValidation="False"
                                                    CommandName="Cancel" Text="Cancel" CssClass="btn btn-xs btn-link color-black scale-hover"
                                                    ToolTip="Cancel">
                                                    <span class="glyphicon glyphicon-remove"></span>
                                                </asp:LinkButton>
                                            </asp:LinkButton>
                                        </ContentTemplate>
                                    </asp:RoleGroup>
                                </RoleGroups>
                            </asp:LoginView>
                            <asp:LoginView ID="lvUpdateCancelUserValidatorLogin" Visible='<%# UserInteraction.CheckIfIdIsLoggedUser((Guid)((DataRowView)Container.DataItem)["CreateBy"]) %>'
                                runat="server">
                                <RoleGroups>
                                    <asp:RoleGroup Roles="user">
                                        <ContentTemplate>
                                            <asp:LinkButton ID="btnUpdateReply" runat="server" CausesValidation="True" CommandName="Update"
                                                Text="Update" CssClass="btn btn-xs btn-link color-black scale-hover" ToolTip="Update">
                                                <span class="glyphicon glyphicon-ok"></span>
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="btnCancelUpdateReply" runat="server" CausesValidation="False"
                                                CommandName="Cancel" Text="Cancel" CssClass="btn btn-xs btn-link color-black scale-hover"
                                                ToolTip="Cancel">
                                                <span class="glyphicon glyphicon-remove"></span>
                                            </asp:LinkButton>
                                        </ContentTemplate>
                                    </asp:RoleGroup>
                                </RoleGroups>
                            </asp:LoginView>
                            <div class="pull-right" runat="server">
                                <asp:Label ID="lblLastUpdatedByDate" runat="server" Font-Size="0.75em" Visible='<%# ((DateTime)((DataRowView)Container.DataItem)["LastUpdateDate"]).CompareTo((DateTime)((DataRowView)Container.DataItem)["CreateDate"]) != 0 %>'>
                                    Last updated by
                                    <asp:HyperLink ID="hlLastUpdateBy" NavigateUrl='<%# string.Format("Profile.aspx?User={0}", ((DataRowView)Container.DataItem)["LastUpdateBy"]) %>'
                                        runat="server"><%# ((DataRowView)Container.DataItem)["LastUpdateByUsername"] %></asp:HyperLink>
                                    on
                                    <asp:Label ID="lblLastUpdateDate" runat="server" Font-Italic="True">
                                        <%# ((DateTime)((DataRowView)Container.DataItem)["LastUpdateDate"]).ToString("dd MMMM yyyy HH:mm", CultureInfo.CreateSpecificCulture("en-us")) %>
                                    </asp:Label>
                                </asp:Label>
                            </div>
                        </div>
                    </EditItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
            ProviderName="System.Data.SqlClient" SelectCommand="
            SELECT ROW_NUMBER() OVER (ORDER BY Replies.CreateDate ASC) as RowNumber, Replies.*, CreateByUser.UserName as CreateByUsername, LastUpdateByUser.UserName as LastUpdateByUsername, Posts.Title
            FROM Replies 
            INNER JOIN aspnet_Users as CreateByUser ON CreateByUser.UserId = Replies.CreateBy
            INNER JOIN aspnet_Users as LastUpdateByUser ON LastUpdateByUser.UserId = Replies.LastUpdateBy
            INNER JOIN Posts ON Posts.ID = Replies.PostID
            WHERE PostID = @PostID" UpdateCommand="UPDATE Replies SET Text = @Text , LastUpdateBy = @LastUpdateBy , LastUpdateDate = @LastUpdateDate WHERE ID = @ID;"
            DeleteCommand="DELETE FROM Replies WHERE ID = @ID;">
            <SelectParameters>
                <asp:QueryStringParameter Name="PostID" QueryStringField="Post" Type="String" />
            </SelectParameters>
            <UpdateParameters>
                <customAsp:LoginParameter Name="LastUpdateBy" />
                <customAsp:ServerDateParameter Name="LastUpdateDate" />
            </UpdateParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>
