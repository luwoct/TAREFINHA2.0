<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // =============================================
    // BACKEND: Criação de nova tarefa
    // =============================================

    // --- 1. Checagem de Sessão e Autorização ---
    // Verifica se o ID do usuário está ativo na sessão.
    Integer idUsuario = (Integer) session.getAttribute("id_usuario");
    if (idUsuario == null) {
        response.sendRedirect("login.jsp");
        return; 
    }

    // Variável para armazenar mensagens de feedback ou erro para o usuário
    String mensagem = "";

    // --- 2. processamento do formulário com POST ---
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String nome = request.getParameter("nome_tarefa");
        String prioridade = request.getParameter("prioridade");

        // Validação de entrada: verifica se os campos obrigatórios foram preenchidos
        if (nome == null || nome.trim().isEmpty() || prioridade == null || prioridade.trim().isEmpty()) {
            mensagem = "Por favor, preencha o Nome da Tarefa e a Prioridade.";
        } else {
            // Início da Lógica de Conexão e Inserção no Banco de Dados
            Connection conn = null;
            PreparedStatement ps = null;

            try {
                // A. Carregamento do Driver JDBC
                Class.forName("com.mysql.cj.jdbc.Driver");
                
                // B. Estabelecimento da Conexão
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/tarefa", "root", "");

                // C. Preparação da Query de Inserção (PreparedStatement para segurança)
                String sql = "INSERT INTO Tarefa (nome_tarefa, prioridade, concluida, id_usuario) VALUES (?, ?, false, ?)";
                ps = conn.prepareStatement(sql);
                ps.setString(1, nome);
                ps.setString(2, prioridade);
                ps.setInt(3, idUsuario); 
                
                // D. Execução da Inserção
                ps.executeUpdate();

                // E. Redirecionamento em caso de sucesso
                // Após a criação bem-sucedida, redireciona o usuário para a lista de tarefas.
                response.sendRedirect("listarTarefas.jsp");
                return; 

            } catch (Exception e) {
                // F. Tratamento de Exceção
                mensagem = "Erro ao criar tarefa: Falha de conexão ou no BD. Detalhe: " + e.getMessage();
            } finally {
                // G. Fechamento de Recursos
                // Garante que os recursos do banco de dados sejam liberados.
                if (ps != null) try { ps.close(); } catch(Exception ignored) {}
                if (conn != null) try { conn.close(); } catch(Exception ignored) {}
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Criar Nova Tarefa</title>
    <style>
        /* ========================================= */
        /* Estilização minimalista */
        /* ========================================= */
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: #f7f7f7;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 40px 20px;
            min-height: 100vh;
            margin: 0;
        }
        
        /* Título */
        h1 {
            color: #1c1c1e;
            margin-bottom: 30px;
            font-size: 32px;
            font-weight: 700;
            border-bottom: 3px solid #34c759; 
            padding-bottom: 8px;
        }
        
        /* Container do Formulário */
        form {
            background: white;
            padding: 35px;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
            box-sizing: border-box;
            border: 1px solid #e0e0e0;
            margin-bottom: 20px;
        }
        
        /* Labels */
        label {
            display: block;
            margin-top: 15px;
            margin-bottom: 5px;
            font-weight: 600;
            color: #48484a;
            font-size: 14px;
        }
        
        /* Inputs e Select */
        input[type="text"], select {
            width: 100%;
            padding: 12px;
            border: 1px solid #d1d1d6;
            background-color: #fcfcfc;
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 16px;
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        
        input[type="text"]:focus, select:focus {
            border-color: #34c759;
            outline: none;
            box-shadow: 0 0 0 3px rgba(52, 199, 89, 0.3);
        }
        
        /* Botão Principal (Criar) */
        button[type="submit"] {
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: 8px;
            font-weight: 700;
            cursor: pointer;
            background: #34c759; 
            color: white;
            margin-top: 30px;
            font-size: 17px;
            transition: background-color 0.2s, box-shadow 0.2s;
            box-shadow: 0 4px 10px rgba(52, 199, 89, 0.4);
        }
        
        button[type="submit"]:hover {
            background-color: #30b050;
            box-shadow: 0 4px 12px rgba(52, 199, 89, 0.6);
        }

        /* Botão Secundário (Voltar) */
        .btn-voltar {
            background: #e5e5ea;
            color: #1c1c1e;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 500;
            transition: opacity 0.2s;
            margin-top: 10px;
        }
        .btn-voltar:hover {
            opacity: 0.8;
            background-color: #d1d1d6;
        }
        
        a { text-decoration: none; }
        
        /* Mensagem de Erro */
        .mensagem-erro { 
            color: #ff3b30; 
            background-color: #ffe6e6;
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #ff3b30;
            margin-bottom: 20px;
            font-weight: 500; 
            max-width: 400px;
            width: 100%;
            box-sizing: border-box;
        }
    </style>
</head>
<body>

<h1>Criar Nova Tarefa</h1>

<% if (!mensagem.isEmpty()) { %>
    <!-- Exibe a mensagem de erro formatada -->
    <p class="mensagem-erro"><%= mensagem %></p>
<% } %>

<form method="post" action="criarTarefa.jsp">
    <label for="nome_tarefa">Nome da Tarefa:</label>
    <input type="text" id="nome_tarefa" name="nome_tarefa" required>

    <label for="prioridade">Prioridade:</label>
    <select id="prioridade" name="prioridade" required>
        <option value="">Selecione</option>
        <option value="Baixa">Baixa</option>
        <option value="Média">Média</option>
        <option value="Alta">Alta</option>
    </select>

    <button type="submit">Criar</button>
</form>

<!-- Botão Voltar -->
<a href="listarTarefas.jsp"><button class="btn-voltar">Voltar para a Lista</button></a>

</body>
</html>