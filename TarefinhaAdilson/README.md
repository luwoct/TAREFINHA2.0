Sobre o Aplicativo — Tarefinha

O Tarefinha é um sistema simples de gerenciamento de tarefas desenvolvido em JSP + MySQL.
Ele permite que cada usuário crie sua conta, faça login e gerencie suas próprias tarefas de forma segura.

O foco do projeto é demonstrar a construção de um CRUD completo usando Java Web (JSP) com acesso ao banco de dados via JDBC.
Nada de frameworks pesados — apenas o essencial para entender o fluxo real entre frontend, backend e persistência.

🔧 Funcionalidades

✔️ Cadastro de Usuário
Criação de contas individuais (com validação e tratamento de erro quando o usuário já existe).

✔️ Login com Sessão
Só acessa as páginas internas quem estiver autenticado.
Informações do usuário ficam salvas em sessão.

✔️ CRUD de Tarefas (por usuário)

Criar tarefa

Editar tarefa

Excluir tarefa

Listar somente as tarefas do usuário logado

Cada operação é protegida: um usuário não acessa tarefas de outro.

✔️ Feedback visual
Mensagens de erro e sucesso aparecem no layout do sistema.
