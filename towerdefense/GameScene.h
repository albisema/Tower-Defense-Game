//
//  GameScene.h
//  TowerDefense
//

//  Copyright (c) 2015 AdrianAlbi. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameLogic/GameObject.h"

@class GameObject;

@interface GameScene : SKScene

@property GameObject* cursorObject;

@property int levelRows;
@property int levelColumns;
@property NSMutableArray* levelGrid;
- (void)populateLevelGrid;
- (void)spawnGoal;
- (int)getLevelGridColumns;
- (int)getLevelGridRows;
- (NSArray*)getLevelGrid;

@property NSMutableArray* gameObjects;
@property NSMutableArray* gameObjectsToBeAdded;
@property NSMutableArray* gameObjectsToBeRemoved;
- (void)addGameObject:(GameObject*)object;
- (void)removeGameObject:(GameObject*)object;
- (NSArray*)getGameObjectsOfType:(Class)classType;
- (void)performGameObjectChanges;

@property CFTimeInterval lastTime;

@property int maxTowerCount;

@property double secondsSinceLastCreep;
@property double spawnRate;
- (void)spawnCreep;

@property int score;
@property SKLabelNode* scoreLabel;
- (void)addToScore:(int)points;

@property BOOL gameIsRunning;
- (void)gameOver;

@property BOOL shouldSpawnSniper;

@end
