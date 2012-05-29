/**
Moralife UI mainnavigation
 
@author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org

@date 05/28/2012
@file mainnavigation.js
*/

var target = UIATarget.localTarget();

UIALogger.logStart("MoraLife Main Navigation Testing Begins");

//UIALogger.logDebug("Main Navigation");
UIATarget.localTarget().frontMostApp().logElementTree();

//target.captureScreenWithName("Initial Screenshot");

if (target.frontMostApp().tabBar().buttons()["Home"]!=null) {
target.frontMostApp().mainWindow().buttons()["Rank"].tap();
target.frontMostApp().mainWindow().buttons()["Vice"].tap();
target.frontMostApp().mainWindow().buttons()["Virtue"].tap();
   UIALogger.logPass("UITabBar Home loaded"); 
} else {
   UIALogger.logFail("UITabBar Home NOT loaded"); 
} 

if (target.frontMostApp().tabBar().buttons()["Journal"]!=null){ 
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

   UIALogger.logPass("UITabBar Journal loaded"); 
} else {

   UIALogger.logFail("UITabBar Journal not loaded"); 
}

if (target.frontMostApp().tabBar().buttons()["Collection"]!=null) {
target.frontMostApp().tabBar().buttons()["Collection"].tap();
target.frontMostApp().mainWindow().buttons()["Accessories"].tap();
target.frontMostApp().navigationBar().leftButton().tap();
target.frontMostApp().mainWindow().buttons()["Figures"].tap();
target.frontMostApp().navigationBar().leftButton().tap();
target.frontMostApp().mainWindow().buttons()["Morals"].tap();
target.frontMostApp().navigationBar().leftButton().tap();
target.frontMostApp().tabBar().buttons()["Home"].tap();
  UIALogger.logPass("UITabBar Collection loaded");
} else {
  UIALogger.logFail("UITabBar Collection NOT loaded");
}

UIALogger.logPass("Main Navigation Complete"); 
