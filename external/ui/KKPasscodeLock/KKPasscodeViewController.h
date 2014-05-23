#import <UIKit/UIKit.h>

#define kPasscodeBoxesCount        4

#define kPasscodeBoxWidth        61.0
#define kPasscodeBoxHeight       53.0


// The mode which controls the passcode view behavior
enum {
    /**
     * Displays the passcode enter view, which the user has to enter the correct passcode
     */
	KKPasscodeModeEnter = 0,
    
    /**
     * Creates a new passcode. This allows the user to enter a new passcode then
     * imediately verify it.
     */
	KKPasscodeModeSet = 1,
    
    /**
     * Disables an existing passcode. This allows the user to disable the passcode lock by
     * entering the passcode
     */
	KKPasscodeModeDisabled = 2,
    
    /**
     * Changes an existing passcode. This allows the user to change the passcode by
     * entering the existing passcode, followed by a new passcode
     */
	KKPasscodeModeChange = 3
};
typedef NSUInteger KKPasscodeMode;


@class KKPasscodeViewController;

@protocol KKPasscodeViewControllerDelegate <NSObject>

@optional

- (void)didPasscodeEnteredCorrectly:(KKPasscodeViewController*)viewController;
- (void)didPasscodeEnteredIncorrectly:(KKPasscodeViewController*)viewController;
- (void)shouldEraseApplicationData:(KKPasscodeViewController*)viewController;
- (void)didSettingsChanged:(KKPasscodeViewController*)viewController;

@end


@interface KKPasscodeViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource> {
	
    // delegate which called when major events happens
	id<KKPasscodeViewControllerDelegate> __unsafe_unretained _delegate;
	
	UILabel* _passcodeConfirmationWarningLabel;
	UIView* _failedAttemptsView;
	UILabel* _failedAttemptsLabel;
    
    // failed attements coutner
	NSInteger _failedAttemptsCount;
	
    // the current panel that being displayed
	NSUInteger _currentPanel;
    
    // used to transition between table views
	NSMutableArray* _tableViews;
    
    // array of passcode entry text fields
	NSMutableArray* _textFields;
    
	NSMutableArray* _boxes;
	
	UITableView* _enterPasscodeTableView;
	UITextField* _enterPasscodeTextField;
	
	UITableView* _setPasscodeTableView;
	UITextField* _setPasscodeTextField;
	
	UITableView* _confirmPasscodeTableView;
	UITextField* _confirmPasscodeTextField;
	
    // readwrite override for passlock mode
	KKPasscodeMode _mode;
	
    // whatever the passcode lock is turned on or off
	BOOL _passcodeLockOn;
    
    // whatever the erase data option is turned on or off
    BOOL _eraseData;
    
    // Used to make sure we do not release the keyboard when on iPad
    BOOL _shouldReleaseFirstResponser;
    
}

@property (nonatomic, unsafe_unretained) id <KKPasscodeViewControllerDelegate> delegate;
@property (nonatomic, assign) KKPasscodeMode mode;


@end

