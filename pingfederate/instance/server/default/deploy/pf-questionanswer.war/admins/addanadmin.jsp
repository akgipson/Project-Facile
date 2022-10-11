<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<html lang="$locale.getLanguage()" dir="ltr">
<head>
    <title>Question & Answer Administration: Manage Administrators - Add an Administrator</title>
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
        <font color="#136383"><b>Manage Administrators - Add an Administrator</b></font><br/><br/>
        <%
            if (session.getAttribute("USER_ACCESS_GRANTED").toString().equalsIgnoreCase("true") &&
                    session.getAttribute("USER_ROLE_SUPER_ADMIN").toString().equalsIgnoreCase("true"))
            {

                /***** BEGIN ADD AN ADMIN SECTION *****/
        %>
        <form method="post" action="<%=response.encodeRedirectURL("adminadded.jsp")%>">
            <table border="0" align="center" cellspacing="0" cellpadding="0">
                <%
                    String errorMessage = request.getParameter("errMsg");
                    if (StringUtils.isNotBlank(errorMessage))
                    {
                        String errorMessageDisplay = "";
                        if (errorMessage.equalsIgnoreCase("INVALID_USERNAME"))
                        {
                            errorMessageDisplay = "Please enter a valid username.";
                        } else if (errorMessage.equalsIgnoreCase("INVALID_EMAIL"))
                        {
                            errorMessageDisplay = "Please enter a valid email.";
                        } else if (errorMessage.equalsIgnoreCase("INVALID_ROLE"))
                        {
                            errorMessageDisplay = "Please select a valid role.";
                        }
                %>
                <tr>
                    <td valign="top" colspan="2" align="center"><font color="red"><b><%
                        out.print(errorMessageDisplay);%></b></font></td>
                </tr>
                <tr>
                    <td valign="top" colspan="2"><br/></td>
                </tr>
                <%
                    }
                %>
                <tr>
                    <td valign="top">Username:&nbsp;</td>
                    <td valign="top"><input type="text" name="username" size="35"
                                            value="<%if (StringUtils.isNotBlank(request.getParameter("username"))) out.print(request.getParameter("username"));%>"/>
                    </td>
                </tr>
                <tr>
                    <td valign="top" colspan="2"><br/></td>
                </tr>
                <tr>
                    <td valign="top">Email:&nbsp;</td>
                    <td valign="top"><input type="text" name="email" size="35"
                                            value="<%if (StringUtils.isNotBlank(request.getParameter("email"))) out.print(request.getParameter("email"));%>"/>
                    </td>
                </tr>
                <tr>
                    <td valign="top" colspan="2"><br/></td>
                </tr>
                <tr>
                    <td valign="top">Role:&nbsp;</td>
                    <td valign="top">
                        <select name="role">
                            <option value="0"><<--please select one-->></option>
                            <%
                                String role = request.getParameter("role");
                                if (StringUtils.isNotBlank(role) && role.equalsIgnoreCase("ADMIN"))
                                {
                                    out.print("<option value=\"ADMIN\" selected>ADMIN</option>");
                                } else
                                {
                                    out.print("<option value=\"ADMIN\">ADMIN</option>");
                                }

                                if (StringUtils.isNotBlank(role) && role.equalsIgnoreCase("QAADMIN"))
                                {
                                    out.print("<option value=\"QAADMIN\" selected>QAADMIN</option>");
                                } else
                                {
                                    out.print("<option value=\"QAADMIN\">QAADMIN</option>");
                                }

                                if (StringUtils.isNotBlank(role) && role.equalsIgnoreCase("HELPDESK"))
                                {
                                    out.print("<option value=\"HELPDESK\" selected>HELPDESK</option>");
                                } else
                                {
                                    out.print("<option value=\"HELPDESK\">HELPDESK</option>");
                                }

                                if (StringUtils.isNotBlank(role) && role.equalsIgnoreCase("USER"))
                                {
                                    out.print("<option value=\"USER\" selected>USER</option>");
                                } else
                                {
                                    out.print("<option value=\"USER\">USER</option>");
                                }
                            %>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td valign="top" colspan="2"><br/></td>
                </tr>
                <tr>
                    <td valign="top">Active:&nbsp;</td>
                    <td valign="top">
                        <%
                            String activeFlag = request.getParameter("activeFlag");
                            if (StringUtils.isNotBlank(activeFlag) && activeFlag.equalsIgnoreCase("0"))
                            {
                        %>
                        <input type="radio" name="activeFlag" value="1"> Yes
                        <input type="radio" name="activeFlag" value="0" checked> No
                        <%
                        } else
                        {
                        %>
                        <input type="radio" name="activeFlag" value="1" checked> Yes
                        <input type="radio" name="activeFlag" value="0"> No
                        <%
                            }
                        %>
                    </td>
                </tr>
                <tr>
                    <td valign="top" colspan="2"><br/></td>
                </tr>
                <tr>
                    <td valign="top" colspan="2" align="center">
                        <input type="hidden" name="formSubmitted" value="yes"/>
                        <input type="submit" name="adminSubmit" class="ping-button normal" value="Submit"/>
                    </td>
                </tr>
            </table>
        </form>
        <%
                /***** END ADD AN ADMIN SECTION *****/

                out.print("<br /><br /><center>[ <a href=\"" + response.encodeRedirectURL("index.jsp") + "\">manage administrators</a> ]</center>");
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