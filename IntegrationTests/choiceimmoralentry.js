/**
Moralife UI Choice Imoral Entry Validation.  Test Data populated from uijsinclude
 
@author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org

@date 05/28/2012
@file choiceimmoralentry.js
*/

#import "include/uiajsinclude.js"

var testSuiteName = "Choice - Immoral Entry";
var testCaseName;

UIALogger.logMessage(testSuiteName + " Testing Begins");

app.tabBar().buttons()["Journal"].tap();

window.buttons()["Immoral Choice"].tap();

testCaseName = testSuiteName + " choiceTextField Entry";
UIALogger.logStart(testCaseName + " Test");

window.textFields()["Choice"].tap();

for (i = 0; i < immoralName.length; i++)
{
    var strChar = immoralName.charAt(i);
    app.keyboard().typeString(strChar);
}

app.keyboard().typeString("\n");

if(window.textFields()["Choice"].value() == immoralName) {
       UIALogger.logPass(testCaseName + " correct."); 
} else {
       UIALogger.logFail(testCaseName + " incorrect: " + window.textFields()["Choice"].value());
}

testCaseName = testSuiteName + " Vice moralButton Selection";
UIALogger.logStart(testCaseName + " Test");

window.buttons()["Select a Vice"].tap();
window.searchBars()[0].tap();

for (i = 0; i < immoralType.length; i++)
{
    var strChar = immoralType.charAt(i);
    app.keyboard().typeString(strChar);
}

app.keyboard().typeString("\n");

window.tableViews()[0].cells()[0].tap();

UIALogger.logPass(testCaseName + " Selected");

testCaseName = testSuiteName + " Vice severitySlider Set";
UIALogger.logStart(testCaseName + " Test");

window.sliders()["Vice Severity"].dragToValue(viceSeverity);

if(window.sliders()["Vice Severity"].value() == viceSeveritySliderValue) {
       UIALogger.logPass(testCaseName + " correctly"); 
} else {
       UIALogger.logFail(testCaseName + " incorrectly: " + window.sliders()["Vice Severity"].value());
}

testCaseName = testSuiteName + " Choice descriptionTextView Entry";
UIALogger.logStart(testCaseName + " Test");

window.textViews()["Description"].tap();

for (i = 0; i < immoralDescription.length; i++)
{
    var strChar = immoralDescription.charAt(i);
    app.keyboard().typeString(strChar);
}

window.buttons()["Done"].tap();

if(window.textViews()["Description"].value() == immoralDescription) {
       UIALogger.logPass(testCaseName + " correct."); 
} else {
       UIALogger.logFail(testCaseName + " incorrect: " + window.textViews()["Description"].value());
}

UIALogger.logMessage("Details Entry Testing");
app.navigationBar().rightButton().tap();

testCaseName = testSuiteName + " Details justificationTextField Entry";
UIALogger.logStart(testCaseName + " Test");

window.textFields()["Justification"].tap();

for (i = 0; i < immoralJustification.length; i++)
{
    var strChar = immoralJustification.charAt(i);
    app.keyboard().typeString(strChar);
}

app.keyboard().typeString("\n");

if(window.textFields()["Justification"].value() == immoralJustification) {
       UIALogger.logPass(testCaseName + " correct."); 
} else {
       UIALogger.logFail(testCaseName + " incorrect: " + window.textFields()["Justification"].value());
}

testCaseName = testSuiteName + " Details consequenceTextField Entry";
UIALogger.logStart(testCaseName + " Test");

window.textFields()["Consequence"].tap();

for (i = 0; i < immoralConsequence.length; i++)
{
    var strChar = immoralConsequence.charAt(i);
    app.keyboard().typeString(strChar);
}

app.keyboard().typeString("\n");

if(window.textFields()["Consequence"].value() == immoralConsequence) {
       UIALogger.logPass(testCaseName + " correct."); 
} else {
       UIALogger.logFail(testCaseName + " incorrect: " + window.textFields()["Consequence"].value());
}

testCaseName = testSuiteName + " Details influenceSlider Set";
UIALogger.logStart(testCaseName + " Test");

window.sliders()["Influence"].dragToValue(immoralInfluence);

if(window.sliders()["Influence"].value() == immoralInfluenceSliderValue) {
       UIALogger.logPass(testCaseName + " correctly."); 
} else {
       UIALogger.logFail(testCaseName + " incorrectly: " + window.sliders()["Influence"].value());
}

window.buttons()["Done"].tap();

UIALogger.logMessage("Details Save Test");

hasError = 0;

app.navigationBar().rightButton().tap();

testCaseName = testSuiteName + " Details justificationTextField Save";
UIALogger.logStart(testCaseName + " Test");

if(window.textFields()["Justification"].value() == immoralJustification) {
       UIALogger.logPass(testCaseName + " succeeded.");
} else {
       UIALogger.logFail(testCaseName + " failed: " + window.textFields()["Justification"].value());
		hasError = 1;
}

testCaseName = testSuiteName + " Details consequenceTextField Save";
UIALogger.logStart(testCaseName + " Test");

if(window.textFields()["Consequence"].value() == immoralConsequence) {
	UIALogger.logPass(testCaseName + " succeeded."); 
} else {
	UIALogger.logFail(testCaseName + " failed: " + window.textFields()["Consequence"].value());
	hasError = 1;
}

testCaseName = testSuiteName + " Details influenceSlider Save";
UIALogger.logStart(testCaseName + " Test");

if(window.sliders()["Influence"].value() == immoralInfluenceSliderValue) {
       UIALogger.logPass(testCaseName + " succeeded."); 
} else {
       UIALogger.logFail(testCaseName + " failed: " + window.sliders()["Influence"].value());
		hasError = 1;
}

if(hasError){
	UIALogger.logError("At least one Choice Detail field didn't save.");
} else {
	UIALogger.logMessage("All Choice Detail fields saved correctly.");
}

window.textFields()["Justification"].tap();
app.keyboard().typeString("\n");

target.delay(2.0);

window.buttons()["Done"].tap();
window.buttons()["Done"].tap();

app.tabBar().buttons()["Home"].tap();
