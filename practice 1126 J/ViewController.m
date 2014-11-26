//
//  ViewController.m
//  practice 1126 J
//
//  Created by Joseph on 2014/11/26.
//  Copyright (c) 2014年 dosomethingq. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate,MBProgressHUDDelegate>
{
    NSMutableArray *dataSource;
    NSArray *detailDataSource;
    MBProgressHUD  *progressHUD;
}



@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end




@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title=@"Yawooo";
    dataSource = [NSMutableArray  arrayWithCapacity:0];
    
    detailDataSource = [NSArray arrayWithObjects:@"Abstract1", @"Abstract2", @"Abstract3", @"Abstract4", @"Abstract5", @"Abstract6", @"Abstract7", @"Abstract8", nil];
    [self getRemoteURL];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - initalizeMBProgressHUD


-(void)initalizeMBProgressHUD:(NSString*) msg{
    
    
    if (progressHUD)
        [progressHUD removeFromSuperview];
    
    progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progressHUD];
    progressHUD.dimBackground = NO;
    progressHUD.delegate=self;
    progressHUD.dimBackground = YES;
    progressHUD.labelText = msg;
    progressHUD.margin = 20.f;
    progressHUD.yOffset = 10.f;
    progressHUD.removeFromSuperViewOnHide = YES;
    [progressHUD show:YES];
    
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    NSString *CellIdentifier = @"DefaultTableViewCell1";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
    } else {
        NSLog(@"I have been initialize. Row = %li", (long)indexPath.row);
    }
    
    
    
    
    cell.textLabel.text = dataSource[indexPath.row][@"current_time"];
    cell.detailTextLabel.text = detailDataSource[indexPath.row];
    
    
    return cell;
}


- (void)getRemoteURL
{
    [self initalizeMBProgressHUD:@"loading..."];
    
    // Prepare the HTTP Client
    AFHTTPClient *httpClient =
    [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://106.187.98.65/"]];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:@"api/v1/AlphaCampTest.php"
                                                      parameters:nil];
    
    // Set the opration
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    // Set the callback block
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [progressHUD hide:YES];
        
        NSString *tmp = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Response: %@",tmp);
        
        NSData *rawData = [tmp dataUsingEncoding:NSUTF8StringEncoding];
        NSError *e;
        NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:rawData options:NSJSONReadingMutableContainers error:&e]; // option:base on JASON format to determine what kind of format need to use
        
        NSString *RC =[NSString stringWithFormat:@"%@",[dict objectForKey:@"RC"]];
        NSString *RM= [NSString stringWithFormat:@"%@",[dict objectForKey:@"RM"]];
        
        
        NSArray * listData=[dict objectForKey:@"result"];
        
        NSLog(@"RC:%@",RC);
        NSLog(@"RM:%@",RM);
        NSLog(@"Result :%@",listData);
        
        NSInteger arrayLength =[listData count];
        NSLog(@"count is %lu",(unsigned long)[listData count]);
        
        if (arrayLength >0){
            [dataSource removeAllObjects];
            for(int i=0 ; i <arrayLength; i++){
                NSDictionary *innerDict=listData[i];
                [dataSource addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                       [innerDict objectForKey:@"announcement_version"],@"announcement_version",
                                       [innerDict objectForKey:@"deliver_time"],@"deliver_time",
                                       [innerDict objectForKey:@"waiting_time"],@"waiting_time",
                                       [innerDict objectForKey:@"current_time" ],@"current_time", nil]];
                
                NSLog(@"dataSource %@",dataSource);
                
            }
        }
        
        NSLog(@"Array Length:%ld",(long)arrayLength);
        [self.tableView reloadData];

        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"完成" delegate:self cancelButtonTitle:@"關閉" otherButtonTitles:nil];
        [alert show];
        

        
        
        // Test Log
        NSLog(@"Response: %@", tmp);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error");
    }];
    
    // Start the opration
    [operation start];
}


@end
