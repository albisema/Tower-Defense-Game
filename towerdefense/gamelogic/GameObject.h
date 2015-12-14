//
//  GameObject.h
//  TowerDefense
//
//  Created by Adrian Wagner on 01.11.15.
//  Copyright © 2015 AdrianAlbi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../GameScene.h"

@class GameScene;

@interface GameObject : NSObject

@property CGPoint position;
@property BOOL inScene;

@property GameScene* scene;

- (id)initForScene:(GameScene*)scene;
- (void)updateWithTimeDelta:(double)timeDelta;
- (void)setObjectInScene:(BOOL)inScene;
- (NSArray*)getSpriteNodes;

@end
