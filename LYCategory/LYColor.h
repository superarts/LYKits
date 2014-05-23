#import "LYCategory.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface UIColor (LYColor)

//	init color with filename
+ (UIColor*)colorNamed:(NSString*)filename;

//	get r, g, b, a values
- (CGFloat)get_red;
- (CGFloat)get_green;
- (CGFloat)get_blue;
- (CGFloat)get_alpha;
- (CGFloat)get_component:(NSInteger)index;
- (UIColor*)invert;
- (UIColor*)dark_color:(CGFloat)l;
- (UIColor*)light_color:(CGFloat)l;

@end
