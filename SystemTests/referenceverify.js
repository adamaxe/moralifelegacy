/**
Moralife UI Choice Reference Section Verification
 
@author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org

@date 05/28/2012
@file referenceverify.js
*/

#import "include/uiajsinclude.js"

var testSuiteName = "Reference - Default Value Verification";
var testCaseName;

UIALogger.logMessage(testSuiteName + " Testing Begins");

testCaseName = testSuiteName + " Verify Default Accessories";

UIALogger.logStart(testCaseName + " Test");

app.tabBar().buttons()["Collection"].tap();

if (app.tabBar().buttons()["Collection"].checkIsValid()){ 
    
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

if(window.staticTexts()["Reference Name"].value() == "Bare Neck") {
	UIALogger.logPass(testCaseName + " verified");
} else {
	UIALogger.logFail(testCaseName + " not verified: " + window.staticTexts()["Reference Name"].value());
}

testCaseName = testSuiteName + " Reference Long Description Verification";
UIALogger.logStart(testCaseName + " Test");

if(window.textViews()["Long Description"].value() == "This Accessory, when equipped, will allow you to remove whatever is slung around my neck.") {
	UIALogger.logPass(testCaseName + " verified");
} else {
	UIALogger.logFail(testCaseName + " not verified: " + window.textViews()["Long Description"].value());
}

app.navigationBar().leftButton().tap();
app.navigationBar().leftButton().tap();

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

if(window.staticTexts()["Reference Name"].value() == "You") {
	UIALogger.logPass(testCaseName + " verified");
} else {
	UIALogger.logFail(testCaseName + " not verified: " + window.staticTexts()["Reference Name"].value());
}

testCaseName = testSuiteName + " Reference Long Description Verification";
UIALogger.logStart(testCaseName + " Test");

if(window.textViews()["Long Description"].value() == "Every hero is a regular person first.  You have chosen to take some responsibility for your actions by using MoraLife.  So, the only question now is how are you going to leave your mark on the world?") {
	UIALogger.logPass(testCaseName + " verified");
} else {
	UIALogger.logFail(testCaseName + " not verified: " + window.textViews()["Long Description"].value());
}

app.navigationBar().leftButton().tap();
app.navigationBar().leftButton().tap();


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

if(window.staticTexts()["Reference Name"].value() == "Aloofness") {
	UIALogger.logPass(testCaseName + " verified");
} else {
	UIALogger.logFail(testCaseName + " not verified: " + window.staticTexts()["Reference Name"].value());
}

testCaseName = testSuiteName + " Reference Long Description Verification";
UIALogger.logStart(testCaseName + " Test");

if(window.textViews()["Long Description"].value() == "Vice: Indifference, Standoffishness") {
	UIALogger.logPass(testCaseName + " verified");
} else {
	UIALogger.logFail(testCaseName + " not verified: " + window.textViews()["Long Description"].value());
}

app.navigationBar().leftButton().tap();
app.navigationBar().leftButton().tap();


target.delay(2.0);
app.tabBar().buttons()["Home"].tap();