*** Settings ***
Documentation     Arquivo de recursos compartilhados para testes do ServeRest
Test Setup        Abrir Navegador
Test Teardown     Fechar Navegador
Library           SeleniumLibrary
Library           String
Library           RequestsLibrary
Library           Collections

*** Variables ***
${BROWSER}        chrome
${URL}            https://front.serverest.dev
${API_URL}        https://serverest.dev
${RANDOM}         ${EMPTY}

*** Keywords ***
# Keywords para configuração de testes
Abrir Navegador
    ${random}=    Generate Random String    5    [NUMBERS]
    Set Global Variable    ${RANDOM}    ${random}
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout    10

Fechar Navegador
    Close Browser

# Keywords para testes de Frontend
Acessar Página de Cadastro
    Go To    ${URL}/cadastrarusuarios
    Wait Until Element Is Visible    css=form[data-testid='cadastro']
    Page Should Contain    Cadastro

Acessar Página de Login
    Go To    ${URL}/login
    Wait Until Element Is Visible    css=form[data-testid='login']
    Page Should Contain    Login

Preencher Formulário de Cadastro
    [Arguments]    ${nome}    ${email}    ${senha}
    Input Text    css=input[data-testid='nome']    ${nome}
    Input Text    css=input[data-testid='email']    ${email}
    Input Text    css=input[data-testid='password']    ${senha}
    Select Radio Button    administrador    false

Preencher Formulário de Login
    [Arguments]    ${email}    ${senha}
    Input Text    css=input[data-testid='email']    ${email}
    Input Text    css=input[data-testid='senha']    ${senha}

Clicar no Botão Cadastrar
    Click Button    css=button[data-testid='cadastrar']

Clicar no Botão Entrar
    Click Button    css=button[data-testid='entrar']

Verificar Mensagem
    [Arguments]    ${mensagem_esperada}
    Wait Until Page Contains    ${mensagem_esperada}
    Page Should Contain    ${mensagem_esperada}

Verificar Mensagem de Erro
    [Arguments]    ${mensagem_esperada}
    Wait Until Page Contains    ${mensagem_esperada}
    Page Should Contain    ${mensagem_esperada}

Verificar Redirecionamento para Login
    Wait Until Location Contains    /login
    Location Should Be    ${URL}/login

Verificar Login com Sucesso
    Wait Until Page Does Not Contain    Login

Verificar Acesso à Página Home
    Wait Until Location Contains    /home
    Page Should Contain    Serverest Store
    Page Should Contain Element    xpath=//nav//a[contains(text(), 'Logout')]

# Keywords para testes de API
Criar Usuário Via API
    [Arguments]    ${nome}    ${email}    ${senha}    ${administrador}=false
    ${body}=    Create Dictionary    nome=${nome}    email=${email}    password=${senha}    administrador=${administrador}
    ${response}=    POST    ${API_URL}/usuarios    json=${body}
    [Return]    ${response}

Listar Produtos Via API
    ${response}=    GET    ${API_URL}/produtos
    [Return]    ${response}
