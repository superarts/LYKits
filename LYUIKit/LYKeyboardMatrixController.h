#import "LYPublic.h"

///	customized keyboard that supports dovrak layout, etc.
/**
 * example
 *
\code
	UILabel* label_keyboard = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 320, 100)];
	label_keyboard.text = @"";
	[window addSubview:label_keyboard];

	UITextView* text_keyboard = [[UITextView alloc] initWithFrame:CGRectMake(0, 220, 320, 100)];
	text_keyboard.text = @"";
	[window addSubview:text_keyboard];

	LYKeyboardMatrixController*	keyboard = [[LYKeyboardMatrixController alloc] initWithDelegate:self];
	keyboard.target = text_keyboard;

- (id)main_view
{
	return nav_main.view;
}
\endcode
 */

@class LYButtonMatrixController;

@interface LYKeyboardMatrixController: NSObject
{
	UIViewController*			controller_ime;
	UIViewController*			controller_left;
	UIViewController*			controller_right;

	LYButtonMatrixController*	matrix_left;
	LYButtonMatrixController*	matrix_right;
	UIView*						view_background_left;
	UIView*						view_background_right;

	id			delegate;
	CGFloat		matrix_width;
	CGFloat		matrix_height;
	CGFloat		matrix_resize;
	NSString*	current_keyboard_layout;
	NSString*	current_keyboard_status;
	BOOL		hidden;
	BOOL		ime_is_moving;
	CGPoint		current_ime_offset;

	NSString*	string;			//	should have "main_view" property
	id			target;			//	text view, etc.
	NSString*	setter;			//	setText:, etc.
	NSString*	getter;			//	text, etc.
	UIButton*	button_ime;

	NSMutableDictionary*	data;
}
@property (nonatomic, retain) NSString*			string;
@property (nonatomic, retain) id				target;
@property (nonatomic, retain) NSString*			setter;
@property (nonatomic, retain) NSString*			getter;
@property (nonatomic, retain) UIButton*			button_ime;
@property (nonatomic, retain) NSString*			current_keyboard_layout;
@property (nonatomic, retain) NSString*			current_keyboard_status;
@property (nonatomic, retain) NSMutableDictionary*	data;
@property (nonatomic, retain) UIViewController*		controller_left;
@property (nonatomic, retain) UIViewController*		controller_right;

- (id)initWithDelegate:(id)obj;
- (void)apply_keyboard_layout;
- (void)show;
- (void)hide;
- (void)resize_keyboard;
- (void)apply_ime_edit;
- (void)apply_ime_na;
- (void)display_help;
- (void)action_ime;
- (void)save_ime_settings;
- (CGFloat)get_screen_height;

- (void)set_button_toggle:(UIButton*)button;

- (void)apply_layout_emoji_001;

@end
