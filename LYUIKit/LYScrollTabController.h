#import <UIKit/UIKit.h>
#import "LYKits.h"

/*
 * 'Scroll tab' is a 'scroll bar' that contains series of buttons.
 */

@protocol LYScrollTabControllerDelegate;

@interface LYScrollTabController: UIViewController
{
	id <LYScrollTabControllerDelegate>	delegate;
	UIScrollView*						scroll_view;
	NSMutableArray*						buttons;
	NSInteger							count;
}
@property(nonatomic,retain)	UIScrollView*	scroll_view;
@property(nonatomic,retain)	NSMutableArray*	buttons;
@property(nonatomic,retain)	id				delegate;

//	interface
- (id)initWithFrame:(CGRect)frame delegate:(id)a_delegate;
- (void)reload_data;

//	internal
- (void)action_button_pressed:(id)sender;
- (void)reload_buttons;

@end

@protocol LYScrollTabControllerDelegate

//	data source; *IMPORTANT* release must be handled for "alloc_xxx" messages manually
- (NSInteger)scroll_tab_count:(LYScrollTabController*)controller_tab;
- (CGSize)scroll_tab_size:(LYScrollTabController*)controller_tab;
- (UIButton*)scroll_tab:(LYScrollTabController*)controller_tab alloc_button_for_index:(NSInteger)index;

//	event handler
- (void)scroll_tab:(LYScrollTabController*)controller_tab did_select_index:(NSInteger)index;

@end


/*
 * LYScrollTabBarController - based on LYScrollTabController, with similar interface as UITabBarController
 */

@interface LYScrollTabBarController: UIViewController <LYScrollTabControllerDelegate>
{
	LYScrollTabController*	scroll_tab;
	NSMutableArray*			data;
	NSUInteger				index;
	CGFloat					height;
}
@property(nonatomic, retain)	LYScrollTabController*	scroll_tab;
@property(nonatomic, retain)	NSMutableArray*			data;
@property(nonatomic)			NSUInteger				index;
@property(nonatomic)			CGFloat					height;

- (void)reload;

@end
