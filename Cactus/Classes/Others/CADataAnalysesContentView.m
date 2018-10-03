//
//  CADataAnalysesContentView.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/10/3.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "CADataAnalysesContentView.h"
#import "XZMPieView.h"
@interface CADataAnalysesContentView()
@property(nonatomic,strong) UIView *pieContentView;//饼图父视图
@property(nonatomic,strong) UIView *NormalDistributionContentView;//正态图父视图
@property(nonatomic,strong) XZMPieView *pieView;
@property(nonatomic,strong) UIBezierPath *bezierPath;
@property(nonatomic,strong) CAShapeLayer *shapeLayer;
@end
@implementation CADataAnalysesContentView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    /*
     * 饼图
     */
    self.pieContentView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 220)];
    self.pieContentView.backgroundColor = [UIColor lightGrayColor];
    self.pieView = [[XZMPieView alloc] initWithFrame:CGRectMake(10, 10, 200, 200)];
    self.pieView.backgroundColor = [UIColor orangeColor];
    [self.pieContentView addSubview:self.pieView];
        _pieView.sectorSpace = 0.01;
    [_pieView setDatas:[self getDatas] colors:@[[UIColor redColor],[UIColor purpleColor]]];
    [_pieView stroke];
    [self addSubview:self.pieContentView];
    /*
     * 正态图
     */
    self.NormalDistributionContentView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.pieContentView.frame) + 10, self.pieContentView.frame.size.width, self.pieContentView.frame.size.height)];
    self.NormalDistributionContentView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.NormalDistributionContentView];
    _bezierPath= [UIBezierPath bezierPath];
    [self drawNormalDistributionWithMui:50 ksei:10 startX:self.NormalDistributionContentView.frame.origin.x startY:self.NormalDistributionContentView.frame.origin.y width:self.NormalDistributionContentView.frame.size.width height:self.NormalDistributionContentView.frame.size.height];
    
    //CADisplayLink *refreshLink= [CADisplayLink displayLinkWithTarget:self selector:@selector(runloop)];
    //[refreshLink addToRunLoop: [NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    
}
#pragma mark --正态图
- (void)drawNormalDistributionWithMui:(CGFloat)mui ksei:(CGFloat) ksei startX:(CGFloat) startX startY:(CGFloat) startY width:(CGFloat) width height:(CGFloat) height{
    
//    static CGFloat mui = 0;//均值
//    static CGFloat ksei = 1;//方差
    [_bezierPath removeAllPoints];//重置path
    
    if(_shapeLayer==nil) {//第一次创建CAShapeLayer
        
        _shapeLayer= [CAShapeLayer layer];
        _shapeLayer.strokeColor= [UIColor blackColor].CGColor;
        _shapeLayer.fillColor= [UIColor whiteColor].CGColor;
        [self.layer addSublayer:_shapeLayer];
    }
    int count = 100;
    CGFloat x = 0;
    while (count >= 0) {
        CGFloat y = (1.0/(sqrt(2*M_PI)*ksei)) * exp(-1 * (x-mui) * (x-mui) / (2*ksei*ksei));
        NSLog(@" x = %f, y = %f",x,y);
        y = y*1000;
        if(count == 100) {
            //[_bezierPath moveToPoint:CGPointMake(x*100+xMove,yMove)];//手动设置首点
            //[_bezierPath addLineToPoint:CGPointMake(x*100+xMove, y*100+yMove)];
            CGPoint startPoint = CGPointMake(startX+10+x,height+startY-y-20);
            [_bezierPath moveToPoint:startPoint];//手动设置首点
            NSLog(@"%f %f",startPoint.x,startPoint.y);
        }else if(count == 0){
            CGPoint endPoint = CGPointMake(startX+10+x,height+startY-y-20);

            [_bezierPath addLineToPoint:endPoint];//手动设置末点
            NSLog(@"%f %f",endPoint.x,endPoint.y);

            //[_bezierPath addLineToPoint:CGPointMake(x*100+xMove, yMove)];
        }else{
            [_bezierPath addLineToPoint:CGPointMake(startX+10+x, height+startY-y-20)];
            
        }
        count--;
        x+=1;
    }

    
    //[_bezierPath closePath];
    
    _shapeLayer.path=_bezierPath.CGPath;
    
    
}

#pragma mark --饼图
- (NSArray *)getDatas{
    
    int cout = arc4random() % 5;
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < cout+1 ; i++) {
        
        [arr addObject:@(arc4random()%100)];
    }
    
    return arr;
}

- (void)changeColor{
    _pieView.sectorSpace = 0;
    [_pieView setDatas:[self getDatas] colors:@[[UIColor redColor],[UIColor purpleColor]]];
    [_pieView stroke];
}
@end
