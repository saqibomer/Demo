# iOS Demo


Table of Contents

1. Problem Statement
2. Solution
3. Implementation
4. Testing
5. Comments



## 1.0 Problem Statement

> Build an app with tabbar using Swift 4.2 or greater. Tab 1 will "Games" and tab 2 will "Favourites". Games tab will contain list of games which will be fetched from api. Favourites tab will contain list of "Favourited" games. Tapping on list item of either tab will open game detail view. Game details will be fetched from api.

## 2.0 Solution
I will develop a app using Swift 5.2.4 (latest at the time of writting) and Storyboard. I will use MVVM architecture. As this is a prototype, MVVM will be extreamly helpful in scalling this app and adding other modules. As controllers are managed by view models, we can use them for unit testing. Following are techincal details

#### Directory Structure:

   > Demo Contains core classes of project. It is further devided into 
   
      - Extensions: Contains all the extensions that will be used in app
      - Config: Contains configurations like environments
      - Controllers: Contains controllers for all views
      - ViewModels: Contains all view models for controllers
      - Models: All the data models for objects are in this directory
      - NetworkClient: Contains networking layer
      - Helpers: Contains utillity classes to help manage different operations
    
##### Environments:
App has three environments to help and maintain development life cyle. Environments are as follows.  
       
       - Development: Local development environment. This will be used while debugging app in Xcode
       - Staging: This will be production like environment but for beta testers or internal testers
       - Production: App store ready environment
       
##### Swift Version: 
        - 5.2.4
##### Xcode Version: 
        - 12.4 (12D4e)
##### Supported OS: 
        - iOS 11.0 and upword
##### Supported Devices: 
        - iPhone
        - iPad
##### Supported Orientations: 
        - Portrait
        - Landscape left
        - Landscape right
                

##### Classes documentation: 
Classes contains documentation of all methods and properties. Methods will show auto complete. 
      
## 3.0 Implementation

I have used Tabbar along with navigation controllers. For Games and favourite lists ```UICollectionView```  is used to cater dual coulmn mode on landscape mode. Implementaion was divided into four main layers

1. View Controllers: 
 Interacts with view models and manages views
 2. View Models:
 Fetches data from network and input or output data to and from views via controllers
3. Models: 
Contains business logic

## 4.0 Testing

I have used Xcode unit testing to test decoding of models. In order to test hit diamond icon on `DemoTests.swift`. It contains three unit tests

1. Test for games api response
2. Test for game detail api
3. Test for search api


## 5.0 Comments

In order to improve app I have following suggestions
* Search api is searching in real time but due to network requests it is not fast enough. I recommend using [MeiliSearch](http://meilisearch.com). It is open source and provides a good user experience. 
* App should provide multi language
* SwiftUI is not mature enough to use in a production environment at the moment but app should be converted to SwiftUI to take leverage of `Combine` framework. 
