<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page
        import="org.apache.commons.lang.StringUtils, java.util.HashMap, java.util.Iterator, com.pingidentity.clientservices.product.administration.questionanswer.utils.PropertyInfoRetriever, java.util.Map,com.pingidentity.clientservices.product.administration.questionanswer.ManageUsers,com.pingidentity.clientservices.product.administration.questionanswer.ManageQuestions, com.pingidentity.clientservices.product.administration.questionanswer.Question, com.pingidentity.clientservices.product.administration.questionanswer.ManageAnswers, com.pingidentity.clientservices.product.administration.questionanswer.Answer" %>
<html lang="$locale.getLanguage()" dir="ltr">
<head>
    <title>Question & Answer Administration: Manage My Answers</title>
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
        <font color="#136383"><b>Manage My Answers</b></font><br/><br/>
        <%
            String username = (String) session.getAttribute("USERNAME");
            if (session.getAttribute("USER_ACCESS_GRANTED").toString().equalsIgnoreCase("true") && StringUtils.isNotBlank(username))
            {

                /***** BEGIN ANSWERS DISPLAY *****/
                String user = (String) session.getAttribute("USERNAME");
                String transactionType = "update"; // default
        %>
        <form method="post" action="<%=response.encodeRedirectURL("answersupdated.jsp")%>">
            <table border="0" align="center" width="100%">
                <%
                    String errorMessage = request.getParameter("errMsg");
                    if (StringUtils.isNotBlank(errorMessage))
                    {
                        String[] errMsgArray = errorMessage.split("\\|");
                        String errorMessageDisplay = "";
                        // note that lengths will need to be modified below if there are more than 10 q&as!
                        for (String errMsg : errMsgArray)
                        {
                            if (errMsg.contains("INVALID_QUESTION_ID") && errMsg.length() == 21)
                            {
                                String num = errMsg.substring(20, 21);
                                errorMessageDisplay += "Please select a question for Question #" + num + ".<br /><br />";
                            }

                            if (errMsg.contains("INVALID_ANSWER") && errMsg.length() == 16)
                            {
                                String num = errMsg.substring(15, 16);
                                errorMessageDisplay += "Please enter a valid answer for Answer #" + num + ". Answer must be a minimum of 3 characters and cannot be the same answer you have used for a different question.<br /><br />";
                            }

                            if (errMsg.contains("INVALID_ANSWERCONFIRM") && errMsg.length() == 23)
                            {
                                String num = errMsg.substring(22, 23);
                                errorMessageDisplay += "Please enter a valid answer for Confirm Answer #" + num + ". Confirm Answer #" + num + " must match Answer #" + num + " (case and punctuation matter).<br /><br />";
                            }

                            if (errMsg.contains("INVALID_QUESTION_ID_DUPLICATE"))
                            {
                                errorMessageDisplay += "The same question cannot be used more than once. Please choose a different question.<br /><br />";
                            }

                            if (errMsg.contains("INVALID_ANSWER_DUPLICATE"))
                            {
                                errorMessageDisplay += "The same answer cannot be entered more than once for a different question. Please enter a different answer.<br /><br />";
                            }
                        }
                %>
                <tr>
                    <td valign="top" colspan="2"><font color="red"><b><%out.print(errorMessageDisplay);%></b></font>
                    </td>
                </tr>
                <tr>
                    <td valign="top" colspan="2"><br/></td>
                </tr>
                <%
                    }

                    // get properties
                    PropertyInfoRetriever pir = new PropertyInfoRetriever();

                    // get questions
                    ManageQuestions mq = new ManageQuestions();
                    HashMap<Integer, Question> questions = mq.queryActiveQuestions(user);

                    // get answers
                    ManageAnswers ma = new ManageAnswers();
                    HashMap<Integer, Answer> answers = ma.queryAnswers(username, user);
                    if (answers != null && !answers.isEmpty())
                    { // display from db (update transaction type)
                        // remove additional answers if there are more answers than number of questions for user property
                        if (pir.getNumberOfQuestions() != 0 && pir.getNumberOfQuestions() < answers.size())
                        {
                            // calculate the number of answers to delete
                            int numberOfQAndAsToDelete = answers.size() - pir.getNumberOfQuestions();

                            // get the uid
                            ManageUsers mu = new ManageUsers();
                            int uid = mu.queryUserForUserId(username, user);

                            // delete the extra answers
                            ma.deleteAnswer(uid, numberOfQAndAsToDelete, user);

                            // reset answers
                            answers = ma.queryAnswers(username, user);
                        }

                        String formSubmitted = request.getParameter("formSubmitted");

                        Iterator ita = answers.entrySet().iterator();
                        while (ita.hasNext())
                        {
                            Map.Entry<Integer, Answer> answerPair = (Map.Entry<Integer, Answer>) ita.next();
                            Answer answer = answerPair.getValue();
                            String aqid = answer.getQuestionId() + "";
                            int numberOfSelectedQuestions = 0;
                %>
                <tr>
                    <td valign="top"><font size="2">Question #<%out.print(answerPair.getKey());%>:</font></td>
                </tr>
                <tr>
                    <td valign="top">
                        <select name="question<%out.print(answerPair.getKey());%>">
                            <option value="0"><<--please select one-->></option>
                            <%
                                String options = "";
                                if (questions != null && !questions.isEmpty())
                                {
                                    Iterator itq = questions.entrySet().iterator();

                                    while (itq.hasNext())
                                    {
                                        Map.Entry<Integer, Question> questionPair = (Map.Entry<Integer, Question>) itq.next();
                                        Question question = questionPair.getValue();
                                        String qid = question.getQuestionId() + "";

                                        if (StringUtils.isBlank(formSubmitted))
                                        {
                                            if (aqid.equalsIgnoreCase(qid))
                                            {
                                                options += "<option value=\"" + qid + "\" selected>" + question.getQuestion() + "</option>";

                                                numberOfSelectedQuestions++;
                                            } else
                                            {
                                                options += "<option value=\"" + qid + "\">" + question.getQuestion() + "</option>";
                                            }
                                        } else
                                        {
                                            String questionName = "question" + answerPair.getKey();
                                            String questionValue = request.getParameter(questionName);
                                            if (StringUtils.isNotBlank(questionValue) && questionValue.equalsIgnoreCase(qid))
                                            {
                                                options += "<option value=\"" + qid + "\" selected>" + question.getQuestion() + "</option>";
                                            } else
                                            {
                                                options += "<option value=\"" + qid + "\">" + question.getQuestion() + "</option>";
                                            }
                                        }
                                    }
                                }

                                out.print(options);
                            %>
                        </select>
                        <%
                            String questionIsInactiveHidden = request.getParameter("questionIsInactive" + answerPair.getKey());
                            if (StringUtils.isBlank(formSubmitted))
                            {
                                if (numberOfSelectedQuestions == 0)
                                {
                                    out.print("<br /><font color=\"red\" size=\"1\">(your previously answered question was either reset or deactivated, please choose a new one)</font>");
                                    questionIsInactiveHidden = "true";
                                } else
                                {
                                    questionIsInactiveHidden = "false";
                                }
                            }
                        %>
                        <input type="hidden" name="questionIsInactive<%out.print(answerPair.getKey());%>"
                               value="<%out.print(questionIsInactiveHidden);%>">
                    </td>
                </tr>
                <%
                    String answerToDisplay = request.getParameter("answer" + answerPair.getKey());
                    if (StringUtils.isBlank(formSubmitted))
                    {
                        if (numberOfSelectedQuestions == 0)
                        {
                            answerToDisplay = "";
                        } else
                        {
                            answerToDisplay = answer.getAnswer();
                            if (StringUtils.isNotBlank(answerToDisplay))
                            {
                                answerToDisplay = "********";
                            }
                        }
                    }

                    if (StringUtils.isBlank(answerToDisplay))
                    {
                        answerToDisplay = "";
                    }

                    String answerConfirmToDisplay = request.getParameter("answerConfirm" + answerPair.getKey());
                    if (StringUtils.isBlank(answerConfirmToDisplay))
                    {
                        answerConfirmToDisplay = "";
                    }
                %>
                <tr>
                    <td valign="top"><font size="2">Answer to Question #<%out.print(answerPair.getKey());%>
                        :&nbsp;</font></td>
                </tr>
                <tr>
                    <td valign="top">
                        <input type="text" name="answer<%out.print(answerPair.getKey());%>" size="35"
                               value="<%out.print(answerToDisplay);%>"/>
                        <input type="hidden" name="answerId<%out.print(answerPair.getKey());%>"
                               value="<%out.print(answer.getAnswerId());%>"/>
                    </td>
                </tr>
                <tr>
                    <td valign="top"><font size="2">Confirm Answer to Question #<%out.print(answerPair.getKey());%>:&nbsp;</font>
                    </td>
                </tr>
                <tr>
                    <td valign="top">
                        <input type="text" name="answerConfirm<%out.print(answerPair.getKey());%>" size="35"
                               value="<%out.print(answerConfirmToDisplay);%>"/>
                    </td>
                </tr>
                <tr>
                    <td valign="top"><br/></td>
                </tr>
                <%
                    }

                    // append addtional questions and answers if numberOfQuestions change in properties file
                    if (pir.getNumberOfQuestions() != 0 && pir.getNumberOfQuestions() > answers.size())
                    {
                        int numberOfQAToAdd = pir.getNumberOfQuestions() - answers.size();
                        int startingQANumber = answers.size();

                        for (int j = 0; j < numberOfQAToAdd; j++)
                        {
                            startingQANumber++;
                %>
                <tr>
                    <td valign="top"><font size="2">Question #<%out.print(startingQANumber);%>:</font></td>
                </tr>
                <tr>
                    <td valign="top">
                        <select name="question<%out.print(startingQANumber);%>">
                            <option value="0"><<--please select one-->></option>
                            <%
                                String options = "";
                                if (questions != null && !questions.isEmpty())
                                {
                                    Iterator itq = questions.entrySet().iterator();

                                    while (itq.hasNext())
                                    {
                                        Map.Entry<Integer, Question> questionPair = (Map.Entry<Integer, Question>) itq.next();
                                        Question question = questionPair.getValue();
                                        String qid = question.getQuestionId() + "";

                                        if (StringUtils.isBlank(formSubmitted))
                                        {
                                            options += "<option value=\"" + qid + "\">" + question.getQuestion() + "</option>";
                                        } else
                                        {
                                            String questionName = "question" + startingQANumber;
                                            String questionValue = request.getParameter(questionName);
                                            if (StringUtils.isNotBlank(questionValue) && questionValue.equalsIgnoreCase(qid))
                                            {
                                                options += "<option value=\"" + qid + "\" selected>" + question.getQuestion() + "</option>";
                                            } else
                                            {
                                                options += "<option value=\"" + qid + "\">" + question.getQuestion() + "</option>";
                                            }
                                        }
                                    }
                                }

                                out.print(options);
                            %>
                        </select>
                        <input type="hidden" name="questionIsInactive<%out.print(startingQANumber);%>" value="false">
                    </td>
                </tr>
                <%
                    String answerToDisplay = request.getParameter("answer" + startingQANumber);
                    if (StringUtils.isBlank(answerToDisplay))
                    {
                        answerToDisplay = "";
                    }

                    String answerConfirmToDisplay = request.getParameter("answerConfirm" + startingQANumber);
                    if (StringUtils.isBlank(answerConfirmToDisplay))
                    {
                        answerConfirmToDisplay = "";
                    }
                %>
                <tr>
                    <td valign="top"><font size="2">Answer to Question #<%out.print(startingQANumber);%>:&nbsp;</font>
                    </td>
                </tr>
                <tr>
                    <td valign="top">
                        <input type="text" name="answer<%out.print(startingQANumber);%>" size="35"
                               value="<%out.print(answerToDisplay);%>"/>
                        <input type="hidden" name="answerId<%out.print(startingQANumber);%>" value="0"/>
                    </td>
                </tr>
                <tr>
                    <td valign="top"><font size="2">Confirm Answer to Question #<%out.print(startingQANumber);%>
                        :&nbsp;</font></td>
                </tr>
                <tr>
                    <td valign="top">
                        <input type="text" name="answerConfirm<%out.print(startingQANumber);%>" size="35"
                               value="<%out.print(answerConfirmToDisplay);%>"/>
                    </td>
                </tr>
                <tr>
                    <td valign="top"><br/></td>
                </tr>
                <%
                        }
                    }

                    int numberOfQuestionsTotal = 0;
                    if (pir.getNumberOfQuestions() >= answers.size())
                    {
                        numberOfQuestionsTotal = pir.getNumberOfQuestions();
                    } else
                    {
                        numberOfQuestionsTotal = answers.size();
                    }
                %>
                <tr>
                    <td valign="top"><input type="hidden" name="numberOfQuestionsTotal"
                                            value="<%out.print(numberOfQuestionsTotal);%>"/></td>
                </tr>
                <%
                } else
                { // no answers exist for user, display default (insert transaction type)
                    transactionType = "insert";

                    for (int i = 0; i < ma.getNumberOfQuestion(); i++)
                    {
                        int num = i + 1;
                        String questionName = "question" + num;
                        String questionValue = request.getParameter(questionName);
                        String answerName = "answer" + num;
                        String answerValue = request.getParameter(answerName);
                        String answerConfirmName = "answerConfirm" + num;
                        String answerConfirmValue = request.getParameter(answerConfirmName);
                %>
                <tr>
                    <td valign="top"><font size="2">Question #<%out.print(num);%>:</font></td>
                </tr>
                <tr>
                    <td valign="top">
                        <select name="<%out.print(questionName);%>">
                            <option value="0"><<--please select one-->></option>
                            <%
                                String options = "";
                                if (questions != null && !questions.isEmpty())
                                {
                                    Iterator it = questions.entrySet().iterator();

                                    while (it.hasNext())
                                    {
                                        Map.Entry<Integer, Question> pair = (Map.Entry<Integer, Question>) it.next();
                                        Question question = pair.getValue();
                                        String qid = question.getQuestionId() + "";
                                        qid = qid.trim();

                                        if (StringUtils.isNotBlank(questionValue) && questionValue.equalsIgnoreCase(qid))
                                        {
                                            options += "<option value=\"" + qid + "\" selected>" + question.getQuestion() + "</option>";
                                        } else
                                        {
                                            options += "<option value=\"" + qid + "\">" + question.getQuestion() + "</option>";
                                        }
                                    }
                                }

                                out.print(options);
                            %>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td valign="top"><font size="2">Answer to Question #<%out.print(num);%>:</font></td>
                </tr>
                <tr>
                    <td valign="top"><input type="text" size="35" name="<%out.print(answerName);%>"
                                            value="<%if (StringUtils.isNotBlank(answerValue)) out.print(answerValue);%>"/>
                    </td>
                </tr>
                <tr>
                    <td valign="top"><font size="2">Confirm Answer to Question #<%out.print(num);%>:</font></td>
                </tr>
                <tr>
                    <td valign="top"><input type="text" size="35" name="<%out.print(answerConfirmName);%>"
                                            value="<%if (StringUtils.isNotBlank(answerConfirmValue)) out.print(answerConfirmValue);%>"/>
                    </td>
                </tr>
                <tr>
                    <td valign="top"><br/></td>
                </tr>
                <%
                        }
                    }
                %>
                <tr>
                    <td valign="top" align="center">
                        <input type="hidden" name="formSubmitted" value="yes"/>
                        <input type="hidden" name="processType" value="<%=request.getParameter("processType")%>"/>
                        <input type="hidden" name="ssoTargetUrl" value="<%=request.getParameter("ssoTargetUrl")%>"/>
                        <input type="hidden" name="transactionType" value="<%out.print(transactionType);%>"/>
                        <input type="submit" name="answersSubmit" class="ping-button normal" value="Submit"/>
                        <a href="<%out.print(response.encodeRedirectURL("../index.jsp"));%>"><input type="button"
                                                                                                    name="answersCancel"
                                                                                                    class="ping-button normal"
                                                                                                    value="Cancel"/></a>
                    </td>
                </tr>
            </table>
        </form>
        <%
                /***** END ANSWERS DISPLAY *****/
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