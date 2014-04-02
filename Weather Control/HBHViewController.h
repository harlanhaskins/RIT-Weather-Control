//
//  HBHViewController.h
//  Weather Control
//
//  Created by Harlan Haskins on 4/1/14.
//  Copyright (c) 2014 haskins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBHViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UISlider *tempSlider;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *sacrificeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sacrificesIdentifierLabel;

@end
