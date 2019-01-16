//
//  QLDropDownView.h
//  Cactus
//
//  Created by 钟奇龙 on 2019/1/16.
//  Copyright © 2019 钟奇龙. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class QLDropDownView;
@protocol QLDropDownDelegate <NSObject>

-(void)dropDown:(QLDropDownView *)drop withView:(UIView *)view didSelectText:(NSString *)str;

@end
@interface QLDropDownView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* tv;//下拉列表
    NSArray* tableArray;//下拉列表数据
    UITextField* textField;//文本输入框
    UIButton* typeBtn;
    BOOL showList;//是否弹出下拉列表
    CGFloat tabheight;//table下拉列表的高度
    CGFloat frameHeight;//frame的高度
}
@property(nonatomic,strong) UITableView* tv;
@property(nonatomic,strong) NSArray* tableArray;
@property(nonatomic,strong) UITextField* textField;
@property(nonatomic,strong) UIButton *typeBtn;
@property (nonatomic, assign) id<QLDropDownDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
