//
//  ImagePicker.m
//  FaceCap
//
//  Created by Nelson Chicas on 4/5/13.
//  Copyright (c) 2013 Applits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePicker : UIViewController <UINavigationControllerDelegate,
                                           UIImagePickerControllerDelegate>

@property (nonatomic, retain) UIImagePickerController *imagePickerController;
@property (nonatomic, readonly) id completionHandler;
@property (nonatomic, readonly) id dismissHandler;

- (id)initAsCamera;
- (id)initAsPhotoLibrary;

- (void)showPicker:(UIViewController*)parent
      onCompletion:(void (^)(UIImage *))completionHandler
         onDismiss:(void (^)(void))errorHandler;
- (void)hidePicker;

@end
