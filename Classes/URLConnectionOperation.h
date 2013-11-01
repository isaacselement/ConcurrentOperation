#import <Foundation/Foundation.h>

@protocol URLConnectionOperationDelegate <NSObject>

- (void)didFinishLoad:(NSDictionary *)info;

@end

@interface URLConnectionOperation : NSOperation {
    id <URLConnectionOperationDelegate>_delegate;
    NSURL *_urlToLoad;

    NSURLConnection *_connection;
    NSMutableData   *_responseData;

    BOOL _isFinished;
    BOOL _isExecuting;
}

@property (nonatomic, assign) id <URLConnectionOperationDelegate>delegate;
@property (nonatomic, retain) NSURL *urlToLoad;
@end
