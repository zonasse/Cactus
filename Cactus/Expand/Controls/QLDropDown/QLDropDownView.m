//
//  QLDropDownView.m
//  Cactus
//
//  Created by 钟奇龙 on 2019/1/16.
//  Copyright © 2019 钟奇龙. All rights reserved.
//

#import "QLDropDownView.h"

@implementation QLDropDownView
@synthesize tv,tableArray,textField,typeBtn;


- (id)initWithFrame:(CGRect)frame
{
    if (frame.size.height < 200) {
        frameHeight = 200;
    }else
    {
        frameHeight = frame.size.height;
    }
    tabheight = frameHeight - 30;
    frame.size.height = 30.0f;
    self = [super initWithFrame:frame];
    if (self) {
        showList = NO;//默认不显示下拉框
        
        tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, frame.size.width, 0)];
        tv.delegate = self;
        tv.dataSource = self;
        tv.backgroundColor = [UIColor whiteColor];
        tv.separatorColor = [UIColor lightGrayColor];
        tv.hidden = YES;
        
        [self addSubview:tv];
        
        // 去掉cell分割线前端空白15px间距
        if ([tv respondsToSelector:@selector(setSeparatorInset:)]) {
            [tv setSeparatorInset: UIEdgeInsetsZero];
        }
        if ([tv respondsToSelector:@selector(setLayoutMargins:)]) {
            [tv setLayoutMargins: UIEdgeInsetsZero];
        }
        
        typeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        [typeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        typeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [typeBtn addTarget:self action:@selector(dropdown) forControlEvents:UIControlEventTouchUpInside];
        typeBtn.titleLabel.font = [UIFont systemFontOfSize:11.0f];
        [self addSubview:typeBtn];
        //        textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        //        textField.borderStyle = UITextBorderStyleRoundedRect;//设置文本框的边框风格;
        //        [textField addTarget:self action:@selector(dropdown) forControlEvents:UIControlEventAllEvents];
        //        [self addSubview:textField];
    }
    return self;
}

- (void)dropdown
{
    //    [textField resignFirstResponder];
    if (showList) {//如果下拉框已经显示，什么都不做
        tv.hidden = YES;
        showList = NO;
        return;
    }else//如果下拉框尚未显示，则进行显示
    {
        CGRect sf = self.frame;
        sf.size.height = frameHeight;
        
        //把dropdownList放到前面，防止下拉框被别的空间遮住
        [self.superview bringSubviewToFront:self];
        tv.hidden = NO;
        showList = YES;//显示下拉框
        
        CGRect frame = tv.frame;
        frame.size.height = 0;
        tv.frame = frame;
        frame.size.height = tabheight;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        self.frame = sf;
        tv.frame = frame;
        [UIView commitAnimations];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,132.0/750*kSCREEN_WIDTH,50.0/750*kSCREEN_WIDTH)];
    lab.text=[tableArray objectAtIndex:[indexPath row]];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.font = [UIFont systemFontOfSize:11.0f];
    [cell.contentView addSubview:lab];
    //    cell.textLabel.text = [tableArray objectAtIndex:[indexPath row]];
    //    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    //    cell.textLabel.font = [UIFont systemFontOfSize:11.0f];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0/750*kSCREEN_WIDTH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    textField.text = [tableArray objectAtIndex:[indexPath row]];
    //    NSString *s = [NSString stringWithFormat:@"%@",]
    [typeBtn setTitle:[tableArray objectAtIndex:[indexPath row]] forState:UIControlStateNormal];
    showList = NO;
    tv.hidden = YES;
    
    CGRect sf = self.frame;
    sf.size.height = 30;
    self.frame = sf;
    CGRect frame = tv.frame;
    frame.size.height = 0;
    tv.frame = frame;
    NSString *type = [tableArray objectAtIndex:[indexPath row]];
    if ([_delegate respondsToSelector:@selector(dropDown:withView:didSelectText:)]) {
        [_delegate dropDown:self withView:self didSelectText:type];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
