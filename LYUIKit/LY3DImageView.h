#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#import "Texture2D.h"
#import "LYCategory.h"

@class LYES1Renderer;

///	3D image view with gravity support
/**
 * EXAMPLE
\code
	image_3d = [[LY3DImageView alloc] initWithFrame:CGRectMake(10, 380, 80, 80)];
	[image_3d set_image:@"Icon.png"];
	[image_3d set_color:[UIColor colorWithWhite:0.4 alpha:1]];
	[image_3d set_mode:1];
\endcode
 */
@interface LY3DImageView : UIView
{    
    LYES1Renderer* 		renderer;
@private
    BOOL animating;
    BOOL displayLinkSupported;
    NSInteger animationFrameInterval;
    id displayLink;
    NSTimer *animationTimer;
}
@property (readonly, nonatomic, getter=isAnimating) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;
@property (nonatomic, retain) LYES1Renderer*		renderer;

- (void)drawView:(id)sender;

- (void)start;
- (void)stop;
- (void)setImage:(UIImage*)image;
- (void)set_image:(NSString*)filename;
- (void)set_color:(UIColor*)color;
- (void)set_mode:(NSInteger)mode;
//TODO - (void)set_target:(id)delegate selector:(SEL)action;

@end

///	3D view helper
//@interface LYES1Renderer : NSObject <LYESRenderer, UIAccelerometerDelegate>
@interface LYES1Renderer : NSObject <UIAccelerometerDelegate>
{
	NSInteger		mode;
	UIColor*		color_bg;
@private
    EAGLContext *context;
    GLint backingWidth;
    GLint backingHeight;
    GLuint defaultFramebuffer, colorRenderbuffer;
	Texture2D*	texture_ground;
	GLfloat		accel[3];
}
@property (nonatomic) NSInteger				mode;
@property (nonatomic, retain) UIColor*		color_bg;
- (void)render;
- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer;
//- (void)set_image:(NSString*)filename;
- (void)set_image:(UIImage*)image;
- (void)enable_accelerometer;
- (void)disable_accelerometer;
- (void)draw_image_bg;
@end

#if 0
@protocol LYESRenderer <NSObject>
- (void)render;
- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer;
- (void)set_image:(NSString*)filename;
@end
#endif
