//
//  Video.m
//  CrowdFlik
//
//  Created by Bobby Schuchert on 1/16/13.
//  Copyright (c) 2013 SPARC. All rights reserved.
//

#import "Video.h"

@implementation Video

-(void) encodeWithCoder: (NSCoder*) coder {
    
    [coder encodeObject: self.filePath forKey: @"filePath"];
    [coder encodeObject: self.mimeType forKey: @"mimeType"];
    [coder encodeObject: self.thumbnailFilePath forKey: @"thumbnailFilePath"];
    [coder encodeObject: self.thumbnailMimeType forKey: @"thumbnailMimeType"];
    [coder encodeObject: self.userId forKey: @"userId"];
}

-(id) initWithCoder: (NSCoder*) coder {
    self = [super init];
    if ( ! self) return nil;
        self.filePath = [coder decodeObjectForKey:@"filePath"];
        self.mimeType = [coder decodeObjectForKey:@"mimeType"];
        self.thumbnailFilePath = [coder decodeObjectForKey:@"thumbnailFilePath"];
        self.thumbnailMimeType = [coder decodeObjectForKey:@"thumbnailMimeType"];
        self.userId = [coder decodeObjectForKey:@"userId"];
    return self;
}


@end
