<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page
        import="org.apache.commons.lang.StringUtils,com.pingidentity.clientservices.product.administration.questionanswer.utils.PropertyInfoRetriever,com.pingidentity.clientservices.product.administration.questionanswer.ManageQuestions" %>
<html lang="$locale.getLanguage()" dir="ltr">
<head>
    <title>Question & Answer Administration: Manage Questions - Question Added</title>
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
        <font color="#136383"><b>Manage Questions - Question Added</b></font><br/><br/>
        <%
            if (session.getAttribute("USER_ACCESS_GRANTED").toString().equalsIgnoreCase("true") &&
                    (session.getAttribute("USER_ROLE_SUPER_ADMIN").toString().equalsIgnoreCase("true") ||
                            session.getAttribute("USER_ROLE_QA_ADMIN").toString().equalsIgnoreCase("true")))
            {

                /***** BEGIN QUESTION ADDED SECTION *****/
                String formSubmitted = request.getParameter("formSubmitted");
                String question = request.getParameter("question");
                String notes = request.getParameter("notes");
                String activeFlag = request.getParameter("activeFlag");

                if (StringUtils.isNotBlank(formSubmitted) && formSubmitted.equalsIgnoreCase("yes"))
                {
                    if (StringUtils.isBlank(question) || (StringUtils.isNotBlank(question) && question.length() < 3))
                    {
                        String errorMessage = "INVALID_QUESTION";
                        String redirectUrl = response.encodeRedirectURL("addaquestion.jsp?errMsg=" + errorMessage);
                        request.getRequestDispatcher(redirectUrl).forward(request, response);
                    } else
                    {
                        String user = (String) session.getAttribute("USERNAME");

                        ManageQuestions mq = new ManageQuestions();
                        mq.insertQuestion(question, notes, activeFlag, user);

                        out.print("Your question has been submitted!");
                    }
                } else
                {
                    PropertyInfoRetriever sair = new PropertyInfoRetriever();
                    String siteAdminEmail = sair.getSiteAdminEmail();

                    out.print("An unexpected error has occurred. Please try <a href=\"" + response.encodeRedirectURL("addaquestion.jsp") + "\">adding a question</a> again.<br /><br />");
                    out.print("If this happens again, please report it to <a href=\"mailto:" + siteAdminEmail + "\">" + siteAdminEmail + "</a>.");
                }
                /***** END QUESTION ADDED SECTION *****/

                out.print("<br /><br /><center>[ <a href=\"" + response.encodeRedirectURL("index.jsp") + "\">manage questions</a> | <a href=\"" + response.encodeRedirectURL("addaquestion.jsp") + "\">add a question</a> ]</center>");
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