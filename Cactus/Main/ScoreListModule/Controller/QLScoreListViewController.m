//
//  CAScoreListViewController.m
//  Cactus
//
//  Created by  zonasse on 2018/9/22.
//  Copyright © 2018年  zonasse. All rights reserved.
//

#import "QLScoreListViewController.h"
#import "QLDeletePointTitleViewController.h"

#import "QLCollectionViewModel.h"

#import "YCXMenu.h"
#import "NSDictionary+QLDictionaryDeepCopy.h"
#import "NSString+QLExtension.h"
#import "QLScoreListCollectionCell.h"
#import "QLScoreListCollectionViewLayout.h"
#import "QLDropDownView.h"
@interface QLScoreListViewController ()
{
    
}
@property (nonatomic,strong) QLCollectionViewModel *collectionViewModel;
///控制器首次出现
@property (nonatomic,assign) BOOL firstAppear;
@end

@implementation QLScoreListViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.classInfo.name;
    //0.设置导航栏返回按钮
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
    [leftButton setImage:[UIImage imageNamed:@"nav_back_btn_icon"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftNavigationItemClicked) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //1.设置导航栏右上角button
    UIButton *crucifixButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
    [crucifixButton setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000eb31", 34, [UIColor whiteColor])] forState:UIControlStateNormal];
    [crucifixButton addTarget:self action:@selector(rightNavigationItemClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *crucifixItem = [[UIBarButtonItem alloc] initWithCustomView:crucifixButton];
    
    
    _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    _saveButton.hidden = YES;
    [_saveButton addTarget:self action:@selector(saveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithCustomView:_saveButton];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:crucifixItem, saveItem, nil];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"pointModifySuccessNotification" object:nil];

    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if (!_firstAppear) {
        _firstAppear = YES;
        self.collectionViewModel = [[QLCollectionViewModel alloc] initWithController:self];
    }
}

/**
 点击了导航栏左上角按钮
 */
- (void)leftNavigationItemClicked{
    [self.collectionViewModel closeKeyboard];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LeftNavigationItemClickedNotification" object:nil];
}
#pragma mark - event response


/**
 点击了导航栏右上角按钮
 */
- (void)rightNavigationItemClicked{
    [YCXMenu setTintColor:[UIColor colorWithRed:0.118 green:0.573 blue:0.820 alpha:1]];
    [YCXMenu setSelectedColor:[UIColor redColor]];
    if ([YCXMenu isShow]){
        [YCXMenu dismissMenu];
    } else {
        
        NSMutableArray *items = [NSMutableArray array];
        YCXMenuItem *addTitleItem = [YCXMenuItem menuItem:@"增加分数列" image:nil target:self action:@selector(addTitleItemClicked)];
//        YCXMenuItem *deleteTitleItem = [YCXMenuItem menuItem:@"删除分数列" image:nil target:self action:@selector(deleteTitle)];
        [items addObject:addTitleItem];
//        [items addObject:deleteTitleItem];
        [YCXMenu setTintColor:kDefaultGreenColor];
        [YCXMenu setSelectedColor:kRGB(263, 161, 53)];
        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 50,0, 50, 0) menuItems:items selected:^(NSInteger index, YCXMenuItem *item) {
            NSLog(@"%@",item);
        }];
    }
    
}

- (void)saveButtonClicked{
    [self.collectionViewModel saveAllPointChanges];
}
- (void)addTitleItemClicked{
    [self.collectionViewModel addTitle];
}
/**
 删除分数列
 */
//- (void)deleteTitle{
//    //跳转到删除分数列控制器
//    QLDeletePointTitleViewController *deletePointTitleVC = [[QLDeletePointTitleViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:deletePointTitleVC];
//    deletePointTitleVC.titles = [self.titles mutableCopy];
//
//    [self presentViewController:nav animated:YES completion:^{
//
//    }];
//}




//重写此方法，解决了部分cell无法点击的问题
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}


#pragma mark - delegete and datasource methods

#pragma mark - getters and setters

#pragma mark - private

#pragma mark - notification methods

@end
