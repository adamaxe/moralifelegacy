/**
Moralife UI Choice Moral Entry Validation.  Test Data populated from uijsinclude
 
@author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org

@date 05/28/2012
@file choicemoralentry.js
*/

#import "include/uiajsinclude.js"

var testSuiteName = "Choice - Moral Entry";
var testCaseName;

UIALogger.logMessage(testSuiteName + " Testing Begins");

app.tabBar().buttons()["Journal"].tap();

window.buttons()["Moral Choice"].tap();

testCaseName = testSuiteName + " choiceTextField Required Field";
UIALogger.logStart(testCaseName + " Test");

window.buttons()["Done"].tap();

if(window.buttons()["Previous"].checkIsValid()) {
    window.buttons()["Previous"].tap();
    UIALogger.logPass(testCaseName + " correct."); 
} else {
    UIALogger.logFail(testCaseName + " incorrect.");
}

testCaseName = testSuiteName + " choiceTextField Entry";
UIALogger.logStart(testCaseName + " Test");

window.textFields()["Choice"].tap();

for (i = 0; i < moralName.length; i++) {
    var strChar = moralName.charAt(i);
    app.keyboard().typeString(strChar);
}

app.keyboard().typeString("\n");

if(window.textFields()["Choice"].value() == moralName) {
       UIALogger.logPass(testCaseName + " correct."); 
} else {
       UIALogger.logFail(testCaseName + " incorrect: " + window.textFields()["Choice"].value());
}
                      
testCaseName = testSuiteName + " Virtue moralButton Required Field";
UIALogger.logStart(testCaseName + " Test");

target.delay(2.0);
window.buttons()["Done"].tap();

if(window.buttons()["Previous"].checkIsValid()) {
    window.buttons()["Previous"].tap();
    UIALogger.logPass(testCaseName + " correct."); 
} else {
    UIALogger.logFail(testCaseName + " incorrect.");
}

testCaseName = testSuiteName + " Virtue moralButton Selection";
UIALogger.logStart(testCaseName + " Test");

window.buttons()["Select a Virtue"].tap();
window.searchBars()[0].tap();
var moralType = "Aptitude";

for (i = 0; i < moralType.length; i++) {
    var strChar = moralType.charAt(i);
    app.keyboard().typeString(strChar);
}

app.keyboard().typeString("\n");

window.tableViews()[0].cells()[0].tap();

UIALogger.logPass(testCaseName + " Selected");

testCaseName = testSuiteName + " Virtue severitySlider Set";
UIALogger.logStart(testCaseName + " Test");

window.sliders()["Virtue Severity"].dragToValue(virtueSeverity);

if(window.sliders()["Virtue Severity"].value() == virtueSeveritySliderValue) {
       UIALogger.logPass(testCaseName + " correctly"); 
} else {
       UIALogger.logFail(testCaseName + " incorrectly: " + window.sliders()["Virtue Severity"].value());
}

testCaseName = testSuiteName + " Choice descriptionTextView Entry";
UIALogger.logStart(testCaseName + " Test");

window.textViews()["Description"].tap();

for (i = 0; i < moralDescription.length; i++) {
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

for (i = 0; i < moralJustification.length; i++) {
    var strChar = moralJustification.charAt(i);
    app.keyboard().typeString(strChar);
}

app.keyboard().typeString("\n");

if(window.textFields()["Justification"].value() == moralJustification) {
       UIALogger.logPass(testCaseName + " correct."); 
} else {
       UIALogger.logFail(testCaseName + " incorrect: " + window.textFields()["Justification"].value());
}

testCaseName = testSuiteName + " Details consequenceTextField Entry";
UIALogger.logStart(testCaseName + " Test");

window.textFields()["Consequence"].tap();

for (i = 0; i < moralConsequence.length; i++) {
    var strChar = moralConsequence.charAt(i);
    app.keyboard().typeString(strChar);
}

app.keyboard().typeString("\n");

if(window.textFields()["Consequence"].value() == moralConsequence) {
       UIALogger.logPass(testCaseName + " correct."); 
} else {
       UIALogger.logFail(testCaseName + " incorrect: " + window.textFields()["Consequence"].value());
}

testCaseName = testSuiteName + " Details influenceSlider Set";
UIALogger.logStart(testCaseName + " Test");

window.sliders()["Influence"].dragToValue(moralInfluence);

if(window.sliders()["Influence"].value() == moralInfluenceSliderValue) {
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

if(window.textFields()["Justification"].value() == moralJustification) {
       UIALogger.logPass(testCaseName + " succeeded.");
} else {
       UIALogger.logFail(testCaseName + " failed: " + window.textFields()["Justification"].value());
		hasError = 1;
}

testCaseName = testSuiteName + " Details consequenceTextField Save";
UIALogger.logStart(testCaseName + " Test");

if(window.textFields()["Consequence"].value() == moralConsequence) {
	UIALogger.logPass(testCaseName + " succeeded."); 
} else {
	UIALogger.logFail(testCaseName + " failed: " + window.textFields()["Consequence"].value());
	hasError = 1;
}

testCaseName = testSuiteName + " Details influenceSlider Save";
UIALogger.logStart(testCaseName + " Test");

if(window.sliders()["Influence"].value() == moralInfluenceSliderValue) {
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

app.tabBar().buttons()["Home"].tap();