/**
Moralife UI Choice Moral Cancel validation
 
@author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org

@date 05/28/2012
@file choicemoralcancel.js
*/

var target = UIATarget.localTarget();

UIALogger.logMessage("MoraLife Choice Moral Testing Begins");
//UIATarget.localTarget().frontMostApp().logElementTree();

target.frontMostApp().tabBar().buttons()["Journal"].tap();

UIALogger.logStart("Choice Cancel Test");

target.frontMostApp().mainWindow().buttons()["Moral Choice"].tap();

target.frontMostApp().mainWindow().textFields()["Choice"].tap();

UIATarget.localTarget().frontMostApp().logElementTree();

var choiceCancel = "Choice Cancel 1";

for (i = 0; i < choiceCancel.length; i++)
{
    var strChar = choiceCancel.charAt(i);
    target.frontMostApp().keyboard().typeString(strChar);
}

target.frontMostApp().keyboard().typeString("\n");

target.frontMostApp().mainWindow().buttons()["Cancel"].tap();
target.frontMostApp().mainWindow().buttons()["Moral Choice"].tap();

if(target.frontMostApp().mainWindow().textFields()["Choice"].value() == choiceCancel) {
	UIALogger.logFail("Choice field cleared incorrectly: " + target.frontMostApp().mainWindow().textFields()["Choice"].value());
} else {
	UIALogger.logPass("Choice field cleared correctly"); 
}

//UIALogger.logStart("Virtue Cancel Test");
//
//target.frontMostApp().mainWindow().buttons()["Select a Virtue"].tap();
//target.frontMostApp().mainWindow().searchBars()[0].tap();
//var moralType = "Aptitude\n";
//
//for (i = 0; i < moralType.length; i++)
//{
//    var strChar = moralType.charAt(i);
//    target.frontMostApp().keyboard().typeString(strChar);
//}
//
//target.frontMostApp().mainWindow().tableViews()["Empty list"].cells()["Aptitude, Ability, Excellence, Potential, Precision, Industriousness, Savvy, Talent"].tap();
//
//UIALogger.logPass("Virtue Selected");

UIALogger.logStart("Virtue Severity Test");

var virtueSeverity = 0.25;
var virtueSeveritySliderValue = (virtueSeverity * 100) + "%";

target.frontMostApp().mainWindow().sliders()["Virtue Severity"].dragToValue(virtueSeverity);

target.frontMostApp().mainWindow().buttons()["Cancel"].tap();
target.frontMostApp().mainWindow().buttons()["Moral Choice"].tap();

if(target.frontMostApp().mainWindow().sliders()["Virtue Severity"].value() == virtueSeveritySliderValue) {
    UIALogger.logFail("Virtue Severity didn't clear: " + target.frontMostApp().mainWindow().sliders()["Virtue Severity"].value());
} else {
    UIALogger.logPass("Virtue Severity cleared correctly");     
}

UIALogger.logStart("Choice Description Clear Test");

target.frontMostApp().mainWindow().textViews()["Description"].tap();

var moralDescription = "Moral test description 1\n\nLine 2";

for (i = 0; i < moralDescription.length; i++)
{
    var strChar = moralDescription.charAt(i);
    target.frontMostApp().keyboard().typeString(strChar);
}

target.frontMostApp().mainWindow().buttons()["Done"].tap();

target.frontMostApp().mainWindow().buttons()["Cancel"].tap();
target.frontMostApp().mainWindow().buttons()["Moral Choice"].tap();

if(target.frontMostApp().mainWindow().textViews()["Description"].value() == moralDescription) {
    UIALogger.logFail("Description field didn't clear: " + target.frontMostApp().mainWindow().textViews()["Description"].value());
} else {
    UIALogger.logPass("Description field cleared correctly"); 
}

UIALogger.logMessage("Details Cancel Testing");
target.frontMostApp().navigationBar().rightButton().tap();

UIALogger.logStart("Choice Justification Cancel Test");

target.frontMostApp().mainWindow().textFields()["Justification"].tap();

var justification = "Justification test 1";

for (i = 0; i < justification.length; i++)
{
    var strChar = justification.charAt(i);
    target.frontMostApp().keyboard().typeString(strChar);
}

target.frontMostApp().keyboard().typeString("\n");

target.frontMostApp().mainWindow().buttons()["Cancel"].tap();
target.frontMostApp().navigationBar().rightButton().tap();

if(target.frontMostApp().mainWindow().textFields()["Justification"].value() == justification) {
    UIALogger.logFail("Justification field didn't clear: " + target.frontMostApp().mainWindow().textFields()["Justification"].value());
} else {
    UIALogger.logPass("Justification field cleared correctly");     
}

UIALogger.logStart("Choice Consequence Cancel Test");

target.frontMostApp().mainWindow().textFields()["Consequence"].tap();

var consequenceCancel = "Consequence Cancel 1";

for (i = 0; i < consequenceCancel.length; i++)
{
    var strChar = consequenceCancel.charAt(i);
    target.frontMostApp().keyboard().typeString(strChar);
}

target.frontMostApp().keyboard().typeString("\n");

target.frontMostApp().mainWindow().buttons()["Cancel"].tap();
target.frontMostApp().navigationBar().rightButton().tap();

if(target.frontMostApp().mainWindow().textFields()["Consequence"].value() == consequenceCancel) {
	UIALogger.logFail("Consequence field cleared incorrectly: " + target.frontMostApp().mainWindow().textFields()["Consequence"].value());
} else {
	UIALogger.logPass("Consequence field cleared correctly"); 
}

UIALogger.logStart("Influence Clear Test");

var influence = 0.25;
var influenceSliderValue = (influence * 100) + "%";

target.frontMostApp().mainWindow().sliders()["Influence"].dragToValue(influence);

target.frontMostApp().mainWindow().buttons()["Cancel"].tap();
target.frontMostApp().navigationBar().rightButton().tap();

if(target.frontMostApp().mainWindow().sliders()["Influence"].value() == influenceSliderValue) {
    UIALogger.logFail("Influence didn't clear: " + target.frontMostApp().mainWindow().sliders()["Influence"].value());
} else {
    UIALogger.logPass("Influence cleared correctly"); 
}

target.frontMostApp().mainWindow().sliders()["Influence"].dragToValue(influence);

target.frontMostApp().mainWindow().buttons()["Cancel"].tap();
target.frontMostApp().mainWindow().buttons()["Cancel"].tap();