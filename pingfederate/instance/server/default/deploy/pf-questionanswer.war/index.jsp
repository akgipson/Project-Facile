<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<html lang="$locale.getLanguage()" dir="ltr">
<head>
    <title>Question & Answer Administration</title>
    <meta name="robots" content="noindex, nofollow"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="viewport" content="initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
    <link rel="stylesheet" media="all" type="text/css" href="../assets/css/main.css"/>
</head>
<body>
<jsp:include page="includes/session.jsp"/>
<div class="ping-container">
    <div class="ping-header">
        Question & Answer Administration
    </div><!-- .ping-header -->
    <div class="ping-body-container">
        <%out.print(session.getAttribute("SESSION_LOGGEDIN_MESSAGE"));%>
        <font color="#136383"><b>Home</b></font><br/><br/>
        <%
            if (session.getAttribute("USER_ACCESS_GRANTED").toString().equalsIgnoreCase("true"))
            {
                out.print("Please click on a link below to start managing:<br /><br /><ul>");
                if (session.getAttribute("USER_ROLE_SUPER_ADMIN").toString().equalsIgnoreCase("true"))
                {
                    out.print("<li><a href=\"" + response.encodeRedirectURL("admins/index.jsp") + "\">Manage Admins</a></li>");
                    out.print("<li><a href=\"" + response.encodeRedirectURL("questions/index.jsp") + "\">Manage Questions</a></li>");
                    out.print("<li><a href=\"" + response.encodeRedirectURL("answers/searchusers.jsp") + "\">Manage Users Answers</a></li>");
                } else if (session.getAttribute("USER_ROLE_QA_ADMIN").toString().equalsIgnoreCase("true"))
                {
                    out.print("<li><a href=\"" + response.encodeRedirectURL("questions/index.jsp") + "\">Manage Questions</a></li>");
                } else if (session.getAttribute("USER_ROLE_HD_ADMIN").toString().equalsIgnoreCase("true"))
                {
                    out.print("<li><a href=\"" + response.encodeRedirectURL("answers/searchusers.jsp") + "\">Manage Users Answers</a></li>");
                }

                out.print("<li><a href=\"" + response.encodeRedirectURL("answers/index.jsp") + "\">Manage My Answers</a></li></ul>");
            } else
            {
                out.print("<div class=\"ping-error\">");
                out.print(session.getAttribute("SESSION_ERROR_MESSAGE"));
                out.print("</div>");
            }
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