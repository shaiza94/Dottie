*** Settings ***
Documentation             Example resource file with custom keywords. NOTE: Some keywords below may need
...                       minor changes to work in different instances.
Library                   QForce
Library                   String
Library                   FakerLibrary
Library                   DateTime


*** Variables ***
# IMPORTANT: Please read the readme.txt to understand needed variables and how to handle them!!
${BROWSER}                chrome
${username}               admin@dottie2v51.com.dottiebeta
${password}               Dotbcs03
${username_title}         admin dottie2v51
${login_url}              https://dottie2v51--dottiebeta.sandbox.lightning.force.com            # Salesforce instance. NOTE: Should be overwritten in CRT variables
${home_url}               ${login_url}/lightning/page/home


*** Keywords ***
Setup Browser
    # Setting search order is not really needed here, but given as an example 
    # if you need to use multiple libraries containing keywords with duplicate names
    Set Library Search Order                          QForce    QWeb
    Open Browser          about:blank                 ${BROWSER}
    SetConfig             LineBreak                   ${EMPTY}               #\ue000
    Evaluate              random.seed()               random                 # initialize random generator
    SetConfig             DefaultTimeout              45s                    #sometimes salesforce is slow
    # adds a delay of 0.3 between keywords. This is helpful in cloud with limited resources.
    SetConfig             Delay                       0.3

End suite
    Close All Browsers


Sign with admin
    TypeText    User                   ${username}
    TypeText    User Password          ${password}   
    ClickText   Sign     

ChooseCurrentDate
    ${TODAYDATE}       Get Current Date       result_format=%m/%d/%Y
    TypeText           Base Date              ${TODAYDATE}

Generate Name
    ${NEWNAME1}            Generate Random String    4     [NUMBERS]
    ${NEWNAME2}            Catenate                  Test ${NEWNAME1}    
    TypeText               Name                      ${NEWNAME2}   


Create Change Control Record and Relate Effectivness Check
    LaunchApp    Change Controls
    VerifyText   Change Controls
    ClickText    New
    VerifyText   New Change Control   
    TypeText     *Change Control Name    CC With Related EC 
    PickList     Business Unit    General
    ClickText    Save          anchor=Cancel    partial_match=false
    ClickText    Effectiveness Check
    ClickText    New    partial_match=False
    ${ECNAME1}           Generate Random String    4     [NUMBERS]
    ${ECNAME2}           Catenate                  Test ${ECNAME1}    
    TypeText             *Effectiveness Check Name     ${ECNAME2}    anchor=*
    ${TODAYDATE}       Get Current Date       result_format=%m/%d/%Y
    TypeText           *Due Date              ${TODAYDATE} 
    ClickText    Save          anchor=Cancel    partial_match=false


Create Deviation Reocrd and Relate CAPA record
    LaunchApp    Deviations
    VerifyText   Deviations
    ClickText    New
    VerifyText   New Deviation   
    TypeText     *Deviation Name    DEV With Related CAPA 
    PickList     Main Deviation Type    Equipment
    ${TODAYDATE}       Get Current Date       result_format=%m/%d/%Y
    TypeText           *Event Date            ${TODAYDATE} 
    ClickText    Save          anchor=Cancel    partial_match=false
    ClickText    CAPAs
    ClickText    New           anchor=Related Existing CAPAs
    ${CAPANAME1}           Generate Random String    4     [NUMBERS]
    ${CAPANAME2}           Catenate                  Test ${CAPANAME1}    
    TypeText               *CAPA Name     ${CAPANAME2}    anchor=*
    PickList    *Action Type              Corrective Action
    TypeText    *Action Plan Description  Test
    TypeText    *Planned Due Date            ${TODAYDATE} 
    ClickText    Save          anchor=Cancel    partial_match=false

Create Complaint Record and Relate Batch Record
    LaunchApp    Batch Records
    VerifyText   Batch Records
    ClickText    New
    VerifyText   New Batch Record
    TypeText     *Batch Record Name    Batch Record for Complaint
    ClickText    Save          anchor=Cancel    partial_match=false
    LaunchApp    Complaints
    VerifyText   Complaints
    ClickText    New
    VerifyText   New Complaint
    ClickText    Next   
    TypeText     *Complaint Name    Complaint With Related Batch Record
    ${TODAYDATE}       Get Current Date       result_format=%m/%d/%Y
    TypeText           *Date Received         ${TODAYDATE}
    TypeText           *Event Date            ${TODAYDATE}
    ClickText    Save          anchor=Cancel    partial_match=false
    ClickText    New Relation                   anchor=Related Batch Records
    ComboBox    Search Batch Records...    Batch Record for Complaint
    ClickText    Save

Create CAPA Plan Record and Relate Investigation Record
    LaunchApp    CAPA Plans
    VerifyText   CAPA Plans
    ClickText    New
    VerifyText   New CAPA Plan
    TypeText     *CAPA Plan Name    CAPA Plan with related investigation record
    ClickText    Save          anchor=Cancel    partial_match=false
    ClickText    Investigation
    ClickText    New           anchor=Investigation Tasks
    TypeText     *Investigation Task Name       Investigation Record for CAPA Plan
    ${TODAYDATE}       Get Current Date       result_format=%m/%d/%Y
    TypeText           *Due Date         ${TODAYDATE}
    ClickText    Save          anchor=Cancel    partial_match=false

Create Investigation Task Record and Relate to MRB
    LaunchApp    MRBs
    VerifyText   MRBs
    ClickText    New
    VerifyText   New MRB: MRB
    TypeText     *MRB Name    MRB Record for Investigation
    TypeText     *Description    Test
    ClickText    Save          anchor=Cancel    partial_match=false
    LaunchApp    Investigation Tasks
    VerifyText   Investigation Tasks
    ClickText    New
    VerifyText   New Investigation Task
    TypeText     *Investigation Task Name    Investigation Task with related MRB record
    ${TODAYDATE}       Get Current Date       result_format=%m/%d/%Y
    TypeText           *Due Date         ${TODAYDATE}
    ClickText    Save          anchor=Cancel    partial_match=false
    ClickText    New Relation                   anchor=MRBs
    ComboBox     Search MRBs...                 MRB Record for Investigation                 
    ClickText    Save

Create Assessment record and Relate Change Control
    LaunchApp    Change Controls
    VerifyText   Change Controls
    ClickText    New
    VerifyText   New Change Control: General
    TypeText     *Change Control Name    CC Record for Assessment
    PickList     Business Unit    General
    ClickText    Save          anchor=Cancel    partial_match=false
    LaunchApp    Assessments
    VerifyText   Assessments
    ClickText    New
    VerifyText   New Assessment
    ClickText    Next
    VerifyText   New Assessment: Risk Assessment
    TypeText     *Assessment Name    Assessment record with related CC
    PickList     Business Unit    General
    ClickText    Save          anchor=Cancel    partial_match=false
    ClickText    Edit    partial_match=False
    ComboBox     Search Change Controls...      CC Record for Assessment                             
    ClickText    Save          anchor=Cancel    partial_match=false

Create Assessment Element record and relate to Assessment record 
    LaunchApp    Assessments
    VerifyText   Assessments
    ClickText    New
    VerifyText   New Assessment
    ClickText    Next
    VerifyText   New Assessment: Risk Assessment
    TypeText     *Assessment Name    Assessment record for Assessment Element
    PickList     Business Unit    General
    ClickText    Save          anchor=Cancel    partial_match=false
    LaunchApp    Assessment Elements 
    VerifyText   Assessment Elements
    ClickText    New
    VerifyText   New Assessment Element
    ClickText    Next
    TypeText     *Risk Title    Assessment Element record with related Assessment
    TypeText     *Potential Failure Mode (Hazard)    Test
    TypeText     *Process Step/Function    3
    TypeText     *Potential Failure Effect (Harm)    Test
    TypeText     *Potential Failure Cause            Test
    TypeText     *Current Controls                   Test
    PickList     *Severity                           2 Minor
    PickList     *Probability                        2 Remote
    PickList     *Detection                          5 Not Likely   
    ComboBox     Search Assessments...          Assessment record for Assessment Element                 
    ClickText    Save          anchor=Cancel    partial_match=false

Create Quality Event record and relate to Product Item record 
    LaunchApp    Product Items
    VerifyText   Product Items
    ClickText    New
    VerifyText   New Product Item
    TypeText     *Product Name    Product Item record for Quality Event
    PickList     *Unit of Measure    Liter
    ClickText    Save          anchor=Cancel    partial_match=false
    LaunchApp    Quality Events
    VerifyText   Quality Events
    ClickText    New
    VerifyText   New Quality Event
    TypeText     *Quality Event Name            QE record with related Product Item record
    ${TODAYDATE}       Get Current Date       result_format=%m/%d/%Y
    TypeText           *Event Date         ${TODAYDATE}
    ClickText    Save          anchor=Cancel    partial_match=false
    ClickText    New Relation                   anchor=Related Products
    ComboBox     Search Product Items...        Product Item record for Quality Event
    ClickText    Save


Create Immediate Action Record and Relate Deviation
    LaunchApp    Deviations
    VerifyText   Deviations
    ClickText    New
    VerifyText   New Deviation
    TypeText     *Deviation Name    Deviation Record for Immediate Action Record
    PickList     *Main Deviation Type    Equipment
    ${TODAYDATE}       Get Current Date       result_format=%m/%d/%Y
    TypeText           *Event Date         ${TODAYDATE}
    ClickText    Save          anchor=Cancel    partial_match=false
    LaunchApp    Immediate Actions
    VerifyText   Immediate Actions
    ClickText    New
    VerifyText   New Immediate Action
    TypeText     *Immediate Action Name    Immediate Action record with related Deviation
    ComboBox     Search People...          ${username_title}
    TypeText     *Action Description       Test
    TypeText     *Planned Due Date         ${TODAYDATE}           
    ComboBox     Search Deviations...      Deviation Record for Immediate Action Record                          
    ClickText    Save          anchor=Cancel    partial_match=false
    ClickText    Actions       delay=2s
    ClickText    Submit to QA

Create CAPA record and relate to Assessment record 
    LaunchApp    Assessments
    VerifyText   Assessments
    ClickText    New
    VerifyText   New Assessment
    ClickText    Next
    VerifyText   New Assessment: Risk Assessment
    TypeText     *Assessment Name    Assessment record for CAPA
    PickList     Business Unit    General
    ClickText    Save          anchor=Cancel    partial_match=false
    LaunchApp    CAPAs 
    VerifyText   CAPAs
    ClickText    New
    VerifyText   New CAPA
    TypeText     *CAPA Name   CAPA record with related Assessment
    PickList     *Action Type                   Corrective Action
    TypeText     *Action Plan Description    Test
    ${TODAYDATE}       Get Current Date       result_format=%m/%d/%Y
    TypeText           *Planned Due Date         ${TODAYDATE}         
    ClickText    Save          anchor=Cancel    partial_match=false
    ClickText    Assessment    anchor=Details    
    ClickText    New Relation                   anchor=Related Assessments
    ComboBox     Search Assessments...          Assessment record for CAPA                 
    ClickText    Save          anchor=Cancel    partial_match=false

Create Audit record and relate Finding record 
    LaunchApp    Audits
    VerifyText   Audits
    ClickText    New
    VerifyText   New Audit
    ClickText    Next
    VerifyText   New Audit: Internal Audit
    TypeText     *Audit Name    Audit record with related Finding
    PickList     Business Unit    General
    ClickText    Save          anchor=Cancel    partial_match=false
    ClickText    Findings    anchor=Details
    ClickText    New         anchor=Findings
    ClickText    Internal Audit
    ClickText    Next
    TypeText     *Finding Name                  Finding Record for Audit
    PickList     Business Unit    General
    ClickText    Save          anchor=Cancel    partial_match=false


Create Action Item record and Relate Change Control
    LaunchApp    Change Controls
    VerifyText   Change Controls
    ClickText    New
    VerifyText   New Change Control: General
    TypeText     *Change Control Name    CC Record for Action Item
    PickList     Business Unit    General
    ClickText    Save          anchor=Cancel    partial_match=false
    LaunchApp    Home
    LaunchApp    Action Items
    VerifyText   Action Items
    ClickText    New
    VerifyText   New Action Item                anchor=Required Information
    TypeText     *Action Item Name    Action Items record with related CC
    ComboBox     Search People...          ${username_title}
    TypeText     *Action Description       Test
    ${TODAYDATE}       Get Current Date       result_format=%m/%d/%Y
    TypeText           *Planned Due Date         ${TODAYDATE}        
    ComboBox     Search Change Controls...      CC Record for Action Item                             
    ClickText    Save          anchor=Cancel    partial_match=false

Create Doc A
    LaunchApp    Master Documents
    ClickText    New
    VerifyText    New Master Document
    ClickText    Simple    anchor=Select a record type
    ClickText    Next
    VerifyText    New Master Document: Simple
    PickList      *Business Unit    General
    TypeText      *Document Name    DOC A
    PickList      *Document Type    Addendum
    ComboBox      Search Departments...    QA  #The depatment should be on the enviornment//
    PickList      Is this a Form or Translation?    No    
    ClickText    Save          anchor=Cancel    partial_match=false
    VerifyText    Upload Files  
    UploadFile    Upload Files                   ../Files_To_Upload/Test 0.docx    delay=5s
    ClickText     Done                        delay=2s
    VerifyText    Test 0

Create Doc B
    LaunchApp    Master Documents
    ClickText    New
    VerifyText   New Master Document
    ClickText    Simple    anchor=Select a record type
    ClickText    Next
    VerifyText    New Master Document: Simple
    PickList      *Business Unit    General
    TypeText      *Document Name    DOC B
    PickList      *Document Type    Addendum
    ComboBox      Search Departments...    QA  #The depatment should be on the enviornment//
    PickList      Is this a Form or Translation?    No    
    ClickText    Save          anchor=Cancel    partial_match=false
    VerifyText    Upload Files  
    UploadFile    Upload Files                   ../Files_To_Upload/Test 1.pdf    delay=5s
    ClickText     Done                        delay=2s
    VerifyText    Test 1

Create Doc C
    LaunchApp    Master Documents
    ClickText    New
    VerifyText   New Master Document
    ClickText    Simple    anchor=Select a record type
    ClickText    Next
    VerifyText   New Master Document: Simple
    PickList     *Business Unit    General
    TypeText     *Document Name    DOC C
    PickList     *Document Type    Addendum
    ComboBox     Search Departments...    QA  #The depatment should be on the enviornment//
    PickList     Is this a Form or Translation?    No    
    ClickText    Save          anchor=Cancel    partial_match=false
    VerifyText   Upload Files  
    UploadFile   Upload Files                   ../Files_To_Upload/Test 2.pptx    delay=5s
    ClickText    Done                        delay=2s
    VerifyText   Test 2

Create Doc D
    LaunchApp    Master Documents
    ClickText    New
    VerifyText   New Master Document
    ClickText    Simple    anchor=Select a record type
    ClickText    Next
    VerifyText   New Master Document: Simple
    TypeText     *Document Name    DOC D
    PickList     *Business Unit    General
    PickList     *Document Type    Addendum
    ComboBox     Search Departments...    QA  #The depatment should be on the enviornment//
    PickList     Is this a Form or Translation?    No    
    ClickText    Save          anchor=Cancel    partial_match=false
    VerifyText   Upload Files  
    UploadFile   Upload Files                   ../Files_To_Upload/Test 3.xlsx    delay=5s
    ClickText    Done                        delay=2s
    VerifyText   Test 3

Create Doc E
    LaunchApp    Master Documents
    ClickText    New
    VerifyText   New Master Document
    ClickText    Simple    anchor=Select a record type
    ClickText    Next
    VerifyText   New Master Document: Simple
    TypeText     *Document Name    DOC E
    PickList     *Business Unit    General
    PickList     *Document Type    Addendum
    ComboBox     Search Departments...    QA  #The depatment should be on the enviornment//
    PickList     Is this a Form or Translation?    No    
    ClickText    Save          anchor=Cancel    partial_match=false
    VerifyText   Upload Files  
    UploadFile   Upload Files                   ../Files_To_Upload/Test 4.csv    delay=5s
    ClickText    Done                        delay=2s
    VerifyText   Test 4

Create Doc F
    LaunchApp    Master Documents
    ClickText    New
    VerifyText   New Master Document
    ClickText    Simple    anchor=Select a record type
    ClickText    Next
    VerifyText   New Master Document: Simple
    TypeText     *Document Name    DOC F
    PickList     *Business Unit    General
    PickList     *Document Type    Addendum
    ComboBox     Search Departments...    QA  #The depatment should be on the enviornment//
    PickList     Is this a Form or Translation?    No    
    ClickText    Save          anchor=Cancel    partial_match=false
    VerifyText   Upload Files  
    UploadFile   Upload Files                   ../Files_To_Upload/Test 5.html    delay=5s
    ClickText    Done                        delay=2s
    VerifyText   Test 5

Create KBA 1
    LaunchApp    Knowledge Base Articles
    VerifyText   Knowledge Base Articles
    ClickText    New
    VerifyText   New Knowledge Base Article
    TypeText     *Knowledge Base Article Name    KBA 1
    PickList     *Business Unit    General
    PickList     *Type             FAQs            
    PickList     *Knowledge Area                 Knowledge Area A   
    ClickText    Save          anchor=Cancel    partial_match=false
    VerifyText                 KBA 1            anchor=Knowledge Base Article Name
    ClickText                  Edit             anchor=Clone Article    partial_match=false
    MultiPickList    Classification    Classification A
    MultiPickList    Sub Knowledge Area    Sub Knowledge Area A
    TypeText    Keywords    Test
    PickList    Created Source    Department A
    MultiPickList    Audience              Audience A
    ClickText    Move selection to Chosen       anchor=Distribution
    ComboBox     Search People...          ${username_title}
    ${current_date}=   Get Current Date
    ${NEXTWEEKDAY}=    Add Time To Date    ${current_date}    7 days    result_format=%d/%m/%Y
    ${TODAYDATE}       Get Current Date       result_format=%d/%m/%Y
    TypeText           Expiration Date     ${NEXTWEEKDAY} 
    TypeText           Last Update         ${NEXTWEEKDAY} 
    TypeText           Review Date         ${TODAYDATE}
    ClickText    Save          anchor=Cancel    partial_match=false
    UploadFile                 Upload Files      ../Files_To_Upload/DS - check 1 - Medical Device.docx    delay=5s      
    ClickText    Done                        delay=2s
    VerifyText   DS - check 1 - Medical Device
    ClickText                  Content Editor             anchor=Clone Article    partial_match=false
    


    
    








    







Login
    [Documentation]       Login to Salesforce instance. Takes instance_url, username and password as
    ...                   arguments. Uses values given in Copado Robotic Testing's variables section by default.
    [Arguments]           ${sf_instance_url}=${login_url}    ${sf_username}=${username}   ${sf_password}=${password}  
    GoTo                  ${sf_instance_url}
    TypeText              Username                    ${sf_username}             delay=1
    TypeSecret            Password                    ${sf_password}
    ClickText             Log In
    # We'll check if variable ${secret} is given. If yes, fill the MFA dialog.
    # If not, MFA is not expected.
    # ${secret} is ${None} unless specifically given.
    ${MFA_needed}=       Run Keyword And Return Status          Should Not Be Equal    ${None}       ${secret}
    Run Keyword If       ${MFA_needed}               Fill MFA   ${sf_username}         ${secret}    ${sf_instance_url}                                            


Login As
    [Documentation]       Login As different persona. User needs to be logged into Salesforce with Admin rights
    ...                   before calling this keyword to change persona.
    ...                   Example:
    ...                   LoginAs    Chatter Expert
    [Arguments]           ${persona}
    ClickText             Setup
    ClickItem             Setup      delay=1
    SwitchWindow          NEW
    TypeText              Search Setup                ${persona}             delay=2
    ClickElement          //*[@title\="${persona}"]   delay=2    # wait for list to populate, then click
    VerifyText            Freeze                      timeout=45                        # this is slow, needs longer timeout          
    ClickText             Login                       anchor=Freeze          partial_match=False    delay=1 


Fill MFA
    [Documentation]      Gets the MFA OTP code and fills the verification dialog (if needed)
    [Arguments]          ${sf_username}=${username}    ${mfa_secret}=${secret}  ${sf_instance_url}=${login_url}
    ${mfa_code}=         GetOTP    ${sf_username}   ${mfa_secret}   ${login_url}  
    TypeSecret           Verification Code       ${mfa_code}      
    ClickText            Verify 


Home
    [Documentation]       Example appstarte: Navigate to homepage, login if needed
    GoTo                  ${home_url}
    ${login_status} =     IsText                      To access this page, you have to log in to Salesforce.    2
    Run Keyword If        ${login_status}             Login
    ClickText             Home
    VerifyTitle           Home | Salesforce