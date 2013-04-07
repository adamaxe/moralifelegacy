/**
Moralife UI Choice Moral Cancel validation - Ensure that User can cancel every choice and that nothing is retained.
 
@author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org

@date 05/28/2012
@file choicemoralcancel.js
*/

#import "include/uiajsinclude.js"

var testSuiteName = "Moral Choice Cancel (moralchoicecancel.js)";
var testCaseName;

UIALogger.logMessage(testSuiteName + " Testing Begins");

testCaseName = testSuiteName + " choiceTextField Clear";

app.navigationBar().buttons()["Journal"].tap();
window.buttons()["Moral Choice"].tap();
window.textFields()["Choice"].tap();

UIALogger.logStart(testCaseName + " Test");

for (i = 0; i < moralChoiceCancel.length; i++) {
    var strChar = moralChoiceCancel.charAt(i);
    app.keyboard().typeString(strChar);
}

app.keyboard().typeString("\n");

window.buttons()["Cancel"].tap();
window.buttons()["Moral Choice"].tap();

if(window.textFields()["Choice"].value() == moralChoiceCancel) {
	UIALogger.logFail(testCaseName + " cleared incorrectly: " + window.textFields()["Choice"].value());
} else {
	UIALogger.logPass(testCaseName + " cleared correctly"); 
}

testCaseName = testSuiteName + " severitySlider Clear";
UIALogger.logStart(testCaseName + " Test");

window.sliders()["Virtue Severity"].dragToValue(virtueSeverityCancel);

window.buttons()["Cancel"].tap();
window.buttons()["Moral Choice"].tap();

if(window.sliders()["Virtue Severity"].value() == virtueSeveritySliderValueCancel) {
    UIALogger.logFail(testCaseName + " didn't clear: " + app.frontMostApp().mainWindow().sliders()["Virtue Severity"].value());
} else {
    UIALogger.logPass(testCaseName + " cleared correctly");     
}

testCaseName = testSuiteName + " descriptionTextView Clear";
UIALogger.logStart(testCaseName + " Test");

window.textViews()["Description"].tap();

for (i = 0; i < moralDescriptionCancel.length; i++) {
    var strChar = moralDescriptionCancel.charAt(i);
    app.keyboard().typeString(strChar);
}

window.buttons()["Done"].tap();

window.buttons()["Cancel"].tap();
window.buttons()["Moral Choice"].tap();

if(window.textViews()["Description"].value() == moralDescriptionCancel) {
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

for (i = 0; i < moralJustificationCancel.length; i++) {
    var strChar = moralJustificationCancel.charAt(i);
    app.keyboard().typeString(strChar);
}

app.keyboard().typeString("\n");

window.buttons()["Cancel"].tap();
app.navigationBar().rightButton().tap();

if(window.textFields()["Justification"].value() == moralJustificationCancel) {
    UIALogger.logFail(testCaseName + " didn't clear: " + app.frontMostApp().mainWindow().textFields()["Justification"].value());
} else {
    UIALogger.logPass(testCaseName + " cleared correctly");     
}

testCaseName = testSuiteName + " consequenceTextField Clear";
UIALogger.logStart(testCaseName + " Test");

window.textFields()["Consequence"].tap();

var consequenceCancel = "Consequence Cancel 1";

for (i = 0; i < moralConsequenceCancel.length; i++) {
    var strChar = moralConsequenceCancel.charAt(i);
    app.keyboard().typeString(strChar);
}

app.keyboard().typeString("\n");

window.buttons()["Cancel"].tap();
app.navigationBar().rightButton().tap();

if(window.textFields()["Consequence"].value() == moralConsequenceCancel) {
	UIALogger.logFail(testCaseName + " cleared incorrectly: " + app.frontMostApp().mainWindow().textFields()["Consequence"].value());
} else {
	UIALogger.logPass(testCaseName + " cleared correctly"); 
}

testCaseName = testSuiteName + " influenceSlider Clear";
UIALogger.logStart(testCaseName + " Test");

window.sliders()["Influence"].dragToValue(moralInfluenceCancel);

window.buttons()["Cancel"].tap();
app.navigationBar().rightButton().tap();

if(window.sliders()["Influence"].value() == moralInfluenceSliderValueCancel) {
    UIALogger.logFail(testCaseName + " didn't clear: " + app.frontMostApp().mainWindow().sliders()["Influence"].value());
} else {
    UIALogger.logPass(testCaseName + " cleared correctly"); 
}

window.sliders()["Influence"].dragToValue(moralInfluenceCancel);

window.buttons()["Cancel"].tap();
window.buttons()["Cancel"].tap();
app.navigationBar().buttons()["Home"].tap();

UIALogger.logMessage(testSuiteName + " Testing Ends");
