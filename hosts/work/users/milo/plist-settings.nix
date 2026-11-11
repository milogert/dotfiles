{ config, ... }:

{
  programs.nix-plist-manager.enable = true;

  # programs.nix-plist-manager.ignoreWarnings = [
  #   "applications.systemSettings.desktopAndDock.hotCorners.bottomLeft.modifiers -> applications.systemSettings.desktopAndDock.hotCorners.bottomLeft.action"
  #   "applications.systemSettings.desktopAndDock.hotCorners.topLeft.modifiers -> applications.systemSettings.desktopAndDock.hotCorners.topLeft.action"
  #   "applications.systemSettings.desktopAndDock.hotCorners.topRight.modifiers -> applications.systemSettings.desktopAndDock.hotCorners.topRight.action"
  # ];

  programs.nix-plist-manager.options.applications = {
    finder = {
      menuBar = {
        view = {
          showSidebar = true;
        };
      };
      settings = {
        advanced = {
          showAllFilenameExtensions = true;
          showWarningBeforeChangingAnExtension = false;
        };
        general = {
          showTheseItemsOnTheDesktop = {
            cdsDvdsAndiPods = true;
            connectedServers = true;
            externalDisks = true;
            hardDisks = true;
          };
        };
      };
    };
    systemSettings = {
      accessibility = {
        audio = {
          backgroundSounds = false;
          backgroundSoundsOptions = {
            timer = false;
          };
        };
        display = {
          showBorders = false;
        };
        hoverText = {
          hoverText = false;
          hoverTypingOptions = {
            textFont = "Default";
          };
          options = {
            textFont = "Default";
          };
        };
        keyboard = {
          slowKeys = false;
          slowKeysOptions = {
            acceptanceDelay = 250;
          };
          stickyKeys = false;
          stickyKeysOptions = {
            pressTheShiftKeyFiveTimesToToggleStickyKeys = false;
          };
        };
        liveCaptions = {
          fontFamily = "Default";
        };
        liveSpeech = {
          liveSpeech = false;
        };
        pointerControl = {
          ignoreBuiltInTrackpadWhenMouseOrWirelessTrackpadIsPresent = false;
          mouseOptions = {
            scrollSpeed = 0.5;
          };
          springLoading = true;
          springLoadingSpeed = 0.5;
          trackpadOptions = {
            useInertiaWhenScrolling = true;
            useTrackpadForScrolling = true;
          };
        };
        readAndSpeak = {
          typingFeedback = {
            characters = true;
            modifierKeys = false;
            selectionChanges = false;
            words = true;
          };
        };
        rtt = {
          sendImmediately = true;
        };
        zoom = {
          useKeyboardShortcutsToZoom = false;
        };
      };
      appearance = {
        clickInTheScrollBarTo = "Jump to the next page";
        showScrollBars = "Always";
      };
      appleIntelligenceAndSiri = {
        siri = {
          enable = false;
        };
      };
      desktopAndDock = {
        desktopAndStageManager = {
          showItems = {
            inStageManager = false;
          };
          showRecentAppsInStageManager = true;
          showWindowsFromAnApplication = "All at Once";
        };
        dock = {
          animateOpeningApplications = false;
          automaticallyHideAndShowTheDock = {
            delay = 0.0;
            duration = 0.0;
            enabled = true;
          };
          dockPositionOnScreen = "Bottom";
          minimizeWindowsIntoApplicationIcon = true;
          minimizedWindowAnimation = "Scale Effect";
          showIndicatorsForOpenApplications = true;
          showSuggestedAndRecentAppsInDock = false;
          size = 64;
        };
        hotCorners = {
          bottomLeft = {
            modifiers = {
              command = false;
              control = false;
              option = false;
              shift = false;
            };
          };
          bottomRight = {
            action = "Quick Note";
            modifiers = {
              command = false;
              control = false;
              option = false;
              shift = false;
            };
          };
          topLeft = {
            action = "-";
            modifiers = {
              command = false;
              control = false;
              option = false;
              shift = false;
            };
          };
          topRight = {
            modifiers = {
              command = false;
              control = false;
              option = false;
              shift = false;
            };
          };
        };
        missionControl = {
          automaticallyRearrangeSpacesBasedOnMostRecentUse = false;
          displaysHaveSeparateSpaces = false;
          groupWindowsByApplication = false;
          shortcuts = {
            applicationWindows = "-";
            missionControl = "-";
            showDesktop = "-";
          };
        };
        widgets = {
          showWidgets = {
            inStageManager = true;
            onDesktop = true;
          };
        };
      };
      displays = {
        showResolutionsAsList = true;
        universalControl = {
          allowPointerAndKeyboardToMoveBetweenNearbyDevices = false;
        };
        whenConnectedToTv = "Ask What to Show";
      };
      general = {
        airDropAndContinuity = {
          allowHandoffBetweenThisMacAndYourIcloudDevices = false;
          iPhoneWidgets = false;
        };
        languageAndRegion = {
          applications = { };
          firstDayOfWeek = "Monday";
          preferredLanguages = [
            "en-US"
          ];
          region = "en_US";
          temperature = "Fahrenheit (°F)";
        };
        sharing = {
          mediaSharing = {
            shareMediaWithGuests = false;
          };
        };
      };
      keyboard = {
        delayUntilRepeat = 15;
        keyRepeatRate = 1;
        keyboardShortcuts = {
          accessibility = {
            decreaseContrast = false;
            increaseContrast = false;
            invertColors = false;
          };
          appShortcuts = {
            menuItems = {
              "com.apple.iWork.Numbers" = {
                "Paste and Match Style" = "⇧⌘V";
              };
            };
          };
          inputSources = {
            selectNextSourceInInputMenu = false;
            selectThePreviousInputSource = false;
          };
          missionControl = {
            moveLeftASpace = true;
            moveRightASpace = true;
          };
          services = { };
          spotlight = {
            showFinderSearchWindow = false;
            showSpotlightSearch = "⌘Space";
          };
        };
        textInput = {
          addPeriodWithDoubleSpace = false;
          capitalizeWordsAutomatically = false;
          inputSources = [
            "com.apple.keylayout.US"
          ];
          showInlinePredictiveText = false;
          useSmartQuotesAndDashes = false;
        };
      };
      menuBar = {
        clock = {
          showAmPm = true;
          showTheDayOfTheWeek = true;
        };
        textInput = true;
        timeMachine = false;
      };
      privacyAndSecurity = {
        appleAdvertising = {
          personalizedAds = false;
        };
      };
      sound = {
        soundEffects = {
          playFeedbackWhenVolumeIsChanged = false;
        };
      };
      spotlight = {
        searchResults = {
          appStore = true;
          apps = true;
          books = true;
          calculator = true;
          calendar = true;
          contacts = true;
          dictionary = true;
          files = true;
          folders = true;
          games = true;
          iPhoneApps = true;
          mail = true;
          menuItems = true;
          messages = true;
          music = true;
          notes = true;
          phone = true;
          photos = true;
          podcasts = true;
          reminders = true;
          safari = true;
          shortcuts = true;
          systemSettings = true;
          tips = true;
          voiceMemos = true;
        };
        showRelatedContent = true;
      };
      trackpad = {
        moreGestures = {
          notificationCenter = true;
        };
        pointAndClick = {
          click = "Medium";
          forceClickAndHapticFeedback = true;
        };
        scrollAndZoom = {
          naturalScrolling = true;
          rotate = true;
          smartZoom = true;
          zoomInOrOut = true;
        };
      };
      wallpaper = {
        startScreenSaver = "After 10 minutes";
      };
    };
  };
}
