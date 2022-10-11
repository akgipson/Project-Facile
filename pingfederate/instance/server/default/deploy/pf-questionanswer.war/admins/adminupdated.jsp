<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page
        import="org.apache.commons.lang.StringUtils,com.pingidentity.clientservices.product.administration.questionanswer.utils.PropertyInfoRetriever,com.pingidentity.clientservices.product.administration.questionanswer.ManageAdmins" %>
<html lang="$locale.getLanguage()" dir="ltr">
<head>
    <title>Question & Answer Administration: Manage Administrators - Administrator Updated</title>
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
        <font color="#136383"><b>Manage Administrators - Administrator Updated</b></font><br/><br/>
        <%
            if (session.getAttribute("USER_ACCESS_GRANTED").toString().equalsIgnoreCase("true") &&
                    session.getAttribute("USER_ROLE_SUPER_ADMIN").toString().equalsIgnoreCase("true"))
            {
                /***** BEGIN ADMINISTRATOR UPDATED SECTION *****/
                String formSubmitted = request.getParameter("formSubmitted");
                String userId = request.getParameter("userId");
                String username = request.getParameter("username");
                String email = request.getParameter("email");
                String role = request.getParameter("role");
                String activeFlag = request.getParameter("activeFlag");

                if (StringUtils.isNotBlank(formSubmitted) && formSubmitted.equalsIgnoreCase("yes"))
                {
                    if (StringUtils.isBlank(username) || (StringUtils.isNotBlank(username) && username.length() < 3))
                    {
                        String errorMessage = "INVALID_USERNAME";
                        String redirectUrl = response.encodeRedirectURL("updateadmin.jsp?uid=" + userId + "&errMsg=" + errorMessage);
                        request.getRequestDispatcher(redirectUrl).forward(request, response);
                    } else if (StringUtils.isBlank(email) || (StringUtils.isNotBlank(email) && (email.length() < 3) || !email.contains("@") || !email.contains(".")))
                    {
                        String errorMessage = "INVALID_EMAIL";
                        String redirectUrl = response.encodeRedirectURL("updateadmin.jsp?uid=" + userId + "&errMsg=" + errorMessage);
                        request.getRequestDispatcher(redirectUrl).forward(request, response);
                    } else if (StringUtils.isBlank(role) || (StringUtils.isNotBlank(role) && role.equalsIgnoreCase("0")))
                    {
                        String errorMessage = "INVALID_ROLE";
                        String redirectUrl = response.encodeRedirectURL("updateadmin.jsp?uid=" + userId + "&errMsg=" + errorMessage);
                        request.getRequestDispatcher(redirectUrl).forward(request, response);
                    } else
                    {
                        if (StringUtils.isNotBlank(userId) && !userId.equalsIgnoreCase("0"))
                        {
                            String user = (String) session.getAttribute("USERNAME");

                            ManageAdmins ma = new ManageAdmins();
                            ma.updateAdmin(userId, username, email, role, activeFlag, user);

                            out.print("The <a href=\"" + response.encodeRedirectURL("updateadmin.jsp?uid=" + userId) + "\">administrator (" + username + ")</a> has been updated!");
                        } else
                        {
                            out.print("An administrator with an invalid ID cannot be updated. Please click on <a href=\"" + response.encodeRedirectURL("index.jsp") + "\">manage administrators</a> to update an administrator again.<br /><br />");
                        }
                    }
                } else
                {
                    if (StringUtils.isNotBlank(userId) && !userId.equalsIgnoreCase("0"))
                    {
                        out.print("An unexpected error has occurred. Please try <a href=\"" + response.encodeRedirectURL("updateadmin.jsp?uid=" + userId) + "\"> updating administrator (" + username + ")</a> again.<br /><br />");
                    } else
                    {
                        out.print("An unexpected error has occurred. Please click on <a href=\"" + response.encodeRedirectURL("index.jsp") + "\">manage administrators</a> to update an administrator again.<br /><br />");
                    }

                    PropertyInfoRetriever sair = new PropertyInfoRetriever();
                    String siteAdminEmail = sair.getSiteAdminEmail();

                    out.print("If this happens again, please report it to <a href=\"mailto:" + siteAdminEmail + "\">" + siteAdminEmail + "</a>.");
                }
                /***** END ADMINISTRATOR UPDATED SECTION *****/

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