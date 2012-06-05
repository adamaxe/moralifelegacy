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