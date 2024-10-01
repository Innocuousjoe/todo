# todo
Simple "To Do" List

## Installation Instructions
via **XCode**
1. Download repository
2. Open project in XCode
3. Make sure preferred provisioning profiles are selected and cooperating with XCode - if necessary, setting for automatic management should work
4. Run using your preferred simulator

via **TestFlight**
1. Download app via [link to be determined](https://www.google.com)

# Architecture Overview
## Networking
The app uses Moya to put together it's various API calls (exactly 1) which are consumed by the State services (also exactly 1, **TodoListState**).

## State Management
A simple Core Data instance is used to persist data between app launches.  When the **todos** api call returns, every object is saved into Core Data.

On the UI side, a Fetched Results Observer is created to watch the **ListItem** model and react to any changes, which happens immediately after said objects are saved into Core Data.

## UI
The **TodoListViewController** uses a compositional layout, creating snapshots based on the incoming data and then feeding that into a collection view.  This allows for extensibility
and substantial customization on a per-cell basis.  Plus, it's reactive out of the box.

The ViewController holds as little as possible, ideally just the UI, and relies on closures from the ViewModel to know when to update the snapshot.

In the ViewModel, we hit our API, turn the data into a snapshot, and then tell the ViewController to update.

## Testing
Tests can be run from inside XCode after specifying an appropriate scheme by just hitting **CMD + U**

UI tests cover the basic flows of the app: adding, deleting, completing, and editing tasks.

Unit tests do unit test things, covering basic core data functionality and view model usage.

# Next Steps
## Dependency Injection
A later version of the app will bundle the various dependencies that are being hard-instantiated into one insertion point, and pass that along from the root level.

## State Management
Todo's Core Data right now is relying on default model creation and insertion, where a more robust wrapper can be used instead to simplify things and provide an 
easy to understand DSL.

## UI
A simple login flow would give us the opportunity to expose different todo tasks depending on who is logged in

## Testing
There's always more to be done testing-wise.






On load of the **TodoListViewController**, the **TodoListViewModel** uses the **TodoListState** to ping *https://jsonplaceholder.typicode.com/todos*