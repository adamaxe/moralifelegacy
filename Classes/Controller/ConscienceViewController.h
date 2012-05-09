/**
MoraLife Home Screen.  Landing UIViewController for application.
Primary screen for entire Application Workflow.  Provides high-level feedback for User review.

@class ConscienceViewController
@see ConscienceModalViewController

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 06/23/2010
@file
*/

@interface ConscienceViewController : UIViewController

/**
Present a thought bubble to the User, suggesting that the UserConscience is talking
 */
-(void) showThought;
/**
Hide the thought bubble.
 */
-(void) hideThought;
/**
Present the ConscienceModalViewController for Conscience interaction
 */
-(void) showConscienceModal;
/**
On first launch, play an introduction
 */
-(void) showIntroView;
/**
Accepts User input in order to determine which thought Bubble to dislay or ConscienceModalViewController
@param sender id which requested the function
 */
-(IBAction) selectNextView:(id) sender;
-(void) refreshConscience;
/**
Cancel all of shooken UserConscience behavior
 */
-(void) shakeEnd;
/**
Create welcome message thought bubble for UserConscience
 */
-(void) createWelcomeMessage;
/**
Calculate through all UserChoices which most prominent/troublesome virtue/vice is
@param isVirtue bool representing whether virtue or vice was requested
 */
-(void) retrieveBiggestChoice:(BOOL) isVirtue;
/**
Find highest rank
 */
-(void) retrieveHighestRank;
/**
User choices affect UserConscience immediately, must return Conscience to regular state
@param originalMood float representing overall Conscience mood
@param originalEnthusiasm float representing overall Conscience enthusiasm
 */
-(void) resetMood:(float) originalMood andEnthusiasm:(float) originalEnthusiasm;

-(void) createMovementReaction;
-(void) endMovementReaction;
-(void) setupModalWorkflow;

@end