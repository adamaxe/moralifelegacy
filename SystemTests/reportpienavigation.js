/**
 Moralife Report Screen navigation

 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org

 @date 05/28/2012
 @file reportpienavigation.js
 */

#import "include/uiajsinclude.js"

var testSuiteName = "Report Pie Navigation";
var testCaseName;

UIALogger.logMessage(testSuiteName + " Testing Begins");

testCaseName = testSuiteName + " Conscience View Help Screen";
UIALogger.logStart(testCaseName + " Test");

target.tap({x:130.00, y:300.00});

testCaseName = testSuiteName + " Moral Report Help Screen";
UIALogger.logStart(testCaseName + " Test");

window.buttons()["Moral Report"].tap();
target.delay(2.0);	

testCaseName = testSuiteName + " Initial Report Type verification";
UIALogger.logStart(testCaseName + " Test");

if(window.staticTexts()["Report Type"].value() == "Virtue") {
    UIALogger.logPass(testCaseName + " verified.");
} else {
    UIALogger.logFail(testCaseName + " not verified: " + window.staticTexts()["Report Type"].value());
}

window.buttons()["Moral Type"].tap();

testCaseName = testSuiteName + " Report Type Change verification";
UIALogger.logStart(testCaseName + " Test");

if(window.staticTexts()["Report Type"].value() == "Vice") {
    UIALogger.logPass(testCaseName + " verified.");
} else {
    UIALogger.logFail(testCaseName + " not verified: " + window.staticTexts()["Report Type"].value());
}

testCaseName = testSuiteName + " Initial Report Sort verification";
UIALogger.logStart(testCaseName + " Test");

if(window.buttons()["Moral Sort"].value() == "%") {
    UIALogger.logPass(testCaseName + " verified.");
} else {
    UIALogger.logFail(testCaseName + " not verified: " + window.buttons()["Moral Sort"].value());
}

window.buttons()["Moral Sort"].tap();

testCaseName = testSuiteName + " Report Sort Change verification";
UIALogger.logStart(testCaseName + " Test");

if(window.buttons()["Moral Sort"].value() == "A") {
    UIALogger.logPass(testCaseName + " verified.");
} else {
    UIALogger.logFail(testCaseName + " not verified: " + window.buttons()["Moral Sort"].value());
}

testCaseName = testSuiteName + " Initial Report Order verification";
UIALogger.logStart(testCaseName + " Test");

if(window.buttons()["Moral Order"].value() == "Des") {
    UIALogger.logPass(testCaseName + " verified.");
} else {
    UIALogger.logFail(testCaseName + " not verified: " + window.buttons()["Moral Order"].value());
}

window.buttons()["Moral Order"].tap();

testCaseName = testSuiteName + " Report Order Change verification";
UIALogger.logStart(testCaseName + " Test");

if(window.buttons()["Moral Order"].value() == "Asc") {
    UIALogger.logPass(testCaseName + " verified.");
} else {
    UIALogger.logFail(testCaseName + " not verified: " + window.buttons()["Moral Order"].value());
}

window.buttons()["Previous"].tap();
window.buttons()["Previous"].tap();