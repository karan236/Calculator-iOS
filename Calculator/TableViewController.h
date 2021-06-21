//
//  TableViewController.h
//  Calculator
//
//  Created by Karan Ghorai on 16/06/21.
//

#import <UIKit/UIKit.h>
#import "DataTransferDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface TableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
-(void)reloadTableData;

@property (retain,nonatomic) id<DataTransferDelegate> mainViewControllerDelegate;

@end

NS_ASSUME_NONNULL_END
