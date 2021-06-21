//
//  TableViewController.m
//  Calculator
//
//  Created by Karan Ghorai on 16/06/21.
//

#import "TableViewController.h"

@interface TableViewController ()
@property (strong, nonatomic) IBOutlet UIButton *historyButton;
- (IBAction)clearHistoryButtonAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _historyButton.layer.cornerRadius = _historyButton.bounds.size.height / 2;
}

-(void)viewWillAppear:(BOOL)animated{

}

-(void)viewDidAppear:(BOOL)animated{
}


-(void)reloadTableData{
    [_tableView reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *filePath = @"/Users/karanghorai/Desktop/Practice Codes/Calculator/Calculator/HistoryData.plist";
    NSMutableArray *historyData = [NSMutableArray arrayWithContentsOfFile:filePath];
    return [historyData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSString *filePath = @"/Users/karanghorai/Desktop/Practice Codes/Calculator/Calculator/HistoryData.plist";
    NSMutableArray *historyData = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    UILabel *expressionLabel = (UILabel *) [cell viewWithTag:1];
    UILabel *resultLabel = (UILabel *) [cell viewWithTag:2];
    NSRange range = [[historyData objectAtIndex:([historyData count] - indexPath.row) - 1] rangeOfString:@" = "];
    
    expressionLabel.text = [NSString stringWithString:[[historyData objectAtIndex:([historyData count] - indexPath.row) - 1] substringToIndex:range.location]];
    resultLabel.text = [NSString stringWithString: [[historyData objectAtIndex:([historyData count] - indexPath.row) - 1] substringFromIndex:range.location + 1]];

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *filePath = @"/Users/karanghorai/Desktop/Practice Codes/Calculator/Calculator/HistoryData.plist";
    NSMutableArray *historyData = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    NSRange range = [[historyData objectAtIndex:([historyData count] - indexPath.row) - 1] rangeOfString:@" = "];
    NSString *expression = [NSString stringWithString:[[historyData objectAtIndex:([historyData count] - indexPath.row) - 1] substringToIndex:range.location]];
    NSString *result = [NSString stringWithString: [[historyData objectAtIndex:([historyData count] - indexPath.row) - 1] substringFromIndex:range.location + 1]];
    
    [_mainViewControllerDelegate setDataFromTableWithExpression:expression result:result];
}


- (IBAction)clearHistoryButtonAction:(id)sender {
    NSMutableArray *emptyArray = [[NSMutableArray alloc] init];
    NSString *filePath = @"/Users/karanghorai/Desktop/Practice Codes/Calculator/Calculator/HistoryData.plist";
    [emptyArray writeToFile:filePath atomically:YES];
    
    [self reloadTableData];
}



@end

