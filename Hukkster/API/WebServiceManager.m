//
//  WebServiceManager.m
//  Hukkster
//
//  Created by Djuro Alfirevic on 15.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import "WebServiceManager.h"
#import "DMManager.h"
#import "Reachability.h"

static WebServiceManager *sharedManager = NULL;

@interface WebServiceManager()
@property (strong, nonatomic) UIAlertView *loaderView;

- (void)parseJSON:(NSData *)data withProcess:(WebServiceProcess)process;
@end

@implementation WebServiceManager

#pragma mark - Public API

+ (WebServiceManager *)sharedInstance
{
    @synchronized(self)	{
        if (sharedManager == nil) {
            sharedManager = [[super allocWithZone:NULL] init];
        }
    }
	
	return sharedManager;
}

- (void)getJSON:(NSString *)urlString withProcess:(WebServiceProcess)process andLoader:(BOOL)loaderOn
{
    // If the user is connected to the Internet, call GCD to get JSON for issues
    if ([self hasInternetConnection]) {
        if (loaderOn) [self showLoaderWithMessage:LOADING_STRING];
        
        dispatch_queue_t downloadQueue = dispatch_queue_create("JSONDownloader", NULL);
        dispatch_async(downloadQueue, ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseJSON:data withProcess:process];
            });
        });
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:NO_INTERNET_NOTIFICATION object:nil];
    }
}

- (void)postParameters:(NSString *)postParameters
                 toURL:(NSString *)url
           withProcess:(PostToWebServiceProcess)process
   asBackgroundProcess:(BOOL)option
{
    if ([self hasInternetConnection]) {
        if (!option) [self showLoaderWithMessage:LOADING_STRING];
        
        NSURL *webUrl = [NSURL URLWithString:url];
        //NSData *postData = [postParameters dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        //NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:webUrl];
        [request setHTTPMethod:@"POST"];
        //[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"HUKK OUtRNFBJTFFXVEpPWFVUMVdFUFoyUUJETEFDMEpVRVhFTEYzSUpBUlE6Yzk3NTBiMzExOTVjMTY3ZDBiYThkNjA4MDY1Yzc2ZjJjZjYwMWE3ZTllNmJlNzczZDAzZjUwMjYxYjlhYTFhYQ==" forHTTPHeaderField:@"Authorization"];
        //[request setHTTPBody:postData];
        
        NSString *myboundary = @"---------------------------14737809831466499882746641449";
        
        // Post body
        NSMutableData *body = [NSMutableData data];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"grant_type"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"hukkster"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"timestamp"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [NSDate date]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"deviceid"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"9F41A975-4E40-4921-8A30-60768B058A11"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"email"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"kibernick@gmail.com"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"password"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"kibermann"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"notification_device_token"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"2db3450e400ee8f7df8a1353e08a1827b2d340f5b4ac28fe499373996a185fb5"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Setting the body of the post to the reqeust
        [request setHTTPBody:body];
        
        // Set the content-length
        NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];

        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   if (!option) [self removeLoader];
                                   
                                   NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                   
                                   if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                       [[DMManager sharedInstance] parsePostData:data withProcess:process];
                                   }
                               }];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:NO_INTERNET_NOTIFICATION object:nil];;
    }
}

/*

- (void)uploadPhoto:(UIImage *)photo
            forName:(NSString *)name
           andEmail:(NSString *)email
         andProcess:(PostToWebServiceProcess)process
{
    if ([self hasInternetConnection]) {
        NSString *myboundary = @"---------------------------14737809831466499882746641449";
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [request setHTTPShouldHandleCookies:NO];
        [request setTimeoutInterval:30];
        [request setHTTPMethod:@"POST"];
        
        // Set Content-Type in HTTP header
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", myboundary];
        [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        // Post body
        NSMutableData *body = [NSMutableData data];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", EMAIL_KEY] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", email] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", NAME_KEY] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", name] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", OWNER_ID_KEY] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [[NSUserDefaults standardUserDefaults] objectForKey:OWNER_ID]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Add Image Data
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", @"ipad.jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:UIImageJPEGRepresentation(photo, 1.0)];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]]; // added key
        
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Setting the body of the post to the reqeust
        [request setHTTPBody:body];
        
        // Set the content-length
        NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        
        // Set URL
        NSString *url = [NSString stringWithFormat:@"%@%@", URL, PHOTO_URL];
        [request setURL:[NSURL URLWithString:url]];
        
        [self showLoaderWithMessage:SENDING_STRING];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             [self removeLoader];
             
             if (data) [[DMManager sharedInstance] parsePostData:data withProcess:process];
         }];
    } else {
        INTERNET_CONNECTION_ALERT;
    }
}*/

- (void)showLoaderWithMessage:(NSString *)message
{
    self.loaderView = [[UIAlertView alloc] initWithTitle:message 
												 message:nil 
												delegate:nil 
									   cancelButtonTitle:nil 
									   otherButtonTitles:nil];
	UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 50, 30, 30)];
	activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	[self.loaderView addSubview:activityIndicator];
	[activityIndicator startAnimating];
	[self.loaderView show];
}

- (void)removeLoader
{
    [self.loaderView dismissWithClickedButtonIndex:0 animated:YES];
}

- (BOOL)hasInternetConnection
{
	Reachability *reach		= [Reachability reachabilityForInternetConnection];
	NetworkStatus status	= [reach currentReachabilityStatus];
	
	if (status == NotReachable) {
		return NO;
	}
	
	return YES;
}
                     
#pragma mark - Private API

- (void)parseJSON:(NSData *)data withProcess:(WebServiceProcess)process
{
    if (data) {
        [[DMManager sharedInstance] parseResponseData:data withProcess:process];
    }
}



@end