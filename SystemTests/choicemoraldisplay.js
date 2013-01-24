/**
Moralife UI Choice Moral Display validation
 
@author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org

@date 05/28/2012
@file choicemoraldisplay.js
*/

#import "include/uiajsinclude.js"

var testSuiteName = "Choice - Moral";
var testCaseName;

UIALogger.logMessage(testSuiteName + " Testing Begins");

app.navigationBar().buttons()["Journal"].tap();
window.buttons()["Moral Choice"].tap();

testCaseName = testSuiteName + " navigationBar Title Text";
UIALogger.logStart(testCaseName + " Test");

target.delay(2.0);

if(app.navigationBar().name() == "Moral Choice") {
	UIALogger.logPass(testCaseName + " correct"); 
} else {
	UIALogger.logFail(testCaseName + " incorrect: " + app.navigationBar().name());
}

testCaseName = testSuiteName + " moralReferenceButton Default";
UIALogger.logStart(testCaseName + " Test");

window.buttons()["Moral Reference"].tap();

if(window.buttons()["Previous"].checkIsValid()) {
	window.buttons()["Previous"].tap();
	UIALogger.logPass(testCaseName + " correct"); 
} else {
	UIALogger.logFail(testCaseName + " incorrect.");
}

testCaseName = testSuiteName + " moralButton Title Text";
UIALogger.logStart(testCaseName + " Test");

if(window.buttons()["Select a Virtue"].value() == "") {
	UIALogger.logFail(testCaseName + " incorrect");
} else {
	UIALogger.logPass(testCaseName + " correct"); 
}

testCaseName = testSuiteName + " severityLabel Text";
UIALogger.logStart(testCaseName + " Test");

if(window.staticTexts()["Good"].value() == "") {
	UIALogger.logFail(testCaseName + " incorrect");
} else {
	UIALogger.logPass(testCaseName + " correct"); 
}

testCaseName = testSuiteName + " influenceButton Default";
UIALogger.logStart(testCaseName + " Test");

app.navigationBar().rightButton().tap();
window.buttons()["Influence Description"].tap();

if(window.buttons()["Previous"].checkIsValid()) {
	window.buttons()["Previous"].tap();
	UIALogger.logPass(testCaseName + " correct"); 
} else {
	UIALogger.logFail(testCaseName + " incorrect");
}

window.buttons()["Cancel"].tap();

window.buttons()["Cancel"].tap();
app.navigationBar().buttons()["Home"].tap();
