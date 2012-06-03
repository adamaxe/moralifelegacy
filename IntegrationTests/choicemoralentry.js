/**
Moralife UI Choice Moral Entry Validation
 
@author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org

@date 05/28/2012
@file choiceentrymoral.js
*/

var target = UIATarget.localTarget().frontMostApp();
var testSuiteName = "Choice - Moral Entry";
var testCaseName;

UIALogger.logMessage("MoraLife " + testSuiteName + " Testing Begins");

target.tabBar().buttons()["Journal"].tap();

target.mainWindow().buttons()["Moral Choice"].tap();

testCaseName = testSuiteName + " Choice Name Entry";
UIALogger.logStart(testCaseName + " Test");

target.mainWindow().textFields()["Choice"].tap();

var moralName = "Test moral 1";

for (i = 0; i < moralName.length; i++)
{
    var strChar = moralName.charAt(i);
    target.keyboard().typeString(strChar);
}

target.keyboard().typeString("\n");

if(target.mainWindow().textFields()["Choice"].value() == moralName) {
       UIALogger.logPass(testCaseName + " correct."); 
} else {
       UIALogger.logFail(testCaseName + " incorrect: " + target.mainWindow().textFields()["Choice"].value());
}

testCaseName = testSuiteName + " Virtue Selection";
UIALogger.logStart(testCaseName + " Test");

target.mainWindow().buttons()["Select a Virtue"].tap();
target.mainWindow().searchBars()[0].tap();
var moralType = "Aptitude\n";

for (i = 0; i < moralType.length; i++)
{
    var strChar = moralType.charAt(i);
    target.keyboard().typeString(strChar);
}

target.mainWindow().tableViews()["Empty list"].cells()["Aptitude, Ability, Excellence, Potential, Precision, Industriousness, Savvy, Talent"].tap();

UIALogger.logPass(testCaseName + " Selected");

testCaseName = testSuiteName + " Virtue Severity Set";
UIALogger.logStart(testCaseName + " Test");

var virtueSeverity = 0.25;
var virtueSeveritySliderValue = (virtueSeverity * 100) + "%";

target.mainWindow().sliders()["Virtue Severity"].dragToValue(virtueSeverity);

if(target.mainWindow().sliders()["Virtue Severity"].value() == virtueSeveritySliderValue) {
       UIALogger.logPass(testCaseName + " correctly"); 
} else {
       UIALogger.logFail(testCaseName + " incorrectly: " + target.mainWindow().sliders()["Virtue Severity"].value());
}

testCaseName = testSuiteName + " Choice Description Entry";
UIALogger.logStart(testCaseName + " Test");

target.mainWindow().textViews()["Description"].tap();

var moralDescription = "Moral test description 1\n\nLine 2";

for (i = 0; i < moralDescription.length; i++)
{
    var strChar = moralDescription.charAt(i);
    target.keyboard().typeString(strChar);
}

target.mainWindow().buttons()["Done"].tap();

if(target.mainWindow().textViews()["Description"].value() == moralDescription) {
       UIALogger.logPass(testCaseName + " correct."); 
} else {
       UIALogger.logFail(testCaseName + " incorrect: " + target.mainWindow().textViews()["Description"].value());
}

UIALogger.logMessage("Details Entry Testing");
target.navigationBar().rightButton().tap();

testCaseName = testSuiteName + " Details Justification Entry";
UIALogger.logStart(testCaseName + " Test");

target.mainWindow().textFields()["Justification"].tap();

var justification = "Justification test 1";

for (i = 0; i < justification.length; i++)
{
    var strChar = justification.charAt(i);
    target.keyboard().typeString(strChar);
}

target.keyboard().typeString("\n");

if(target.mainWindow().textFields()["Justification"].value() == justification) {
       UIALogger.logPass(testCaseName + " correct."); 
} else {
       UIALogger.logFail(testCaseName + " incorrect: " + target.mainWindow().textFields()["Justification"].value());
}

testCaseName = testSuiteName + " Details Consequence Entry";
UIALogger.logStart(testCaseName + " Test");

target.mainWindow().textFields()["Consequence"].tap();

var consequence = "Consequence test 1";

for (i = 0; i < consequence.length; i++)
{
    var strChar = consequence.charAt(i);
    target.keyboard().typeString(strChar);
}

target.keyboard().typeString("\n");

if(target.mainWindow().textFields()["Consequence"].value() == consequence) {
       UIALogger.logPass(testCaseName + " correct."); 
} else {
       UIALogger.logFail(testCaseName + " incorrect: " + target.mainWindow().textFields()["Consequence"].value());
}

testCaseName = testSuiteName + " Details Influence Set";
UIALogger.logStart(testCaseName + " Test");

var influence = 0.25;
var influenceSliderValue = (influence * 100) + "%";

target.mainWindow().sliders()["Influence"].dragToValue(influence);

if(target.mainWindow().sliders()["Influence"].value() == influenceSliderValue) {
       UIALogger.logPass(testCaseName + " correctly."); 
} else {
       UIALogger.logFail(testCaseName + " incorrectly: " + target.mainWindow().sliders()["Influence"].value());
}

target.mainWindow().buttons()["Done"].tap();

UIALogger.logMessage("Details Save Test");

hasError = 0;

target.navigationBar().rightButton().tap();

testCaseName = testSuiteName + " Details Justification Save";
UIALogger.logStart(testCaseName + " Test");

if(target.mainWindow().textFields()["Justification"].value() == justification) {
       UIALogger.logPass(testCaseName + " succeeded.");
} else {
       UIALogger.logFail(testCaseName + " failed: " + target.mainWindow().textFields()["Justification"].value());
		hasError = 1;
}

testCaseName = testSuiteName + " Details Consequence Save";
UIALogger.logStart(testCaseName + " Test");

if(target.mainWindow().textFields()["Consequence"].value() == consequence) {
	UIALogger.logPass(testCaseName + " succeeded."); 
} else {
	UIALogger.logFail(testCaseName + " failed: " + target.mainWindow().textFields()["Consequence"].value());
	hasError = 1;
}

testCaseName = testSuiteName + " Details Influence Save";
UIALogger.logStart(testCaseName + " Test");

if(target.mainWindow().sliders()["Influence"].value() == influenceSliderValue) {
       UIALogger.logPass(testCaseName + " succeeded."); 
} else {
       UIALogger.logFail(testCaseName + " failed: " + target.mainWindow().sliders()["Influence"].value());
		hasError = 1;
}

if(hasError){
	UIALogger.logError("At least one Choice Detail field didn't save.");
} else {
	UIALogger.logMessage("All Choice Detail fields saved correctly.");
}

target.mainWindow().textFields()["Justification"].tap();
target.keyboard().typeString("\n");

target.mainWindow().buttons()["Done"].tap();
target.mainWindow().buttons()["Done"].tap();