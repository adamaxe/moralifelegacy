/**
Reference information screen.  View that is presented when User requests a reference.

Final screen in Reference View Workflow.  Lists all relevant information about ReferenceAsset, Moral or ConscienceAsset.
 
@class ReferenceDetailViewController
@see ReferenceViewController

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 06/06/2010
@file
@todo rename to ReferenceViewController
 */

#import "CoreData/CoreData.h"

@class MoraLifeAppDelegate;

@interface ReferenceDetailViewController : UIViewController <UIActionSheetDelegate> {

	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
	NSManagedObjectContext *context;		/**< Core Data context */
	
	IBOutlet UIButton *wwwLinkButton;			/**< button to allow Safari access to more info */
	IBOutlet UIButton *quoteButton;			/**< button to push Quote modal window */
	
	IBOutlet UIImageView *referencePictureView;		/**< card surrounding reference image */
	IBOutlet UIImageView *referenceSmallPictureView;	/**< card surrounding reference image */
	IBOutlet UIImageView *moralPictureView;             	/**< moral image referencing asset's moral value*/
	IBOutlet UIImageView *cardView;             	/**< moral image referencing asset's moral value*/
	IBOutlet UILabel *referenceNameLabel;			/**< reference name */
	IBOutlet UILabel *referenceDateLabel;			/**< reference date of birth/construction/publishment */
	IBOutlet UILabel *referenceOriginLabel;			/**< reference's place of creation/birth/construction */
	IBOutlet UILabel *referenceShortDescriptionLabel;	/**< text to appear under reference name */
	IBOutlet UILabel *cardNumberLabel;                  	/**< text to appear over card */
	IBOutlet UITextView *referenceLongDescriptionTextView;	 /**< detailed reference text */

	int referenceType;			/**< which type of reference is being presented */
	bool hasQuote;				/**< does reference have a quote */
	bool hasLink;				/**< does reference have an external link */
	
	NSString *referenceName;			/**< display name of Reference */
	NSString *referenceKey;				/**< reference pkey */
	NSMutableString *referenceDate;		/**< reference origin date */
	NSMutableString *referenceDeathDate;	/**< reference death date */
	NSString *referencePicture;			/**< picture of reference */
	NSString *referenceReferenceURL;		/**< URL of external reference text */
	NSString *referenceShortDescription;	/**< description of reference */
	NSString *referenceLongDescription;		/**< detailed account of reference */
	NSString *referenceOrigin;			/**< place of reference origin */

	NSString *referenceOrientation;
	NSString *referenceMoral; 			/**< moral assigned to reference */
	NSString *referenceQuote;			/**< quote by or referencing reference */
    
}

/**
Accepts User input to ask for a Quote from reference.
 */
-(IBAction)showReferenceData:(id)sender;

/**
Accepts User input to launch Safari and browse reference's online reference.
 */
-(IBAction)showExternalURL:(id)sender;

/**
Accepts User input to cancel the detail screen.
@todo rename as ReferenceDetail is not modal
 */
-(IBAction)dismissReferenceModal:(id)sender;

/**
Create a date view for a reference
 */
-(void)createDateView;

/**
Take data from UserData and populate fields and UI
 */
-(void)populateReferenceScreen;

/**
Retrieve userCollection to determine what value the assets have
 */
-(void)retrieveCollection;

/**
Retrieve reference from SystemData
 */
-(void)retrieveReference;

@end