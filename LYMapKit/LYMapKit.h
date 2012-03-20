#import <MapKit/MapKit.h>
#import "LYCategory.h"
#import "LYAnnotation.h"

/*
 * LYAnnotation
 * 		basic annotation class with title, subtitle, and coordinate
 *
 */

///	place manager that implementes CLLocationManagerDelegate and MKReverseGeocoderDelegate
#if 1
@interface LYPlaceManager: NSObject <CLLocationManagerDelegate, MKReverseGeocoderDelegate>
{
	CLLocationManager*	location_manager;
	MKReverseGeocoder*	reverse_geocoder;
	MKPlacemark*		placemark;
	NSString*			mode;
	id					delegate;
}
@property (nonatomic, retain) IBOutlet CLLocationManager*	location_manager;
@property (nonatomic, retain) IBOutlet MKReverseGeocoder*	reverse_geocoder;
@property (nonatomic, retain) IBOutlet MKPlacemark*	placemark;
@property (nonatomic, retain) IBOutlet NSString*	mode;
@property (nonatomic, retain) IBOutlet id			delegate;

@end
#endif
