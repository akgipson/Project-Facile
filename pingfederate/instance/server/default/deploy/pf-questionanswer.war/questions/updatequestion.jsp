<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page
        import="org.apache.commons.lang.StringUtils,com.pingidentity.clientservices.product.administration.questionanswer.utils.PropertyInfoRetriever,com.pingidentity.clientservices.product.administration.questionanswer.ManageQuestions,com.pingidentity.clientservices.product.administration.questionanswer.Question" %>
<html lang="$locale.getLanguage()" dir="ltr">
<head>
    <title>Question & Answer Administration: Manage Questions - Update Question</title>
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
        <font color="#136383"><b>Manage Questions - Update Question</b></font><br/><br/>
        <%
            if (session.getAttribute("USER_ACCESS_GRANTED").toString().equalsIgnoreCase("true") && (
                    session.getAttribute("USER_ROLE_SUPER_ADMIN").toString().equalsIgnoreCase("true") ||
                            session.getAttribute("USER_ROLE_QA_ADMIN").toString().equalsIgnoreCase("true")))
            {

                /***** BEGIN UPDATE QUESTION SECTION *****/
                PropertyInfoRetriever sair = new PropertyInfoRetriever();
                String siteAdminEmail = sair.getSiteAdminEmail();

                String qid = request.getParameter("qid");
                if (StringUtils.isNotBlank(qid))
                {
                    qid = qid.trim();

                    String user = (String) session.getAttribute("USERNAME");

                    ManageQuestions mq = new ManageQuestions();
                    Question qq = mq.queryQuestion(qid, user);

                    if (qq != null && qq.getQuestionId() != 0)
                    {
                        String questionId = request.getParameter("questionId");
                        String question = request.getParameter("question");
                        String notes = request.getParameter("notes");
                        String activeFlag = request.getParameter("activeFlag");
                        String creationDate = request.getParameter("creationDate");
                        String lastUpdatedDate = request.getParameter("lastUpdatedDate");
                        String deactivatedDate = request.getParameter("deactivatedDate");

                        String formSubmitted = request.getParameter("formSubmitted");
                        if (StringUtils.isBlank(formSubmitted))
                        {
                            questionId = String.valueOf(qq.getQuestionId());
                            question = qq.getQuestion();

                            if (StringUtils.isNotBlank(qq.getNotes()))
                            {
                                notes = qq.getNotes();
                            } else
                            {
                                notes = "";
                            }

                            activeFlag = String.valueOf(qq.getActiveFlag());

                            if (qq.getCreationDate() != null)
                            {
                                creationDate = qq.getCreationDate().toString();
                            } else
                            {
                                creationDate = "";
                            }

                            if (qq.getLastUpdatedDate() != null)
                            {
                                lastUpdatedDate = qq.getLastUpdatedDate().toString();
                            } else
                            {
                                lastUpdatedDate = "";
                            }

                            if (qq.getDeactivatedDate() != null)
                            {
                                deactivatedDate = qq.getDeactivatedDate().toString();
                            } else
                            {
                                deactivatedDate = "";
                            }
                        }
        %>
        <form method="post" action="<%=response.encodeRedirectURL("questionupdated.jsp")%>">
            <table border="0" align="center" cellspacing="0" cellpadding="0">
                <%
                    String errorMessage = request.getParameter("errMsg");
                    if (StringUtils.isNotBlank(errorMessage) && errorMessage.equalsIgnoreCase("INVALID_QUESTION"))
                    {
                %>
                <tr>
                    <td valign="top" colspan="2" align="center"><font color="red"><b><%
                        out.print("Please enter a valid question.");%></b></font></td>
                </tr>
                <tr>
                    <td valign="top" colspan="2"><br/></td>
                </tr>
                <%
                    }
                %>
                <tr>
                    <td valign="top">Question:&nbsp;</td>
                    <td valign="top"><input type="text" name="question" size="35" value="<%out.print(question);%>"/>
                    </td>
                </tr>
                <tr>
                    <td valign="top" colspan="2"><br/></td>
                </tr>
                <tr>
                    <td valign="top">Notes:&nbsp;</td>
                    <td valign="top">
                        <textarea name="notes" rows="8" cols="40"><%out.print(notes);%></textarea>
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
                    <td valign="top">Deactivated Date:&nbsp;</td>
                    <td valign="top"><%out.print(deactivatedDate);%></td>
                </tr>
                <tr>
                    <td valign="top" colspan="2"><br/></td>
                </tr>
                <tr>
                    <td valign="top" colspan="2" align="center">
                        <input type="hidden" name="formSubmitted" value="yes"/>
                        <input type="hidden" name="questionId" value="<%out.print(questionId);%>"/>
                        <input type="hidden" name="creationDate" value="<%out.print(creationDate);%>"/>
                        <input type="hidden" name="lastUpdatedDate" value="<%out.print(lastUpdatedDate);%>"/>
                        <input type="hidden" name="deactivatedDate" value="<%out.print(deactivatedDate);%>"/>
                        <input type="submit" name="questionSubmit" class="ping-button normal" value="Submit"/>
                    </td>
                </tr>
            </table>
        </form>
        <%
                    } else
                    {
                        out.print("Sorry, Question #" + qid + " does not exist. Therefore, it cannot be updated. Please click on <a href=\"" + response.encodeRedirectURL("index.jsp") + "\">manage questions</a> to update a valid question.<br /><br />");
                        out.print("If you feel that you have reached this message in error, please report it to <a href=\"mailto:" + siteAdminEmail + "\">" + siteAdminEmail + "</a>.");
                    }
                } else
                {
                    out.print("Sorry, an invalid question cannot be updated. Please click on <a href=\"" + response.encodeRedirectURL("index.jsp") + "\">manage questions</a> to update a valid question.<br /><br />");
                    out.print("If you feel that you have reached this message in error, please report it to <a href=\"mailto:" + siteAdminEmail + "\">" + siteAdminEmail + "</a>.");
                }
                /***** END UPDATE QUESTION SECTION *****/

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