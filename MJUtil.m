//
//  MJUtil.m
//  Space Kitty
//
//  Created by Jeremy Adams on 8/16/14.
//  Copyright (c) 2014 MrJeremy. All rights reserved.
//

#import "MJUtil.h"

@implementation MJUtil


+ (NSInteger) randomWithMin:(NSInteger)min max:(NSInteger)max {

    return arc4random()%(max - min) + min;
    
}

@end
