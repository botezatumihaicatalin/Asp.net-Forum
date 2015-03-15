<%@ Page Title="" Language="C#" MasterPageFile="~/NavbarMasterPage.master" AutoEventWireup="true"
    CodeFile="Subjects.aspx.cs" Inherits="Subjects" ValidateRequest="false" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Globalization" %>

<asp:Content ID="cntSubjectsHead" ContentPlaceHolderID="HeadPlaceHolder" runat="Server">
    <link href="Styles/mainpage-styles.css" rel="stylesheet" type="text/css" />
    <link href="Styles/subjectspage-styles.css" rel="stylesheet" type="text/css" />
    <link href="Styles/repliespage-styles.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            var newSubjectDialog = $("#" + "<%= dNewSubjectDialog.ClientID %>").dialog({
                autoOpen: false,
                modal: true,
                draggable: true,
                height: "auto",
                width: "auto",
                resizable: false
            });
            newSubjectDialog.parent().appendTo($("form:first"));
        });
    </script>
</asp:Content>
<asp:Content ID="cntSubjectsBody" ContentPlaceHolderID="ContentPlaceHolder" runat="Server">
    <div id="dCateogryDescriptionContainer" class="container-fluid">
        <asp:Label Font-Size="XX-Large" Font-Bold="True" ID="lblCategoryName" runat="server">Category name</asp:Label>
        <br />
        <asp:Label Font-Size="Large" ID="lblCategoryDescription" runat="server">Category description</asp:Label>
        <br />
        <br />
    </div>
    
    <div id="dNewSubjectDialog" title="New subject dialog" runat="server">
        <asp:LoginView ID="lvSubjectDialogLoginView" runat="server">
            <RoleGroups>
                <asp:RoleGroup Roles="administrator">
                    <ContentTemplate>
                        <asp:Label ID="lblSubjectName" Font-Size="X-Large" runat="server">
                            Subject name
                        </asp:Label>
                        <br/>
                        <asp:TextBox ID="tbSubjectName" runat="server" CssClass="form-control margin-top-1em"
                            Font-Size="Large" ToolTip="Subject title" />
                        <br />
                        <asp:Label ID="lblSubjectDescription" Font-Size="Medium" runat="server">
                            Subject description
                        </asp:Label>
                        <br/>
                        <asp:TextBox ID="tbSubjectDescription" runat="server" TextMode="multiline" Font-Size="Medium"
                            CssClass="form-control margin-top-1em" Rows="10" Columns="50">
                        </asp:TextBox>
                        <br/>
                        <asp:RequiredFieldValidator ID="rfvEditName" runat="server" Display="Dynamic" ControlToValidate="tbSubjectName"
                            ValidationGroup="NewSubjectGroup">
                    Name cannot be empty or whitespace.<br />
                        </asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revEditName" ControlToValidate="tbSubjectName"
                            ValidationExpression="^[\s\S]{0,100}$" runat="server" Display="Dynamic" ValidationGroup="NewSubjectGroup">
                    Name must have maximum 100 characters.<br/>
                        </asp:RegularExpressionValidator>
                        <asp:RequiredFieldValidator ID="rfvEditDescription" runat="server" Display="Dynamic"
                            ControlToValidate="tbSubjectDescription" ValidationGroup="NewSubjectGroup">
                    Description cannot be empty or whitespace.<br />
                        </asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revEditDescription" ControlToValidate="tbSubjectDescription"
                            ValidationExpression="^[\s\S]{0,1000}$" runat="server" Display="Dynamic" ValidationGroup="NewSubjectGroup">
                    Description must have maximum 1000 characters.<br/>
                        </asp:RegularExpressionValidator>
                        <asp:Button ID="btnReply" runat="server" ValidationGroup="NewSubjectGroup" CssClass="btn btn-primary pull-right"
                            Text="New Subject" OnClick="CreateNewSubjectClick" />
                    </ContentTemplate>
                </asp:RoleGroup>
            </RoleGroups>
        </asp:LoginView>
    </div>
    <asp:LoginView runat="server" ID="lvNewSubject">
        <RoleGroups>
            <asp:RoleGroup Roles="administrator">
                <ContentTemplate>
                    <div class="container-fluid padding-bottom5 padding-top5">
                        <a class="btn btn-primary pull-right" onclick="$('#' + '<%= dNewSubjectDialog.ClientID %>').dialog('open')" >
                            <span class="glyphicon glyphicon-plus" style="margin-right: 10px"></span>Create new subject
                        </a>
                    </div>
                </ContentTemplate>
            </asp:RoleGroup>
        </RoleGroups>
    </asp:LoginView>

    <div id="dSubjectContainer" class="container-fluid">
        <asp:GridView ID="gvSubjectList" runat="server" AllowPaging="true" PageSize="10"
            AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="SqlDataSource1" ShowHeader="True"
            HeaderStyle-BackColor="#344E87" CssClass="table-bordered categories-width-fill margin-top-1em background-whitesmoke">
            <Columns>
                <asp:TemplateField HeaderText="Subject" ItemStyle-HorizontalAlign="Left" HeaderStyle-CssClass="text-align-left">
                    <HeaderTemplate>
                        <div class="container-fluid padding-bottom5 padding-top5">
                            <asp:Label ID="lblHeaderSubject" runat="server" Font-Size="large" ForeColor="White">
                                Subject
                            </asp:Label>
                        </div>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="container-fluid padding-top10">
                            <asp:HyperLink ID="hlSubjectName" Font-Size="x-large" Font-Bold="True" runat="server"
                                NavigateUrl='<%# string.Format("Posts.aspx?Subject={0}", ((DataRowView)Container.DataItem)["ID"]) %>'> <%# Server.HtmlEncode((string)((DataRowView)Container.DataItem)["Name"]) %> </asp:HyperLink>
                            <br />
                            <asp:Label ID="lblSubjectDescription" Font-Size="medium" runat="server"><%# Server.HtmlEncode((string)((DataRowView)Container.DataItem)["Description"])%></asp:Label>
                            <hr class="custom-hr" />
                            <div class="container-fluid pull-right padding-bottom10">
                                <asp:Label ID="lblCreateByDate" runat="server" Font-Size="0.75em">Added by
                                    <asp:HyperLink ID="hlCreateBy" NavigateUrl='<%# string.Format("Profile.aspx?User={0}", ((DataRowView)Container.DataItem)["CreateBy"]) %>'
                                        runat="server"><%# ((DataRowView)Container.DataItem)["CreateByUsername"]%></asp:HyperLink>
                                    on
                                    <asp:Label ID="lblCreateDate" runat="server" Font-Italic="True">
                                        <%# ((DateTime)((DataRowView)Container.DataItem)["CreateDate"]).ToString("dd MMMM yyyy", CultureInfo.CreateSpecificCulture("en-us")) %>
                                    </asp:Label>
                                </asp:Label>
                                <br />
                                <asp:Label ID="lblLastUpdateByDate" runat="server" Font-Size="0.75em">Last updated by
                                    <asp:HyperLink ID="hlLastUpdatbeBy" NavigateUrl='<%# string.Format("Profile.aspx?User={0}", ((DataRowView)Container.DataItem)["LastUpdateBy"]) %>'
                                        runat="server"><%# ((DataRowView)Container.DataItem)["LastUpdateByUsername"]%></asp:HyperLink>
                                    on
                                    <asp:Label ID="lblLastUpdateDate" runat="server" Font-Italic="True">
                                        <%# ((DateTime)((DataRowView)Container.DataItem)["LastUpdateDate"]).ToString("dd MMMM yyyy", CultureInfo.CreateSpecificCulture("en-us"))%>
                                    </asp:Label>
                                </asp:Label>
                            </div>
                            <div class="padding-top15 padding-bottom5">
                                <asp:LoginView ID="lvAdminValidatorLogin" runat="server">
                                    <RoleGroups>
                                        <asp:RoleGroup Roles="administrator">
                                            <ContentTemplate>
                                                <asp:LinkButton ID="lbtnEdit" runat="server" CausesValidation="False" CommandName="Edit"
                                                    Text="Edit" CssClass="btn btn-link color-black scale-hover" ToolTip="Edit">
                                                    <span class="glyphicon glyphicon-pencil"></span>
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="lbtnDelete" runat="server" CausesValidation="False" CommandName="Delete"
                                                    Text="Delete" CssClass="btn btn-link color-black scale-hover" ToolTip="Delete" OnClientClick="return confirm('Are you sure you want to delete this category?');">
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
                            <asp:TextBox ID="tbEditName" runat="server" Text='<%# Bind ("Name") %>' CssClass="form-control margin-top-1em"
                                MaxLength="100" Font-Size="X-Large"></asp:TextBox>
                            <br />
                            <asp:TextBox ID="tbEditDescription" runat="server" Text='<%# Bind ("Description") %>'
                                CssClass="form-control margin-bottom-1em" MaxLength="1000" Font-Size="Medium"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvSubjectTitle" ValidationGroup="SubjectValidationGroup"
                                runat="server" ControlToValidate="tbEditName" Display="Dynamic">
                                Subject title cannot be empty or whitespace. <br/>
                            </asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revSubjectTitle" ValidationGroup="SubjectValidationGroup"
                                ControlToValidate="tbEditName" ValidationExpression="^[\s\S]{0,100}$" runat="server"
                                Display="Dynamic">
                                Subject title must have maximum 100 characters. <br/>
                            </asp:RegularExpressionValidator>
                            <asp:RequiredFieldValidator ID="rfvSubjectDescription" ValidationGroup="SubjectValidationGroup"
                                runat="server" ControlToValidate="tbEditDescription" Display="Dynamic">
                                Subject description cannot be empty or whitespace.
                            </asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revSubjectDescription" ValidationGroup="SubjectValidationGroup"
                                ControlToValidate="tbEditDescription" ValidationExpression="^[\s\S]{0,1000}$"
                                runat="server" Display="Dynamic">
                                Subject title must have maximum 1000 characters. <br/>
                            </asp:RegularExpressionValidator>
                            <hr class="custom-hr" />
                            <div class="container-fluid pull-right padding-bottom10">
                                <asp:Label ID="lblCreateByDate" runat="server" Font-Size="0.75em">Added by
                                    <asp:HyperLink ID="hlCreateBy" NavigateUrl='<%# string.Format("Profile.aspx?User={0}", ((DataRowView)Container.DataItem)["CreateBy"]) %>'
                                        runat="server"><%# ((DataRowView)Container.DataItem)["CreateByUsername"]%></asp:HyperLink>
                                    on
                                    <asp:Label ID="lblCreateDate" runat="server" Font-Italic="True">
                                        <%# ((DateTime)((DataRowView)Container.DataItem)["CreateDate"]).ToString("dd MMMM yyyy", CultureInfo.CreateSpecificCulture("en-us")) %>
                                    </asp:Label>
                                </asp:Label>
                                <br />
                                <asp:Label ID="lblLastUpdateByDate" runat="server" Font-Size="0.75em">Last updated by
                                    <asp:HyperLink ID="hlLastUpdatbeBy" NavigateUrl='<%# string.Format("Profile.aspx?User={0}", ((DataRowView)Container.DataItem)["LastUpdateBy"]) %>'
                                        runat="server"><%# ((DataRowView)Container.DataItem)["LastUpdateByUsername"]%></asp:HyperLink>
                                    on
                                    <asp:Label ID="lblLastUpdateDate" runat="server" Font-Italic="True">
                                        <%# ((DateTime)((DataRowView)Container.DataItem)["LastUpdateDate"]).ToString("dd MMMM yyyy", CultureInfo.CreateSpecificCulture("en-us"))%>
                                    </asp:Label>
                                </asp:Label>
                            </div>
                            <div class="padding-top15 padding-bottom5">
                                <asp:LoginView ID="lvAdminValidatorLogin" runat="server">
                                    <RoleGroups>
                                        <asp:RoleGroup Roles="administrator">
                                            <ContentTemplate>
                                                <asp:LinkButton ID="lbtnUpdate" ValidationGroup="SubjectValidationGroup" runat="server"
                                                    CausesValidation="True" CommandName="Update" Text="Update" CssClass="btn btn-link color-black scale-hover"
                                                    ToolTip="Update">
                                                <span class="glyphicon glyphicon-ok"></span>
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="lbtnCancel" runat="server" CausesValidation="False" CommandName="Cancel"
                                                    Text="Cancel" CssClass="btn btn-link color-black scale-hover" ToolTip="Cancel">
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
                <asp:TemplateField HeaderText="Statistics" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="text-align-center"
                    ItemStyle-Width="1px" ItemStyle-Wrap="False">
                    <HeaderTemplate>
                        <div class="container-fluid padding-bottom5 padding-top5">
                            <asp:Label ID="lblHeaderStats" runat="server" Font-Size="large" ForeColor="White">
                                Stats
                            </asp:Label>
                        </div>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="container-fluid">
                            <div class="container-fluid">
                                <asp:Label ID="lblNumPosts" Font-Size="medium" runat="server"><%# ((DataRowView)Container.DataItem)["NumberOfPosts"] + @" posts"%></asp:Label>
                                <br />
                                <asp:Label ID="lblNumReplies" Font-Size="medium" runat="server"><%# ((DataRowView)Container.DataItem)["NumberOfReplies"] + @" replies"%></asp:Label>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="RecentPosts" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="text-align-center"
                    ItemStyle-Width="1px" ItemStyle-Wrap="False">
                    <HeaderTemplate>
                        <div class="container-fluid padding-bottom5 padding-top5">
                            <asp:Label ID="lblHeaderCategory" runat="server" Font-Size="large" ForeColor="White">
                                Recent posts
                            </asp:Label>
                        </div>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="container-fluid">
                            <%# RenderControlToHtml(MakeControlForRecentReply(((DataRowView)Container.DataItem)["RecentPostID"] as Guid?, ((DataRowView)Container.DataItem)["RecentPostCreateBy"] as Guid?, ((DataRowView)Container.DataItem)["RecentPostUsername"] as string, ((DataRowView)Container.DataItem)["RecentPostTitle"] as string, ((DataRowView)Container.DataItem)["RecentPostCreateDate"] as DateTime?))%>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
            ProviderName="System.Data.SqlClient" SelectCommand="
            SELECT SubjectID, COUNT(ID) AS NumPosts
            INTO #PostsCount
            FROM Posts
            GROUP BY SubjectID;
            
            SELECT Posts.SubjectID, COUNT(Replies.ID) as NumReplies
            INTO #RepliesCount
            FROM Posts
            INNER JOIN Replies ON Replies.PostID = Posts.ID
            GROUP BY Posts.SubjectID
            
            SELECT Posts.SubjectID, MAX(Posts.CreateDate) AS MaxCreateDate
            INTO #RepliesMaxCreateDate
            FROM Posts
            GROUP BY Posts.SubjectID

            SELECT Subjects.ID, 
                   Subjects.CreateBy, Subjects.CreateDate,
                   Subjects.LastUpdateBy, Subjects.LastUpdateDate,
                   CreateByUser.UserName as CreateByUsername, LastUpdateByUser.UserName as LastUpdateByUsername,
                   Subjects.Description, Subjects.Name, ISNULL(PostsCount.NumPosts, 0) as NumberOfPosts, ISNULL(RepliesCount.NumReplies, 0) as NumberOfReplies,
                   RecentPost.ID as RecentPostID , RecentPost.UserName as RecentPostUserName, RecentPost.Title as RecentPostTitle, 
                   RecentPost.CreateDate as RecentPostCreateDate, RecentPost.CreateBy as RecentPostCreateBy
            FROM Subjects 
            INNER JOIN aspnet_Users AS CreateByUser ON CreateByUser.UserId = Subjects.CreateBy
            INNER JOIN aspnet_Users AS LastUpdateByUser ON LastUpdateByUser.UserId = Subjects.LastUpdateBy
            LEFT OUTER JOIN #PostsCount AS PostsCount ON PostsCount.SubjectID = Subjects.ID
            LEFT OUTER JOIN #RepliesCount AS RepliesCount ON RepliesCount.SubjectID = Subjects.ID
            LEFT OUTER JOIN (
                SELECT Posts.ID, Posts.SubjectID, Posts.CreateBy, Posts.Title, Posts.CreateDate, aspnet_Users.UserName
                FROM Posts
                INNER JOIN aspnet_Users ON aspnet_Users.UserId = Posts.CreateBy
                INNER JOIN #RepliesMaxCreateDate ON (#RepliesMaxCreateDate.SubjectID = Posts.SubjectID AND #RepliesMaxCreateDate.MaxCreateDate = Posts.CreateDate)
            ) AS RecentPost ON RecentPost.SubjectID = Subjects.ID
            WHERE CategoryID = @CategoryID" 
            UpdateCommand="
            UPDATE Subjects SET Description = @Description , Name = @Name, LastUpdateBy = @LastUpdateBy, LastUpdateDate = @LastUpdateDate WHERE ID = @ID"
            DeleteCommand="
            DELETE FROM Replies WHERE PostID IN (
                SELECT ID FROM Posts WHERE SubjectID = @ID
            );
            DELETE FROM Posts WHERE SubjectID = @ID;
            DELETE FROM Subjects WHERE ID = @ID;
            ">
            <SelectParameters>
                <asp:QueryStringParameter Name="CategoryID" QueryStringField="Category" Type="String" />
            </SelectParameters>
            <UpdateParameters>
                <customAsp:LoginParameter Name="LastUpdateBy" />
                <customAsp:ServerDateParameter Name="LastUpdateDate" />
            </UpdateParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>
