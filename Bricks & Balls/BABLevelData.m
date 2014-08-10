//
//  BABLevelData.m
//  Bricks & Balls
//
//  Created by Eric Williams on 8/8/14.
//  Copyright (c) 2014 Eric Williams. All rights reserved.
//

#import "BABLevelData.h"

@implementation BABLevelData
{
    NSArray * levels;
}


+ (BABLevelData *)mainData;
{
    static dispatch_once_t create;
    
    static BABLevelData * singleton = nil;
    
    dispatch_once(&create, ^{
        
        singleton = [[BABLevelData alloc] init];
        
    });
    
    return singleton;
}

- (id)init  // this allows us to sublass
{
    self = [super init];
    if (self)
    {
        levels = @[
                   @{
                       @"cols" : @6,
                       @"rows": @3
                       },
                   @{
                       @"cols": @7,
                       @"rows": @4
                       }
                   ];
    }
    return self;
}

- (NSDictionary *)levelInfo;
{
    return levels[self.currentLevel];
}

@end