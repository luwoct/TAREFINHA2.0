<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // BACKEND: Checagem simples de login
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Nome do usuário para exibir na tela
    String nomeUsuario = (String) session.getAttribute("usuario");
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Página Inicial - Tarefinha</title>

    <style>
        /* ---------- Layout geral ---------- */
        body { 
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: #f7f7f7;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding-top: 60px;
            margin: 0;
            text-align: center;
        }

        h2 { 
            color: #1c1c1e;
            margin-bottom: 5px;
            font-weight: 700;
            font-size: 32px;
        }

        h3 { 
            color: #8e8e93;
            margin-bottom: 25px;
            font-weight: 400;
            font-size: 18px;
        }

        /* Linha apenas para separar visualmente */
        hr { 
            width: 80%;
            max-width: 400px;
            border: 0;
            border-top: 1px solid #d1d1d6;
            margin: 20px 0 40px 0;
        }

        /* ---------- Menu de botões ---------- */
        .menu-container {
            width: 100%;
            max-width: 300px;
        }

        a {
            text-decoration: none;
            margin: 8px 0;
            display: block;
        }

        /* Botão base */
        button {
            padding: 15px 20px;
            border: none;
            border-radius: 12px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color .2s, opacity .2s;
            width: 100%;
            font-size: 16px;
        }

        /* Botões padrão */
        .btn-default {
            background-color: #e5e5ea;
            color: #1c1c1e;
        }
        .btn-default:hover { background-color: #d1d1d6; }

        /* Destaque para criar tarefa */
        .btn-highlight {
            background-color: #34c759;
            color: white;
            font-weight: 600;
            box-shadow: 0 4px 10px rgba(52, 199, 89, 0.4);
        }
        .btn-highlight:hover { background-color: #30b050; }

        /* Botão de sair */
        .btn-logout {
            background-color: #ff3b30;
            color: white;
            margin-top: 30px; 
        }
        .btn-logout:hover { background-color: #e53327; }
    </style>
</head>

<body>

    <h2>Olá, <%= nomeUsuario %>!</h2>
    <h3>O que vamos fazer hoje?</h3>
    <hr>
    
    <div class="menu-container">
        <a href="criarTarefa.jsp">
            <button class="btn-highlight">Criar Nova Tarefa 📝</button>
        </a>

        <a href="listarTarefas.jsp">
            <button class="btn-default">Listar Tarefas</button>
        </a>

        <a href="logs.jsp">
            <button class="btn-default">Ver Log</button>
        </a>

        <a href="logout.jsp">
            <button class="btn-logout">Sair</button>
        </a>
    </div>

</body>
</html>
