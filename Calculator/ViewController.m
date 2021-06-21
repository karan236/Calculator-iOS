//
//  ViewController.m
//  Calculator
//
//  Created by Karan Ghorai on 15/06/21.
//

#import "ViewController.h"
#import "ButtonViewController.h"
#import "TableViewController.h"


@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIView *tableViewContainer;
@property (strong, nonatomic) IBOutlet UIView *buttonViewContainer;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *inputButtonsMainViewController;
@property (strong, nonatomic) IBOutlet UIButton *historyButton;
@property (strong, nonatomic) IBOutlet UITextView *inputTextView;
@property (strong, nonatomic) IBOutlet UILabel *outputLabel;
- (IBAction)equalToButtonAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;

- (IBAction)historyButtonAction:(id)sender;
- (IBAction)arithmaticOperatorsAction:(id)sender;
- (IBAction)deleteButtonAction:(id)sender;


@end

@implementation ViewController
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   if ([[segue identifier] isEqualToString:@"buttonsViewController"])
   {
       buttonViewController = [segue destinationViewController];
       buttonViewController.mainViewControllerDelegate = self;
   }
    else if ([[segue identifier] isEqualToString:@"tableViewController"])
    {
        tableViewController = [segue destinationViewController];
        tableViewController.mainViewControllerDelegate = self;
    }
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

-(void)setDataFromTableWithExpression:(NSString *)expression result:(NSString *)result{
    _inputTextView.text = expression;
    _outputLabel.text = result;
}

-(NSInteger)getCurrentCursorPosition{
    UITextRange *myRange = _inputTextView.selectedTextRange;
    UITextPosition *myPosition = myRange.start;
    NSInteger currentCursorPosition = [_inputTextView offsetFromPosition:_inputTextView.beginningOfDocument toPosition:myPosition];
    return currentCursorPosition;
}

-(void)setCursorAt: (NSInteger) position{
    NSRange range = NSMakeRange(position, 0);
    UITextPosition *start = [_inputTextView positionFromPosition:[_inputTextView beginningOfDocument] offset:range.location];
    UITextPosition *end = [_inputTextView positionFromPosition:start offset:range.length];
    [_inputTextView setSelectedTextRange:[_inputTextView textRangeFromPosition:start toPosition:end]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITextView appearance] setTintColor:[UIColor greenColor]];
    UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    _inputTextView.inputView = dummyView;
    
    UIImage *selectedImage = [UIImage imageNamed:@"CalculatorImage.png"];
    [_historyButton setImage:selectedImage forState:UIControlStateSelected];
    
    UIImage *normalImage = [UIImage imageNamed:@"HistoryIcon.png"];
    [_historyButton setImage:normalImage forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated{
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    for(int i = 0; i < [_inputButtonsMainViewController count]; i++){
        UIButton *btn = [_inputButtonsMainViewController objectAtIndex:i];
        btn.layer.cornerRadius = btn.bounds.size.height/2;
    }
     
    [_inputTextView becomeFirstResponder];
    
}


-(void)addDataToFileForInputExpression:(NSString *) inputExpression result:(NSString *) result{
    NSString *filePath = @"/Users/karanghorai/Desktop/Practice Codes/Calculator/Calculator/HistoryData.plist";
    NSMutableArray *historyData = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    if(historyData == NULL){
        historyData = [[NSMutableArray alloc] init];
    }
   if ([historyData count] == 10){
        [historyData removeObjectAtIndex:0];
    }
    [historyData addObject:[NSString stringWithFormat:@"%@ %@",inputExpression,result]];
    [historyData writeToFile:filePath atomically:YES];
}


- (IBAction)deleteButtonAction:(id)sender {
    NSMutableString *presentInputString = [_inputTextView.text mutableCopy];
    NSInteger currentCursorPosition = [self getCurrentCursorPosition];
    if (currentCursorPosition > 0){
        [presentInputString replaceCharactersInRange:NSMakeRange(currentCursorPosition - 1, 1) withString:@""];
        _inputTextView.text = presentInputString;
        [self setCursorAt: currentCursorPosition - 1];
        [self setLabelToNil];
    }
}

- (IBAction)arithmaticOperatorsAction:(id)sender {
    [self setLabelToNil];
    NSArray *operators = @[@"÷",@"x",@"-",@"+",@"("];
    
    NSMutableString *presentInputString = [_inputTextView.text mutableCopy];
    
    if ([self getCurrentCursorPosition]>0){
        NSInteger currentCursorPosition = [self getCurrentCursorPosition];
        
        NSString *characterAtLeftOfCursor = [presentInputString substringWithRange:NSMakeRange(currentCursorPosition - 1, 1)];
        
        BOOL isCharacterAtLeftOfCursorOperator = NO;
        
        for(int i = 0; i<5 ; i++){
            if([characterAtLeftOfCursor isEqualToString: [operators objectAtIndex:i]]){
                isCharacterAtLeftOfCursorOperator = YES;
                break;
            }
            
        }
        
        if ([characterAtLeftOfCursor isEqualToString:@"("]){
            return;
        }
        
        if(isCharacterAtLeftOfCursorOperator){
            if(![[operators objectAtIndex:[sender tag] - 11] isEqualToString: characterAtLeftOfCursor]){
                [presentInputString replaceCharactersInRange:NSMakeRange(currentCursorPosition - 1, 1) withString:[operators objectAtIndex:[sender tag] - 11]];
                _inputTextView.text = presentInputString;
                [self setCursorAt: currentCursorPosition];
            }

        }
        else{
            [presentInputString insertString:[operators objectAtIndex:[sender tag] - 11] atIndex:currentCursorPosition];
            _inputTextView.text = presentInputString;
            [self setCursorAt:currentCursorPosition + 1];
        }
    }
}

- (void)showToastMessage:(NSString *)Message {
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil
                                                                  message:@""
                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIView *firstSubview = alert.view.subviews.firstObject;
    UIView *alertContentView = firstSubview.subviews.firstObject;
    for (UIView *subSubView in alertContentView.subviews) {
        subSubView.backgroundColor = [UIColor grayColor];
    }
    NSMutableAttributedString *AS = [[NSMutableAttributedString alloc] initWithString:Message];
    [AS addAttribute: NSForegroundColorAttributeName value: [UIColor whiteColor] range: NSMakeRange(0,AS.length)];
    [alert setValue:AS forKey:@"attributedTitle"];
    [self presentViewController:alert animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:^{
        }];
    });
}


- (IBAction)historyButtonAction:(id)sender {
    _historyButton.selected = !_historyButton.selected;
    _buttonViewContainer.hidden = _historyButton.isSelected;
}

- (IBAction)equalToButtonAction:(id)sender {
    BOOL isLastCharacterOperator = NO;
    NSArray *operators = @[@"÷",@"x",@"-",@"+"];
    for(int i=0 ; i<[operators count]; i++){
        if([[_inputTextView.text substringWithRange:NSMakeRange([_inputTextView.text length] - 1, 1)] isEqualToString:[operators objectAtIndex:i]]){
            isLastCharacterOperator = YES;
            break;
        }
    }
    if (isLastCharacterOperator == YES){
        [self showToastMessage:@"Invalid input"];
    }
    if (![_inputTextView.text isEqualToString:@""] && isLastCharacterOperator == NO){
        NSMutableString *result = [[self calculate:_inputTextView.text] mutableCopy];
        if([result isEqualToString:@""]){
            return;
        }
        [result insertString:@"= " atIndex:0];
        _resultLabel.text = result;
        
        [self addDataToFileForInputExpression:_inputTextView.text result:result];
        
        [tableViewController reloadTableData];
    }
//    NSLog(@"%@", [self calculate:_inputTextView.text]);
}


-(void)setLabelToNil{
    _resultLabel.text = @"";
}


-(NSString *)calculate:(NSString *) expression{
    NSDictionary *operatorPriorities = @{@"+":@1,@"-":@1,@"x":@2,@"÷":@2,@"(":@0};
    NSMutableArray *valueStack = [NSMutableArray array];
    NSMutableArray *operatorStack = [NSMutableArray array];
    
    NSArray *operators = @[@"÷",@"x",@"-",@"+",@"(",@")"];
    NSMutableString *currentNumber = [NSMutableString stringWithString:@""];
    for(int i=0; i<[expression length]; i++){
        BOOL isCurrentCharacterOperator = NO;
        
        for(int j=0; j<[operators count]; j++){
            if([[expression substringWithRange:NSMakeRange(i, 1)] isEqualToString:[operators objectAtIndex:j]] ){
                isCurrentCharacterOperator = YES;
                break;
            }
        }
        if (!isCurrentCharacterOperator){
            [currentNumber appendString:[expression substringWithRange:NSMakeRange(i, 1)]];
            if (i == [expression length] - 1){
                [valueStack addObject:currentNumber];
            }
        }
        else{
            if(![currentNumber isEqualToString:@""]){
                [valueStack addObject:currentNumber];
                currentNumber = [NSMutableString stringWithString:@""];
            }
//            NSLog(@"%i",[[expression substringWithRange:NSMakeRange(i, 1)] isEqual:@")"]);
            if ([[expression substringWithRange:NSMakeRange(i, 1)] isEqual:@")"]){
                while([operatorStack count]!=0 && ![[operatorStack objectAtIndex:[operatorStack count] - 1] isEqualToString:@"("]){
                    NSString *poppedOperator = [operatorStack objectAtIndex:[operatorStack count]-1];
                    [operatorStack removeObjectAtIndex:[operatorStack count] - 1];
                    NSInteger secondOperant = [[valueStack objectAtIndex:[valueStack count] - 1] integerValue];
                    [valueStack removeObjectAtIndex:[valueStack count] - 1];
                    NSInteger firstOperant = [[valueStack objectAtIndex:[valueStack count] - 1] integerValue];
                    [valueStack removeObjectAtIndex:[valueStack count] - 1];
                    NSInteger result = 0;
                    if([poppedOperator isEqualToString:@"+"]){
                        result = firstOperant + secondOperant;
                    }
                    else if([poppedOperator isEqualToString:@"-"]){
                        result = firstOperant - secondOperant;
                    }
                    else if([poppedOperator isEqualToString:@"x"]){
                        result = firstOperant * secondOperant;
                    }
                    else if([poppedOperator isEqualToString:@"÷"]){
                        if (secondOperant == 0){
                            [self showToastMessage:@"Division by 0 not allowed"];
                            return @"";
                        }
                        result = firstOperant / secondOperant;
                    }
                    [valueStack addObject:[NSString stringWithFormat:@"%ld",result]];
                }
                [operatorStack removeObjectAtIndex:[operatorStack count] - 1];
            }
            else{
                while([operatorStack count]!=0 && [[operatorPriorities valueForKey:[operatorStack objectAtIndex:[operatorStack count]-1]] integerValue] >= [[operatorPriorities valueForKey:[expression substringWithRange:NSMakeRange(i, 1)]] integerValue] && ![[expression substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"("]){
                    
                    
//                    NSLog(@"%@  %@",[operatorPriorities valueForKey:[operatorStack objectAtIndex:[operatorStack count]-1]], [operatorPriorities valueForKey:[expression substringWithRange:NSMakeRange(i, 1)]]);
                    NSString *poppedOperator = [operatorStack objectAtIndex:[operatorStack count]-1];
                    [operatorStack removeObjectAtIndex:[operatorStack count] - 1];
                    NSInteger secondOperant = [[valueStack objectAtIndex:[valueStack count] - 1] integerValue];
                    [valueStack removeObjectAtIndex:[valueStack count] - 1];
                    NSInteger firstOperant = [[valueStack objectAtIndex:[valueStack count] - 1] integerValue];
                    [valueStack removeObjectAtIndex:[valueStack count] - 1];
                    NSInteger result = 0;
                    if([poppedOperator isEqualToString:@"+"]){
                        result = firstOperant + secondOperant;
                        [valueStack addObject:[NSString stringWithFormat:@"%ld",result]];
                    }
                    else if([poppedOperator isEqualToString:@"-"]){
                        result = firstOperant - secondOperant;
                        [valueStack addObject:[NSString stringWithFormat:@"%ld",result]];
                    }
                    else if([poppedOperator isEqualToString:@"x"]){
                        result = firstOperant * secondOperant;
                        [valueStack addObject:[NSString stringWithFormat:@"%ld",result]];
                    }
                    else if([poppedOperator isEqualToString:@"÷"]){
                        if (secondOperant == 0){
                            [self showToastMessage:@"Division by 0 not allowed"];
                            return @"";
                        }
                        result = firstOperant / secondOperant;
                        [valueStack addObject:[NSString stringWithFormat:@"%ld",result]];
                    }
                    
                    
                }
                [operatorStack addObject:[expression substringWithRange:NSMakeRange(i, 1)]];
            }
        }
    }

    while([operatorStack count]>0){
        NSString *poppedOperator = [operatorStack objectAtIndex:[operatorStack count]-1];
        [operatorStack removeObjectAtIndex:[operatorStack count] - 1];
        NSInteger secondOperant = [[valueStack objectAtIndex:[valueStack count] - 1] integerValue];
        [valueStack removeObjectAtIndex:[valueStack count] - 1];
        NSInteger firstOperant = [[valueStack objectAtIndex:[valueStack count] - 1] integerValue];
        [valueStack removeObjectAtIndex:[valueStack count] - 1];
        NSInteger result = 0;
        if([poppedOperator isEqualToString:@"+"]){
            result = firstOperant + secondOperant;
            [valueStack addObject:[NSString stringWithFormat:@"%ld",result]];
        }
        else if([poppedOperator isEqualToString:@"-"]){
            result = firstOperant - secondOperant;
            [valueStack addObject:[NSString stringWithFormat:@"%ld",result]];
        }
        else if([poppedOperator isEqualToString:@"x"]){
            result = firstOperant * secondOperant;
            [valueStack addObject:[NSString stringWithFormat:@"%ld",result]];
        }
        else if([poppedOperator isEqualToString:@"÷"]){
            if (secondOperant == 0){
                [self showToastMessage:@"Division by 0 not allowed"];
                return @"";
            }
            result = firstOperant / secondOperant;
            [valueStack addObject:[NSString stringWithFormat:@"%ld",result]];
        }
        
    }
    return [valueStack objectAtIndex:[valueStack count] - 1];
}


-(BOOL)isMaximumDigitLimitReached: (NSString *)presentInputString{
    NSInteger currentLength = 0;
    NSArray *operators = @[@"÷",@"x",@"-",@"+",@"(",@")"];
    for(long i = [self getCurrentCursorPosition] - 1; i>=0; i--){
        BOOL isCurrentCharacterOperator = NO;
        for(int j=0; j<[operators count]; j++){
            if ([[presentInputString substringWithRange:NSMakeRange(i, 1)] isEqualToString:[operators objectAtIndex:j]]){
                isCurrentCharacterOperator = YES;
                break;
            }
        }
        if (!isCurrentCharacterOperator){
            currentLength +=1;
        }
        else{
            break;
        }
    }
    
    for(long i = [self getCurrentCursorPosition]; i<[presentInputString length]; i++){
        BOOL isCurrentCharacterOperator = NO;
        for(int j=0; j<[operators count]; j++){
            if ([[presentInputString substringWithRange:NSMakeRange(i, 1)] isEqualToString:[operators objectAtIndex:j]]){
                isCurrentCharacterOperator = YES;
                break;
            }
        }
        if (!isCurrentCharacterOperator){
            currentLength +=1;
        }
        else{
            break;
        }
    }
    
    if (currentLength < 5){
        return NO;
    }
    
    [self showToastMessage:@"5 digit numbers allowed"];
    return YES;
}

//#pragma mark - DataTransferProtocol

- (void)addInput:(NSMutableString *)input{
    [self setLabelToNil];
    NSMutableString *presentInputString = [_inputTextView.text mutableCopy];
    NSInteger currentCursorPosition = [self getCurrentCursorPosition];
    if ((currentCursorPosition == 0 || [presentInputString characterAtIndex:currentCursorPosition - 1] != ')') && (![self isMaximumDigitLimitReached:presentInputString])){
        [presentInputString insertString:input atIndex:currentCursorPosition];
        _inputTextView.text = presentInputString;
        
        [self setCursorAt:currentCursorPosition + 1];
    }
    
}

-(void)addOpenningBracket{
    NSInteger currentCursorPosition = [self getCurrentCursorPosition];
    NSMutableString *presentInputString = [_inputTextView.text mutableCopy];
    if (currentCursorPosition != 0){
        NSString *characterAtLeftOfCursor = [[NSString alloc] initWithString:[presentInputString substringWithRange:NSMakeRange(currentCursorPosition - 1, 1)]];
        NSArray *operators = @[@"÷",@"x",@"-",@"+",@"("];
        
        for(int i=0; i<5; i++){
            if([characterAtLeftOfCursor isEqualToString:[operators objectAtIndex:i]]){
                [presentInputString insertString:@"(" atIndex:currentCursorPosition];
                _inputTextView.text = presentInputString;
                [self setCursorAt:currentCursorPosition + 1];
                break;
            }
        }
    }
    else{
        [presentInputString insertString:@"(" atIndex:currentCursorPosition];
        _inputTextView.text = presentInputString;
        [self setCursorAt:currentCursorPosition + 1];
    }
}

-(BOOL)isClosingBracketValidForString: (NSMutableString *) presentInputString{
    NSInteger stackCount = 0;
    for(int i = 0; i<[presentInputString length]; i++){
        if ([presentInputString characterAtIndex:i] == '('){
            stackCount+=1;
        }
        else if ([presentInputString characterAtIndex:i] == ')'){
            stackCount-=1;
        }
    }
    if(stackCount > 0){
        return YES;
    }
    else{
        return NO;
    }
}

-(void)addClosingBracket{
    NSInteger currentCursorPosition = [self getCurrentCursorPosition];
    NSMutableString *presentInputString = [_inputTextView.text mutableCopy];
    if (currentCursorPosition != 0 && [presentInputString characterAtIndex:currentCursorPosition - 1] != '(' && [self isClosingBracketValidForString:presentInputString]){
        NSString *characterAtLeftOfCursor = [[NSString alloc] initWithString:[presentInputString substringWithRange:NSMakeRange(currentCursorPosition - 1, 1)]];
        
        NSArray *operators = @[@"÷",@"x",@"-",@"+"];
        BOOL ischaracterAtLeftOfCursorOperator = NO;
        for(int i=0; i<4; i++){
            if([characterAtLeftOfCursor isEqualToString:[operators objectAtIndex:i]]){
                ischaracterAtLeftOfCursorOperator = YES;
                break;
            }
        }
        if (!ischaracterAtLeftOfCursorOperator){
            [presentInputString insertString:@")" atIndex:currentCursorPosition];
            _inputTextView.text = presentInputString;
            [self setCursorAt:currentCursorPosition + 1];
        }
    }
}

-(void)clearText{
    _inputTextView.text = @"";
}

-(void)addArithmaticOperator:(NSMutableString *)arithmaticOperator{
    
}
@end
