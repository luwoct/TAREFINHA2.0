<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // ===================================================
    // BACKEND: Proteção de sessão
    // ===================================================
    // Garante que apenas usuários logados acessem a página.
    Integer idUsuario = (Integer) session.getAttribute("id_usuario");
    if (idUsuario == null) {
        response.sendRedirect("login.jsp");
        return; // interrompe carregamento da página
    }
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Minhas Tarefas</title>
    <style>
        /* ---------------------------------------------------- */
        /* CORREÇÃO DO ALINHAMENTO */
        /* ---------------------------------------------------- */
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: #f7f7f7;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-start;
            min-height: 100vh;
            padding-top: 40px;
            margin: 0;
            position: relative; /* Define o corpo como referência para o posicionamento absoluto */
        }
        
        /* Contêiner principal para centralizar o conteúdo */
        .container {
            width: 90%;
            max-width: 800px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            padding: 20px;
            box-sizing: border-box;
            margin-bottom: 40px; 
        }

        /* Seta fixa no canto superior esquerdo */
        .btn-back-home-fixed {
            position: absolute; 
            top: 40px; 
            left: 50%; 
            transform: translateX(-400px); 
            max-width: 800px; 
            margin-left: -400px; 
            padding-left: 20px; 

            /* Estilo Visual */
            text-decoration: none;
            color: #007aff;
            font-size: 16px;
            font-weight: 600;
            display: flex;
            align-items: center;
            transition: opacity 0.2s;
            z-index: 10; 
        }
        
        /* Estilo da Seta */
        .btn-back-home-fixed::before {
            content: "←"; 
            font-size: 24px;
            margin-right: 5px;
        }

        /* Estilo do Título Central */
        h2 { 
            color: #1c1c1e; 
            font-weight: 700; 
            font-size: 30px; 
            border-bottom: 3px solid #007aff; 
            padding-bottom: 5px;
            margin-top: 0;
            margin-bottom: 30px; 
            text-align: center; 
        }

        /* O resto do CSS para a tabela e botões */
        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 15px;
        }
        th, td {
            border: none;
            padding: 12px 10px;
            text-align: left;
        }
        th {
            background-color: #007aff;
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 14px;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tr:hover {
            background-color: #f0f0f0;
        }
        td:last-child {
            text-align: right;
            white-space: nowrap;
        }

        /* Estilo dos Botões de Ação na Linha */
        .btn-group a {
            text-decoration: none;
            margin-left: 8px;
            display: inline-block;
            padding: 8px 12px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            transition: background-color 0.2s;
        }
        .btn-create {
            display: inline-block;
            margin-top: 0;
            margin-bottom: 20px;
            padding: 10px 15px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: opacity 0.2s;
            text-decoration: none; 
            background-color: #34c759;
            color: white;
        }
        .btn-edit, .btn-finish { 
            background-color: #007aff; 
            color: white;
        }
        .btn-delete { 
            background-color: #ff3b30; 
            color: white;
        }
        .btn-edit:hover, .btn-finish:hover, .btn-delete:hover { opacity: 0.8; }

        /* Estilo do Status */
        .status-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
        }
        .btn-concluida {
            background-color: #34c759;
            color: white;
        }
        .btn-nao-concluida {
            background-color: #ffcc00;
            color: #1c1c1e;
        }
    </style>
</head>
<body>

<a href="home.jsp" class="btn-back-home-fixed"><-- Voltar para Home</a>

<h2>Minhas Tarefas</h2>

<a href="criarTarefa.jsp" class="btn-create">Criar nova tarefa</a>


<div class="container">
    <table>
        <tr>
            <th>ID</th>
            <th>Nome da Tarefa</th>
            <th>Prioridade</th>
            <th style="text-align: center;">Status</th>
            <th>Ações</th>
        </tr>

<%
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        // =========================================
        // BACKEND: Conexão com o banco MySQL
        // =========================================
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/tarefa", "root", "");

        // Recupera todas as tarefas do usuário logado
        String sql = "SELECT id_tarefa, nome_tarefa, prioridade, concluida FROM Tarefa WHERE id_usuario=? ORDER BY FIELD(prioridade, 'Alta', 'Média', 'Baixa'), concluida ASC, id_tarefa ASC";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, idUsuario);
        rs = ps.executeQuery();

        while (rs.next()) {
            int idTarefa = rs.getInt("id_tarefa");
            String nome = rs.getString("nome_tarefa");
            String prioridade = rs.getString("prioridade");
            boolean concluida = rs.getBoolean("concluida");
            
            // Determina a classe de estilo para o status
            String statusClass = concluida ? "btn-concluida" : "btn-nao-concluida";
            String statusText = concluida ? "Concluída" : "Pendente";
%>
<tr>
    <td><%= idTarefa %></td>
    <td><%= nome %></td>
    <td><%= prioridade %></td>
    <td style="text-align: center;">
        <span class="status-badge <%= statusClass %>"><%= statusText %></span>
    </td>
    <td class="btn-group">
        <a href="editarTarefa.jsp?id_tarefa=<%= idTarefa %>" class="btn-edit">Editar</a>
        <a href="deletarTarefa.jsp?id_tarefa=<%= idTarefa %>" class="btn-delete">Excluir</a>
        <% if (!concluida) { %>
            <a href="concluirTarefa.jsp?id_tarefa=<%= idTarefa %>" class="btn-finish">Concluir</a>
        <% } %>
    </td>
</tr>
<%
        }
    } catch (Exception e) {
        // emite uma log do erro e exibe uma mensagem amigável no frontend
        System.err.println("Erro ao carregar tarefas: " + e.getMessage());
        out.println("<tr><td colspan='5'>Erro ao carregar tarefas: " + e.getMessage() + "</td></tr>");
    } finally {
        // Fechamento seguro dos recursos de banco de dados
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (ps != null) try { ps.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>
    </table>
</div>

</body>
</html>