//
//  WebViewController.h
//  FaceCap
//
//  Created by Nelson Chicas on 5/5/13.
//  Copyright (c) 2013 Applits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webView;

- (id)initWithTitle:(NSString *)title content:(NSString *)contentPath;

@end