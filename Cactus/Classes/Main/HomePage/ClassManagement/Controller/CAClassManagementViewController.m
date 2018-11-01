//
//  CALessonManagementViewController.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/9/22.
//  Copyright © 2018年 钟奇龙. All rights reserved.
//

#import "CAClassManagementViewController.h"
#import <AxcAE_TabBar.h>
#import "CAClassHomePageViewController.h"
#import "CADataAnalysisViewController.h"
#import "CAScoreListViewController.h"
#import "CAStudentListViewController.h"
#import "CAStudent.h"
@interface CAClassManagementViewController ()<AxcAE_TabBarDelegate>
@property(nonatomic,strong) AxcAE_TabBar *axcTabBar;
@end

@implementation CAClassManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
    [rightButton setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000eb31", 34, [UIColor orangeColor])] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
//    self.title = @"c++ 19999班";
    /*
     * 此处设置课程管理主页简略信息
     */
    
}
#pragma mark --添加子页面
- (void)setClassInfo:(CAClassInfo *)classInfo{
    _classInfo = classInfo;
    [self addChildViewControllers];
}
#pragma mark --设置tabbar子页面
- (void)addChildViewControllers{
#pragma mark --添加虚拟数据
//    CAStudent *stu1 = [[CAStudent alloc] init];
//    stu1.name = @"赵丽";
//    stu1.s_id = @"20180001";
//    CAStudent *stu2 = [[CAStudent alloc] init];
//    stu2.name = @"刘信";
//    stu2.s_id = @"20180002";
//    CAStudent *stu3 = [[CAStudent alloc] init];
//    stu3.name = @"Kami";
//    stu3.s_id = @"20180003";
//    CAStudent *stu4 = [[CAStudent alloc] init];
//    stu4.name = @"zoro";
//    stu4.s_id = @"20180004";
//    CAStudent *stu5 = [[CAStudent alloc] init];
//    stu5.name = @"三笠";
//    stu5.s_id = @"20180005";
//    CAStudent *stu6 = [[CAStudent alloc] init];
//    stu6.name = @"Alice";
//    stu6.s_id = @"20180006";
//    NSArray *students = [NSArray arrayWithObjects:stu1,stu2,stu3,stu4,stu5,stu6, nil];
//    self.lessonClass.students = students;

    CAClassHomePageViewController *classHomePageVC = [[CAClassHomePageViewController alloc] init];
    classHomePageVC.classInfo = self.classInfo;

    CADataAnalysisViewController *dataAnalysisVC = [[CADataAnalysisViewController alloc] init];
//    dataAnalysesVC.lessonClass = self.lessonClass;

    CAScoreListViewController *scoreListVC = [[CAScoreListViewController alloc] init];
    scoreListVC.classInfo = self.classInfo;

    CAStudentListViewController *studentListVC = [[CAStudentListViewController alloc] init];
    studentListVC.classInfo = self.classInfo;


    NSArray <NSDictionary *>*VCArray =
   @[@{@"vc":scoreListVC,@"normalImg":@"\U0000ed0e",@"selectImg":@"\U0000ed0e",@"itemTitle":@"分数列表"},
    @{@"vc":studentListVC ,@"normalImg":@"\U0000ece3",@"selectImg":@"\U0000ece3",@"itemTitle":@"学生列表"},@{@"vc":dataAnalysisVC,@"normalImg":@"\U0000ecf2",@"selectImg":@"\U0000ecf2",@"itemTitle":@"数据分析"},@{@"vc":classHomePageVC ,@"normalImg":@"\U0000eb4f",@"selectImg":@"\U0000eb4f",@"itemTitle":@"班级信息"}
      ];
    // 1.遍历这个集合
    // 1.1 设置一个保存构造器的数组
    NSMutableArray *tabBarConfs = @[].mutableCopy;
    // 1.2 设置一个保存VC的数组
    NSMutableArray *tabBarVCs = @[].mutableCopy;
    [VCArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 2.根据集合来创建TabBar构造器
        AxcAE_TabBarConfigModel *model = [AxcAE_TabBarConfigModel new];
        // 3.item基础数据三连
        model.itemTitle = [obj objectForKey:@"itemTitle"];
        model.selectImageName = [obj objectForKey:@"selectImg"];
        model.normalImageName = [obj objectForKey:@"normalImg"];
        // 4.设置单个选中item标题状态下的颜色
        model.selectColor = [UIColor orangeColor];
        model.normalColor = [UIColor lightGrayColor];

        /***********************************/
//        if (idx == 2 ) { // 如果是中间的
//            // 设置凸出
//            model.bulgeStyle = AxcAE_TabBarConfigBulgeStyleSquare;
//            // 设置凸出高度
//            model.bulgeHeight = -5;
//            model.bulgeRoundedCorners = 2; // 修角
//            // 设置成纯文字展示
//            model.itemLayoutStyle = AxcAE_TabBarItemLayoutStyleTitle;
//            // 文字为加号
//            model.itemTitle = @"+";
//            // 字号大小
//            model.titleLabel.font = [UIFont systemFontOfSize:40];
//            model.normalColor = [UIColor whiteColor]; // 未选中
//            model.selectColor = [UIColor whiteColor];   // 选中后一致
//            // 让Label上下左右全边距
//            model.componentMargin = UIEdgeInsetsMake(-5, 0, 0, 0 );
//            // 未选中选中为橘里橘气
//            model.normalBackgroundColor = [UIColor greenColor];
//            model.selectBackgroundColor = [UIColor greenColor];
//            // 设置大小/边长
//            model.itemSize = CGSizeMake(self.tabBar.frame.size.width / 5 - 35.0 ,self.tabBar.frame.size.height - 10);
//        }
        // 备注 如果一步设置的VC的背景颜色，VC就会提前绘制驻留，优化这方面的话最好不要这么写
        // 示例中为了方便就在这写了
        UIViewController *vc = [obj objectForKey:@"vc"];
        /*vc.view.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.f
                                                  green:arc4random()%255/255.f
                                                   blue:arc4random()%255/255.f alpha:1];
        */
        // 5.将VC添加到系统控制组
        [tabBarVCs addObject:vc];
        // 5.1添加构造Model到集合
        [tabBarConfs addObject:model];
    }];
    // 5.2 设置VCs -----
    // 一定要先设置这一步，然后再进行后边的顺序，因为系统只有在setViewControllers函数后才不会再次创建UIBarButtonItem，以免造成遮挡
    // 大意就是一定要让自定义TabBar遮挡住系统的TabBar
    self.viewControllers = tabBarVCs;
    //////////////////////////////////////////////////////////////////////////
    // 注：这里方便阅读就将AE_TabBar放在这里实例化了 使用懒加载也行
    // 6.将自定义的覆盖到原来的tabBar上面
    // 这里有两种实例化方案：
    // 6.1 使用重载构造函数方式：
    //    self.axcTabBar = [[AxcAE_TabBar alloc] initWithTabBarConfig:tabBarConfs];
    // 6.2 使用Set方式：
    self.axcTabBar = [AxcAE_TabBar new] ;
    self.axcTabBar.tabBarConfig = tabBarConfs;
    // 7.设置委托
    self.axcTabBar.delegate = self;
    // 8.添加覆盖到上边
    [self.tabBar addSubview:self.axcTabBar];
    [self addLayoutTabBar]; // 10.添加适配
}
// 9.实现代理，如下：
static NSInteger lastIdx = 0;
- (void)axcAE_TabBar:(AxcAE_TabBar *)tabbar selectIndex:(NSInteger)index{
//    if (index != 2) { // 不是中间的就切换
        // 通知 切换视图控制器
        [self setSelectedIndex:index];
        lastIdx = index;
//    }else{ // 点击了中间的
//        [self.axcTabBar setSelectIndex:lastIdx WithAnimation:NO]; // 换回上一个选中状态
//        // 或者
//        //        self.axcTabBar.selectIndex = lastIdx; // 不去切换TabBar的选中状态
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"点击了中间的,不切换视图"
//                                                                          preferredStyle:UIAlertControllerStyleAlert];
//        [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"好的！！！！");
//        }])];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
}
- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    [super setSelectedIndex:selectedIndex];
    if(self.axcTabBar){
        self.axcTabBar.selectIndex = selectedIndex;
    }
}

// 10.添加适配
- (void)addLayoutTabBar{
    // 使用重载viewDidLayoutSubviews实时计算坐标 （下边的 -viewDidLayoutSubviews 函数）
    // 能兼容转屏时的自动布局
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.axcTabBar.frame = self.tabBar.bounds;
    [self.axcTabBar viewDidLayoutItems];
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