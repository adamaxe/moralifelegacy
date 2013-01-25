/**
Moralife Help Screen dismissals
 
@author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org

@date 05/28/2012
@file helpscreendismissals.js
*/

#import "include/uiajsinclude.js"

var testSuiteName = "Help Screen Dismissal";
var testCaseName;

UIALogger.logMessage(testSuiteName + " Testing Begins");

testCaseName = testSuiteName + " UINavigationBar loaded";

UIALogger.logStart(testCaseName + " Test");

if (app.navigationBar().buttons()["Journal"].checkIsValid()){
	
	UIALogger.logPass(testCaseName + " correctly."); 
	
    testCaseName = testSuiteName + " Journal Help Screens";
    UIALogger.logStart(testCaseName + " Test");
        
    if (app.navigationBar().buttons()["Journal"].checkIsValid()){ 
        
        app.navigationBar().buttons()["Journal"].tap();
        window.buttons()["Previous"].tap();
        window.buttons()["Moral Choice"].tap();
        window.buttons()["Previous"].tap();
        app.navigationBar().rightButton().tap();
        window.buttons()["Previous"].tap();
        app.navigationBar().buttons()["Home"].tap();
        app.navigationBar().buttons()["Collection"].tap();
        window.buttons()["Previous"].tap();

        UIALogger.logPass(testCaseName + " passed."); 
        
    } else {
        UIALogger.logFail(testCaseName + " incorrect."); 
    }
        
    testCaseName = testSuiteName + " Conscience View Help Screen";
    UIALogger.logStart(testCaseName + " Test");
    app.navigationBar().buttons()["Home"].tap();        
    target.tap({x:130.00, y:300.00});
    
    if (window.buttons()["Previous"].checkIsValid()){ 
    
        window.buttons()["Previous"].tap();
        UIALogger.logPass(testCaseName + " passed."); 
        
    } else {
        UIALogger.logFail(testCaseName + " incorrect."); 
    }

    testCaseName = testSuiteName + " Commissary Help Screen";
    UIALogger.logStart(testCaseName + " Test");

    window.buttons()["Commissary"].tap();
    window.buttons()["Features"].tap();
    window.buttons()["Eye"].tap();
    target.delay(2.0);    
    
    if (window.buttons()["Previous"].checkIsValid()){ 
    
        window.buttons()["Previous"].tap();
		target.delay(2.0);
        window.buttons()["Previous"].tap();
		target.delay(2.0);		
        window.buttons()["Previous"].tap();
		target.delay(2.0);		
        window.buttons()["Previous"].tap();
        UIALogger.logPass(testCaseName + " passed."); 
        
    } else {
        UIALogger.logFail(testCaseName + " incorrect."); 
    }
        
    testCaseName = testSuiteName + " Morathology Help Screen";
    UIALogger.logStart(testCaseName + " Test");
    
    window.buttons()["Morathology"].tap();
    window.buttons()["Orientation"].tap();
    target.delay(2.0);
    
    if (window.buttons()["Previous"].checkIsValid()){ 
		
        window.buttons()["Previous"].tap();
		target.delay(2.0);		
        window.buttons()["Previous"].tap();
		target.delay(2.0);
        window.buttons()["Previous"].tap();
        UIALogger.logPass(testCaseName + " passed."); 
        
    } else {
        UIALogger.logFail(testCaseName + " incorrect."); 
    }
        
    testCaseName = testSuiteName + " Moral Report Help Screen";
    UIALogger.logStart(testCaseName + " Test");
    
    window.buttons()["Moral Report"].tap();
    target.delay(2.0);
    
    if (window.buttons()["Previous"].checkIsValid()){ 
        
        window.buttons()["Previous"].tap();
		target.delay(2.0);
        window.buttons()["Previous"].tap();
		target.delay(2.0);
        window.buttons()["Previous"].tap();
        
        UIALogger.logPass(testCaseName + " passed."); 
        
    } else {
        UIALogger.logFail(testCaseName + " incorrect."); 
    }
    
    app.navigationBar().buttons()["Home"].tap();
		
} else {
	UIALogger.logFail(testCaseName + " incorrectly."); 
}