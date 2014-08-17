//
//  MJUtil.h
//  Space Kitty
//
//  Created by Jeremy Adams on 8/16/14.
//  Copyright (c) 2014 MrJeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

static const int MJProjectileSpeed = 400;
static const int MJSpaceDogMinSpeed = -100;
static const int MJSpaceDogMaxSpeed = -50;
static const int MJMaxLives = 4;
static const int MJPointsPerHit = 100;

typedef NS_OPTIONS(uint32_t, MJCollisionCategory) {
    MJCollisionCategoryEnemy        = 1 << 0,   //0000
    MJCollisionCategoryProjectile   = 1 << 1,   //0010
    MJCollisionCategoryDebris       = 1 << 2,   //0100
    MJCollisionCategoryGround       = 1 << 3    //1000
};

@interface MJUtil : NSObject

+ (NSInteger) randomWithMin:(NSInteger)min max:(NSInteger)max;

@end
