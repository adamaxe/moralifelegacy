/**
Moralife UI Choice Moral Entry Verification
 
@author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org

@date 05/28/2012
@file choicemoralverify.js
*/

#import "include/uiajsinclude.js"

var testSuiteName = "Choice - Moral Entry Verification";
var testCaseName;

UIALogger.logMessage(testSuiteName + " Testing Begins");

testCaseName = testSuiteName + " Verify Moral Journal Entry";

UIALogger.logStart(testCaseName + " Test");

app.tabBar().buttons()["Journal"].tap();

if (app.tabBar().buttons()["Journal"].checkIsValid()){ 
    
    window.buttons()["All Choices"].tap();
        	
    window.tableViews()[0].cells()[0].tap();
    
    UIALogger.logPass(testCaseName + " loaded"); 
} else {
    UIALogger.logFail(testCaseName + " NOT loaded"); 
}

target.delay(2.0);

if(app.navigationBar().name() == "Moral Choice") {
	UIALogger.logPass(testCaseName + " correct"); 
} else {
	UIALogger.logFail(testCaseName + " incorrect: " + app.navigationBar().name());
}

testCaseName = testSuiteName + " choiceTextField entry";
UIALogger.logStart(testCaseName + " Test");

if(window.textFields()["Choice"].value() == moralName) {
       UIALogger.logPass(testCaseName + " verified."); 
} else {
       UIALogger.logFail(testCaseName + " not verified: " + window.textFields()["Choice"].value());
}

testCaseName = testSuiteName + " Virtue moralButton selection";
target.delay(2.0);

UIALogger.logMessage(window.buttons()["Select a Virtue"].name());

testCaseName = testSuiteName + " Virtue severitySlider set";
UIALogger.logStart(testCaseName + " Test");

if(window.sliders()["Virtue Severity"].value() == virtueSeveritySliderValue) {
       UIALogger.logPass(testCaseName + " verified"); 
} else {
       UIALogger.logFail(testCaseName + " not verified: " + window.sliders()["Virtue Severity"].value());
}

testCaseName = testSuiteName + " Choice descriptionTextView entry";
UIALogger.logStart(testCaseName + " Test");

if(window.textViews()["Description"].value() == moralDescription) {
       UIALogger.logPass(testCaseName + " verified."); 
} else {
       UIALogger.logFail(testCaseName + " not verified: " + window.textViews()["Description"].value());
}

UIALogger.logMessage("Details Entry Verification");
app.navigationBar().rightButton().tap();

testCaseName = testSuiteName + " Details justificationTextField Entry";
UIALogger.logStart(testCaseName + " Test");

if(window.textFields()["Justification"].value() == moralJustification) {
       UIALogger.logPass(testCaseName + " verified."); 
} else {
       UIALogger.logFail(testCaseName + " not verified: " + window.textFields()["Justification"].value());
}

testCaseName = testSuiteName + " Details consequenceTextField Entry";
UIALogger.logStart(testCaseName + " Test");

if(window.textFields()["Consequence"].value() == moralConsequence) {
       UIALogger.logPass(testCaseName + " verified."); 
} else {
       UIALogger.logFail(testCaseName + " not verified: " + window.textFields()["Consequence"].value());
}

testCaseName = testSuiteName + " Details influenceSlider Set";
UIALogger.logStart(testCaseName + " Test");

if(window.sliders()["Influence"].value() == moralInfluenceSliderValue) {
       UIALogger.logPass(testCaseName + " verified."); 
} else {
       UIALogger.logFail(testCaseName + " not verified: " + window.sliders()["Influence"].value());
}

window.textFields()["Consequence"].tap();

app.keyboard().typeString("\n");

target.delay(2.0);
window.buttons()["Cancel"].tap();
target.delay(2.0);
window.buttons()["Cancel"].tap();
app.navigationBar().leftButton().tap();