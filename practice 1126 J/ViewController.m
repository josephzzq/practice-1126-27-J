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

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate,MBProgressHUDDelegate,UITextFieldDelegate>
{
    NSMutableArray *dataSource;
    NSArray *detailDataSource;
    MBProgressHUD  *progressHUD;
    NSTimer *_timer;
    double timerNumber;

}



@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *startTimer;
@property (weak, nonatomic) IBOutlet UIButton *pauseTimer;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end




@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title=@"Yawooo";
    
    
    dataSource = [NSMutableArray  arrayWithCapacity:0];
    
    detailDataSource = [NSArray arrayWithObjects:@"Abstract1", @"Abstract2", @"Abstract3", @"Abstract4", @"Abstract5", @"Abstract6", @"Abstract7", @"Abstract8", nil];
    
    
    // UIButton layout
    [self.startTimer.layer setCornerRadius:10.0f];
    [self.startTimer.layer setBorderColor:[[UIColor brownColor]CGColor] ];
    [self.startTimer.layer setBorderWidth:3.0f];
    
    [self.pauseTimer.layer setCornerRadius:10.0f];
    [self.pauseTimer.layer setBorderColor:[[UIColor redColor] CGColor]];
    [self.pauseTimer.layer setBorderWidth:4.0f];
    
    
    
    
    // add more button in navigation item
    UIButton *a1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [a1 setFrame:CGRectMake(0.0f, 0.0f, 46.0f, 29.0f)];
    [a1 addTarget:self action:@selector(enterEditMode:) forControlEvents:(UIControlEventTouchUpInside)];
    [a1 setTitle:@"編輯" forState:(UIControlStateNormal)];
    [a1.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [a1 setTitleColor:[UIColor purpleColor] forState:(UIControlStateNormal)];
    a1.titleLabel.textColor =[UIColor blackColor];
    UIBarButtonItem *right1Button = [[UIBarButtonItem alloc] initWithCustomView:a1];
    
    
    
    UIButton *a2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [a2 setFrame:CGRectMake(0.0f, 0.0f, 46.0f, 29.0f)];
    [a2 addTarget:self action:@selector(leaveEditMode:) forControlEvents:(UIControlEventTouchUpInside)];
    [a2 setTitle:@"結束" forState:(UIControlStateNormal)];
    [a2.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [a2 setTitleColor:[UIColor purpleColor] forState:(UIControlStateNormal)];
    a2.titleLabel.textColor =[UIColor blackColor];
    UIBarButtonItem *right2Button = [[UIBarButtonItem alloc] initWithCustomView:a2];
    
    self.navigationItem.rightBarButtonItems =@[right1Button,right2Button];
    
    
    
    
    [self.textField becomeFirstResponder];
    [self getRemoteURL];

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Bar Button items press action


-(void)enterEditMode:(id)sender{
    NSLog(@"enterEditMode");
}

-(void)leaveEditMode:(id)sender{
    NSLog(@"leaveEditMode");
}



#pragma mark - timer setup


-(void)timerEvent:(NSTimer*)timer{
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提醒" message:@"已登出" delegate:self cancelButtonTitle:@"確認" otherButtonTitles: nil];
    [alert show];
    
}


- (IBAction)startTimer:(id)sender {

    double interval= 3.0f;
    _timer =[NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timerEvent:) userInfo:nil repeats:true];
    
    }


- (IBAction)stopTimer:(id)sender {

    [_timer invalidate];
    
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提醒" message:@"已停止" delegate:self cancelButtonTitle:@"確認" otherButtonTitles: nil];
    [alert show];

}




#pragma mark - replace empty space string in textField


- (IBAction)complete:(id)sender {
    
    
    NSString *final =[self.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSLog(@"Enter:%@" ,final);
    //NSLog(@"Enter:%@" ,self.textField.text);
    [self.textField resignFirstResponder];
}





#pragma mark - UITextFieldDelegate

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldEndEditing");

    return YES;
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
    
    NSLog(@"A Dictionary: %@", dataSource[indexPath.row]);
    
    
    
    cell.textLabel.text = dataSource[indexPath.row][@"current_time"];
    cell.detailTextLabel.text = detailDataSource[indexPath.row];
    
    
    // add button via coding
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(230, 30, 80, 40)];
    [button setTitle:@"Open Web" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName: @"AvenirNextCondensed-Bold" size: 12.0];
    [button setBackgroundColor:[UIColor brownColor]];
    button.tag = indexPath.row;
    
    
    // add button action
    [button addTarget:self action:@selector(openWeb:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:button];
    
    [button.layer setCornerRadius:10.0f];
    [button.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [button.layer setBorderWidth:2.0f];
    
    
    
    return cell;
}


// openWeb via input textFied text (URL scheme)
-(void)openWeb:(id)sender{
    NSString *url = [NSString stringWithFormat:@"http://%@", self.textField.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}




#pragma mark - AFNetworking getRemoteURL


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
