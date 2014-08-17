//
//  MJTitleSceen.m
//  Space Kitty
//
//  Created by Jeremy Adams on 8/16/14.
//  Copyright (c) 2014 MrJeremy. All rights reserved.
//

#import "MJTitleSceen.h"
#import "MJGamePlayScene.h"
#import <AVFoundation/AVFoundation.h>

@interface MJTitleSceen ()
@property (nonatomic) SKAction *pressStartSFX;
@property (nonatomic) AVAudioPlayer *backgroundMusic;


@end

@implementation MJTitleSceen


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
       /* Setup your scene here */
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"splash_1"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
       // background.anchorPoint = CGPointMake(0, 0);
        [self addChild:background];
        
        self.pressStartSFX = [SKAction playSoundFileNamed:@"PressStart.caf" waitForCompletion:NO];
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"StartScreen" withExtension:@"mp3"];
        
        self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        self.backgroundMusic.numberOfLoops = -1;
        [self.backgroundMusic prepareToPlay];
        
    }
    
    return self;
}

- (void) didMoveToView:(SKView *)view {
    [self.backgroundMusic play];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self runAction:self.pressStartSFX];
    [self.backgroundMusic stop];
    MJGamePlayScene *gamePlayScene = [MJGamePlayScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition fadeWithDuration:1.0];
    //SKTransition *transition = [SKTransition doorsOpenHorizontalWithDuration:1.0];
    
    [self.view presentScene:gamePlayScene transition:transition];
    
    
}

@end
