# Assignment
Create a universal iOS app which:
1. Ingests a json feed from https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json
2. You can use a third party json parser to parse this if desired.
3. The feed contains a title and a list of rows
4. Displays the content (including image, title and description) in a table
5. The title in the navbar should be updated from the json
6. Each row should be the right height to display its own content and no taller. No content should be clipped.
This means some rows will be larger than others.
7. Loads the images lazily
8. Don’t download them all at once, but only as needed
9. Refresh function
10. Either place a refresh button or use pull down to refresh.
11. Should not block UI when loading the data from the json feed.
