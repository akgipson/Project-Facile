<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page
        import="java.util.HashMap, java.util.Map, java.util.Iterator, com.pingidentity.clientservices.product.administration.questionanswer.ManageQuestions, com.pingidentity.clientservices.product.administration.questionanswer.Question" %>
<html lang="$locale.getLanguage()" dir="ltr">
<head>
    <title>Question & Answer Administration: Manage Questions</title>
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
        <font color="#136383"><b>Manage Questions</b></font><br/><br/>
        <%
            if (session.getAttribute("USER_ACCESS_GRANTED").toString().equalsIgnoreCase("true") && (
                    session.getAttribute("USER_ROLE_SUPER_ADMIN").toString().equalsIgnoreCase("true") ||
                            session.getAttribute("USER_ROLE_QA_ADMIN").toString().equalsIgnoreCase("true")))
            {

                /***** BEGIN QUESTIONS DISPLAY *****/
                String user = (String) session.getAttribute("USERNAME");

                ManageQuestions mq = new ManageQuestions();
                HashMap<Integer, Question> questions = mq.queryQuestions(user);
                if (questions != null && !questions.isEmpty())
                {
        %>
        <table border="0" align="center" width="100%">
            <tr>
                <td valign="top"><font size="2"><b>#</b></font></td>
                <td valign="top"><font size="2"><b>Question</b></font></td>
                <td valign="top"><font size="2"><b>Active</b></font></td>
            </tr>
            <tr>
                <td colspan="3"><br/></td>
            </tr>
            <%
                Iterator it = questions.entrySet().iterator();
                while (it.hasNext())
                {
                    Map.Entry<Integer, Question> pair = (Map.Entry<Integer, Question>) it.next();
                    Question question = pair.getValue();

                    String active = "yes";
                    if (question.getActiveFlag() == 0)
                    {
                        active = "no";
                    }
            %>
            <tr>
                <td valign="top"><font size="2"><%
                    out.print("<a href=\"" + response.encodeRedirectURL("updatequestion.jsp?qid=" + question.getQuestionId()) + "\">" + question.getQuestionId() + "</a>");%></font>&nbsp;
                </td>
                <td valign="top"><font size="2"><%out.print(question.getQuestion());%></font>&nbsp;</td>
                <td valign="top"><font size="2"><%out.print(active);%></font></td>
            </tr>
            <%
                }
            %>
        </table>
        <%
                } else
                {
                    out.print("No questions exist currently. Click on the link below to start adding questions.");
                }
                /***** END QUESTIONS DISPLAY *****/

                out.print("<br /><br /><center>[ <a href=\"" + response.encodeRedirectURL("addaquestion.jsp") + "\">add a question</a> ]</center>");
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