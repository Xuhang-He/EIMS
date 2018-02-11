<%@page language="java" contentType="text/html;charset=gb2312"%>
<%@ include file="db.jsp"%>
<%String sql = "select * from user";
			try {
				Class.forName(drv).newInstance();
				Connection conn = DriverManager.getConnection(url, usr, pwd);
				Statement stm = conn.createStatement();
				ResultSet rs = stm.executeQuery(sql);
				ResultSetMetaData rsmd = rs.getMetaData();
				int cols = rsmd.getColumnCount();
				while (rs.next()) {
					for (int i = 1; i <= cols; i++) {
						String field = (String) (rsmd.getColumnName(i));
						String value = (String) (rs.getString(i));
						out.print(field + "=" + value + ";");
					}
				}
				rs.close();
				stm.close();
				conn.close();
			} catch (Exception e) {
				e.printStackTrace();
				out.println(e);
			}
		%>
