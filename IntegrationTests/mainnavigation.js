/**
Moralife UI Main Navigation traversal validation
 
@author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org

@date 05/28/2012
@file mainnavigation.js
*/

#import "include/uiajsinclude.js"

var testSuiteName = "Main UITabBar Navigation";
var testCaseName;

UIALogger.logMessage(testSuiteName + " Testing Begins");

testCaseName = testSuiteName + " ConscienceView (Home)";

UIALogger.logStart(testCaseName + " Test");

if (app.tabBar().buttons()["Home"]!=null) {
    app.tabBar().buttons()["Home"].tap();
    
    UIALogger.logPass(testCaseName + " loaded"); 
} else {
   UIALogger.logFail(testCaseName + " NOT loaded"); 
} 

testCaseName = testSuiteName + " rankButton";

UIALogger.logStart(testCaseName + " Test");

if (window.buttons()["Rank"]!=null) {
    window.buttons()["Rank"].tap();
    
    UIALogger.logPass(testCaseName + " loaded"); 
} else {
    UIALogger.logFail(testCaseName + " NOT loaded"); 
} 

testCaseName = testSuiteName + " viceButton";

UIALogger.logStart(testCaseName + " Test");

if (window.buttons()["Vice"]!=null) {
    window.buttons()["Vice"].tap();
    
    UIALogger.logPass(testCaseName + " loaded"); 
} else {
    UIALogger.logFail(testCaseName + " NOT loaded"); 
} 

testCaseName = testSuiteName + " virtueButton";

UIALogger.logStart(testCaseName + " Test");

if (window.buttons()["Virtue"]!=null) {
    window.buttons()["Virtue"].tap();
    
    UIALogger.logPass(testCaseName + " loaded"); 
} else {
    UIALogger.logFail(testCaseName + " NOT loaded"); 
} 

testCaseName = testSuiteName + " ChoiceInit (Journal)";

UIALogger.logStart(testCaseName + " Test");

if (app.tabBar().buttons()["Journal"]!=null){ 

    app.tabBar().buttons()["Journal"].tap();
    window.buttons()["Moral Choice"].tap();
    app.navigationBar().leftButton().tap();
        
    window.buttons()["Immoral Choice"].tap();
    app.navigationBar().leftButton().tap();    
    
    window.buttons()["All Choices"].tap();
    app.navigationBar().leftButton().tap();

    UIALogger.logPass(testCaseName + " loaded"); 
} else {
    UIALogger.logFail(testCaseName + " NOT loaded"); 
}

testCaseName = testSuiteName + " Choice (Moral)";

UIALogger.logStart(testCaseName + " Test");

if (app.tabBar().buttons()["Journal"]!=null){ 
    app.tabBar().buttons()["Journal"].tap();
    window.buttons()["Moral Choice"].tap();
    window.buttons()["Moral History"].tap();
    window.buttons()["Previous"].tap();
    window.buttons()["Moral Reference"].tap();
    window.buttons()["Previous"].tap();
    window.buttons()["Select a Virtue"].tap();
    window.buttons()["Previous"].tap();    
    app.navigationBar().rightButton().tap();
    app.navigationBar().leftButton().tap();
    app.navigationBar().leftButton().tap();
    
    UIALogger.logPass(testCaseName + " loaded"); 
} else {
    UIALogger.logFail(testCaseName + " NOT loaded"); 
}

testCaseName = testSuiteName + " Choice (Immoral)";

UIALogger.logStart(testCaseName + " Test");

if (app.tabBar().buttons()["Journal"]!=null){ 
    app.tabBar().buttons()["Journal"].tap();    
    
    window.buttons()["Immoral Choice"].tap();
    app.navigationBar().rightButton().tap();
    app.navigationBar().leftButton().tap();
    app.navigationBar().leftButton().tap();
    
    UIALogger.logPass(testCaseName + " loaded"); 
} else {
    UIALogger.logFail(testCaseName + " NOT loaded"); 
}

testCaseName = testSuiteName + " All Choices Screen";

UIALogger.logStart(testCaseName + " Test");

if (app.tabBar().buttons()["Journal"]!=null){ 
    app.tabBar().buttons()["Journal"].tap();
    
    window.buttons()["All Choices"].tap();
    window.buttons()["Sort"].tap();
    window.buttons()["Order"].tap();    
    app.navigationBar().leftButton().tap();

    UIALogger.logPass(testCaseName + " loaded"); 
} else {
    UIALogger.logFail(testCaseName + " NOT loaded"); 
}

testCaseName = testSuiteName + " ChoiceList (All Choices)";

UIALogger.logStart(testCaseName + " Test");

if (app.tabBar().buttons()["Collection"]!=null) {
    app.tabBar().buttons()["Collection"].tap();
    window.buttons()["Accessories"].tap();
    app.navigationBar().leftButton().tap();
    window.buttons()["Figures"].tap();
    app.navigationBar().leftButton().tap();
    window.buttons()["Morals"].tap();
    app.navigationBar().leftButton().tap();
    app.tabBar().buttons()["Home"].tap();
    
    UIALogger.logPass(testCaseName + " loaded"); 
} else {
    UIALogger.logFail(testCaseName + " NOT loaded"); 
}

app.tabBar().buttons()["Home"].tap();
