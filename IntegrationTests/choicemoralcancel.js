/**
Moralife UI Choice Moral Cancel validation
 
@author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org

@date 05/28/2012
@file choicemoralcancel.js
*/

#import "include/uiajsinclude.js"

var testSuiteName = "Choice - Cancel";
var testCaseName;

UIALogger.logMessage(testSuiteName + " Testing Begins");

testCaseName = testSuiteName + " choiceTextField Clear";

app.tabBar().buttons()["Journal"].tap();
window.buttons()["Moral Choice"].tap();
window.textFields()["Choice"].tap();

UIALogger.logStart(testCaseName + " Test");

var choiceCancel = "Choice Cancel 1";

for (i = 0; i < choiceCancel.length; i++)
{
    var strChar = choiceCancel.charAt(i);
    app.keyboard().typeString(strChar);
}

app.keyboard().typeString("\n");

window.buttons()["Cancel"].tap();
window.buttons()["Moral Choice"].tap();

if(window.textFields()["Choice"].value() == choiceCancel) {
	UIALogger.logFail(testCaseName + " cleared incorrectly: " + window.textFields()["Choice"].value());
} else {
	UIALogger.logPass(testCaseName + " cleared correctly"); 
}

testCaseName = testSuiteName + " severitySlider Clear";
UIALogger.logStart(testCaseName + " Test");

var virtueSeverity = 0.25;
var virtueSeveritySliderValue = (virtueSeverity * 100) + "%";

window.sliders()["Virtue Severity"].dragToValue(virtueSeverity);

window.buttons()["Cancel"].tap();
window.buttons()["Moral Choice"].tap();

if(window.sliders()["Virtue Severity"].value() == virtueSeveritySliderValue) {
    UIALogger.logFail(testCaseName + " didn't clear: " + app.frontMostApp().mainWindow().sliders()["Virtue Severity"].value());
} else {
    UIALogger.logPass(testCaseName + " cleared correctly");     
}

testCaseName = testSuiteName + " descriptionTextView Clear";
UIALogger.logStart(testCaseName + " Test");

window.textViews()["Description"].tap();

var moralDescription = "Moral test description 1\n\nLine 2";

for (i = 0; i < moralDescription.length; i++)
{
    var strChar = moralDescription.charAt(i);
    app.keyboard().typeString(strChar);
}

window.buttons()["Done"].tap();

window.buttons()["Cancel"].tap();
window.buttons()["Moral Choice"].tap();

if(window.textViews()["Description"].value() == moralDescription) {
    UIALogger.logFail(testCaseName + " didn't clear: " + app.frontMostApp().mainWindow().textViews()["Description"].value());
} else {
    UIALogger.logPass(testCaseName + " cleared correctly"); 
}

UIALogger.logMessage("Details Clear Testing");
app.navigationBar().rightButton().tap();

testCaseName = testSuiteName + " justificationTextField Clear";
UIALogger.logStart(testCaseName + " Test");

window.textFields()["Justification"].tap();

var justification = "Justification test 1";

for (i = 0; i < justification.length; i++)
{
    var strChar = justification.charAt(i);
    app.keyboard().typeString(strChar);
}

app.keyboard().typeString("\n");

window.buttons()["Cancel"].tap();
app.navigationBar().rightButton().tap();

if(window.textFields()["Justification"].value() == justification) {
    UIALogger.logFail(testCaseName + " didn't clear: " + app.frontMostApp().mainWindow().textFields()["Justification"].value());
} else {
    UIALogger.logPass(testCaseName + " cleared correctly");     
}

testCaseName = testSuiteName + " consequenceTextField Clear";
UIALogger.logStart(testCaseName + " Test");

window.textFields()["Consequence"].tap();

var consequenceCancel = "Consequence Cancel 1";

for (i = 0; i < consequenceCancel.length; i++)
{
    var strChar = consequenceCancel.charAt(i);
    app.keyboard().typeString(strChar);
}

app.keyboard().typeString("\n");

window.buttons()["Cancel"].tap();
app.navigationBar().rightButton().tap();

if(window.textFields()["Consequence"].value() == consequenceCancel) {
	UIALogger.logFail(testCaseName + " cleared incorrectly: " + app.frontMostApp().mainWindow().textFields()["Consequence"].value());
} else {
	UIALogger.logPass(testCaseName + " cleared correctly"); 
}

testCaseName = testSuiteName + " influenceSlider Clear";
UIALogger.logStart(testCaseName + " Test");

var influence = 0.25;
var influenceSliderValue = (influence * 100) + "%";

window.sliders()["Influence"].dragToValue(influence);

window.buttons()["Cancel"].tap();
app.navigationBar().rightButton().tap();

if(window.sliders()["Influence"].value() == influenceSliderValue) {
    UIALogger.logFail(testCaseName + " didn't clear: " + app.frontMostApp().mainWindow().sliders()["Influence"].value());
} else {
    UIALogger.logPass(testCaseName + " cleared correctly"); 
}

window.sliders()["Influence"].dragToValue(influence);

window.buttons()["Cancel"].tap();
window.buttons()["Cancel"].tap();
app.tabBar().buttons()["Home"].tap();
