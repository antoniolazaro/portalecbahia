//
//  FirstViewController.h
//  portalecbahia
//
//  Created by Antonio Lazaro Carvalho Borges on 21/11/12.
//  Copyright (c) 2012 Antonio Lazaro Carvalho Borges. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface FirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSArray *news;
}

@property (strong, nonatomic) IBOutlet UITableView *tableNews;
@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *newsDB;

- (void)fetchNews;

@end
