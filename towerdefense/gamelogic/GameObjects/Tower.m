//
//  Tower.m
//  TowerDefense
//
//  Created by Adrian Wagner on 03.11.15.
//  Copyright © 2015 AdrianAlbi. All rights reserved.
//

#import "Tower.h"
#import "Creep.h"
#import "Bullet.h"

@implementation Tower

- (id)initForScene:(GameScene*)scene;
{
    self = [super initForScene:scene];
    
    if (self != nil)
    {
        _baseSprite = [SKSpriteNode spriteNodeWithImageNamed:@"towerbase"];
        _baseSprite.scale = 1;
        _baseSprite.zPosition = 91;
        _topSprite = [SKSpriteNode spriteNodeWithImageNamed:@"towertop"];
        _topSprite.scale = 1;
        _topSprite.zPosition = 92;
        _rangeIndicatorSprite = [SKShapeNode shapeNodeWithCircleOfRadius:128];
        _rangeIndicatorSprite.lineWidth = 1.0;
        _rangeIndicatorSprite.fillColor = [SKColor lightGrayColor];
        _rangeIndicatorSprite.strokeColor = [SKColor whiteColor];
        _rangeIndicatorSprite.alpha = 0.5;
        _rangeIndicatorSprite.glowWidth = 0.5;
        _rangeIndicatorSprite.zPosition = 90;
        
        _secondsSinceLastBullet = 20;
    }
    
    return self;
}

- (void)updateWithTimeDelta:(double)timeDelta
{
    if (self.inScene)
    {
        _secondsSinceLastBullet += timeDelta;
    
        NSArray* creeps = [self.scene getGameObjectsOfType:[Creep class]];
    
        for (Creep* creep in creeps)
        {
            double dx = (creep.position.x - self.position.x);
            double dy = (creep.position.y - self.position.y);
            double distance = sqrt(dx * dx + dy * dy);
        
            if (distance < 128)
            {
                SKAction *action = [SKAction rotateByAngle:(M_PI)*timeDelta duration:0];
                [_topSprite runAction:action];
            
                if (_secondsSinceLastBullet > 2)
                {
                    GameObject* bullet = [[Bullet alloc] initForScene:self.scene];
                    bullet.position = CGPointMake(self.position.x, self.position.y);
                    ((Bullet*)bullet).targetPosition = CGPointMake(creep.position.x, creep.position.y);
                
                    [self.scene addGameObject:bullet];
                
                    _secondsSinceLastBullet = 0;
                }
            
                break;
            }
        }
    }
    
    //update sprite node positions
    [_baseSprite setPosition:self.position];
    [_topSprite setPosition:self.position];
    [_rangeIndicatorSprite setPosition:self.position];
}

- (NSArray*)getSpriteNodes
{
    return [NSArray arrayWithObjects:_rangeIndicatorSprite, _baseSprite, _topSprite, nil];
}

- (void)setObjectInScene:(BOOL)inScene
{
    [super setObjectInScene:inScene];
    
    if (inScene)
    {
        _rangeIndicatorSprite.hidden = YES;
    }
    else
    {
        _rangeIndicatorSprite.hidden = NO;
    }
}

@end
