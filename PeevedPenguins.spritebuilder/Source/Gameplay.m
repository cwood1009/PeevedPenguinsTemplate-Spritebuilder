//
//  Gameplay.m
//  PeevedPenguins
//
//  Created by Chris Wood on 7/14/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

#import "Gameplay.h"

@implementation Gameplay{
    CCPhysicsNode *_physicsNode;
    CCNode *_catapultArm;
    CCNode *_levelNode;
    CCNode *_contentNode;
    CCNode *_pullbackNode;
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = true;
    CCScene *level = [CCBReader loadAsScene:@"Levels/Level1"];
    [_levelNode addChild:level];
    _pullbackNode.physicsBody.collisionMask = @[];
    
   // _physicsNode.debugDraw = TRUE;
    
}

// called on every touch of the screen
- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    [self launchPenguin];
    
}

- (void) launchPenguin {
    // loads the penguin.bb we have setup in spritebuilder
    CCNode *penguin = [CCBReader load:@"Penguin"];
    
    //position penguin at bowl of catapult
    penguin.position = ccpAdd(_catapultArm.position, ccp(16,50));
    
    //add the penguin to physicsNode of this scene
    [_physicsNode addChild:penguin];
    
    //manuall create & apply force
    CGPoint launchDirection = ccp(1, 0);
    CGPoint force = ccpMult(launchDirection, 8000);
    [penguin.physicsBody applyForce:force];
    
    //follow penguin
    self.position = ccp(0,0);
    CCActionFollow *follow = [CCActionFollow actionWithTarget:penguin worldBoundary:self.boundingBox];
    [_contentNode runAction:follow];
    
}

-(void)retry {
    // reload the level
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"Gameplay"]];
    
}
@end
