//
//  CADataAnalysesViewController.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/22.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "CADataAnalysesViewController.h"
#import "CADataAnalysesContentView.h"
@interface CADataAnalysesViewController ()
@property (nonatomic,strong) CADataAnalysesContentView *dataAnalysesView;
@end

@implementation CADataAnalysesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"show CADataAnalysesViewController");
    _dataAnalysesView = [[CADataAnalysesContentView alloc] initWithFrame:CGRectMake(0, tabbarVCStartY, SCREEN_WIDTH, SCREEN_HEIGHT-tabbarVCStartY-44)];
    _dataAnalysesView.contentSize = CGSizeMake(SCREEN_WIDTH, 1000);
    _dataAnalysesView.backgroundColor = [UIColor whiteColor];
    _dataAnalysesView.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:_dataAnalysesView];
    // Do any additional setup after loading the view.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [_dataAnalysesView changeColor];
}


- (void)setLessonClass:(CAClass *)lessonClass{
    NSLog(@"CADataAnalysesViewController setClass");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
