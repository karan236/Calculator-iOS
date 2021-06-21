//
//  ButtonViewController.h
//  Calculator
//
//  Created by Karan Ghorai on 15/06/21.
//

#import <UIKit/UIKit.h>
#import "DataTransferDelegate.h"

@interface ButtonViewController : UIViewController

@property (retain,nonatomic) id<DataTransferDelegate> mainViewControllerDelegate;
@end
