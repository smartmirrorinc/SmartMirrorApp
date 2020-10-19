part of components;

class ModuleNewsfeed extends PositionedModule {
  bool showPublishDate;
  bool showSourceTitle;
  List<dynamic> feeds;

  ModuleNewsfeed(
      id, module, position, _showPublishDate, _showSourceTitle, _feeds)
      : showPublishDate = _showPublishDate,
        showSourceTitle = _showSourceTitle,
        feeds = _feeds,
        super(id, module, position);

  factory ModuleNewsfeed.fromJson(Map<String, dynamic> json) {
    return ModuleNewsfeed(
      json['_meta']['id'],
      json['module'],
      modulePositionFromString(json['position']),
      json['config']['showPublishDate'],
      json['config']['showSourceTitle'],
      json['config']['feeds'],
    );
  }

  static instantiate(Map<String, dynamic> json) =>
      ModuleNewsfeed.fromJson(json);

  @override
  String toString() {
    return "{id:$id, module:$module, position:${position.toString()}, " +
        "showPublishDate: $showPublishDate, " +
        "showSourceTitle: $showSourceTitle, " +
        "feeds: ${feeds.toString()}}";
  }

  @override
  void buildWidgets(Function refresh) {
    super.buildWidgets(refresh);

    // Checkbox to toggle "show publish date"
    widgets.add(Card(
        child: Column(children: [
      ListTile(
        leading: Icon(Icons.date_range),
        title: Text("Show publish date",
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Align(
            child: Checkbox(
                value: showPublishDate,
                onChanged: (x) {
                  showPublishDate = x;
                  refresh(this);
                }),
            alignment: Alignment.centerLeft),
      )
    ])));

    // Checkbox to toggle "show source title"
    widgets.add(Card(
        child: Column(children: [
      ListTile(
        leading: Icon(Icons.subtitles),
        title: Text("Show source title",
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Align(
            child: Checkbox(
                value: showSourceTitle,
                onChanged: (x) {
                  showSourceTitle = x;
                  refresh(this);
                }),
            alignment: Alignment.centerLeft),
      )
    ])));

    // "Feeds" header with icon and add button
    // TODO: make add button actually do something
    var feedsHeaderTile = ListTile(
        leading: Icon(Icons.rss_feed),
        title: Text("Feeds", style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Icon(Icons.add));

    // List with each feed and menu button, click item to open menu
    var feedList = List<Widget>();
    feeds.forEach((feed) {
      feedList.add(PopupMenuButton(
        child: ListTile(
          title: Text(feed['title'],
              style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(feed['url']),
          trailing: Icon(Icons.menu),
        ),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'delete',
            child: Text('Delete'),
          ),
        ],
        onSelected: (String x) {
          if (x == "delete") {
            feeds.remove(feed);
            refresh(this);
          }
        },
      ));
    });

    widgets.add(Card(
        child: Column(
      children: [
        feedsHeaderTile,
        // wrap feeds in scrollable listview
        ListView(
            children: feedList,
            scrollDirection: Axis.vertical,
            shrinkWrap: true)
      ],
    )));
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json['config'] = {
      'broadcastNewsFeeds': true,
      'broadcastNewsUpdates': true,
      'showPublishDate': showPublishDate,
      'showSourceTitle': showSourceTitle,
      'feeds': feeds
    };
    return json;
  }
}
