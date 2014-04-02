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
    self.items = @[@"Overcast", @"Rain", @"Snow", @"Sleet", @"Gale Force Winds", @"Apocalypse", @"Hoth", @"Heat Wave", @"Sun", @"Second Winter", @"San Diego"];
    self.selectedIndex = 0;
    [self setSacrifices];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)sliderChanged:(UISlider*)sender {
    NSInteger temp = (150 * sender.value) - 75;
    self.tempLabel.text = [NSString stringWithFormat:@"%li°", (long)temp];
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
        indexPath.row == [self.items indexOfObject:@"Gale Force Winds"]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void) setSacrifices {
    NSInteger hash = [self.items[self.selectedIndex] hash];
    NSInteger sacrifices = hash % (self.items.count * 2);
    self.sacrificeLabel.text = [NSString stringWithFormat:@"%li", (long)sacrifices];
    
    NSString *sacrificesText = sacrifices == 1 ? @"sacrifice" : @"sacrifices";
    self.sacrificesIdentifierLabel.text = [sacrificesText stringByAppendingString:@" required"];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self setSacrifices];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
