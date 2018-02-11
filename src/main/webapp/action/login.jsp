<%@ page import="com.demo.javabean.UserBean"%>
<%@ page pageEncoding="UTF-8"%>

<%
//取得参数
String username = request.getParameter("username");
String password = request.getParameter("password");

// 验证登录
UserBean userBean = new UserBean();
boolean isValid = userBean.valid(username, password);

if (isValid) {
	session.setAttribute("username", username);
	response.sendRedirect("../welcome.jsp");
} else {
	response.sendRedirect("../login.jsp");
}
%>