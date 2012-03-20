#import <UIKit/UIKit.h>

///	template of all the singleton classes like LYCache, LYRandom, etc.
@interface LYSingletonClass: NSObject
@end

@interface LYSingletonViewController: UIViewController
@end

#pragma mark Singleton Example

///	sington class example
@interface MySingletonClass: LYSingletonClass
{
    NSString*		property;
}
@property (nonatomic, retain) NSString*		property;
+ (id)shared;
@end
