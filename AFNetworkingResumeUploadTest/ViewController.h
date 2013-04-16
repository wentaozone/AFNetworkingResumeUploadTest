//
//  ViewController.h
//  AFNetworkingResumeUploadTest
//
//  Created by Bobby Schuchert on 4/16/13.
//  Copyright (c) 2013 SPARC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFHTTPRequestOperation;

@interface ViewController : UIViewController


@property(nonatomic, weak) IBOutlet UIButton *pauseButton;
-(IBAction)pauseResumeButtonPressed:(id)sender;

@end
