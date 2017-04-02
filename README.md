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

To add more data types, you need to add the appropriate enum inside the header file and the string for that contentType inside the private method:
```
-(ContentType)getContentTypeOfString:(NSString *)string
```
and also in the `getParsedData` method you need to check the value of the `ContentType` enum and handle the data format.

### Cancel Request:

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
You don't have to set a unique identifier as the we automatically set it on our own using the time stamp inside of the category. And since the request is now assosciated with the `UIImageView`, the timestamp is stored.

**Note:** For caching a "timeOfUse" property has been added to the objects but not used currently. It was added in case we need to store in the disk memory later on. Custom cache(`NSMutableDictionary`) was created as the apple cache doesn't necessarily follow LRU algorithm.  

After the "Home Screen" just click on a cell to open the detailed view where you will see a "+" button. Click on it to show more options. One of the buttons downloads **all** the images and other two cancel the downloading of images the smaller two `UIImageView`

Visual manual:

![alt tag](https://media.giphy.com/media/3o7bu7llrIVkwKEnao/giphy.gif)
