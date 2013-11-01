#import <UIKit/UIKit.h>

@protocol URLConnectionOperationDelegate;

@class ConcurrentOperationTestViewController;

@interface ConcurrentOperationTestAppDelegate : NSObject <URLConnectionOperationDelegate, UIApplicationDelegate> {
    UIWindow *window;
    ConcurrentOperationTestViewController *viewController;

    NSOperationQueue *queue;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ConcurrentOperationTestViewController *viewController;

@end

