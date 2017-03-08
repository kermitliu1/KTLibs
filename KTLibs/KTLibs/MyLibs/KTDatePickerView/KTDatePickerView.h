//
//  KTDatePickerView.h
//  KTLibs
//
//  Created by KermitLiu on 2017/3/8.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol KTDatePickerViewDelegate <NSObject>
@required
- (void)datePickerCancelBtnClicked;
- (void)datePickerOKBtnClicked;

@end

//typedef enum {
//    YearMonthDay = 1,                   // 年-月-日
//    YearMonthDayHour_12Minute = 2,      // 年-月-日 1:00
//    YearMonthDayHour_24Minute = 3,      // 年-月-日 13:00
//    MonthDayHour_12Minute = 4,          // 月-日 1:00
//    MonthDayHour_24Minute = 5,
//} ShowTimeType;

typedef NS_ENUM(NSInteger,ShowTimeType){
    YearMonthDay = 0,                   // 年-月-日
    YearMonthDayHour_12Minute = 1,      // 年-月-日 1:00
    YearMonthDayHour_24Minute = 2,      // 年-月-日 13:00
    MonthDayHour_12Minute = 3,          // 月-日 1:00
    MonthDayHour_24Minute = 4,          // 月-日 13:00
    
};

@interface KTDatePickerView : UIView

@property (nonatomic, assign) id<KTDatePickerViewDelegate> delegate;


@property (nonatomic, assign) ShowTimeType showTimeType;

@property (nonatomic, strong) NSDate * minimumDate;
@property (nonatomic, strong) NSDate * maximumDate;

@property (nonatomic, strong) UIColor * topBGColor;
@property (nonatomic, strong) UIColor * topTimeLabelColor;
@property (nonatomic, strong) UIColor * cancelBtnTitleColor;
@property (nonatomic, strong) UIColor * okBtnTitleColor;


/**
 *  @return 选中的时间
 */
- (NSString *)getSelectedDateStr;

@end
