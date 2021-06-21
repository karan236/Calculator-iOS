//
//  DataTransferProtocol.h
//  Calculator
//
//  Created by Karan Ghorai on 17/06/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DataTransferDelegate <NSObject>
-(void)addInput:(NSMutableString *) input;
-(void)addArithmaticOperator:(NSMutableString *) arithmaticOperator;
-(void)addOpenningBracket;
-(void)addClosingBracket;
-(void)clearText;
-(void)setLabelToNil;
-(void)setDataFromTableWithExpression: (NSString *) expression result:(NSString *) result;
@end

NS_ASSUME_NONNULL_END
