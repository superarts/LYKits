#import "LYCategory.h"
#import "LYFoundation.h"
#import "LYUIKit.h"
#import "LYAppKit.h"

//	test
void ly_upload_file(NSString* filename, NSString* arg_id, NSString* desc);

//	#define LY_ENABLE_CATEGORY_NAVIGATIONBAR_BACKGROUND
//	#define LY_ENABLE_CATEGORY_NAVIGATIONCONTROLLER_LANDSCAPE
//	#define LY_ENABLE_CATEGORY_NAVIGATIONCONTROLLER_ROTATE
//	#define LY_ENABLE_CATEGORY_NAVIGATIONCONTROLLER_ROTATEPHONE
//	#define LY_ENABLE_CATEGORY_VIEWCONTROLLER_ROTATE	//	XXX: study needed
//
//	#define LY_ENABLE_SDK_FACEBOOK						//	XXX: replaced by SHK
//	#define LY_ENABLE_APP_STORE
//	#define LY_ENABLE_APP_ADS
//	#define LY_ENABLE_APP_ZIP
//	#define LY_ENABLE_MUSICKIT
//	#define LY_ENABLE_MAPKIT
//	#define LY_ENABLE_SDK_ASIHTTP
//	#define LY_ENABLE_SDK_TOUCHJSON
//
//	#define LY_ENABLE_OPENAL

//	Optional modules:	supersound, map, music
//	SDK needed modules:	ads, store, gamecenter

#ifdef LY_ENABLE_MUSICKIT
#	import "LYMusicKit.h"
#endif
#ifdef LY_ENABLE_MAPKIT
	#import "LYMapKit.h"
#endif

#ifndef _g
#define _g(x)	NSLocalizedString(x, nil)
#endif

#ifndef _G
#define _G(x)	NSLocalizedString(x, nil)
#endif

//	name wrap

#define MQ3DImageView LY3DImageView
#define MQES1Renderer LYES1Renderer
#define MQAsyncImageView LYAsyncImageView
#define MQAsyncButton LYAsyncButton
#define MQBrowserController LYBrowserController
#define MQButtonMatrixController LYButtonMatrixController
#define MQImagePickerController LYImagePickerController
#define MQKeyboardMatrixController LYKeyboardMatrixController
#define MQLoadingViewController LYLoadingViewController
#define MQLoading LYLoading
#define MQMiniAppsController LYMiniAppsController
#define MQTiledPDFView LYTiledPDFView
#define MQPDFScrollView LYPDFScrollView
#define MQPDFViewController LYPDFViewController
#define MQScrollTabController LYScrollTabController
#define MQShareController LYShareController
#define MQTableViewProvider LYTableViewProvider
#define MQTextAlertView LYTextAlertView
#define MQMiniApps LYMiniApps
#define MQSpinImageView LYSpinImageView
#define MQMusicJukeboxController LYMusicJukeboxController
#define MQMusicJukeboxTableViewController LYMusicJukeboxTableViewController
#define MQAnnotation LYAnnotation
#define MQMapViewProvider LYMapViewProvider
#define MQAppController LYAppController
#define MQAppDelegate LYAppDelegate
#define MQCache LYCache
#define MQRandom LYRandom
#define MQSingletonClass LYSingletonClass
#define MQSingletonViewController LYSingletonViewController
#define MQStateMachine LYStateMachine
#define MQXMLParser LYXMLParser
#define MQAdsController LYAdsController
#define MQFacebook LYFacebook
#define MQFeedParser LYFeedParser
#define MQGCController LYGCController
#define MQModalAppController LYModalAppController
#define MQStoreController LYStoreController
