//
//  PostViewController.m
//  Instagram
//
//  Created by Eric Moran on 6/27/22.
//

#import "PostViewController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Post.h"

@interface PostViewController ()
@property (weak, nonatomic) IBOutlet UITextField *caption;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
- (IBAction)choosePhoto:(id)sender;
- (IBAction)post:(id)sender;
@property (nonatomic) BOOL hasChosenimage;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    self.hasChosenimage = false;
    
    UITapGestureRecognizer *imageTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePhoto:)];
    [imageTapRecognizer setDelegate:self];
        [self.postImage addGestureRecognizer:imageTapRecognizer];
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
//    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    self.postImage.image = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.hasChosenimage = true;
    

    // Do something with the images (based on your use case)
//    [Post postUserImage:originalImage withCaption:@"new post" withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
//
//    }];
    
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)post:(id)sender {
    if (self.hasChosenimage)
    {
        [Post postUserImage:self.postImage.image withCaption:self.caption.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (error == nil)
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success!"
                                             message:@"Successfully Created Post"
                                             preferredStyle:UIAlertControllerStyleAlert];

                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                 {}];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
                self.view.window.rootViewController = tabBarController;
            }
            else
            {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Missing Photo"
                                     message:@"Please choose a Photo for your post"
                                     preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
         {}];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)choosePhoto:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
//    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}
@end
