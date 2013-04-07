/**
Moralife Conscience Modal Screen navigation
 
@author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org

@date 05/28/2012
@file consciencenavigation.js
*/

#import "include/uiajsinclude.js"

var testSuiteName = "Conscience Navigation (consciencenavigation)";
var testCaseName;

UIALogger.logMessage(testSuiteName + " Testing Begins");

testCaseName = testSuiteName + " Conscience Entry";
UIALogger.logStart(testCaseName + " Test");

target.tap({x:130.00, y:300.00});

if (window.buttons()["Commissary"].checkIsValid()){
	
	window.buttons()["Commissary"].tap();
	UIALogger.logPass(testCaseName + " correct."); 	

    testCaseName = testSuiteName + " Commissary Feature Navigation";
    UIALogger.logStart(testCaseName + " Test");
    
    if (window.buttons()["Features"].checkIsValid()){ 
        
        window.buttons()["Features"].tap();
        window.buttons()["Eye"].tap();
        window.buttons()["Previous"].tap();		
        window.buttons()["Face"].tap();
        window.buttons()["Previous"].tap();
        window.buttons()["Mouth"].tap();
        window.buttons()["Previous"].tap();
        window.buttons()["Bubble"].tap();		
		target.delay(2.0);
        window.buttons()["Previous"].tap();
		target.delay(2.0);
        window.buttons()["Previous"].tap();

        UIALogger.logPass(testCaseName + " correct."); 

    } else {
        UIALogger.logFail(testCaseName + " incorrect."); 
    }        
    
    testCaseName = testSuiteName + " Commissary Colors Navigation";
    UIALogger.logStart(testCaseName + " Test");
    
    if (window.buttons()["Colors"].checkIsValid()){ 

        window.buttons()["Colors"].tap();
        window.buttons()["Eye"].tap();
        window.buttons()["Previous"].tap();
        window.buttons()["Brow"].tap();
//        window.buttons()["Previous"].tap();
//        window.buttons()["Bubble"].tap();
        window.buttons()["Previous"].tap();      
        window.buttons()["Previous"].tap();
        
        UIALogger.logPass(testCaseName + " correct."); 
        
    } else {
        UIALogger.logFail(testCaseName + " incorrect."); 
    }        

    testCaseName = testSuiteName + " Commissary Accessories Navigation";
    UIALogger.logStart(testCaseName + " Test");
    
    if (window.buttons()["Accessories"].checkIsValid()){ 
    
        window.buttons()["Accessories"].tap();
        window.buttons()["Primary Accessory"].tap();
		target.delay(2.0);
        window.buttons()["Previous"].tap();
        window.buttons()["Secondary Accessory"].tap();
		target.delay(2.0);
        window.buttons()["Previous"].tap();
        window.buttons()["Top Accessory"].tap();
		target.delay(2.0);
        window.buttons()["Previous"].tap();
        window.buttons()["Bottom Accessory"].tap();
		target.delay(2.0);
        window.buttons()["Previous"].tap();
        window.buttons()["Previous"].tap();		

        UIALogger.logPass(testCaseName + " correct."); 
        
    } else {
        UIALogger.logFail(testCaseName + " incorrect."); 
    }        

	window.buttons()["Previous"].tap();		
	
    testCaseName = testSuiteName + " Morathology Navigation";
    UIALogger.logStart(testCaseName + " Test");
    
    if (window.buttons()["Morathology"].checkIsValid()){ 

        window.buttons()["Morathology"].tap();
        window.buttons()["Orientation"].tap();
        window.buttons()["Previous"].tap();
        window.buttons()["Atlantic"].tap();
		target.delay(2.0);		
        window.buttons()["Previous"].tap();
		target.delay(2.0);		
        window.buttons()["Previous"].tap();
                        
        UIALogger.logPass(testCaseName + " correct."); 
        
    } else {
        UIALogger.logFail(testCaseName + " incorrect."); 
    }

    testCaseName = testSuiteName + " Moral Report Navigation";
    UIALogger.logStart(testCaseName + " Test");
    
    if (window.buttons()["Moral Report"].checkIsValid()){ 
                
        window.buttons()["Moral Report"].tap();
		target.delay(2.0);
        window.buttons()["Moral Sort"].tap();
        window.buttons()["Moral Order"].tap();        
        window.buttons()["Moral Type"].tap();        
        window.buttons()["Previous"].tap();
        
        UIALogger.logPass(testCaseName + " correct."); 
        
    } else {
        UIALogger.logFail(testCaseName + " incorrect."); 
    }

    window.buttons()["Previous"].tap();
		
} else {
	UIALogger.logFail(testCaseName + " incorrect. No commissary"); 
}

UIALogger.logMessage(testSuiteName + " Testing Ends");