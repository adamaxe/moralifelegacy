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

testCaseName = testSuiteName + " UITabBar loaded";

UIALogger.logStart(testCaseName + " Test");

if (app.tabBar().buttons()["Home"].checkIsValid()){
	
	UIALogger.logPass(testCaseName + " correctly."); 
	
    testCaseName = testSuiteName + " Initial Help Screens";
    UIALogger.logStart(testCaseName + " Test");
        
    if (app.tabBar().buttons()["Journal"].checkIsValid()){ 
        
        app.tabBar().buttons()["Journal"].tap();
        window.buttons()["Previous"].tap();
        window.buttons()["Moral Choice"].tap();
        window.buttons()["Previous"].tap();
        app.navigationBar().rightButton().tap();
        window.buttons()["Previous"].tap();
        app.tabBar().buttons()["Collection"].tap();
        window.buttons()["Previous"].tap();
        app.tabBar().buttons()["Home"].tap();
        target.tap({x:130.00, y:300.00});
        window.buttons()["Previous"].tap();

        window.buttons()["Commissary"].tap();
        window.buttons()["Features"].tap();
        window.buttons()["Eye"].tap();
		target.delay(2.0);
        window.buttons()["Previous"].tap();
		target.delay(2.0);
        window.buttons()["Previous"].tap();
		target.delay(2.0);		
        window.buttons()["Previous"].tap();
		        
        window.buttons()["Morathology"].tap();
        window.buttons()["Orientation"].tap();
        window.buttons()["Previous"].tap();
        window.buttons()["Previous"].tap();
        window.buttons()["Previous"].tap();
        
        window.buttons()["Moral Report"].tap();
        window.buttons()["Previous"].tap();
        window.buttons()["Previous"].tap();
        window.buttons()["Previous"].tap();
        
        UIALogger.logPass(testCaseName + " passed."); 
        
    } else {
        UIALogger.logFail(testCaseName + " incorrect."); 
    }
    
    app.tabBar().buttons()["Home"].tap();
		
} else {
	UIALogger.logFail(testCaseName + " incorrectly."); 
}