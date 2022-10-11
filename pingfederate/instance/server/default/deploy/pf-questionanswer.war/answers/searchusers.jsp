<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page
        import="org.apache.commons.lang.StringUtils, java.util.HashMap, java.util.Iterator, java.util.Map, com.pingidentity.clientservices.product.administration.questionanswer.utils.StringValidator, com.pingidentity.clientservices.product.administration.questionanswer.ManageUsers, com.pingidentity.clientservices.product.administration.questionanswer.User" %>
<html lang="$locale.getLanguage()" dir="ltr">
<head>
    <title>Question & Answer Administration: Manage Users Answers - Search Users</title>
    <meta name="robots" content="noindex, nofollow"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="viewport" content="initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
    <link rel="stylesheet" media="all" type="text/css" href="../../assets/css/main.css"/>
</head>
<body>
<jsp:include page="../includes/session.jsp"/>
<div class="ping-container">
    <div class="ping-header">
        Question & Answer Administration
    </div><!-- .ping-header -->
    <div class="ping-body-container">
        <%out.print(session.getAttribute("SESSION_LOGGEDIN_MESSAGE"));%>
        <font color="#136383"><b>Manage Users Answers - Search Users</b></font><br/><br/>
        <%
            if (session.getAttribute("USER_ACCESS_GRANTED").toString().equalsIgnoreCase("true") && (
                    session.getAttribute("USER_ROLE_SUPER_ADMIN").toString().equalsIgnoreCase("true") ||
                            session.getAttribute("USER_ROLE_HD_ADMIN").toString().equalsIgnoreCase("true")))
            {

                /***** BEGIN SEARCH USERS DISPLAY *****/
        %>
        <form method="post" action="<%=response.encodeRedirectURL("searchusers.jsp")%>">
            <input type="hidden" name="formSubmitted" value="yes"/>
            <table border="0" align="center" width="100%">
                <tr>
                    <td valign="top">Search for the user by username:</td>
                </tr>
                <%
                    String formSubmitted = request.getParameter("formSubmitted");
                    String username = request.getParameter("username");
                    boolean errorsExist = false;
                    if (StringUtils.isNotBlank(formSubmitted) && formSubmitted.equalsIgnoreCase("yes"))
                    {
                        if (StringUtils.isBlank(username) || (StringUtils.isNotBlank(username) && (username.length() < 2) || StringValidator.containsBadCharacters(username)))
                        {
                            errorsExist = true;
                %>
                <tr>
                    <td valign="top" colspan="2"><br/></td>
                </tr>
                <tr>
                    <td valign="top" align="center" colspan="2"><font color="red"><b><%
                        out.print("Please enter a valid username.");%></b></font></td>
                </tr>
                <%
                        }
                    }
                %>
                <tr>
                    <td valign="top" colspan="2"><br/></td>
                </tr>
                <tr>
                    <td valign="top"><input type="text" name="username" size="20"
                                            value="<%if (StringUtils.isNotBlank(request.getParameter("username"))) out.print(request.getParameter("username"));%>"/>
                    </td>
                    <td valign="top">&nbsp;&nbsp;<input type="submit" name="searchUsersSubmit"
                                                        class="ping-button normal" value="GO"/></td>
                </tr>
            </table>
        </form>
        <%
            if (StringUtils.isNotBlank(formSubmitted) && formSubmitted.equalsIgnoreCase("yes") && !errorsExist)
            {
                if (StringUtils.isNotBlank(username))
                {
                    String user = (String) session.getAttribute("USERNAME");

                    ManageUsers mu = new ManageUsers();
                    HashMap<Integer, User> users = mu.queryUsers(username, user);
                    if (users != null && !users.isEmpty())
                    {
        %>
        <br/>
        <table border="0" align="center" width="100%">
            <tr>
                <td valign="top"><font size="2"><b>User</b></font></td>
                <td valign="top"><font size="2"><b>Role</b></font></td>
                <td valign="top"><font size="2"><b>Active</b></font></td>
                <td valign="top"><font size="2"><b>Last Updated</b></font></td>
                <td valign="top"></td>
            </tr>
            <tr>
                <td colspan="5"><br/></td>
            </tr>
            <%
                Iterator it = users.entrySet().iterator();
                while (it.hasNext())
                {
                    Map.Entry<Integer, User> pair = (Map.Entry<Integer, User>) it.next();
                    User userObject = pair.getValue();

                    String active = "yes";
                    if (userObject.getActiveFlag() == 0)
                    {
                        active = "no";
                    }
            %>
            <tr>
                <td valign="top"><font size="2"><%out.print(userObject.getUsername());%></font>&nbsp;</td>
                <td valign="top"><font size="2"><%out.print(userObject.getRole());%></font>&nbsp;</td>
                <td valign="top"><font size="2"><%out.print(active);%></font></td>
                <td valign="top"><font size="2"><%out.print(userObject.getLastUpdatedDate());%></font>&nbsp;</td>
                <td valign="top"><%
                    out.print("<a href=\"" + response.encodeRedirectURL("answersreset.jsp?uid=" + userObject.getUserId()) + "\">reset</a>");%></td>
            </tr>
            <%
                }
            %>
        </table>
        <%
                        } else
                        {
                            out.print("<br /><center>Sorry, no users exist with the username of '<font color=\"red\">" + username + "</font>'.<br />Please try searching again.</center>");
                        }
                    }
                }
                /***** END SEARCH USERS DISPLAY *****/
            } else
            {
                out.print("<div class=\"ping-error\">");
                out.print(session.getAttribute("SESSION_ERROR_MESSAGE"));
                out.print("</div>");
            }

            out.print("<br /><br />");
            out.print("<center><font size=\"2\">[ <a href=\"" + response.encodeRedirectURL("../index.jsp") + "\">go back to main</a> ]</font></center>");
        %>
    </div><!-- .ping-body-container -->
    <div class="ping-footer-container">
        <div class="ping-footer">
            <div class="ping-credits">
                <a href="http://www.pingidentity.com">PingIdentity</a>
            </div>
        </div> <!-- .ping-footer -->
    </div> <!-- .ping-footer-container -->
</div><!-- .ping-container -->
</body>
</html>