//
//  ButtonViewController.m
//  Calculator
//
//  Created by Karan Ghorai on 15/06/21.
//

#import "ButtonViewController.h"

@interface ButtonViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *inputButtonsCollectionView;
- (IBAction)inputButtonsAction:(id)sender;
- (IBAction)clearButtonAction:(id)sender;
- (IBAction)openingBracketButtonAction:(id)sender;
- (IBAction)closingBracketButtonAction:(id)sender;


@end

@implementation ButtonViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    int i=0;
    
    for(i=0; i < [_inputButtonsCollectionView count]; i++){
        UIButton *btn = [_inputButtonsCollectionView objectAtIndex:i];
        btn.layer.cornerRadius = btn.bounds.size.height/2;
    }
}

- (IBAction)closingBracketButtonAction:(id)sender {
    [_mainViewControllerDelegate addClosingBracket];
}

- (IBAction)openingBracketButtonAction:(id)sender {
    [_mainViewControllerDelegate addOpenningBracket];
}

- (IBAction)clearButtonAction:(id)sender {
    [_mainViewControllerDelegate clearText];
    [_mainViewControllerDelegate setLabelToNil];
}

- (IBAction)inputButtonsAction:(id)sender {
    [_mainViewControllerDelegate addInput:[NSMutableString stringWithFormat:@"%ld",[sender tag]-1]];
}
@end
