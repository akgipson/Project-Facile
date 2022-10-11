<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page
        import="org.apache.commons.lang.StringUtils,com.pingidentity.clientservices.product.administration.questionanswer.utils.PropertyInfoRetriever,com.pingidentity.clientservices.product.administration.questionanswer.ManageUsers,com.pingidentity.clientservices.product.administration.questionanswer.ManageAnswers,com.pingidentity.clientservices.product.administration.questionanswer.email.SendEmail" %>
<html lang="$locale.getLanguage()" dir="ltr">
<head>
    <title>Question & Answer Administration: Manage Users Answers - Answers Reset</title>
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
        <%
            out.print(session.getAttribute("SESSION_LOGGEDIN_MESSAGE"));
        %>
        <font color="#136383"><b>Manage Users Answers - Answers Reset</b></font><br/><br/>
        <%
            if (session.getAttribute("USER_ACCESS_GRANTED").toString().equalsIgnoreCase("true") && (
                    session.getAttribute("USER_ROLE_SUPER_ADMIN").toString().equalsIgnoreCase("true") ||
                            session.getAttribute("USER_ROLE_HD_ADMIN").toString().equalsIgnoreCase("true")))
            {

                /***** BEGIN ANSWERS RESET DISPLAY *****/
                PropertyInfoRetriever sair = new PropertyInfoRetriever();
                String siteAdminEmail = sair.getSiteAdminEmail();

                String errorMessage = "If this happened in error, please report it to <a href=\"mailto:" + siteAdminEmail + "\">" + siteAdminEmail + "</a>.";

                String userId = request.getParameter("uid");
                if (StringUtils.isNotBlank(userId) && StringUtils.isNumeric(userId))
                {
                    int uid = Integer.parseInt(userId);

                    String user = (String) session.getAttribute("USERNAME");

                    ManageUsers mu = new ManageUsers();
                    uid = mu.queryForUserId(uid, user);
                    if (uid != 0)
                    {
                        String username = mu.queryUserForUsername(uid, user);

                        ManageAnswers ma = new ManageAnswers();
                        if (ma.answersExist(uid, user))
                        {
                            ma.resetAnswers(uid, user);
                            out.print("Questions, answers, and answer attempts have been reset for <font color=\"red\">" + username + "</font>.");

                            // email info
                            String subject = "Your questions and answers have been reset";
                            String content = "Your question and answers have been reset.<br /><br />If you are unaware of these changes, please report it to <a href=\"mailto:" + siteAdminEmail + "\">" + siteAdminEmail + "</a>.";

                            SendEmail se = new SendEmail();
                            se.sendEmail(mu.queryUserForEmail(uid, user), subject, content, user);
                        } else
                        {
                            out.print("No questions and answers exist for <font color=\"red\">" + username + "</font>. Therefore, none were reset.");
                        }
                    } else
                    {
                        out.print("Answers cannot be reset for an invalid user ID.<br /><br />");
                        out.print(errorMessage);
                    }
                } else
                {
                    out.print("Answers cannot be reset for a null user ID.<br /><br />");
                    out.print(errorMessage);
                }
                /***** END ANSWERS RESET DISPLAY *****/

                out.print("<br /><br /><center>[ <a href=\"" + response.encodeRedirectURL("searchusers.jsp") + "\">manage users answers</a> ]</center>");
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