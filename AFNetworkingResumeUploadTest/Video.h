//
//  Video.h
//  CrowdFlik
//
//  Created by Bobby Schuchert on 1/16/13.
//  Copyright (c) 2013 SPARC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject <NSCoding>

@property(nonatomic, strong) NSString *filePath;
@property(nonatomic, strong) NSString *mimeType;

@property(nonatomic, strong) NSString *thumbnailFilePath;
@property(nonatomic, strong) NSString *thumbnailMimeType;

@property(nonatomic, strong) NSString *userId;

@end
