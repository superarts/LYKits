#import "LYAsyncImageView.h"

@implementation LYAsyncImageView

@synthesize delegate;
@synthesize mode;
@synthesize scale;
@synthesize placeholder;

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		self.contentMode = UIViewContentModeScaleAspectFill;
		self.clipsToBounds = YES;
		filename_original = nil;
		filename = nil;
		is_downloading = NO;
		data = nil;
		connection = nil;
		delegate = nil;
		mode = UIViewContentModeScaleAspectFill;
		scale = 2.0;
		placeholder = @"";
	}

	return [super init];
}

- (void)load_url:(NSString*)s
{
	NSURLRequest*	request;
	if (is_downloading == YES)
		return;

	//	NSLog(@"ASYNC 1 %@", self);

	if (scale == 0.0f)
		scale = 2.0;
	progress = 0;
#if 0
	filename = [[NSString alloc] initWithFormat:@"%ix%i-%@",
			 (int)self.frame.size.width, (int)self.frame.size.height, [s url_to_filename]];
#else
	filename = [[NSString alloc] initWithString:[s url_to_filename]];
#endif
	//	[self.image release], self.image = nil;

	//	NSLog(@"checking filename: %@", [@"" filename_document]);
	if ([filename file_exists] == YES)
	{
		//	NSLog(@"loading from cache: %@", [filename filename_document]);
		self.image = [UIImage imageWithContentsOfFile:[filename filename_document]];
		[filename release];
		[delegate perform_string:@"async_image_loaded:" with:self];
	}
	else
	{
		filename_original = [[NSString alloc] initWithString:[s url_to_filename]];
		if ([filename_original file_exists])
		{
			UIImage* the_image = [UIImage imageWithContentsOfFile:[filename_original filename_document]];
			UIImage* resized_image = [UIImage image_flip_horizontally:the_image];
			//UIImage* resized_image = [the_image image_with_size_aspect_fill:CGSizeMake(self.frame.size.width * scale, self.frame.size.height * scale)];
			[UIView begin_animations:0.3];
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
			//[UIImagePNGRepresentation(resized_image) writeToFile:[filename filename_document] atomically:YES];
			[UIImageJPEGRepresentation(resized_image, 75) writeToFile:[filename filename_document] atomically:YES];
			[ly no_backup:[filename filename_document]];
			self.image = resized_image;
			[UIView commitAnimations];
			[filename_original release], filename_original = nil;
			[filename release], filename = nil;
			[delegate perform_string:@"async_image_loaded:" with:self];
		}
		else
		{
			if ([placeholder is:@""])
			{
				if (self.frame.size.width < 128)
					self.image = [UIImage imageNamed:@"ly-placeholder-2.png"];
				else if (self.frame.size.width < 256)
					self.image = [UIImage imageNamed:@"ly-placeholder-4.png"];
				else
					self.image = [UIImage imageNamed:@"ly-placeholder-8.png"];
			}
			else
				self.image = [UIImage imageNamed:placeholder];

			//	NSLog(@"downloading from: %@", s);
			is_downloading = YES;
			request = [NSURLRequest requestWithURL:[NSURL URLWithString:s] 
									   cachePolicy:NSURLRequestReturnCacheDataElseLoad 
								   timeoutInterval:30.0];
			connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		}
	}
	//	NSLog(@"ASYNC 2 %@", self);
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData 
{
    if (data == nil)
        data = [[NSMutableData alloc] initWithCapacity:2048];

	progress++;
	//	if ((progress % 20) == 0) NSLog(@"ASYNC image received data: %i", progress);
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection 
{
	UIImage*	the_image = [UIImage imageWithData:data];

	is_downloading = NO;
	//	NSLog(@"got image: %@", the_image);
	//	NSLog(@"got data: %@", self);
	if (the_image != nil)
	{
		//	NSLog(@"downloaded image: %@", NSStringFromCGSize(the_image.size));
		[UIView begin_animations:0.3];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
		if (mode == UIViewContentModeScaleAspectFill)
		{
			the_image = [the_image image_with_size_aspect_fill:CGSizeMake(self.frame.size.width * scale, self.frame.size.height * scale)];
		}
		else if (mode == UIViewContentModeScaleAspectFit)
		{
#if 0
			CGFloat width = self.frame.size.width;
			CGFloat height = self.frame.size.height;
			height = width * the_image.size.height / the_image.size.width;
			the_image = [the_image image_with_size_aspect:CGSizeMake(width * scale, height * scale)];
#else
			//the_image = [the_image image_with_size_aspect:CGSizeMake(self.frame.size.width * scale, self.frame.size.height * scale)];
			the_image = [UIImage image_flip_horizontally:the_image];
#endif
		}
		else
		{
			//	NSLog(@"processing image: %@, %f", NSStringFromCGSize(self.frame.size), scale);
			the_image = [the_image image_with_size_aspect_fill:CGSizeMake(self.frame.size.width * scale, self.frame.size.height * scale)];
		}
		NSData* data_jpeg = UIImageJPEGRepresentation(the_image, 75);
		//[data writeToFile:[filename_original filename_document] atomically:YES];
		[data_jpeg writeToFile:[filename_original filename_document] atomically:YES];
		//	NSLog(@"saving image: %@", NSStringFromCGSize(the_image.size));
		//[UIImagePNGRepresentation(the_image) writeToFile:[filename filename_document] atomically:YES];
		[data_jpeg writeToFile:[filename filename_document] atomically:YES];
		[ly no_backup:[filename_original filename_document]];
		[ly no_backup:[filename filename_document]];
		self.image = the_image;
		[UIView commitAnimations];

		if (delegate != nil)
		{
			[delegate perform_string:@"async_image_downloaded:" with:self];
		}
	}
	[filename_original release], filename_original = nil;
	[filename release], filename = nil;
    [data release], data = nil;
	[connection release], connection = nil;
}

- (void)dealloc
{
	//[data release];
	//[connection release];
    [super dealloc];
}

@end


@implementation LYAsyncButton

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		self.imageView.contentMode = UIViewContentModeScaleAspectFill;
		self.imageView.clipsToBounds = YES;
		filename_original = nil;
		filename = nil;
		is_downloading = NO;
		data = nil;
		connection = nil;
	}

	return self;
}

- (void)load_url:(NSString*)s
{
	NSURLRequest*	request;

	if (is_downloading == YES)
		return;

	filename = [[NSString alloc] initWithFormat:@"%ix%i-%@",
			 (int)self.frame.size.width, (int)self.frame.size.height, [s url_to_filename]];
	//	[self.image release], self.image = nil;

	if ([filename file_exists] == YES)
	{
		//	NSLog(@"loading from cache: %@", [filename filename_document]);
		[self setBackgroundImage:[UIImage imageWithContentsOfFile:[filename filename_document]] forState:UIControlStateNormal];
		[filename release];
	}
	else
	{
		filename_original = [[NSString alloc] initWithString:[s url_to_filename]];
		if ([filename_original file_exists])
		{
			//	NSLog(@"loading from original...");
			UIImage* the_image = [UIImage imageWithContentsOfFile:[filename_original filename_document]];
			UIImage* resized_image = [the_image image_with_size_aspect_fill:CGSizeMake(self.frame.size.width * 2, self.frame.size.height * 2)];
			[UIView begin_animations:0.3];
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
			//[UIImagePNGRepresentation(resized_image) writeToFile:[filename filename_document] atomically:YES];
			[UIImageJPEGRepresentation(resized_image, 75) writeToFile:[filename filename_document] atomically:YES];
			[ly no_backup:[filename filename_document]];
			[self setBackgroundImage:resized_image forState:UIControlStateNormal];
			[UIView commitAnimations];
			[filename_original release], filename_original = nil;
			[filename release], filename = nil;
		}
		else
		{
			if (self.frame.size.width < 128)
				[self setBackgroundImage:[UIImage imageNamed:@"ly-placeholder-2.png"] forState:UIControlStateNormal];
			else if (self.frame.size.width < 256)
				[self setBackgroundImage:[UIImage imageNamed:@"ly-placeholder-4.png"] forState:UIControlStateNormal];
			else
				[self setBackgroundImage:[UIImage imageNamed:@"ly-placeholder-8.png"] forState:UIControlStateNormal];

			//	NSLog(@"downloading from: %@", s);
			is_downloading = YES;
			request = [NSURLRequest requestWithURL:[NSURL URLWithString:s] 
									   cachePolicy:NSURLRequestReturnCacheDataElseLoad 
								   timeoutInterval:30.0];
			connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		}
	}
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData 
{
    if (data == nil)
        data = [[NSMutableData alloc] initWithCapacity:2048];
	
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection 
{
	UIImage*	the_image = [UIImage imageWithData:data];

	is_downloading = NO;
	//	NSLog(@"got image: %@", the_image);
	//	NSLog(@"got data: %@", self);
	if (the_image != nil)
	{
		[UIView begin_animations:0.3];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
		the_image = [the_image image_with_size_aspect_fill:CGSizeMake(self.frame.size.width * 2, self.frame.size.height * 2)];
		NSData* data_jpeg = UIImageJPEGRepresentation(the_image, 75);
		//[data writeToFile:[filename_original filename_document] atomically:YES];
		[data_jpeg writeToFile:[filename_original filename_document] atomically:YES];
		//[UIImagePNGRepresentation(the_image) writeToFile:[filename filename_document] atomically:YES];
		[data_jpeg writeToFile:[filename filename_document] atomically:YES];
		[ly no_backup:[filename_original filename_document]];
		[ly no_backup:[filename filename_document]];
		[self setBackgroundImage:the_image forState:UIControlStateNormal];
		[UIView commitAnimations];
		//	NSLog(@"saving %@", [filename filename_document]);
	}
	[filename_original release], filename_original = nil;
	[filename release], filename = nil;
    [data release], data = nil;
	[connection release], connection = nil;
}

- (void)dealloc
{
	//	[data release];
	//	[connection release];
    [super dealloc];
}

@end
