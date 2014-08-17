//
//  MJGameOverNode.h
//  Space Kitty
//
//  Created by Jeremy Adams on 8/17/14.
//  Copyright (c) 2014 MrJeremy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MJGameOverNode : SKNode

+ (instancetype) gameOverAtPosition:(CGPoint)position;

- (void) performAnimation;

@end
