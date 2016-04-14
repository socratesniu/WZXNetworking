//
//  NetworkManager.m
//  NetworkManager
//
//  Created by wordoor－z on 16/4/14.
//  Copyright © 2016年 wzx. All rights reserved.
//

#import "NetworkManager.h"
@interface NetworkManager()
@property (nonatomic,copy)NSString * url;
@property (nonatomic,assign)RequestType wRequestType;
@property (nonatomic,assign)RequestSerializer requestSerialize;
@property (nonatomic,assign)ResponseSerializer responseSerialize;
@property (nonatomic,copy)id parameters;
@property (nonatomic,copy)NSDictionary * wHTTPHeader;
@property (nonatomic,assign)ApiVersion version;
@end
@implementation NetworkManager

+ (NetworkManager *)manager {
    static NetworkManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NetworkManager alloc]init];
        [manager replace];
    });
    return manager;
}

- (NetworkManager *(^)(NSString *))setRequest {
    return ^NetworkManager* (NSString * url) {
        self.url = url;
        return self;
    };
}

- (NetworkManager *(^)(RequestType))RequestType {
    return ^NetworkManager* (RequestType type) {
        self.wRequestType = type;
        return self;
    };
}

- (NetworkManager* (^)(id parameters))Parameters {
    return ^NetworkManager* (id parameters) {
        self.parameters = parameters;
        return self;
    };
}
- (NetworkManager *(^)(NSDictionary *))HTTPHeader {
    return ^NetworkManager* (NSDictionary * HTTPHeaderDic) {
        self.wHTTPHeader = HTTPHeaderDic;
        return self;
    };
}

- (NetworkManager *(^)(RequestSerializer))RequestSerialize {
    return ^NetworkManager* (RequestSerializer requestSerializer) {
        self.requestSerialize = requestSerializer;
        return self;
    };
}

- (NetworkManager *(^)(ApiVersion))Version {
    return ^NetworkManager * (ApiVersion version) {
        self.version = version;
        return self;
    };
}

- (NetworkManager *(^)(ResponseSerializer))ResponseSerialize {
    return ^NetworkManager* (ResponseSerializer responseSerializer) {
        self.responseSerialize = responseSerializer;
        return self;
    };
}

- (void)startRequestWithSuccess:(void (^)(id))success failure:(void (^)())failure {
    NetworkManager * manager = [[self class]manager];
    //设置请求头
    [self setupRequestSerializerWithManager:manager];
    [self setupHTTPHeaderWithManager:manager];
    //设置返回头
    [self setupResponseSerializerWithManager:manager];
   
    NSString * url = [self setupUrl];
    
    switch (self.wRequestType) {
        case GET: {
        [manager GET:url parameters:self.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            failure(error);
        }];
        }
            break;
            
        case POST: {
            [manager POST:url parameters:self.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                failure(error);
            }];
        }
            break;
            
        case PUT: {
            [manager PUT:url parameters:self.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                failure(error);
            }];
        }
            break;
            
        case PATCH: {
            [manager PATCH:url parameters:self.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                failure(error);
            }];
        }
            break;
            
        case DELETE: {
            [manager DELETE:url parameters:self.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                failure(error);
            }];
        }
            break;
            
        default:
            break;
    }
    [self replace];
}

- (NetworkManager *)setupRequestSerializerWithManager:(NetworkManager *)manager {
    
    switch (self.requestSerialize) {
        case RequestSerializerJSON: {
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
        }
            break;
        case RequestSerializerHTTP: {
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        }
            break;
        default:
            break;
    }
    return manager;
}

- (NetworkManager *)setupResponseSerializerWithManager:(NetworkManager *)manager {
    switch (self.responseSerialize) {
        case ResponseSerializerJSON: {
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
        }
            break;
        case ResponseSerializerHTTP: {
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        }
            break;
        default:
            break;
    }
    return manager;
}

- (NetworkManager *)setupHTTPHeaderWithManager:(NetworkManager *)manager {
    for (NSString * key in self.wHTTPHeader.allKeys) {
        [manager.requestSerializer setValue:self.wHTTPHeader[key] forHTTPHeaderField:key];
    }
    return manager;
}

- (NSString *)setupUrl {
    NSString * version = @"";
    switch (self.version) {
        case V1: {
            version = @"v1";
        }
            break;
        case V2: {
            version = @"v2";
        }
            break;
        case NONE: {
            return self.url;
        }
            break;
        default:
            break;
    }
    return [NSString stringWithFormat:@"%@,%@",self.url,version];
}

- (void)replace {
    self.url = nil;
    self.version = NONE;
    self.wRequestType = GET;
    self.parameters = nil;
    self.wHTTPHeader = nil;
    self.requestSerialize = RequestSerializerHTTP;
    self.responseSerialize = ResponseSerializerJSON;
}
@end
