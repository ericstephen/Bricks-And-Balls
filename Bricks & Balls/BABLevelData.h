//
//  BABLevelData.h
//  Bricks & Balls
//
//  Created by Eric Williams on 8/8/14.
//  Copyright (c) 2014 Eric Williams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BABLevelData : NSObject

+ (BABLevelData *)mainData;

@property (nonatomic) int topScore;

@property (nonatomic) int currentLevel;

- (NSDictionary *)levelInfo;

@end
