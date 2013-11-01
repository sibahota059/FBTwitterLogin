//
//  SPHViewController.m
//  TweeterLogin
//
//  Created by Siba Prasad Hota on 9/26/13.
//  Copyright (c) 2013 Wemakeappz. All rights reserved.
//

#import "SPHViewController.h"

@interface SPHViewController ()

@end

@implementation SPHViewController

@synthesize facebook;
@synthesize userPermissions;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *kAppID = @"145039522260092";
    facebook =[[Facebook alloc]initWithAppId:kAppID andDelegate:self];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)TetLogin:(id)sender
{
    
    if(!_engine){
        
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
        _engine.consumerKey = @"PzkZj9g57ah2bcB58mD4Q";
        _engine.consumerSecret = @"OvogWpara8xybjMUDGcLklOeZSF12xnYHLE37rel2g";
    }
    
    if(![_engine isAuthorized]){
        UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];
        if (controller){
            [self presentViewController:controller animated:YES completion:nil];
        }
    }

    
}

- (IBAction)fblogin:(id)sender
{
    facebook.sessionDelegate=self;
    if([facebook isSessionValid])
    {
        [facebook requestWithGraphPath:@"me" andDelegate:self];
        [[NSUserDefaults standardUserDefaults] setValue: facebook.accessToken forKey: @"access_token"];
        [[NSUserDefaults standardUserDefaults] setValue: facebook.expirationDate forKey: @"expiration_date"];
         NSLog(@"User already logined with facebook");
    }
    else
    {
        [facebook authorize:[NSArray arrayWithObjects:@"read_stream",
                                 @"publish_stream",
                                 @"email",
                                 @"user_birthday",
                                 @"friends_about_me",
                                 @"friends_activities",
                                 @"friends_likes",
                                 nil]];
    }
}



- (void) request:(FBRequest*)request didLoad:(id)result
{
    NSLog(@"All data =%@",result);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if ([result isKindOfClass:[NSDictionary class]])
    {
    }
    [self fbUploadImage];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"FacebookEnginePosted" object:result]];
}





- (void) fbUploadImage
{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"Conciergist for iPhone and Android", @"name",
                                   @"Login with Conciergist and start Chatting with your personal assistance for FREE https://itunes.apple.com/us/app/conciergist/id670191546?mt=8", @"caption",
                                   [UIImage imageNamed:@"ConciergistShareImg"], @"picture",
                                   nil];
    
    [facebook requestWithMethodName: @"photos.upload"
                          andParams: params
                      andHttpMethod: @"POST"
                        andDelegate: nil];
    
    [[NSUserDefaults standardUserDefaults]setValue:@"Done" forKey:@"FBUpload"];
    
    
}


- (void)publishButtonAction {
    // Put together the dialog parameters
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"Conciergist for iPhone and Android", @"name",
                                   @"Login with Conciergist and start Chatting with your personal assistance for FREE", @"caption",
                                   @"Machines answers to your questions, but Human responds. Conciergist, Free Live Chat application allows users to ask questions to real people, regardless of the kind of question.Are you looking for a good restaurant? Are you lost on your way? You can make use of this application to solve your problem. All your questions will be responded by humans and not robot, so you can explain your problem, every way you can. This app doesn’t give any room for vague results, as the answer-givers are the real people.You can make use of Our Free Live Chat application at your convenient time!", @"description",
                                   @"https://itunes.apple.com/us/app/conciergist/id670191546?mt=8", @"link",
                                   [UIImage imageNamed:@"ConciergistShareImg"], @"picture",
                                   nil];
    
    // Invoke the dialog
    [self.facebook dialog:@"feed" andParams:params andDelegate:self];
    
}




- (void)fbDidLogin
{
    [[NSUserDefaults standardUserDefaults]setValue:@"FB" forKey:@"type"];
    [[NSUserDefaults standardUserDefaults] setValue:facebook.accessToken forKey: @"access_token"];
    [[NSUserDefaults standardUserDefaults] setValue: facebook.expirationDate forKey: @"expiration_date"];
    [facebook requestWithGraphPath:@"me" andDelegate:self];
    
    
}


//facebook error
- (void)request:(FBRequest*)request didFailWithError:(NSError*)error
{
    
    
}


-(void)fbDidNotLogin:(BOOL)cancelled
{
    // // NSLog(@"Login Cancelled");
    
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt
{
    
}

-(void)fbSessionInvalidated
{
    
}


-(void)fbDidLogout
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // // NSLog(@"defaults fbDidLogout  ........%@",defaults);
    
    if ([defaults objectForKey:@"FBAccessTokenKey"])
    {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
    
    
    // Hide the publish button.
    
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"facebook"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
}





-(void)logoutFB
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // // NSLog(@"defaults fbDidLogout  ........%@",defaults);
    
    if ([defaults objectForKey:@"FBAccessTokenKey"])
    {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
    
    
    // Hide the publish button.
    
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"facebook"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
    
}




- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	
	NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
	NSLog(@"Authenticated with user %@", data);
    
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
    
    NSArray *indiArray=[[[NSUserDefaults standardUserDefaults] valueForKey:@"authData"] componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *tweetDict=[[NSMutableDictionary alloc]init];
    NSLog(@"indiArray=%@",indiArray);
    for (int i=0; i<indiArray.count; i++) {
        
        NSString *rowData=[indiArray objectAtIndex:i];
        NSArray *separatedData=[rowData componentsSeparatedByString:@"="];
        
        [tweetDict setValue:[separatedData objectAtIndex:1] forKey:[separatedData objectAtIndex:0]];
        
        
    }
    
  
    NSLog(@"TWEETDICT=%@",tweetDict);
  
    
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}


-(void)AskForEmail
{
    
}


-(IBAction)updateStream:(id)sender {
	
	[_engine getFollowedTimelineSinceID:1 startingAtPage:1 count:100];
}


#pragma mark SA_OAuthTwitterController Delegate

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	
	NSLog(@"Authenticated with user %@", username);
	
  
	[self updateStream:nil];
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	
	NSLog(@"Authentication Failure");
    
   
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	
   
	NSLog(@"Authentication Canceled");
}

#pragma mark MGTwitterEngineDelegate Methods

- (void)requestSucceeded:(NSString *)connectionIdentifier {
    
	NSLog(@"Request Suceeded: %@", connectionIdentifier);
}

- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)connectionIdentifier {
	
	tweets = [[NSMutableArray alloc] init];
	
	for(NSDictionary *d in statuses) {
		
		NSLog(@"See dictionary: %@", d);
    }
	
	
}

-(void)logOutFromTwitter
{
    
    _engine = nil;
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey: @"authData"];
}
- (void)receivedObject:(NSDictionary *)dictionary forRequest:(NSString *)connectionIdentifier {
    
	NSLog(@"Recieved Object: %@", dictionary);
}

- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)connectionIdentifier {
    
	NSLog(@"Direct Messages Received: %@", messages);
}

- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier {
	
	NSLog(@"User Info Received: %@", userInfo);
}

- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)connectionIdentifier {
	
	NSLog(@"Misc Info Received: %@", miscInfo);
}


@end
