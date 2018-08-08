//
//  ViewController.m
//  PayPassWord
//
//  Created by Superman on 2018/8/7.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "ViewController.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField*textField;
@property(nonatomic,strong)NSMutableArray*pswArray;
@property(nonatomic,unsafe_unretained)BOOL isNext;
@property(nonatomic,copy)NSString*firstPsw;

@property(nonatomic,strong)UIButton*nextBtn;
@property(nonatomic,strong)UILabel*titleLabel;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.nextBtn.backgroundColor = [UIColor lightGrayColor];
    
    self.pswArray = [[NSMutableArray alloc]init];
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.textField.hidden = YES;
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.textField becomeFirstResponder];
    [self.textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.textField];
    
    UILabel *lab=[[UILabel alloc]init];
    lab.frame=CGRectMake(10,100 ,SCREEN_WIDTH-10*2 ,25 );
    lab.font=[UIFont systemFontOfSize:13];
    lab.textColor=[UIColor grayColor];
    lab.textAlignment=NSTextAlignmentCenter;
    lab.text=@"请输入新的支付密码";
    [self.view addSubview:lab];
    
    CGFloat pswWid=(SCREEN_WIDTH-10*2)/6;
    CGFloat pswHei=45;

    for (int i = 0; i < 6; i++)
    {
        UITextField * pswTF = [[UITextField alloc]init];
        pswTF.frame=CGRectMake(10+(pswWid-1)*i,150 , pswWid, pswHei);
        pswTF.borderStyle=UITextBorderStyleLine;
        pswTF.secureTextEntry = YES;
        pswTF.tag=i+1;
        pswTF.textAlignment=NSTextAlignmentCenter;
        pswTF.layer.borderColor = [[UIColor grayColor]CGColor];
        pswTF.layer.borderWidth = 1;
        pswTF.delegate = self;
        [self.view addSubview:pswTF];
    }
    
    UIButton *nextBtn=[[UIButton alloc]init];
    nextBtn.frame=CGRectMake(30,230 ,SCREEN_WIDTH-60 ,40 );
    [nextBtn setBackgroundColor:[UIColor grayColor]];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(clickNextBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    
}
-(void)clickNextBtn:(UIButton *)sender{
    if (!self.isNext)
    {
        if (self.textField.text.length < 6)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入六位支付密码" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                //            viewcontroller.tabBarController.selectedViewController = viewcontroller;
                self.textField.text = @"";
                for (int i = 0; i < 6; i++)
                {
                    UITextField *pwdTextField= [self.view viewWithTag:i+1];
                    pwdTextField.text = @"";
                }
                [self.textField becomeFirstResponder];
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        [self.pswArray removeAllObjects];
        for (int i = 0; i < 6; i++)
        {
            NSString *pwd = [self.textField.text substringWithRange:NSMakeRange(i, 1)];
            [self.pswArray addObject:pwd];
        }
        
        //判断数字是否重复
        if ([self.pswArray[0] isEqualToString:self.pswArray[1]] && [self.pswArray[1] isEqualToString:self.pswArray[2]] && [self.pswArray[2] isEqualToString:self.pswArray[3]] && [self.pswArray[3] isEqualToString:self.pswArray[4]] && [self.pswArray[4] isEqualToString:self.pswArray[5]])
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"禁止单数字重复" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                self.textField.text = @"";
                for (int i = 0; i < 6; i++)
                {
                    UITextField *pwdTextField= [self.view viewWithTag:i+1];
                    pwdTextField.text = @"";
                }
                [self.textField becomeFirstResponder];
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        if ([self.pswArray[0] integerValue] == [self.pswArray[1] integerValue] + 1  && [self.pswArray[1] integerValue] == [self.pswArray[2] integerValue] + 1 && [self.pswArray[2] integerValue] == [self.pswArray[3] integerValue] + 1 && [self.pswArray[3] integerValue] == [self.pswArray[4] integerValue] + 1 && [self.pswArray[4] integerValue] == [self.pswArray[5] integerValue] + 1)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"禁止密码呈递减排列" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                self.textField.text = @"";
                for (int i = 0; i < 6; i++)
                {
                    UITextField *pwdTextField= [self.view viewWithTag:i+1];
                    pwdTextField.text = @"";
                }
                [self.textField becomeFirstResponder];
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        if ([self.pswArray[0] integerValue] == [self.pswArray[1] integerValue] - 1  && [self.pswArray[1] integerValue] == [self.pswArray[2] integerValue] - 1 && [self.pswArray[2] integerValue] == [self.pswArray[3] integerValue] - 1 && [self.pswArray[3] integerValue] == [self.pswArray[4] integerValue] - 1 && [self.pswArray[4] integerValue] == [self.pswArray[5] integerValue] - 1)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"禁止密码呈递增排列" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                self.textField.text = @"";
                for (int i = 0; i < 6; i++)
                {
                    UITextField *pwdTextField= [self.view viewWithTag:i+1];
                    pwdTextField.text = @"";
                }
                [self.textField becomeFirstResponder];
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            return;
            
        }
        
        
        self.firstPsw = self.textField.text;
        
        self.titleLabel.text = @"请确认支付密码";
        self.textField.text = @"";
        for (int i = 0; i < 6; i++)
        {
            UITextField *pwdTextField= [self.view viewWithTag:i+1];
            pwdTextField.text = @"";
        }
        [self.textField becomeFirstResponder];
        
        self.isNext = YES;
        
    }else
    {
        if ([self.textField.text isEqualToString:@""])
        {
            return;
        }
        if ([self.firstPsw isEqualToString:self.textField.text])
        {
            //修改成功的处理
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"两次密码不一致请重新输入" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                //            viewcontroller.tabBarController.selectedViewController = viewcontroller;
                self.isNext = NO;
                self.firstPsw = @"";
                
                self.titleLabel.text = @"请输入新的支付密码";
                self.textField.text = @"";
                self.textField.text = @"";
                for (int i = 0; i < 6; i++)
                {
                    UITextField *pwdTextField= [self.view viewWithTag:i+1];
                    pwdTextField.text = @"";
                }
                [self.textField becomeFirstResponder];
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            
            //            self.isNext = NO;
            //            self.firstPsw = @"";
            //
            //            self.titleLabel.text = @"请输入新的支付密码";
            //            self.textField.text = @"";
            //            [self performSelector:@selector(clearPswTest) withObject:self afterDelay:1];
            
        }
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.textField becomeFirstResponder];
    return NO;
}
#pragma mark - 文本框内容改变
- (void)textChange:(UITextField *)textField {
    NSString *password = textField.text;
    if (password.length > 6) {
        textField.text = [password substringToIndex:6];
        return;
    }
    
    for (int i = 0; i < 6; i++)
    {
        UITextField *pwdTextField= [self.view viewWithTag:i+1];
        if (i < password.length) {
            NSString *pwd = [password substringWithRange:NSMakeRange(i, 1)];
            pwdTextField.text = pwd;
        } else {
            pwdTextField.text = nil;
        }
        
    }
    if (password.length == 6)
    {
        [textField resignFirstResponder];//隐藏键盘
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
