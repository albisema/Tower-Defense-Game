//
//  GameObject.m
//  TowerDefense
//
//  Created by Adrian Wagner on 01.11.15.
//  Copyright © 2015 AdrianAlbi. All rights reserved.
//

#import "GameObject.h"

@implementation GameObject

@synthesize position;
@synthesize inScene;

- (id)initForScene:(GameScene*)scene;
{
    self = [super init];
    
    if (self != nil)
    {
        self.scene = scene;
        self.inScene = NO;
    }
    
    return self;
}

- (void)updateWithTimeDelta:(double)timeDelta
{
    return;
}


- (NSArray*)getSpriteNodes
{
    return [NSArray array];
}

- (void)setObjectInScene:(BOOL)inScene
{
    self.inScene = inScene;
}

@end
