//
//  FMLoginViewController.m
//  Douban FM
//
//  Created by Lolo on 15/5/26.
//  Copyright (c) 2015年 Lolo. All rights reserved.
//

#import "FMLoginViewController.h"
#import <UIImageView+AFNetworking.h>
#import <AFNetworkActivityIndicatorManager.h>


@interface FMLoginViewController ()

@end

@implementation FMLoginViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initFromNib];
       
    }
    return self;
}



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initTextFields];
    [self initResignResponderAction];
   
    
}

- (void)didReceiveMemoryWarning
{
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



#pragma mark -
#pragma mark - self init


- (void)initFromNib
{
    [[NSBundle mainBundle] loadNibNamed:@"FMLoginViewController" owner:self options:nil];
    CGRect frame = [[UIScreen mainScreen]bounds];
    self.view.frame = frame;
    //[self.contentView addSubview:self.view];
    
}


#pragma mark -
#pragma mark - button actions

- (void)backgroundTapped
{
    [self.usernameText resignFirstResponder];
    [self.passwordText resignFirstResponder];
    [self.captchaText resignFirstResponder];
}

- (IBAction)loginPressed:(UIButton *)sender
{
    [self doLogin];
}

- (IBAction)cancelPressed:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doLogin
{
    NSString *username = self.usernameText.text;
    NSString *password = self.passwordText.text;
    NSString *captcha  = self.captchaText.text;
    
    [self loginWithUsername:username Password:password Captcha:self.captcha CaptchaSolution:captcha];
}


#pragma mark -
#pragma mark - text Field

- (void)initTextFields
{
    self.usernameText.delegate = self;
    self.passwordText.delegate = self;
    self.captchaText.delegate  = self;
}

- (void)initResignResponderAction
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped)];
    [singleTap setNumberOfTapsRequired:1];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:singleTap];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.captchaText)
    {
        [self getCaptcha];
      
    }
    return YES;
}



#pragma mark -
#pragma mark - Net Working

- (void)getCaptcha
{
    NSString *captchaID_url =  @"http://douban.fm/j/new_captcha";
    NSString *captchaImage_url = @"http://douban.fm/misc/captcha?size=m&id=%@";
    
    
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    
    httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [httpManager GET:captchaID_url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
             NSString *captchaID;
             NSMutableString *tempCaptchaID = [[NSMutableString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             [tempCaptchaID replaceOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempCaptchaID length])];
             captchaID = tempCaptchaID;
             NSString *captchaURL = [NSString stringWithFormat:captchaImage_url,tempCaptchaID];
             //加载验证码图片
             
             self.captcha = [FMCaptcha captchaWithID:captchaID AndURL:captchaURL];
            [self.captchaImage setImageWithURL:self.captcha.captchaURL];
            NSLog(@"%@", self.captcha.captchaID);
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"%@",error);
         }
     ];

}

//source:radio
//alias: my_email_here@xmail.com
//form_password: my_password_here
//captcha_solution: profit
//captcha_id: Rc6zxTUxDa7crcSXjdpi3tyz:en
//task: sync_channel_list


//Response
//
//Success:
//r
//value 0 , represent for succeed
//user_info
//the user info details
//Fail
//err_msg
//the error message
//err_no
//the error number
//r
//value 1 , represent for failed

//登陆成功 返回信息
//login {
//    r = 0;
//    "user_info" =     {
//        ck = L3zp;
//        id = 1831044;
//        "is_dj" = 0;
//        "is_new_user" = 0;
//        "is_pro" = 0;
//        name = Lolo;
//        "play_record" =         {
//            banned = 7;
//            "fav_chls_count" = 0;
//            liked = 85;
//            played = 7606;
//        };
//        "third_party_info" = "<null>";
//        uid = hitlolo;
//        url = "http://www.douban.com/people/hitlolo/";
//    };
//}


- (void)loginWithUsername:(NSString*)username Password:(NSString*)password Captcha:(FMCaptcha*)Captcha CaptchaSolution:(NSString*)solution
{
    
    if (username == nil || password == nil || Captcha == nil || solution == nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"输入有误" message:@"请重新输入信息！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        
    }
    else
    {
        [self cleanCookiesBeforeLogin];
        
        NSString* login_url = @"http://douban.fm/j/login";
        //NSString* url = [NSString stringWithFormat:login_url,username,password,Captcha.captchaID,solution];
        AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
        // httpManager.requestSerializer  = [AFJSONRequestSerializer serializer];
        httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
        NSDictionary *paramter = @{
                                   @"source":@"radio",
                                   @"alias":username,
                                   @"form_password":password,
                                   @"captcha_id":Captcha.captchaID,
                                   @"captcha_solution":solution,
                                   @"remember":@"off"
                                   };
        
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]requestWithMethod:@"POST" URLString:login_url parameters:paramter error:nil];
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
             NSDictionary *temUserInfo = responseObject;
             //r=0 登陆成功
             if ([(NSNumber *)[temUserInfo valueForKey:@"r"] intValue] == SUCCESS)
             {
                 FMUser* user = [FMUser userByDictionary:temUserInfo];
                 BOOL is_success = [[FMPlayer sharedInstance] login: user];
                 if (is_success)
                 {
                     [self dismissViewControllerAnimated:YES completion:nil];
                 }
             }
             else 
             {
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Login Failed" message:[temUserInfo valueForKey:@"err_msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 [alertView show];
                 
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"%@",error);
         }];
        
        [[NSOperationQueue mainQueue] addOperation:operation];
    }
    
}

- (void)cleanCookiesBeforeLogin
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in [cookieJar cookiesForURL:[NSURL URLWithString:@"http://douban.fm/j/login" ]])
    {
        //NSLog(@"%@",cookie);
        
        [cookieJar deleteCookie:cookie];
    }
}

@end
