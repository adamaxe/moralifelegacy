/**
 Moralife UI Common include and test data
 
 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 
 @date 05/28/2012
 @file uiajsinclude.js
 */

//Retrieve an instance of UIATarget from app
var target = UIATarget.localTarget();
//Retrieve an instance of application from Target
var app = target.frontMostApp();
//Retrieve handle of applications main window
var window = app.mainWindow(); 
//Retrieve view elements 
var view = window.elements()[0]; 

//UIATarget.localTarget().frontMostApp().logElementTree();

//Generic tap events take a parameter that must contain an X and Y value
//Mock CGPoint function to UIKit
function CGPoint(x, y){
    this.x = x;
    this.y = y;
};


//Test data
var moralName = "Test moral 1";
var moralType = "Aptitude";
var virtueSeverity = 0.35;
var virtueSeveritySliderValue = (virtueSeverity * 100) + "%";
var moralDescription = "Moral test description 1\n\nLine 2";
var moralJustification = "Moral Justification test 1";
var moralConsequence = "Moral Consequence test 1";
var moralInfluence = 0.05;
var moralInfluenceSliderValue = (moralInfluence * 100) + "%";

var moralChoiceCancel = "Moral Choice Cancel 1";
var virtueSeverityCancel = 0.25;
var virtueSeveritySliderValueCancel = (virtueSeverityCancel * 100) + "%";
var moralDescriptionCancel = "Moral test description 1\nCancel\nLine 2";
var moralJustificationCancel = "Moral Justification Cancel 1";
var moralConsequenceCancel = "Moral Consequence Cancel 1";
var moralInfluenceCancel = 0.25;
var moralInfluenceSliderValueCancel = (moralInfluenceCancel * 100) + "%";

var immoralName = "Test immoral 1";
var immoralType = "Aloofness";
var viceSeverity = 0.25;
var viceSeveritySliderValue = (viceSeverity * 100) + "%";
var immoralDescription = "Moral test description 1\n\nLine 2";
var immoralJustification = "Immoral Justification test 1";
var immoralConsequence = "Immoral Consequence test 1";
var immoralInfluence = 0.20;
var immoralInfluenceSliderValue = (immoralInfluence * 100) + "%";

var immoralChoiceCancel = "Immoral Choice Cancel 1";
var viceSeverityCancel = 0.58;
var viceSeveritySliderValueCancel = (viceSeverityCancel * 100) + "%";
var immoralDescriptionCancel = "Immoral test description 1\nCancel\nLine 2";
var immoralJustificationCancel = "Immoral Justification Cancel 1";
var immoralConsequenceCancel = "Immoral Consequence Cancel 1";
var immoralInfluenceCancel = 0.24;
var immoralInfluenceSliderValueCancel = (immoralInfluenceCancel * 100) + "%";
