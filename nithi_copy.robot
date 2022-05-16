*** Settings ***
Library             OperatingSystem
#Library             lib/LoginLibrary_copy.py
Library             C:\Users\ett19798\.jenkins\workspace\RobotAutomation\lib\LoginLibrary_copy.py
Library             DebugLibrary
Library             String
#Library             commands-Copy
# Suite Setup         Clear Login Database
# Test Teardown       Clear Login Database

Force Tags          quickstart
Default Tags        example    smoke


*** Variables ***
@{USERNAME}                 janedoe    Sam    Peter    John    Maria
@{PASSWORD}                 J4n3D0ee    S2q12qww    P34gTuvv    J1nM2qww    M12vx5q
@{EMAIL}                    Jane.doe@gmail.com    Sam.new@hotmail.com    Peter.pan@yahoo.com    John.cook@nmn.com    Maria.janzz@zzz.com
${INVALID PASSWORD}         e0D3n4J  
@{NEW PASSWORD}             Jzx23QW    Sqw89NM    Pt90QIK    Jil786T    MzaTYp123 
@{WRONG PASSWORD LEN}       Io122    qwerttyuoas12345    
&{WRONG PASSWORD CONTENT}    1=ABCDABC    2=abcabcc    3=12312312    4=ABCabca 
@{INVALID EMAIL}            Jane.doegmail.com    Sam.new@hotmail    @yahoo.com    John.cook&nmn.com                 
${DATABASE FILE}            ${TEMPDIR}${/}robotframework-quickstart-db.txt
${PWD INVALID LENGTH}       Password must be 7-12 characters long
${PWD INVALID CONTENT}      Password must be a combination of lowercase and uppercase letters and numbers
${EMAIL VALIDATION}         Validation of email address

*** Test Cases ***
##Testcase 1###
User can create an account and log in 
    Create valid User    ${USERNAME}[1]   ${PASSWORD}[1]    ${EMAIL}[1]
    Attempt to Login with Credentials    ${USERNAME}[1]    ${PASSWORD}[1] 
    Status Should Be    Logged In

##Testcase 2###
User can create multiple accounts and log into all
    FOR    ${user}    ${pass}    ${mail}    IN ZIP    ${USERNAME}    ${PASSWORD}    ${EMAIL}
        Create valid User    ${user}   ${pass}    ${mail}   
        Attempt to Login with Credentials    ${user}   ${pass}
        Status Should Be    Logged In
    END

# ##Testcase 3###
User SHOULD NOT be able to login using invalid password for above created accounts
    FOR    ${user}    IN     @${USERNAME}        
        Attempt to Login with Credentials    ${user}   ${INVALID PASSWORD}
        Status Should Be    Access Denied

    END

# # ##Testcase 4###
User should be able to change new password.
    FOR    ${user}    ${pass}    ${newpass}    IN ZIP    ${USERNAME}    ${PASSWORD}    ${NEW PASSWORD}   
        Change password    ${user}   ${pass}    ${newpass} 
        Status should be    SUCCESS
    END

# ##Testcase 5###
User should be able to login with new password
     FOR    ${user}    ${pass}    IN ZIP    ${USERNAME}    ${NEW PASSWORD}        
        Attempt to Login with Credentials    ${user}   ${pass}
        Status Should Be    Logged In
    END

# # ##Testcase 6###
User Login using old password should fail.
    FOR    ${user}    ${pass}    IN ZIP    ${USERNAME}    ${PASSWORD}         
        Attempt to Login with Credentials    ${user}   ${pass}
        Status Should Be    Access Denied
    END

# ##Testcase 7###
Validation of password for invalid password length and content
    [Template]    Creating user with invalid password should fail
    FOR    ${val}    IN     @{WRONG PASSWORD LEN}        
            ${val}    ${PWD INVALID LENGTH}
    END
    
    FOR    ${pwd}    ${value}    IN    &{WRONG PASSWORD CONTENT}        
           ${value}    ${PWD INVALID CONTENT}
    END

# ##Testcase 8###
Validate INVALID email address are NOT ACCEPTED
    FOR   ${user}  ${mail}    IN ZIP    ${USERNAME}   ${INVALID EMAIL}       
           validate_email   ${user}  ${mail} 
           Status Should Be   Failed
    END

##Testcase 9###
Log the database file to console   
    ${Cmd_Output}=  Get File    ${DATABASE FILE}
    @{Lines}=    Split To Lines       ${Cmd_Output}
    FOR   ${line}     IN      @{Lines}
       ${Value}=   Get Variable Value  ${line}
       log to console    (${Value})
    END

*** Keywords ***
Clear login database
    Remove file    ${DATABASE FILE}

Create valid user
        [Arguments]    ${username}    ${password}    ${email}    
        Create user    ${username}    ${password}    ${email}    
        Status should be    SUCCESS

Creating user with invalid password should fail
        [Arguments]    ${password}    ${error}
        Create user    ${username}[1]    ${password}     ${email}[1]
        Status should be    Creating user failed: ${error}

Login
        [Arguments]    ${username}    ${password}    
        Attempt to login with credentials    ${username}    ${password}   
        Status should be    Logged In

User can change password
     Change password    ${USERNAME}    ${PASSWORD}    ${NEW PASSWORD}
     Status should be    SUCCESS

User should be able to login with new password
    [Arguments]    ${username}    ${password}    
    Attempt to login with credentials    ${username}    ${password}   
    Status should be    Logged In    

She cannot use the old password anymore
    Attempt to login with credentials    ${USERNAME}    ${PASSWORD}    
    Status should be    Access Denied

Validate INVALID email address are NOT ACCEPTED
        [Arguments]     ${username}    ${email}
        validate_email   ${username}    ${email}
        Status should be    Invalid email address

Database Should Contain
    [Arguments]    ${username}    ${password}    ${email}    ${status}
    ${database} =    Get File    ${DATABASE FILE}
    Should Contain    ${database}    ${username}\t${password}\t${email}\t${status}\n

Log the database file to console 