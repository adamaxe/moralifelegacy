/**
Moralife UI Choice Moral Entry
 
@author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org

@date 05/28/2012
@file choiceentrymoral.js
*/

var target = UIATarget.localTarget();

UIALogger.logStart("MoraLife Choice Moral Testing Begins");

target.frontMostApp().tabBar().buttons()["Journal"].tap();
target.frontMostApp().mainWindow().buttons()[0].tap();
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

target.frontMostApp().mainWindow().buttons()["Select a Virtue"].tap();
target.frontMostApp().mainWindow().searchBars()[0].tap();
var moralType = "Aptitude\n";

for (i = 0; i < moralType.length; i++)
{
    var strChar = moralType.charAt(i);
    target.frontMostApp().keyboard().typeString(strChar);
}

target.frontMostApp().mainWindow().tableViews()["Empty list"].cells()["Aptitude, Ability, Excellence, Potential, Precision, Industriousness, Savvy, Talent"].tap();
target.frontMostApp().mainWindow().sliders()["Virtue Severity."].dragToValue(0.5);
//target.frontMostApp().mainWindow().textViews()["Description"].tapWithOptions({tapOffset:{x:0.36, y:0.71}});
target.frontMostApp().mainWindow().textViews()["Description"].tap();

var moralDescription = "Moral test description 1\n\nLine 2";

for (i = 0; i < moralDescription.length; i++)
{
    var strChar = moralDescription.charAt(i);
    target.frontMostApp().keyboard().typeString(strChar);
}

target.frontMostApp().mainWindow().buttons()[3].tap();
target.frontMostApp().navigationBar().rightButton().tap();
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

target.frontMostApp().mainWindow().sliders()[0].dragToValue(0.25);
target.frontMostApp().mainWindow().buttons()["Done"].tap();
target.frontMostApp().mainWindow().buttons()["Done"].tap();

UIALogger.logPass("Choice Form navigation Pass."); 
