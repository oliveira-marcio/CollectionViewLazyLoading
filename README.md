# CollectionViewLazyLoading

### Proposal
The goal here is to update separated rows of the table/collection view based on asynchronous interactors' responses with data for each row.

For example, we can have a kind of dashboard screen where each section receives data from a different API every time the screen is displayed. Therefore, to avoid waiting until the last API data is retrieved to completely update the whole dashboard, we can try this lazy loading approach where each section of the dashboard might be a row in the table view and asynchronously update each row as soon as we retrieve the corresponding data.

### Solution
Here we have some fake interactors that just simulate asynchronous API calls with random delay and each interactor keeps its corresponding updated model. Also we have a table view that will have rows based in the provided array of models

Therefore, we can just create updated snapshots as soon as we receive the data from each interactor, and apply them to the table view.

Because of the capabilities of `UITableViewDiffableDataSource`, no unnecessary refresh will be done in rows with unchanged data when we apply the snapshot with the full list of models.

The `rowMap` will keep an indexed list of models to be updated as they are asynchronously received and the snapshots will always be created from it. The indexes will also ensure that the rows will be assembled in the correct order.

In the first run, the map will be empty, so the table view will grow accordingly to the data received. The next runs will only update the contents of the rows.

### Demo
[Download the video](https://github.com/oliveira-marcio/CollectionViewLazyLoading/blob/main/Demo/demo.mov?raw=true)
