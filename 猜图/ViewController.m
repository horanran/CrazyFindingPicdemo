//
//  ViewController.m
//  猜图
//
//  Created by 方舟 on 15/5/28.
//  Copyright (c) 2015年 方舟. All rights reserved.
//

#import "ViewController.h"
#import "Question.h"

#define kButtonW 35.0
#define kButtonH 35.0
#define kButtonMargin 10.0
#define kTotalCol 7

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (strong,nonatomic) UIButton *cover;
@property (strong, nonatomic) NSArray *questions;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (assign, nonatomic) int index;
@property (weak, nonatomic) IBOutlet UIButton *nextQuestionButton;
@property (weak, nonatomic) IBOutlet UIView *answerView;
@property (weak, nonatomic) IBOutlet UIView *optionView;
@property (weak, nonatomic) IBOutlet UIButton *scoreButton;

@end

@implementation ViewController

-(NSArray *)questions
{
    if(!_questions)
    {
        _questions = [Question questions];
//        NSLog(@"%@",_questions);
    }
    return _questions;
}

-(UIButton *)cover
{
    if(!_cover){
        _cover = [[UIButton alloc] initWithFrame:self.view.bounds];
        _cover.backgroundColor = [UIColor blackColor];
        _cover.alpha = 0.0;
        [self.view addSubview:_cover];
        [_cover addTarget:self action:@selector(bigImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cover;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self questions];
    self.index = -1;
    [self.scoreButton setTitle:@"10000" forState:UIControlStateNormal];
    [self nextQuestion];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)bigImage {
    //增加蒙版
    //设置子视图大小通常用父视图的bounds属性
    //将图片移动到顶层
    [self cover];
    //动画放大图片
    if (self.cover.alpha == 0.0) {
        CGFloat viewW = self.view.bounds.size.width;
        CGFloat imageW = viewW;
        CGFloat imageH = imageW;
        CGFloat imageY = (self.view.bounds.size.height - imageH) * 0.5;
        
        [UIView animateWithDuration:1.0 animations:^{
            self.cover.alpha = 0.5f;
            self.imageButton.frame = CGRectMake(0, imageY, imageW, imageH);
            [self.view bringSubviewToFront:self.imageButton];
        }];
    }else{
        [UIView animateWithDuration:1.0 animations:^{
            self.imageButton.frame = CGRectMake(85, 80, 150, 150);
            self.cover.alpha = 0.0;
        }];
    }
    
}

- (IBAction)nextQuestion {
    self.index++;
    if (self.index >= [self.questions count]) {
        for (UIButton *btn in self.answerView.subviews) {
            btn.enabled = NO;
        }
        for (UIButton *btn in self.optionView.subviews) {
            btn.enabled = NO;
        }
        return;
    }
    Question *question = self.questions[self.index];
    self.numLabel.text = [NSString stringWithFormat:@"%i/%i",self.index + 1,[self.questions count]];
    self.titleLabel.text = question.title;
    [self.imageButton setImage:[UIImage imageNamed:question.icon] forState:UIControlStateNormal];
    self.nextQuestionButton.enabled = (self.index != [self.questions count] - 1);
    
    //删除前一题答案按钮，创建答案按钮
    for (UIButton *button in self.answerView.subviews) {
        [button removeFromSuperview];
    }
    int lenth = question.answer.length;
    CGFloat answerViewW = self.answerView.bounds.size.width;
    CGFloat answerX = (answerViewW - kButtonW * lenth - kButtonMargin * (lenth - 1)) * 0.5;
    for (int i = 0; i < lenth; i++) {
        CGFloat x = answerX + i * (kButtonW + kButtonMargin);
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, kButtonW, kButtonH)];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateHighlighted];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(answerClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.answerView addSubview:button];
    }
    
    //删除前一题备选答案，创建备选答案
    for (UIButton *button in self.optionView.subviews) {
        [button removeFromSuperview];
    }
    CGFloat optionViewW = self.optionView.bounds.size.width;
    CGFloat optionX = (optionViewW - kButtonW * kTotalCol - kButtonMargin * (kTotalCol - 1)) * 0.5;
    for (int i = 0; i < [question.options count]; i++) {
        int row = i / kTotalCol;
        int col = i % kTotalCol;
        CGFloat x = optionX + col * (kButtonW + kButtonMargin);
        CGFloat y = row * (kButtonH + kButtonMargin);
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, kButtonW, kButtonH)];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateHighlighted];
        [button setTitle:question.options[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button addTarget:self action:@selector(optionClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.optionView addSubview:button];
    }
}

- (void)answerClick: (UIButton *)button
{
    if (button.currentTitle.length == 0) {
        return;
    }
    for (UIButton *btn in self.answerView.subviews) {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    for (UIButton *btn in self.optionView.subviews) {
        if ([btn.currentTitle isEqualToString:button.currentTitle] && btn.isHidden) {
            btn.hidden = NO;
            [button setTitle:nil forState:UIControlStateNormal];
            break;
        }
    }
}

- (void)optionClick: (UIButton *)button
{
    //将备选按钮文字填充到答案区中第一个空按钮，填充后隐藏备选按钮
    for (UIButton *btn in self.answerView.subviews) {
        if (btn.currentTitle.length == 0) {
            [btn setTitle:button.currentTitle forState:UIControlStateNormal];
            button.hidden = YES;
            break;
        }
    }
    //答案的处理：
    //1、首先判断答案按钮是否均不为空，若均不为空
    //  则开始判断答案是否正确，若正确，则显示为蓝色0.5s，然后切换至下一题；
    //  若错误，则显示为红色
    NSMutableString *answerString = [NSMutableString stringWithFormat:@""];
    BOOL isFull = YES;
    for (UIButton *btn in self.answerView.subviews) {
        if (btn.currentTitle.length == 0) {
            isFull = NO;
            break;
        }else{
            [answerString appendString:btn.currentTitle];
//            NSLog(@"%@", answerString);
        }
    }
    
    if (isFull) {
        Question *question = [self.questions objectAtIndex:self.index];
//        NSLog(@"%@ %@", question.answer, answerString);
        if ([answerString isEqualToString:question.answer]) {
            [self changeScore:500];
            for (UIButton *btn in self.answerView.subviews) {
                [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }
            [self performSelector:@selector(nextQuestion) withObject:nil afterDelay:0.5f];
        }else{
            for (UIButton *btn in self.answerView.subviews) {
                [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        }
    }
    
}

- (IBAction)tipButton {
    if (self.index >= [self.questions count]) {
        return;
    }
    for (UIButton *btn in self.answerView.subviews) {
        if (btn.currentTitle.length != 0) {
            [self answerClick:btn];
        }
    }
    Question *question = self.questions[self.index];
    NSString *tipString = [question.answer substringWithRange:(NSRange){0,1}];
    for (UIButton *btn in self.optionView.subviews) {
        if ([btn.currentTitle isEqualToString:tipString]) {
            [self optionClick:btn];
        }
    }
//    NSLog(@"%d",self.index);
    [self changeScore:-1000];
}

- (void)changeScore: (int)score
{
    int s = [self.scoreButton.currentTitle integerValue];
    s += score;
    [self.scoreButton setTitle:[NSString stringWithFormat:@"%d",s] forState:UIControlStateNormal];
}

@end
