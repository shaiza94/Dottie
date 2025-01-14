*** Settings ***
Library    QForce
Resource                      ../resources/commondottie.robot
Suite Setup                   Setup Browser
Suite Teardown                End suite

*** Test Cases ***
Test Case 1- Validation Document for Dottie AI- Pre 4
    Login
    Create Change Control Record and Relate Effectivness Check
    Create Deviation Reocrd and Relate CAPA record
    Create Complaint Record and Relate Batch Record
    Create CAPA Plan Record and Relate Investigation Record
    Create Investigation Task Record and Relate to MRB
    Create Assessment record and Relate Change Control
    Create Assessment Element record and relate to Assessment record
    Create Quality Event record and relate to Product Item record
    Create Immediate Action Record and Relate Deviation
    Create CAPA record and relate to Assessment record
    Create Audit record and relate Finding record
    Create Action Item record and Relate Change Control
    
    
    
    

