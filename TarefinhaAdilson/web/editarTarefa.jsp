<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%

// BACKEND: editarTarefa.jsp
// busca a tarefa do usuário, valida as alterações e salva no DB.

    // checa se o usuário está logado. Se não, redireciona para login.
    Integer idUsuario = (Integer) session.getAttribute("id_usuario");
    if (idUsuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String method = request.getMethod();
    int idTarefa = 0;
    String nome = "";
    String prioridade = "";
    String mensagem = "";

    // conexão e statement
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        // Carregamento do Driver JDBC
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // busca a tarefa existente e preenche o formulário 
        if("GET".equalsIgnoreCase(method)) {
            String idParam = request.getParameter("id_tarefa");
            if(idParam == null || idParam.isEmpty()) {
                out.println("Erro: ID da tarefa não informado.");
                return;
            }
            // Parse do ID da tarefa
            idTarefa = Integer.parseInt(idParam);

            // Estabelecimento da Conexão
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/tarefa","root","");
            
            // Query de Seleção: Busca a tarefa específica e verifica se pertence ao usuário logado (segurança).
            ps = conn.prepareStatement(
                "SELECT nome_tarefa, prioridade FROM Tarefa WHERE id_tarefa=? AND id_usuario=?"
            );
            ps.setInt(1, idTarefa);
            ps.setInt(2, idUsuario);
            rs = ps.executeQuery();

            if(rs.next()) {
                nome = rs.getString("nome_tarefa");
                prioridade = rs.getString("prioridade");
            } else {
                out.println("Erro: Tarefa não encontrada ou você não tem permissão para editá-la.");
                return;
            }
            
            // Fechamento dos recursos do GET
            rs.close();
            ps.close();
            conn.close();
            conn = null; // Reinicializa a variável para o finally
            ps = null; // Reinicializa a variável para o finally
            rs = null; // Reinicializa a variável para o finally
        }

        // atualiza a tarefa no banco de dados ---
        if("POST".equalsIgnoreCase(method)) {
            // Captura de parâmetros
            idTarefa = Integer.parseInt(request.getParameter("id_tarefa"));
            nome = request.getParameter("nome_tarefa");
            prioridade = request.getParameter("prioridade");

            // Validação de campos obrigatórios
            if(nome == null || nome.trim().isEmpty()) {
                mensagem = "O nome da tarefa não pode ser vazio.";
                // Se o nome estiver vazio, vai permitir que o restante do JSP renderize o formulário com a mensagem de erro.
            } else {
                // estabelecimento da conexão para o POST
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/tarefa","root","");
                
                // query de update
                ps = conn.prepareStatement(
                    "UPDATE Tarefa SET nome_tarefa=?, prioridade=? WHERE id_tarefa=? AND id_usuario=?"
                );
                ps.setString(1, nome);
                ps.setString(2, prioridade);
                ps.setInt(3, idTarefa);
                ps.setInt(4, idUsuario);
                
                int rows = ps.executeUpdate();

                if (rows > 0) {
                    // Se a atualização for bem-sucedida, redireciona.
                    response.sendRedirect("listarTarefas.jsp");
                    return; // Interrompe a execução após o redirecionamento
                } else {
                    mensagem = "Erro: Tarefa não encontrada ou sem permissão para atualizar.";
                }
            }
        }
        
    } catch(NumberFormatException e) {
        // captura erro se o ID da tarefa não for um número válido.
        out.println("Erro de formato de dados: ID da tarefa inválido.");
        return;
    } catch(Exception e) {
        // Captura erros de JDBC ou outros.
        mensagem = "Erro na operação do banco de dados: " + e.getMessage();
    } finally {
        // este bloco é executado independente de ter exceção ou não.
        if (rs != null) try { rs.close(); } catch(Exception ignored) {}
        if (ps != null) try { ps.close(); } catch(Exception ignored) {}
        if (conn != null) try { conn.close(); } catch(Exception ignored) {}
    }
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Editar Tarefa - <%= idTarefa %></title>
    <style>
        /* ========================================= */
        /* Estilos minimalistas */
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
            border-bottom: 3px solid #ff9500; 
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
            border-color: #ff9500;
            outline: none;
            box-shadow: 0 0 0 3px rgba(255, 149, 0, 0.3);
        }
        
        /* Botão Principal (Salvar) */
        button[type="submit"] {
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: 8px;
            font-weight: 700;
            cursor: pointer;
            background: #ff9500; 
            color: white;
            margin-top: 30px;
            font-size: 17px;
            transition: background-color 0.2s, box-shadow 0.2s;
            box-shadow: 0 4px 10px rgba(255, 149, 0, 0.4);
        }
        
        button[type="submit"]:hover {
            background-color: #e58700;
            box-shadow: 0 4px 12px rgba(255, 149, 0, 0.6);
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

<h1>Editar Tarefa</h1>

<% if(!mensagem.isEmpty()) { %>
    <p class="mensagem-erro"><%= mensagem %></p>
<% } %>

<form method="post" action="editarTarefa.jsp">
    <!-- campo oculto para garantir que o ID da tarefa seja enviado no POST -->
    <input type="hidden" name="id_tarefa" value="<%= idTarefa %>">

    <label for="nome_tarefa">Nome da tarefa:</label>
    <input type="text" id="nome_tarefa" name="nome_tarefa" value="<%= nome %>" required>

    <label for="prioridade">Prioridade:</label>
    <select id="prioridade" name="prioridade" required>
        <!-- a opção correta é marcada como "selected" baseada no valor recuperado do banco (GET) -->
        <option value="Baixa" <%= "Baixa".equals(prioridade) ? "selected" : "" %>>Baixa</option>
        <option value="Média" <%= "Média".equals(prioridade) ? "selected" : "" %>>Média</option>
        <option value="Alta" <%= "Alta".equals(prioridade) ? "selected" : "" %>>Alta</option>
    </select>

    <button type="submit">Salvar alterações</button>
</form>

<a href="listarTarefas.jsp"><button class="btn-voltar">Voltar para a Lista</button></a>

</body>
</html>