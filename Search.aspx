<%@ Page Title="" Language="C#" MasterPageFile="~/NavbarMasterPage.master" AutoEventWireup="true"
    CodeFile="Search.aspx.cs" Inherits="Search" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Globalization" %>
<asp:Content ID="cntSearchHead" ContentPlaceHolderID="HeadPlaceHolder" runat="Server">
    <link href="Styles/repliespage-styles.css" rel="stylesheet" type="text/css" />
    <link href="Styles/mainpage-styles.css" rel="stylesheet" type="text/css" />
    <link href="Styles/subjectspage-styles.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="cntSearchBody" ContentPlaceHolderID="ContentPlaceHolder" runat="Server">
    <div id="dPostsContainer" runat="server" class="container-fluid">
        <asp:GridView ID="gvSearch" runat="server" DataSourceID="SqlDataSource1" AllowPaging="true"
            PageSize="20" AutoGenerateColumns="False" DataKeyNames="ID" ShowHeader="False"
            CssClass="custom-table table-bordered categories-width-fill margin-top-1em background-whitesmoke">
            <Columns>
                <asp:TemplateField HeaderText="Reply" ItemStyle-HorizontalAlign="Left">
                    <ItemTemplate>
                        <div class="container-fluid">
                            <asp:HyperLink ID="hlPostTitle" Font-Size="large" Font-Bold="True" runat="server" NavigateUrl=<%# string.Format("Replies.aspx?Post={0}",((DataRowView)Container.DataItem)["PostID"]) %>> <%# Convert.ToBoolean(((DataRowView)Container.DataItem)["IsReply"]) ? string.Format("Re : {0}", ((DataRowView)Container.DataItem)["PostTitle"]) : ((DataRowView)Container.DataItem)["PostTitle"]%> </asp:HyperLink>
                            <div class = "container-fluid background-whitesmoke padding-bottom15 padding-top30">
                                <div class="container-fluid">
                                    <asp:Label ID="lblReplyText" runat="server" Font-Size="medium">
                                        <%# ((DataRowView)Container.DataItem)["Text"] %>
                                    </asp:Label>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Data" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="1px"
                    ItemStyle-Wrap="False">
                    <ItemTemplate>
                        <div class="container-fluid padding-top5 padding-bottom15">
                            <div class="container-fluid">
                                <asp:Label ID="lblCreateByDate" runat="server" Font-Size="0.75em">
                                    Added by 
                                    <asp:HyperLink ID="hlCreateBy" NavigateUrl=<%# string.Format("Profile.aspx?User={0}", ((DataRowView)Container.DataItem)["CreateBy"]) %> runat="server"><%# ((DataRowView)Container.DataItem)["CreateByUsername"] %></asp:HyperLink> 
                                    on
                                    <asp:Label ID="lblCreateDate" runat="server" Font-Italic="True">
                                        <%# ((DateTime)((DataRowView)Container.DataItem)["CreateDate"]).ToString("dd MMMM yyyy", CultureInfo.CreateSpecificCulture("en-us"))%>
                                    </asp:Label>
                                </asp:Label>
                                <br/>
                                <asp:Label ID="lblLastUpdateByDate" runat="server" Font-Size="0.75em">
                                    Last updated by 
                                    <asp:HyperLink ID="hlLastUpdatbeBy" NavigateUrl=<%# string.Format("Profile.aspx?User={0}", ((DataRowView)Container.DataItem)["LastUpdateBy"]) %> runat="server"><%# ((DataRowView)Container.DataItem)["LastUpdateByUsername"] %></asp:HyperLink> 
                                    on
                                    <asp:Label ID="lblLastUpdateDate" runat="server" Font-Italic="True">
                                        <%# ((DateTime)((DataRowView)Container.DataItem)["LastUpdateDate"]).ToString("dd MMMM yyyy", CultureInfo.CreateSpecificCulture("en-us"))%>
                                    </asp:Label>
                                </asp:Label>
                                <br />
                                <br/>
                                <asp:Label ID="lblCategoryHolder" runat="server" Font-Size="medium">
                                    Category: 
                                    <asp:HyperLink ID="hlCategoryName" NavigateUrl=<%# string.Format("Subjects.aspx?Category={0}",((DataRowView)Container.DataItem)["CategoryID"]) %> runat="server">
                                        <%# Server.HtmlEncode((string)((DataRowView)Container.DataItem)["CategoryName"]) %>
                                    </asp:HyperLink>
                                </asp:Label>
                                <br/>
                                <asp:Label ID="lblSubjectHolder" runat="server" Font-Size="medium">
                                    Subject: 
                                    <asp:HyperLink ID="hlSubjectName" NavigateUrl=<%# string.Format("Posts.aspx?Subject={0}",((DataRowView)Container.DataItem)["SubjectID"]) %> runat="server">
                                        <%# Server.HtmlEncode((string)((DataRowView)Container.DataItem)["SubjectName"])%>
                                    </asp:HyperLink>
                                </asp:Label>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
    <asp:SqlDataSource ID="SqlDataSource1" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
        ProviderName="System.Data.SqlClient" SelectCommand="
        SELECT Replies.ID, Replies.Text, Replies.CreateDate, Replies.CreateBy, Replies.LastUpdateDate, Replies.LastUpdateBy, Replies.IsReply,
               CreateByUser.Username as CreateByUsername, LastUpdateByUser.Username as LastUpdateByUsername,
               Category.Name AS CategoryName, Category.ID AS CategoryID, 
               Subjects.Name AS SubjectName, Subjects.ID AS SubjectID, Posts.Title AS PostTitle, Posts.ID AS PostID
        FROM Replies 
        INNER JOIN Posts ON Posts.ID = Replies.PostID 
        INNER JOIN Subjects ON Subjects.ID = Posts.SubjectID 
        INNER JOIN Category ON Category.ID = Subjects.CategoryID
        INNER JOIN aspnet_Users AS CreateByUser ON CreateByUser.UserId = Replies.CreateBy
        INNER JOIN aspnet_Users AS LastUpdateByUser ON LastUpdateByUser.UserId = Replies.LastUpdateBy
        WHERE (Posts.Title LIKE '%' + @QueryString + '%') OR (Replies.Text LIKE '%' + @QueryString + '%')
        ORDER BY Replies.CreateDate DESC" runat="server">
        <SelectParameters>
            <asp:QueryStringParameter Name="QueryString" QueryStringField="Query" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
