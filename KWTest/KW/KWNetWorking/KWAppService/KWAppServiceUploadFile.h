//
//  KWAppServiceUploadFile.h
//  Pods
//
//  Created by aaaa on 16/8/28.
//
//

#import <Foundation/Foundation.h>

/**
 *  用于多文件传输使用
 */
@interface KWAppServiceUploadFile : NSObject

/**
 *  文件地址
 */
@property (nonatomic, copy) NSString *fileURL;

/**
 *  外面参数名  imageFileParameterName
 */
@property (nonatomic, copy) NSString *name;

/**
 *  传到服务器的文件名  fileName
 */
@property (nonatomic, copy) NSString *filename;

/**
 *  文件类型  fileType
 */
@property (nonatomic, copy) NSString *mimeType;

@end
