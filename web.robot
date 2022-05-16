Documentation    This testsuite is to validate the demo website

*** Settings ***
Library    SeleniumLibrary

Suite Teardown    close


*** Variables ***
${URL}    https://opensource-demo.orangehrmlive.com/
@{CREDENTIALS}    Admin    admin123

*** Test Cases ***
Login to website
    Open Browser   ${URL}     chrome
    Set Browser Implicit Wait    5
    Input Text    id= txtUsername    ${CREDENTIALS}[0]
    Input Text    id= txtPassword    ${CREDENTIALS}[1]
    Click Button   id= btnLogin
    Sleep    3

Update my details
    #Click Link    href=https://opensource-demo.orangehrmlive.com/index.php/pim/viewMyDetails
    Maximize Browser Window    
    Click Element   id= menu_admin_viewAdminModule
    Click Element   id= menu_pim_viewMyDetails
    Click Button    id= btnSave
    Sleep     3
    Input Text    id= personal_txtEmpFirstName   Samuel  
    Input Text    id= personal_txtEmpLastName    Johnes 
    Input Text    id= personal_txtEmployeeId     22190   
    Click Element    //*[@id="frmEmpPersonalDetails"]/fieldset/ol[3]/li[1]/ul/li[1]/label
    Select From List By Value    id=personal_cmbNation      10
    Sleep    10
    Click Button    id= btnSave
*** Keywords ***
close
    Close Browser