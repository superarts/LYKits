#import "LYMiniAppsController.h"

@implementation LYMiniAppsController

@synthesize nav;
@synthesize parent;
@synthesize original;
@synthesize image_fullscreen;
@synthesize button_fullscreen;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
	{
		browser = [[LYBrowserController alloc] initWithString:@"http://superarts.org"];
		browser.delegate = self;
		nav = nil;
		parent = nil;
		original = nil;
		delegate = nil;
    }
    return self;
}

- (void)dealloc
{
	[browser release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#if 0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#endif

- (void)show_flashlight:(UIColor*)color
{
	status_bar_hidden = [[UIApplication sharedApplication] isStatusBarHidden];

	UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(-100, -100, 2148, 2148)];
	button.backgroundColor = color;
	button.alpha = 0.01;
	//[button addTarget:[LYMiniApps shared] action:@selector(hide_view:) forControlEvents:UIControlEventTouchDown];
	[button addTarget:self action:@selector(hide_view:) forControlEvents:UIControlEventTouchDown];
	[[[[UIApplication sharedApplication] delegate] performSelector:@selector(window)] addSubview:button];
	//	if (status_bar_hidden == NO)
	//		[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

	[UIView begin_animations:0.3];
	button.alpha = 1;
	[UIView commitAnimations];
}

- (void)show_image:(NSString*)filename
{
	[self present_image:[[UIImage alloc] initWithContentsOfFile:[filename filename_bundle]]];
}

- (void)present_image:(UIImage*)image
{
	if ((nav == nil) && (parent == nil))
	{
		NSLog(@"MINIAPPS invalid parent");
		return;
	}

	if (image == nil)
	{
		NSLog(@"MINIAPPS invalid image");
		return;
	}

	self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	if (nav != nil)
		[nav presentModalViewController:self animated:YES];
	else if (parent != nil)
		[parent presentModalViewController:self animated:YES];
	image_fullscreen.image = image;
	[self.view addSubview:view_fullscreen];
	//[image_fullscreen.image release];
	//image_fullscreen.image = image;
	[image retain];
	//[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

#if 0
	UIViewController* controller = [[UIViewController alloc] init];
	UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screen_width(), screen_height())];

	status_bar_hidden = [[UIApplication sharedApplication] isStatusBarHidden];
	if (status_bar_hidden == NO)
		[button reset_height:-20];
	controller.view = button;
	controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	button.backgroundColor = [UIColor clearColor];
	[button autoresizing_add_width:YES height:YES];
	[button set_background_named:filename];
	//[button set_image_named:filename];
	[button addTarget:[LYMiniApps shared] action:@selector(hide_controller:) forControlEvents:UIControlEventTouchDown];
	if (nav == nil)
		[[[[UIApplication sharedApplication] delegate] performSelector:@selector(window)] addSubview:button];
	else
		[nav presentModalViewController:controller animated:YES];
#endif
}

- (void)add_image:(UIImage*)image
{
	if ((nav == nil) && (parent == nil))
	{
		NSLog(@"MINIAPPS invalid parent");
		return;
	}

	if (image == nil)
	{
		NSLog(@"MINIAPPS invalid image");
		return;
	}

	UIView* view_parent = nil;
	if (nav != nil)
		view_parent = nav.view;
	else if (parent != nil)
		view_parent = parent.view;

	button_fullscreen = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screen_width(), screen_height())];

	UIImageView* image_view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen_width(), screen_height())];
	image_view.contentMode = UIViewContentModeScaleAspectFit;
	image_view.image = image;
	[button_fullscreen addSubview:image_view];
	[image_view release];

	[button_fullscreen addTarget:self action:@selector(remove_view) forControlEvents:UIControlEventTouchDown];
	//[button_fullscreen setImage:image forState:UIControlStateNormal];
	//button_fullscreen.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button_fullscreen.backgroundColor = [UIColor blackColor];
	[view_parent addSubview:button_fullscreen];
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
#if 0
	self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	if (nav != nil)
		[nav presentModalViewController:self animated:YES];
	else if (parent != nil)
		[parent presentModalViewController:self animated:YES];
	image_fullscreen.image = image;
	[self.view addSubview:view_fullscreen];
	//[image_fullscreen.image release];
	//image_fullscreen.image = image;
	[image retain];

	UIViewController* controller = [[UIViewController alloc] init];
	UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screen_width(), screen_height())];

	status_bar_hidden = [[UIApplication sharedApplication] isStatusBarHidden];
	if (status_bar_hidden == NO)
		[button reset_height:-20];
	controller.view = button;
	controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	button.backgroundColor = [UIColor clearColor];
	[button autoresizing_add_width:YES height:YES];
	[button set_background_named:filename];
	//[button set_image_named:filename];
	[button addTarget:[LYMiniApps shared] action:@selector(hide_controller:) forControlEvents:UIControlEventTouchDown];
	if (nav == nil)
		[[[[UIApplication sharedApplication] delegate] performSelector:@selector(window)] addSubview:button];
	else
		[nav presentModalViewController:controller animated:YES];
#endif
}

- (void)remove_view
{
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
	[button_fullscreen removeFromSuperview];
	[button_fullscreen release];
	if (delegate != nil)
		[delegate perform_string:@"miniapps_fullscreen_exit"];
}

- (void)hide_view:(UIView*)view
{
	if (status_bar_hidden == NO)
		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

	[UIView begin_animations:0.3];
	view.alpha = 0.01;
	[UIView commitAnimations];

	[self performSelector:@selector(remove_release:) withObject:view afterDelay:0.3];
}

- (void)hide_controller:(UIView*)view
{
	//	if (status_bar_hidden == NO)
	//		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

	if (nav != nil)
		[nav dismissModalViewControllerAnimated:YES];
	else if (parent != nil)
		[parent dismissModalViewControllerAnimated:YES];
	[[view view_controller] release];
	[view release];
}

- (void)remove_release:(UIView*)view
{
	[view removeFromSuperview];
	[view release];
}

- (IBAction)action_dismiss_fullscreen
{
	NSLog(@"app dismiss");
	[image_fullscreen.image release];
	if (nav != nil)
		[nav dismissModalViewControllerAnimated:YES];
	else if (parent != nil)
	{
		[parent dismissModalViewControllerAnimated:YES];
#if 0
		if (original != nil)
		{
			[parent presentModalViewController:original animated:NO];
		}
#endif
	}
	//[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

#pragma mark browser

- (void)show_browser:(NSString*)url
{
	[browser set_url:url];
	if (is_phone())
	{
		browser.view.frame = CGRectMake(0, 20, screen_width(), screen_height() - 20);
		[browser.view set_y:screen_height()];
		[browser.view set_y:20 animation:0.3];
		if (nav != nil)
			[nav.view addSubview:browser.view];
		else if (parent != nil)
			[parent.view addSubview:browser.view];
	}
	else
	{
		browser.modalPresentationStyle = UIModalPresentationFormSheet;
		browser.modalPresentationStyle = UIModalPresentationPageSheet;
		if (nav != nil)
			[nav presentModalViewController:browser animated:YES];
		else if (parent != nil)
			[parent presentModalViewController:browser animated:YES];
	}
}

- (void)browser_dismiss:(id)sender
{
	if (is_phone())
	{
		[browser.view set_y:screen_height() animation:0.3];
		[self performSelector:@selector(browser_remove) withObject:nil afterDelay:0.3];
	}
	else
	{
		if (nav != nil)
			[nav dismissModalViewControllerAnimated:YES];
		else if (parent != nil)
			[parent dismissModalViewControllerAnimated:YES];
	}
}

- (void)browser_remove
{
	[browser.view removeFromSuperview];
}

#pragma mark mail

- (void)show_mail_to:(NSArray*)recipients title:(NSString*)title body:(NSString*)body
{
	MFMailComposeViewController* controller_mail = [[MFMailComposeViewController alloc] init];
	controller_mail.mailComposeDelegate = self;
	[controller_mail setToRecipients:recipients];
	[controller_mail setSubject:title];
	[controller_mail setMessageBody:body isHTML:NO];
	if (nav != nil)
		[nav presentModalViewController:controller_mail animated:YES];
	else if (parent != nil)
		[parent presentModalViewController:controller_mail animated:YES];
}

#if 1
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	//	NSLog(@"mail result: %@", error);
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
			[@"Mail Error" show_alert_message:@"Please check your mail and internet settings, and try again later."];
			break;
		default:
			break;
	}
	if (nav != nil)
		[nav dismissModalViewControllerAnimated:YES];
	else if (parent != nil)
		[parent dismissModalViewControllerAnimated:YES];

	[controller release];
}
#endif

#if 0
- (void)messageComposeViewController:(MFMessageComposeViewController*)controller didFinishWithResult:(MessageComposeResult)result
{
	[nav dismissModalViewControllerAnimated:YES];
	[controller release];
}
#endif

@end
