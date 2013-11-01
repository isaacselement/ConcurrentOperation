#import "ConcurrentOperationTestAppDelegate.h"
#import "ConcurrentOperationTestViewController.h"
#import "URLConnectionOperation.h"

@interface ConcurrentOperationTestAppDelegate ()
- (NSArray *)urlFixtures;
@end

static NSUInteger totalImagesLoaded = 0;

@implementation ConcurrentOperationTestAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {

    queue = [[[NSOperationQueue alloc] init] retain];
    [queue setMaxConcurrentOperationCount:3];

    for(NSURL *url in [self urlFixtures]) {
        URLConnectionOperation *op = [[[URLConnectionOperation alloc] init] autorelease];
        op.delegate = self;
        op.urlToLoad = url;
        [queue addOperation:op];
    }

    viewController.countLabel.text = @"Images Loaded: 0";
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}

- (void)didFinishLoad:(NSDictionary *)info
{
    NSURL *url = [info valueForKey:@"url"];
    totalImagesLoaded += 1;
    viewController.countLabel.text = [NSString stringWithFormat:@"Images Loaded: %i/%i", totalImagesLoaded, [[self urlFixtures] count]];

    NSLog(@"FINISHED LOADING URL:%@", url);
}

- (NSArray *)urlFixtures
{
   return [NSArray arrayWithObjects:
    [NSURL URLWithString:@"http://farm4.static.flickr.com/3451/3386878622_d245679751_m.jpg"],
    [NSURL URLWithString:@"http://farm4.static.flickr.com/3622/3386066099_e5056ac309_m.jpg"],
    [NSURL URLWithString:@"http://farm4.static.flickr.com/3424/3386878852_a775116286_m.jpg"],
    [NSURL URLWithString:@"http://farm4.static.flickr.com/3577/3386066275_059a0663bc_m.jpg"],
    [NSURL URLWithString:@"http://farm4.static.flickr.com/3587/3386066179_e9b4335e7f_m.jpg"],
    [NSURL URLWithString:@"http://farm4.static.flickr.com/3633/3386878920_2d91bdfcd1_m.jpg"],
    [NSURL URLWithString:@"http://farm4.static.flickr.com/3453/3386878964_19c9e50832_m.jpg"],
    [NSURL URLWithString:@"http://farm4.static.flickr.com/3470/3386879000_34d34cb340_m.jpg"],
    [NSURL URLWithString:@"http://farm4.static.flickr.com/3455/3386066469_c946d584b3_m.jpg"],
    [NSURL URLWithString:@"http://farm4.static.flickr.com/3662/3386066511_dbd1f2812a_m.jpg"],
    [NSURL URLWithString:@"http://farm4.static.flickr.com/3458/3386066561_696e34daa0_m.jpg"],
    [NSURL URLWithString:@"http://farm4.static.flickr.com/3563/3386066613_c2fc908f47_m.jpg"],
    [NSURL URLWithString:@"http://farm4.static.flickr.com/3601/3386066631_76466c8c1d_m.jpg"],
    [NSURL URLWithString:@"http://farm4.static.flickr.com/3611/3386879310_d339318e3f_m.jpg"],
    [NSURL URLWithString:@"http://farm4.static.flickr.com/3592/3386066741_2bb58db5d0_m.jpg"],
    [NSURL URLWithString:@"http://farm4.static.flickr.com/3641/3386066821_5eae68bbca_m.jpg"],
    nil];
}


- (void)dealloc {
    [queue release];
    [viewController release];
    [window release];
    [super dealloc];
}


@end
