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
@property (nonatomic) NSInteger wind;
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
    [self tempSliderChanged:self.tempSlider];
    [self windSliderChanged:self.windSlider];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)tempSliderChanged:(UISlider*)sender {
    self.temperature = sender.value;
}

-(IBAction)windSliderChanged:(UISlider*)sender {
    self.wind = sender.value;
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
    
    if (indexPath.row ==self.selectedIndex) {
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

- (void) updateWind {
    if ([self galeForceWindsIsSelected]) {
        self.windSlider.enabled = NO;
        self.wind = 50;
    } else {
        self.windSlider.enabled = YES;
    }
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

- (NSInteger) calculateWindChillWithTemperature:(NSInteger)temp andWindSpeed:(NSInteger)wind {
    NSInteger windChill;
    
    if (wind < 3) {
        windChill = temp;
    } else {
        // formula according to the The National Weather Service based on skin temperatures and heat transfer rates
        windChill = 35.74 + 0.6215 * temp - 35.75 * pow(wind, 0.16) + 0.4275 * self.temperature * pow(wind, 0.16);
    }
    
    return (NSInteger)windChill;
}

- (void) setWind:(NSInteger)wind {
    _wind = wind;
    [self updateWindLabel];
    [self updateWindChillLabel];
    [self updateSacrifices];
}

- (void) updateWindLabel {
    self.windLabel.text = [NSString stringWithFormat:@"%li mph", (long)self.wind];
}

- (void) updateWindChillLabel {
    NSInteger windChill = [self calculateWindChillWithTemperature:self.temperature andWindSpeed:self.wind];
    self.windChillLabel.text = [NSString stringWithFormat:@"%li°", (long)windChill];
}

- (void) setTemperature:(NSInteger)temperature {
    _temperature = temperature;
    [self updateTemperatureLabel];
    [self updateWindChillLabel];
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
    [self updateWind];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
