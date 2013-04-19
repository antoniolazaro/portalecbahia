//
//  NewDetailViewController.h
//  portalecbahia
//
//  Created by Antonio Lazaro Carvalho Borges on 19/04/13.
//  Copyright (c) 2013 Antonio Lazaro Carvalho Borges. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageViewDetail;
@property (strong, nonatomic) IBOutlet UILabel *labelDataDetail;
@property (strong, nonatomic) IBOutlet UILabel *labelTituloDetail;
@property (strong, nonatomic) IBOutlet UITextView *contentNewDetail;

@property (strong, nonatomic) IBOutlet NSDictionary *detailItem;

@end
