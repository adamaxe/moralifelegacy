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

UIALogger.logStart("Choice Name Test");

target.frontMostApp().mainWindow().textFields()["Choice"].tap();

var moralName = "Test moral 1";

for (i = 0; i < moralName.length; i++)
{
    var strChar = moralName.charAt(i);
    target.frontMostApp().keyboard().typeString(strChar);
}

target.frontMostApp().keyboard().typeString("\n");

if(target.frontMostApp().mainWindow().textFields()["Choice"].value() == moralName) {
       UIALogger.logPass("Choice Name field entered correctly"); 
} else {
       UIALogger.logFail("Choice Name field entered incorrectly: " + target.frontMostApp().mainWindow().textFields()["Choice"].value());
}

UIALogger.logStart("Virtue Selection Test");

target.frontMostApp().mainWindow().buttons()["Select a Virtue"].tap();
target.frontMostApp().mainWindow().searchBars()[0].tap();
var moralType = "Aptitude\n";


for (i = 0; i < moralType.length; i++)
{
    var strChar = moralType.charAt(i);
    target.frontMostApp().keyboard().typeString(strChar);
}

target.frontMostApp().mainWindow().tableViews()["Empty list"].cells()["Aptitude, Ability, Excellence, Potential, Precision, Industriousness, Savvy, Talent"].tap();

UIALogger.logPass("Virtue Selected");

UIALogger.logStart("Virtue Severity Test");

var virtueSeverity = 0.25;
var virtueSeveritySliderValue = (virtueSeverity * 100) + "%";

target.frontMostApp().mainWindow().sliders()["Virtue Severity"].dragToValue(virtueSeverity);

if(target.frontMostApp().mainWindow().sliders()["Virtue Severity"].value() == virtueSeveritySliderValue) {
       UIALogger.logPass("Virtue Severity entered correctly"); 
} else {
       UIALogger.logFail("Virtue Severity entered incorrectly: " + target.frontMostApp().mainWindow().sliders()["Virtue Severity"].value());
}

//target.frontMostApp().mainWindow().textViews()["Description"].tapWithOptions({tapOffset:{x:0.36, y:0.71}});

UIALogger.logStart("Choice Description Test");

target.frontMostApp().mainWindow().textViews()["Description"].tap();

var moralDescription = "Moral test description 1\n\nLine 2";

for (i = 0; i < moralDescription.length; i++)
{
    var strChar = moralDescription.charAt(i);
    target.frontMostApp().keyboard().typeString(strChar);
}

target.frontMostApp().mainWindow().buttons()["Done"].tap();

if(target.frontMostApp().mainWindow().textViews()["Description"].value() == moralDescription) {
       UIALogger.logPass("Description field entered correctly"); 
} else {
       UIALogger.logFail("Description field entered incorrectly: " + target.frontMostApp().mainWindow().textViews()["Description"].value());
}

UIALogger.logPass("Description Entered");

UIALogger.logMessage("Details Entry Testing");
target.frontMostApp().navigationBar().rightButton().tap();

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

UIALogger.logStart("Choice Justification Test");

target.frontMostApp().mainWindow().textFields()["Justification"].tap();

var justification = "Justification test 1";

for (i = 0; i < justification.length; i++)
{
    var strChar = justification.charAt(i);
    target.frontMostApp().keyboard().typeString(strChar);
}

target.frontMostApp().keyboard().typeString("\n");

if(target.frontMostApp().mainWindow().textFields()["Justification"].value() == justification) {
       UIALogger.logPass("Justification field entered correctly"); 
} else {
       UIALogger.logFail("Justification field entered incorrectly: " + target.frontMostApp().mainWindow().textFields()["Justification"].value());
}

UIALogger.logStart("Choice Consequence Test");

target.frontMostApp().mainWindow().textFields()["Consequence"].tap();

var consequence = "Consequence test 1";

for (i = 0; i < consequence.length; i++)
{
    var strChar = consequence.charAt(i);
    target.frontMostApp().keyboard().typeString(strChar);
}

target.frontMostApp().keyboard().typeString("\n");

if(target.frontMostApp().mainWindow().textFields()["Consequence"].value() == consequence) {
       UIALogger.logPass("Consequence field entered correctly"); 
} else {
       UIALogger.logFail("Consequence field entered incorrectly: " + target.frontMostApp().mainWindow().textFields()["Consequence"].value());
}

UIALogger.logStart("Influence Test");

var influence = 0.25;
var influenceSliderValue = (influence * 100) + "%";

target.frontMostApp().mainWindow().sliders()["Influence"].dragToValue(influence);

if(target.frontMostApp().mainWindow().sliders()["Influence"].value() == influenceSliderValue) {
       UIALogger.logPass("Influence entered correctly"); 
} else {
       UIALogger.logFail("Influence entered incorrectly: " + target.frontMostApp().mainWindow().sliders()["Influence"].value());
}

target.frontMostApp().mainWindow().buttons()["Done"].tap();

UIALogger.logStart("Details Save Test");

hasError = 0;

target.frontMostApp().navigationBar().rightButton().tap();

if(target.frontMostApp().mainWindow().textFields()["Justification"].value() == justification) {
       UIALogger.logMessage("Justification field saved correctly");
} else {
       UIALogger.logError("Justification field didn't save: " + target.frontMostApp().mainWindow().textFields()["Justification"].value());
		hasError = 1;
}

if(target.frontMostApp().mainWindow().textFields()["Consequence"].value() == consequence) {
	UIALogger.logMessage("Consequence field saved correctly"); 
} else {
	UIALogger.logError("Consequence field didn't save: " + target.frontMostApp().mainWindow().textFields()["Consequence"].value());
	hasError = 1;
}

if(target.frontMostApp().mainWindow().sliders()["Influence"].value() == influenceSliderValue) {
       UIALogger.logMessage("Influence saved correctly"); 
} else {
       UIALogger.logError("Influence didn't save: " + target.frontMostApp().mainWindow().sliders()["Influence"].value());
		hasError = 1;
}

if(hasError){
	UIALogger.logFail("At least one Choice Detail field didn't save.");
} else {
	UIALogger.logPass("All Choice Detail fields saved correctly.");
}

target.frontMostApp().mainWindow().textFields()["Justification"].tap();
target.frontMostApp().keyboard().typeString("\n");

target.frontMostApp().mainWindow().buttons()["Done"].tap();
target.frontMostApp().mainWindow().buttons()["Done"].tap();