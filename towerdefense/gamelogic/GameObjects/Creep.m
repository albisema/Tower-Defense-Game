//
//  Creep.m
//  TowerDefense
//
//  Created by Adrian Wagner on 03.11.15.
//  Copyright © 2015 AdrianAlbi. All rights reserved.
//

#import "Creep.h"

@implementation Creep

@synthesize speed;

- (id)initForScene:(GameScene*)scene;
{
    self = [super initForScene:scene];
    
    if (self != nil)
    {
        _bodySprite = [SKSpriteNode spriteNodeWithImageNamed:@"creep"];
        _bodySprite.scale = 1;
        
        _lastGridIndex = -1;
        _nextGridIndex = -1;
        
        _life = 5;
        _startingLife = 5;
        
        self.speed = 30;
    }
    
    return self;
}

- (void)updateWithTimeDelta:(double)timeDelta
{
    if (_lastGridIndex == -1)
    {
        int row = (int)(self.position.y / 64);
        int column = (int)(self.position.x / 64);
        
        _lastGridIndex = row * [self.scene getLevelGridColumns] + column;
        _nextGridIndex = row * [self.scene getLevelGridColumns] + column;
        _nextX = column * 64 + 32;
        _nextY = row * 64 + 32;
    }
    
    NSArray* levelGrid = [self.scene getLevelGrid];
    
    if (fabs(self.position.x - _nextX) < timeDelta * self.speed && fabs(self.position.y - _nextY) < timeDelta * self.speed)
    {
        if (_nextGridIndex+1 != _lastGridIndex &&
            [[levelGrid objectAtIndex:_nextGridIndex+1] isEqualTo:@0])
        {
            _nextX += 64;
            _lastGridIndex = _nextGridIndex;
            _nextGridIndex += 1;
        }
        else if (_nextGridIndex-1 != _lastGridIndex &&
                 [[levelGrid objectAtIndex:_nextGridIndex-1] isEqualTo:@0])
        {
            _nextX -= 64;
            _lastGridIndex = _nextGridIndex;
            _nextGridIndex -= 1;
        }
        else if (_nextGridIndex-[self.scene getLevelGridColumns] != _lastGridIndex &&
                 [[levelGrid objectAtIndex:_nextGridIndex-[self.scene getLevelGridColumns]] isEqualTo:@0])
        {
            _nextY -= 64;
            _lastGridIndex = _nextGridIndex;
            _nextGridIndex -= [self.scene getLevelGridColumns];
        }
        else if (_nextGridIndex+[self.scene getLevelGridColumns] != _lastGridIndex &&
                 [[levelGrid objectAtIndex:_nextGridIndex+[self.scene getLevelGridColumns]] isEqualTo:@0])
        {
            _nextY += 64;
            _lastGridIndex = _nextGridIndex;
            _nextGridIndex += [self.scene getLevelGridColumns];
        }
    }
    else
    {
        
        if (timeDelta > 1)
        {
            return;
        }
        double newX;
        double newY;
        
        if (_nextX < self.position.x)
        {
            newX = self.position.x - timeDelta * self.speed;
        }
        else
        {
            newX = self.position.x + timeDelta * self.speed;
        }
        
        if (_nextY < self.position.y)
        {
            newY = self.position.y - timeDelta * self.speed;
        }
        else
        {
            newY = self.position.y + timeDelta * self.speed;
        }
        
        
        self.position = CGPointMake(newX, newY);
    }
    
    //update sprite node positions
    [_bodySprite setPosition:self.position];
}

- (NSArray*)getSpriteNodes
{
    return [NSArray arrayWithObjects:_bodySprite, nil];
}

- (void)takeHit:(int)intensity
{
    _life -= intensity;
    
    float redIndicator = 1 * (1.0 - ((float)_life / (float)_startingLife));
    
    _bodySprite.color = [SKColor colorWithRed:redIndicator green:1-redIndicator blue:0 alpha:1];
    _bodySprite.colorBlendFactor = 0.7f;
    
    if (_life <= 0)
    {
        NSString *emitterPath = [[NSBundle mainBundle] pathForResource:@"CreepDeath" ofType:@"sks"];
        SKEmitterNode *blood = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterPath];
        blood.position = CGPointMake(self.position.x, self.position.y);
        blood.targetNode = self.scene;
        blood.particleZPosition = 100;
        [self.scene addChild:blood];
        
        [self.scene addToScore:1];
        [self.scene removeGameObject:self];
    }
}

@end
