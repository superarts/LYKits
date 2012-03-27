#import "LYServiceKit.h"

///	face detection from face.com
#ifdef LY_ENABLE_SDK_ASIHTTP
@interface LYServiceFaceDotCom: NSObject
{
	NSMutableDictionary* data;
}
@property (nonatomic, retain) NSMutableDictionary*	data;

- (void)limits:(LYBlockVoidDictError)callback;
- (void)detect:(NSString*)filename block:(LYBlockVoidArrayError)callback;

@end
#endif
