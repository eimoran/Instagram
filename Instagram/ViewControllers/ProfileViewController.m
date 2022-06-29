//
//  ProfileViewController.m
//  Instagram
//
//  Created by Eric Moran on 6/29/22.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "UIImageView+AFNetworking.h"
#import "Post.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)chooseProfilePic:(id)sender;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *imageTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseProfilePic:)];
    [imageTapRecognizer setDelegate:self];
    [self.profilePic addGestureRecognizer:imageTapRecognizer];
    
    PFUser *user = [PFUser currentUser];
    PFFileObject *pic = user[@"profilePic"];
    
    NSURL *url = [NSURL URLWithString:pic.url];
    
    if (pic)
    {
        [self.profilePic setImageWithURL:url];
    }
    else{
        self.profilePic.image = [UIImage imageNamed:@"profile_tab"];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)chooseProfilePic:(id)sender {
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

- (IBAction)post:(id)sender {
    
    
    
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
//    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    self.profilePic.image = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
//    self.hasChosenimage = true;
    

    // Do something with the images (based on your use case)
//    [Post postUserImage:originalImage withCaption:@"new post" withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
//
//    }];
    
    PFUser *user = [PFUser currentUser];
    
    user[@"profilePic"] = [Post getPFFileFromImage:self.profilePic.image];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    CGSize size = CGSizeMake(1300, 1000);
    self.profilePic.image = [self resizeImage:self.profilePic.image withSize:size];
    [[PFUser currentUser] saveInBackground];
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
