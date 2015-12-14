//
//  Bullet.h
//  TowerDefense
//
//  Created by iphone001 on 03/11/15.
//  Copyright © 2015 AdrianAlbi. All rights reserved.
//

#import "GameObject.h"

@interface Bullet : GameObject

@property SKSpriteNode* bodySprite;

@property CGPoint targetPosition;

- (id)initForScene:(GameScene*)scene;

@end
