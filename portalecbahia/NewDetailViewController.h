//
//  NewDetailViewController.h
//  portalecbahia
//
//  Created by Antonio Lazaro Carvalho Borges on 19/04/13.
//  Copyright (c) 2013 Antonio Lazaro Carvalho Borges. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet NSDictionary *detailItem;
@property (strong, nonatomic) IBOutlet UIImageView *imageNewDetail;
@property (strong, nonatomic) IBOutlet UITableView *tableViewDetail;

@end
