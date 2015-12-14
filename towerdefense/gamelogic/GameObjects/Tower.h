//
//  Tower.h
//  TowerDefense
//
//  Created by Adrian Wagner on 03.11.15.
//  Copyright © 2015 AdrianAlbi. All rights reserved.
//

#import "GameObject.h"
#import <SpriteKit/SpriteKit.h>

@interface Tower : GameObject

@property SKSpriteNode* baseSprite;
@property SKSpriteNode* topSprite;
@property SKShapeNode* rangeIndicatorSprite;

@property float secondsSinceLastBullet;

- (id)initForScene:(GameScene*)scene;

@end
