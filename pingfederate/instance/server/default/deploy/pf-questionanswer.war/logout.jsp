<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%
/** modifiable - begin **/
String targetUrl = "https://localhost:9031/pf-questionanswer/index.jsp";
String loginUrl = "https://localhost:9031/pf/adapter2adapter.ping?IdpAdapterId=HTMLFormAdapter&SpSessionAuthnAdapterId=QAReferenceID&TargetResource=" + response.encodeRedirectURL(targetUrl);
/** modifiable - end **/

// invalidate user session
    session.invalidate();
    session = null;

/*
// BACKUP PLAN IF STICKY SESSIONS AREN'T CONFIGURED PROPERLY - BEGIN
// delete cookies
Cookie[] cookies = request.getCookies();
if (cookies != null) {
    for (Cookie cookie : cookies) {
        if (cookie.getName().equalsIgnoreCase("SUBJECT")) {
            cookie.setValue(null);
            cookie.setMaxAge(0);
            response.addCookie(cookie);
        } else if (cookie.getName().equalsIgnoreCase("ROLE")) {
            cookie.setValue(null);
            cookie.setMaxAge(0);
            response.addCookie(cookie);
        } else if (cookie.getName().equalsIgnoreCase("ACTIVE")) {
            cookie.setValue(null);
            cookie.setMaxAge(0);
            response.addCookie(cookie);
        }
    }
}
// BACKUP PLAN IF STICKY SESSIONS AREN'T CONFIGURED PROPERLY - END
*/
%>
<html lang="$locale.getLanguage()" dir="ltr">
<head>
    <title>Question & Answer Administration: Logged Out</title>
    <meta name="robots" content="noindex, nofollow"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="viewport" content="initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
    <link rel="stylesheet" media="all" type="text/css" href="../assets/css/main.css"/>
</head>
<body>
<div class="ping-container">
    <div class="ping-header">
        Question & Answer Administration
    </div><!-- .ping-header -->
    <div class="ping-body-container">
        <font color="#136383"><b>Logged Out</b></font><br/><br/>
        You have been logged out. Click <a href="<%=loginUrl%>">here</a> to login again.
        <br/><br/>
        <center><font size="2">[ <a href="index.jsp">go back to main</a> ]</font></center>
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