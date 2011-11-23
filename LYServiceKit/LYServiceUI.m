#import "LYServiceUI.h"

#ifdef LY_ENABLE_SDK_AWS
@implementation LYSuarViewController

@synthesize delegate;
@synthesize tab;
@synthesize nav_profile;
@synthesize nav_wall;
@synthesize nav_public;

- (id)init
{
	self = [super init];
	if (self)
	{
		[self loadView];
		sdb_wall	= [[LYServiceAWSSimpleDB alloc] init];
		sdb_public	= [[LYServiceAWSSimpleDB alloc] init];
		provider_wall = nil;
		provider_public = nil;
	}
	return self;
}

- (void)dealloc
{
	[sdb_wall release];
	[sdb_public release];
	[super dealloc];
}

- (IBAction)load_wall
{
	NSString* query = [NSString stringWithFormat:
		@"select * from `posts` where `author-mail` = '%@' and `date-create` > '20110101-00:00:00' order by `date-create` desc",
		[@"ly-suar-profile-mail" setting_string]];
	[self reload_provider:&provider_wall table:table_wall query:query sdb:sdb_wall];
}

- (IBAction)load_public
{
	NSString* query = @"select * from `posts` where `date-create` > '20110101-00:00:00' order by `date-create` desc";
	[self reload_provider:&provider_public table:table_public query:query sdb:sdb_public];
}

- (void)reload_provider:(LYTableViewProvider**)a_provider table:(UITableView*)table query:(NSString*)query sdb:(LYServiceAWSSimpleDB*)sdb
{
	LYTableViewProvider* provider = *a_provider;
	if (provider == nil)
	{
		provider = [[LYTableViewProvider alloc] initWithTableView:table];
		provider.texts = [[NSMutableArray alloc] initWithObjects:[NSMutableArray array], nil];
		provider.details = [[NSMutableArray alloc] initWithObjects:[NSMutableArray array], nil];
		provider.image_urls = [[NSMutableArray alloc] initWithObjects:[NSMutableArray array], nil];
		provider.delegate = self;
		provider.cell_height = 64;

		UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10, 38, 20, 20)];
		activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
		[activity startAnimating];
		[provider.data key:@"refresh-view" v:activity];
		//[provider apply_theme_color:[UIColor blackColor] on:[UIColor whiteColor]];
	}

	[provider.data key:@"state" v:@"refresh"];
	[table reloadData];
	[sdb select:query block:^(id obj, NSError* error)
	{
		NSArray* array = (NSArray*)obj;
		//	NSLog(@"query error: %@", error);
		//	NSLog(@"query result: %@", array);
		[provider.data key:@"state" v:@""];
		[[provider.texts i:0] removeAllObjects];
		for (NSDictionary* dict_item in array)
		{
			NSDictionary* dict = [dict_item v:@"attr-dict"];
			NSString* s;

			s = [dict v:@"text-title"];
			if ([s is:@""])
			{
				s = [dict v:@"author-app"];
				if ([s is:@"org.superarts.PhotoShare"])
					s = @"Via Photo Share";
				else if ([s is:@"org.superarts.PhotoShare"])
					s = @"Via Photo Share";
				else
					s = @"Untitled";
			}
			[[provider.texts i:0] addObject:s];

			s = [dict v:@"text-body"];
			if ([s is:@""])
			{
				s = [dict v:@"date-create"];
				s = [s local_medium_date_from:@"yyyyMMdd-HH:mm:ss"];
				if ((s == nil) || ([s is:@""]))
					s = @"No description.";
			}
			[[provider.details i:0] addObject:s];

			s = [dict v:@"photo-main"];
			if ([s is:@""])
				s = @"";
			else
			{
				if (![[s substringToIndex:4] is:@"raw/"])
					s = [@"raw/" stringByAppendingString:s];
				s = [@"http://s3.amazonaws.com/us-general/" stringByAppendingString:s];
			}
			[[provider.image_urls i:0] addObject:s];
		}
		[table reloadData];
		*a_provider = provider;
		//	NSLog(@"titles %@", provider.texts);
	}];
}

- (void)load
{
	[[provider_wall.texts i:0] addObject:@"No Post"];
	[table_wall reloadData];
	[[provider_public.texts i:0] addObject:@"No Post"];
	[table_public reloadData];

	if ([@"ly-suar-profile-pin" setting_string] == nil)
	{
		segment_profile_type.selectedSegmentIndex = 1;
		[self action_profile_type];
		[field_profile_name becomeFirstResponder];
	}
	else
	{
		field_profile_name.text = [@"ly-suar-profile-name" setting_string];
		field_profile_mail.text = [@"ly-suar-profile-mail" setting_string];
		field_profile_pin1.text = [@"ly-suar-profile-pin" setting_string];
		field_profile_pin2.text = [@"ly-suar-profile-pin" setting_string];
	}
}

#pragma mark action

- (IBAction)action_delegate_dismiss
{
	[delegate perform_string:@"suar_dismiss"];
}

- (IBAction)action_profile_type
{
	switch (segment_profile_type.selectedSegmentIndex)
	{
		case 0:
			field_profile_name.hidden = YES;
			field_profile_pin2.hidden = YES;
			break;
		case 1:
			field_profile_name.hidden = NO;
			field_profile_pin2.hidden = NO;
			break;
	}
}

- (IBAction)action_profile_done
{
	if (segment_profile_type.selectedSegmentIndex == 0)
	{
		//	login
		[LYLoading enable_label:@"Logging in..."];
		[[LYLoading shared] setNav:nil];
		[LYLoading show];
		NSString* query = [NSString stringWithFormat:@"select * from `users` where itemName() = '%@'",
			field_profile_mail.text];
		//	NSLog(@"query: %@", query);
		[sdb_wall select:query block:^(id obj, NSError* error)
		{
			NSArray* array = (NSArray*)obj;
			//	NSLog(@"login: %@", array);
			[LYLoading performSelector:@selector(hide) withObject:nil afterDelay:0.5];
			if (error != nil)
			{
				[@"Login Failed" show_alert_message:error.localizedDescription];
				return;
			}
			if (array.count == 0)
			{
				[@"Login Failed" show_alert_message:@"Username not found. Please try again or choose \"Register\" to create a new profile."];
				return;
			}
			if (![[[[array i:0] v:@"attr-dict"] v:@"pin"] is:field_profile_pin1.text])
				[@"Login Failed" show_alert_message:@"Your username/password combination is not correct. Please try again or choose \"Register\" to create a new profile."];
			else
			{
				[@"ly-suar-profile-name" setting_string:[[[array i:0] v:@"attr-dict"] v:@"name-display"]];
				[@"ly-suar-profile-mail" setting_string:field_profile_mail.text];
				[@"ly-suar-profile-pin" setting_string:field_profile_pin1.text];
				field_profile_name.text = [@"ly-suar-profile-name" setting_string];
				field_profile_pin2.text = [@"ly-suar-profile-pin" setting_string];
				//[nav dismissModalViewControllerAnimated:YES];
				[self action_delegate_dismiss];
			}
		}];
	}
	else
	{
		//	register
		if (field_profile_name.text.length < 3)
		{
			[@"Name Too Short" show_alert_message:@"The name you entered is too short. Please choose a valid name."];
			[field_profile_name becomeFirstResponder];
			return;
		}
		if ([field_profile_mail.text is_email] == NO)
		{
			[@"Invalid E-mail Address" show_alert_message:@"Please enter a valid e-mail address."];
			[field_profile_mail becomeFirstResponder];
			return;
		}
		if ([field_profile_pin1.text is:field_profile_pin2.text] == NO)
		{
			[@"Passwords Mismatch" show_alert_message:@"Please make sure the two passwords you've entered are identical."];
			[field_profile_pin1 becomeFirstResponder];
			return;
		}
		if (field_profile_pin1.text.length < 5)
		{
			[@"Password Too Short" show_alert_message:@"The password must have at least 5 characters. Please try again."];
			[field_profile_pin1 becomeFirstResponder];
			return;
		}
		[LYLoading enable_label:@"Checking username..."];
		[[LYLoading shared] setNav:nil];
		[LYLoading show];
		
		NSString* query = [NSString stringWithFormat:@"select * from `users` where itemName() = '%@' and pin is not null",
			field_profile_mail.text];
		//	NSLog(@"query: %@", query);
		[sdb_wall select:query block:^(id obj, NSError* error)
		{
			NSArray* array = (NSArray*)obj;
			if (array.count > 0)
			{
				[@"Email already registered" show_alert_message:@"This email address has already been registered. Please choose another email as username and try again."];
				[LYLoading performSelector:@selector(hide) withObject:nil afterDelay:0.5];
			}
			else
			{
				[sdb_wall put:@"users" name:field_profile_mail.text];
				[sdb_wall key:@"name-display" unique:field_profile_name.text];
				[sdb_wall key:@"pin" unique:field_profile_pin1.text];
				[sdb_wall key:@"app" value:@"org.superarts.SPS"];
				[sdb_wall put_block:^(id obj, NSError* error)
				{
					NSLog(@"register: %@, %@", obj, error);
					if (error == nil)
					{
						[@"ly-suar-profile-name" setting_string:field_profile_name.text];
						[@"ly-suar-profile-mail" setting_string:field_profile_mail.text];
						[@"ly-suar-profile-pin" setting_string:field_profile_pin1.text];
						//[nav dismissModalViewControllerAnimated:YES];
						[self action_delegate_dismiss];
					}
					else
					{
						[@"Registration Failed" show_alert_message:[NSString stringWithFormat:@"Error: %@", error.localizedDescription]];
					}
					NSLog(@"xxx");
					[LYLoading performSelector:@selector(hide) withObject:nil afterDelay:0.5];
				}];
			}
		}];
	}
}

#pragma mark delegate

- (BOOL)textFieldShouldReturn:(UITextField *)field
{
	if (field == field_profile_name)
		[field_profile_mail becomeFirstResponder];
	else if (field == field_profile_mail)
		[field_profile_pin1 becomeFirstResponder];
	else if (field == field_profile_pin1)
	{
		if (segment_profile_type.selectedSegmentIndex == 0)
			[field_profile_pin1 resignFirstResponder];
		else
			[field_profile_pin2 becomeFirstResponder];
	}
	else if (field == field_profile_pin2)
		[field_profile_pin2 resignFirstResponder];

	return YES;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)controller
{
	//	NSLog(@"should select index: %i", tab.selectedIndex);
	if (controller == nav_wall)
		if ([@"ly-suar-profile-pin" setting_string] == nil)
			return NO;
	if (controller == nav_public)
		if ([@"ly-suar-profile-pin" setting_string] == nil)
			return NO;
	return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	//	NSLog(@"index: %i", tab.selectedIndex);
	if (tab.selectedIndex == 1)
	{
		if (provider_wall == nil)
			[self load_wall];
	}
	else if (tab.selectedIndex == 2)
	{
		if (provider_public == nil)
			[self load_public];
	}
}

@end
#endif


#if 0
@implementation LYServiceUI

@synthesize label_login_note;
@synthesize item_login_cancel;
@synthesize data;

- (id)init
{
	self = [super initWithNibName:nil bundle:nil];
	if (self != nil)
	{
		data = [[NSMutableDictionary alloc] init];
		[data key:@"db" v:[[LYDatabase alloc] init]];
		[data key:@"nav" v:nil];
		[data key:@"user" v:[@"ly-service-login-user" setting_object]];
		[self loadView];
	}
	return self;
}

- (void)dealloc
{
	[data release];
	[super dealloc];
}

#pragma mark service extension

- (NSString*)insert_post_image:(NSString*)key
{
	return [self insert_post_title:key
						   content:@""
							   pid:[(NSMutableDictionary*)[[data v:@"db"] data] v:@"app"]
							   url:[[data v:@"db"] url_blob_serve:key]];
}

- (NSString*)insert_post_title:(NSString*)title 
					   content:(NSString*)content
						   pid:(NSString*)pid
						   url:(NSString*)parent_url
					//	 block:(LYBlockVoidStringError)callback
{
	NSString* ret = [LYRandom unique_string];
	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
		ret,
		@"post-id",
		pid,
		@"parent-id",
		[@"ly-service-login-name" setting_string],
		@"author-name",
		[@"ly-service-login-mail" setting_string],
		@"author-email",
		title,
		@"title",
		parent_url,
		@"parent-url",
		[(NSMutableDictionary*)[[data v:@"db"] data] v:@"category"],
		@"category",
		[(NSMutableDictionary*)[[data v:@"db"] data] v:@"app"],
		@"app",
		content,
		@"content",
		nil];
		NSLog(@"post data: %@", dict);
	//	[nav dismissModalViewControllerAnimated:YES];
	//	NSLog(@"current dict: %@", current_dict);
	//	return;
	[[data v:@"db"] sdb_wall:@"post" insert_unique:dict block:^(NSString* str, NSError* error)
	{
		NSLog(@"SUI post insert: %@ - %@", error, str);
#if 0
		callback(str, error);
		if ((error == nil) && (str != nil))
			[@"Reply Successful" show_alert_message:@""];
		else
			[@"Reply Failed" show_alert_message:[NSString stringWithFormat:@"Error: %@", error.localizedDescription]];
#endif
	}];
	return ret;
}

- (void)login_disable_cancel
{
	NSMutableArray *array = [NSMutableArray arrayWithArray:toolbar_login_main.items];
	[array removeObjectAtIndex:0];
	[toolbar_login_main setItems:array animated:NO];
}

- (UIViewController*)controller_login
{
	//	NSLog(@"login %@", controller_login);
	segment_login_type.selectedSegmentIndex = 0;
	field_login_name.text = [@"ly-service-login-name" setting_string];
	field_login_mail.text = [@"ly-service-login-mail" setting_string];
	field_login_pin1.text = [@"ly-service-login-pin" setting_string];
	field_login_pin2.text = [@"ly-service-login-pin" setting_string];
	return controller_login;
}

- (IBAction)action_login_type
{
	switch (segment_login_type.selectedSegmentIndex)
	{
		case 0:
			field_login_name.hidden = YES;
			field_login_pin2.hidden = YES;
			break;
		case 1:
			field_login_name.hidden = NO;
			field_login_pin2.hidden = NO;
			break;
	}
}

- (IBAction)action_login_done
{
	if (segment_login_type.selectedSegmentIndex == 0)
	{
		//	login
		[LYLoading show_label:@"Logging in..."];
		[[data v:@"db"] sdb_wall:@"user" verify:[NSDictionary dictionaryWithObjectsAndKeys:
			field_login_mail.text,
			@"email",
			field_login_pin1.text,
			@"pin",
			nil] block:^(NSDictionary* dict, NSError* error)
		{
			NSLog(@"error: %@ - %@", error, dict);
			if ((error == nil) && (dict.count > 0))
			{
				[@"ly-service-login-name" setting_string:[dict v:@"name-display"]];
				[@"ly-service-login-mail" setting_string:field_login_mail.text];
				[@"ly-service-login-pin" setting_string:field_login_pin1.text];
				field_login_name.text = [@"ly-service-login-name" setting_string];
				field_login_pin2.text = [@"ly-service-login-pin" setting_string];
				[[data v:@"nav"] dismissModalViewControllerAnimated:YES];
				[data key:@"user" v:dict];
				[@"ly-service-login-user" setting_object:dict];
			}
			else
			{
				[@"Login Failed" show_alert_message:@"Your username/password combination is not correct. Please try again or choose \"Register\" to create a new account."];
			}
			[LYLoading performSelector:@selector(hide) withObject:nil afterDelay:0.5];
		}];
	}
	else
	{
		//	register
		if (field_login_name.text.length < 3)
		{
			[@"Name Too Short" show_alert_message:@"The name you entered is too short. Please choose a valid name."];
			[field_login_name becomeFirstResponder];
			return;
		}
		if ([field_login_mail.text is_email] == NO)
		{
			[@"Invalid E-mail Address" show_alert_message:@"Please enter a valid e-mail address."];
			[field_login_mail becomeFirstResponder];
			return;
		}
		if ([field_login_pin1.text is:field_login_pin2.text] == NO)
		{
			[@"Passwords Mismatch" show_alert_message:@"Please make sure the two passwords you've entered are identical."];
			[field_login_pin1 becomeFirstResponder];
			return;
		}
		if (field_login_pin1.text.length < 5)
		{
			[@"Password Too Short" show_alert_message:@"The password must have at least 5 characters. Please try again."];
			[field_login_pin1 becomeFirstResponder];
			return;
		}
		[LYLoading show_label:@"Checking username..."];
		[[data v:@"db"] insert_user:[NSDictionary dictionaryWithObjectsAndKeys:
			field_login_mail.text,
			@"email",
			field_login_name.text,
			@"name-display",
			field_login_pin1.text,
			@"pin",
			[NSMutableArray arrayWithObjects:
				@"org.superarts.LSM",
				@"org.superarts.LSM-Free",
				nil],
			@"apps",
			[NSMutableArray array],
			@"friends",
			nil] block:^(NSArray* array, NSError* error)
			{
				NSLog(@"result user insert: %@ - %@", error, array);
				if (error == nil)
				{
					[@"ly-service-login-name" setting_string:field_login_name.text];
					[@"ly-service-login-mail" setting_string:field_login_mail.text];
					[@"ly-service-login-pin" setting_string:field_login_pin1.text];
					[[data v:@"nav"] dismissModalViewControllerAnimated:YES];

					//[[data v:@"db"] name:@"db100_model" key:[array objectAtIndex:0] block:^(NSArray* array, NSError* error)
					[[data v:@"db"] sdb_wall:@"user" key:[array objectAtIndex:0] block:^(NSDictionary* dict, NSError* error)
					{
						//	NSLog(@"xxx %@, %@", dict, error);
						[data key:@"user" v:dict];
						[@"ly-service-login-user" setting_object:dict];
					}];
				}
				else
				{
					[@"Registration Failed" show_alert_message:[NSString stringWithFormat:@"Error: %@", error.localizedDescription]];
				}
				//[LYLoading hide];
				[LYLoading performSelector:@selector(hide) withObject:nil afterDelay:0.5];
			}];
	}
}

- (IBAction)action_login_cancel
{
	[[data v:@"nav"] dismissModalViewControllerAnimated:YES];
}

#pragma mark delegate

- (BOOL)textFieldShouldReturn:(UITextField *)field
{
	if (field == field_login_name)
		[field_login_mail becomeFirstResponder];
	else if (field == field_login_mail)
		[field_login_pin1 becomeFirstResponder];
	else if (field == field_login_pin1)
	{
		if (segment_login_type.selectedSegmentIndex == 0)
			[field_login_pin1 resignFirstResponder];
		else
			[field_login_pin2 becomeFirstResponder];
	}
	else if (field == field_login_pin2)
		[field_login_pin2 resignFirstResponder];

	return YES;
}

@end
#endif
