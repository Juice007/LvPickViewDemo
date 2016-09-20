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
    
    UIPickerView *pickerView;
}

@property (weak, nonatomic) IBOutlet UITextField *timeTextField;

@property (weak, nonatomic) IBOutlet UITextField *fruitTextField;

@property (strong, nonatomic) NSArray *fruitArray;

@end

@implementation LvPickerTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDatePicker];
    
    [self initPickerView];
    
}

#pragma mark - fruitArray的懒加载方法
- (NSArray *)fruitArray {
    if (!_fruitArray) {
        _fruitArray = @[@"Apple", @"Pear", @"Grape"];
    }
    return _fruitArray;
}

- (void)initDatePicker {
    
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

- (void)initPickerView {
    //设置UIToolBar
    UIToolbar *pickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 33)];
    [pickerToolBar setBackgroundColor:[UIColor whiteColor]];
    UIBarButtonItem *cancelTollBarItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickCancel)];
    UIBarButtonItem *spaceToolBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneToolBarItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(didSelectItem)];
    [pickerToolBar setItems:[NSArray arrayWithObjects:cancelTollBarItem, spaceToolBarItem, doneToolBarItem, nil]];
    
    //设置UIPickerView`
//    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, (2 / 3) * SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT / 3)];
    pickerView = [[UIPickerView alloc] init];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.backgroundColor = [UIColor whiteColor];
    _fruitTextField.inputView = pickerView;
    _fruitTextField.tintColor = [UIColor clearColor]; //隐藏光标
    [_fruitTextField setInputAccessoryView:pickerToolBar]; //加入toolBar
}

- (void)didSelectItem {
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
//    NSString *fruitStr = [self pickerView:pickerView titleForRow:row forComponent:component];
//    _fruitTextField.text = fruitStr;
    _fruitTextField.text = _fruitArray[row];
}

#pragma mark - 开始拖拽(实现点击空白收起键盘)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

@end
