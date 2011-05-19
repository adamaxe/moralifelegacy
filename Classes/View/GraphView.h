/**
Graph chart for reporting.  The appearance and display of various graph forms for reporting
 
@class GraphView
@see ReportPieViewController

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 09/05/2010
@file
*/

@interface GraphView : UIView {
    	
}

@property (nonatomic, retain) NSArray *pieValues;	/**< Array of float pieValues in number of degrees out of 360 */
@property (nonatomic, retain) NSArray *pieColors;	/**< NSArray of UIColors that map to each Value */

@end
