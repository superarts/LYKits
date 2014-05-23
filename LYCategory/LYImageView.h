#import "LYPublic.h"

@interface UIImageView (LYImage)

- (id)initWithImageNamed:(NSString*)filename;
- (void)draw_frame_with_r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a width:(CGFloat)width;
- (void)draw_cross_with_r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a width:(CGFloat)width;
- (void)draw_frame_black;
- (void)draw_frame_white;
- (void)draw_cross_black;
- (void)draw_cross_white;
- (void)set_mask_circle;
- (void)set_border_circle;
- (void)clock_flip;

@end
