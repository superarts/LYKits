#import <UIKit/UIKit.h>
#import "LYKits.h"
//#import "LYCategory.h"

///	multiple-thread downloading
@interface LYAsyncImageView: UIImageView 
{
    NSURLConnection*	connection;
    NSMutableData*		data;
	NSString*			filename_original;
	NSString*			filename;
	BOOL				is_downloading;
	id					delegate;
	int					progress;
	UIViewContentMode	mode;
	CGFloat				scale;
}
@property (retain, nonatomic) id			delegate;
@property (retain, nonatomic) NSString*		placeholder;
@property (nonatomic) UIViewContentMode		mode;
@property (nonatomic) CGFloat				scale;

- (void)load_url:(NSString *)theUrlString;

@end


//	TODO: combine these two classes
@interface LYAsyncButton: UIButton 
{
    NSURLConnection*	connection;
    NSMutableData*		data;
	NSString*			filename_original;
	NSString*			filename;
	BOOL				is_downloading;
}

- (void)load_url:(NSString *)theUrlString;

@end
