//
//  BABGameBoardVC.m
//  Bricks & Balls
//
//  Created by Eric Williams on 8/6/14.
//  Copyright (c) 2014 Eric Williams. All rights reserved.
//

#import "BABGameBoardVC.h"
#import "BABHeaderView.h"
#import "BABLevelData.h"

#import <Crashlytics/Crashlytics.h>

// when gameover clear bricks and show start button
// create new class called "BABLevelData" as a subclass of NSObject  *******

// make a method that will drop a UIView (gravity) from a broken brick like a powerup.... listen for it to collide with paddle
//randomly change size of paddle when powerup hits paddle

@interface BABGameBoardVC () <UICollisionBehaviorDelegate>

@end

@implementation BABGameBoardVC
{
    UIDynamicAnimator * animator;
    UIDynamicItemBehavior * ballItemBehavior;
    UIDynamicItemBehavior * brickItemBehavior;
    UIDynamicItemBehavior * powerBehavior;
    
    UICollisionBehavior * powerCollision;
    UICollisionBehavior * collisionBehavior;
    UIAttachmentBehavior * attachmentBehavior;
    
    UIView * ball;
    UIView * paddle;
    UIView * powerUpPaddleUp;
    UIView * powerUpPaddleDown;
    UIView * powerUpBallBig;
    UIView * powerUpBallSmall;
    UIView * powerUpMultiBall;
    
    UIGravityBehavior * gravityBehavior;
    
    NSMutableArray * bricks;
    
    UIButton * startButton;
    
    BABHeaderView * headerView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        
         headerView = [[BABHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        
        [self.view addSubview:headerView];
        
         bricks = [@[]mutableCopy];
        
         animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
         ballItemBehavior = [[UIDynamicItemBehavior alloc] init];
         ballItemBehavior.friction = 0;
         ballItemBehavior.elasticity = 1;
         ballItemBehavior.resistance = 0;
         ballItemBehavior.allowsRotation = NO;
        [animator addBehavior:ballItemBehavior];
        
         gravityBehavior = [[UIGravityBehavior alloc] init];
        [animator addBehavior:gravityBehavior];
        
         collisionBehavior = [[UICollisionBehavior alloc] init];
         collisionBehavior.collisionDelegate = self;
        
        [collisionBehavior addBoundaryWithIdentifier:@"floor" fromPoint:CGPointMake(0, SCREEN_HEIGHT + 20) toPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT + 20)];
        
        [collisionBehavior addBoundaryWithIdentifier:@"left wall" fromPoint:CGPointMake(0,0) toPoint:CGPointMake(0, SCREEN_HEIGHT)];
        
        [collisionBehavior addBoundaryWithIdentifier:@"right wall" fromPoint:CGPointMake(SCREEN_WIDTH, 0) toPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        [collisionBehavior addBoundaryWithIdentifier:@"ceiling" fromPoint:CGPointMake(0,0) toPoint:CGPointMake(SCREEN_WIDTH, 30)];
        
        [animator addBehavior:collisionBehavior];
        
         brickItemBehavior = [[UIDynamicItemBehavior alloc] init];
         brickItemBehavior.density = 10000000;
        
        [animator addBehavior:brickItemBehavior];
        
         powerBehavior = [[UIDynamicItemBehavior alloc] init];
         powerBehavior.allowsRotation = NO;
        
        [animator addBehavior:powerBehavior];
        
         powerCollision = [[UICollisionBehavior alloc] init];
         powerCollision.collisionDelegate = self;
        
        [animator addBehavior:powerCollision];
        
        
        
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     paddle = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 100) / 2.0, (SCREEN_HEIGHT - 10.0), 100, 5)];
     paddle.backgroundColor = [UIColor blueColor];
     paddle.layer.cornerRadius = 5;
    
    [self.view addSubview:paddle];
    
    
     startButton = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 100) / 2.0, (SCREEN_HEIGHT - 100) /2.0, 100, 100)];
    [startButton setTitle:@"Start" forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
     startButton.backgroundColor = [UIColor grayColor];
     startButton.layer.cornerRadius = 50;
    
    [self.view addSubview:startButton];
}

-(void)startGame
{
    [startButton removeFromSuperview];
    
    [self resetBricks];
    [self createBall];
}

-(void)createBall
{
     ball = [[UIView alloc]initWithFrame:CGRectMake(paddle.center.x, SCREEN_HEIGHT - 50, 20, 20)];
     ball.layer.cornerRadius = ball.frame.size.width / 2.0;
     ball.backgroundColor = [UIColor magentaColor];

    [self.view addSubview:ball];
    

    [collisionBehavior addItem:ball];
    [ballItemBehavior addItem:ball];

    UIPushBehavior * pushBehavior = [[UIPushBehavior alloc] initWithItems:@[ball] mode:UIPushBehaviorModeInstantaneous];

    pushBehavior.pushDirection = CGVectorMake(0.1, -0.1);

    [animator addBehavior:pushBehavior];
    
    [[Crashlytics sharedInstance] crash];
    

}

-(void)createPowerUp:(UIView *)brick
{
    
    powerUpPaddleUp = [[UIView alloc] initWithFrame:CGRectMake(brick.center.x, brick.center.y, 20, 20)];
    powerUpPaddleUp.backgroundColor = [UIColor blackColor];
    powerUpPaddleUp.layer.cornerRadius = 10;
    
    [self.view addSubview:powerUpPaddleUp];
    
    [gravityBehavior addItem:powerUpPaddleUp];
    [powerCollision addItem:powerUpPaddleUp];
    [powerCollision addItem:paddle];
    
    
    powerUpPaddleDown = [[UIView alloc] initWithFrame:CGRectMake(brick.center.x, brick.center.y, 20, 20)];
    powerUpPaddleDown.backgroundColor = [UIColor redColor];
    powerUpPaddleDown.layer.cornerRadius = 10;
    
    [self.view addSubview:powerUpPaddleDown];
    
    [gravityBehavior addItem:powerUpPaddleDown];
    [powerCollision addItem:powerUpPaddleDown];
    [powerCollision addItem:paddle];
    
    
    powerUpBallBig = [[UIView alloc] initWithFrame:CGRectMake(brick.center.x, brick.center.y, 40, 40)];
    powerUpBallBig.backgroundColor = [UIColor greenColor];
    powerUpBallBig.layer.cornerRadius = 20;
    
    [self.view addSubview:powerUpBallBig];
    
    [gravityBehavior addItem:powerUpBallBig];
    [powerCollision addItem:powerUpBallBig];
    [powerCollision addItem:paddle];
    
    
    powerUpBallSmall = [[UIView alloc] initWithFrame:CGRectMake(brick.center.x, brick.center.y, 20, 20)];
    powerUpBallSmall.backgroundColor = [UIColor blueColor];
    powerUpBallSmall.layer.cornerRadius = 10;
    
    [self.view addSubview:powerUpBallSmall];
    
    [gravityBehavior addItem:powerUpBallSmall];
    [powerCollision addItem:powerUpBallSmall];
    [powerCollision addItem:paddle];
    
    
    powerUpMultiBall = [[UIView alloc] initWithFrame:CGRectMake(brick.center.x, brick.center.y, 20, 20)];
    powerUpMultiBall.backgroundColor = [UIColor purpleColor];
    powerUpMultiBall.layer.cornerRadius = 10;
    
    [self.view addSubview:powerUpMultiBall];
    
    [gravityBehavior addItem:powerUpMultiBall];
    [powerCollision addItem:powerUpMultiBall];
    [powerCollision addItem:paddle];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
     attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:paddle attachedToAnchor:paddle.center];
    
    [animator addBehavior:attachmentBehavior];
    
    [collisionBehavior addItem:paddle];
    [brickItemBehavior addItem:paddle];
    
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    if ([@"floor" isEqualToString:(NSString*)identifier])
    {
        UIView * ballItem = (UIView *)item;
        
        [collisionBehavior removeItem:ballItem];
        [ballItem removeFromSuperview];
        
        headerView.lives--;
        
        // this code will reanimate another ball until lives go to zero and will be gameover
        
        if (headerView.lives > 0)
        {
            [self createBall];
        }
        
        // this code will bring user back to start screen to begin a new game
        
        if (headerView.lives == 0)
        {
            [self resetGame];
        }
    }
}
// this code will reset the lives and score on the screen

- (void)resetGame
{
    headerView.lives = 3;
    headerView.score = 0;

    // the code will below will reset the bricks when lives run out
    
    for (UIView * brick in bricks)
    {
        [brick removeFromSuperview];
        [collisionBehavior removeItem:brick];
    }
    
    [bricks removeAllObjects];
    
     startButton = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 100) / 2.0, (SCREEN_HEIGHT - 100) /2.0, 100, 100)];
    [startButton setTitle:@"Start" forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
     startButton.backgroundColor = [UIColor grayColor];
     startButton.layer.cornerRadius = 50;    
    
    [self.view addSubview:startButton];
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{
    for (UIView * brick in [bricks copy])
    {
        if ([item1 isEqual:brick] || [item2 isEqual:brick])
        {
             headerView.score += 100;
            [collisionBehavior removeItem:brick];
            [gravityBehavior addItem:brick];
            
            int random = arc4random_uniform(6);
            if (random == 2)
            {
                [self createPowerUp:(UIView *)brick];
            }
            
            [UIView animateWithDuration:0.3 animations:^{
                
                brick.alpha = 0;
                
            } completion:^(BOOL finished) {
                
                [brick removeFromSuperview];
                [bricks removeObjectIdenticalTo:brick];
            }];
        }
    }
    
    if ([item1 isEqual:powerUpPaddleUp] || [item2 isEqual:powerUpPaddleUp])
    {
        [powerCollision removeItem:powerUpPaddleUp];
        [powerUpPaddleUp removeFromSuperview];
        
        powerUpPaddleUp = nil;
        
        if (powerUpPaddleUp == nil)
        {
            CGRect frame = paddle.frame;
            frame.size.width = arc4random_uniform(100) + 30;
            paddle.frame = frame;
        }
    }
    
    if ([item1 isEqual:powerUpPaddleDown] || [item2 isEqual:powerUpPaddleDown])
    {
        [powerCollision removeItem:powerUpPaddleDown];
        [powerUpPaddleDown removeFromSuperview];
        
        powerUpPaddleDown = nil;
        
        if (powerUpPaddleDown == nil)
        {
            CGRect frame = paddle.frame;
            frame.size.width = arc4random_uniform(100) + 30;
            paddle.frame = frame;
        }
    }
    
    if ([item1 isEqual:powerUpBallBig] || [item2 isEqual:powerUpBallBig])
    {
        [powerCollision removeItem:powerUpBallBig];
        [powerUpPaddleDown removeFromSuperview];
        
        powerUpBallBig = nil;
        
        if (powerUpBallBig == nil)
        {
            CGRect frame = ball.frame;
            frame.size.width = 60;
            ball.frame = frame;
        }
    }
    
    if ([item1 isEqual:powerUpBallSmall] || [item2 isEqual:powerUpBallSmall])
    {
        [powerCollision removeItem:powerUpBallSmall];
        [powerUpBallSmall removeFromSuperview];
        
        powerUpBallSmall = nil;
        
        if (powerUpBallSmall == nil)
        {
            CGRect frame = paddle.frame;
            frame.size.width = arc4random_uniform(100) + 40;
            paddle.frame = frame;
        }
    }
    
    if ([item1 isEqual:powerUpMultiBall] || [item2 isEqual:powerUpMultiBall])
    {
        [powerCollision removeItem:powerUpMultiBall];
        [powerUpMultiBall removeFromSuperview];
        
        powerUpMultiBall = nil;
        
        if (powerUpMultiBall == nil)
        {
            CGRect frame = paddle.frame;
            frame.size.width = arc4random_uniform(100) + 40;
            paddle.frame = frame;
        }
    }

    if (bricks.count == 0)
    {
        [collisionBehavior removeItem:ball];
        [ball removeFromSuperview];
        [BABLevelData mainData].currentLevel++;
        
        [self resetGame];
    }
}

- (void)resetBricks
{
    int colCount = [[[BABLevelData mainData] levelInfo][@"cols"] intValue];
    int rowCount = [[[BABLevelData mainData] levelInfo][@"rows"] intValue];
    int brickSpacing = 8;
    
    for (int col = 0 ; col < colCount; col++)
    {
        for (int row = 0 ; row < rowCount; row++)
        {
            float width = (SCREEN_WIDTH - (brickSpacing * (colCount + 1))) / colCount;
            float height = ((SCREEN_HEIGHT / 3.5) - (brickSpacing * rowCount )) / rowCount;
            float x = brickSpacing + (width + brickSpacing) * col;
            float y = brickSpacing + (height + brickSpacing) * row + 30;
            UIView * brick = [[UIView alloc]initWithFrame:CGRectMake(x, y, width, height)];
            
            CGFloat hue = (arc4random() % 256 / 256.0 );
            CGFloat saturation = (arc4random() % 128 / 256.0 ) + 0.5;
            CGFloat brightness = (arc4random() % 128 / 256.0 ) + 0.5;
            UIColor * color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
            brick.backgroundColor = color;
            
            [self.view addSubview:brick];
            
            [bricks addObject:brick];
            
            [collisionBehavior addItem:brick];
            [brickItemBehavior addItem:brick];
        }
    }
}

-(void)touchesBegan: (NSSet *)touches withEvent:(UIEvent *)event
{
    [self movePaddleWithTouches:touches];
}

-(void)touchesMoved: (NSSet *)touches withEvent:(UIEvent *)event
{
    [self movePaddleWithTouches:touches];
}

-(void)movePaddleWithTouches: (NSSet *)touches
{
    UITouch * touch = [touches allObjects][0];
    CGPoint location = [touch locationInView:self.view];
    
    float guard = paddle.frame.size.width / 2.0 + 10;
    float dragX = location.x;
    
    if (dragX < guard) dragX = guard;
    if (dragX > SCREEN_WIDTH - guard) dragX = SCREEN_WIDTH - guard;
    
    attachmentBehavior.anchorPoint = CGPointMake(dragX, paddle.center.y);
}

-(BOOL)prefersStatusBarHidden { return YES; }
    
    @end
