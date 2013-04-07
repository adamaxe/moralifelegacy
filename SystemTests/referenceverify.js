/**
Moralife UI Choice Reference Section Verification - Verify that the default application reference data is present
 
@author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org

@date 05/28/2012
@file referenceverify.js
*/

#import "include/uiajsinclude.js"

var testSuiteName = "Reference Verify (referenceverify.js)";
var testCaseName;

UIALogger.logMessage(testSuiteName + " Testing Begins");

testCaseName = testSuiteName + " Verify Default Accessories";

UIALogger.logStart(testCaseName + " Test");

if (app.navigationBar().buttons()["Collection"].checkIsValid()){

    app.navigationBar().buttons()["Collection"].tap();

    window.buttons()["Accessories"].tap();
        	
    window.tableViews()[0].cells()[0].tap();
    
    UIALogger.logPass(testCaseName + " loaded"); 
} else {
    UIALogger.logFail(testCaseName + " NOT loaded"); 
}

testCaseName = testSuiteName + " Verify 1st Accessory fields";
target.delay(2.0);

testCaseName = testSuiteName + " Accessory Title Verification";
UIALogger.logStart(testCaseName + " Test");

if(window.staticTexts()["Reference Name"].value() == defaultReferenceAccessoryName1) {
	UIALogger.logPass(testCaseName + " verified");
} else {
	UIALogger.logFail(testCaseName + " not verified: " + window.staticTexts()["Reference Name"].value());
}

testCaseName = testSuiteName + " Reference Long Description Verification";
UIALogger.logStart(testCaseName + " Test");

if(window.textViews()["Long Description"].value() == defaultReferenceAccessoryDescription1) {
	UIALogger.logPass(testCaseName + " verified");
} else {
	UIALogger.logFail(testCaseName + " not verified: " + window.textViews()["Long Description"].value());
}

window.buttons()["Cancel"].tap();
window.tableViews()[0].cells()[1].tap();

testCaseName = testSuiteName + " Verify 2nd Accessory fields";
target.delay(2.0);

testCaseName = testSuiteName + " Accessory Title Verification";
UIALogger.logStart(testCaseName + " Test");

if(window.staticTexts()["Reference Name"].value() == defaultReferenceAccessoryName2) {
	UIALogger.logPass(testCaseName + " verified");
} else {
	UIALogger.logFail(testCaseName + " not verified: " + window.staticTexts()["Reference Name"].value());
}

testCaseName = testSuiteName + " Reference Long Description Verification";
UIALogger.logStart(testCaseName + " Test");

if(window.textViews()["Long Description"].value() == defaultReferenceAccessoryDescription2) {
	UIALogger.logPass(testCaseName + " verified");
} else {
	UIALogger.logFail(testCaseName + " not verified: " + window.textViews()["Long Description"].value());
}

window.buttons()["Cancel"].tap();
window.buttons()["Cancel"].tap();

testCaseName = testSuiteName + " Figures Verification";
UIALogger.logStart(testCaseName + " Test");

if (window.buttons()["Figures"].checkIsValid()){ 
    
    window.buttons()["Figures"].tap();
        	
    window.tableViews()[0].cells()[0].tap();
    
    UIALogger.logPass(testCaseName + " loaded"); 
} else {
    UIALogger.logFail(testCaseName + " NOT loaded"); 
}

testCaseName = testSuiteName + " Verify Quote available";

UIALogger.logStart(testCaseName + " Test");

window.buttons()["Quote"].tap();

if (window.buttons()["Previous"].checkIsValid()){ 
    
    window.buttons()["Previous"].tap();
        	    
    UIALogger.logPass(testCaseName + " loaded"); 
} else {
    UIALogger.logFail(testCaseName + " NOT loaded"); 
}

testCaseName = testSuiteName + " Verify 1st Figure fields";
target.delay(2.0);

testCaseName = testSuiteName + " Figure Title Verification";
UIALogger.logStart(testCaseName + " Test");

if(window.staticTexts()["Reference Name"].value() == defaultReferenceFigureName) {
	UIALogger.logPass(testCaseName + " verified");
} else {
	UIALogger.logFail(testCaseName + " not verified: " + window.staticTexts()["Reference Name"].value());
}

testCaseName = testSuiteName + " Reference Long Description Verification";
UIALogger.logStart(testCaseName + " Test");

if(window.textViews()["Long Description"].value() == defaultReferenceFigureDescription) {
	UIALogger.logPass(testCaseName + " verified");
} else {
	UIALogger.logFail(testCaseName + " not verified: " + window.textViews()["Long Description"].value());
}

window.buttons()["Cancel"].tap();
window.buttons()["Cancel"].tap();

testCaseName = testSuiteName + " Figures Verification";
UIALogger.logStart(testCaseName + " Test");

if (window.buttons()["Morals"].checkIsValid()){ 
    
    window.buttons()["Morals"].tap();
        	
    window.tableViews()[0].cells()[0].tap();
    
    UIALogger.logPass(testCaseName + " loaded"); 
} else {
    UIALogger.logFail(testCaseName + " NOT loaded"); 
}

testCaseName = testSuiteName + " Verify 1st Moral fields";
target.delay(2.0);

testCaseName = testSuiteName + " Moral Title Verification";
UIALogger.logStart(testCaseName + " Test");

if(window.staticTexts()["Reference Name"].value() == defaultReferenceMoralName) {
	UIALogger.logPass(testCaseName + " verified");
} else {
	UIALogger.logFail(testCaseName + " not verified: " + window.staticTexts()["Reference Name"].value());
}

testCaseName = testSuiteName + " Reference Long Description Verification";
UIALogger.logStart(testCaseName + " Test");

if(window.textViews()["Long Description"].value() == defaultReferenceMoralDescription) {
	UIALogger.logPass(testCaseName + " verified");
} else {
	UIALogger.logFail(testCaseName + " not verified: " + window.textViews()["Long Description"].value());
}

window.buttons()["Cancel"].tap();
window.buttons()["Cancel"].tap();

target.delay(2.0);
app.navigationBar().leftButton().tap();

UIALogger.logMessage(testSuiteName + " Testing Ends");