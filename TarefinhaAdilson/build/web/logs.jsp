<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // =============================================
    // BACKEND: Listagem de logs do usuário
    // =============================================

    // 1. Verifica se o usuário está logado
    Integer idUsuario = (Integer) session.getAttribute("id_usuario");
    if (idUsuario == null) {
        // Se não estiver logado, redireciona para a página de login
        response.sendRedirect("login.jsp"); // Corrigido para .jsp, seguindo o padrão
        return;
    }

    // 2. Inicializa variáveis de conexão
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        // 3. Carrega o driver JDBC do MySQL
        Class.forName("com.mysql.cj.jdbc.Driver");

        // 4. Conecta ao banco de dados (local) 'tarefa' usando usuário root e sem senha
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/tarefa", "root", "");

        // 5. Prepara a query para buscar logs do usuário
        //    - Traz ID do log, ação realizada, descrição, timestamp e nome da tarefa associada
        //    - Junta a tabela de logs (LogTarefa) com a tabela de tarefas (Tarefa)
        String sql = "SELECT l.id_log, l.acao, l.descricao, l.timestamp, t.nome_tarefa " +
                     "FROM LogTarefa l " +
                     "JOIN Tarefa t ON l.id_tarefa = t.id_tarefa " +
                     "WHERE l.id_usuario = ? " + // apenas logs do usuário logado
                     "ORDER BY l.timestamp DESC"; // ordem do mais recente para o mais antigo

        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, idUsuario); // define o parâmetro do usuário

        // 6. Executa a query e obtém os resultados
        rs = stmt.executeQuery();
%>

<!-- =============================================
      FRONTEND: Exibição dos logs
============================================= -->
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Logs do Sistema</title>
    <style>
        /* Estilos minimalistas */
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: #f9f9f9;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 30px 20px;
            min-height: 100vh;
            margin: 0;
        }
        h1 { 
            color: #1c1c1e; 
            margin-bottom: 20px; 
            font-size: 28px; 
            font-weight: 700;
        }
        table { 
            border-collapse: collapse; 
            width: 100%; 
            max-width: 900px; 
            background: white; 
            border-radius: 12px;
            overflow: hidden; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.1); 
            margin-top: 20px;
        }
        th, td { 
            border: none; 
            padding: 12px 15px; 
            text-align: left; 
        }
        th { 
            background-color: #007aff; 
            color: white; 
            font-weight: 600;
            text-transform: uppercase;
        }
        tr:nth-child(even) { background-color: #f2f2f2; }
        tr:hover { background-color: #e8e8e8; }
        
        /* Estilizaçao do Botão de Voltar  */
        .btn-back { 
            background-color: #5856d6; 
            color: white; 
            border: none; 
            padding: 10px 20px; 
            border-radius: 8px; 
            cursor: pointer; 
            font-size: 16px; 
            font-weight: 600;
            margin-bottom: 20px; 
            transition: opacity 0.2s; 
            text-decoration: none; 
            display: inline-block;
        }
        .btn-back:hover { 
            opacity: 0.85; 
        }

    </style>
</head>
<body>

<h1>Logs do usuário: <%= session.getAttribute("usuario") %></h1>

<!-- Botão para voltar para a home usando o novo estilo .btn-back -->
<a href="listarTarefas.jsp" class="btn-back">Voltar para Tarefas</a>

<!-- Tabela de logs -->
<table>
    <tr>
        <th>ID Log</th>
        <th>Tarefa</th>
        <th>Ação</th>
        <th>Descrição</th>
        <th>Data e Hora</th>
    </tr>

<%
    // 7. Itera sobre o ResultSet e imprime cada log na tabela
    while (rs.next()) {
%>
    <tr>
        <td><%= rs.getInt("id_log") %></td>
        <td><%= rs.getString("nome_tarefa") %></td>
        <td><%= rs.getString("acao") %></td>
        <td><%= rs.getString("descricao") %></td>
        <td><%= rs.getTimestamp("timestamp") %></td>
    </tr>
<%
    }
%>
</table>

</body>
</html>

<%
    } catch (Exception e) {
        // 8. Caso ocorra erro, exibe a mensagem para o usuário
        out.println("Erro ao carregar logs: " + e.getMessage());
    } finally {
        // 9. Fecha todos os recursos para evitar vazamentos
        if (rs != null) try { rs.close(); } catch(SQLException ignore) {}
        if (stmt != null) try { stmt.close(); } catch(SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch(SQLException ignore) {}
    }
%>