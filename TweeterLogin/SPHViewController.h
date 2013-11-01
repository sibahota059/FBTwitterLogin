//
//  SPHViewController.h
//  TweeterLogin
//
//  Created by Siba Prasad Hota on 9/26/13.
//  Copyright (c) 2013 Wemakeappz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"
#import "FBConnect.h"
#import "FBLoginDialog.h"
#import "FBRequest.h"

@interface SPHViewController : UIViewController<SA_OAuthTwitterEngineDelegate, SA_OAuthTwitterControllerDelegate,FBRequestDelegate,FBSessionDelegate,FBDialogDelegate>
{
    SA_OAuthTwitterEngine *_engine;
	
    NSMutableArray *tweets;

}

@property (nonatomic, retain) NSMutableDictionary *userPermissions;
@property (nonatomic, retain) Facebook *facebook;


- (IBAction)TetLogin:(id)sender;
- (IBAction)fblogin:(id)sender;

@end
