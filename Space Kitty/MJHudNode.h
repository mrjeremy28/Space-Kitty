//
//  MJHudNode.h
//  Space Kitty
//
//  Created by Jeremy Adams on 8/17/14.
//  Copyright (c) 2014 MrJeremy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MJHudNode : SKNode

@property (nonatomic) NSInteger lives;
@property (nonatomic) NSInteger score;

+ (instancetype) hudAtPosition:(CGPoint)position inFrame:(CGRect)frame;

- (void) addPoints:(NSInteger)points;
- (BOOL) loseLife;

@end
