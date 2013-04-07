/**
Moralife Introduction completion - Conclude the introduction so that the rest of the test suite can progress.
 
@author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org

@date 05/28/2012
@file introcompletion.js
*/

#import "include/uiajsinclude.js"

var testSuiteName = "Introduction Completion (1introcompletion.js)";
var testCaseName;

UIALogger.logMessage(testSuiteName + " Testing Begins");

testCaseName = testSuiteName + " UINavigationBar unloaded";

UIALogger.logStart(testCaseName + " Test");

if (!app.navigationBar().buttons()["Journal"].checkIsValid()){
	
	UIALogger.logPass(testCaseName + " correctly."); 
	
    target.delay(5.0);

    testCaseName = testSuiteName + " Thought bubble tap";
    UIALogger.logStart(testCaseName + " Test");
    
    if (window.buttons()["Conscience thought bubble"].checkIsValid()){ 
        
        window.buttons()["Conscience thought bubble"].tap();
		
        UIALogger.logPass(testCaseName + " available."); 
        
    } else {
        UIALogger.logFail(testCaseName + " unavailable."); 
    }

	testCaseName = testSuiteName + " Introduction skip";
    UIALogger.logStart(testCaseName + " Test");
    
    if (window.buttons()["Next"].checkIsValid()){ 

        window.buttons()["Next"].tap();
		
        UIALogger.logPass(testCaseName + " available."); 

    } else {
        UIALogger.logFail(testCaseName + " unavailable."); 
    }
		
    target.delay(5.0);

    testCaseName = testSuiteName + " UINavigationBar Journal verification";
    UIALogger.logStart(testCaseName + " Test");
        
    if (app.navigationBar().buttons()["Journal"].checkIsValid()){

        UIALogger.logPass(testCaseName + " passed."); 
        
    } else {
        UIALogger.logFail(testCaseName + " failed."); 
    }

    testCaseName = testSuiteName + " UINavigationBar Collection verification";
    UIALogger.logStart(testCaseName + " Test");

    if (app.navigationBar().buttons()["Collection"].checkIsValid()){

        UIALogger.logPass(testCaseName + " passed.");

    } else {
        UIALogger.logFail(testCaseName + " failed.");
    }
    
} else {
	UIALogger.logFail(testCaseName + " incorrectly."); 
}

UIALogger.logMessage(testSuiteName + " Testing Ends");
