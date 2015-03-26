//
//  ViewController.m
//  NPPHomework4
//
//  Created by Nick Peters on 3/2/15.
//  Copyright (c) 2015 Nick Peters. All rights reserved.
//

#import "NPPDataModel.h"
#import "ViewController.h"
#import "WebViewController.h"

@implementation ViewController

NSInteger editingCurrentIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"websites"]) {
        NSData *serialized = [[NSUserDefaults standardUserDefaults] objectForKey:@"websites"];
        self.websites = [NSKeyedUnarchiver unarchiveObjectWithData:serialized];
    } else {
        //Only runs the first time the app is launched
        self.websites = [[NSMutableArray alloc] init];
        
        NPPDataModel *website1 = [[NPPDataModel alloc] initWithName:@"Google" andUrl:@"http://google.com"];
        NPPDataModel *website2 = [[NPPDataModel alloc] initWithName:@"Facebook" andUrl:@"http://facebook.com"];
        NPPDataModel *website3 = [[NPPDataModel alloc] initWithName:@"Twitter" andUrl:@"http://twitter.com"];
        NPPDataModel *website4 = [[NPPDataModel alloc] initWithName:@"YouTube" andUrl:@"https://www.youtube.com/watch?v=_OBlgSz8sSM&spfreload=10"];
        NPPDataModel *website5 = [[NPPDataModel alloc] initWithName:@"Apple" andUrl:@"http://apple.com"];
        
        [self.websites addObject:website1];
        [self.websites addObject:website2];
        [self.websites addObject:website3];
        [self.websites addObject:website4];
        [self.websites addObject:website5];
        
        [self saveData];
    }
    
    UIView *header = self.headerView;
    [self.tableView setTableHeaderView:header];
}

-(void)saveData
{
    NSData *serialized = [NSKeyedArchiver archivedDataWithRootObject:self.websites];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:serialized forKey:@"websites"];
    [userDefaults synchronize];
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *url = [[alertView textFieldAtIndex:1] text];
        
        if (![url containsString:@"http://"]) {
            NSMutableString *validURL = [[NSMutableString alloc] init];
            [validURL setString:@"http://"];
            [validURL appendString:url];
            url = validURL;
        }
        
        if ([[alertView title] isEqualToString:@"Edit Bookmark"]) {
            
            NPPDataModel *website = [self.websites objectAtIndex:editingCurrentIndex];
            
            NSString *name = [[alertView textFieldAtIndex:0] text];
            NSString *url = [[alertView textFieldAtIndex:1] text];
            
            [website setName: name];
            [website setUrl: url];
            
            [self saveData];
            [self.tableView reloadData];
            
            editingCurrentIndex = -1;
        } else {
            NPPDataModel *newItem = [[NPPDataModel alloc]initWithName: [[alertView textFieldAtIndex:0] text] andUrl:url];
            
            [self.websites addObject:newItem];
            
            NSInteger lastRow = [self.tableView numberOfRowsInSection:0];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
            
            [self.tableView insertRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationTop];
            [self saveData];
        }
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Edit Bookmark" message:@"Enter the website name and the URL." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alert textFieldAtIndex:1].secureTextEntry = NO;
    
    UITextField *name = [alert textFieldAtIndex:0];
    UITextField *url = [alert textFieldAtIndex:1];
    
    name.placeholder = @"Name";
    url.placeholder = @"URL";
    
    name.text = [[self.websites objectAtIndex: indexPath.row] name];
    url.text = [[self.websites objectAtIndex: indexPath.row] url];
    
    editingCurrentIndex = indexPath.row;
    [alert show];
    
}

 - (IBAction)addNewItem:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"New Bookmark" message:@"Enter the website name and the URL." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alert textFieldAtIndex:1].secureTextEntry = NO;
    [alert textFieldAtIndex:0].placeholder = @"Name";
    [alert textFieldAtIndex:1].placeholder = @"URL";
    [alert show];
}

- (IBAction)toggleEditingMode:(id)sender
{
    // If you are currently in editing mode...
    if (self.tableView.isEditing) {
        // Change text of button to inform user of state
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        
        // Turn off editing mode
        [self.tableView setEditing:NO animated:YES];
    } else {
        // Change text of button to inform user of state
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        
        // Enter editing mode
        [self.tableView setEditing:YES animated:YES];
    }
}
 
 - (UIView *)headerView
{
    if (!_headerView) {
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView"
                                      owner:self
                                    options:nil];
    }
    return _headerView;
 }

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showWebView"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        WebViewController *destViewController = segue.destinationViewController;
        
        NPPDataModel *dataModel = [self.websites objectAtIndex:indexPath.row];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[dataModel url]]];
        
        destViewController.name = dataModel.name;
        destViewController.request = request;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.websites count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"WebsiteCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
                
    cell.textLabel.text = [[self.websites objectAtIndex:indexPath.row] name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.websites removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
        [self saveData];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NPPDataModel *object = [self.websites objectAtIndex:sourceIndexPath.row];
    [self.websites removeObjectAtIndex:sourceIndexPath.row];
    [self.websites insertObject:object atIndex:destinationIndexPath.row];
    [self saveData];
}

@end
