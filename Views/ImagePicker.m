//
//  ImagePicker.m
//  FaceCap
//
//  Created by Nelson Chicas on 4/5/13.
//  Copyright (c) 2013 Applits. All rights reserved.
//

#import "ImagePicker.h"

@interface ImagePicker ()

@property (nonatomic, strong) UIViewController *parent;
@property (nonatomic, assign) BOOL isShown;
@property (nonatomic, readwrite) id completionHandler;
@property (nonatomic, readwrite) id dismissHandler;

@end

@implementation ImagePicker

#pragma mark - Constructors

- (id)init;
{
	self = [super init];
	if (self) {
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
	return self;
}

- (id)initAsCamera;
{
	self = [super init];
	if (self) {
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
	return self;
}

- (id)initAsPhotoLibrary;
{
	self = [super init];
	if (self) {
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
	return self;
}

- (void)showPicker:(UIViewController*)parent
      onCompletion:(void (^)(UIImage *))completionHandler
         onDismiss:(void (^)(void))dismissHandler;
{
	if (self.isShown) {
		return;
	}
    
    self.parent = parent;
    self.completionHandler = completionHandler;
    self.dismissHandler = dismissHandler;
    
	[parent presentModalViewController:self.imagePickerController animated:YES];
	self.isShown = YES;
}

- (void)hidePicker;
{
	if (!self.isShown) {
		return;
	}
    
	[self.parent dismissModalViewControllerAnimated:YES];
	self.isShown = NO;
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

// this get called when an image has been chosen from the library or taken from the camera
//
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if( self.completionHandler ) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        ((void (^)(UIImage *))self.completionHandler)( image );
    }
    
    [self.parent dismissModalViewControllerAnimated:YES];
    self.isShown = NO;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if( self.dismissHandler) {
        ((void (^)(void))self.dismissHandler)();
    }
    
    [self.parent dismissModalViewControllerAnimated:YES];
    self.isShown = NO;
}

@end
