//
//  Creep.h
//  TowerDefense
//
//  Created by Adrian Wagner on 03.11.15.
//  Copyright © 2015 AdrianAlbi. All rights reserved.
//

#import "GameObject.h"
#import <SpriteKit/SpriteKit.h>

@interface Creep : GameObject

@property SKSpriteNode* bodySprite;

@property int lastGridIndex;
@property int nextGridIndex;
@property int nextX;
@property int nextY;

- (id)initForScene:(GameScene*)scene;

@property int startingLife;
@property int life;
- (void)takeHit:(int)intensity;

@property double speed;

@end
