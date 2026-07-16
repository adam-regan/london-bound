# London Bound

A **SwiftUI London transport companion built on the Transport for London (TfL) API**, designed to explore production-quality iOS architecture for real-time, data-driven apps.

The app lets users check live line status, track upcoming arrivals, find nearby stations, and save their favourite stops through a custom-designed interface featuring a custom tab bar, adaptive iPad sidebar, and modern SwiftUI architecture.

## Highlights

• Live data powered by the **Transport for London (TfL) API**\
• **Swift Concurrency** (async/await) for asynchronous data loading\
• **MVVM-C architecture** with repository and service abstraction\
• **Core Location** for nearby station discovery\
• **Core Data** persistence for saved stations\
• **Auto-refreshing arrivals** via a reusable polling utility\
• **Custom SwiftUI UI components and design token system**\
• **Adaptive layouts** — custom tab bar on iPhone, sidebar on iPad\
• **Skeleton loading states** for improved UX\
• Protocol-driven design for testability

------------------------------------------------------------------------

# Motivation

This project explores how to build a **modern SwiftUI app around a live public API** that balances clean architecture with a polished user experience.

The focus was on solving real-world concerns such as:

• Consuming and decoding live network data\
• Asynchronous data loading and refresh\
• State management across multiple screens\
• Location permissions and services\
• Local persistence\
• Clean architecture and testability\
• Creating responsive and visually engaging UI components

The goal was to build something closer to a **real product experience rather than a simple demo app**.

------------------------------------------------------------------------

# Features

### Line Status

Browse the **current status of London's transport network**, grouped by mode, with disruption details available per line.

### Arrivals

Search for a station and view **live arrival predictions**, automatically refreshed while the screen is on-screen.

### Nearby

Uses **Core Location** to find stations close to the user, with graceful handling of permission and location errors.

### Saved

Users can **bookmark stations** for quick access, backed by **Core Data** persistence.

### Adaptive Navigation

A **custom tab bar** on iPhone and a **sidebar** on iPad, driven by a coordinator-based navigation layer.


### Skeleton Loading

Lists display **skeleton loading states** with a shimmer effect to improve perceived performance during network requests.

------------------------------------------------------------------------

# Tech Stack

## Core Frameworks

• **SwiftUI** – UI framework\
• **Core Location** – nearby station discovery\
• **Core Data** – saved stations persistence\
• **Foundation** – networking, JSON decoding, utilities

## Swift Features

• **Swift Concurrency** (async/await, Task, @MainActor)\
• **Property wrappers**:
- `@State`
- `@StateObject`
- `@Published`
- `@Environment`

------------------------------------------------------------------------

# Architecture

The app follows an **MVVM-C architecture** with clear separation between UI, business logic, and data access, organised using a **feature-folder structure** and coordinated navigation.

Key architectural goals:

• Maintain **separation of concerns**\
• Enable **testability** through protocol-driven design\
• Allow **data source flexibility** via service and repository abstraction\
• Keep SwiftUI views **lightweight and declarative**\
• Support **scalability** through modular feature folders

## Feature-Folder Structure

The project is organised into self-contained feature folders, each owning its own views, view models, and models. This keeps related code together, makes features easy to locate, and allows the project to scale without deep, unwieldy directory trees.

    Features/
      Status/         – line status, grouping, and disruption detail
      Arrivals/       – station search and live arrivals
      Nearby/         – location-based station discovery
      Saved/          – bookmarked stations
      StationDetail/  – shared station detail screen
      TabBar/         – tab bar (iPhone) and sidebar (iPad) shell

Shared infrastructure lives outside of features:

    Core/             – services, models, persistence, utilities
    Coordinators/     – navigation routing
    DesignSystem/     – colour, spacing, and radius tokens + components

## Layers

### Views (SwiftUI)

Views focus purely on presentation and user interaction.

Examples include:

- StatusView
- ArrivalsView
- NearbyView
- SavedView
- StationDetailView
- CustomTabBarView / CustomSideBarView

Reusable UI components (lists, headers, shimmer, error and skeleton states) are extracted into smaller composable views in the **DesignSystem**.

------------------------------------------------------------------------

### ViewModels

ViewModels manage UI state and coordinate data between services and views.

Examples:

**StatusViewModel**\
Fetches line statuses and groups them by transport mode.

**ArrivalsViewModel**\
Drives station search and live arrivals, refreshing on a timer.

**NearbyViewModel**\
Requests location and resolves nearby stations.

**SavedViewModel / SavedAddViewModel**\
Manage the saved-station list and the add-station flow.


------------------------------------------------------------------------

### Models

Domain models such as **StationDetail**, **Line**, **LineStatus**, **Arrival**, **NearbyStation**, and **SavedStation** describe the network and persisted data, with conversions between representations kept close to the models themselves.

Line and service colours are derived through model extensions (`LineID+Color`, `ServiceCondition+Color`).

------------------------------------------------------------------------

### Service & Repository Layer

Network and data access are abstracted behind protocols, enabling stubbed implementations for previews and tests.

Protocol:

    protocol TFLAPIServiceProtocol {
        func lineStatus() async throws -> [LineStatus]
        func searchStations(name: String) async throws -> [Station]
        func arrivals(stationId: String) async throws -> [Arrival]
        func nearbyStations(coords: Coordinate) async throws -> [NearbyStation]
    }

Implementations:

**TFLAPIService**\
Live implementation backed by the TfL REST API and a typed `TFLEndpoint`.

**TFLAPIServiceStub**\
Used for previews and testing.

The same pattern applies to `LocationProviderProtocol` and `SavedStationsRepositoryProtocol`, each with a live and a stub implementation.

------------------------------------------------------------------------

### Utilities

**Poller** – drives periodic refresh of live arrivals.\
**ArrivalsCache** – caches recent arrivals responses.\
**Loadable** – models loading / loaded / error states for the UI.\
**LossyDecodableArray** – decodes arrays while skipping malformed elements, keeping live data robust.

------------------------------------------------------------------------

# Key Patterns Used

**MVVM-C architecture**

Clear separation between UI, state management, and business logic.

**Coordinator Pattern**

`MainCoordinator` and `Page` centralise navigation routing across the app.

**Repository / Service Abstraction**

Protocols decouple the data layer from UI logic and allow live or stubbed data sources.

**Dependency Injection**

Dependencies are composed in `AppDependencies` and passed through initializers.

**Protocol-Oriented Design**

Protocols enable testability and flexible implementations.

**Swift Concurrency**

Async operations handled using modern async/await patterns.

------------------------------------------------------------------------

# Testing

Tests are written using **Swift Testing**, the modern macro-based testing framework, with a `MockURLProtocol` for driving network responses.

Testing focuses on:

• API decoding and endpoint construction\
• model conversions and colour mapping\
• ViewModel logic and state transitions\
• utility behaviour (lossy decoding, name cleaning)

------------------------------------------------------------------------

# Running the Project

1.  Clone the repository
2.  Copy `Config.xcconfig.example` to `Config.xcconfig` and paste in your own
    free TfL API key from the [TfL API Portal](https://api-portal.tfl.gov.uk/)
3.  Open the project in **Xcode**
4.  Build and run on an **iOS simulator or device**

The app talks to the live **TfL API**, so a network connection is required. Nearby station discovery requires **location permission**.

------------------------------------------------------------------------

# Future Improvements

## Platform Features

• Live Activities for tracked arrivals\
• Home screen and Lock Screen widgets\
• Notifications for saved-line disruptions

## User Experience

• Journey planning\
• Map-based nearby view

------------------------------------------------------------------------

# Author

Adam Regan\
2026
