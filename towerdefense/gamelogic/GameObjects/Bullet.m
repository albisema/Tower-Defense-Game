//
//  Bullet.m
//  TowerDefense
//
//  Created by iphone001 on 03/11/15.
//  Copyright © 2015 AdrianAlbi. All rights reserved.
//

#import "Bullet.h"
#import "Creep.h"

@implementation Bullet

@synthesize targetPosition;

- (id)initForScene:(GameScene*)scene;
{
    self = [super initForScene:scene];
    
    if (self != nil)
    {
        _bodySprite = [SKSpriteNode spriteNodeWithImageNamed:@"block"];
        _bodySprite.scale = 1;
        _bodySprite.alpha = 0;
        
        NSString *emitterPath = [[NSBundle mainBundle] pathForResource:@"BulletParticle" ofType:@"sks"];
        SKEmitterNode *bulletSpark = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterPath];
        bulletSpark.position = CGPointMake(0, 0);
        bulletSpark.targetNode = self.scene;
        bulletSpark.particleZPosition = 100;
        [_bodySprite addChild:bulletSpark];
    }
    
    return self;
}

- (void)updateWithTimeDelta:(double)timeDelta
{
    if (self.inScene)
    {
    }
    
    double dx = self.targetPosition.x - self.position.x;
    double dy = self.targetPosition.y - self.position.y;
    double distance = sqrt(dx * dx + dy * dy);
    
    if (distance > timeDelta * 180)
    {
        self.position = CGPointMake(self.position.x + dx / distance * timeDelta * 180, self.position.y + dy / distance * timeDelta * 180);
    }
    else
    {
        [self.scene removeGameObject:self];
    }
    
    
    NSArray* creeps = [self.scene getGameObjectsOfType:[Creep class]];
    
    for (Creep* creep in creeps)
    {
        double dx = (creep.position.x - self.position.x);
        double dy = (creep.position.y - self.position.y);
        double distance = sqrt(dx * dx + dy * dy);
        
        if (distance < 16)
        {
            [self.scene removeGameObject:self];
            [creep takeHit:1];
        }
    }
    
    //update sprite node positions
    [_bodySprite setPosition:self.position];
}

- (NSArray*)getSpriteNodes
{
    return [NSArray arrayWithObjects:_bodySprite, nil];
}

@end
