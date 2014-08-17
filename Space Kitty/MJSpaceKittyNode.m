//
//  MJSpaceKittyNode.m
//  Space Kitty
//
//  Created by Jeremy Adams on 8/16/14.
//  Copyright (c) 2014 MrJeremy. All rights reserved.
//

#import "MJSpaceKittyNode.h"

@interface MJSpaceKittyNode ()
@property (nonatomic) SKAction *tapAction;
@end


@implementation MJSpaceKittyNode
+(instancetype) spaceKittyAtPosition:(CGPoint)position {
    MJSpaceKittyNode *spaceCat = [self spriteNodeWithImageNamed:@"spacecat_1"];
    spaceCat.position = position;
    spaceCat.zPosition = 10;
    spaceCat.anchorPoint = CGPointMake(0.5, 0);
    spaceCat.name = @"SpaceCat";
    
    return spaceCat;
    
}

- (SKAction *) tapAction {
    
    if (_tapAction != nil ) {
        return _tapAction;
    }
    
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"spacecat_2"],
                          [SKTexture textureWithImageNamed:@"spacecat_1"]];
    _tapAction = [SKAction animateWithTextures:textures timePerFrame:0.25];
    return _tapAction;
}


- (void) performTap {
    [self runAction:self.tapAction];
}

@end
