<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // =============================================
    // BACKEND - concluirTarefa.jsp
    // esse backend tem como função marcar como concluída uma tarefa no DB.
    // =============================================
    
    // --- 1. Checagem de Sessão e Autorização ---
    // Verifica se o ID do usuário está armazenado na sessão.
    // É crucial para garantir que apenas usuários logados acessem esta funcionalidade.
    Integer idUsuario = (Integer) session.getAttribute("id_usuario");
    if (idUsuario == null) {
        // Redireciona para a página de login se a sessão não for válida.
        response.sendRedirect("login.jsp");
        return;
    }

    // --- 2. Captura e Validação de Parâmetros ---
    // Captura o ID da tarefa a ser concluída.
    String idParam = request.getParameter("id_tarefa");
    if (idParam == null || idParam.isEmpty()) {
        out.println("Erro: ID da tarefa não informado.");
        return;
    }
    int idTarefa;
    try {
        // Converte a String capturada para um inteiro.
        idTarefa = Integer.parseInt(idParam);
    } catch (NumberFormatException e) {
        out.println("Erro: Formato de ID da tarefa inválido.");
        return;
    }

    // --- 3. Lógica de Banco de Dados ---
    Connection conn = null;

    try {
        // Carregamento do Driver JDBC para MySQL
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // Estabelecimento da Conexão
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/tarefa", "root", "");

        // A. Atualiza a Tarefa para 'concluida = true'
        // A cláusula 'AND id_usuario = ?' garante que o usuário só pode concluir suas próprias tarefas (controle de acesso).
        PreparedStatement psUpdate = conn.prepareStatement(
            "UPDATE Tarefa SET concluida = true WHERE id_tarefa = ? AND id_usuario = ?"
        );
        psUpdate.setInt(1, idTarefa);
        psUpdate.setInt(2, idUsuario);
        int rows = psUpdate.executeUpdate();

        if (rows > 0) {
            // B. Se a atualização foi bem-sucedida, registra a ação no log
            PreparedStatement psLog = conn.prepareStatement(
                "INSERT INTO LogTarefa (id_tarefa, id_usuario, acao, descricao) VALUES (?, ?, 'CONCLUIR', ?)"
            );
            psLog.setInt(1, idTarefa);
            psLog.setInt(2, idUsuario);
            psLog.setString(3, "Tarefa concluída pelo usuário.");
            psLog.executeUpdate();
            psLog.close(); // Fechamento do recurso PreparedStatement do log
            
            // Redireciona o usuário de volta para a lista de tarefas após a conclusão.
            response.sendRedirect("listarTarefas.jsp");
        } else {
            // Caso 0 linhas afetadas: a tarefa não existe ou não pertence ao usuário logado.
            out.println("Erro: Tarefa não encontrada ou você não tem permissão para concluí-la.");
        }

        psUpdate.close(); // Fechamento do recurso PreparedStatement de update

    } catch (Exception e) {
        // Captura e exibe erros gerais (ex: problema de conexão com o banco de dados)
        out.println("Erro interno do servidor ao tentar concluir a tarefa: " + e.getMessage());
        // Em um ambiente de produção, e.printStackTrace() deve ser usado para logar a exceção completa
    } finally {
        // 4. Bloco FINALLY para garantir o fechamento seguro da Conexão
        if (conn != null) try { conn.close(); } catch(Exception ignored) {}
    }
%>