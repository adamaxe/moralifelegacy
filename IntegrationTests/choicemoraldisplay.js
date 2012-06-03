/**
Moralife UI Choice Moral Display validation
 
@author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org

@date 05/28/2012
@file choicemoraldisplay.js
*/

var target = UIATarget.localTarget().frontMostApp();
var testSuiteName = "Choice - Moral";
var testCaseName;

UIALogger.logMessage("MoraLife " + testSuiteName + " Testing Begins");

target.tabBar().buttons()["Journal"].tap();
target.mainWindow().buttons()["Moral Choice"].tap();

testCaseName = testSuiteName + " choiceTextField Default Text";
UIALogger.logStart(testCaseName + " Test");

if(target.mainWindow().textFields()["Choice"].value() == "Enter in your good deed.") {
	UIALogger.logPass(testCaseName + " correct"); 
} else {
	UIALogger.logFail(testCaseName + " incorrect: " + target.mainWindow().textFields()["Choice"].value());
}

testCaseName = testSuiteName + " moralButton Title Text";
UIALogger.logStart(testCaseName + " Test");

if(target.mainWindow().buttons()["Select a Virtue"].value() == "") {
	UIALogger.logFail(testCaseName + " incorrect");
} else {
	UIALogger.logPass(testCaseName + " correct"); 
}

testCaseName = testSuiteName + " severityLabel Text";
UIALogger.logStart(testCaseName + " Test");

if(target.mainWindow().staticTexts()["Good"].value() == "") {
	UIALogger.logFail(testCaseName + " incorrect");
} else {
	UIALogger.logPass(testCaseName + " correct"); 
}

target.mainWindow().buttons()["Cancel"].tap();
target.tabBar().buttons()["Home"].tap();
