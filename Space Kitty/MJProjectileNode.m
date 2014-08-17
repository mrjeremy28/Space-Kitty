//
//  MJProjectileNode.m
//  Space Kitty
//
//  Created by Jeremy Adams on 8/16/14.
//  Copyright (c) 2014 MrJeremy. All rights reserved.
//

#import "MJProjectileNode.h"
#import "MJUtil.h"


@implementation MJProjectileNode


+(instancetype) projectileAtPosition:(CGPoint)position {

    MJProjectileNode *projectile = [self spriteNodeWithImageNamed:@"projectile_1"];
    projectile.position = position;
    projectile.name = @"Projectile";
    
    [projectile setupAnimation];
    [projectile setupPhysicsBody];
    
    return  projectile;
}

-(void) setupAnimation {
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"projectile_1"],
                          [SKTexture textureWithImageNamed:@"projectile_2"],
                          [SKTexture textureWithImageNamed:@"projectile_3"]];
    
    SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    SKAction *repeatAction = [SKAction repeatActionForever:animation];
    [self runAction:repeatAction];
    
}

-(void) moveTowardsPosition:(CGPoint)position {
    //user touches x3,y3
    //slope = (y3 - y1) / (x3 - x1)
    
    float slope = (position.y - self.position.y) / (position.x - self.position.x);
    //slope = (y2 - y1) / (x2 - x1)
    // y2-y1 = slope*(x2 - x1)
    // y2  = slope * x2 - slope * x1 + y1
    
    float offscreenX;
    //is touch on left screen
    if ( position.x <= self.position.x) {
        offscreenX = -10;
    } else {
        offscreenX = self.parent.frame.size.width + 10;
    }
    
    float offscreenY = slope * offscreenX - slope * self.position.x + self.position.y;
    CGPoint pointOffscreen = CGPointMake(offscreenX, offscreenY);
    
    float distanceA = pointOffscreen.y - self.position.y;
    float distanceB = pointOffscreen.x - self.position.x;
    float distanceC = sqrtf(powf(distanceA, 2) + powf(distanceB, 2));
    
    // distance = speed * time
    // time = distance / speed
    
    float time = distanceC / MJProjectileSpeed ;
    float waitToFade = time * 0.75;
    float fadeTime = time - waitToFade;
    
    SKAction *moveProjectile = [SKAction moveTo:pointOffscreen duration:time];
    [self runAction:moveProjectile];
    
    NSArray *sequence = @[[SKAction waitForDuration:waitToFade],
                          [SKAction fadeOutWithDuration:fadeTime],
                          [SKAction removeFromParent]];
    [self runAction:[SKAction sequence:sequence]];
    
}

- (void) setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.categoryBitMask = MJCollisionCategoryProjectile;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = MJCollisionCategoryEnemy;


}

@end










