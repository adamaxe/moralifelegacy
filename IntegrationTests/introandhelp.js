/**
Moralife UI Main Navigation traversal validation
 
@author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org

@date 05/28/2012
@file mainnavigation.js
*/

#import "include/uiajsinclude.js"

var testSuiteName = "Intro and Help Screen Dismissal";
var testCaseName;

UIALogger.logMessage(testSuiteName + " Testing Begins");

testCaseName = testSuiteName + " ConscienceView (Home)";

UIALogger.logStart(testCaseName + " Test");

//try {

	if (!app.tabBar().buttons()["Home"].checkIsValid()){

		target.delay(20.0);

		if (window.buttons()["Introduction skip"]!=null){ 
    
		    window.buttons()["Introduction skip"].tap();

		    target.delay(5.0);
    
		    app.tabBar().buttons()["Journal"].tap();
		    window.buttons()["Previous"].tap();
		    window.buttons()["Moral Choice"].tap();
		    window.buttons()["Previous"].tap();
		    app.navigationBar().rightButton().tap();
		    window.buttons()["Previous"].tap();
		    app.tabBar().buttons()["Collection"].tap();
		    window.buttons()["Previous"].tap();
		    app.tabBar().buttons()["Home"].tap();
//			window.buttons()["Previous"].tap();
//			window.buttons()["icon customization"].tap();
//			window.buttons()["icon features"].tap();

  			UIALogger.logPass(testCaseName + " passed"); 
		} else {
    		UIALogger.logFail(testCaseName + " NOT passed"); 
		}
	}
//} catch(err) {
//    UIALogger.logFail(testCaseName + " NOT passed: " + err.message); 	
//}