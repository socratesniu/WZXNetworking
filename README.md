# WZXNetworking
基于AFNetwoking，使用链式编程思想的网络请求框架

# 为什么封装WZXNetworking
这是一个容错性非常吓人的框架。
它是采用链式编程思想封装。
```
 [[WZXNetworkManager manager].setRequest(@"http://192.168.1.40:8001").RequestType(POST).HTTPHeader(nil).Parameters(nil).RequestSerialize(RequestSerializerHTTP).ResponseSerialize(ResponseSerializerJSON) startRequestWithSuccess:^(id response) {
        
        NSLog(@"success");
    } failure:^{
        
        NSLog(@"failure");
    }];
```
在这里除了`.setRequest(url)`和`startRequestWithSuccess failure`方法，其他都是不必要的。
