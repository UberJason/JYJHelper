//
//  JYJNextBusViewController.m
//  JYJ Helper
//
//  Created by Jason Ji on 10/26/13.
//  Copyright (c) 2013 Jason Ji. All rights reserved.
//

#import "JYJNextBusViewController.h"

@interface JYJNextBusViewController ()

@property (strong, nonatomic) NSURL *bus23AHome;
@property (strong, nonatomic) NSURL *bus23AWork;

@end

@implementation JYJNextBusViewController

-(NSURL *)bus23AHome {
    if(!_bus23AHome)
        _bus23AHome = [NSURL URLWithString: @"http://www.nextbus.com/wireless/miniPrediction.shtml?a=wmata&r=23A&d=23A_23A_0&s=7385"];
    
    return _bus23AHome;
}

-(NSURL *)bus23AWork {
    if(!_bus23AWork) {
                _bus23AWork = [NSURL URLWithString: @"http://www.nextbus.com/wireless/miniPrediction.shtml?a=wmata&r=23A&d=23A_23A_1&s=14172"];
    }
    return _bus23AWork;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if(self.homeRequested) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.bus23AHome]];
        self.navBar.topItem.title = @"23A Home";
    }
    else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.bus23AWork]];
        self.navBar.topItem.title = @"23A Work";
    }
    
    self.navBar.barTintColor = [UIColor emeraldFlatColor];
    [self.navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navBar.barStyle = UIBarStyleBlackTranslucent;
}
- (IBAction)reload:(id)sender {
    NSLog(@"reload");
    
    [self.webView reload];
}
- (IBAction)dismiss:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}


@end
