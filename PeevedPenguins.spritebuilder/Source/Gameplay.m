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
    CCNode *_mouseJointNode;
    CCPhysicsJoint *_mouseJoint;
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = true;
    CCScene *level = [CCBReader loadAsScene:@"Levels/Level1"];
    [_levelNode addChild:level];
    _pullbackNode.physicsBody.collisionMask = @[];
    
   // _physicsNode.debugDraw = TRUE;
    _mouseJointNode.physicsBody.collisionMask = @[];
    
}

// called on every touch of the screen
- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    //[self launchPenguin];
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    
    // start catapult dragging
    if (CGRectContainsPoint([_catapultArm boundingBox], touchLocation)) {
        // mouve the mouseJointNode to the touch position
        _mouseJointNode.position = touchLocation;
        
        // setup a spring joint between the mousejoint node and catapult
        _mouseJoint = [CCPhysicsJoint connectedSpringJointWithBodyA:_mouseJointNode.physicsBody bodyB:_catapultArm.physicsBody anchorA:ccp(0,0) anchorB:ccp(34,138) restLength:0.f stiffness:3000.f damping:150.f];
        
    }
    
    
}

- (void) touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event    {
    // when touches move update position of mousejoint node
    
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    _mouseJointNode.position = touchLocation;
    
}

- (void) releaseCatapult {
    if (_mouseJoint !=nil) {
        [_mouseJoint invalidate];
        _mouseJoint = nil;
    }
}

- (void) touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    [self releaseCatapult];
    
}

- (void) touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    [self releaseCatapult];
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
