<%@ Page Title="" Language="C#" MasterPageFile="~/NavbarMasterPage.master" AutoEventWireup="true"
    CodeFile="MainPage.aspx.cs" Inherits="MainPage" ValidateRequest="false" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Globalization" %>
<asp:Content ID="cntMainPageHead" ContentPlaceHolderID="HeadPlaceHolder" runat="Server">
    <link href="Styles/mainpage-styles.css" rel="stylesheet" type="text/css" />
    <link href="Styles/repliespage-styles.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            var newCategoryDialog = $("#" + "<%= dNewCategoryDialog.ClientID %>").dialog({
                autoOpen: false,
                modal: true,
                draggable: true,
                height: "auto",
                width: "auto",
                resizable: false
            });
            newCategoryDialog.parent().appendTo($("form:first"));
        });
    </script>
</asp:Content>
<asp:Content ID="cntMainPageBody" ContentPlaceHolderID="ContentPlaceHolder" runat="Server">
    <div id="dNewCategoryDialog" title="New category dialog" runat="server">
        <asp:LoginView ID="lvCategoryDialogLoginView" runat="server">
            <RoleGroups>
                <asp:RoleGroup Roles="administrator">
                    <ContentTemplate>
                        <asp:Label ID="lblCategoryName" Font-Size="X-Large" runat="server">
                            Category name
                        </asp:Label>
                        <br />
                        <asp:TextBox ID="tbCategoryName" runat="server" CssClass="form-control margin-top-1em"
                            Font-Size="Large" ToolTip="Category title" />
                        <br />
                        <asp:Label ID="lblCategoryDescription" Font-Size="Medium" runat="server">
                            Category description
                        </asp:Label>
                        <br />
                        <asp:TextBox ID="tbCategoryDescription" runat="server" TextMode="multiline" Font-Size="Medium"
                            CssClass="form-control margin-top-1em" Rows="10" Columns="50">
                        </asp:TextBox>
                        <br />
                        <asp:RequiredFieldValidator ID="rfvEditName" runat="server" Display="Dynamic" ControlToValidate="tbCategoryName"
                            ValidationGroup="NewCategoryGroup">
                    Name cannot be empty or whitespace.<br />
                        </asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revEditName" ControlToValidate="tbCategoryName"
                            ValidationExpression="^[\s\S]{0,100}$" runat="server" Display="Dynamic" ValidationGroup="NewCategoryGroup">
                    Name must have maximum 100 characters.<br/>
                        </asp:RegularExpressionValidator>
                        <asp:RequiredFieldValidator ID="rfvEditDescription" runat="server" Display="Dynamic"
                            ControlToValidate="tbCategoryDescription" ValidationGroup="NewCategoryGroup">
                    Description cannot be empty or whitespace.<br />
                        </asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revEditDescription" ControlToValidate="tbCategoryDescription"
                            ValidationExpression="^[\s\S]{0,1000}$" runat="server" Display="Dynamic" ValidationGroup="NewCategoryGroup">
                    Description must have maximum 1000 characters.<br/>
                        </asp:RegularExpressionValidator>
                        <asp:Button ID="btnReply" runat="server" ValidationGroup="NewCategoryGroup" CssClass="btn btn-primary pull-right"
                            Text="New category" OnClick="CreateNewCategoryClick" />
                    </ContentTemplate>
                </asp:RoleGroup>
            </RoleGroups>
        </asp:LoginView>
    </div>
    <asp:LoginView runat="server" ID="lvNewCategory">
        <RoleGroups>
            <asp:RoleGroup Roles="administrator">
                <ContentTemplate>
                    <div class="container-fluid padding-bottom10 padding-top10">
                        <a class="btn btn-primary pull-right" onclick="$('#' + '<%= dNewCategoryDialog.ClientID %>').dialog('open')">
                            <span class="glyphicon glyphicon-plus" style="margin-right: 10px"></span>Create
                            new category </a>
                    </div>
                </ContentTemplate>
            </asp:RoleGroup>
        </RoleGroups>
    </asp:LoginView>
    <div class="container-fluid">
        <asp:GridView ID="gvCategoriesContainer" runat="server" AutoGenerateColumns="False"
            DataKeyNames="ID" ShowHeader="True" HeaderStyle-BackColor="#344E87" DataSourceID="SqlDataSource1"
            CssClass="table-bordered table-responsive background-whitesmoke categories-width-fill">
            <Columns>
                <asp:TemplateField HeaderText="Category" ItemStyle-HorizontalAlign="Left" HeaderStyle-CssClass="text-align-left">
                    <HeaderTemplate>
                        <div class="container-fluid padding-bottom5 padding-top5">
                            <asp:Label ID="lblHeaderCategory" runat="server" Font-Size="large" ForeColor="White">
                                Category
                            </asp:Label>
                        </div>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="container-fluid padding-top10">
                            <asp:HyperLink ID="hlCategoryName" Font-Size="x-large" Font-Bold="True" runat="server"
                                NavigateUrl='<%# string.Format("Subjects.aspx?Category={0}", ((DataRowView)Container.DataItem)["ID"]) %>'>
                                <%# Server.HtmlEncode((string)((DataRowView)Container.DataItem)["Name"]) %>
                            </asp:HyperLink>
                            <br />
                            <asp:Label ID="hlCategoryDescription" Font-Size="medium" runat="server"><%# Server.HtmlEncode((string)((DataRowView)Container.DataItem)["Description"]) %></asp:Label>
                            <hr class="custom-hr" />
                            <div class="container-fluid pull-right padding-bottom10">
                                <asp:Label ID="lblCreateByDate" runat="server" Font-Size="0.75em">Added by
                                    <asp:HyperLink ID="hlCreateBy" NavigateUrl='<%# string.Format("Profile.aspx?User={0}",((DataRowView)Container.DataItem)["CreateBy"]) %>'
                                        runat="server"><%# ((DataRowView)Container.DataItem)["CreateByUsername"]%></asp:HyperLink>
                                    on
                                    <asp:Label ID="lblCreateDate" runat="server" Font-Italic="True">
                                        <%# ((DateTime)((DataRowView)Container.DataItem)["CreateDate"]).ToString("dd MMMM yyyy", CultureInfo.CreateSpecificCulture("en-us"))%>
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
                                                    Text="Delete" CssClass="btn btn-link color-black scale-hover" ToolTip="Delete"
                                                    OnClientClick="return confirm('Are you sure you want to delete this category?'); ">
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
                            <asp:TextBox ID="tbEditName" runat="server" Text='<%# Bind("Name") %>' CssClass="form-control input-lg margin-top-1em"
                                MaxLength="100" Font-Size="X-Large"></asp:TextBox>
                            <br />
                            <asp:TextBox ID="tbEditDescription" runat="server" Text='<%# Bind("Description") %>'
                                CssClass="form-control margin-bottom-1em" MaxLength="1000" Font-Size="Medium"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvEditName" runat="server" Display="Dynamic" ControlToValidate="tbEditName"
                                ValidationGroup="EditCategoryGroup">
                                Name cannot be empty or whitespace.<br />
                            </asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revEditName" ControlToValidate="tbEditName" ValidationExpression="^[\s\S]{0,100}$"
                                runat="server" Display="Dynamic" ValidationGroup="EditCategoryGroup">
                                Name must have maximum 100 characters.<br/>
                            </asp:RegularExpressionValidator>
                            <asp:RequiredFieldValidator ID="rfvEditDescription" runat="server" Display="Dynamic"
                                ControlToValidate="tbEditDescription" ValidationGroup="EditCategoryGroup">
                                Description cannot be empty or whitespace.<br />
                            </asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revEditDescription" ControlToValidate="tbEditDescription"
                                ValidationExpression="^[\s\S]{0,1000}$" runat="server" Display="Dynamic" ValidationGroup="EditCategoryGroup">
                                Description must have maximum 1000 characters.<br/>
                            </asp:RegularExpressionValidator>
                            <hr class="custom-hr" />
                            <div class="container-fluid pull-right padding-bottom10">
                                <asp:Label ID="lblCreateByDate" runat="server" Font-Size="0.75em">Added by
                                    <asp:HyperLink ID="hlCreateBy" NavigateUrl='<%# string.Format("Profile.aspx?User={0}",((DataRowView)Container.DataItem)["CreateBy"]) %>'
                                        runat="server"><%# ((DataRowView)Container.DataItem)["CreateByUsername"]%></asp:HyperLink>
                                    on
                                    <asp:Label ID="lblCreateDate" runat="server" Font-Italic="True">
                                        <%# ((DateTime)((DataRowView)Container.DataItem)["CreateDate"]).ToString("dd MMMM yyyy", CultureInfo.CreateSpecificCulture("en-us"))%>
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
                                                <asp:LinkButton ID="lbtnUpdate" runat="server" CausesValidation="True" ValidationGroup="EditCategoryGroup"
                                                    CommandName="Update" Text="Update" CssClass="btn btn-link color-black scale-hover"
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
                    ItemStyle-Wrap="False" ItemStyle-Width="1px">
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
                                <asp:Label ID="lblNumSubjects" Font-Size="medium" runat="server"><%# ((DataRowView)Container.DataItem)["NumberOfSubjects"] + @" subjects"%></asp:Label>
                                <br />
                                <asp:Label ID="lblNumPosts" Font-Size="medium" runat="server"><%# ((DataRowView)Container.DataItem)["NumberOfPosts"] + @" posts"%></asp:Label>
                                <br />
                                <asp:Label ID="lblNumReplies" Font-Size="medium" runat="server"><%# ((DataRowView)Container.DataItem)["NumberOfReplies"] + @" replies"%></asp:Label>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="RecentPosts" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="text-align-center" HeaderStyle-Wrap="False"
                    ItemStyle-Wrap="False" ItemStyle-Width="1px">
                    <HeaderTemplate>
                        <div class="container-fluid padding-bottom5 padding-top5">
                            <asp:Label ID="lblHeaderRecent" runat="server" Font-Size="large" ForeColor="White">
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
            SELECT CategoryID, COUNT(ID) NumSubjects
            INTO #SubjectsCount
            FROM  Subjects
            GROUP BY CategoryID;

            SELECT Subjects.CategoryID, COUNT(Posts.ID) NumPosts
            INTO #PostsCount
            FROM Subjects
            INNER JOIN Posts ON Posts.SubjectID = Subjects.ID
            GROUP BY Subjects.CategoryID;

            SELECT Subjects.CategoryID, COUNT(Replies.ID) NumReplies
            INTO #RepliesCount
            FROM Subjects AS Subjects 
            INNER JOIN Posts AS Posts ON Posts.SubjectID = Subjects.ID 
            INNER JOIN Replies ON Replies.PostID = Posts.ID
            GROUP BY Subjects.CategoryID;
            
            SELECT Subjects.CategoryID, MAX(Posts.CreateDate) AS MaxCreateDate
            INTO #RepliesMaxCreateDate
            FROM Posts
            INNER JOIN Subjects ON Subjects.ID = Posts.SubjectID
            GROUP BY Subjects.CategoryID

            SELECT Category.ID, Category.CreateBy, Category.LastUpdateBy, Category.Description, Category.Name, 
                   Category.CreateDate, CreateByUser.UserName as CreateByUsername, 
                   Category.LastUpdateDate, LastUpdateByUser.UserName as LastUpdateByUsername,
                   ISNULL(#SubjectsCount.NumSubjects, 0) AS NumberOfSubjects, ISNULL(#PostsCount.NumPosts, 0) AS NumberOfPosts, 
                   ISNULL(#RepliesCount.NumReplies, 0) AS NumberOfReplies, RecentPost.ID as RecentPostID , RecentPost.UserName as RecentPostUserName, RecentPost.Title as RecentPostTitle , 
                   RecentPost.CreateDate as RecentPostCreateDate, RecentPost.CreateBy as RecentPostCreateBy
            FROM Category 
            INNER JOIN aspnet_Users as CreateByUser ON CreateByUser.UserId = Category.CreateBy
            INNER JOIN aspnet_Users as LastUpdateByUser ON LastUpdateByUser.UserId = Category.LastUpdateBy
            LEFT OUTER JOIN #SubjectsCount ON #SubjectsCount.CategoryID = Category.ID 
            LEFT OUTER JOIN #PostsCount ON #PostsCount.CategoryID = Category.ID 
            LEFT OUTER JOIN #RepliesCount ON #RepliesCount.CategoryID = Category.ID
            LEFT OUTER JOIN (
                SELECT Posts.ID, Posts.SubjectID, Subjects.CategoryID, Posts.CreateBy, Posts.Title, Posts.CreateDate, aspnet_Users.UserName
                FROM Posts
                INNER JOIN aspnet_Users ON aspnet_Users.UserId = Posts.CreateBy
                INNER JOIN Subjects ON Subjects.ID = Posts.SubjectID
                INNER JOIN #RepliesMaxCreateDate ON (#RepliesMaxCreateDate.CategoryID = Subjects.CategoryID AND #RepliesMaxCreateDate.MaxCreateDate = Posts.CreateDate)
            ) AS RecentPost ON RecentPost.CategoryID = Category.ID;" UpdateCommand="
            UPDATE Category SET Description = @Description , Name = @Name, LastUpdateDate = @LastUpdateDate, LastUpdateBy = @LastUpdateBy WHERE ID = @ID"
            DeleteCommand="
            DELETE FROM Replies WHERE PostID IN (
                SELECT Posts.ID FROM Posts INNER JOIN Subjects ON Subjects.ID = Posts.SubjectID WHERE Subjects.CategoryID = @ID
            );
            DELETE FROM Posts WHERE SubjectID IN (
                SELECT ID FROM Subjects WHERE CategoryID = @ID
            );
            DELETE FROM Subjects WHERE CategoryID = @ID;
            DELETE FROM Category WHERE ID = @ID;
            ">
            <UpdateParameters>
                <customAsp:LoginParameter Name="LastUpdateBy" />
                <customAsp:ServerDateParameter Name="LastUpdateDate" />
            </UpdateParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>
