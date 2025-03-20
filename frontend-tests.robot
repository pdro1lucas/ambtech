*** Settings ***
Documentation     Testes de frontend para o site ServeRest https://front.serverest.dev/
Resource          resource.robot
Test Setup        Abrir Navegador
Test Teardown     Fechar Navegador

*** Test Cases ***
Cenário 1: Criar Cadastro com Sucesso
    Acessar Página de Cadastro
    Preencher Formulário de Cadastro    TestUser${RANDOM}    teste@email${RANDOM}.com    teste123    
    Clicar no Botão Cadastrar
    Verificar Mensagem    Cadastro realizado com sucesso
    Verificar Redirecionamento para Login

Cenário 2: Login com Sucesso
    ${email}=    Set Variable    teste@serverest.com
    ${senha}=    Set Variable    teste
    
    Acessar Página de Login
    Preencher Formulário de Login    ${email}    ${senha}
    Clicar no Botão Entrar
    Verificar Login com Sucesso
    Verificar Acesso à Página Home

Cenário 3: Login com Credenciais Incorretas
    ${email}=    Set Variable    incorreto@email.com
    ${senha}=    Set Variable    senhaerrada
    
    Acessar Página de Login
    Preencher Formulário de Login    ${email}    ${senha}
    Clicar no Botão Entrar
    Verificar Mensagem de Erro    Email e/ou senha inválidos
