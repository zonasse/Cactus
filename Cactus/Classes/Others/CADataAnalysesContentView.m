//
//  CADataAnalysesContentView.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/10/3.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "CADataAnalysesContentView.h"
//#import "XZMPieView.h"
#import "Masonry.h"
#import "Cactus-Bridging-Header.h"
@interface CADataAnalysesContentView()<ChartViewDelegate>
@property(nonatomic,strong) PieChartView *pieView;//饼图父视图
@property(nonatomic,strong) PieChartData *pieData;
@property(nonatomic,strong) UIView *NormalDistributionContentView;//正态图父视图
//@property(nonatomic,strong) XZMPieView *pieView;
//@property(nonatomic,strong) UIBezierPath *bezierPath;
//@property(nonatomic,strong) CAShapeLayer *shapeLayer;

@end
@implementation CADataAnalysesContentView

- (void)drawRect:(CGRect)rect{
    [self setupPieChartView];
    
    
}
- (void)setupPieChartView{
    //1.
    self.pieView = [[PieChartView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height*0.5)];
    self.pieView.backgroundColor = [UIColor lightGrayColor];
    self.pieView.delegate = self;
    [self addSubview:self.pieView];
    self.pieView.drawEntryLabelsEnabled = YES;//
    self.pieView.usePercentValuesEnabled = YES;
    self.pieView.drawSlicesUnderHoleEnabled = NO;
    self.pieView.holeRadiusPercent = 0.58;
    self.pieView.transparentCircleRadiusPercent = 0.61;
    self.pieView.chartDescription.enabled = NO;
    [self.pieView setExtraOffsetsWithLeft:5.f top:10.f right:5.f bottom:5.f];
    
    self.pieView.drawCenterTextEnabled = YES;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@"Charts\nby Daniel Cohen Gindi"];
    [centerText setAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:13.f],
                                NSParagraphStyleAttributeName: paragraphStyle
                                } range:NSMakeRange(0, centerText.length)];
    [centerText addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f],
                                NSForegroundColorAttributeName: UIColor.grayColor
                                } range:NSMakeRange(10, centerText.length - 10)];
    [centerText addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:11.f],
                                NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]
                                } range:NSMakeRange(centerText.length - 19, 19)];
    _pieView.centerAttributedText = centerText;
    
    _pieView.drawHoleEnabled = YES;
    _pieView.rotationAngle = 0.0;
    _pieView.rotationEnabled = YES;
    _pieView.highlightPerTapEnabled = YES;
    
    ChartLegend *l = _pieView.legend;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentRight;
    l.verticalAlignment = ChartLegendVerticalAlignmentTop;
    l.orientation = ChartLegendOrientationVertical;
    l.drawInside = NO;
    l.xEntrySpace = 7.0;
    l.yEntrySpace = 0.0;
    l.yOffset = 0.0;
    
    // entry label styling
    _pieView.entryLabelColor = UIColor.whiteColor;
    _pieView.entryLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
    
    [_pieView animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
    [self setDataCount:5 range:14.0];
}
- (void)setDataCount:(int)count range:(double)range
{
    double mult = range;
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [values addObject:[[PieChartDataEntry alloc] initWithValue:(arc4random_uniform(mult) + mult / 5) label:[NSString stringWithFormat:@"数据 %d",i] icon: [UIImage imageNamed:@"icon"]]];
        
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@"Election Results"];
    
    dataSet.drawIconsEnabled = NO;
    
    dataSet.sliceSpace = 2.0;
    dataSet.iconsOffset = CGPointMake(0, 40);
    
    // add a lot of colors
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
    [colors addObjectsFromArray:ChartColorTemplates.joyful];
    [colors addObjectsFromArray:ChartColorTemplates.colorful];
    [colors addObjectsFromArray:ChartColorTemplates.liberty];
    [colors addObjectsFromArray:ChartColorTemplates.pastel];
    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:UIColor.whiteColor];
    
    _pieView.data = data;
    [_pieView highlightValues:nil];
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

@end
