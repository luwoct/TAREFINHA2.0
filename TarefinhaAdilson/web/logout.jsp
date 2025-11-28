<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Invalida a sessão atual
    session.invalidate();

    // Redireciona para o login
    response.sendRedirect("index.jsp");
%>

