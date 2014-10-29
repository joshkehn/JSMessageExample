//
//  ViewController.m
//  JSMessageExample
//
//  Created by Joshua Kehn on 10/27/14.
//  Copyright (c) 2014 KEHN. All rights reserved.
//

#import "ViewController.h"

#define k_JSBIN_URL @"http://jsbin.com/meniw"

@interface ViewController ()
@property (strong, nonatomic) WKWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // First create a WKWebViewConfiguration object so we can add a controller
    // pointing back to this ViewController.
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]
                                             init];
    WKUserContentController *controller = [[WKUserContentController alloc]
                                           init];

    // Add a script handler for the "observe" call. This is added to every frame
    // in the document (window.webkit.messageHandlers.NAME).
    [controller addScriptMessageHandler:self name:@"observe"];
    configuration.userContentController = controller;

    // This is the URL to be loaded into the WKWebView.
    NSURL *jsbin = [NSURL URLWithString:k_JSBIN_URL];

    // Initialize the WKWebView with the current frame and the configuration
    // setup above
    _webView = [[WKWebView alloc] initWithFrame:self.view.frame
                                  configuration:configuration];

    // Load the jsbin URL into the WKWebView and then add it as a sub-view.
    [_webView loadRequest:[NSURLRequest requestWithURL:jsbin]];
    [self.view addSubview:_webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Nothing else happens here
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {

    // Check to make sure the name is correct
    if ([message.name isEqualToString:@"observe"]) {
        // Log out the message received
        NSLog(@"Received event %@", message.body);

        // Then pull something from the device using the message body
        NSString *version = [[UIDevice currentDevice] valueForKey:message.body];

        // Execute some JavaScript using the result
        NSString *exec_template = @"set_headline(\"received: %@\");";
        NSString *exec = [NSString stringWithFormat:exec_template, version];
        [_webView evaluateJavaScript:exec completionHandler:nil];
    }
}

@end
