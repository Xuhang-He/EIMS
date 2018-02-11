package com.demo.servlet;

import com.demo.javabean.UserBean;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class RegisterServlet extends HttpServlet{

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession();
        String username = req.getParameter("username");
        String password1 = req.getParameter("password1");
        String email = req.getParameter("email");

        UserBean userBean = new UserBean();
        boolean isExist = userBean.isExist(username);

        if (!isExist) {
            userBean.add(username, password1, email);
            session.setAttribute("username", username);
            resp.sendRedirect("welcome.jsp");
        } else {
            resp.sendRedirect("register.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}
