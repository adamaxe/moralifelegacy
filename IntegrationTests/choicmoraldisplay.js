/**
Moralife UI Choice Moral Entry
 
@author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org

@date 05/28/2012
@file choiceentrymoral.js
*/

var target = UIATarget.localTarget();

UIALogger.logMessage("MoraLife Choice Moral Testing Begins");
//UIATarget.localTarget().frontMostApp().logElementTree();

target.frontMostApp().tabBar().buttons()["Journal"].tap();
target.frontMostApp().mainWindow().buttons()["Moral Choice"].tap();

UIALogger.logStart("Choice Default Text Test");

if(target.frontMostApp().mainWindow().textFields()["Choice"].value() == "Enter in your good deed.") {
	UIALogger.logPass("Choice Default Text correct"); 
} else {
	UIALogger.logFail("Choice Default Text incorrect: " + target.frontMostApp().mainWindow().textFields()["Choice"].value());
}

UIALogger.logStart("Choice Moral Button Display Test");

if(target.frontMostApp().mainWindow().buttons()["Select a Virtue"].value() == "") {
	UIALogger.logFail("Choice Button Title incorrect");
} else {
	UIALogger.logPass("Choice Button Title correct"); 
}

UIALogger.logStart("Moral Severity Label Display Test");

if(target.frontMostApp().mainWindow().buttons()["Good"].value() == "") {
	UIALogger.logFail("Severity Label incorrect");
} else {
	UIALogger.logPass("Severity Label correct"); 
}

target.frontMostApp().mainWindow().buttons()["Cancel"].tap();