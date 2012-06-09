/**
Moralife UI Choice Immoral Display validation
 
@author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org

@date 05/28/2012
@file choiceimmoraldisplay.js
*/

#import "include/uiajsinclude.js"

var testSuiteName = "Choice - Immoral";
var testCaseName;

UIALogger.logMessage(testSuiteName + " Testing Begins");

app.tabBar().buttons()["Journal"].tap();
window.buttons()["Immoral Choice"].tap();

testCaseName = testSuiteName + " navigationBar Title Text";
UIALogger.logStart(testCaseName + " Test");

target.delay(2.0);

if(app.navigationBar().name() == "Immoral Choice") {
	UIALogger.logPass(testCaseName + " correct"); 
} else {
	UIALogger.logFail(testCaseName + " incorrect: " + app.navigationBar().name());
}

testCaseName = testSuiteName + " choiceTextField Default Text";
UIALogger.logStart(testCaseName + " Test");

if(window.textFields()["Choice"].value() == "Enter in your bad deed.") {
	UIALogger.logPass(testCaseName + " correct"); 
} else {
	UIALogger.logFail(testCaseName + " incorrect: " + window.textFields()["Choice"].value());
}

testCaseName = testSuiteName + " moralButton Title Text";
UIALogger.logStart(testCaseName + " Test");

if(window.buttons()["Select a Vice"].value() == "") {
	UIALogger.logFail(testCaseName + " incorrect");
} else {
	UIALogger.logPass(testCaseName + " correct"); 
}

testCaseName = testSuiteName + " severityLabel Text";
UIALogger.logStart(testCaseName + " Test");

if(window.staticTexts()["Bad"].value() == "") {
	UIALogger.logFail(testCaseName + " incorrect");
} else {
	UIALogger.logPass(testCaseName + " correct"); 
}

window.buttons()["Cancel"].tap();
app.tabBar().buttons()["Home"].tap();
