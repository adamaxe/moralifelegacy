/**
Moralife UI mainnavigation
 
@author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org

@date 05/28/2012
@file mainnavigation.js
*/

var target = UIATarget.localTarget();

UIALogger.logStart("MoraLife Testing Begins");
UIALogger.logDebug("Main Navigation");
UIATarget.localTarget().frontMostApp().logElementTree();

target.captureScreenWithName("Initial Screenshot");

if (target.frontMostApp().tabBar().buttons()["Journal"]==null ||
target.frontMostApp().tabBar().buttons()["Journal"]==null ||
target.frontMostApp().tabBar().buttons()["Journal"]==null){
   UIALogger.logFail("FAIL:. UITabBar not loaded"); 
} else {
   UIALogger.logPass("PASS: UITabBar loaded"); 
} 

target.frontMostApp().mainWindow().buttons()["Rank"].tap();
target.frontMostApp().mainWindow().buttons()["Vice"].tap();
target.frontMostApp().mainWindow().buttons()["Virtue"].tap();
target.frontMostApp().tabBar().buttons()["Journal"].tap();
target.frontMostApp().mainWindow().buttons()["Moral Choice"].tap();
target.frontMostApp().navigationBar().rightButton().tap();
target.frontMostApp().navigationBar().leftButton().tap();
target.frontMostApp().navigationBar().leftButton().tap();
target.frontMostApp().mainWindow().buttons()["Immoral Choice"].tap();
target.frontMostApp().navigationBar().rightButton().tap();
target.frontMostApp().navigationBar().leftButton().tap();
target.frontMostApp().navigationBar().leftButton().tap();
target.frontMostApp().mainWindow().buttons()["All Choices"].tap();
target.frontMostApp().navigationBar().leftButton().tap();
target.frontMostApp().tabBar().buttons()["Collection"].tap();
target.frontMostApp().mainWindow().buttons()["Accessories"].tap();
target.frontMostApp().navigationBar().leftButton().tap();
target.frontMostApp().mainWindow().buttons()["Figures"].tap();
target.frontMostApp().navigationBar().leftButton().tap();
target.frontMostApp().mainWindow().buttons()["Morals"].tap();
target.frontMostApp().navigationBar().leftButton().tap();
target.frontMostApp().tabBar().buttons()["Home"].tap();

UIALogger.logPass("PASS: Main Navigation Complete"); 
