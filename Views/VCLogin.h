//
//  LoginViewController.h
//  BodyGraph
//
//  Created by Cai DaRong on 2/13/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCLogin : UIViewController<UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *emailTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) IBOutlet UITextField *sighupEmailTextField;
@property (nonatomic, strong) IBOutlet UITextField *signupPasswordTextField;

@property (nonatomic, strong) IBOutlet UITextField *confirmationTextField;

- (IBAction)signin:(id)sender;
- (IBAction)signup:(id)sender;
- (IBAction)signinWithFacebook:(id)sender;
- (IBAction)signinWithTwitter:(id)sender;

- (void)forcelogin;

@end
