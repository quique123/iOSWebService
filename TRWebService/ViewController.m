//
//  ViewController.m
//  TRWebService
//
//  Created by Marcio Valenzuela on 4/10/13.
//  Copyright (c) 2013 Marcio Valenzuela. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    NSDictionary *flickrDictionary;
    NSMutableArray *cFRAIPArray;
}

@end

@implementation ViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    NSURL *myURL = [NSURL URLWithString:@"http://api.worldweatheronline.com/free/v1/weather.ashx?q=London&format=json&num_of_days=5&key=xfanay7rjhsfe6ays8w3xfza"];
    //"http://www.flickr.com/services/rest/?method=flickr.test.echo&format=json&api_key=3c6eeeae4711a5f478d3da796750e06b&nojsoncallback=1"];
    
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
    NSURLConnection *myConnection = [NSURLConnection connectionWithRequest:myRequest delegate:self];
    if (myConnection) {
        [myConnection start];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*) response;
    int errorCode = httpResponse.statusCode;
    NSString *fileMIMEType = [[httpResponse MIMEType] lowercaseString];
    
    NSLog(@"response is %d, %@", errorCode, fileMIMEType);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"data is %@", data);
    NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"string is %@", myString);
    NSError *e = nil;

    flickrDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
    NSLog(@"dictionary is %@", flickrDictionary);
    
    //test
    //NSLog(@"value is %@", [[[[[[flickrDictionary valueForKey:@"data"] objectForKey:@"current_condition"] objectAtIndex:0] objectForKey:@"weatherDesc"] objectAtIndex:0] objectForKey:@"value"]);
    
    //Init array
    cFRAIPArray = [[NSMutableArray alloc] initWithCapacity:6];
    
    //DAY1
    NSString *today = [[[[[[flickrDictionary valueForKey:@"data"] objectForKey:@"current_condition"] objectAtIndex:0] objectForKey:@"weatherDesc"] objectAtIndex:0] objectForKey:@"value"];
    [cFRAIPArray addObject:today];
    //DAY2
    NSString *tomorrow = [[[[[[flickrDictionary valueForKey:@"data"] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"weatherDesc"] objectAtIndex:0] objectForKey:@"value"];
    [cFRAIPArray addObject:tomorrow];
    //DAY3
    NSString *afterTomorrow = [[[[[[flickrDictionary valueForKey:@"data"] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"weatherDesc"] objectAtIndex:0] objectForKey:@"value"];
    [cFRAIPArray addObject:afterTomorrow];
    //DAY4
    NSString *next = [[[[[[flickrDictionary valueForKey:@"data"] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"weatherDesc"] objectAtIndex:0] objectForKey:@"value"];
    [cFRAIPArray addObject:next];
    //DAY5
    NSString *afterThat = [[[[[[flickrDictionary valueForKey:@"data"] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"weatherDesc"] objectAtIndex:0] objectForKey:@"value"];
    [cFRAIPArray addObject:afterThat];
    
    NSLog(@"cFRAIPArray is %@", cFRAIPArray);
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded!");
    /** Part 1
    cFRAIPArray = [[NSMutableArray alloc] initWithCapacity:5];
    for (NSString *key in flickrDictionary) {
        NSLog(@"the key is %@", flickrDictionary[key]);
        id object = flickrDictionary[key]; // this will be apikey,format,method etc...
        if ([object isKindOfClass:[NSDictionary class]]) { //first 4 are arrays-crsh-dicts
            NSLog(@"object valueForKey is %@", [object valueForKey:@"_content"]);
            [cFRAIPArray addObject:[object valueForKey:@"_content"]];
            
        } else {
            [cFRAIPArray addObject:flickrDictionary[key]];
        }
    }
    NSLog(@"cfraiparray %@", cFRAIPArray);
    **/
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [cFRAIPArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cFRAIP");
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [cFRAIPArray objectAtIndex:indexPath.row];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
