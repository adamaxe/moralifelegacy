/**
Moralife UI Choice Moral Cancel validation
 
@author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org

@date 05/28/2012
@file choicemoralcancel.js
*/

var target = UIATarget.localTarget();

var target = UIATarget.localTarget().frontMostApp();
var testSuiteName = "Choice - Cancel";
var testCaseName;

UIALogger.logMessage("MoraLife " + testSuiteName + " Testing Begins");

testCaseName = testSuiteName + " choiceTextField Clear";

target.tabBar().buttons()["Journal"].tap();
target.mainWindow().buttons()["Moral Choice"].tap();
target.mainWindow().textFields()["Choice"].tap();

UIALogger.logStart(testCaseName + " Test");

var choiceCancel = "Choice Cancel 1";

for (i = 0; i < choiceCancel.length; i++)
{
    var strChar = choiceCancel.charAt(i);
    target.keyboard().typeString(strChar);
}

target.keyboard().typeString("\n");

target.mainWindow().buttons()["Cancel"].tap();
target.mainWindow().buttons()["Moral Choice"].tap();

if(target.mainWindow().textFields()["Choice"].value() == choiceCancel) {
	UIALogger.logFail(testCaseName + " cleared incorrectly: " + target.mainWindow().textFields()["Choice"].value());
} else {
	UIALogger.logPass(testCaseName + " cleared correctly"); 
}

testCaseName = testSuiteName + " severitySlider Clear";
UIALogger.logStart(testCaseName + " Test");

var virtueSeverity = 0.25;
var virtueSeveritySliderValue = (virtueSeverity * 100) + "%";

target.mainWindow().sliders()["Virtue Severity"].dragToValue(virtueSeverity);

target.mainWindow().buttons()["Cancel"].tap();
target.mainWindow().buttons()["Moral Choice"].tap();

if(target.mainWindow().sliders()["Virtue Severity"].value() == virtueSeveritySliderValue) {
    UIALogger.logFail(testCaseName + " didn't clear: " + target.frontMostApp().mainWindow().sliders()["Virtue Severity"].value());
} else {
    UIALogger.logPass(testCaseName + " cleared correctly");     
}

testCaseName = testSuiteName + " descriptionTextView Clear";
UIALogger.logStart(testCaseName + " Test");

target.mainWindow().textViews()["Description"].tap();

var moralDescription = "Moral test description 1\n\nLine 2";

for (i = 0; i < moralDescription.length; i++)
{
    var strChar = moralDescription.charAt(i);
    target.keyboard().typeString(strChar);
}

target.mainWindow().buttons()["Done"].tap();

target.mainWindow().buttons()["Cancel"].tap();
target.mainWindow().buttons()["Moral Choice"].tap();

if(target.mainWindow().textViews()["Description"].value() == moralDescription) {
    UIALogger.logFail(testCaseName + " didn't clear: " + target.frontMostApp().mainWindow().textViews()["Description"].value());
} else {
    UIALogger.logPass(testCaseName + " cleared correctly"); 
}

UIALogger.logMessage("Details Clear Testing");
target.navigationBar().rightButton().tap();

testCaseName = testSuiteName + " justificationTextField Clear";
UIALogger.logStart(testCaseName + " Test");

target.mainWindow().textFields()["Justification"].tap();

var justification = "Justification test 1";

for (i = 0; i < justification.length; i++)
{
    var strChar = justification.charAt(i);
    target.keyboard().typeString(strChar);
}

target.keyboard().typeString("\n");

target.mainWindow().buttons()["Cancel"].tap();
target.navigationBar().rightButton().tap();

if(target.mainWindow().textFields()["Justification"].value() == justification) {
    UIALogger.logFail(testCaseName + " didn't clear: " + target.frontMostApp().mainWindow().textFields()["Justification"].value());
} else {
    UIALogger.logPass(testCaseName + " cleared correctly");     
}

testCaseName = testSuiteName + " consequenceTextField Clear";
UIALogger.logStart(testCaseName + " Test");

target.mainWindow().textFields()["Consequence"].tap();

var consequenceCancel = "Consequence Cancel 1";

for (i = 0; i < consequenceCancel.length; i++)
{
    var strChar = consequenceCancel.charAt(i);
    target.keyboard().typeString(strChar);
}

target.keyboard().typeString("\n");

target.mainWindow().buttons()["Cancel"].tap();
target.navigationBar().rightButton().tap();

if(target.mainWindow().textFields()["Consequence"].value() == consequenceCancel) {
	UIALogger.logFail(testCaseName + " cleared incorrectly: " + target.frontMostApp().mainWindow().textFields()["Consequence"].value());
} else {
	UIALogger.logPass(testCaseName + " cleared correctly"); 
}

testCaseName = testSuiteName + " influenceSlider Clear";
UIALogger.logStart(testCaseName + " Test");

var influence = 0.25;
var influenceSliderValue = (influence * 100) + "%";

target.mainWindow().sliders()["Influence"].dragToValue(influence);

target.mainWindow().buttons()["Cancel"].tap();
target.navigationBar().rightButton().tap();

if(target.mainWindow().sliders()["Influence"].value() == influenceSliderValue) {
    UIALogger.logFail(testCaseName + " didn't clear: " + target.frontMostApp().mainWindow().sliders()["Influence"].value());
} else {
    UIALogger.logPass(testCaseName + " cleared correctly"); 
}

target.mainWindow().sliders()["Influence"].dragToValue(influence);

target.mainWindow().buttons()["Cancel"].tap();
target.mainWindow().buttons()["Cancel"].tap();
target.tabBar().buttons()["Home"].tap();
