<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page
        import="java.util.Set, java.util.HashSet, org.apache.commons.lang.StringUtils,com.pingidentity.clientservices.product.administration.questionanswer.utils.PropertyInfoRetriever,com.pingidentity.clientservices.product.administration.questionanswer.utils.StringValidator,com.pingidentity.clientservices.product.administration.questionanswer.ManageUsers,com.pingidentity.clientservices.product.administration.questionanswer.ManageAnswers,com.pingidentity.clientservices.product.administration.questionanswer.email.SendEmail" %>
<html lang="$locale.getLanguage()" dir="ltr">
<head>
    <title>Question & Answer Administration: Manage My Answers - Answers Updated</title>
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
        <font color="#136383"><b>Manage My Answers - Answers Updated</b></font><br/><br/>
        <%
            String username = (String) session.getAttribute("USERNAME");
            if (session.getAttribute("USER_ACCESS_GRANTED").toString().equalsIgnoreCase("true") && StringUtils.isNotBlank(username))
            {

                /***** BEGIN ANSWERS UPDATED SECTION *****/
                PropertyInfoRetriever sair = new PropertyInfoRetriever();
                String siteAdminEmail = sair.getSiteAdminEmail();

                String postTransactionErrorMessage = "An unexpected error has occurred. Please click on <a href=\"" + response.encodeRedirectURL("index.jsp") + "\">manage answers</a> to update your answers again.<br /><br />";
                postTransactionErrorMessage += "If this happens again, please report it to <a href=\"mailto:" + siteAdminEmail + "\">" + siteAdminEmail + "</a>.";

                boolean redirectToQASSO = false;
                String processType = request.getParameter("processType");
                String ssoTargetUrl = response.encodeRedirectURL(request.getParameter("ssoTargetUrl"));
                if (StringUtils.isNotBlank(processType) && processType.equalsIgnoreCase("initial") && StringUtils.isNotBlank(ssoTargetUrl))
                {
                    redirectToQASSO = true;
                }

                String formSubmitted = request.getParameter("formSubmitted");
                if (StringUtils.isNotBlank(formSubmitted) && formSubmitted.equalsIgnoreCase("yes"))
                {
                    String transactionType = request.getParameter("transactionType");
                    if (StringUtils.isNotBlank(transactionType))
                    {
                        transactionType = transactionType.trim();

                        String user = (String) session.getAttribute("USERNAME");

                        String errorMessage = "";

                        ManageUsers mu = new ManageUsers();
                        int uid = mu.queryUserForUserId(username, user);

                        if (uid != 0)
                        {
                            // email info
                            String subject = "Changes have been made to your questions and answers";
                            String content = "Changes have been made to your questions and answers.<br /><br />If you are unaware of these changes, please report it to <a href=\"mailto:" + siteAdminEmail + "\">" + siteAdminEmail + "</a>.";

                            ManageAnswers ma = new ManageAnswers();
                            if (transactionType.equalsIgnoreCase("insert"))
                            {
                                /** BEGIN: validation for insert **/
                                Set<String> questionIdsToCheck = new HashSet<String>();
                                Set<String> answersToCheck = new HashSet<String>();

                                for (int i = 0; i < ma.getNumberOfQuestion(); i++)
                                {
                                    int num = i + 1;

                                    String questionFieldName = "question" + num;
                                    String questionId = request.getParameter(questionFieldName);
                                    questionIdsToCheck.add(questionId);

                                    String answerFieldName = "answer" + num;
                                    String answer = request.getParameter(answerFieldName);
                                    answersToCheck.add(answer);

                                    String answerConfirmFieldName = "answerConfirm" + num;
                                    String answerConfirm = request.getParameter(answerConfirmFieldName);

                                    if (StringUtils.isBlank(questionId) || (StringUtils.isNotBlank(questionId) && questionId.equalsIgnoreCase("0")))
                                    {
                                        errorMessage += "INVALID_QUESTION_ID_" + num + "|";
                                    }

                                    if (StringUtils.isBlank(answer) || (StringUtils.isNotBlank(answer) && (answer.length() < 3 || StringValidator.hasConsecutiveCharacters(answer))))
                                    {
                                        errorMessage += "INVALID_ANSWER_" + num + "|";
                                    }

                                    if (StringUtils.isBlank(answerConfirm) || (StringUtils.isNotBlank(answerConfirm) && StringUtils.isNotBlank(answer) && !answerConfirm.equals(answer)))
                                    {
                                        errorMessage += "INVALID_ANSWERCONFIRM_" + num + "|";
                                    }
                                }

                                if (questionIdsToCheck.size() != ma.getNumberOfQuestion())
                                {
                                    errorMessage += "INVALID_QUESTION_ID_DUPLICATE|";
                                }

                                if (answersToCheck.size() != ma.getNumberOfQuestion())
                                {
                                    errorMessage += "INVALID_ANSWER_DUPLICATE";
                                }
                                //System.out.print("questionIdsToCheck :: " + questionIdsToCheck.size());
                                //System.out.print("answersToCheck :: " + answersToCheck.size());
                                /** END: validation for insert **/

                                if (StringUtils.isNotBlank(errorMessage))
                                {
                                    String redirectUrl = response.encodeRedirectURL("index.jsp?errMsg=" + errorMessage);
                                    request.getRequestDispatcher(redirectUrl).forward(request, response);
                                } else
                                {
                                    for (int i = 0; i < ma.getNumberOfQuestion(); i++)
                                    {
                                        int num = i + 1;

                                        String questionFieldName = "question" + num;
                                        String questionId = request.getParameter(questionFieldName);

                                        String answerFieldName = "answer" + num;
                                        String answer = request.getParameter(answerFieldName);

                                        if (!ma.allAnswersExist(uid, user))
                                        {
                                            ma.insertAnswer(questionId, answer, uid, user);
                                        }
                                    }

                                    SendEmail se = new SendEmail();
                                    se.sendEmail(mu.queryUserForEmail(uid, user), subject, content, user);

                                    if (redirectToQASSO)
                                    {
                                        response.sendRedirect(ssoTargetUrl);
                                    } else
                                    {
                                        out.print("Your questions and answers have been updated!");
                                    }
                                }
                            } else if (transactionType.equalsIgnoreCase("update"))
                            {
                                /** BEGIN: validation for update **/
                                String numberOfQuestionsTotalStr = request.getParameter("numberOfQuestionsTotal");
                                int numberOfQuestionsTotal = 0;
                                if (StringUtils.isNotBlank(numberOfQuestionsTotalStr))
                                {
                                    numberOfQuestionsTotal = Integer.parseInt(numberOfQuestionsTotalStr);
                                }

                                Set<String> questionIdsToCheck = new HashSet<String>();
                                Set<String> answersToCheck = new HashSet<String>();

                                for (int i = 0; i < numberOfQuestionsTotal; i++)
                                {
                                    int num = i + 1;

                                    String answerIdFieldName = "answerId" + num;
                                    String answerId = request.getParameter(answerIdFieldName);

                                    String questionFieldName = "question" + num;
                                    String questionId = request.getParameter(questionFieldName);
                                    questionIdsToCheck.add(questionId);

                                    String questionIsInactiveFieldName = "questionIsInactive" + num;
                                    String questionIsInactive = request.getParameter(questionIsInactiveFieldName);

                                    String answerFieldName = "answer" + num;
                                    String answer = request.getParameter(answerFieldName);

                                    String answerConfirmFieldName = "answerConfirm" + num;
                                    String answerConfirm = request.getParameter(answerConfirmFieldName);

                                    if (StringUtils.isBlank(questionId) || (StringUtils.isNotBlank(questionId) && questionId.equalsIgnoreCase("0")))
                                    {
                                        errorMessage += "INVALID_QUESTION_ID_" + num + "|";
                                    }

                                    if (StringUtils.isBlank(answer))
                                    {
                                        // add answer to answersToCheck
                                        answersToCheck.add(answer);

                                        errorMessage += "INVALID_ANSWER_" + num + "|";
                                    } else
                                    {
                                        if (!answer.equalsIgnoreCase("********"))
                                        {
                                            // add answer to answersToCheck
                                            answersToCheck.add(answer);

                                            if (answer.length() < 3 || StringValidator.hasConsecutiveCharacters(answer) || ma.doesAnswerMatch(uid, questionId, answer, user))
                                            {
                                                errorMessage += "INVALID_ANSWER_" + num + "|";
                                            }

                                            if (StringUtils.isBlank(answerConfirm) || (StringUtils.isNotBlank(answerConfirm) && !answerConfirm.equals(answer)))
                                            {
                                                errorMessage += "INVALID_ANSWERCONFIRM_" + num + "|";
                                            }
                                        } else
                                        {
                                            // append num to the 8 asterisks (********), so that answers are different in order to check size below
                                            answersToCheck.add(answer + num);

                                            if (StringUtils.isNotBlank(questionIsInactive) && questionIsInactive.equalsIgnoreCase("true") && answer.equalsIgnoreCase("********"))
                                            {
                                                errorMessage += "INVALID_ANSWER_" + num + "|";
                                            }

                                            if (StringUtils.isNotBlank(answerConfirm) && !answerConfirm.equalsIgnoreCase(answer))
                                            {
                                                errorMessage += "INVALID_ANSWERCONFIRM_" + num + "|";
                                            }
                                        }
                                    }
                                }

                                if (questionIdsToCheck.size() != numberOfQuestionsTotal)
                                {
                                    errorMessage += "INVALID_QUESTION_ID_DUPLICATE|";
                                }

                                if (answersToCheck.size() != numberOfQuestionsTotal)
                                {
                                    errorMessage += "INVALID_ANSWER_DUPLICATE";
                                }
                                //System.out.print("questionIdsToCheck :: " + questionIdsToCheck.size());
                                //System.out.print("answersToCheck :: " + answersToCheck.size());
                                /** END: validation for update **/

                                if (StringUtils.isNotBlank(errorMessage))
                                {
                                    String redirectUrl = response.encodeRedirectURL("index.jsp?errMsg=" + errorMessage);
                                    request.getRequestDispatcher(redirectUrl).forward(request, response);
                                } else
                                {
                                    int numOfNoUpdatesNeeded = 0;

                                    for (int i = 0; i < numberOfQuestionsTotal; i++)
                                    {
                                        int num = i + 1;

                                        String answerIdFieldName = "answerId" + num;
                                        String answerId = request.getParameter(answerIdFieldName);

                                        String questionFieldName = "question" + num;
                                        String questionId = request.getParameter(questionFieldName);

                                        String answerFieldName = "answer" + num;
                                        String answer = request.getParameter(answerFieldName);

                                        if (!answer.equalsIgnoreCase("********"))
                                        {
                                            if (answerId.equalsIgnoreCase("0"))
                                            {
                                                if (!ma.allAnswersExist(uid, user))
                                                {
                                                    ma.insertAnswer(questionId, answer, uid, user);
                                                }
                                            } else
                                            {
                                                ma.updateAnswer(answerId, uid, questionId, answer, user);
                                            }
                                        } else
                                        {
                                            numOfNoUpdatesNeeded++;
                                        }
                                    }

                                    SendEmail se = new SendEmail();
                                    se.sendEmail(mu.queryUserForEmail(uid, user), subject, content, user);

                                    if (redirectToQASSO)
                                    {
                                        response.sendRedirect(ssoTargetUrl);
                                    } else
                                    {
                                        if (numOfNoUpdatesNeeded == numberOfQuestionsTotal)
                                        {
                                            out.print("No questions and answers have been updated.<br /><br /><u>Note</u>: If you are trying to update a question only, you will need to update both the question and the answer in order for the update to go through.");
                                        } else
                                        {
                                            out.print("Your questions and answers have been updated!");
                                        }
                                    }
                                }
                            } else
                            {
                                out.print(postTransactionErrorMessage);
                                out.print("<br /><br />[invalid transaction type]");
                            }
                        } else
                        {
                            out.print(postTransactionErrorMessage);
                            out.print("<br /><br />[invalid user ID]");
                        }
                    } else
                    {
                        out.print(postTransactionErrorMessage);
                        out.print("<br /><br />[null transaction type]");
                    }
                } else
                {
                    out.print(postTransactionErrorMessage);
                    out.print("<br /><br />[bad form submission]");
                }
                /***** END ANSWERS UPDATED SECTION *****/

                out.print("<br /><br /><center>[ <a href=\"" + response.encodeRedirectURL("index.jsp") + "\">manage my answers</a> ]</center>");
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