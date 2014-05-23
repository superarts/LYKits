#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "LYCategory.h"
#import "LYBrowserController.h"

@class LYBrowserController;

///	mini apps including flashlight, fullscreen image, etc.
@interface LYMiniAppsController: UIViewController <MFMailComposeViewControllerDelegate>
{
	id	delegate;
	UINavigationController*	nav;
	UIViewController*		parent;
	UIViewController*		original;
	BOOL					status_bar_hidden;
	IBOutlet UIView*		view_fullscreen;
	IBOutlet UIButton*		button_fullscreen;
	IBOutlet UIImageView*	image_fullscreen;
	LYBrowserController*	browser;
}
@property (nonatomic, retain) id							delegate;
@property (nonatomic, retain) UINavigationController*		nav;
@property (nonatomic, retain) UIViewController*				parent;
@property (nonatomic, retain) UIViewController*				original;
@property (nonatomic, retain) UIImageView*					image_fullscreen;
@property (nonatomic, retain) UIButton*						button_fullscreen;

//- (id)initWithNavigationController:(UINavigationController*)a_nav;
- (void)show_flashlight:(UIColor*)color;
- (void)show_image:(NSString*)filename;
- (void)present_image:(UIImage*)image;
- (void)add_image:(UIImage*)image;
- (void)show_mail_to:(NSArray*)recipients title:(NSString*)title body:(NSString*)body;
- (void)show_browser:(NSString*)url;

- (IBAction)action_dismiss_fullscreen;

@end
