//
//  HBHViewController.m
//  Weather Control
//
//  Created by Harlan Haskins on 4/1/14.
//  Copyright (c) 2014 haskins. All rights reserved.
//

#import "HBHViewController.h"

@interface HBHViewController ()

@property (nonatomic) NSArray* items;
@property (nonatomic) NSInteger selectedIndex;

@property (nonatomic) NSInteger temperature;
@property (nonatomic) NSInteger sacrifices;

@end

@implementation HBHViewController

- (id) init {
    if (self = [super init]) {
        self.title = @"Destler's Weather Control";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.items = @[@"Overcast", @"Rain", @"Snow", @"Sleet", @"Gale Force Winds", @"Second Winter", @"Hoth", @"Heat Wave", @"Apocalypse", @"Sun", @"San Diego"];
    self.selectedIndex = 0;
    [self sliderChanged:self.tempSlider];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)sliderChanged:(UISlider*)sender {
    self.temperature = sender.value;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = self.items[indexPath.row];
    
    if (indexPath.row ==self.selectedIndex ||
        [self isGaleForceWindsIndex:indexPath.row]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void) updateSacrifices {
    self.sacrifices = [self sacrificeCountForCurrentSelections];
}

- (NSInteger) sacrificeCountForCurrentSelections {
    BOOL shouldBeZero = (self.temperature < 0) || [self galeForceWindsIsSelected];
    if (shouldBeZero) {
        return 0;
    }
    
    NSInteger total = ((self.selectedIndex * 3) + (self.temperature / 10));
    total *=  (self.temperature / self.tempSlider.maximumValue);
    
    return total;
}

- (BOOL) isGaleForceWindsIndex:(NSInteger)index {
    return index == [self.items indexOfObject:@"Gale Force Winds"];
}

- (BOOL) galeForceWindsIsSelected {
    return [self isGaleForceWindsIndex:self.selectedIndex];
}

- (void) setSacrifices:(NSInteger)sacrifices {
    _sacrifices = sacrifices;
    [self updateSacrificeLabel];
}

- (void) setTemperature:(NSInteger)temperature {
    _temperature = temperature;
    [self updateTemperatureLabel];
    [self updateSacrifices];
}

- (void) updateTemperatureLabel {
    self.tempLabel.text = [NSString stringWithFormat:@"%li°", (long)self.temperature];
}

- (void) updateSacrificeLabel {
    self.sacrificeLabel.text = [NSString stringWithFormat:@"%li", (long)self.sacrifices];
    
    NSString *sacrificesText = self.sacrifices == 1 ? @"sacrifice" : @"sacrifices";
    self.sacrificesIdentifierLabel.text = [sacrificesText stringByAppendingString:@" required"];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedIndex = indexPath.row;
    [self updateSacrifices];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
