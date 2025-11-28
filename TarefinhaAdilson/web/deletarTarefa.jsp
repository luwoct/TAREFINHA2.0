<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // ==================================================
    // BACKEND: deletarTarefa.jsp
    // Esse backend é responsável por excluir a tarefa e registrar log da mesma.
    // ==================================================

    // --- Sessão / Autorização ---
    // Se não estiver logado, manda pro login.
    Integer idUsuario = (Integer) session.getAttribute("id_usuario");
    if (idUsuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // --- Parâmetros ---
    // Pega o id da tarefa da URL
    String idParam = request.getParameter("id_tarefa");
    if (idParam == null || idParam.isEmpty()) {
        out.println("Erro: ID da tarefa não informado.");
        return;
    }

    int idTarefa;
    try {
        idTarefa = Integer.parseInt(idParam);
    } catch (NumberFormatException e) {
        out.println("Erro: Formato inválido para ID da tarefa.");
        return;
    }

    // --- DB ---
    Connection conn = null;
    PreparedStatement psNome = null;
    PreparedStatement psLog = null;
    PreparedStatement psDelete = null;
    ResultSet rs = null;

    try {
        // conexão com o banco
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/tarefa",
            "root",
            ""
        );

        // 1) Busca o nome da tarefa
        // Serve pra garantir posse e gerar log com descrição legível.
        psNome = conn.prepareStatement(
            "SELECT nome_tarefa FROM Tarefa WHERE id_tarefa = ? AND id_usuario = ?"
        );
        psNome.setInt(1, idTarefa);
        psNome.setInt(2, idUsuario);
        rs = psNome.executeQuery();

        if (!rs.next()) {
            out.println("Erro: Tarefa não encontrada ou você não tem permissão.");
            return;
        }

        String nomeTarefa = rs.getString("nome_tarefa");

        rs.close();
        psNome.close();

        // 2) Registra log (ação: DELETAR)
        psLog = conn.prepareStatement(
            "INSERT INTO LogTarefa (id_tarefa, id_usuario, acao, descricao) VALUES (?, ?, 'DELETAR', ?)"
        );
        psLog.setInt(1, idTarefa);
        psLog.setInt(2, idUsuario);
        psLog.setString(3, "Tarefa \"" + nomeTarefa + "\" deletada.");
        psLog.executeUpdate();
        psLog.close();

        // 3) Apaga a tarefa
        // Só exclui se for do usuário logado.
        psDelete = conn.prepareStatement(
            "DELETE FROM Tarefa WHERE id_tarefa = ? AND id_usuario = ?"
        );
        psDelete.setInt(1, idTarefa);
        psDelete.setInt(2, idUsuario);
        psDelete.executeUpdate();
        psDelete.close();

        // se tiver sucesso, volta pra listagem
        response.sendRedirect("listarTarefas.jsp");

    } catch (Exception e) {
        out.println("Erro interno ao deletar: " + e.getMessage());
    } finally {
        // fecha os recursos
        try { if (rs != null) rs.close(); } catch(Exception ignored) {}
        try { if (psNome != null) psNome.close(); } catch(Exception ignored) {}
        try { if (psLog != null) psLog.close(); } catch(Exception ignored) {}
        try { if (psDelete != null) psDelete.close(); } catch(Exception ignored) {}
        try { if (conn != null) conn.close(); } catch(Exception ignored) {}
    }
%>
