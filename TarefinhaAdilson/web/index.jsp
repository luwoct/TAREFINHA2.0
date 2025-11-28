<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    /* ===================== BACKEND: PROCESSAMENTO DE LOGIN ===================== */

    // mensagem de erro exibida no frontend
    String erro = null;

    // executa somente se o formulário for enviado via POST
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String usuario = request.getParameter("usuario");
        String senha   = request.getParameter("senha");

        if (usuario != null && senha != null) {

            Connection conn = null;
            PreparedStatement st = null;
            ResultSet rs = null;

            try {
                // driver MySQL
                Class.forName("com.mysql.cj.jdbc.Driver");

                // conexão
                conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/tarefa", "root", ""
                );

                // verifica login
                String sql = "SELECT id_usuario, usuario FROM Usuario WHERE usuario=? AND senha=?";
                st = conn.prepareStatement(sql);
                st.setString(1, usuario);
                st.setString(2, senha);

                rs = st.executeQuery();

                if (rs.next()) {
                    session.setAttribute("id_usuario", rs.getInt("id_usuario"));
                    session.setAttribute("usuario", rs.getString("usuario"));
                    response.sendRedirect("home.jsp");
                    return;
                } else {
                    erro = "Usuário ou senha inválidos.";
                }

            } catch (SQLException e) {
                erro = "Erro ao conectar com o banco de dados.";
                e.printStackTrace();
            } catch (ClassNotFoundException e) {
                erro = "Erro interno do servidor.";
                e.printStackTrace();
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception e) {}
                try { if (st != null) st.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>

    <style>
        /* ===================== FRONTEND: ESTILOS DA PÁGINA ===================== */

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: #f0f2f5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .container {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
            width: 320px;
            text-align: center;
        }

        .app-header {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 30px;
            color: #1c1c1e;
        }

        .app-title {
            font-weight: 700;
            font-size: 28px;
            margin: 0;
            color: #1c1c1e;
        }

        label {
            display: block;
            text-align: left;
            margin-top: 15px;
            margin-bottom: 5px;
            font-weight: 500;
            color: #48484a;
            font-size: 14px;
        }

        input {
            width: 100%;
            padding: 12px;
            border: 1px solid #dcdcdc;
            background-color: #ffffff;
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 16px;
            margin-bottom: 10px;
            transition: border-color 0.3s;
        }

        input:focus {
            border-color: #007aff;
            outline: none;
            box-shadow: 0 0 0 3px rgba(0, 122, 255, 0.2);
        }

        .btn-primary {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            background: #007aff;
            color: white;
            margin-top: 30px;
            font-size: 16px;
            transition: background 0.2s;
        }

        .btn-primary:hover {
            background: #005bb5;
        }

        .btn-secondary {
            background: none;
            color: #007aff;
            margin-top: 15px;
            padding: 10px;
            font-size: 14px;
            font-weight: 500;
            text-decoration: none;
            display: inline-block;
            cursor: pointer;
            border: none;
            width: auto;
            text-align: center;
            transition: color 0.2s;
        }

        .btn-secondary:hover { 
            text-decoration: underline; 
            color: #005bb5; 
        }

        .secondary-link-wrapper {
            text-align: center;
            margin-top: 15px;
        }

        .error-message {
            color: #ff3b30;
            margin-top: 15px;
            font-weight: 500;
            font-size: 14px;
        }
    </style>
</head>
<body>

<div class="container">

    <div class="app-header">
        <h2 class="app-title">Tarefinha - Login</h2>
    </div>

    <form method="post">
        <label for="usuario-input">Usuário:</label>
        <input type="text" id="usuario-input" name="usuario" required>

        <label for="senha-input">Senha:</label>
        <input type="password" id="senha-input" name="senha" required>

        <button type="submit" class="btn-primary">Entrar</button>
    </form>

    <div class="secondary-link-wrapper">
        <a href="cadastro.jsp" class="btn-secondary">Criar Conta</a>
    </div>

    <%
        if (erro != null) {
    %>
        <p class="error-message"><%= erro %></p>
    <%
        }
    %>
</div>

</body>
</html>
