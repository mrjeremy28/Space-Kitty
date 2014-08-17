//
//  MJSpaceDogNode.h
//  Space Kitty
//
//  Created by Jeremy Adams on 8/16/14.
//  Copyright (c) 2014 MrJeremy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, MJSpaceDogType) {
    MJSpaceDogTypeA = 0,
    MJSpaceDogTypeB = 1
    
};
@interface MJSpaceDogNode : SKSpriteNode

@property (nonatomic, getter = isDamaged) BOOL damaged;
@property (nonatomic) MJSpaceDogType type;

+(instancetype) spaceDogOfType:(MJSpaceDogType)type;

@end
