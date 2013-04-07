/**
 Moralife UI Choice Immoral Cancel validation - Ensure that User can cancel every choice and that nothing is retained.
 
 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 
 @date 05/28/2012
 @file choiceimmoralcancel.js
 */

#import "include/uiajsinclude.js"

var testSuiteName = "Choice Immoral Cancel (choiceimmoralcancel.js)";
var testCaseName;

UIALogger.logMessage(testSuiteName + " Testing Begins");

testCaseName = testSuiteName + " choiceTextField Clear";

app.navigationBar().buttons()["Journal"].tap();
window.buttons()["Immoral Choice"].tap();
window.textFields()["Choice"].tap();

UIALogger.logStart(testCaseName + " Test");

for (i = 0; i < immoralChoiceCancel.length; i++) {
    var strChar = immoralChoiceCancel.charAt(i);
    app.keyboard().typeString(strChar);
}

app.keyboard().typeString("\n");

window.buttons()["Cancel"].tap();
window.buttons()["Immoral Choice"].tap();

if(window.textFields()["Choice"].value() == immoralChoiceCancel) {
	UIALogger.logFail(testCaseName + " cleared incorrectly: " + window.textFields()["Choice"].value());
} else {
	UIALogger.logPass(testCaseName + " cleared correctly"); 
}

testCaseName = testSuiteName + " severitySlider Clear";
UIALogger.logStart(testCaseName + " Test");

window.sliders()["Vice Severity"].dragToValue(viceSeverityCancel);

window.buttons()["Cancel"].tap();
window.buttons()["Immoral Choice"].tap();

if(window.sliders()["Vice Severity"].value() == viceSeveritySliderValueCancel) {
    UIALogger.logFail(testCaseName + " didn't clear: " + app.frontMostApp().mainWindow().sliders()["Vice Severity"].value());
} else {
    UIALogger.logPass(testCaseName + " cleared correctly");     
}

testCaseName = testSuiteName + " descriptionTextView Clear";
UIALogger.logStart(testCaseName + " Test");

window.textViews()["Description"].tap();

for (i = 0; i < immoralDescriptionCancel.length; i++) {
    var strChar = immoralDescriptionCancel.charAt(i);
    app.keyboard().typeString(strChar);
}

window.buttons()["Done"].tap();

window.buttons()["Cancel"].tap();
window.buttons()["Immoral Choice"].tap();

if(window.textViews()["Description"].value() == immoralDescriptionCancel) {
    UIALogger.logFail(testCaseName + " didn't clear: " + app.frontMostApp().mainWindow().textViews()["Description"].value());
} else {
    UIALogger.logPass(testCaseName + " cleared correctly"); 
}

UIALogger.logMessage("Details Clear Testing");
app.navigationBar().rightButton().tap();

testCaseName = testSuiteName + " justificationTextField Clear";
UIALogger.logStart(testCaseName + " Test");

window.textFields()["Justification"].tap();

for (i = 0; i < immoralJustificationCancel.length; i++) {
    var strChar = immoralJustificationCancel.charAt(i);
    app.keyboard().typeString(strChar);
}

app.keyboard().typeString("\n");

window.buttons()["Cancel"].tap();
app.navigationBar().rightButton().tap();

if(window.textFields()["Justification"].value() == immoralJustificationCancel) {
    UIALogger.logFail(testCaseName + " didn't clear: " + app.frontMostApp().mainWindow().textFields()["Justification"].value());
} else {
    UIALogger.logPass(testCaseName + " cleared correctly");     
}

testCaseName = testSuiteName + " consequenceTextField Clear";
UIALogger.logStart(testCaseName + " Test");

window.textFields()["Consequence"].tap();

var consequenceCancel = "Consequence Cancel 1";

for (i = 0; i < immoralConsequenceCancel.length; i++) {
    var strChar = immoralConsequenceCancel.charAt(i);
    app.keyboard().typeString(strChar);
}

app.keyboard().typeString("\n");

window.buttons()["Cancel"].tap();
app.navigationBar().rightButton().tap();

if(window.textFields()["Consequence"].value() == immoralConsequenceCancel) {
	UIALogger.logFail(testCaseName + " cleared incorrectly: " + app.frontMostApp().mainWindow().textFields()["Consequence"].value());
} else {
	UIALogger.logPass(testCaseName + " cleared correctly"); 
}

testCaseName = testSuiteName + " influenceSlider Clear";
UIALogger.logStart(testCaseName + " Test");

window.sliders()["Influence"].dragToValue(immoralInfluenceCancel);

window.buttons()["Cancel"].tap();
app.navigationBar().rightButton().tap();

if(window.sliders()["Influence"].value() == immoralInfluenceSliderValueCancel) {
    UIALogger.logFail(testCaseName + " didn't clear: " + app.frontMostApp().mainWindow().sliders()["Influence"].value());
} else {
    UIALogger.logPass(testCaseName + " cleared correctly"); 
}

window.sliders()["Influence"].dragToValue(immoralInfluenceCancel);

window.buttons()["Cancel"].tap();
window.buttons()["Cancel"].tap();
app.navigationBar().buttons()["Home"].tap();

UIALogger.logMessage(testSuiteName + " Testing Ends");
