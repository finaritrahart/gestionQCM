<<<<<<< .merge_file_ovfY71
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil" %>


=======
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.*, util.DBUtil" %>
>>>>>>> .merge_file_hP7ENQ
<%
String id = request.getParameter("id");

try{
    Connection conn = null;
    conn = DBUtil.getConnection();
    Statement st = conn.createStatement();
    st.executeUpdate("DELETE FROM etudiant WHERE num_etudiant='"+id+"'");

    response.sendRedirect("liste.jsp");

    conn.close();
}catch(Exception e){
    out.println(e.getMessage());
}
%>