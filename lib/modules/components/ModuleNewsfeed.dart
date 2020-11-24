part of components;

// TODO: Any nice way to get a list of popular feeds?
var knownFeeds = [
  {"title": "DR", "url": "https://www.dr.dk/nyheder/service/feeds/allenyheder"},
  {"title": "Ingeniøren", "url": "https://www.ing.dk/section/rss-all?mime=xml"},
  {"title": "TV2 Øst", "url": "https://www.tv2east.dk/rss"},
  {"title": "TV2 Nord", "url": "https://www.tv2nord.dk/rss"},
  {"title": "BT", "url": "https://www.bt.dk/bt/seneste/rss"},
  {"title": "Videnskab.dk", "url": "https://videnskab.dk/topic/all/rss"},
  {"title": "Computerworld", "url": "https://www.computerworld.dk/rss/all"},
  {"title": "Jyllands-Posten", "url": "https://jyllands-posten.dk/?service=rssfeed"},
];

class ModuleNewsfeed extends PositionedModule {
  bool showPublishDate;
  bool showSourceTitle;
  List<dynamic> feeds;

  ModuleNewsfeed(
      id, order, module, position, _showPublishDate, _showSourceTitle, _feeds)
      : showPublishDate = _showPublishDate,
        showSourceTitle = _showSourceTitle,
        feeds = _feeds,
        super(id, order, module, position);

  factory ModuleNewsfeed.fromJson(Map<String, dynamic> json) {
    bool showPublishDate = true;
    bool showSourceTitle = true;
    List<dynamic> feeds = [knownFeeds[0]];
    if (json.containsKey("config")) {
      if (json["config"].containsKey("showPublishDate")) {
        showPublishDate = json['config']['showPublishDate'];
      }
      if (json["config"].containsKey("showSourceTitle")) {
        showSourceTitle = json['config']['showSourceTitle'];
      }
      if (json["config"].containsKey("feeds")) {
        feeds = json['config']['feeds'];
      }
    }

    return ModuleNewsfeed(
      json['_meta']['id'],
      json['_meta']['order'],
      json['module'],
      modulePositionFromString(json['position']),
      showPublishDate,
      showSourceTitle,
      feeds,
    );
  }

  static instantiate(Map<String, dynamic> json) =>
      ModuleNewsfeed.fromJson(json);

  @override
  String toString() {
    return "{id:$id, order:$order, module:$module, position:${position.toString()}, " +
        "showPublishDate: $showPublishDate, " +
        "showSourceTitle: $showSourceTitle, " +
        "feeds: ${feeds.toString()}}";
  }

  @override
  void buildWidgets(BuildContext context, Function refresh) {
    super.buildWidgets(context, refresh);

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

    var knownFeedMenuItems = List<PopupMenuItem<String>>();
    knownFeeds.forEach((x) {
      if (feeds.where((feed) => feed["title"] == x["title"]).length == 0)
        knownFeedMenuItems.add(
            PopupMenuItem<String>(value: x["title"], child: Text(x["title"])));
    });

    // "Feeds" header with icon and add button
    // TODO: Add custom feed option
    var feedsHeaderTile = PopupMenuButton(
        child: ListTile(
            leading: Icon(Icons.rss_feed),
            title: Text("Feeds", style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Icon(Icons.add)),
        itemBuilder: (BuildContext context) => knownFeedMenuItems,
        onSelected: (String x) {
          var newfeed = knownFeeds.where((feed) => feed["title"] == x);
          if (newfeed.length != 1) throw ("Invalid feed $x");
          feeds.add(newfeed.first);
          refresh(this);
        });

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

    var tiles = List<Widget>();
    tiles.add(feedsHeaderTile);
    feedList.forEach((x) => tiles.add(x));

    widgets.add(
        Card(child: SingleChildScrollView(child: Column(children: tiles))));
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
