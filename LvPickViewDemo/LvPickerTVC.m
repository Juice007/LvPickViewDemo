//
//  LvPickerTVC.m
//  LvPickViewDemo
//
//  Created by lvxin on 16/9/7.
//  Copyright © 2016年 JuiceLv. All rights reserved.
//

#import "LvPickerTVC.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface LvPickerTVC () <UIPickerViewDelegate, UIPickerViewDataSource> {
    UIDatePicker *datePicker;
    
    UIPickerView *fruitPicker;
}

@property (weak, nonatomic) IBOutlet UITextField *timeTextField;

@property (weak, nonatomic) IBOutlet UITextField *fruitTextField;

@property (strong, nonatomic) NSArray *fruitArray;

@end

@implementation LvPickerTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTimePickerView];
    
    [self setupFruitPickerView];
    
}

#pragma mark - fruitArray的懒加载方法
- (NSArray *)fruitArray {
    if (!_fruitArray) {
        _fruitArray = @[@"Apple", @"Pear", @"Grape"];
    }
    return _fruitArray;
}

- (void)setupTimePickerView {
    
    //设置UIToolBar
    UIToolbar *timePickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 33)];
    [timePickerToolBar setBackgroundColor:[UIColor whiteColor]];
    UIBarButtonItem *cancelTollBarItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickCancel)];
    UIBarButtonItem *spaceToolBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneToolBarItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(didSelectTime)];
    [timePickerToolBar setItems:[NSArray arrayWithObjects:cancelTollBarItem, spaceToolBarItem, doneToolBarItem, nil]];
    
    //设置UIDatePicker
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.minimumDate = [NSDate date];
    _timeTextField.inputView = datePicker;
    _timeTextField.tintColor = [UIColor clearColor]; //隐藏光标
    [_timeTextField setInputAccessoryView:timePickerToolBar]; //加入toolBar
    
    //边滑动UIDatePicker边将值显示在textField上
    [datePicker addTarget:self action:@selector(selectingDate) forControlEvents:UIControlEventValueChanged];
}

- (void)selectingDate {
    //将NSDate转换成字符串
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    _timeTextField.text = [dateFormatter stringFromDate:datePicker.date];
}

- (void)didSelectTime {
    [_timeTextField resignFirstResponder];
}

- (void)clickCancel {
    [_timeTextField resignFirstResponder];
    [_fruitTextField resignFirstResponder];
}

- (void)setupFruitPickerView {
    //设置UIToolBar
    UIToolbar *fruitPickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 33)];
    [fruitPickerToolBar setBackgroundColor:[UIColor whiteColor]];
    UIBarButtonItem *cancelTollBarItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickCancel)];
    UIBarButtonItem *spaceToolBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneToolBarItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(didSelectFruit)];
    [fruitPickerToolBar setItems:[NSArray arrayWithObjects:cancelTollBarItem, spaceToolBarItem, doneToolBarItem, nil]];
    
    //设置UIPickerView
    fruitPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, (2 / 3) * SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT / 3)];
    fruitPicker.delegate = self;
    fruitPicker.dataSource = self;
    fruitPicker.backgroundColor = [UIColor whiteColor];
    _fruitTextField.inputView = fruitPicker;
    _fruitTextField.tintColor = [UIColor clearColor]; //隐藏光标
    [_fruitTextField setInputAccessoryView:fruitPickerToolBar]; //加入toolBar
}

- (void)didSelectFruit {
    [_fruitTextField resignFirstResponder];
}

#pragma mark - <UIPickerViewDataSource>
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.fruitArray.count;
}

#pragma mark - <UIPickerViewDelegate>
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.fruitArray[row];
}

//滑动的时候显示在textField上
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *fruitStr = [self pickerView:pickerView titleForRow:row forComponent:component];
    _fruitTextField.text = fruitStr;
}

#pragma mark - 开始拖拽(实现点击空白收起键盘)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

@end
