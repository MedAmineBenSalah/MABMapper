//
//  ArrayViewController.m
//  MapperDemo
//
//  Created by MedAmine BenSalah on 17/11/2018.
//  Copyright © 2018 mab. All rights reserved.
//

#import "ArrayViewController.h"
#import "Resto.h"
#import "MABMapperFetcher.h"

@interface ArrayViewController ()

@end

@implementation ArrayViewController{
    NSArray<Resto*> *restArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

- (void)loadData{
    NSString *jsonPath = [NSBundle.mainBundle pathForResource:@"resto" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSArray *rawObjects = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    restArray = [MABMapperFetcher<Resto*> fetchArray:rawObjects andClass:[Resto class]];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return restArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
    Resto *resto = restArray[indexPath.row];
    cell.textLabel.text = resto.name;
    cell.detailTextLabel.text = resto.address;
    
    return cell;
}


@end
