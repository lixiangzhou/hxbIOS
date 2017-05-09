//
//  PYTextModel.m
//  PYCountDown
//
//  Created by 李鹏跃 on 2017/4/19.
//  Copyright © 2017年 李鹏跃. All rights reserved.
//

#import "HXBBaseContDownManager.h"


@interface HXBBaseContDownManager()

///外界传入的开始倒计时时间(从什么时候开始倒计时)
@property (nonatomic,assign) long countDownStartTime;
///外界传入的倒计时基本单位
@property (nonatomic,assign) double countDownUnit;
/////外界传入的modelarray
//@property (nonatomic,strong) NSArray *modelArray;
///外界传入的model中计算倒计时时间的key
@property (nonatomic,copy) NSString *modelDateKey;
///外界传入的model中的用于倒计时显示的key
@property (nonatomic,copy) NSString *modelCountDownKey;
///传入的时间类型，是为原始时间还是剩余时间
@property (nonatomic,assign) PYContDownManagerModelDateType modelDateType;
///队列
@property(nonatomic,strong) dispatch_queue_t queue;
///用于对外刷新UI的接口
@property(nonatomic,copy) void(^countdownDataFredbackWithBlock)();

//注意:此处应该使用强引用 strong
@property (nonatomic,strong) dispatch_source_t timer;
//记录了组数（暂时未用）
@property (nonatomic,assign) int column;
@property (nonatomic,strong) NSMutableArray *countDownArray;
@end



@implementation HXBBaseContDownManager
#pragma mark - setter

#pragma mark - getter

- (dispatch_source_t)timer {
    if (!_timer) {
        [self createTimer];
    }
    return _timer;
}
- (dispatch_queue_t)queue {
    if (!_queue) {
        _queue = dispatch_get_global_queue(0, 0);
    }
    return _queue;
}
- (double)countdownUnit {
    if (!_countDownUnit) {
        return 1;
    }
    return _countDownUnit;
}

- (long)countdownStartTime {
    if (!_countDownStartTime) {
        _countDownStartTime = 60 * 60;
    }
    return _countDownStartTime;
}

- (NSMutableArray *)countDownArray {
    if (!_countDownArray) {
        _countDownArray = [[NSMutableArray alloc]init];
    }
    return _countDownArray;
}


#pragma mark - setter 
- (void)setModelArray:(NSArray *)modelArray {
    _modelArray = modelArray;
    [self createTimer];
}
#pragma mark - 创建对象
+ (instancetype)countDownManagerWithCountDownStartTime: (long)countDownStartTime
                                      andCountDownUnit: (double)countDownUnit
                                         andModelArray: (NSArray *)modelArray
                                       andModelDateKey: (NSString *)modelDateKey
                                  andModelCountDownKey: (NSString *)modelCountDownKey
                                      andModelDateType: (PYContDownManagerModelDateType)modelDateType
{
    return [[self alloc]initWithCountDownStartTime:countDownStartTime
                                  andCountDownUnit:countDownUnit
                                     andModelArray:modelArray
                                   andModelDateKey:modelDateKey
                              andModelCountDownKey:modelCountDownKey
                                  andModelDateType:modelDateType];
}
- (instancetype)initWithCountDownStartTime: (long)countDownStartTime
                          andCountDownUnit: (double)countDownUnit
                             andModelArray: (NSArray *)modelArray
                           andModelDateKey: (NSString *)modelDateKey
                      andModelCountDownKey: (NSString *)modelCountDownKey
                          andModelDateType: (PYContDownManagerModelDateType)modelDateType
{
    self = [super init];
    if (self) {
        self.countDownStartTime = countDownStartTime;
        self.countDownUnit = countDownUnit;
        self.modelArray = modelArray;
        self.modelDateKey = modelDateKey;
        self.modelCountDownKey = modelCountDownKey;
        self.modelDateType = modelDateType;
        if (!self.timer){
            [self createTimer];
        }
    }
    return self;
}


#pragma mark - 倒计时开始
//MARK: 计时器的创建
- (void)createTimer {
        //0.创建队列
        dispatch_queue_t queue = self.queue;
        //1.创建GCD中的定时器
        /*
         第一个参数:创建source的类型 DISPATCH_SOURCE_TYPE_TIMER:定时器
         第二个参数:0
         第三个参数:0
         第四个参数:队列
         */
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
         self.timer = timer;
        //2.设置定时器
        /*
         第一个参数:定时器对象
         第二个参数:DISPATCH_TIME_NOW 表示从现在开始计时
         第三个参数:间隔时间 GCD里面的时间最小单位为 纳秒
         第四个参数:精准度(表示允许的误差,0表示绝对精准)
         */
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, self.countDownUnit * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        
        //3.要调用的任务
        dispatch_source_set_event_handler(timer, ^{
            dispatch_async(self.queue, ^{
                [self lookingForATimelyModelArray:self.modelArray];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.countdownDataFredbackWithBlock) {
                        self.countdownDataFredbackWithBlock();
                    }
                });
            });
        });
        
        //4.开始执行
        dispatch_resume(timer);
}



- (void)lookingForATimelyModelArray: (NSArray *)modelArray {
    
    if (!modelArray.count) {
        [self cancelTimer];
        return;
    }
    [modelArray enumerateObjectsUsingBlock:^(id  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        //如果依然是数组那么就在便利一次
        if ([[model class] isSubclassOfClass:NSClassFromString(@"NSArray")]) {
            self.column ++;
            [self lookingForATimelyModelArray:model];
        }
        
        //判断model中的关于时间类的类型
        NSString *dateValue = [model valueForKey:self.modelDateKey];
        
        long long dateNumber = dateValue.longLongValue;
       
        //如果没有时间值
        if (!dateNumber) return;
        
        //判断是否需要计算时间差
        if (self.modelDateType == PYContDownManagerModelDateType_OriginalTime){
            //时间差计算
           dateNumber = [self computationTimeDifferenceWithDateNumber:dateNumber];
        }
        
        //判断是否需要计时
        if (dateNumber <= self.countdownStartTime && dateNumber >= 0) {
            //添加到数组中
            [self.countDownArray addObject:model];
            dispatch_async(dispatch_get_main_queue(), ^{
                [model setValue:@(dateNumber).description forKey:self.modelCountDownKey];
                
            });
        }else {
            [self.countDownArray removeObject:model];
        }
    }];
    //关掉定时器
    if (!self.countDownArray.count && self.isAutoEnd) [self cancelTimer];
}

//MARK: 时间差的计算
- (long long)computationTimeDifferenceWithDateNumber: (long long)dateNumber {
    NSDate *date = [[NSDate alloc]init];
    if (self.clientTime) {
        date = self.clientTime;
    }
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    return (dateNumber - timeInterval);
}

//MARK: 外部刷新UI的接口
- (void)countdownDataFredbackWithBlock: (void(^)())countdownDataFredbackWithBlock {
    self.countdownDataFredbackWithBlock = countdownDataFredbackWithBlock;
}


//MARK: 取消定时器
- (void)cancelTimer {
    dispatch_cancel(self.timer);
    self.timer = nil;
}
//MARK: 开启定时器
- (void)resumeTimer {
    if (!self.timer) {
        [self createTimer];
    }
}
//MARK: 数组发生变化了
- (void)countDownWithModelArray:(NSArray *)modelArray andModelDateKey:(NSString *)modelDateKey andModelCountDownKey:(NSString *)modelCountDownKey {
    if (modelArray.count) {
        self.modelArray = modelArray;
    }
    if (modelDateKey) {
        self.modelDateKey = modelDateKey;
    }
    if (modelCountDownKey) {
        _modelCountDownKey = modelCountDownKey;
    }
    [self cancelTimer];
    [self resumeTimer];
}

@end
