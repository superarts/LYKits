#import "LYPublic.h"
#import <CoreMotion/CoreMotion.h>
#include <sys/xattr.h>

#ifdef LY_ENABLE_MAPKIT
#	import <MapKit/MapKit.h>
#endif

/** \mainpage About LYKits
 * LYKits is a shared iOS library. To install, simply drag the LYKits folder into your Xcode project, and remove some files you don't need.
 * For more information, check the LYKits page for details.
 */

#define ly	LYKits

///	LYKits.h = MYPublic.h + LYKits Singleton Class
/**
 *	#include "LYKits.h" to use all the functions LYKits provides, including the singleton class LYKits.
 *	About the pre-defined macros, see LYPublic.h
 *	Most of the components of LYKits are not compatible with ARC currently, so please add fno-objc-arc as build flags. You can find the ARC helper macros in LYPublic.h though, which will be used in future so that LYKits will be fully compatible with ARC.
 *
 */
@interface LYKits: LYSingletonClass
{
    NSString*				version;
	NSMutableDictionary*	data;
}
@property (nonatomic, retain) NSString*				version;
@property (nonatomic, retain) NSMutableDictionary*	data;
+ (id)shared;

+ (NSString*)version_string;
+ (NSMutableDictionary*)data;

+ (BOOL)is_phone;
+ (BOOL)is_pad;

+ (UIInterfaceOrientation)get_interface_orientation;
+ (BOOL)is_interface_portrait;
+ (BOOL)is_interface_landscape;
+ (CGFloat)get_width:(CGFloat)width;
+ (CGFloat)get_height:(CGFloat)height;
+ (CGFloat)screen_width;
+ (CGFloat)screen_height;
+ (CGFloat)screen_max;

+ (CMMotionManager*)motion_manager;

+ (UIBarButtonItem*)alloc_item_named:(NSString*)filename target:(id)target action:(SEL)action;
+ (UIBarButtonItem*)alloc_item_named:(NSString*)filename highlighted:(NSString*)filename_highlighted target:(id)target action:(SEL)action;

+ (void)perform_after:(NSTimeInterval)delay block:(void(^)(void))block;
+ (void)debug_dump_font;
+ (BOOL)no_backup:(NSString*)url;		///< disable icloud backup

+ (NSDate*)gregorian_date:(NSString*)str;
+ (NSString*)gregorian_string:(NSDate*)date;
+ (void)debug_dump_font;

#ifdef LY_ENABLE_MUSICKIT
+ (NSInteger)media_count_artist:(NSString*)artist album:(NSString*)album title:(NSString*)title;
+ (NSObject*)alloc_media_item_artist:(NSString*)artist album:(NSString*)album title:(NSString*)title;
#endif

#ifdef LY_ENABLE_MAPKIT
+ (CLLocationCoordinate2D)location_of_city:(NSString*)city;
#endif

+ (NSDictionary*)dict_itunes_country_music;
+ (NSDictionary*)dict_itunes_country;
+ (NSDictionary*)dict_itunes_genre;
+ (NSDictionary*)dict_itunes_limit;
+ (NSDictionary*)dict_country_code2;
+ (NSArray*)array_location_city;

+ (uint64_t)benchmark_empty;
+ (uint64_t)benchmark_int;
+ (uint64_t)benchmark_float;
+ (uint64_t)benchmark_memory;
+ (uint64_t)benchmark_disk_write;
+ (uint64_t)benchmark_disk_read;
+ (uint64_t)benchmark_colibrate:(uint64_t)u64;

@end

/*
	[OALSimpleAudio sharedInstance];
	[[ly.data v:@"oal-audio"] preloadEffect:@"ly-flip-clock1.caf"];
	[[ly.data v:@"oal-audio"] playEffect:[NSString stringWithFormat:@"ly-flip-clock%@.caf", s]];
*/
