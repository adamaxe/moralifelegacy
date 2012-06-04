/**
Moralife UI Choice Moral Entry Validation
 
@author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org

@date 05/28/2012
@file choiceentrymoral.js
*/

#import "include/uiajsinclude.js"

var testSuiteName = "Choice - Moral Entry";
var testCaseName;

UIALogger.logMessage(testSuiteName + " Testing Begins");

app.tabBar().buttons()["Journal"].tap();

window.buttons()["Moral Choice"].tap();

testCaseName = testSuiteName + " choiceTextField Entry";
UIALogger.logStart(testCaseName + " Test");

window.textFields()["Choice"].tap();

var moralName = "Test moral 1";

for (i = 0; i < moralName.length; i++)
{
    var strChar = moralName.charAt(i);
    app.keyboard().typeString(strChar);
}

app.keyboard().typeString("\n");

if(window.textFields()["Choice"].value() == moralName) {
       UIALogger.logPass(testCaseName + " correct."); 
} else {
       UIALogger.logFail(testCaseName + " incorrect: " + window.textFields()["Choice"].value());
}

testCaseName = testSuiteName + " Virtue moralButton Selection";
UIALogger.logStart(testCaseName + " Test");

window.buttons()["Select a Virtue"].tap();
window.searchBars()[0].tap();
var moralType = "Aptitude\n";

for (i = 0; i < moralType.length; i++)
{
    var strChar = moralType.charAt(i);
    app.keyboard().typeString(strChar);
}

window.tableViews()["Empty list"].cells()["Aptitude, Ability, Excellence, Potential, Precision, Industriousness, Savvy, Talent"].tap();

UIALogger.logPass(testCaseName + " Selected");

testCaseName = testSuiteName + " Virtue severitySlider Set";
UIALogger.logStart(testCaseName + " Test");

var virtueSeverity = 0.25;
var virtueSeveritySliderValue = (virtueSeverity * 100) + "%";

window.sliders()["Virtue Severity"].dragToValue(virtueSeverity);

if(window.sliders()["Virtue Severity"].value() == virtueSeveritySliderValue) {
       UIALogger.logPass(testCaseName + " correctly"); 
} else {
       UIALogger.logFail(testCaseName + " incorrectly: " + window.sliders()["Virtue Severity"].value());
}

testCaseName = testSuiteName + " Choice descriptionTextView Entry";
UIALogger.logStart(testCaseName + " Test");

window.textViews()["Description"].tap();

var moralDescription = "Moral test description 1\n\nLine 2";

for (i = 0; i < moralDescription.length; i++)
{
    var strChar = moralDescription.charAt(i);
    app.keyboard().typeString(strChar);
}

window.buttons()["Done"].tap();

if(window.textViews()["Description"].value() == moralDescription) {
       UIALogger.logPass(testCaseName + " correct."); 
} else {
       UIALogger.logFail(testCaseName + " incorrect: " + window.textViews()["Description"].value());
}

UIALogger.logMessage("Details Entry Testing");
app.navigationBar().rightButton().tap();

testCaseName = testSuiteName + " Details justificationTextField Entry";
UIALogger.logStart(testCaseName + " Test");

window.textFields()["Justification"].tap();

var justification = "Justification test 1";

for (i = 0; i < justification.length; i++)
{
    var strChar = justification.charAt(i);
    app.keyboard().typeString(strChar);
}

app.keyboard().typeString("\n");

if(window.textFields()["Justification"].value() == justification) {
       UIALogger.logPass(testCaseName + " correct."); 
} else {
       UIALogger.logFail(testCaseName + " incorrect: " + window.textFields()["Justification"].value());
}

testCaseName = testSuiteName + " Details consequenceTextField Entry";
UIALogger.logStart(testCaseName + " Test");

window.textFields()["Consequence"].tap();

var consequence = "Consequence test 1";

for (i = 0; i < consequence.length; i++)
{
    var strChar = consequence.charAt(i);
    app.keyboard().typeString(strChar);
}

app.keyboard().typeString("\n");

if(window.textFields()["Consequence"].value() == consequence) {
       UIALogger.logPass(testCaseName + " correct."); 
} else {
       UIALogger.logFail(testCaseName + " incorrect: " + window.textFields()["Consequence"].value());
}

testCaseName = testSuiteName + " Details influenceSlider Set";
UIALogger.logStart(testCaseName + " Test");

var influence = 0.25;
var influenceSliderValue = (influence * 100) + "%";

window.sliders()["Influence"].dragToValue(influence);

if(window.sliders()["Influence"].value() == influenceSliderValue) {
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

if(window.textFields()["Justification"].value() == justification) {
       UIALogger.logPass(testCaseName + " succeeded.");
} else {
       UIALogger.logFail(testCaseName + " failed: " + window.textFields()["Justification"].value());
		hasError = 1;
}

testCaseName = testSuiteName + " Details consequenceTextField Save";
UIALogger.logStart(testCaseName + " Test");

if(window.textFields()["Consequence"].value() == consequence) {
	UIALogger.logPass(testCaseName + " succeeded."); 
} else {
	UIALogger.logFail(testCaseName + " failed: " + window.textFields()["Consequence"].value());
	hasError = 1;
}

testCaseName = testSuiteName + " Details influenceSlider Save";
UIALogger.logStart(testCaseName + " Test");

if(window.sliders()["Influence"].value() == influenceSliderValue) {
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

window.buttons()["Done"].tap();
window.buttons()["Done"].tap();