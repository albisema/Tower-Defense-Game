//
//  SniperTower.h
//  TowerDefense
//
//  Created by Adrian Wagner on 04.11.15.
//  Copyright © 2015 AdrianAlbi. All rights reserved.
//

#import "GameObject.h"

@interface SniperTower : GameObject

@property SKSpriteNode* baseSprite;
@property SKSpriteNode* topSprite;

@property int direction;
- (void)changeDirection;

@property float secondsSinceLastBullet;

- (id)initForScene:(GameScene*)scene;

@end
