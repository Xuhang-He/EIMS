package com.demo.servlet;

import com.demo.javabean.UserBean;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

public class AjaxServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/xml");
        response.setHeader("Cache-Control","no-cache");
        String username = request.getParameter("username");

        UserBean userBean = new UserBean();
        boolean isExist = userBean.isExist(username);

        PrintWriter out =response.getWriter();

        if(isExist) {
            out.println("<content>the username already exists!</content>");

        }else{
            out.println("<content>ok</content>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
