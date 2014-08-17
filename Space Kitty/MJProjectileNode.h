//
//  MJProjectileNode.h
//  Space Kitty
//
//  Created by Jeremy Adams on 8/16/14.
//  Copyright (c) 2014 MrJeremy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MJProjectileNode : SKSpriteNode

+(instancetype) projectileAtPosition:(CGPoint)position;


-(void) moveTowardsPosition:(CGPoint)position ;


@end
