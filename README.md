# iOS Assignment la3eb
iOS interview app for la3eb.

Table of Contents

1.0 Problem Statement
2.0 Solution
3.0 Implementation
4.0 Testing
5.0 Comments
6.0 Recommendations


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
Classes contains documentation of all methods and properties. Methods will show auto complete with 
      
## 3.0 Implementation

I have used Tabbar along with navigation controllers. For Games and favourite lists ```UICollectionView```  is used to cater dual coulmn mode on landscape mode. Implementaion was divided into four main layers

1: Controllers: 
 
      


suggestions:Multilanguage
