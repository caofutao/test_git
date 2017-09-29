//
//  ViewController.m
//  CoreTextDemo
//
//  Created by 曹福涛 on 15/12/5.
//  Copyright © 2015年 曹福涛. All rights reserved.
//

#import "ViewController.h"
#import "TCDisplayView.h"
#import "TCFrameParser.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet TCDisplayView *displayView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // git demo

    NSString *content = @"南京#1#上海#2#四川#3#西安哈哈哈#1#乌鲁木齐#2#哈尔滨";
//    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:12]};
//    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"西安哈哈哈西安哈哈哈西安哈哈哈北京" attributes:attrs];
//    CGFloat old = [str boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    
    CoreTextData *data = [TCFrameParser parseContent:content];
    
    TCDisplayView *view = [[TCDisplayView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [view setBackgroundColor:[UIColor orangeColor]];
    view.data = data;
    
    CGRect frame = view.frame;
    frame.size.height = data.height;
    view.frame = frame;
    [self.view addSubview:view];
    
    self.displayView.data = data;
    [self.displayView setNeedsDisplay];
}

- (void)configView {
    // 注释一下 first
    UIView *bgView = [UIView new];
    [self.view addSubview:bgView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
