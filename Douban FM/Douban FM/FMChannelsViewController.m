//
//  FMChannelsViewController.m
//  Douban FM
//
//  Created by Lolo on 15/5/25.
//  Copyright (c) 2015年 Lolo. All rights reserved.
//

#import "FMChannelsViewController.h"
#import "FMPlayer.h"

@interface FMChannelsViewController ()
{
    UITableView *tableView;
    FMPlayer *player;
    NSArray  *array;
}

@end

@implementation FMChannelsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    tableView = [[UITableView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    [self.view addSubview:tableView];
    player = [FMPlayer sharedInstance];
    tableView.delegate = self;
    tableView.sectionHeaderHeight = 80;
    tableView.rowHeight = 60;
    //self.clearsSelectionOnViewWillAppear = YES;
   
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ChannelCell"];
   
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    array = @[@"1",@"2",@"3"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadTableviewData];
    NSLog(@"TABLE VIEW APPEAR");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return player.channel.channelTitle[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    NSLog(@"%d,title",[[[player channel]channelTitle]count]);
   // return [[[player channel]channelTitle]count];
    return [array count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
   // return [[[player channel]channels][section] count];
    return [array count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChannelCell" forIndexPath:indexPath];
    
    // Configure the cell...
    //cell.textLabel.text = [[player channel].channels[indexPath.section][indexPath.row] channelName];
    cell.textLabel.text = array[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    player.channel.currentChannel = [[player.channel.channels objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    //[networkManager loadPlaylistwithType:@"n"];
    
}

- (void)reloadTableviewData
{
    [tableView reloadData];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
