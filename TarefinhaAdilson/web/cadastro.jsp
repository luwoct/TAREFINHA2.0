<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
// BACKEND: cadastro.jsp
// esse backend é responsável por processar o cadastro de novos usuários no sistema.


    // Captura os dados enviados pelo formulário via método POST
    String usuario = request.getParameter("usuario");
    String senha = request.getParameter("senha");

    // Variável para armazenar a mensagem de feedback do sistema para o usuário
    String mensagem = "";

    // O processamento ocorre apenas se os parâmetros 'usuario' e 'senha' existirem
    if (usuario != null && senha != null && !usuario.trim().isEmpty() && !senha.trim().isEmpty()) {
        Connection conn = null;
        PreparedStatement st = null;

        try {
            // 1. Carregamento do Driver JDBC para MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 2. Estabelecimento da Conexão com o Banco de Dados
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/tarefa", "root", ""
            );

            // 3. prepara a query SQL
            String sql = "INSERT INTO Usuario (usuario, senha) VALUES (?, ?)";
            st = conn.prepareStatement(sql);
            st.setString(1, usuario);
            st.setString(2, senha); 

            // 4. Executa a atualização (inserção)
            int rowsAffected = st.executeUpdate();

            if (rowsAffected > 0) {
                mensagem = "<span class='msg-success'>Usuário cadastrado com sucesso!</span>";
            } else {
                mensagem = "<span class='msg-error'>Falha ao cadastrar. Tente novamente.</span>";
            }

        } catch (SQLIntegrityConstraintViolationException e) {
            // Erro específico para duplicidade (ex: chave primária ou única)
            mensagem = "<span class='msg-error'>Erro: O nome de usuário já está em uso.</span>";
        } catch (Exception e) {
            // Captura erros gerais de conexão ou outros problemas de BD
            mensagem = "<span class='msg-error'>Erro no servidor: Não foi possível realizar o cadastro.</span>";
            // É recomendável logar a exceção completa no console do servidor (e.printStackTrace())
        } finally {
            if (st != null) try { st.close(); } catch(Exception ignored) {}
            if (conn != null) try { conn.close(); } catch(Exception ignored) {}
        }
    }
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Cadastro de Usuário</title>
    <style>
        /* Estilização minimalista */

        /* Layout Principal */
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: #f7f7f7;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }

        /* Container do Formulário */
        .container {
            background-color: #fff;
            padding: 40px 30px;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.1); 
            width: 100%;
            max-width: 400px;
            box-sizing: border-box;
            border: 1px solid #e0e0e0; 
        }

        /* Título */
        h2 {
            text-align: center;
            color: #1c1c1e;
            margin-bottom: 25px;
            font-weight: 700;
            font-size: 26px;
            border-bottom: 3px solid #007aff;
            padding-bottom: 10px;
            display: inline-block;
            margin-left: auto;
            margin-right: auto;
        }

        /* Labels */
        label {
            display: block;
            margin-top: 15px;
            margin-bottom: 5px;
            font-weight: 500;
            color: #48484a;
            font-size: 14px;
        }

        /* Campos de Input */
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 12px;
            font-size: 16px;
            border-radius: 8px;
            border: 1px solid #d1d1d6;
            background-color: #fcfcfc;
            box-sizing: border-box;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        input[type="text"]:focus, input[type="password"]:focus {
            border-color: #007aff;
            outline: none;
            box-shadow: 0 0 0 3px rgba(0, 122, 255, 0.3); 
        }

        /* Botão Principal (Cadastrar) */
        button[type="submit"] {
            width: 100%;
            padding: 14px;
            margin-top: 30px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 17px;
            cursor: pointer;
            background-color: #34c759; 
            color: white;
            transition: background-color 0.2s, box-shadow 0.2s;
            box-shadow: 0 4px 10px rgba(52, 199, 89, 0.4);
        }

        button[type="submit"]:hover {
            background-color: #30b050;
            box-shadow: 0 4px 12px rgba(52, 199, 89, 0.6);
        }

        /* Mensagens de Feedback */
        .mensagem {
            text-align: center;
            margin-top: 20px;
            padding: 10px;
            border-radius: 6px;
            font-weight: 500;
            font-size: 15px;
        }
        .msg-success {
            color: #1c1c1e;
            background-color: #e6ffed; 
            border: 1px solid #34c759;
            display: block;
        }
        .msg-error {
            color: #1c1c1e;
            background-color: #ffe6e6; 
            border: 1px solid #ff3b30;
            display: block;
        }

        /* Link de Retorno */
        .link-login {
            display: block;
            text-align: center;
            margin-top: 25px;
            font-size: 15px;
            text-decoration: none;
            color: #007aff;
            transition: color 0.2s;
        }

        .link-login:hover {
            color: #005bb5;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Criar Conta</h2>

    <!-- Formulário de cadastro. Envia os dados para a própria página (cadastro.jsp) -->
    <form action="cadastro.jsp" method="post">
        <label for="usuario">Usuário:</label>
        <input type="text" id="usuario" name="usuario" required>

        <label for="senha">Senha:</label>
        <input type="password" id="senha" name="senha" required>

        <button type="submit">Cadastrar</button>
    </form>

    <!-- Exibe a mensagem de feedback (sucesso ou erro) gerada pelo backend -->
    <div class="mensagem">
        <%= mensagem %>
    </div>

    <!-- Link para redirecionar o usuário para a tela de autenticação -->
    <a href="cadastro.jsp" class="link-login">Voltar ao Login</a>
</div>

</body>

</html>
