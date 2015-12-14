//
//  EndScene.m
//  TowerDefense
//
//  Created by iphone001 on 03/11/15.
//  Copyright © 2015 AdrianAlbi. All rights reserved.
//

#import "EndScene.h"

@implementation EndScene

@synthesize score;

-(void)didMoveToView:(SKView *)view
{
    SKLabelNode* scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreLabel.text = [NSString stringWithFormat:@"%@ %@", @"Score:", [[NSNumber numberWithInt:score] stringValue]];
    scoreLabel.fontSize = 45;
    scoreLabel.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    scoreLabel.zPosition = 100;
    [self addChild:scoreLabel];
    
    SKLabelNode* restartLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    restartLabel.text = @"Play again!";
    restartLabel.fontSize = 30;
    restartLabel.position = CGPointMake(self.size.width / 2, -100);
    restartLabel.zPosition = 100;
    
    SKAction *action = [SKAction moveToY:self.size.height / 3 duration:1.0];
    
    [restartLabel runAction:action];
    [self addChild:restartLabel];
}

-(void)mouseDown:(NSEvent *)theEvent
{
    GameScene* game = [GameScene sceneWithSize:self.size];
    [self.view presentScene:game transition:[SKTransition crossFadeWithDuration:2.0]];
}

@end
