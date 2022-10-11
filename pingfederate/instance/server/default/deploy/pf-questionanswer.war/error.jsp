<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%String url = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort();%>
<html lang="$locale.getLanguage()" dir="ltr">
<head>
    <title>Question & Answer Administration - Error</title>
    <meta name="robots" content="noindex, nofollow"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="viewport" content="initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
    <link rel="stylesheet" media="all" type="text/css" href="<%out.print(url);%>/assets/css/main.css"/>
</head>
<body>
<div class="ping-container">
    <div class="ping-header">
        Question & Answer Administration
    </div><!-- .ping-header -->
    <div class="ping-body-container">
        <%out.print(session.getAttribute("SESSION_LOGGEDIN_MESSAGE"));%>
        <font color="#136383"><b>Error</b></font><br/><br/>
        You have reached this page in error.<br/><br/>
        <%out.print("<center><font size=\"2\">[ <a href=\"" + response.encodeRedirectURL(url + "/pf-questionanswer/index.jsp") + "\">go back to main</a> ]</font></center>");%>
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