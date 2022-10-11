<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page
        import="org.apache.commons.lang.StringUtils,com.pingidentity.clientservices.product.administration.questionanswer.utils.PropertyInfoRetriever,com.pingidentity.clientservices.product.administration.questionanswer.ManageAdmins,com.pingidentity.clientservices.product.administration.questionanswer.Administrator" %>
<html lang="$locale.getLanguage()" dir="ltr">
<head>
    <title>Question & Answer Administration: Manage Administrators - Update Administrator</title>
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
        <font color="#136383"><b>Manage Administrators - Update Administrator</b></font><br/><br/>
        <%
            if (session.getAttribute("USER_ACCESS_GRANTED").toString().equalsIgnoreCase("true") &&
                    session.getAttribute("USER_ROLE_SUPER_ADMIN").toString().equalsIgnoreCase("true"))
            {
                /***** BEGIN UPDATE ADMINISTRATOR SECTION *****/
                PropertyInfoRetriever sair = new PropertyInfoRetriever();
                String siteAdminEmail = sair.getSiteAdminEmail();

                String uid = request.getParameter("uid");
                if (StringUtils.isNotBlank(uid))
                {
                    uid = uid.trim();

                    String user = (String) session.getAttribute("USERNAME");

                    ManageAdmins ma = new ManageAdmins();
                    Administrator aa = ma.queryAdmin(uid, user);

                    if (aa != null && aa.getUserId() != 0)
                    {
                        String userId = request.getParameter("userId");
                        String username = request.getParameter("username");
                        String email = request.getParameter("email");
                        String role = request.getParameter("role");
                        String activeFlag = request.getParameter("activeFlag");
                        String creationDate = request.getParameter("creationDate");
                        String lastUpdatedDate = request.getParameter("lastUpdatedDate");

                        String formSubmitted = request.getParameter("formSubmitted");
                        if (StringUtils.isBlank(formSubmitted))
                        {
                            userId = String.valueOf(aa.getUserId());

                            username = aa.getUsername();

                            if (aa.getEmail() != null)
                            {
                                email = aa.getEmail();
                            } else
                            {
                                email = "";
                            }

                            role = aa.getRole();

                            activeFlag = String.valueOf(aa.getActiveFlag());

                            if (aa.getCreationDate() != null)
                            {
                                creationDate = aa.getCreationDate().toString();
                            } else
                            {
                                creationDate = "";
                            }

                            if (aa.getLastUpdatedDate() != null)
                            {
                                lastUpdatedDate = aa.getLastUpdatedDate().toString();
                            } else
                            {
                                lastUpdatedDate = "";
                            }
                        }
        %>
        <form method="post" action="<%=response.encodeRedirectURL("adminupdated.jsp")%>">
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
                    <td valign="top"><input type="text" name="username" size="35" value="<%out.print(username);%>"/>
                    </td>
                </tr>
                <tr>
                    <td valign="top" colspan="2"><br/></td>
                </tr>
                <tr>
                    <td valign="top">Email:&nbsp;</td>
                    <td valign="top"><input type="text" name="email" size="35" value="<%out.print(email);%>"/></td>
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
                    <td valign="top">Creation Date:&nbsp;</td>
                    <td valign="top"><%out.print(creationDate);%></td>
                </tr>
                <tr>
                    <td valign="top" colspan="2"><br/></td>
                </tr>
                <tr>
                    <td valign="top">Last Updated Date:&nbsp;</td>
                    <td valign="top"><%out.print(lastUpdatedDate);%></td>
                </tr>
                <tr>
                    <td valign="top" colspan="2"><br/></td>
                </tr>
                <tr>
                    <td valign="top" colspan="2" align="center">
                        <input type="hidden" name="formSubmitted" value="yes"/>
                        <input type="hidden" name="userId" value="<%out.print(userId);%>"/>
                        <input type="hidden" name="creationDate" value="<%out.print(creationDate);%>"/>
                        <input type="hidden" name="lastUpdatedDate" value="<%out.print(lastUpdatedDate);%>"/>
                        <input type="submit" name="adminSubmit" class="ping-button normal" value="Submit"/>
                    </td>
                </tr>
            </table>
        </form>
        <%
                    } else
                    {
                        out.print("Sorry, the administrator that you are trying to update does not exist. Therefore, it cannot be updated. Please click on <a href=\"" + response.encodeRedirectURL("index.jsp") + "\">manage administrators</a> to update a valid administrator.<br /><br />");
                        out.print("If you feel that you have reached this message in error, please report it to <a href=\"mailto:" + siteAdminEmail + "\">" + siteAdminEmail + "</a>.");
                    }
                } else
                {
                    out.print("Sorry, an invalid administrator cannot be updated. Please click on <a href=\"" + response.encodeRedirectURL("index.jsp") + "\">manage administrators</a> to update a valid administrator.<br /><br />");
                    out.print("If you feel that you have reached this message in error, please report it to <a href=\"mailto:" + siteAdminEmail + "\">" + siteAdminEmail + "</a>.");
                }
                /***** END UPDATE ADMINISTRATOR SECTION *****/

                out.print("<br /><br /><center>[ <a href=\"" + response.encodeRedirectURL("index.jsp") + "\">manage administrators</a> | <a href=\"" + response.encodeRedirectURL("addanadmin.jsp") + "\">add an administrator</a> ]</center>");
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