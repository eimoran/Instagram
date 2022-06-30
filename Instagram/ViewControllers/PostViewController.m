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
    
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)post:(id)sender {
    if (self.hasChosenimage)
    {
        CGSize size = CGSizeMake(1300, 1000);
        self.postImage.image = [self resizeImage:self.postImage.image withSize:size];
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

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
