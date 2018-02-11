<%@ page pageEncoding="UTF-8"%>
<%@page import="com.demo.javabean.AddressBean"%>
<%
	String method = request.getParameter("method");// 操作方法
	String topage = "../address.jsp";// 跳转页地址
	// 未登录时跳转到登录页面
	if (session.getAttribute("username") == null) {
		topage = "../login.jsp";
	} else {
		String username = (String) session.getAttribute("username");// 当前登录用户名

		// 取得分页参数
		String pageSize = request.getParameter("pageSize");// 每页显示行数
		String pageNo = request.getParameter("pageNo");// 当前显示页次
		if (pageSize == null) {// 为空时设置默认页大小为25
			pageSize = "25";
		}
		if (pageNo == null) {// 为空时设置默认为第1页
			pageNo = "1";
		}
		// 保存分页参数，传递给下一个页面
		request.setAttribute("pageSize", pageSize);
		request.setAttribute("pageNo", pageNo);

		// 根据method参数执行各种操作
		AddressBean addressBean = new AddressBean();
		
		if (method.equals("list")) {// 列表操作
			// 查询数据
			addressBean.list(request, username, pageSize, pageNo);
			topage = "../address.jsp";// 跳到列表页
		} else if (method.equals("delete")) {// 删除操作
			// 执行删除
			addressBean.delete(request, username);
			// 查询数据
			addressBean.list(request, username, pageSize, pageNo);
			topage = "../address.jsp";// 跳到列表页
		} else if (method.equals("add")) {// 新增操作
			topage = "../address_add.jsp";// 跳到新增页
		} else if (method.equals("insert")) {// 插入操作
			// 执行插入
			addressBean.insert(request, username);
			// 查询数据
			addressBean.list(request, username, pageSize, pageNo);
			topage = "../address.jsp";// 跳到列表页
		} else if (method.equals("edit")) {// 修改操作
			// 执行查询
			addressBean.select(request, username);
			topage = "../address_edit.jsp";// 跳到修改页
		} else if (method.equals("update")) {// 更新操作
			// 更新数据
			addressBean.update(request, username);
			// 查询数据
			addressBean.list(request, username, pageSize, pageNo);
			topage = "../address.jsp";// 跳到列表页
		}
	}
%>
<jsp:forward page="<%=topage%>" />
