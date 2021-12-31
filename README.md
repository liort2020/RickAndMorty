# Rick and Morty App
![Application version](https://img.shields.io/badge/application%20version-v1.1.0-blue)
![Swift version](https://img.shields.io/badge/Swift-%205.5-orange)
![Xcode version](https://img.shields.io/badge/Xcode-%2013.2.1-yellow)
![Platforms](https://img.shields.io/badge/platforms-iOS%20-lightgrey.svg)

RickAndMorty is an application that fetches a list of Rick and Morty characters.

## Architecture

![Screenshot](https://github.com/liort2020/RickAndMorty/blob/master/Assets/RickAndMortyAppArchitecture.png)

This application developed in `SwiftUI`, `async/await`, `TaskGroup`, `Combine`. Implemented in `MVVM`, and `Clean Architecture` with three layers:
- **Presentation layer**
  - Contains `Views` and cells.
  - `ViewModel` - Connect between presentation layer and data layer. For example `RealCharactersListViewModel` and `MockedCharactersListViewModel` (For Tests) - Implement `CharactersListViewModel` protocol (Strategy design pattern).
  - `ViewRouting` control navigation between views. For example `CharactersListViewRouting`.
  - `CharactersListViewRouting` and `CharacterDetailsViewRouting` control navigation between views (ViewRouting contains them).
  
- **Domain layer**
  - `RealCharactersInteractor` - Connect between presentation layer and data layer. `RealCharactersInteractor` and `MockedCharactersInteractor` (For Tests) - Implement `CharactersInteractor` protocol (Strategy design pattern).
  - `RickAndMortyCharactersAPI`- Model that we got from the "character" server, implements `CharactersAPI` and `Codable`.
  - `RickAndMortyEpisodesAPI`- Model that we got from the "episode" server, implements `EpisodesAPI` and `Codable`.
  - `AppState` - Contains `ViewRouting` that control navigation between views.
  
- **Data Layer**
  - **APIRepositories**:
  - `APIRepository` - Retrieves data from the server using `async/await`.
  - `CharactersAPIRepository` - Allow us to get all characters and episodes, implements `APIRepository` protocol. `RealCharactersAPIRepository` and `MockedCharactersAPIRepository` (For Tests) - Implement `CharactersAPIRepository` protocol (Strategy design pattern).
  - `RealCharactersAPIRepository` - Allow us to communicate with the server using URLSession, implements `CharactersAPIRepository` protocol.
  - `APIError` - The error that `APIRepository` can throw.
  - `Endpoint` - Prepares the URLRequest to connect to the server (`RickAndMortyEndpoint` implements this protocol).
  - `HTTPMethod` - The HTTP methods that allow in this application.
  - `MockedCharactersAPIRepository` (For Tests) - Allow us to communicate with fake server, implements `CharactersAPIRepository` and `TestAPIRepository`.
  - `TestAPIRepository` (For Tests) - Retrieves data from fake server using mocked session, implements `APIRepository`.
  - `MockURLProtocol` (For Tests) - Get request and return mock response, implements `URLProtocol`.
  - `MockAPIError` (For Tests) - The error that `TestAPIRepository` can throw.
  
  - **DBRepositories**:
  - `PersistentStore` - Allow us to fetch, update, and delete items from `CoreData` database. `CoreDataStack` and `MockedPersistentStore` (For Tests) - Implement `PersistentStore` protocol (Strategy design pattern).
  - `CoreDataStack` - Allow access to `CoreData` storage, implements `PersistentStore`.
  - `MockedPersistentStore` (For Tests) - Allow access to in-memory storage for testing, implements `PersistentStore`.
  - `CharactersDBRepository` - Allow us to fetch and save lists of characters and episodes. `RealCharactersDBRepository` and `MockedCharactersDBRepository` (For Tests) - Implement `CharactersDBRepository` protocol (Strategy design pattern).
  - `RealCharactersDBRepository` - Allow us to use `CoreDataStack` to get all items from `CoreData`, implements `CharactersDBRepository`.
  -  `MockedCharactersDBRepository` (For Tests) - Allow us to use `MockedPersistentStore` to get all items from in-memory storage, implements `CharactersDBRepository`.
  - `Character` and `Episode` - Models that we save in `CoreData` database, these models are shown in `Views`. `Character` and `Episode` models inherit from `NSManagedObject` class and implement `Identifiable` protocol.
  
- **System**
  - `RickAndMortyApp` - An entry point to this application.
  - `DIContainer` – Help us to inject the dependencies (Dependency injection design patterns) holds the `Interactors`, `DBRepositories`, `APIRepositories` and `AppState`.
  

## Server API
- Get a list of characters
  - HTTP Method: `GET`
  - URL: [`https://rickandmortyapi.com/api/character?page={page_number}`](https://rickandmortyapi.com/api/character?page=1)

- Get a list of episodes
  - HTTP Method: `GET`
  - URL: [`https://rickandmortyapi.com/api/episode/{id}`](https://rickandmortyapi.com/api/episode/1)
  
  
## Dependencies - Pods
  - We use [`URLImage`](https://cocoapods.org/pods/URLImage) SwiftUI view that displays an image downloaded from provided URL.
  
  
## Installation
### System requirement
- iOS 15.2 or later

### Install and Run the RickAndMorty application
1. Install [`CocoaPods`](https://cocoapods.org) - This is a dependency manager for Swift and Objective-C projects for Apple's platforms. 
You can install it with the following command:

```bash
$ gem install cocoapods
```

2. Navigate to the project directory and install pods from `Podfile` with the following command:

```bash
$ pod install
```

3. Open the `RickAndMorty.xcworkspace` file that was created and run it in Xcode


## Tests

### Unit Tests
Run unit tests:
1. Navigate to `RickAndMortyTests` target

2. Run the test from `Product` ➞ `Test` or use `⌘U` shortcuts

### Performance Tests
Run performance tests:
1. Navigate to `RickAndMortyPerformanceTests` target

2. Run the test from `Product` ➞ `Test` or use `⌘U` shortcuts

### UI Tests
Run UI tests:
1. Navigate to `RickAndMortyUITests` target

2. Run the test from `Product` ➞ `Test` or use `⌘U` shortcuts


### Screen recording

1. List of characters
  <img src="https://github.com/liort2020/RickAndMorty/blob/master/Assets/CharactersScreenRecording.gif" width="220"/>

2. Search characters
  <img src="https://github.com/liort2020/RickAndMorty/blob/master/Assets/SearchScreenRecording.gif" width="220"/>

3. List of episodes
  <img src="https://github.com/liort2020/RickAndMorty/blob/master/Assets/EpisodesScreenRecording.gif" width="220"/>
