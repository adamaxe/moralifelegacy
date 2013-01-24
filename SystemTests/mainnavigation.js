/**
Moralife UI Main Navigation traversal validation
 
@author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org

@date 05/28/2012
@file mainnavigation.js
*/

#import "include/uiajsinclude.js"

var testSuiteName = "Main UINavigationBar Navigation";
var testCaseName;

UIALogger.logMessage(testSuiteName + " Testing Begins");

testCaseName = testSuiteName + " rankButton";

UIALogger.logStart(testCaseName + " Test");

if (window.buttons()["Rank"].checkIsValid()) {
    window.buttons()["Rank"].tap();
    
    UIALogger.logPass(testCaseName + " loaded"); 
} else {
    UIALogger.logFail(testCaseName + " NOT loaded"); 
} 

testCaseName = testSuiteName + " viceButton";

UIALogger.logStart(testCaseName + " Test");

if (window.buttons()["Vice"].checkIsValid()) {
    window.buttons()["Vice"].tap();
    
    UIALogger.logPass(testCaseName + " loaded"); 
} else {
    UIALogger.logFail(testCaseName + " NOT loaded"); 
} 

testCaseName = testSuiteName + " virtueButton";

UIALogger.logStart(testCaseName + " Test");

if (window.buttons()["Virtue"].checkIsValid()) {
    window.buttons()["Virtue"].tap();
    
    UIALogger.logPass(testCaseName + " loaded"); 
} else {
    UIALogger.logFail(testCaseName + " NOT loaded"); 
} 

testCaseName = testSuiteName + " ChoiceInit (Journal)";

UIALogger.logStart(testCaseName + " Test");

if (app.navigationBar().buttons()["Journal"].checkIsValid()){ 

    app.navigationBar().buttons()["Journal"].tap();
    window.buttons()["Moral Choice"].tap();
    window.buttons()["Cancel"].tap();

    window.buttons()["Immoral Choice"].tap();
    window.buttons()["Cancel"].tap();

    window.buttons()["All Choices"].tap();
    window.buttons()["Cancel"].tap();

    UIALogger.logPass(testCaseName + " loaded"); 
} else {
    UIALogger.logFail(testCaseName + " NOT loaded"); 
}

testCaseName = testSuiteName + " Choice (Moral)";

UIALogger.logStart(testCaseName + " Test");

if (app.navigationBar().buttons()["Journal"].checkIsValid()){ 
    app.navigationBar().buttons()["Journal"].tap();
    window.buttons()["Moral Choice"].tap();
    window.buttons()["Moral History"].tap();
    window.buttons()["Previous"].tap();
    window.buttons()["Moral Reference"].tap();
    window.buttons()["Previous"].tap();
    window.buttons()["Select a Virtue"].tap();
    window.buttons()["Previous"].tap();    
    app.navigationBar().rightButton().tap();
    app.navigationBar().leftButton().tap();
    
    UIALogger.logPass(testCaseName + " loaded"); 
} else {
    UIALogger.logFail(testCaseName + " NOT loaded"); 
}

testCaseName = testSuiteName + " Choice (Immoral)";

UIALogger.logStart(testCaseName + " Test");

if (app.navigationBar().buttons()["Journal"].checkIsValid()){ 
    app.navigationBar().buttons()["Journal"].tap();    
    
    window.buttons()["Immoral Choice"].tap();
    app.navigationBar().rightButton().tap();
    app.navigationBar().leftButton().tap();
    
    UIALogger.logPass(testCaseName + " loaded"); 
} else {
    UIALogger.logFail(testCaseName + " NOT loaded"); 
}

testCaseName = testSuiteName + " All Choices Screen";

UIALogger.logStart(testCaseName + " Test");

if (app.navigationBar().buttons()["Journal"].checkIsValid()){ 
    app.navigationBar().buttons()["Journal"].tap();
    
    window.buttons()["All Choices"].tap();
    window.buttons()["Sort"].tap();
    window.buttons()["Order"].tap();    
    app.navigationBar().leftButton().tap();

    UIALogger.logPass(testCaseName + " loaded"); 
} else {
    UIALogger.logFail(testCaseName + " NOT loaded"); 
}

testCaseName = testSuiteName + " Collection Init";

UIALogger.logStart(testCaseName + " Test");

if (app.navigationBar().buttons()["Collection"].checkIsValid()) {
    app.navigationBar().buttons()["Collection"].tap();
    
    UIALogger.logPass(testCaseName + " loaded"); 
} else {
    UIALogger.logFail(testCaseName + " NOT loaded"); 
}

testCaseName = testSuiteName + " Accessories";

UIALogger.logStart(testCaseName + " Test");

if (window.buttons()["Accessories"].checkIsValid()){ 
    window.buttons()["Accessories"].tap();
    window.buttons()["Cancel"].tap();

    UIALogger.logPass(testCaseName + " loaded"); 
} else {
    UIALogger.logFail(testCaseName + " NOT loaded"); 
}

testCaseName = testSuiteName + " Figures";

UIALogger.logStart(testCaseName + " Test");

if (window.buttons()["Figures"].checkIsValid()){ 
    window.buttons()["Figures"].tap();
    window.buttons()["Cancel"].tap();

    UIALogger.logPass(testCaseName + " loaded"); 
} else {
    UIALogger.logFail(testCaseName + " NOT loaded"); 
}

testCaseName = testSuiteName + " Morals";

UIALogger.logStart(testCaseName + " Test");

if (window.buttons()["Morals"].checkIsValid()){ 
    window.buttons()["Morals"].tap();
    window.buttons()["Cancel"].tap();
    
    UIALogger.logPass(testCaseName + " loaded"); 
} else {
    UIALogger.logFail(testCaseName + " NOT loaded"); 
}

app.navigationBar().leftButton().tap();