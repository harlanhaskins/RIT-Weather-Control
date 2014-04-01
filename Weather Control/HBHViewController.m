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
    self.items = @[@"Overcast", @"Rain", @"Snow", @"Sleet", @"Apocalypse", @"Heat Wave", @"Sun", @"Spring Snow", @"San Diego"];
    self.selectedIndex = 0;
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
    cell.accessoryType = (self.selectedIndex == indexPath.row) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
