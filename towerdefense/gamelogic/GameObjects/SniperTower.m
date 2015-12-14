//
//  SniperTower.m
//  TowerDefense
//
//  Created by Adrian Wagner on 04.11.15.
//  Copyright © 2015 AdrianAlbi. All rights reserved.
//

#import "SniperTower.h"
#import "Creep.h"

@implementation SniperTower

- (id)initForScene:(GameScene*)scene;
{
    self = [super initForScene:scene];
    
    if (self != nil)
    {
        _baseSprite = [SKSpriteNode spriteNodeWithImageNamed:@"towerbase"];
        _baseSprite.scale = 1;
        _topSprite = [SKSpriteNode spriteNodeWithImageNamed:@"aimtower"];
        _topSprite.scale = 1;
        
        // 3 = up, 0 = right, 1 = down, 2 = left
        _direction = 0;
        
        _secondsSinceLastBullet = 20;
    }
    
    return self;
}

- (void)updateWithTimeDelta:(double)timeDelta
{
    if (self.inScene)
    {
        _secondsSinceLastBullet += timeDelta;
                
        if (_secondsSinceLastBullet > 2)
        {            
            NSString *emitterPath = [[NSBundle mainBundle] pathForResource:@"SniperShot" ofType:@"sks"];
            SKEmitterNode *bulletSpark = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterPath];
            
            switch (_direction % 4)
            {
                case 0:
                    bulletSpark.position = CGPointMake(512, 0);
                    bulletSpark.particlePositionRange = CGVectorMake(1024, 0);
                    break;
                
                case 1:
                    bulletSpark.position = CGPointMake(0, 512);
                    bulletSpark.particlePositionRange = CGVectorMake(0, 1024);
                    break;
                    
                case 2:
                    bulletSpark.position = CGPointMake(-512, 0);
                    bulletSpark.particlePositionRange = CGVectorMake(1024, 0);
                    break;
                    
                case 3:
                    bulletSpark.position = CGPointMake(0, -512);
                    bulletSpark.particlePositionRange = CGVectorMake(0, 1024);
                    break;
            }
            
            bulletSpark.targetNode = self.scene;
            bulletSpark.particleZPosition = 100;
            [_baseSprite addChild:bulletSpark];
            
            NSArray* creeps = [self.scene getGameObjectsOfType:[Creep class]];
            
            for (Creep* creep in creeps)
            {
                switch (_direction % 4)
                {
                    case 0:
                        if (fabs(creep.position.y - self.position.y) < 20 &&
                            creep.position.x > self.position.x)
                        {
                            [creep takeHit:1];
                        }
                        break;
                        
                    case 1:
                        if (fabs(creep.position.x - self.position.x) < 20 &&
                            creep.position.y > self.position.y)
                        {
                            [creep takeHit:1];
                        }
                        break;
                        
                    case 2:
                        if (fabs(creep.position.y - self.position.y) < 20 &&
                            creep.position.x < self.position.x)
                        {
                            [creep takeHit:1];
                        }
                        break;
                        
                    case 3:
                        if (fabs(creep.position.x - self.position.x) < 20 &&
                            creep.position.y < self.position.y)
                        {
                            [creep takeHit:1];
                        }
                        break;
                }
            }
                    
            _secondsSinceLastBullet = 0;
        }
    }
    
    //update sprite node positions
    [_baseSprite setPosition:self.position];
    [_topSprite setPosition:self.position];
}

- (NSArray*)getSpriteNodes
{
    return [NSArray arrayWithObjects:_baseSprite, _topSprite, nil];
}

- (void)changeDirection
{
    _direction++;
    
    SKAction *action = [SKAction rotateToAngle:(M_PI/2)*_direction duration:0.3];
    [_topSprite runAction:action];
}

@end
