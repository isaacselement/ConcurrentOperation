
#import "ConcurrentOperationTestViewController.h"

@implementation ConcurrentOperationTestViewController

@synthesize countLabel;


- (void)dealloc {
    [countLabel release];
    [super dealloc];
}

@end
