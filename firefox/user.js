user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("browser.download.alwaysOpenPanel", false);
// darwin only — ignored on other platforms
user_pref("widget.macos.titlebar-blend-mode.behind-window", true);
user_pref("browser.theme.native-theme", true);

// Startup
user_pref("browser.startup.page", 3);
user_pref("browser.startup.homepage", "chrome://browser/content/blanktab.html");

// New tab page
user_pref("browser.newtabpage.enabled", false);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.showSearch", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeBookmarks", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeDownloads", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includePocket", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeVisited", false);

// Sidebar / vertical tabs
user_pref("sidebar.verticalTabs", true);
user_pref("sidebar.revamp", true);

// Bookmarks
user_pref("browser.toolbars.bookmarks.visibility", "never");
user_pref("browser.bookmarks.editDialog.showForNewBookmarks", false);

// Password manager
user_pref("signon.rememberSignons", false);
user_pref("signon.autofillForms", false);
user_pref("signon.generation.enabled", false);
user_pref("signon.management.page.breach-alerts.enabled", false);

// Privacy / telemetry
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("browser.discovery.enabled", false);

// UI
user_pref("browser.aboutConfig.showWarning", false);
user_pref("browser.ml.chat.shortcuts", false);
user_pref("browser.ml.chat.provider", "https://gemini.google.com");
user_pref("accessibility.browsewithcaret", true);

// Language
user_pref("intl.accept_languages", "ko-kr,en-us");
user_pref("intl.regional_prefs.use_os_locales", true);

// Find bar
user_pref("accessibility.typeaheadfind.flashBar", 0);

// Picture-in-picture
user_pref("media.videocontrols.picture-in-picture.respect-disablePictureInPicture", false);

// Privacy
user_pref("privacy.clearOnShutdown_v2.formdata", true);

// Use user font selections instead of page fonts
user_pref("browser.display.use_document_fonts", 0);
// Fonts — Latin (x-western)
user_pref("font.default.x-western", "sans-serif");
user_pref("font.name.sans-serif.x-western", "Pretendard JP");
user_pref("font.name.serif.x-western", "Noto Serif CJK KR");
user_pref("font.name.monospace.x-western", "D2CodingLigature Nerd Font");
// Fonts — Korean
user_pref("font.default.ko", "sans-serif");
user_pref("font.name.sans-serif.ko", "Pretendard JP");
user_pref("font.name.serif.ko", "Noto Serif CJK KR");
user_pref("font.name.monospace.ko", "D2CodingLigature Nerd Font");
// Fonts — Japanese
user_pref("font.default.ja", "sans-serif");
user_pref("font.name.sans-serif.ja", "Pretendard JP");
user_pref("font.name.serif.ja", "Noto Serif CJK JP");
user_pref("font.name.monospace.ja", "D2CodingLigature Nerd Font");
