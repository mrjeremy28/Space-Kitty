//
//  MJMachineNode.m
//  Space Kitty
//
//  Created by Jeremy Adams on 8/16/14.
//  Copyright (c) 2014 MrJeremy. All rights reserved.
//

#import "MJMachineNode.h"

@implementation MJMachineNode


+(instancetype) machineAtPosition:(CGPoint)position {
    MJMachineNode *machine = [self spriteNodeWithImageNamed:@"machine_1"];
    machine.position = position;
    machine.zPosition = 9;
    machine.name = @"Machine";
    machine.anchorPoint = CGPointMake(0.5, 0);
    
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"machine_1"],
                          [SKTexture textureWithImageNamed:@"machine_2"]];
    
    SKAction *machineAnimation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    SKAction *machineRepeat = [SKAction repeatActionForever:machineAnimation];
    [machine runAction:machineRepeat];
    
    return machine;
    
}



@end
