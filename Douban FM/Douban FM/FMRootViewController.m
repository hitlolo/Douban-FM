//
//  FMRootViewController.m
//  Douban FM
//
//  Created by Lolo on 15/5/23.
//  Copyright (c) 2015年 Lolo. All rights reserved.
//

#import "FMRootViewController.h"

enum
{
    BUTTON_PLAYER = 0,
    BUTTON_USER,
    BUTTON_CHANNELS,
    BUTTON_DISMISS
};

@interface FMRootViewController ()
{
    CDSideBarController   *sideBar;
}

@property (weak,nonatomic)FMPlayViewController *playViewController;



@end

@implementation FMRootViewController


- (void)awakeFromNib
{
    
    [self initPlayerView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBar.hidden = YES;
   
    //[self initPlayerView];
    //[self initChanelSideBar];
        
 
    [self initSideBar];
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [sideBar insertMenuButtonOnView:self.view atPosition:CGPointMake(self.view.frame.size.width - 50, 40)];
    
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
#pragma mark - Player View

- (void)initPlayerView
{
    // CGRect frame = [[UIScreen mainScreen]bounds];
    self.playViewController = self.viewControllers[0];
    
}

#pragma mark -
#pragma mark - Side Bar Methods
- (void) initSideBar
{
    NSArray *imageList = @[[UIImage imageNamed:@"menuPlayer"],
                           [UIImage imageNamed:@"menuLogin"],
                           [UIImage imageNamed:@"menuChannel"],
                           [UIImage imageNamed:@"menuClose.png"]];
    
    sideBar = [CDSideBarController sharedInstanceWithImages:imageList];
    sideBar.delegate = self;

}


- (void)menuButtonClicked:(int)index
{
    
    switch (index) {
        case BUTTON_PLAYER:
            self.selectedIndex = BUTTON_PLAYER;
            break;
        case BUTTON_USER:
            self.selectedIndex = BUTTON_USER;
            break;
        case BUTTON_CHANNELS:
            [self showChannelBar];
            break;
        case BUTTON_DISMISS :
            [self dismissChannelBar];
            break;
        default:
            break;
    }
}

- (void)dismissChannelBar
{
    [self.playViewController dismssChannelBar];
}


- (void)showChannelBar
{
    if (self.selectedIndex == BUTTON_PLAYER)
    {
        [self.playViewController showChannelBar];
    }
    if (self.selectedIndex == BUTTON_USER)
    {
        self.selectedIndex = BUTTON_PLAYER;
        [self.playViewController showChannelBar];
    }
    
}


@end
