# AsyncDataFetch

There is the `HTTPHandler` file that does all the download tasks. To fetch images, you can use the category created on `UIImageView` that works like `sd_webImage`. 

You can set the cache size using:

```
[[HTTPHandler sharedInstance] setCacheWithSize:4 * 1024 * 1024];
```
### You can fetch requests on your own using:

The class is a singleton class that offers two methods for you to use to fetch requests:

```
-(void)getDataFromUrlString:(NSString *)urlString andUniqueIdentifier:(NSString *)uniqueIdentifier withCompletionHandler:(void(^)(NSData *result, NSError *error))completionHandler;

-(void)getParsedDataFromUrlString:(NSString *)urlString andUniqueIdentifier:(NSString *)uniqueIdentifier withCompletionHandler:(void(^)(id result, NSError *error))completionHandler;
```

If you want the `NSData` format in the response, then use the first method and the second method will parse the data into the appropriate format based on Content-Type in the header of the response. 

If you want to create a cancellable request, you need to pass in a unique identifier to make that request unique in case there are multiple requests from the same URL going in. If there is only one request with a particular URL you can get away by just passing the URL to cancel it and nil in the identifier. The method to cancel:

```
-(void)cancelRequestWithUrlString:(NSString *)urlString andUniqueIdentifier:(NSString *)identifier
```

## Another way of using (for images):
To download images, you can just use the category created on `UIImageView`:

```
[imageView downloadImageFromUrlString:self.backgroundImageString andOnCompletion:^(UIImage *image, NSError *error) {
        
        if(!error){
            
            [imageView setImage:image];
        }
}];
```

Now advantage of using said category is to cancel the request all you have to do is:

```
[imageView cancelRequestForUrlString:self.backgroundImageString];
```
You don't have to set a unique identifier as the we automatically set it on our own using the time stamp inside of the category. And since the request is now assosciated with the `UIImageView`, the timestamp is stored across the lifetime of the object.
