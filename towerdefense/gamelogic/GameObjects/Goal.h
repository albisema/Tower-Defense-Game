//
//  Goal.h
//  TowerDefense
//
//  Created by iphone001 on 03/11/15.
//  Copyright © 2015 AdrianAlbi. All rights reserved.
//

#import "GameObject.h"

@interface Goal : GameObject

@property SKSpriteNode* bodySprite;

- (id)initForScene:(GameScene*)scene;

@end
