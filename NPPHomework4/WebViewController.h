//
//  WebViewController.h
//  NPPHomework4
//
//  Created by Nick Peters on 3/5/15.
//  Copyright (c) 2015 Nick Peters. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController<NSURLConnectionDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSString *name;

@end
