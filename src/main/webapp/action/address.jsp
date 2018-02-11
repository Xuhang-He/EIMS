<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Hashtable"%>
<%@page import="java.util.List"%>
<%@ include file="../inc/db.jsp"%>
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
		if (method.equals("list")) {// 列表操作
			// 查询数据
			list(request, drv, url, usr, pwd, username, pageSize,
					pageNo);
			topage = "../address.jsp";// 跳到列表页
		} else if (method.equals("delete")) {// 删除操作
			// 执行删除
			delete(request, drv, url, usr, pwd, username);
			// 查询数据
			list(request, drv, url, usr, pwd, username, pageSize,
					pageNo);
			topage = "../address.jsp";// 跳到列表页
		} else if (method.equals("add")) {// 新增操作
			topage = "../address_add.jsp";// 跳到新增页
		} else if (method.equals("insert")) {// 插入操作
			// 执行插入
			insert(request, drv, url, usr, pwd, username);
			// 查询数据
			list(request, drv, url, usr, pwd, username, pageSize,
					pageNo);
			topage = "../address.jsp";// 跳到列表页
		} else if (method.equals("edit")) {// 修改操作
			// 执行查询
			select(request, drv, url, usr, pwd, username);
			topage = "../address_edit.jsp";// 跳到修改页
		} else if (method.equals("update")) {// 更新操作
			// 更新数据
			update(request, drv, url, usr, pwd, username);
			// 查询数据
			list(request, drv, url, usr, pwd, username, pageSize,
					pageNo);
			topage = "../address.jsp";// 跳到列表页
		}
	}
%>
<jsp:forward page="<%=topage%>" />
<!-- (1)列表函数 -->
<%!public boolean list(HttpServletRequest request, String drv, String url,
			String usr, String pwd, String username, String strPageSize,
			String strPageNo) {
		try {
			// 创建数据库连接
			Class.forName(drv).newInstance();
			Connection conn = DriverManager.getConnection(url, usr, pwd);
			Statement stm = conn.createStatement();

			// 查询总的记录数，计算跳页参数
			int pageSize = Integer.parseInt(strPageSize);
			int pageNo = Integer.parseInt(strPageNo);
			int start = pageSize * (pageNo - 1);
			// 总记录数查询SQL
			String sql1 = "select count(*) as countall from address where username='"
					+ username + "'";
			ResultSet rs1 = stm.executeQuery(sql1);
			if (rs1.next()) {
				//计算总行数并保存
				String countall = rs1.getString("countall");
				int rowCount = Integer.parseInt(countall);
				request.setAttribute("rowCount", rowCount);

				//计算总页数并保存
				int pageCount = rowCount % pageSize == 0 ? rowCount / pageSize
						: rowCount / pageSize + 1;
				request.setAttribute("pageCount", pageCount);

				//计算跳页参数并保存
				int pageFirstNo = 1;// 首页
				int pageLastNo = pageCount;//尾页
				int pagePreNo = pageNo > 1 ? pageNo - 1 : 1;// 前一页
				int pageNextNo = pageNo < pageCount ? pageNo + 1 : pageCount;// 后一页
				request.setAttribute("pageFirstNo", pageFirstNo);
				request.setAttribute("pageLastNo", pageLastNo);
				request.setAttribute("pagePreNo", pagePreNo);
				request.setAttribute("pageNextNo", pageNextNo);
			}
			rs1.close();

			// 取得当前页数据SQL
			String sql2 = "select * from address where username='" + username
					+ "' order by name limit " + start + "," + pageSize;
			List<Hashtable<String, String>> list = new ArrayList<Hashtable<String, String>>();
			ResultSet rs2 = stm.executeQuery(sql2);
			ResultSetMetaData rsmd = rs2.getMetaData();
			int cols = rsmd.getColumnCount();
			while (rs2.next()) {
				// 查询每行数据的各个字段数据
				Hashtable<String, String> hash = new Hashtable<String, String>();
				for (int i = 1; i <= cols; i++) {
					String field = (String) (rsmd.getColumnName(i));// 字段名
					String value = (String) (rs2.getString(i));// 字段值
					if (value == null)
						value = "";
					hash.put(field, value);
				}
				// 保存当前行
				list.add(hash);
			}
			// 保存所有行数据列表传递给下一个页面
			request.setAttribute("list", list);
			rs2.close();
			stm.close();
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		} finally {
		}
		return true;
	}%>
<!-- (2)删除函数 -->
<%!public boolean delete(HttpServletRequest request, String drv, String url,
			String usr, String pwd, String username) {
		try {
			// 创建数据库连接
			Class.forName(drv).newInstance();
			Connection conn = DriverManager.getConnection(url, usr, pwd);
			Statement stm = conn.createStatement();
			// 根据id组成删除SQL，执行删除
			String id = request.getParameter("id");
			String sql = "delete from address where id=" + id;
			stm.executeUpdate(sql);
			stm.close();
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		} finally {
		}
		return true;
	}%>
<!-- (3)新增函数 -->
<%!public boolean insert(HttpServletRequest request, String drv, String url,
			String usr, String pwd, String username) {
		try {
			// 创建数据库连接
			Class.forName(drv).newInstance();
			Connection conn = DriverManager.getConnection(url, usr, pwd);
			Statement stm = conn.createStatement();

			// 取得新增表单参数
			String name = request.getParameter("name");
			String sex = request.getParameter("sex");
			String mobile = request.getParameter("mobile");
			String email = request.getParameter("email");
			String qq = request.getParameter("qq");
			String company = request.getParameter("company");
			String address = request.getParameter("address");
			String postcode = request.getParameter("postcode");

			// 组合新增SQL
			String sql = "insert into address (username, name, sex, mobile, email, qq, company, address, postcode) ";
			sql += " values('" + username + "','" + name + "','" + sex + "','"
					+ mobile + "','" + email + "','" + qq + "','" + company
					+ "','" + address + "','" + postcode + "')";

			// 转换参数编码
			sql = new String(sql.getBytes("ISO8859-1"), "UTF-8");

			// 执行插入
			stm.executeUpdate(sql);
			stm.close();
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		} finally {
		}
		return true;
	}%>
<!-- (4)查询函数 -->
<%!public boolean select(HttpServletRequest request, String drv, String url,
			String usr, String pwd, String username) {
		try {
			// 创建数据库连接
			Class.forName(drv).newInstance();
			Connection conn = DriverManager.getConnection(url, usr, pwd);
			Statement stm = conn.createStatement();

			// 根据id编号查询当前行记录
			String id = request.getParameter("id");
			String sql = "select * from address where id=" + id;
			ResultSet rs = stm.executeQuery(sql);
			if (rs.next()) {
				// 取得各个字段的值并保存
				request.setAttribute("id", (String) (rs.getString("id")));
				request.setAttribute("username", (String) (rs
						.getString("username")));
				request.setAttribute("name", (String) (rs.getString("name")));
				request.setAttribute("sex", (String) (rs.getString("sex")));
				request.setAttribute("mobile", (String) rs.getString("mobile"));
				request.setAttribute("email", (String) rs.getString("email"));
				request.setAttribute("qq", (String) rs.getString("qq"));
				request.setAttribute("company", (String) rs
						.getString("company"));
				request.setAttribute("address", (String) rs
						.getString("address"));
				request.setAttribute("postcode", (String) rs
						.getString("postcode"));
			}
			rs.close();
			stm.close();
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		} finally {
		}
		return true;
	}%>
<!-- (5)更新函数 -->
<%!public boolean update(HttpServletRequest request, String drv, String url,
			String usr, String pwd, String username) {
		try {
			// 创建数据库连接
			Class.forName(drv).newInstance();
			Connection conn = DriverManager.getConnection(url, usr, pwd);
			Statement stm = conn.createStatement();

			// 取得修改页表单参数
			String id = request.getParameter("id");
			String name = request.getParameter("name");
			String sex = request.getParameter("sex");
			String mobile = request.getParameter("mobile");
			String email = request.getParameter("email");
			String qq = request.getParameter("qq");
			String company = request.getParameter("company");
			String address = request.getParameter("address");
			String postcode = request.getParameter("postcode");

			// 组合更新SQL
			String sql = "update address set name='" + name + "', sex='" + sex
					+ "', mobile='" + mobile + "', email='" + email + "', qq='"
					+ qq + "', company='" + company + "', address='" + address
					+ "', postcode='" + postcode + "' where id=" + id;

			// 转换参数编码
			sql = new String(sql.getBytes("ISO8859-1"), "UTF-8");

			// 执行更新
			stm.executeUpdate(sql);
			stm.close();
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		} finally {
		}
		return true;
	}%>
