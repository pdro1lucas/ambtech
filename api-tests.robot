*** Settings ***
Documentation     Testes de API para o ServeRest https://serverest.dev/
Resource          resource.robot
Library           RequestsLibrary
Library           Collections
Library           String

*** Variables ***
${API_URL}        https://serverest.dev

*** Test Cases ***
Cenário 1: Cadastro de Usuário via API
    ${random_string}=    Generate Random String    5    [LOWER]
    ${email}=    Set Variable    user_${random_string}@teste.com
    ${nome}=    Set Variable    Usuário Teste ${random_string}
    ${password}=    Set Variable    teste123
    
    ${body}=    Create Dictionary    nome=${nome}    email=${email}    password=${password}    administrador=true
    
    ${response}=    POST    ${API_URL}/usuarios    json=${body}    expected_status=201
    
    Dictionary Should Contain Key    ${response.json()}    message
    Dictionary Should Contain Value    ${response.json()}    message    Cadastro realizado com sucesso
    Dictionary Should Contain Key    ${response.json()}    _id

Cenário 2: Cadastro com Caracteres Acima do Limite para os Campos de Login
    ${nome_longo}=    Generate Random String    150    [LOWER]
    ${email_longo}=    Generate Random String    100    [LOWER]
    ${email_longo}=    Set Variable    ${email_longo}@teste.com
    ${senha_longa}=    Generate Random String    200    [LOWER]
    
    ${body}=    Create Dictionary    nome=${nome_longo}    email=${email_longo}    password=${senha_longa}    administrador=true
    
    ${response}=    POST    ${API_URL}/usuarios    json=${body}    expected_status=400
    
    Dictionary Should Contain Key    ${response.json()}    message
    Dictionary Should Contain Value    ${response.json()}    message    password não pode ter mais de 100 caracteres

Cenário 3: Listar Produtos Cadastrados
    ${response}=    GET    ${API_URL}/produtos    expected_status=200
    
    Dictionary Should Contain Key    ${response.json()}    quantidade
    Dictionary Should Contain Key    ${response.json()}    produtos
    
    ${produtos}=    Get From Dictionary    ${response.json()}    produtos
    Should Not Be Empty    ${produtos}
