/**
Moralife UI Choice Immoral Display validation
 
@author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org

@date 05/28/2012
@file choiceimmoraldisplay.js
*/

var target = UIATarget.localTarget();

UIALogger.logMessage("MoraLife Choice Immoral Testing Begins");
//UIATarget.localTarget().frontMostApp().logElementTree();

target.frontMostApp().tabBar().buttons()["Journal"].tap();
target.frontMostApp().mainWindow().buttons()["Immoral Choice"].tap();

UIALogger.logStart("Choice Immoral Default Text Test");

if(target.frontMostApp().mainWindow().textFields()["Choice"].value() == "Enter in your bad deed.") {
	UIALogger.logPass("Choice Default Text correct"); 
} else {
	UIALogger.logFail("Choice Default Text incorrect: " + target.frontMostApp().mainWindow().textFields()["Choice"].value());
}

UIALogger.logStart("Choice Immoral Button Display Test");

if(target.frontMostApp().mainWindow().buttons()["Select a Vice"].value() == "") {
	UIALogger.logFail("Choice Button Title incorrect");
} else {
	UIALogger.logPass("Choice Button Title correct"); 
}

UIALogger.logStart("Choice Immoral Severity Label Display Test");

if(target.frontMostApp().mainWindow().buttons()["Bad"].value() == "") {
	UIALogger.logFail("Severity Label incorrect");
} else {
	UIALogger.logPass("Severity Label correct"); 
}

target.frontMostApp().mainWindow().buttons()["Cancel"].tap();