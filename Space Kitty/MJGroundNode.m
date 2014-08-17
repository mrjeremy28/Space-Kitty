//
//  MJGroundNode.m
//  Space Kitty
//
//  Created by Jeremy Adams on 8/16/14.
//  Copyright (c) 2014 MrJeremy. All rights reserved.
//

#import "MJGroundNode.h"
#import "MJUtil.h"

@implementation MJGroundNode


+ (instancetype) groundWithSize:(CGSize)size {
//    MJGroundNode *ground = [self spriteNodeWithColor:[SKColor greenColor] size:size];
    MJGroundNode *ground = [self spriteNodeWithColor:[SKColor clearColor] size:size];
    ground.name = @"Ground";
    ground.position = CGPointMake(size.width / 2, size.height / 2);
    [ground setupPhysicsBody];
    
    
    return ground;
}

- (void) setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.dynamic = NO;
    self.physicsBody.categoryBitMask = MJCollisionCategoryGround;
    self.physicsBody.collisionBitMask = MJCollisionCategoryDebris;
    self.physicsBody.contactTestBitMask = MJCollisionCategoryEnemy;
    
}

@end
