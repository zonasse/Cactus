//
//  CAScoreListView.m
//  Cactus
//
//  Created by 钟奇龙 on 2018/10/30.
//  Copyright © 2018 钟奇龙. All rights reserved.
//

#import "CAScoreListView.h"
#import "ExcelView/ExcelView.h"
@interface CAScoreListView()<ExcelViewDelegate>
@property (nonatomic,strong) ExcelView *excelView;

@end
@implementation CAScoreListView

- (void)drawRect:(CGRect)rect {
    
    _excelView = [[ExcelView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _excelView.delegate = self;
    [self addSubview:_excelView];
    ExcelModel *headerModel = [ExcelModel new];
    headerModel.title = @"学生姓名";
    headerModel.contentArray = @[@"年龄",@"爱好",@"工作",@"邮箱",@"对象",@"父母",
                                 @"年龄",@"爱好",@"工作",@"邮箱",@"对象",@"父母"];
    _excelView.headerModel = headerModel;
    
    ExcelModel *contentModel = [ExcelModel new];
    contentModel.title = @"小刘";
    contentModel.contentArray = @[@"16",@"打游戏",@"开发",@"3944423@163.com",@"翠花",@"隐私",
                                  @"16",@"打游戏",@"开发",@"3944423@163.com",@"翠花",@"隐私"];
    _excelView.dataArray = @[contentModel,contentModel,contentModel,contentModel,contentModel,contentModel,contentModel,contentModel,contentModel,contentModel,contentModel,contentModel,contentModel,contentModel,contentModel,contentModel];
    
    [_excelView drawExcel];

}


- (void)itemOnClick:(UIButton *)sender indexPath:(NSIndexPath *)indexPath index:(NSInteger)index {
    NSLog(@"点击了第%ld行第%ld个",indexPath.row + 1 , index + 1);
}

- (void)headerItemOnClick:(UIButton *)sender index:(NSInteger)index {
    NSLog(@"点击了第%ld个", index + 1);
}


@end
