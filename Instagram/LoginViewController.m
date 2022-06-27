//
//  LoginViewController.m
//  Instagram
//
//  Created by Eric Moran on 6/27/22.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "HomeViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
- (IBAction)Login:(id)sender;
- (IBAction)signUp:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.emailField.hidden = true;
    // Do any additional setup after loading the view.
}

- (void)registerUser {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameField.text;
    newUser.email = self.emailField.text;
    newUser.password = self.passwordField.text;
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            [self performSegueWithIdentifier:@"home" sender:self];
            
            // manually segue to logged in view
        }
    }];
}

- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            [self performSegueWithIdentifier:@"home" sender:self];
            // display view controller that needs to shown after successful login
        }
    }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"home"]){
//        [self performSegueWithIdentifier:@"home" sender:self];
//        HomeViewController *detailsVC = [segue destinationViewController];
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
//        detailsVC.tweet = self.arrayOfTweets[indexPath.row];
        }
//    else {
//        UINavigationController *navigationController = [segue destinationViewController];
//        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
//        composeController.delegate = self;
//    }
}


- (IBAction)signUp:(id)sender {
    self.emailField.hidden = false;
    if ([self.usernameField isEqual:@""] || [self.emailField isEqual:@""] || [self.passwordField isEqual:@""])
    {
        
    }
    else{
        [self registerUser];
        
    }
}

- (IBAction)Login:(id)sender {
    if ([self.usernameField isEqual:@""])
    {
        
    }
    else{
        [self loginUser];
    }
}
@end
