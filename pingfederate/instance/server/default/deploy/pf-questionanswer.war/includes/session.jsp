<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page
        import="java.util.Date,org.apache.commons.lang.StringUtils,com.pingidentity.clientservices.product.administration.questionanswer.utils.PropertyInfoRetriever,com.pingidentity.clientservices.product.administration.questionanswer.auth.AuthenticateUser" %>
<%
	/** modifiable - begin **/
String loginUrl = "https://localhost:9031/pf/adapter2adapter.ping?IdpAdapterId=HTMLFormAdapter&SpSessionAuthnAdapterId=QAReferenceID";
String logoutUrl = "https://localhost:9031/pf-questionanswer/logout.jsp";
/** modifiable - end **/

    PropertyInfoRetriever sair = new PropertyInfoRetriever();
    String siteAdminEmail = sair.getSiteAdminEmail();

    boolean userLoggedIn = false;
    boolean userIsSuperAdmin = false;
    boolean userIsQAAdmin = false;
    boolean userIsHDAdmin = false;
    String loggedInMessage = "";
    String errorMessage = "";

/* 
// BACKUP PLAN IF STICKY SESSIONS AREN'T CONFIGURED PROPERLY - BEGIN
String user = (String) session.getAttribute("SUBJECT");
String role = (String) session.getAttribute("ROLE");
String isUserActive = (String) session.getAttribute("ACTIVE");

if (StringUtils.isBlank(user)) {
	Cookie[] cookies = request.getCookies();
	if (cookies != null) {
		for (Cookie cookie : cookies) {
			String cookieName = cookie.getName();
			String cookieValue = cookie.getValue();
			System.out.print("session.jsp :: cookie name :: " + cookieName + " :: cookie value :: " + cookieValue);
	   		if (cookieName.equalsIgnoreCase("SUBJECT")) {
		   		user = cookieValue;
		   		session.setAttribute("SUBJECT", user);
	   		} else if (cookieName.equalsIgnoreCase("ROLE")) {
	   			role = cookieValue;
	   			session.setAttribute("ROLE", role);
	   		} else if (cookieName.equalsIgnoreCase("ACTIVE")) {
	   			isUserActive = cookieValue;
	   			session.setAttribute("ACTIVE", isUserActive);
	   		}
	    }
	}
}

if (StringUtils.isBlank(user)) {
	AuthenticateUser au = new AuthenticateUser();
	au.authUser(request, response);
}

//need to reset for value to show up after agentless call
user = (String) session.getAttribute("SUBJECT");
System.out.print("session.jsp :: user :: " + user);
role = (String) session.getAttribute("ROLE");
System.out.print("session.jsp :: role :: " + role);
isUserActive = (String) session.getAttribute("ACTIVE");
System.out.print("session.jsp :: active :: " + isUserActive);
// BACKUP PLAN IF STICKY SESSIONS AREN'T CONFIGURED PROPERLY -  END 
*/

    String user = (String) session.getAttribute("SUBJECT");
    if (StringUtils.isBlank(user))
    {
        AuthenticateUser au = new AuthenticateUser();
        au.authUser(request, response);
    }
    user = (String) session.getAttribute("SUBJECT"); // need to reset for value to show up after agentless call

    if (StringUtils.isNotBlank(user))
    {
        // set userLoggedIn to true
        userLoggedIn = true;
        user = user.toLowerCase();
        loggedInMessage = "<p align=\"right\"><font size=\"2\">[ logged in as " + user + " | <a href=\"" + logoutUrl + "\">logout</a> ]</font></p><br />";

        // set user role
        String role = (String) session.getAttribute("ROLE");
        if (StringUtils.isNotBlank(role))
        {
            if (role.equalsIgnoreCase("ADMIN"))
            {
                userIsSuperAdmin = true;
            } else if (role.equalsIgnoreCase("QAADMIN"))
            {
                userIsQAAdmin = true;
            } else if (role.equalsIgnoreCase("HELPDESK"))
            {
                userIsHDAdmin = true;
            }
        }
	
	/*
	// set session max inactivity interval
	System.out.print("**********BEGIN SESSION DATA PRINT OUT**********");
	session.setMaxInactiveInterval(sair.getSessionMaxInactivityInterval()*60);
	Date sessionCreationDate = new Date(session.getCreationTime());
	System.out.println("Session created at :: " + sessionCreationDate);
	Date sessionLastAccessed = new Date(session.getLastAccessedTime());
	System.out.println("Session last accessed at :: " + sessionLastAccessed);
	System.out.println("Session ID :: " + session.getId());
	int sessionMaxInactiveInterval = session.getMaxInactiveInterval()/60;
	System.out.println("Session Max Inactivity Interval set to :: " + sessionMaxInactiveInterval + " min");
	System.out.print("**********END SESSION DATA PRINT OUT**********");
	*/

        // set not authorized message for users that do not have the higher roles
        if (userLoggedIn && (!userIsSuperAdmin || !userIsQAAdmin || !userIsHDAdmin))
        {
            errorMessage = "Apologies, you are not authorized to view this page.<br /><br />If you have reached this message in error, please contact ";
            errorMessage += "<a href=\"mailto:" + siteAdminEmail + "\">" + siteAdminEmail + "</a>.";
        }
    } else
    {
        // get target URL
        String targetUrl = request.getRequestURL().toString();

        // append queryStr if not null
        String queryStr = request.getQueryString();
        if (StringUtils.isNotBlank(queryStr))
        {
            targetUrl += "?" + queryStr;
        }

        // append targetUrl to loginUrl if not null
        if (StringUtils.isNotBlank(targetUrl))
        {
            loginUrl += "&TargetResource=" + response.encodeRedirectURL(targetUrl);
        }

        // append active versus inactive message
        String isUserActive = (String) session.getAttribute("ACTIVE");
        if (StringUtils.isNotBlank(isUserActive) && isUserActive.equalsIgnoreCase("false"))
        {
            errorMessage = "Your account is in an inactive state.<br /><br />";
            errorMessage += "If you think you may have reached this message in error, please try <a href=\"" + loginUrl + "\">logging in</a> again.<br /><br />";
            errorMessage += "Otherwise, please contact <a href=\"mailto:" + siteAdminEmail + "\">" + siteAdminEmail + "</a> to activate your account.";
        } else
        {
            errorMessage = "Your session has expired or your account does not exist.<br /><br />";
            errorMessage += "If your session has expired, please <a href=\"" + loginUrl + "\">login</a> to view this page.<br /><br />";
            errorMessage += "If you need an account created, or are still encountering issues, please contact <a href=\"mailto:" + siteAdminEmail + "\">" + siteAdminEmail + "</a>.";
        }
    }

// set session attributes
    session.setAttribute("USER_ACCESS_GRANTED", userLoggedIn);
    session.setAttribute("USERNAME", user);
    session.setAttribute("USER_ROLE_SUPER_ADMIN", userIsSuperAdmin);
    session.setAttribute("USER_ROLE_QA_ADMIN", userIsQAAdmin);
    session.setAttribute("USER_ROLE_HD_ADMIN", userIsHDAdmin);
    session.setAttribute("SESSION_LOGGEDIN_MESSAGE", loggedInMessage);
    session.setAttribute("SESSION_ERROR_MESSAGE", errorMessage);
%>