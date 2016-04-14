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
你可以这样:
```
[[WZXNetworkManager manager].setRequest(@"http://192.168.1.40:8001") startRequestWithSuccess:^(id response) {
       
        NSLog(@"success");
    } failure:^{
        
        NSLog(@"failure");
    }];
```
链式在**参数和参数的选择很多的情况**或者**很有可能改动的情况**下展现了惊人的优势。因为，它的改动十分方便，只不过添加或者修改一个方法。
