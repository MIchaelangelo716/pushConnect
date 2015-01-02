//
//  ViewController.m
//  parsePushConnect
//
//  Created by Michael Kane on 12/31/14.
//  Copyright (c) 2014 ArilogicApps. All rights reserved.
//

#import "MainViewController.h"
#import "Account.h"
#import "editViewController.h"
#import <Parse/Parse.h>

@interface MainViewController () <UIPickerViewDelegate, UIPickerViewDataSource, NSFetchedResultsControllerDelegate, UITextViewDelegate, NSKeyedArchiverDelegate>
@property (strong, nonatomic) IBOutlet UIPickerView *accountPicker;
@property (strong, nonatomic) IBOutlet UITextView *messageBodyTextView;
@property (strong, nonatomic) IBOutlet UITextField *musictextField;
@property (strong, nonatomic) IBOutlet UISwitch *iosSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *androidSwitch;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UISwitch *windowsSwitch;
@end

@implementation MainViewController

{
    NSInteger rowToDelete;
}
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Error! %@", error);
        abort();
    }
    
    if ([[self.fetchedResultsController fetchedObjects]count] == 0) {
        self.accountPicker.hidden = YES;
    }
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    self.navigationController.navigationBar.translucent = YES;
    _messageBodyTextView.layer.borderWidth = 2;
    _messageBodyTextView.layer.borderColor = [UIColor redColor].CGColor;
    self.editButton.hidden = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - Picker delegate Mehtods start
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//Gathers the fetched object counts and assigns to numberOfRows
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
   
    return [[self.fetchedResultsController fetchedObjects]count];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_messageBodyTextView resignFirstResponder];
    [_musictextField resignFirstResponder];
    return YES; 
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //Add key value coding to update the app delegate ID's for parse
    Account *account = [[self.fetchedResultsController fetchedObjects] objectAtIndex:row];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:account.parseID forKey:@"parseID"];
    [defaults setObject:account.parseClientKey forKey:@"parseClientKey"];
    NSLog(@"Account Name: %@: ID: %@ Key:%@",account.accountName, account.parseID, account.parseClientKey);
    
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    rowToDelete = row;
    UILabel* tView = (UILabel *)view;
    if (!tView) {
        tView = [[UILabel alloc]init];
        [tView setTextAlignment:NSTextAlignmentCenter];
        [tView setFont:[UIFont fontWithName:@"Marker Felt" size:30]];
        [tView setTextColor:[UIColor whiteColor]];
    }
    Account *account = [[self.fetchedResultsController fetchedObjects] objectAtIndex:row];
    tView.text = account.accountName;
    return tView;
}
#pragma mark - Picker delegate Mehtods End
#pragma mark - FetchedResultsControllerSection
//Creates it when needed for anyone who asks
-(NSFetchedResultsController*)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    //Create if not already done
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"accountName"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
   _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:self.managedObjectContext
                                                                      sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

//If our saved object is changed, reload the pickerView
-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.accountPicker reloadAllComponents];
}

//Whatever object is at the index we want to delete
-(void)deleteAccount:(NSInteger)row
{
    NSManagedObjectContext *context = [self managedObjectContext];
    Account *accountToDelete = [[self.fetchedResultsController fetchedObjects] objectAtIndex:row];
    [context deleteObject:accountToDelete];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Error! %@", error);
    }
}

#pragma mark - Account Delegate Mehtods Start
-(void)addAccountDidCancel:(Account *)accountToDelete
{
    //Deletes the cancelled accounts
    NSManagedObjectContext *context = self.managedObjectContext;
    [context deleteObject:accountToDelete];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addAccountDidSave
{
    NSError *error;
    NSManagedObjectContext *context = self.managedObjectContext;
    if (![context save:&error]) {
        NSLog(@"ERROR! %@", error);
    }
    self.accountPicker.hidden = NO;
    self.editButton.hidden = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Account Delegate Mehtods End

#pragma mark - IBActions Start
- (IBAction)delete:(id)sender
{
    [self deleteAccount:rowToDelete];
    [self.accountPicker reloadAllComponents];
    if ([[self.fetchedResultsController fetchedObjects]count] == 0) {
        self.accountPicker.hidden = YES;
        self.editButton.hidden = YES; 
    }
}

- (IBAction)pushTheNotifications:(id)sender
{
    NSMutableArray *arrayToAddToPush = [[NSMutableArray alloc]init];
    
    if (_iosSwitch.on == YES) {
        [arrayToAddToPush addObject:@"ios"];
    }
    
    if (_androidSwitch.on == YES) {
        [arrayToAddToPush addObject:@"android"];
    }
    
    if (_windowsSwitch.on == YES) {
        [arrayToAddToPush addObject:@"winphone"];
    }
    
    NSArray *arrayToPush = [NSArray arrayWithArray:arrayToAddToPush];
    PFQuery *queryUser = [PFInstallation query];
    [queryUser whereKey:@"deviceType" containedIn:arrayToPush];
    
    NSString *message = _messageBodyTextView.text;
    NSString *increment = @"increment";
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          message, @"alert",
                          increment, @"badge",
                          _musictextField.text, @"sound",
                          nil];
    
    // Send the notification.
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:queryUser];
    [push setData:data];
    [push sendPushInBackground];
    _messageBodyTextView.text = @""; 
}
#pragma mark - IBActions End

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"addNewAccount"]) {
        AccountViewController *addnew = (AccountViewController *)[segue destinationViewController];
        addnew.delegate = self;
        
        Account *newAccount = (Account *)[NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:[self managedObjectContext]];
        
        addnew.currentAccount = newAccount;
    }
    
    if ([[segue identifier] isEqualToString:@"edit"]) {
        editViewController *evd = (editViewController *)[segue destinationViewController];
        Account *selectedAccount = (Account *)[[self.fetchedResultsController fetchedObjects] objectAtIndex:rowToDelete];
        evd.currentAccount = selectedAccount;
    }
}
@end
