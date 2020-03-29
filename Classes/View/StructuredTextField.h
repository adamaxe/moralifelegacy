/**
Maximum Length Textfield Subclass UIView.  Allow for a maximum length to be entered in field.
 
@class StructuredTextField StructuredTextField.h

@author Copyright 2020 Adam Axe. All rights reserved. http://www.adamaxe.com
@date 05/23/2010
@file
*/

extern int const MLChoiceTextFieldLength;

@interface StructuredTextField: UITextField 

@property (nonatomic, assign) int maxLength;	/**< maximum length of field */

@end
