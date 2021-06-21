//
//  ViewController.h
//  Calculator
//
//  Created by Karan Ghorai on 15/06/21.
//

#import <UIKit/UIKit.h>
#import "ButtonViewController.h"
#import "TableViewController.h"
#import "DataTransferDelegate.h"

@interface ViewController : UIViewController <DataTransferDelegate>
{
    ButtonViewController *buttonViewController;
    TableViewController *tableViewController;
}

@end

