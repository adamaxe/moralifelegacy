/**
Moralife Introduction completion
 
@author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org

@date 05/28/2012
@file introcompletion.js
*/

#import "include/uiajsinclude.js"

var testSuiteName = "Intro Completion";
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
        
//        app.navigationBar().buttons()["Journal"].tap();

        UIALogger.logPass(testCaseName + " passed."); 
        
    } else {
        UIALogger.logFail(testCaseName + " failed."); 
    }

//    testCaseName = testSuiteName + " UINavigationBar Home verification";
//    UIALogger.logStart(testCaseName + " Test");
//
//    if (app.navigationBar().buttons()["Home"].checkIsValid()){
//
//        app.navigationBar().buttons()["Home"].tap();
//
//        UIALogger.logPass(testCaseName + " passed.");
//
//    } else {
//        UIALogger.logFail(testCaseName + " failed.");
//    }

    testCaseName = testSuiteName + " UINavigationBar Collection verification";
    UIALogger.logStart(testCaseName + " Test");

    if (app.navigationBar().buttons()["Collection"].checkIsValid()){

//        app.navigationBar().buttons()["Collection"].tap();

        UIALogger.logPass(testCaseName + " passed.");

    } else {
        UIALogger.logFail(testCaseName + " failed.");
    }
    
} else {
	UIALogger.logFail(testCaseName + " incorrectly."); 
}