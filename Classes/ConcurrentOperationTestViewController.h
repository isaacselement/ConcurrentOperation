#import <UIKit/UIKit.h>

@interface ConcurrentOperationTestViewController : UIViewController {
    IBOutlet UILabel *countLabel;
}

@property (nonatomic, retain) UILabel *countLabel;

@end

