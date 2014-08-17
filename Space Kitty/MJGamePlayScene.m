//
//  MJGamePlayScene.m
//  Space Kitty
//
//  Created by Jeremy Adams on 8/16/14.
//  Copyright (c) 2014 MrJeremy. All rights reserved.
//
// Touch: (x3,y3)
// end Point (-10, y2) or for Right (ScreenWIdth +10, y2)
// Slope: (y3-y1) / (x3-x1)
// Point Slop Line Equation: y2 - y1 = slope*(x2 - x1)
//
//

#import "MJGamePlayScene.h"
#import "MJMachineNode.h"
#import "MJSpaceKittyNode.h"
#import "MJProjectileNode.h"
#import "MJSpaceDogNode.h"
#import "MJGroundNode.h"
#import "MJUtil.h"
#import <AVFoundation/AVFoundation.h>
#import "MJHudNode.h"
#import "MJGameOverNode.h"


@interface MJGamePlayScene ()
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval timeSinceEnemyAdded;
@property (nonatomic) NSTimeInterval totalGameTime;
@property (nonatomic) NSInteger minSpeed;
@property (nonatomic) NSTimeInterval addEnemyTimeInterval;

@property (nonatomic) SKAction *damageSFX;
@property (nonatomic) SKAction *explodeSFX;
@property (nonatomic) SKAction *laserSFX;
@property (nonatomic) SKAction *glassSFX;
@property (nonatomic) AVAudioPlayer *backgroundMusic;
@property (nonatomic) AVAudioPlayer *gameOverMusic;
@property (nonatomic) BOOL gameOver;
@property (nonatomic) BOOL restart;
@property (nonatomic) BOOL gameOverDisplayed;

@end

@implementation MJGamePlayScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        self.lastUpdateTimeInterval = 0;
        self.timeSinceEnemyAdded = 0;
        self.addEnemyTimeInterval = 1.5;
        self.totalGameTime = 0;
        self.restart = NO;
        self.gameOver = NO;
        self.gameOverDisplayed = NO;
        self.minSpeed = MJSpaceDogMinSpeed;
        
        /* Setup your scene here */
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background_1"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        // background.anchorPoint = CGPointMake(0, 0);
        [self addChild:background];
        
        
        MJMachineNode *machine = [MJMachineNode machineAtPosition:CGPointMake(CGRectGetMidX(self.frame), 12)];
        
        [self addChild:machine];
        
        MJSpaceKittyNode *spaceCat = [MJSpaceKittyNode spaceKittyAtPosition:CGPointMake(machine.position.x, machine.position.y -2)];
        
        [self addChild:spaceCat];
        
        
        
        self.physicsWorld.gravity = CGVectorMake(0, -9.8);
        self.physicsWorld.contactDelegate = self;
        MJGroundNode *ground = [MJGroundNode groundWithSize:CGSizeMake(self.frame.size.width, 22)];
        [self addChild:ground];
        [self setupSounds];
        
        MJHudNode *hud = [MJHudNode hudAtPosition:CGPointMake(0, self.frame.size.height - 20) inFrame:self.frame];
        [self addChild:hud];
        
    }
    
    return self;
}

- (void) didMoveToView:(SKView *)view {
    [self.backgroundMusic play];
}

- (void) setupSounds {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Gameplay" withExtension:@"mp3"  ];
    self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.backgroundMusic.numberOfLoops = -1;
    self.backgroundMusic.volume = 0.2;
    [self.backgroundMusic prepareToPlay];
    
    NSURL *gameOverurl = [[NSBundle mainBundle] URLForResource:@"GameOver" withExtension:@"mp3"  ];
    self.gameOverMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:gameOverurl error:nil];
    self.gameOverMusic.numberOfLoops = 0;
    [self.gameOverMusic prepareToPlay];
    
    
    
    self.damageSFX = [SKAction playSoundFileNamed:@"Damage.caf" waitForCompletion:NO];
    self.explodeSFX = [SKAction playSoundFileNamed:@"Explode.caf" waitForCompletion:NO];
    self.laserSFX = [SKAction playSoundFileNamed: @"Laser.caf" waitForCompletion:NO];
    self.glassSFX = [SKAction playSoundFileNamed:@"Glass.caf" waitForCompletion:NO];
    
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.gameOver) {
    for (UITouch *touch in touches) {
        CGPoint position = [touch locationInNode:self];
        [self shootProjectileTowardsPosition:position];
        }
    } else if ( self.restart ) {
        for (SKNode *node in [self children]) {
            [node removeFromParent];
        }
        
        MJGamePlayScene *scene = [MJGamePlayScene sceneWithSize:self.view.bounds.size];
        [self.view presentScene:scene];
    }
    
    
    
}

- (void) performGameOver {
    MJGameOverNode *gameOver = [MJGameOverNode gameOverAtPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
    for (SKNode *node in [self children]) {
        if ([node.name isEqualToString:@"Debris"]) {
        
            [node removeFromParent];
        }
        NSLog(@"NOde: %@",node);
        
    }
    
    [self addChild:gameOver];
    self.restart = YES;
    self.gameOverDisplayed = YES;
    [gameOver performAnimation];
    
   
    
    [self.backgroundMusic stop];
    [self.gameOverMusic play];
}


-(void) shootProjectileTowardsPosition:(CGPoint)position {
    MJSpaceKittyNode *spaceCat = (MJSpaceKittyNode*)[self childNodeWithName:@"SpaceCat"];
    [spaceCat performTap];
    
    MJMachineNode *machine = (MJMachineNode *)[self childNodeWithName:@"Machine"];

    MJProjectileNode *projectile = [MJProjectileNode projectileAtPosition:CGPointMake(machine.position.x, machine.position.y + machine.frame.size.height - 15 )];
    [self addChild:projectile];
    
    [projectile moveTowardsPosition:position];
    [self runAction:self.laserSFX];
    
}

-(void) addSpaceDog {
//    MJSpaceDogNode *spaceDogA = [MJSpaceDogNode spaceDogOfType:MJSpaceDogTypeA];
//    spaceDogA.position = CGPointMake(100, 300);
//    [self addChild:spaceDogA];
//    
//    MJSpaceDogNode *spaceDogB = [MJSpaceDogNode spaceDogOfType:MJSpaceDogTypeB];
//    spaceDogB.position = CGPointMake(200, 300);
//    [self addChild:spaceDogB];
//    
    NSUInteger randomSpaceDog = [MJUtil randomWithMin:0 max:2];
    MJSpaceDogNode *spaceDog = [MJSpaceDogNode spaceDogOfType:randomSpaceDog];
    float dy = [MJUtil randomWithMin:MJSpaceDogMinSpeed max:MJSpaceDogMaxSpeed];
    spaceDog.physicsBody.velocity = CGVectorMake(0,dy);

    
    float y = self.frame.size.height + spaceDog.size.height;
    float x = [MJUtil randomWithMin:10 + spaceDog.size.width max:self.frame.size.width - spaceDog.size.width - 10];
    
    spaceDog.position = CGPointMake(x, y);
    [self addChild:spaceDog];
    
    
}

- (void) update:(NSTimeInterval)currentTime {

    if (self.lastUpdateTimeInterval) {
        self.timeSinceEnemyAdded += currentTime - self.lastUpdateTimeInterval;
        self.totalGameTime += currentTime - self.lastUpdateTimeInterval;
    }
    
    // 1.0 is pretty fast
    if (self.timeSinceEnemyAdded > self.addEnemyTimeInterval && !self.gameOver) {
        [self addSpaceDog];
        self.timeSinceEnemyAdded = 0;
    }
    self.lastUpdateTimeInterval = currentTime;
    
    
    if ( self.totalGameTime > 480 ) {
        // 480 / 60 = 8 minutes
        self.addEnemyTimeInterval = 0.50;
        self.minSpeed = -160;
    } else if (self.totalGameTime > 240) {
        //240 / 60 = 4 mins
        self.addEnemyTimeInterval = 0.65;
        self.minSpeed = -150;
    } else if (self.totalGameTime > 120) {
        // 120 / 60 = 2 mins
        self.addEnemyTimeInterval = 0.75;
        self.minSpeed = -125;
    } else if (self.totalGameTime > 30) {
        // half a min.
        self.addEnemyTimeInterval = 1.0;
        self.minSpeed = -100;
    }
    
    if (self.gameOver && !self.gameOverDisplayed ) {
        [self performGameOver];
    }
    
    
}


-(void) didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
        
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    
    
    if (firstBody.categoryBitMask == MJCollisionCategoryEnemy && secondBody.categoryBitMask == MJCollisionCategoryProjectile) {
        NSLog(@"BAMM!!");
        MJSpaceDogNode *spaceDog = (MJSpaceDogNode *)firstBody.node;
        MJProjectileNode *projectile = (MJProjectileNode *)secondBody.node;
        
        [self addPoints:MJPointsPerHit];
        
        if ( [spaceDog isDamaged]) {
        [self runAction:self.explodeSFX];
        
        [spaceDog removeFromParent];
        [projectile removeFromParent];
        [self createDebrisAtPosition:contact.contactPoint];
        } else {
            
            [self runAction:self.glassSFX];
        }
        
    }
    else if (firstBody.categoryBitMask == MJCollisionCategoryEnemy &&
             secondBody.categoryBitMask == MJCollisionCategoryGround) {
        NSLog(@"Hit Ground");
        
        
        if (!self.gameOver && !self.gameOverDisplayed ) {
        [self runAction:self.damageSFX];
        }
        
         MJSpaceDogNode *spaceDog = (MJSpaceDogNode *)firstBody.node;
        [spaceDog removeFromParent];
        [self loseLife];
        
        [self createDebrisAtPosition:contact.contactPoint];
    }
    
    
    
}

- (void) loseLife {
    MJHudNode *hud = (MJHudNode*)[self childNodeWithName:@"HUD"];
    self.gameOver = [hud loseLife];
}

- (void) addPoints:(NSInteger)points {
    
    MJHudNode *hud = (MJHudNode*)[self childNodeWithName:@"HUD"];
    [hud addPoints:points];
    
}

- (void) createDebrisAtPosition:(CGPoint)position {
    NSInteger numberOfPieces = [MJUtil  randomWithMin:5 max:20];
    
    
    
    for (int i=0; i<numberOfPieces; i++) {
        NSInteger randomPiece = [MJUtil randomWithMin:1 max:4];
        NSString *imageName = [NSString stringWithFormat:@"debri_%d",randomPiece];
        SKSpriteNode *debris = [SKSpriteNode spriteNodeWithImageNamed:imageName];
        debris.position = position;
        [self addChild:debris];
        
        debris.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:debris.frame.size];
        debris.physicsBody.categoryBitMask = MJCollisionCategoryDebris;
        debris.physicsBody.contactTestBitMask = 0;
        debris.physicsBody.collisionBitMask = MJCollisionCategoryGround | MJCollisionCategoryDebris;
        debris.name = @"Debris";
        debris.physicsBody.velocity = CGVectorMake([MJUtil randomWithMin:-150 max:150], [MJUtil randomWithMin:150 max:350]);
        
        
//        [debris runAction:[SKAction waitForDuration:2.0] completion:^{
//            [debris removeFromParent];
//        }];
        
         // If you want fading on debris
         NSArray *sequence = @[[SKAction waitForDuration:1.0],
         [SKAction fadeOutWithDuration:1.0]];
         [debris runAction:[SKAction sequence:sequence]completion:^{
         [debris removeFromParent];
         }];
        
    }
    
    //create emitter node
    NSString *explosionPath = [[NSBundle mainBundle] pathForResource:@"Explosion" ofType:@"sks" ];
    
    SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath];
    
    explosion.position = position;
    [self addChild:explosion];
    
    [explosion runAction:[SKAction waitForDuration:2.0] completion:^{
        [explosion removeFromParent];
    }];
    
    
}

@end
