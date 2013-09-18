//
//  LoginViewController.m
//  BodyGraph
//
//  Created by Cai DaRong on 2/13/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import "VCLogin.h"
#import "AuthService.h"
#import "FacebookManager.h"
#import "TwitterManager.h"
#import "AppDelegate.h"
#import "User.h"
#import "HUDManager.h"
#import "VCProfile.h"

@interface VCLogin ()

@end

@implementation VCLogin

bool isForceLogin = false;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //
    }
    return self;
} 
- (void) forcelogin
{
    isForceLogin = true;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard:)];
        [self.view addGestureRecognizer:tap];
    
    NSString *accessToken = [[AuthService sharedServiceWithContext:kSecurityContext] getAccessToken];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserIdKey];
    if( accessToken != nil && userId != nil && !isForceLogin) {
        NSString *viewName = @"VCProfile";
        UIViewController *viewController = [[NSClassFromString(viewName) alloc] initWithNibName:viewName bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    [self.navigationController setNavigationBarHidden:YES];
    
    // Recognize gesture for dissmising keyboard
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.confirmationTextField.delegate = self;
}
- (void) animateTextField: (UITextField*) textField up: (BOOL) up movDist:(int)movementDistance
{
    //const int movementDistance = 105; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (IBAction)textFieldDidBeginEditing:(id)sender {
    [self animateTextField: _emailTextField up: YES movDist:105];
}
- (IBAction)textFieldDidEndEditing:(id)sender {
    [self animateTextField: _emailTextField up: NO movDist:105];
}
- (IBAction)txtSignupDidBegin:(id)sender {
    [self animateTextField: _signupPasswordTextField up: YES movDist:10];
}
- (IBAction)txtSignupDidEnd:(id)sender {
    [self animateTextField: _signupPasswordTextField up: NO movDist:10];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerUser:(NSDictionary *)params withSource:(LoginType)loginSource
{
    NSString *email = _sighupEmailTextField.text; //[params objectForKey:@"email"];
    NSString *password = _signupPasswordTextField.text; // [params objectForKey:@"password"];
    //NSString *confirmation = [params objectForKey:@"confirmation"];
    
    if([email length] == 0 && loginSource == Credentials)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BodyGraph"
                                                        message:@"Please enter a valid email"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if( [password length] == 0  && loginSource == Credentials) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BodyGraph"
                                                        message:@"Please enter a password"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*if( confirmation == nil ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BodyGraph"
                                                        message:@"Please reenter the password"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *regex = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+.[A-Z]{2,4}$";
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regex
                                                                                options:NSRegularExpressionCaseInsensitive
                                                                                  error:nil];
    
    NSUInteger match = [expression numberOfMatchesInString:email
                                                   options:0
                                                     range:NSMakeRange(0, [email length])];
    
    if( match == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BodyGraph"
                                                        message:@"Please a valid email"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if( ![password isEqualToString:confirmation] ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BodyGraph"
                                                        message:@"Passwords don't match"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }*/
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Registering user...";
    
    [[AuthService sharedServiceWithContext:kSecurityContext] registerWithParams:params
    onCompletion:^(User *user) {
        [AppDelegate sharedDelegate].localUser = user;
                                
        NSUserDefaults *appSettings = [NSUserDefaults standardUserDefaults];
        [appSettings setInteger:loginSource forKey:kLoginSourceKey];
        [appSettings setInteger:user.userId forKey:@"User"];
                                
        [hud hide:YES];
                                
        // If user logins with a social network, user data is collected from there
        NSString *viewName = (user.activeCampaign == nil || user.activeCampaign.campaignId == 0) ? @"VCStartCampaign" : @"VCProfile";
        UIViewController *viewController = [[NSClassFromString(viewName) alloc] initWithNibName:viewName bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    onError:^(NSError *error) {
        [hud hide:YES];
                                     
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BodyGraph"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

- (IBAction)signin:(id)sender
{
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if( [email length] == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BodyGraph"
                                                        message:@"Please enter a valid email"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if( [password length] == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BodyGraph"
                                                        message:@"Please enter a password"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *regex = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+.[A-Z]{2,4}$";
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regex
                                                                                options:NSRegularExpressionCaseInsensitive
                                                                                  error:nil];
    
    NSUInteger match = [expression numberOfMatchesInString:email
                                                   options:0
                                                     range:NSMakeRange(0, [email length])];
    
    if( match == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BodyGraph"
                                                        message:@"Please enter a valid email"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Login...";
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            email, @"email",
                            password, @"password", nil];
    
    [[AuthService sharedServiceWithContext:kSecurityContext] loginWithParams:params
    onCompletion:^(User *user) {
        [AppDelegate sharedDelegate].localUser = user;
                             
        NSUserDefaults *appSettings = [NSUserDefaults standardUserDefaults];
        [appSettings setInteger:user.userId forKey:@"User"];
                             
        [hud hide:YES];
                             
        NSString *viewName = (user.activeCampaign == nil || user.activeCampaign.campaignId == 0) ? @"VCStartCampaign" : @"VCProfile";//VCProfile
        UINavigationController *viewController = [[NSClassFromString(viewName) alloc] initWithNibName:viewName bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
        
    }
    onError:^(NSError *error) {
        [hud hide:YES];
                                  
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BodyGraph"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];
    
}



- (IBAction)signup:(id)sender
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            self.sighupEmailTextField.text, @"email",
                            self.signupPasswordTextField.text, @"password",
                            //self.confirmationTextField.text, @"confirmation",
                            [NSNumber numberWithInt:Credentials], @"source", nil];
    
    [self registerUser:params withSource:Credentials];
}

- (IBAction)signinWithFacebook:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Login with Facebook...";
    
    [[FacebookManager sharedManager]
     login:^(NSDictionary *data) {
         NSString *pictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", [data objectForKey:@"id"]];
         NSString *email = [NSString stringWithFormat:@"%@@facebook.com", [data objectForKey:@"id"]];
         NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 email, @"email",
                                 kRegisterToken, @"password",
                                 kRegisterToken, @"confirmation",
                                 [data objectForKey:@"id"], @"fbid",
                                 [data objectForKey:@"name"], @"nickname",
                                 pictureUrl, @"picture",
                                 [NSNumber numberWithInt:Facebook], @"source", nil];
         
         [hud hide:YES];
         [self registerUser:params withSource:Facebook];
     }
     onError:^(NSError *error){
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BodyGraph"
                                                         message:[error localizedDescription]
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
         [alert show];
     }];
}

- (IBAction)signinWithTwitter:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Login with Twitter...";
    
    [[TwitterManager sharedManager]
     login:^(NSDictionary *data) {
         NSString *email = [NSString stringWithFormat:@"%@@twitter.com", [data objectForKey:@"id_str"]];
         NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 email, @"email",
                                 kRegisterToken, @"password",
                                 kRegisterToken, @"confirmation",
                                 [data objectForKey:@"id"], @"twid",
                                 [data objectForKey:@"name"], @"nickname",
                                 [data objectForKey:@"profile_image_url"], @"picture",
                                 [NSNumber numberWithInt:Twitter], @"source", nil];
         
         [hud hide:YES];
         [self registerUser:params withSource:Twitter];
     }
     onError:^(NSError *error){
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BodyGraph"
                                                         message:[error localizedDescription]
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
         [alert show];
     }];
}

- (IBAction)dismissKeyboard:(id)sender
{
    [_passwordTextField resignFirstResponder];
    [_emailTextField resignFirstResponder];
    [_sighupEmailTextField resignFirstResponder];
    [_signupPasswordTextField resignFirstResponder];
}

@end
