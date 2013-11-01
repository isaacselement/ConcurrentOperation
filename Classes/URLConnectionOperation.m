#import "URLConnectionOperation.h"
@interface URLConnectionOperation ()
- (void)finish;
@end

@implementation URLConnectionOperation
@synthesize delegate = _delegate;
@synthesize urlToLoad = _urlToLoad;

- (id)init
{
   if((self = [super init])) {
       _isExecuting = NO;
       _isFinished = NO;
   }

   return self;
}

- (void)dealloc
{
    [_urlToLoad release];
    [super dealloc];
}

- (BOOL)isConcurrent {
    return YES;
}

- (void)start
{
    // (Run on main thread, the delegate will callback in main thread)
//    if (![NSThread isMainThread])
//    {
//        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
//        return;
//    }

    if ([self isCancelled]) {
        [self willChangeValueForKey:@"isFinished"];
        _isFinished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }

    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];

    NSURLRequest *request = [NSURLRequest requestWithURL:self.urlToLoad cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0];

    // all the setup comes here

    // Run on background thread , the delegate will callback on other thread
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [_connection scheduleInRunLoop:loop forMode:NSRunLoopCommonModes];
    [_connection start];
    if(_connection) {
        _responseData = [[[NSMutableData alloc] init] retain];
    }
    else {
        [self finish];
    }
    [loop run]; // make sure that you have a running run-loop. This is important , See the doc of this method

    
    // Make sure the connection runs in the main run loop.  (Run on main thread)
//    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
//    [_connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
//    [_connection start];
//    if(_connection) {
//        _responseData = [[[NSMutableData alloc] init] retain];
//    }
//    else {
//        [self finish];
//    }
}

- (void)finish {
    [_connection release];
    _connection = nil;

    [_responseData release];
    _responseData = nil;

    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];

    _isExecuting = NO;
    _isFinished = YES;

    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (BOOL)isExecuting {
   return _isExecuting;
}

- (BOOL)isFinished {
   return _isFinished;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"NSThread isMainThread - %d", [NSThread isMainThread] );
    [_responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey: NSURLErrorFailingURLStringErrorKey]);

    [self finish];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    UIImage *img = [[[UIImage alloc] initWithData:_responseData] autorelease];
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:img, @"img", _urlToLoad, @"url", nil];
    NSLog(@"_responseData lenght : %d",[_responseData length]);

    dispatch_async(dispatch_get_main_queue(), ^{
        if([_delegate respondsToSelector:@selector(didFinishLoad:)]) {
            [_delegate performSelector:@selector(didFinishLoad:) withObject:info];
        }
    });

    [self finish];
}
@end
