//
//  MJSpaceDogNode.m
//  Space Kitty
//
//  Created by Jeremy Adams on 8/16/14.
//  Copyright (c) 2014 MrJeremy. All rights reserved.
//

#import "MJSpaceDogNode.h"
#import "MJUtil.h"

@implementation MJSpaceDogNode



+(instancetype) spaceDogOfType:(MJSpaceDogType)type {
    
    MJSpaceDogNode *spaceDog;
    spaceDog.damaged = NO;
    
    NSArray *textures;
    
    
    
    if (type == MJSpaceDogTypeA) {
        spaceDog = [self spriteNodeWithImageNamed:@"spacedog_A_1"];
        textures = @[[SKTexture textureWithImageNamed:@"spacedog_A_1"],
                     [SKTexture textureWithImageNamed:@"spacedog_A_2"]];
        spaceDog.type = MJSpaceDogTypeA;
    
    } else {
        spaceDog = [self spriteNodeWithImageNamed:@"spacedog_B_1"];
        textures = @[[SKTexture textureWithImageNamed:@"spacedog_B_1"],
                     [SKTexture textureWithImageNamed:@"spacedog_B_2"],
                     [SKTexture textureWithImageNamed:@"spacedog_B_3"]];
        spaceDog.type = MJSpaceDogTypeB;
    }
    
    float scale = [MJUtil randomWithMin:85 max:100] / 100.0f;
    spaceDog.xScale = scale;
    spaceDog.yScale = scale;
    
    SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    [spaceDog runAction:[SKAction repeatActionForever:animation] withKey:@"animation"];
    
    [spaceDog setupPhysicsBody];
    
    return spaceDog;
}

- (BOOL) isDamaged {
    NSArray *textures;
    if ( !_damaged) {
        [self removeActionForKey:@"animation"];
        
        if (self.type == MJSpaceDogTypeA) {
            textures = @[[SKTexture textureWithImageNamed:@"spacedog_A_3"]];
        }else {
            textures = @[[SKTexture textureWithImageNamed:@"spacedog_B_4"]];
        }
        SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:1.0];
        [self runAction:[SKAction repeatActionForever:animation] withKey:@"animation"];
        
        _damaged = YES;
        
        return NO;
    } else {
        return _damaged;
    }
}

- (void) setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.categoryBitMask = MJCollisionCategoryEnemy;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = MJCollisionCategoryProjectile | MJCollisionCategoryGround; // 0010 | 1000 = 1010

}

@end
