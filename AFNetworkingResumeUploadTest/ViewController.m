//
//  ViewController.m
//  AFNetworkingResumeUploadTest
//
//  Created by Bobby Schuchert on 4/16/13.
//  Copyright (c) 2013 SPARC. All rights reserved.
//

#import "ViewController.h"
#import "Video.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

@interface ViewController ()
@property (nonatomic) BOOL isSuspended;
@property (strong) NSMutableArray *objectsToUpload;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.objectsToUpload = [NSMutableArray arrayWithCapacity:2];
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 1;
    
    //lets start in a paused state
    [self pauseUploads];
    
    
    //populate our array of objects
    [self.objectsToUpload addObject: [self generateTestVideo]];
    [self populateOperationQueueWithUploadObjects];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Test Object Creation

-(Video *)generateTestVideo {
    
    Video *video = [[Video alloc] init];
    
    video.filePath = [[NSBundle mainBundle] pathForResource:@"A11Landing" ofType:@"mov"];
    video.mimeType = @"video/quicktime";
    
    video.thumbnailFilePath = [[NSBundle mainBundle] pathForResource:@"PIA16884" ofType:@"jpg"];
    video.thumbnailMimeType = @"image/jpeg";
    
    video.userId = @"867-5309";
    
    return video;
}



#pragma mark - Pause/Resume Controls

-(IBAction)pauseResumeButtonPressed:(id)sender {
    if (self.isSuspended) {
        [self resumeUploads];
    } else {
        [self pauseUploads];
        
    }
}

-(void)pauseUploads {
    NSLog(@"Pausing Upload Operation");
    self.isSuspended = YES;
    [self.operationQueue setSuspended:YES];
    
    //force the operation to pause now
    if ([self.operationQueue.operations count] > 0) {
        AFHTTPRequestOperation *topOperation = (AFHTTPRequestOperation *)[self.operationQueue.operations objectAtIndex:0];
        [topOperation pause];
    }
    
    //update the button
    [self.pauseButton setTitle:@"RESUME UPLOAD" forState:UIControlStateNormal];
    
}


-(void)resumeUploads {
    NSLog(@"Resuming Upload Operation");
    self.isSuspended = NO;
    [self.operationQueue setSuspended:NO];
    
    //force the operation to resume (or restart)
    if ([self.operationQueue.operations count] > 0) {
        AFHTTPRequestOperation *topOperation = (AFHTTPRequestOperation *)[self.operationQueue.operations objectAtIndex:0];
        [topOperation resume];
    }
    
    //update the button
    [self.pauseButton setTitle:@"PAUSE UPLOAD" forState:UIControlStateNormal];
}



#pragma mark - Upload Operation


-(void)populateOperationQueueWithUploadObjects {
    
    NSURL *url = [NSURL URLWithString:@"http://posttestserver.com/"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    
    for (Video *currentVideo in self.objectsToUpload) {
        NSData *videoData = [NSData dataWithContentsOfFile:currentVideo.filePath];
        NSData *thumbnailData = [NSData dataWithContentsOfFile:currentVideo.thumbnailFilePath];
        
        
        NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"post.php?dir=AFUpload" parameters:nil
                                                        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
                        [formData appendPartWithFileData:videoData name:@"file" fileName:@"video" mimeType:currentVideo.mimeType];
                        [formData appendPartWithFileData:thumbnailData name:@"thumbnail" fileName:@"thumbnail" mimeType:currentVideo.thumbnailMimeType];
                        [formData appendPartWithFormData:[currentVideo.userId dataUsingEncoding:NSUTF8StringEncoding] name:@"userId"];

        }];
        
        
        // create our operation
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        //handle progress
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
        }];
        
        // handle completion
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString *response = [operation responseString];
            NSLog(@"response: [%@]",response);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Upload Failure");
        }];
        
        
        [self.operationQueue addOperation:operation];

    }
    
}









@end
