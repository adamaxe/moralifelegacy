/**
Graph chart for reporting.  The appearance and display of various graph forms for reporting
 
@class GraphView
@see ReportPieViewController

@author Copyright 2020 Adam Axe. All rights reserved. http://www.adamaxe.com
@date 09/05/2010
@file
*/

@interface GraphView : UIView 

@property (nonatomic, strong) NSArray *pieValues;	/**< Array of float pieValues in number of degrees out of 360 */
@property (nonatomic, strong) NSArray *pieColors;	/**< NSArray of UIColors that map to each Value */

@end
