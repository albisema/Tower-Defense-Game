//
//  GameScene.m
//  TowerDefense
//
//  Created by Adrian Wagner on 27.10.15.
//  Copyright (c) 2015 AdrianAlbi. All rights reserved.
//

#import "GameScene.h"
#import "EndScene.h"
#import "GameLogic/GameObjects/Tower.h"
#import "GameLogic/GameObjects/SniperTower.h"
#import "GameLogic/GameObjects/Creep.h"
#import "GameLogic/GameObjects/Goal.h"


@implementation GameScene

-(void)didMoveToView:(SKView *)view
{
    
    _gameObjects = [NSMutableArray array];
    _gameObjectsToBeAdded = [NSMutableArray array];
    _gameObjectsToBeRemoved = [NSMutableArray array];
    
    _levelRows = 12;
    _levelColumns = 16;
    _levelGrid = [NSMutableArray array];
    [self populateLevelGrid];
    
    _secondsSinceLastCreep = 0;
    _spawnRate = 300;
    
    _maxTowerCount = 15;
    
    _cursorObject = nil;
    
    _shouldSpawnSniper = NO;
    
    _score = 0;
    _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _scoreLabel.text = @"Score: 0";
    _scoreLabel.fontSize = 45;
    _scoreLabel.position = CGPointMake(120,723);
    _scoreLabel.zPosition = 100;
    [self addChild:_scoreLabel];
}

-(void)mouseDown:(NSEvent *)theEvent
{
    if (_cursorObject == nil)
    {
        return;
    }
    
    CGPoint location = [theEvent locationInNode:self];
    int row = (int)(location.y / 64);
    int column = (int)(location.x / 64);
    
    if ([[_levelGrid objectAtIndex:row * _levelColumns + column] isEqualTo:@1])
    {
        for (SKSpriteNode* node in [_cursorObject getSpriteNodes])
        {
            [node removeFromParent];
        }
        
        NSArray* towers = [self getGameObjectsOfType:[Tower class]];
        
        if ([towers count] == _maxTowerCount)
        {
            [self removeGameObject:[towers objectAtIndex:0]];
        }
        
        [self addGameObject:_cursorObject];
        [_levelGrid replaceObjectAtIndex:row * _levelColumns + column withObject:@2];
        _cursorObject = nil;
    }
    else if ([[_levelGrid objectAtIndex:row * _levelColumns + column] isEqualTo:@2])
    {
        NSArray* towers = [self getGameObjectsOfType:[SniperTower class]];
        
        for (SniperTower* tower in towers)
        {
            double dx = (tower.position.x - location.x);
            double dy = (tower.position.y - location.y);
            double distance = sqrt(dx * dx + dy * dy);
            
            if (distance < 32)
            {
                [tower changeDirection];
            }
        }
    }
}

-(void) mouseMoved:(NSEvent *)theEvent
{
    if (_cursorObject == nil)
    {
        if (_shouldSpawnSniper)
        {
            _cursorObject = [[SniperTower alloc] initForScene:self];
        }
        else
        {
            _cursorObject = [[Tower alloc] initForScene:self];
        }
        
        _shouldSpawnSniper = !_shouldSpawnSniper;
        
        _cursorObject.position = [theEvent locationInNode:self];
        
        for (SKSpriteNode* node in [_cursorObject getSpriteNodes])
        {
            [self addChild:node];
        }
    }
    
    CGPoint location = [theEvent locationInNode:self];
    location.x = (int)(location.x / 64) * 64 + 32;
    location.y = (int)(location.y / 64) * 64 + 32;
    _cursorObject.position = location;
    [_cursorObject updateWithTimeDelta:0];
    
    int row = (int)(location.y / 64);
    int column = (int)(location.x / 64);
    
    if (row * _levelColumns + column < _levelRows * _levelColumns &&
        row * _levelColumns + column > 0)
    {
        if ([[_levelGrid objectAtIndex:row * _levelColumns + column] isEqualTo:@1])
        {
            for (SKSpriteNode* node in [_cursorObject getSpriteNodes])
            {
                node.hidden = NO;
            }
        }
        else
        {
            for (SKSpriteNode* node in [_cursorObject getSpriteNodes])
            {
                node.hidden = YES;
            }
        }
    }
}

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
    
    if (_gameIsRunning)
    {
    
        double delta = currentTime - _lastTime;
        _lastTime = currentTime;
        
        // first frame has load times etc.
        if (delta > 1)
        {
            return;
        }
        
        if (_spawnRate > 30)
        {
            _spawnRate = _spawnRate - delta;
        }
    
        for (GameObject* object in _gameObjects)
        {
            [object updateWithTimeDelta:delta];
        }
    
        _secondsSinceLastCreep += delta;
    
        if (_secondsSinceLastCreep > 8 / 300.0 * _spawnRate)
        {
            [self spawnCreep];
            _secondsSinceLastCreep = 0;
        }
    
        [self performGameObjectChanges];
    }
}

- (void)addToScore:(int)points
{
    _score += points;
    
    _scoreLabel.text = [NSString stringWithFormat:@"%@ %@", @"Score:", [[NSNumber numberWithInt:_score] stringValue]];
}

-(void)spawnCreep
{
    for (int row = 0; row < _levelRows; row++)
    {
        if ([[_levelGrid objectAtIndex:row * _levelColumns] isEqualTo:@0])
        {
            GameObject* creep = [[Creep alloc] initForScene:self];
            creep.position = CGPointMake(1 , row * 64 + 32);
            ((Creep*)creep).speed = 300 - _spawnRate + 30;
            [self addGameObject:creep];
            
            break;
        }
    }
}

- (void)spawnGoal
{
    for (int row = 0; row < _levelRows; row++)
    {
        if ([[_levelGrid objectAtIndex:row * _levelColumns + _levelColumns - 1] isEqualTo:@0])
        {
            GameObject* goal = [[Goal alloc] initForScene:self];
            goal.position = CGPointMake((_levelColumns - 1) * 64 + 32 , row * 64 + 32);
            [self addGameObject:goal];
            
            break;
        }
    }
}

- (void)populateLevelGrid
{
    /* 0 = way, 1 = arable, 2 = tower already build */
    /*_levelGrid = [NSMutableArray arrayWithObjects:
                  @1, @1, @0, @0, @0, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1,
                  @1, @0, @0, @1, @0, @0, @1, @1, @0, @0, @0, @0, @0, @1, @1, @1,
                  @1, @0, @1, @1, @1, @0, @1, @1, @0, @1, @1, @1, @0, @1, @1, @1,
                  @1, @0, @0, @1, @1, @0, @1, @1, @0, @0, @0, @1, @0, @1, @1, @1,
                  @1, @1, @0, @1, @1, @0, @1, @1, @1, @1, @0, @1, @0, @1, @1, @1,
                  @0, @0, @0, @1, @1, @0, @1, @1, @0, @0, @0, @1, @0, @1, @1, @1,
                  @1, @1, @1, @1, @1, @0, @1, @1, @0, @1, @1, @1, @0, @0, @0, @1,
                  @1, @1, @1, @1, @1, @0, @1, @1, @0, @1, @1, @1, @1, @1, @0, @1,
                  @1, @1, @1, @1, @1, @0, @1, @1, @0, @1, @1, @1, @1, @1, @0, @0,
                  @1, @1, @1, @1, @1, @0, @0, @0, @0, @1, @1, @1, @1, @1, @1, @1,
                  @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1,
                  @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, nil];*/
    
    _levelGrid = [NSMutableArray array];
    
    for (int row = 0; row < _levelRows; row++)
    {
        for (int column = 0; column < _levelColumns; column++)
        {
            [_levelGrid addObject:@1];
        }
    }
    
    
    int lastRow = (arc4random() % (_levelRows - 2)) + 1;
    
    for (int column = 0; column < _levelColumns; column++)
    {
        [_levelGrid replaceObjectAtIndex:lastRow*_levelColumns+column withObject:@0];
        
        if (column == 0 || column == _levelColumns-1)
        {
            continue;
        }
        
        int direction = 0;
        BOOL nextColumn = NO;
        
        while (!nextColumn)
        {
            switch (arc4random() % 3)
            {
                case 0:
                    nextColumn = YES;
                    break;
                case 1:
                    if (direction != -1)
                    {
                        direction = 1;
                        lastRow += 1;
                        if (lastRow < _levelRows - 1)
                        {
                            if ([[_levelGrid objectAtIndex:lastRow * _levelColumns + column - 1] isEqualTo:@1])
                            {
                                [_levelGrid replaceObjectAtIndex:lastRow*_levelColumns+column withObject:@0];
                            }
                            else
                            {
                                lastRow--;
                            }
                        }
                        else
                        {
                            lastRow--;
                            nextColumn = YES;
                        }
                    }
                    break;
                case 2:
                    if (direction != 1)
                    {
                        direction = -1;
                        lastRow -= 1;
                        if (lastRow > 1)
                        {
                            if ([[_levelGrid objectAtIndex:lastRow * _levelColumns + column - 1] isEqualTo:@1])
                            {
                                [_levelGrid replaceObjectAtIndex:lastRow*_levelColumns+column withObject:@0];
                            }
                            else
                            {
                                lastRow++;
                            }
                        }
                        else
                        {
                            lastRow++;
                            nextColumn = YES;
                        }
                    }
                    break;
            }
        }
    }
    
    
    for (int row = 0; row < _levelRows; row++)
    {
        for (int column = 0; column < _levelColumns; column++)
        {
            if ([[_levelGrid objectAtIndex:row * _levelColumns + column] isEqualTo:@0])
            {
                SKSpriteNode* waySprite = [SKSpriteNode spriteNodeWithImageNamed:@"grass"];
                waySprite.color = [SKColor colorWithRed:0.7 green:0.35 blue:0.1 alpha:1];
                waySprite.colorBlendFactor = 1.0f;
                waySprite.position = CGPointMake(column * 64 + 32, row * 64 + 32);
                
                [self addChild:waySprite];
            }
            else
            {
                SKSpriteNode* grassSprite = [SKSpriteNode spriteNodeWithImageNamed:@"grass"];
                grassSprite.position = CGPointMake(column * 64 + 32, row * 64 + 32);
                
                [self addChild:grassSprite];
            }
        }
    }
    
    [self spawnGoal];
    _gameIsRunning = YES;
}

- (void)gameOver
{
    _gameIsRunning = NO;
    
    EndScene* end = [EndScene sceneWithSize:self.size];
    end.score = _score;
    [self.view presentScene:end transition:[SKTransition crossFadeWithDuration:2.0]];
}

- (void)addGameObject:(GameObject*)object
{
    [_gameObjectsToBeAdded addObject:object];
}

- (void)removeGameObject:(GameObject*)object
{
    [_gameObjectsToBeRemoved addObject:object];
}

- (void)performGameObjectChanges
{
    //adding
    for (GameObject* object in _gameObjectsToBeAdded)
    {
        if (![_gameObjects containsObject:object])
        {
            for (SKSpriteNode* node in [object getSpriteNodes])
            {
                [self addChild:node];
            }
        
            [object setObjectInScene:YES];
            [_gameObjects addObject:object];
        }
    }
    
    if ([_gameObjectsToBeAdded count] > 0)
    {
        _gameObjectsToBeAdded = [NSMutableArray array];
    }
    
    //removing
    for (GameObject* object in _gameObjectsToBeRemoved)
    {
        if ([_gameObjects containsObject:object])
        {
            for (SKSpriteNode* node in [object getSpriteNodes])
            {
                [node removeFromParent];
            }
        
            [_gameObjects removeObject:object];
            
            if ([object isKindOfClass:[Tower class]])
            {
                int row = (int)(object.position.y / 64);
                int column = (int)(object.position.x / 64);
                
                [_levelGrid replaceObjectAtIndex:row * _levelColumns + column withObject:@1];
            }
        }
    }
    
    if ([_gameObjectsToBeRemoved count] > 0)
    {
        _gameObjectsToBeRemoved = [NSMutableArray array];
    }
}

- (NSArray*)getGameObjectsOfType:(Class)classType
{
    NSMutableArray* returnArray = [NSMutableArray array];
    
    for (GameObject* object in _gameObjects)
    {
        if ([object isKindOfClass:classType])
        {
            [returnArray addObject:object];
        }
    }
    
    return returnArray;
}

- (int)getLevelGridColumns
{
    return _levelColumns;
}

- (int)getLevelGridRows
{
    return _levelRows;
}

- (NSArray*)getLevelGrid
{
    return _levelGrid;
}

@end
