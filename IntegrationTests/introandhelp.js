/**
Moralife UI Main Navigation traversal validation
 
@author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org

@date 05/28/2012
@file mainnavigation.js
*/

#import "include/uiajsinclude.js"

var testSuiteName = "Intro and Help Screen Dismissal";
var testCaseName;

UIALogger.logMessage(testSuiteName + " Testing Begins");

testCaseName = testSuiteName + " UITabBar unloaded";

UIALogger.logStart(testCaseName + " Test");

if (!app.tabBar().buttons()["Home"].checkIsValid()){
	
	UIALogger.logPass(testCaseName + " correctly."); 
	
    target.delay(20.0);
	
	testCaseName = testSuiteName + " Introduction skip";
    UIALogger.logStart(testCaseName + " Test");
    
    if (window.buttons()["Introduction skip"].checkIsValid()){ 

        window.buttons()["Introduction skip"].tap();
		
        UIALogger.logPass(testCaseName + " available."); 

    } else {
        UIALogger.logFail(testCaseName + " unavailable."); 
    }
		
    target.delay(5.0);

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
        window.buttons()["Previous"].tap();
        target.tap({x:130.00, y:300.00});
        window.buttons()["Commissary"].tap();
        window.buttons()["Features"].tap();
        window.buttons()["Previous"].tap();
        window.buttons()["Colors"].tap();
        window.buttons()["Previous"].tap();
        window.buttons()["Accessories"].tap();
        window.buttons()["Previous"].tap();
        window.buttons()["Previous"].tap();
        window.buttons()["Morathology"].tap();
        window.buttons()["Previous"].tap();
        window.buttons()["Moral Report"].tap();
        window.buttons()["Previous"].tap();

        
//        window.buttons()["Previous"].tap();
//        window.buttons()["icon customization"].tap();
//        window.buttons()["icon features"].tap();
//        window.buttons()["icon eye"].tap();
//        window.buttons()["Previous"].tap();
//        window.buttons()["Previous"].tap();
//        window.buttons()["Previous"].tap();
//        window.buttons()["Previous"].tap();
//        window.buttons()["icon rank"].tap();
//        window.buttons()["icon placesani1"].tap();
//        window.buttons()["Previous"].tap();
//        window.buttons()["Previous"].tap();
//        window.buttons()["Previous"].tap();
//        window.buttons()["icon piechart"].tap();
//        window.buttons()["Previous"].tap();
//        window.buttons()["Previous"].tap();
//        window.buttons()["Previous"].tap();
                
        UIALogger.logPass(testCaseName + " passed."); 
        
    } else {
        UIALogger.logFail(testCaseName + " incorrect."); 
    }
    
		
} else {
	UIALogger.logFail(testCaseName + " incorrectly."); 
}