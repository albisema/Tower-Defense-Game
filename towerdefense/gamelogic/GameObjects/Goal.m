//
//  Goal.m
//  TowerDefense
//
//  Created by iphone001 on 03/11/15.
//  Copyright © 2015 AdrianAlbi. All rights reserved.
//

#import "Goal.h"
#import "Creep.h"

@implementation Goal

- (id)initForScene:(GameScene*)scene;
{
    self = [super initForScene:scene];
    
    if (self != nil)
    {
        _bodySprite = [SKSpriteNode spriteNodeWithImageNamed:@"crown"];
    }
    
    return self;
}

- (void)updateWithTimeDelta:(double)timeDelta
{    
    NSArray* creeps = [self.scene getGameObjectsOfType:[Creep class]];
    
    for (Creep* creep in creeps)
    {
        double dx = (creep.position.x - self.position.x);
        double dy = (creep.position.y - self.position.y);
        double distance = sqrt(dx * dx + dy * dy);
        
        if (distance < 32)
        {
            NSString *emitterPath = [[NSBundle mainBundle] pathForResource:@"GoalSmoke" ofType:@"sks"];
            SKEmitterNode *goalSmoke = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterPath];
            goalSmoke.position = CGPointMake(0, 0);
            goalSmoke.targetNode = self.scene;
            goalSmoke.particleZPosition = 100;
            [_bodySprite addChild:goalSmoke];
            
            [self.scene gameOver];
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
