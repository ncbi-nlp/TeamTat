var keyboardMap = [
  "", // [0]
  "", // [1]
  "", // [2]
  "CANCEL", // [3]
  "", // [4]
  "", // [5]
  "HELP", // [6]
  "", // [7]
  "BACK_SPACE", // [8]
  "TAB", // [9]
  "", // [10]
  "", // [11]
  "CLEAR", // [12]
  "ENTER", // [13]
  "ENTER_SPECIAL", // [14]
  "", // [15]
  "SHIFT", // [16]
  "CONTROL", // [17]
  "ALT", // [18]
  "PAUSE", // [19]
  "CAPS_LOCK", // [20]
  "KANA", // [21]
  "EISU", // [22]
  "JUNJA", // [23]
  "FINAL", // [24]
  "HANJA", // [25]
  "", // [26]
  "ESCAPE", // [27]
  "CONVERT", // [28]
  "NONCONVERT", // [29]
  "ACCEPT", // [30]
  "MODECHANGE", // [31]
  "SPACE", // [32]
  "PAGE_UP", // [33]
  "PAGE_DOWN", // [34]
  "END", // [35]
  "HOME", // [36]
  "LEFT", // [37]
  "UP", // [38]
  "RIGHT", // [39]
  "DOWN", // [40]
  "SELECT", // [41]
  "PRINT", // [42]
  "EXECUTE", // [43]
  "PRINTSCREEN", // [44]
  "INSERT", // [45]
  "DELETE", // [46]
  "", // [47]
  "0", // [48]
  "1", // [49]
  "2", // [50]
  "3", // [51]
  "4", // [52]
  "5", // [53]
  "6", // [54]
  "7", // [55]
  "8", // [56]
  "9", // [57]
  "COLON", // [58]
  "SEMICOLON", // [59]
  "LESS_THAN", // [60]
  "EQUALS", // [61]
  "GREATER_THAN", // [62]
  "QUESTION_MARK", // [63]
  "AT", // [64]
  "A", // [65]
  "B", // [66]
  "C", // [67]
  "D", // [68]
  "E", // [69]
  "F", // [70]
  "G", // [71]
  "H", // [72]
  "I", // [73]
  "J", // [74]
  "K", // [75]
  "L", // [76]
  "M", // [77]
  "N", // [78]
  "O", // [79]
  "P", // [80]
  "Q", // [81]
  "R", // [82]
  "S", // [83]
  "T", // [84]
  "U", // [85]
  "V", // [86]
  "W", // [87]
  "X", // [88]
  "Y", // [89]
  "Z", // [90]
  "OS_KEY", // [91] Windows Key (Windows) or Command Key (Mac)
  "", // [92]
  "CONTEXT_MENU", // [93]
  "", // [94]
  "SLEEP", // [95]
  "NUMPAD0", // [96]
  "NUMPAD1", // [97]
  "NUMPAD2", // [98]
  "NUMPAD3", // [99]
  "NUMPAD4", // [100]
  "NUMPAD5", // [101]
  "NUMPAD6", // [102]
  "NUMPAD7", // [103]
  "NUMPAD8", // [104]
  "NUMPAD9", // [105]
  "MULTIPLY", // [106]
  "ADD", // [107]
  "SEPARATOR", // [108]
  "SUBTRACT", // [109]
  "DECIMAL", // [110]
  "DIVIDE", // [111]
  "F1", // [112]
  "F2", // [113]
  "F3", // [114]
  "F4", // [115]
  "F5", // [116]
  "F6", // [117]
  "F7", // [118]
  "F8", // [119]
  "F9", // [120]
  "F10", // [121]
  "F11", // [122]
  "F12", // [123]
  "F13", // [124]
  "F14", // [125]
  "F15", // [126]
  "F16", // [127]
  "F17", // [128]
  "F18", // [129]
  "F19", // [130]
  "F20", // [131]
  "F21", // [132]
  "F22", // [133]
  "F23", // [134]
  "F24", // [135]
  "", // [136]
  "", // [137]
  "", // [138]
  "", // [139]
  "", // [140]
  "", // [141]
  "", // [142]
  "", // [143]
  "NUM_LOCK", // [144]
  "SCROLL_LOCK", // [145]
  "WIN_OEM_FJ_JISHO", // [146]
  "WIN_OEM_FJ_MASSHOU", // [147]
  "WIN_OEM_FJ_TOUROKU", // [148]
  "WIN_OEM_FJ_LOYA", // [149]
  "WIN_OEM_FJ_ROYA", // [150]
  "", // [151]
  "", // [152]
  "", // [153]
  "", // [154]
  "", // [155]
  "", // [156]
  "", // [157]
  "", // [158]
  "", // [159]
  "CIRCUMFLEX", // [160]
  "EXCLAMATION", // [161]
  "DOUBLE_QUOTE", // [162]
  "HASH", // [163]
  "DOLLAR", // [164]
  "PERCENT", // [165]
  "AMPERSAND", // [166]
  "UNDERSCORE", // [167]
  "OPEN_PAREN", // [168]
  "CLOSE_PAREN", // [169]
  "ASTERISK", // [170]
  "PLUS", // [171]
  "PIPE", // [172]
  "HYPHEN_MINUS", // [173]
  "OPEN_CURLY_BRACKET", // [174]
  "CLOSE_CURLY_BRACKET", // [175]
  "TILDE", // [176]
  "", // [177]
  "", // [178]
  "", // [179]
  "", // [180]
  "VOLUME_MUTE", // [181]
  "VOLUME_DOWN", // [182]
  "VOLUME_UP", // [183]
  "", // [184]
  "", // [185]
  "SEMICOLON", // [186]
  "EQUALS", // [187]
  "COMMA", // [188]
  "MINUS", // [189]
  "PERIOD", // [190]
  "SLASH", // [191]
  "BACK_QUOTE", // [192]
  "", // [193]
  "", // [194]
  "", // [195]
  "", // [196]
  "", // [197]
  "", // [198]
  "", // [199]
  "", // [200]
  "", // [201]
  "", // [202]
  "", // [203]
  "", // [204]
  "", // [205]
  "", // [206]
  "", // [207]
  "", // [208]
  "", // [209]
  "", // [210]
  "", // [211]
  "", // [212]
  "", // [213]
  "", // [214]
  "", // [215]
  "", // [216]
  "", // [217]
  "", // [218]
  "OPEN_BRACKET", // [219]
  "BACK_SLASH", // [220]
  "CLOSE_BRACKET", // [221]
  "QUOTE", // [222]
  "", // [223]
  "META", // [224]
  "ALTGR", // [225]
  "", // [226]
  "WIN_ICO_HELP", // [227]
  "WIN_ICO_00", // [228]
  "", // [229]
  "WIN_ICO_CLEAR", // [230]
  "", // [231]
  "", // [232]
  "WIN_OEM_RESET", // [233]
  "WIN_OEM_JUMP", // [234]
  "WIN_OEM_PA1", // [235]
  "WIN_OEM_PA2", // [236]
  "WIN_OEM_PA3", // [237]
  "WIN_OEM_WSCTRL", // [238]
  "WIN_OEM_CUSEL", // [239]
  "WIN_OEM_ATTN", // [240]
  "WIN_OEM_FINISH", // [241]
  "WIN_OEM_COPY", // [242]
  "WIN_OEM_AUTO", // [243]
  "WIN_OEM_ENLW", // [244]
  "WIN_OEM_BACKTAB", // [245]
  "ATTN", // [246]
  "CRSEL", // [247]
  "EXSEL", // [248]
  "EREOF", // [249]
  "PLAY", // [250]
  "ZOOM", // [251]
  "", // [252]
  "PA1", // [253]
  "WIN_OEM_CLEAR", // [254]
  "" // [255]
];

var BioC = function(id, options) {
  this.initPaneWidthHeight();
  var self = this;
  options = _.extend({
    isReadOnly: false,
    root: '/'
  }, options);
  if (options.root.slice(-1) != "/") {
    options.root = options.root + "/";
  }
  this.svg = SVG('drawing');
  this.projectId = options.projectId;
  this.assignId = options.assignId;
  this.isManager = options.isManager || false;
  this.writable = (options.writable.length == 0);
  this.writableReason = options.writable;
  this.me = options.me;
  this.endpoints = options.endpoints;
  this.annotations = options.annotations;
  this.relations = options.relations;
  this.templates = options.templates;
  this.entityTypes = options.entityTypes;
  this.relationTypes = options.relationTypes;
  this.roundState = options.roundState;
  this.id = id;
  this.disabledUsers = [];
  this.url = options.root + "documents/" + id;
  this.conceptNameCache = options.conceptNameCache;
  this.annotatorManager = new AnnotatorManager(this.annotations, this.me);
  this.annotationModal = new AnnotationModal(this);
  this.relationModal = new RelationModal(this);
  this.conceptNameCache.initFetch(self.annotations);
  if (!this.isManager) {
    this.annotatorManager.anonymize(this.annotations);
  }
  $('#typeTab .item').tab({
    onVisible: function() {
      $("#drawing").toggle($(this).data('tab') == 'relations');
    }
  });
  if (this.writable) {
    $('#lockedIndicator').hide();
  } 

  $("#addRelationButton").click(function() {
    self.addNodeToRelation([], {force: true});
  });

  this.renderAnnotatorChecker();
  this.renderEntityRelationTypeCSS();
  this.renderAllPassages();
  this.renderAnnotationTable();
  this.renderRelationTable();
  this.initModal();
  $(".refresh-annotation-table").click(function(e) {
    e.stopPropagation();
    $(".refresh-annotation-table").addClass('loading');
    self.renderAnnotationTable();
    return false;
  });

  $(".refresh-relation-table").click(function(e) {
    e.stopPropagation();
    $(".refresh-relation-table").addClass('loading');
    self.renderRelationTable();
    return false;
  });

  $(window).on('resize', function() {
    this.initPaneWidthHeight();
  }.bind(this));
  this.initOutlineScroll();

  self.bindAnnotationSpan(); 
  if (!self.writable) {
    $(".action-button").prop('disabled', true).addClass("disabled");
  }
  $(".add-new-entity").click(self.addNewEntity.bind(self));
  $(".add-new-relation-type").click(self.addNewRelationType.bind(self));
  $("#defaultTypeSelector select").val($("#defaultTypeSelector option:first").val());
  $("#defaultTypeSelector select").change(function(e) {
    var selected = $("#defaultTypeSelector select option:selected");
    console.log(selected);
    if (selected.hasClass('type')) {
      localStorage && localStorage.setItem('defaultType_' + options.projectId, selected.text());
    }
    if (selected.hasClass("new")) {
      self.addNewEntity();
    }
  });
  $("#defaultRTypeSelector select").change(function(e) {
    var selected = $("#defaultRTypeSelector select option:selected");
    console.log(selected);
    if (selected.hasClass('type')) {
      localStorage && localStorage.setItem('defaultRType_' + options.projectId, selected.text());
    }
    if (selected.hasClass("new")) {
      self.addNewRelationType();
    }
  });
  console.log('defaultType_' + options.projectId);
  var defaultType = localStorage && localStorage.getItem('defaultType_' + options.projectId);
  if (defaultType) {
    var types = $.map($("#defaultTypeSelector select option.type"), function(item) {return $(item).text();});
    if (types.includes(defaultType)) {
      $("#defaultTypeSelector select").val(defaultType);  
    } else {
      localStorage && localStorage.removeItem('defaultType_' + options.projectId);
      $("#defaultTypeSelector select").val($("#defaultTypeSelector option:first").val());
    }
  }
  var defaultRType = localStorage && localStorage.getItem('defaultRType_' + options.projectId);
  if (defaultRType) {
    var types = $.map($("#defaultRTypeSelector select option.type"), function(item) {return $(item).text();});
    if (types.includes(defaultRType)) {
      $("#defaultRTypeSelector select").val(defaultRType);  
    } else {
      localStorage && localStorage.removeItem('defaultRType_' + options.projectId);
      $("#defaultRTypeSelector select").val($("#defaultRTypeSelector option:first").val());
    }
  }
  $("#documentSpinner").removeClass("active");
  this.restoreScrollTop();
  //====================================================
  $(window).scroll(_.debounce(self.storeScrollTop, 100));
  
  $("#annotationTableUpButton").click(function() {
    $('.right-side.pane').animate({scrollTop: 0},
       500, 
       "easeOutQuint"
    );
  });
  $("#annotationTableDownButton").click(function() {
    var height = ($('#typeTab .item.active').data('tab') == 'annotations') ?
          $('#annotationTable').height() : $('#relationTable').height();
    
    $('.right-side.pane').animate({scrollTop: height},
       500, 
       "easeOutQuint"
    );
  });

  $(".concept-id-head").click(function(e) {
    var $e = $(e.currentTarget);
    $e.closest('table').toggleClass('show-concept-name');
  });

  $("#hideAnnotatorButton").click(function() {
    self.disabledUsers = [];
    self.annotatorManager.anonymize(self.annotations);
    self.renderAnnotatorChecker();
    self.renderAllPassages();
  });

  $("#showAnnotatorButton").click(function() {
    self.disabledUsers = [];
    self.annotatorManager.deAnonymize(self.annotations);
    self.renderAnnotatorChecker();
    self.renderAllPassages();
  });
};

BioC.prototype.renderAnnotatorChecker = function() {
  var self = this;
  self.annotatorManager.renderAnnotatorChecker();
  $('#annotatorCheckerList .user-row').click(function(e) {
    $(this).toggleClass('annotation-hide');
    self.disabledUsers = _.map($('.user-row.annotation-hide'), function(e) {
      return $(e).text();
    });
    self.renderAllPassages();
  });
};

BioC.prototype.addNewEntity = function() {
  var self = this;
  if (!self.isManager) {
    return toastr.error("Only the manager can add new entity");
  }
  var $s = $("#defaultTypeSelector select");
  var name = prompt("Enter a new entity type (only alphanumeric characters and '_' are allowed)");
  if (!name) {
    $s[0].selectedIndex =0;
    return;
  }
  name = name.trim().replace(/ /g,"_").replace(/[ !@#$%^&*() +\-=\[\]{};':"\\|,.<>\/?]/gi, '');
  if (!name) {
    toastr.error("Invalid entity type (only alphanumeric characters and '_' are allowed)")
    $s[0].selectedIndex =0;
    return;
  }
  var same = _.filter($("#annotationModal select option"), function(e) {
    return $(e).text() == name
  });

  if (same.length === 0) {
    var $option = $("<option class='type'></option>").text(name).attr("value", name);
    $s.prepend($option);
    $s.val(name);
    $s.find("option.nothing").remove();
    $s.change();

    $.ajax({
      url: $s.data('url'),
      method: "POST",
      data: {entity_type: {name: name}}, 
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      success: function(data) {
        self.entityTypes[data.name] = {prefix: data.prefix, color: data.color}
        self.renderEntityRelationTypeCSS();
        $option = $("<option></option>").text(name).attr("value", name)
        $("#annotationModal select[name='type']").append($option);
        setTimeout(function(){
          $("#annotationModal select[name='type']").dropdown("set selected", name);
        }, 100);
      }, 
      error: function(err) {
        console.error(err);
        toastr.error(err.responseText || err); 
        $s[0].selectedIndex =0;
      }
    });
    
  } else {
    $s.val($(same[0]).val());
  }
};

BioC.prototype.addNewRelationType = function() {
  var self = this;
  if (!self.isManager) {
    return toastr.error("Only the manager can add new entity");
  }
  var $s = $("#defaultRTypeSelector select");
  var name = prompt("Enter a new relation type (only alphanumeric characters and '_' are allowed)");
  if (!name) {
    $s[0].selectedIndex =0;
    return;
  }
  name = name.trim().replace(/ /g,"_").replace(/[ !@#$%^&*() +\-=\[\]{};':"\\|,.<>\/?]/gi, '');
  if (!name) {
    toastr.error("Invalid relation type (only alphanumeric characters and '_' are allowed)")
    $s[0].selectedIndex =0;
    return;
  }
  var same = _.filter($("#relationModal select option"), function(e) {
    return $(e).text() == name
  });

  if (same.length === 0) {
    var $option = $("<option class='type'></option>").text(name).attr("value", name);
    $s.prepend($option);
    $s.val(name);
    $s.find("option.nothing").remove();
    $s.change();

    $.ajax({
      url: $s.data('url'),
      method: "POST",
      data: {relation_type: {name: name, num_nodes: 10}}, 
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      success: function(data) {
        self.relationTypes[data.name] = {num: data.num_nodes, color: data.color, entity: []}
        self.renderEntityRelationTypeCSS();
        $option = $("<option></option>").text(name).attr("value", name)
        $("#relationModal select[name='type']").append($option);
        setTimeout(function(){
          $("#relationModal select[name='type']").dropdown("set selected", name);
        }, 100);
      }, 
      error: function(err) {
        console.error(err);
        toastr.error(err.responseText || err); 
        $s[0].selectedIndex =0;
      }
    });
  } else {
    $s.val($(same[0]).val());
  }
};

// annotation changes =======================================================================
BioC.prototype.bindAnnotationSpan = function() {
  var self = this;

  var actualSpan;
  var nextSpan;
  var nextChild;
  var passageId;
  var par;
  var control = 0;
  var start = 0;
  var end = 1;
  var startWord = 0;
  var endWord = 0;
  var startSpan;
  var endSpan;
  var range = document.createRange();
  var arrayOfSpans = new Array();
  var shortcuts = {
    'next-word': 68,
    'previous-word': 65,
    'jump-next': 83,
    'jump-previous': 87,
    'next-char': 69,
    'previous-char': 81,
    'add-annot': 32,
    'create-annot': 67,
    'delete-annot': 82,
    'plus-ten': 17
  }

  wordsOffSets = function (text) {
    let s = 0;
    let e = 1;
    let i;
    let arrayOfOffsets = new Array();

    for (i = 0; i <= text.length; i++) {
      if ((text[i] === ' ') || (text[i] === '\n') || (i === text.length-1)) {
        e = i;
        arrayOfOffsets.push([s, e+1]);
        i++;
        s = i;
      }
    }
    return arrayOfOffsets;
  }

  spansWords = function () {
    spans = par.find('.passage-text span')
    arrayOfSpans = new Array();
    spans.each(function ( index ) {
      arrayOfSpans.push({span: $(this).get(0), words: wordsOffSets($(this).text())})
    });
    console.log(arrayOfSpans);
  }

  findActualWord = function () {
    for (let i = 0; i < arrayOfOffsets.length; i++) {
      if (end >= arrayOfOffsets[i][0] && end <= arrayOfOffsets[i][1]) {
        word = 0;
        if (i != 0) {
          word = i - 1
        }
        break;
      }
    }
  } 
  
  resetPointers = function(prev) {
    startSpan = 0
    endSpan = 0
    startWord = 0
    endWord = 0
    if (prev) {
      startSpan = arrayOfSpans.length-1
      endSpan = arrayOfSpans.length-1
      startWord = arrayOfSpans[startSpan].words.length-1
      endWord = startWord
    }
  }

  assignSpans = function () {
    actualSpan = arrayOfSpans[startSpan].span;
    nextChild = arrayOfSpans[endSpan].span;
  }

  nextWord = function (amount, hold) {
    endWord += 1
    if (endWord >= arrayOfSpans[endSpan].words.length && endSpan >= arrayOfSpans.length-1) {
      resetPointers(false);
    }
    if (endWord >= arrayOfSpans[endSpan].words.length) {
      endWord = 0;
      endSpan += 1;
    }
    if (!hold) {
      startWord = endWord;
      startSpan = endSpan;
    }
    assignSpans()
    start = arrayOfSpans[startSpan].words[startWord][0];
    end = arrayOfSpans[endSpan].words[endWord][1];
  }

  nextJump = function (hold) {
    if (arrayOfSpans.length <= 1) {
    } else {
      console.log("startWord: " + startWord);
      console.log("endWord: " + endWord);
      console.log("startSpan: " + startSpan);
      console.log("endSpan: " + endSpan);
      if ((endWord + 5) >= arrayOfSpans[endSpan].words.length) {
        if (endSpan+1 < arrayOfSpans.length) {
          endSpan+=1;
          if (!hold) {
            startSpan = endSpan;
          }
          startWord = 0;
          endWord = 0;
        }
      } else {
        endWord += 5
      }
      if (!hold) {
        startWord = endWord;
      }
    }
    assignSpans();
    start = arrayOfSpans[startSpan].words[startWord][0];
    end = arrayOfSpans[endSpan].words[endWord][1];
  }

  previousJump = function (hold) {
    console.log("startWord: " + startWord);
    console.log("endWord: " + endWord);
    console.log("startSpan: " + startSpan);
    console.log("endSpan: " + endSpan);
    if (arrayOfSpans.length <= 1) {
    } else {
      if ((endWord - 5) < 0) {
        if (endSpan-1 > 0) {
          endSpan-=1;
          endWord = arrayOfSpans[endSpan].words.length-1;
          if (!hold) {
            startSpan = endSpan;
            startWord = endWord;
          }
        }
      } else {
        endWord -= 5
      }
      if (!hold) {
        startWord = endWord;
      }
    }
    assignSpans();
    start = arrayOfSpans[startSpan].words[startWord][0];
    end = arrayOfSpans[endSpan].words[endWord][1];
  }

  previousWord = function (amount, hold) {
    endWord -= 1
    if (!hold) {
      startWord -= 1;
    }
    if (endWord < 0) {
      if (endSpan >= 0) {
        endSpan -= 1
        if (endSpan < 0) {
          resetPointers(true)
        }
        endWord = arrayOfSpans[endSpan].words.length-1
      }

      if (!hold) {
        startSpan -= 1;
        startWord = arrayOfSpans[startSpan].words.length-1;
      }
    }
    assignSpans()
    start = arrayOfSpans[startSpan].words[startWord][0];
    end = arrayOfSpans[endSpan].words[endWord][1];
  }

  nextChar = function (hold) {
    end += 1;
    if (!hold) {
      start = end - 1;
      startSpan = endSpan
    }
    if (end >= arrayOfSpans[endSpan].words[arrayOfSpans[endSpan].words.length-1][1]) {
      end = 0;
      endSpan += 1
      endWord = 0
    }
    assignSpans()

    // findActualWord()
  }
  
  previousChar = function (hold) {
    end -= 1;
    if (end < 0) {
      endSpan -= 1
      end = arrayOfSpans[endSpan].words[arrayOfSpans[endSpan].words.length-1][1];
      endWord = arrayOfSpans[endSpan].words[arrayOfSpans[endSpan].words.length-1][1]
    }
    if (!hold) {
      start = end - 1;
      startSpan = endSpan
    }
    assignSpans()
  }

  setRangeSelection = function () {
    range.setStart(actualSpan.firstChild, start);
    if (nextChild === null) {
      nextChild = actualSpan;
    }
    range.setEnd(nextChild.firstChild, end);
    document.getSelection().removeAllRanges();
    document.getSelection().addRange(range);
  }

  swapIf = function () {
    if (start > end) {
      let aux = start
      start = end
      end = aux
    }
  }
  var optionValues = [];
  var createEntityShorcuts = function() {
    optionValues = [];
    $('#defaultTypeSelector select > option').each(function(index) {
      optionValues.push($(this).val());
      if (index < $('#defaultTypeSelector select > option').length-2) {
        $('[id^=entity-helper]').append('<li>'+ index + ' - ' + $(this).text() + '</li>')
      }
    });
  }
  createEntityShorcuts();
  $(".passage").click(function () {
    passageId = $(this).data('id');
    par = $(this);
    actualSpan = par.find('.passage-text span').first().get(0);
    nextChild = actualSpan
    spansWords()
    start = arrayOfSpans[0].words[0][0]; end = arrayOfSpans[0].words[0][1]
    startSpan = 0;
    endWord = 0;
    startWord = 0;
    endSpan = 0;
    setRangeSelection()
  });

  $(document).keydown(function(e) {
    console.log('Keydown: ' + e.key)
    if ($(e.target).is('input, textarea, select')) {
      return true;
    }
    if ((e.which >= 48) && (e.which <= 57)) {
      let norm = ((e.which - 48))
      norm += control;
      $("#defaultTypeSelector select").val(optionValues[norm]).change()
    }
    switch(e.which) {
      case shortcuts['plus-ten']:
        if (control+10 > optionValues.length) {
          control = 0;
          $('[id^=plus-ten]').text('Control plus: ' + control);
        } else {
          control += 10;
          $('[id^=plus-ten]').text('Control plus: ' + control);
        }
        $('[id^=entity-helper] > li').each(function (index) {
          if (index >= control && index < control+10) {
            $(this).wrapInner("<b></b>");
          } else {
            let li_cont = $(this).html()
            $(this).html(li_cont.replace("<b>", "").replace("</b>", ""))
          }
        })
        break;
      case shortcuts['next-word']:
        nextWord(1, e.shiftKey);
        break;
      case shortcuts['previous-word']:
        previousWord(1, e.shiftKey);
        break;
      case shortcuts['jump-next']:
        nextJump(e.shiftKey)
        break;
      case shortcuts['jump-previous']:
        previousJump(e.shiftKey);
        break;
      case shortcuts['next-char']:
        nextChar(e.shiftKey);
        break;
      case shortcuts['previous-char']:
        previousChar(e.shiftKey);
        break;
      case shortcuts['create-annot']:
        $("#defaultTypeSelector select").val(optionValues[optionValues.length-1]).change()
        $('[id^=entity-helper] li').remove()
        createEntityShorcuts();
        break;
      case shortcuts['delete-annot']:
        var selection = getSelected();
        if (selection && selection.rangeCount > 0) {
          var range = selection.getRangeAt(0);

          var result = self.findAnnotationRange(range);
          if (result.error) {
            toastr.error("You cannot work with multiple paragraphs. Please select a span in a paragraph.");
            clearSelection();
            return;
          }
          var annotations = _.filter(self.annotations, function(a) {
            return result.annotations.includes(a.id); 
          });
          var annotationsIds = $.map(annotations, function(annot) {
            return annot.annotation_id
          })
          self.deleteCheckedAnnotation(annotationsIds);
        } else {
          console.log('Nothing to Delete')
        }
        break;
      case shortcuts['add-annot']:
        e.preventDefault();
        var selection = getSelected();
        if (selection && selection.rangeCount > 0) {
          var range = selection.getRangeAt(0);

          var result = self.findAnnotationRange(range);
          if (result.error) {
            toastr.error("You cannot work with multiple paragraphs. Please select a span in a paragraph.");
            clearSelection();
            return;
          }

          var length = range.endOffset - range.startOffset;
          var text = result.text.trim();
          var offset = result.offset + result.text.indexOf(text);
          if (result.annotations.length == 0 && length > 0 && text.length > 0) {
            if (result.text.length != length) {
              console.log("Something wrong " + length + " !=" + result.text.length);
              clearSelection();
              return;
            }
            // recommends = getRecommendText(range);
            // var elemOffset = parseInt($(range.startContainer.parentElement).data('offset'), 10);
            // var offset = elemOffset + range.startOffset;
            
            if (self.writable) {
              self.addNewAnnotation(text, offset, passageId);
            } else {
              clearSelection();
            }   
            // self.showLocationSelector(recommends, range);
          } else if (result.annotations.length > 0) {
            
            if (result.annotations.length == 1 && result.text.length == 0) {

            } else if (result.annotations.length > 0) {
              self.showAnnotationListModal(result.annotations, result.offset, result.text, passageId);
            }
            clearSelection();
          } else {
            console.log("????", length);
            clearSelection();
          }
        }
        startSpan = endSpan;
        endWord = startWord;
        start = arrayOfSpans[startSpan].words[arrayOfSpans[startSpan].words.length-1][0];
        end = arrayOfSpans[endSpan].words[arrayOfSpans[endSpan].words.length-1][1];
        break;
      default:
        break;
    }
    console.log('Passei aqui')
    spansWords()
    assignSpans()
    setRangeSelection();
  });

  $("p[id^='p-']").each(function() {
    // console.log(this)
    this.innerHTML = keyboardMap[shortcuts[this.id.substring(2)]]
  })

  $("button[id^='shc']").click(function() {
    var pId = 'p-' + this.id.substring(4)
    $('#key-modal').modal('show')
    $('#key-modal').focus()
    $('#key-modal').on('click')
    $('#key-modal').keydown(function(e) {
      console.log("p[id^=" + pId + "]")
      $("#"+pId).html(keyboardMap[e.which])
      shortcuts[pId.substring(2)] = e.which
      console.log("Code:" + e.which)
      $('#key-modal').off()
      $('#key-modal').modal('hide')
    })
  });

  $(".passage").mouseup(function (e) {   
    var passageId = $(this).data('id');
    var selection = getSelected();
    if (selection && selection.rangeCount > 0) {
      var range = selection.getRangeAt(0);

      var result = self.findAnnotationRange(range);
      if (result.error) {
        toastr.error("You cannot work with multiple paragraphs. Please select a span in a paragraph.");
        clearSelection();
        return;
      }

      var length = range.endOffset - range.startOffset;
      var text = result.text.trim();
      var offset = result.offset + result.text.indexOf(text);
      if (result.annotations.length == 0 && length > 0 && text.length > 0) {
        if (result.text.length != length) {
          console.log("Something wrong " + length + " !=" + result.text.length);
          clearSelection();
          return;
        }
        // recommends = getRecommendText(range);
        // var elemOffset = parseInt($(range.startContainer.parentElement).data('offset'), 10);
        // var offset = elemOffset + range.startOffset;
        
        if (self.writable) {
          self.addNewAnnotation(text, offset, passageId);
        } else {
          clearSelection();
        }   
        // self.showLocationSelector(recommends, range);
      } else if (result.annotations.length > 0) {
        
        if (result.annotations.length == 1 && result.text.length == 0) {

        } else if (result.annotations.length > 0) {
          self.showAnnotationListModal(result.annotations, result.offset, result.text, passageId);
        }
        clearSelection();
      } else {
        console.log("????", length);
        clearSelection();
      }
    }
  });
};
// End annotation changes ========================================================================

BioC.prototype.annotationUrl = function(id) {
  if (id) {
    return this.endpoints.annotations + "/" + id + ".json"    
  } else {
    return this.endpoints.annotations + ".json"
  }
};

BioC.prototype.relationUrl = function(id) {
  if (id) {
    return this.endpoints.relations + "/" + id + ".json"    
  } else {
    return this.endpoints.relations + ".json"
  }
};

BioC.prototype.addNewAnnotation = function(text, offset, passageId) {
  var self = this;
  var type = $("#defaultTypeSelector option:selected").text();
  if (!type) {
    self.addNewEntity();
    type = $("#defaultTypeSelector option:selected").text();
    if (!type) {
      toastr.error("Cannot save an annotation without assigning an entity type");
      return;
    }
  }
  $(".document-loader").addClass("active");
  if (text.trim().length == 0) {
    console.log("????", length);
    clearSelection();
    return;
  }
  $.ajax({
    url: self.annotationUrl(),
    method: "POST",
    data: {text: text, offset: offset, type: type, passage_id: passageId}, 
    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
    success: function(data) {
      console.log(data);
      if (data.annotation) {
        self.annotations.push(data.annotation);
        $("#annotationList").prepend(self.templates.view1(_.assign({
          size: 1, iconClass: 'search', 
          review_state: self.getReviewState(data.annotation.review_result),
          conceptName: self.conceptNameCache.get(data.annotation.concept),
          conceptId: self.conceptNameCache.escape(data.annotation.concept),
        }, data.annotation)));
        self.renderPassage(data.annotation.passage);
        $("#annotationList tr:first-child").addClass("new");
        self.bindAnnotationTr();
        // $("#annotationList .annotation-tr:first-child .concept").click();
      } else {
        toastr.error("Unable to create an annotation. Maybe texts are located in sentences."); 
      }
    },
    error: function(xhr, status, err) {
      $(".document-loader").removeClass("active");
      toastr.error(xhr.responseText || err);                    
    },
    complete: function() {
      $(".document-loader").removeClass("active");
    }
  });
};

BioC.prototype.findAnnotationRange = function(range) {
  var annotations = [];
  var ids;
  var wholeText = "";
  var $start = $(range.startContainer.parentElement || range.startContainer.parentNode);
  var $end = $(range.endContainer.parentElement || range.endContainer.parentNode);
  var startP = range.startContainer.parentElement || range.startContainer.parentNode;
  var endP = range.endContainer.parentElement || range.endContainer.parentNode;
  var startPassage = startP.parentElement || startP.parentNode;
  var endPassage = endP.parentElement || endP.parentNode;
  
  if (startPassage != endPassage) {
    return {error: 'Different Passage!'};
  }
  
  var elemOffset = parseInt($start.data('offset'), 10);
  var offset = elemOffset + range.startOffset;

  var $p = $start;
  var startOffset, endOffset;
  var text;
  while($p.data('offset') <= $end.data('offset')) {
    text = $p.text();
    startOffset = 0;
    endOffset = text.length;
    if ($p.data('offset') == $start.data('offset')) {
      startOffset = range.startOffset;
    }
    if ($p.data('offset') == $end.data('offset')) {
      endOffset = range.endOffset;
    }
    text = text.substr(startOffset, endOffset - startOffset);
    wholeText += text;

    if ($p.hasClass('annotation')) {
      ids = $p.data('ids');
      if (ids.split) {
        ids = ids.split(" ");
      } else {
        ids = [ids];
      }
      _.each(ids, function(id) {
        annotations.push("" + id);
      });
    }
    $p = $p.next();
  }
  annotations = _.uniq(annotations).sort();
  return {
    offset: offset,
    text: wholeText,
    annotations: annotations,
  };
};

BioC.prototype.updateAnnotationListModal = function(annotationIds) {
  var self = this;

  if (!annotationIds) {
    var ids = $("#annotationListModal .content").data('ids');
    if (ids && ids.split) {
      annotationIds = ids.split(' ');
    }
  } else {
    $("#annotationListModal .content").data('ids', annotationIds.join(" "));
  }

  if (!annotationIds) {
    return;
  }

  var annotations = _.filter(self.annotations, function(a) {
    return annotationIds.includes(a.id); 
  });
  annotations.sort(function(a, b) {
    return a.offset - b.offset;
  });
  $("#annotationListModal .annotationListCount").text(annotations.length);

  var bodyHtml = _.map(annotations, function(a) {
    var item = $.extend({}, a);
    if (self.isValidTimestamp(a.updated_at)) {
      item.updated_at = moment(a.updated_at).local().format("LLL");
      item.yymmdd = moment(a.updated_at).local().format('YYYY-MM-DD');
    }
    item.iconClass = (a.note) ?'comment': 'search';
    return self.templates.annotationList(item);
  });
  $("#annotationListModal .annotationListTableBody").html(bodyHtml.join("\n"));
  if (self.writable) {
    $("#annotationListModal .annotation-tr .concept").unbind("click").click(self.clickConcept.bind(self));
    $("#annotationListModal .annotation-tr .type-text").unbind("click").click(self.clickEntityType.bind(self));
  }
  $("#annotationListModal .annotation-tr .icon.show-popup").unbind("click").click(function(e) {
    var $e = $(e.currentTarget);
    self.clickAnnotation($e.closest("tr"), {event: e, force: true});
  });

  $("#annotationListModal").find(".need-popup2").unbind('mouseover').mouseover(function(e) {
    var $tr = $(e.currentTarget).closest('tr');
    var id = $tr.data('id');
    var pos = $(e.currentTarget).offset();
    var a = self.annotations.find(function(e) { return e.id == id;});
    if (a) {
      var name = self.conceptNameCache.get(a.concept);
      if (name == a.concept) {
        name = "";
      }
      $("#conceptPopup table").html(self.templates.popup({id: a.concept, name: name}));
      $("#conceptPopup").show().css({top: (pos.top + 22) + "px", left: pos.left + "px"});   
    }
  });
  $("#annotationListModal").find(".need-popup2").unbind('mouseout').mouseout(function(e) {
    $("#conceptPopup").hide();
  });
};

BioC.prototype.showAnnotationListModal = function(annotationIds, offset, text, passageId) {
  var self = this;
  var titleHelp = "Offset [" + offset + ":" + (offset + text.length) + "] (length: " + text.length + ")";
  var titleText = "<span class='annotation-text-span need-popup-title' data-position='bottom left' data-content='" + titleHelp + "'>" + text + "</span>";
  if (text.length > 0) {
    $("#annotationListModal .header").html(titleText);
  } else {
    $("#annotationListModal .header").html("");
  }  
  $("#annotationListModal input[type='checkbox']").prop('checked', false);
  $("#annotationListModal thead input[type='checkbox']").change(function(e) {
    var val = $(e.currentTarget).is(':checked');
    $("#annotationListModal input[type='checkbox']").prop('checked', val);
  });
  $("#annotationListModal .ui.button.create-new").toggleClass('disabled', (text.length <= 0 || !self.writable));
  self.updateAnnotationListModal(annotationIds);
  $("#annotationListModal .add-relation-button").unbind('click').click(function() {
    var $checked = $("#annotationListModal .annotationListTableBody input[type='checkbox']:checked");
    if ($checked.length == 0) {
      alert('Please select annotations which you want add.');
      return false;
    }
    if (confirm("Are you sure to add " + $checked.length + " annotation(s)?")) {
      var ids = _.map($checked, function(item) {
        var $tr = $(item).closest('tr');
        return "" + $tr.data('id');
      });
      self.addNodeToRelation(ids)
      $('#typeTab .item').tab('change tab', 'relations');
      $("#annotationListModal").modal('hide');
    }
    return false;
  });

  $("#annotationListModal").modal({
    allowMultiple: true,
    onApprove: function($e) {
      if ($e.hasClass('create-new')) {
        self.addNewAnnotation(text, offset, passageId);      
      }
    },
    onDeny: function($e) {
      if ($e.hasClass('delete-checked')) {
        var $checked = $("#annotationListModal .annotationListTableBody input[type='checkbox']:checked");
        if ($checked.length == 0) {
          alert('Please select annotations which you want delete.');
          return false;
        }
        if (confirm("Are you sure to delete " + $checked.length + " annotation(s)?")) {
          var ids = _.map($checked, function(item) {
            var $tr = $(item).closest('tr');
            return $tr.data('annotation_id');
          });
          self.deleteCheckedAnnotation(ids)
        }
        return false;
      }
    }
  }).modal('show');
  $('.need-popup-title').popup();
//   $("#annotationListModal thead input[type='checkbox']").blur();
//   $("#annotationListModal input[type='text']:first").focus();
//   setTimeout(function() {
//     console.log("blue-------------");
//     $("#annotationListModal thead input[type='checkbox']").blur();
//     $("#annotationListModal input[type='text']:first").focus();
//   }, 400);
};

BioC.prototype.refreshViewAfterDelete = function(ids) {
  var self = this;
  ids = _.map(ids, function(id) {return parseInt(id, 10);});
  var selected = _.filter(self.annotations, function(a) {
    return ids.includes(a.annotation_id);
  });
  var passageIds = _.uniq(_.map(selected, function(e) {return e.passage;}));
  self.annotations = _.filter(self.annotations, function(a) {
    return !ids.includes(a.annotation_id);
  });
  _.each(passageIds, function(id) {
    self.renderPassage(id);
  });
};

BioC.prototype.refreshViewUpdate = function(data) {
  var self = this;
  var found = [];
  self.annotations = _.map(self.annotations, function(a) {
    var newOne = _.find(data, function(e) {
      return e.annotation_id == a.annotation_id;
    });
    if (newOne) {
      found.push(newOne.annotation_id);
    }
    return newOne || a;
  });
  _.each(data, function(e) {
    if (!found.includes(e.annotation_id)) {
      self.annotations.push(e);
    }
  });

  var passageIds = _.uniq(_.map(data, function(a) {return a.passage;}));
  _.each(passageIds, function(id) {self.renderPassage(id);});
};

BioC.prototype.deleteCheckedAnnotation = function(ids) {
  var self = this;
  $.ajax({
    url: self.annotationUrl(ids[0]),
    method: "DELETE",
    async: false,
    data: {
      deleteMode: 'batch', 
      ids: ids, 
    }, 
    success: function(data) {
      self.refreshViewAfterDelete(data);
      self.refreshAnnotationListModal()
      toastr.success("Successfully deleted.");              
    },
    error: function(xhr, status, err) {
      toastr.error(xhr.responseText || err);              
    },
  });
};

BioC.prototype.getReviewState = function(state) {
  var self = this;
  if (!self.isManager && (self.roundState == 'reviewing' || self.roundState == 'annotating')) {
    return "review-" + state;
  }
  if (self.isManager) {
    return "review-" + state;    
  }
  return "";
};

BioC.prototype.hasEnabledAnnotators = function(annotators) {
  var needHide = true;
  var emails = annotators.split(",");
  for(var j = 0; j < emails.length; j++) {
    if (!this.disabledUsers.includes(emails[j])) {
      needHide = false;
    }
  }
  return !needHide;
};
function getOffsetHashKey(a) {
  var t;
  if (a.concept && a.concept.trim().length > 0) {
    t = [a.type, a.concept].join("|");
  } else {
    t = [a.type, a.text].join("|");
  }
  return t;  
}

BioC.prototype.renderAnnotationTable = function() {
  var self = this;
  var offsetHash = {}
  _.each(this.annotations, function(a) {
    offset = offsetHash[getOffsetHashKey(a)];
    if (!offset || offset > a.offset) {
      offsetHash[getOffsetHashKey(a)] = a.offset;
    }
  });
  this.annotations.sort(function(a, b) {
    var aHOffset = offsetHash[getOffsetHashKey(a)];
    var bHOffset = offsetHash[getOffsetHashKey(b)];
    if (aHOffset > bHOffset) {
      return 1;
    }
    if (aHOffset < bHOffset) {
      return -1;
    }
    if (a.review_result && b.review_result) {
      if (a.review_result == 'not_determined' && b.review_result != 'not_determined') {
        return -1;
      }
      if (a.review_result != 'not_determined' && b.review_result == 'not_determined') {
        return 1;
      }
      if (a.review_result == 'disagreed' && b.review_result != 'disagreed') {
        return -1;
      }
      if (a.review_result != 'disagreed' && b.review_result == 'disagreed') {
        return 1;
      }
    }
    
    if (a.type > b.type) {
      return 1;
    } 
    if (a.type < b.type) {
      return -1;
    }
    if (a.concept > b.concept) {
      return 1;
    } 
    if (a.concept < b.concept) {
      return -1;
    } 
    return a.offset - b.offset;
    // return a.text.localeCompare(b.text);
  });
  self.conceptNameCache.init();
  $("#annotationHead").html(self.templates.head);
  var html, text;
  html = [];
  text = [];
  var last = {};
  var concept, type;
  for(var i = 0; i < this.annotations.length; i++) {
    var a = self.annotations[i];
    
    if (!self.hasEnabledAnnotators(a.annotator)) {
      continue;
    }

    if (last.type !== a.type || (last.concept !== a.concept || a.concept.trim().length === 0)) {
      for(var j = 0; j < text.length; j++) {
        if (j == 0) {
          html.push(self.templates.view1({
            id: text[j].id, offset: text[j].offset, text: text[j].text, passage: text[j].passage,
            size: text.length, type: last.type, need_collapse: (text.length > 1) ? 'need-collapse':'',
            review_state:  self.getReviewState(text[j].review_result),
            concept: last.concept,
            conceptId: self.conceptNameCache.escape(last.concept),
            annotation_id: text[j].annotation_id,
            iconClass: (text[j].note ?'comment': 'search')
          }));
        } else {
          html.push(self.templates.view2({
            id: text[j].id, offset: text[j].offset, text: text[j].text, passage: text[j].passage, 
            annotation_id: text[j].annotation_id, top_annotation_id: text[0].annotation_id,
            review_state: self.getReviewState(text[j].review_result),
            iconClass: (text[j].note ?'comment': 'search')
          }));
        }
      }
      last.type = a.type;
      last.concept = a.concept;
      last.text = a.text;
      text = [a];
    } else {
      text.push(a);
      if (last.text !== a.text) {
        last.text = a.text;
      }
    }
  }
  for(var j = 0; j < text.length; j++) {
    if (j == 0) {
      html.push(self.templates.view1({
        id: text[j].id, offset: text[j].offset, text: text[j].text, passage: text[j].passage,
        size: text.length, type: last.type, need_collapse: (text.length > 1) ? 'need-collapse':'',
        concept: last.concept,
        review_state: self.getReviewState(text[j].review_result),
        conceptId: self.conceptNameCache.escape(last.concept),
        annotation_id: text[j].annotation_id,
        iconClass: (text[j].note ?'comment': 'search')
      }));
    } else {
      html.push(self.templates.view2({
        id: text[j].id, offset: text[j].offset, text: text[j].text, passage: text[j].passage, 
        annotation_id: text[j].annotation_id, top_annotation_id: text[0].annotation_id,
        review_state: self.getReviewState(text[j].review_result),
        iconClass: (text[j].note ?'comment': 'search')
      }));
    }
  }
  $("#annotationList").html(html.join("\n"));
  self.bindAnnotationTr();
  self.conceptNameCache.fetchAll();
  // $(".need-popup").popup();

  $('.annotation-tr .collapse-btn .plus.icon').click(function(e) {
    var $tr = $($(e.currentTarget).closest('tr'));
    var id = $tr.data('annotation_id');
    var size = $tr.data('size');
    $tr.removeClass("collapsed");
    $(".annotation-tr[data-top_annotation_id='" + id + "']").show();
    $tr.find("td.type").attr("rowspan", size);
    $tr.find("td.concept").attr("rowspan", size);
  });

  $('.annotation-tr .collapse-btn .minus.icon').click(function(e) {
    var $tr = $($(e.currentTarget).closest('tr'));
    var id = $tr.data('annotation_id');
    $tr.addClass("collapsed");
    $(".annotation-tr[data-top_annotation_id='" + id + "']").hide();
    $tr.find("td.type").attr("rowspan", 1);
    $tr.find("td.concept").attr("rowspan", 1);
  }).click();
  var issueCount = $("#annotationTable .annotation-tr.review-not_determined, #annotationTable .annotation-tr.review-disagreed").length;
  $("#reviewWarning").text(issueCount).toggle(issueCount > 0);


  $("#annotationList").find(".need-popup2").unbind('mouseover').mouseover(function(e) {
    var $tr = $(e.currentTarget).closest('tr');
    var id = $tr.data('id');
    var pos = $(e.currentTarget).offset();
    var a = self.annotations.find(function(e) { return e.id == id;});
    if (a) {
      var name = self.conceptNameCache.get(a.concept);
      if (name == a.concept) {
        name = "";
      }
      $("#conceptPopup table").html(self.templates.popup({id: a.concept, name: name}));
      $("#conceptPopup").show().css({top: (pos.top + 22) + "px", left: pos.left + "px"});   
    }
  });
  $("#annotationList").find(".need-popup2").unbind('mouseout').mouseout(function(e) {
    $("#conceptPopup").hide();
  });
  $(".refresh-annotation-table").removeClass('loading');
};

fontColor = function(color) {

}

BioC.prototype.renderEntityRelationTypeCSS = function() {
  var self = this;
  var lines1 = _.map(self.entityTypes, function(e, name) {
    return ".A_" + name.toUpperCase() + " { " +
      " background-color: " + e.color + " !important;" +
      " color: #000 !important; }"
  });
  var lines2 = _.map(self.relationTypes, function(e, name) {
    return ".R_" + name.toUpperCase() + " { " +
      " background-color: " + e.color + " !important;" +
      " color: #FFF !important; }"
  });
  $("#document-entity-type-css").html("<style type='text/css'>" + lines1.concat(lines2).join("\n") + "</style>");
};

BioC.prototype.bindAnnotationTr = function() {
  var self = this;
  $("#annotationTable .annotation-tr").unbind("mouseover mouseout")
    .mouseover(function(e) {
      var $e = $(e.currentTarget);
      var cls = ".AL_" + $e.data('id') + '_' + $e.data('offset');
      $(cls).addClass("focused-now");
      // $(cls).css("border-bottom", "4px solid #f44");
    })
    .mouseout(function(e) {
      var $e = $(e.currentTarget);
      var cls = ".AL_" + $e.data('id') + '_' + $e.data('offset');
      $(cls).removeClass("focused-now");
      // $(cls).css("border-bottom", "0");
    });
  $("#annotationTable .annotation-tr .td-annotation-text").unbind('click')
    .click(function(e) {
      var $e = $(e.currentTarget).parent();
      $("#annotationTable .annotation-tr .td-annotation-text").removeClass("selected");
      $(e.currentTarget).addClass("selected");
      if ($e.data('passage') !== undefined) {
        self.scrollToPasssage($e.data('passage'));
      }
    })

  $("#annotationTable .annotation-tr .icon.show-popup").unbind("click").click(function(e) {
    var $e = $(e.currentTarget);
    self.clickAnnotation($e.closest("tr"), {event: e});
  });
  if (self.writable) {
    $("#annotationTable .annotation-tr .concept").unbind("click").click(self.clickConcept.bind(self));
    $("#annotationTable .annotation-tr .type-text").unbind("click").click(self.clickEntityType.bind(self));
  }
  $("#annotationTable").removeClass("selectable");
};

BioC.prototype.clickEntityType = function(e) {
  console.log("click concept");
  this.restoreTR();
  var self = this;
  var $e = $(e.currentTarget);
  var $tr = $e.closest("tr");
  var $td = $tr.find("td.type");
  $td.addClass("editing");
  var oldValue = $td.text().trim();
  $td.data('value', oldValue);
  $td.find(".type-edit").html($("<select/>").html($("#annotationModal select[name='type']").html()));
  $td.find("select").val(oldValue).focus();
  $td.find("select").unbind('change').change(function(e) {
    self.updateEntityType($tr);
  });
  $td.find("select").unbind('blur').blur(function() {
    self.updateEntityType($tr);
  });
};

BioC.prototype.restoreTR = function(e) {
  _.each($("td.type.editing"), function(cell) {
    var $e = $(cell);
    $e.removeClass("editing")
    $e.find(".type-edit").empty();
    $e.find(".type-text").html($e.data("value"));
  });
  $(".annotation-tr").removeClass("editable");
};

BioC.prototype.clickConcept = function(e) {
  console.log("click concept");
  var self = this;
  e.stopPropagation();
  var $e = $(e.currentTarget);
  var $tr = $e.closest("tr");
  var oldValue = $tr.find(".concept-text.for-id").text().trim();
  this.restoreTR();
  $tr.addClass("editable");  
  $tr.find(".concept-edit input").val(oldValue).focus();
  $tr.find(".concept-edit input").unbind('change').change(function() {
    self.updateConcept($tr);
  });
};

BioC.prototype.updateEntityType = function($tr) {
  console.log("UPDATE entity_type")
  var self = this;
  var $td = $tr.find("td.type");
  var newValue = $td.find("select").val();
  var oldValue = $td.data("value");
  var concept = $tr.find(".concept-text.for-id").text().trim();
  var isMention = ($tr.data('mode') == 'mention') || (!concept);
  var annotation_id = $tr.data('annotation_id');

  if (oldValue !== newValue) {
    $tr.find('.type .dimmer').addClass('active');
    $.ajax({
      url: self.annotationUrl(annotation_id),
      method: "PATCH",
      data: {mode: !isMention, concept: concept, type: newValue, no_update_note: true}, 
      success: function(data) {
        self.refreshViewUpdate(data);
        $tr.removeClass("new");
        $td.data('value', newValue);
        self.restoreTR();
        toastr.success("Successfully updated.");              
        self.refreshAnnotationListModal();
      },
      error: function(xhr, status, err) {
        toastr.error(xhr.responseText || err);              
      },
      complete: function() {
        $tr.find('.type .dimmer').removeClass('active');
      }
    });
  } else {
    $tr.removeClass("new");
    self.restoreTR();
  }
};

BioC.prototype.updateRelationType = function($tr) {
  var self = this;
  var $td = $tr.find("td.type");
  var newValue = $td.find("select").val();
  var oldValue = $td.data("value");
  var relation_id = $tr.data('relation_id');

  if (oldValue !== newValue) {
    $tr.find('.type .dimmer').addClass('active');
    $.ajax({
      url: self.relationUrl(relation_id),
      method: "PATCH",
      data: {type: newValue, no_update_note: true}, 
      success: function(data) {
        console.log(data);
        if (data && data.relation) {
          var relation = _.find(self.relations, {relation_id: relation_id});
          relation.type = data.relation.type;
          $tr.removeClass("new");
          $td.data('value', newValue);
          self.restoreRTR();
          toastr.success("Successfully updated.");              
          $td.removeClass("R_" + oldValue).addClass("R_" + newValue);          
        }
      },
      error: function(xhr, status, err) {
        toastr.error(xhr.responseText || err);              
      },
      complete: function() {
        $tr.find('.type .dimmer').removeClass('active');
      }
    });
  } else {
    $tr.removeClass("new");
    self.restoreTR();
  }
};


BioC.prototype.refreshAnnotationListModal = function() {
  if ($("#annotationListModal").is(":visible")) {
    this.updateAnnotationListModal();
    this.renderAnnotationTable();
  }
};
BioC.prototype.reorderConceptIDs = function(ids) {
  var self = this;
  if (ids.indexOf(";") >= 0) {
    ids = _.map(ids.split(';'), function(str) { return self.reorderConceptIDs(str);});
    return _.compact(ids).join(';');
  } else if (ids.indexOf(",") >= 0) {
    ids = _.map(ids.split(','), function(str) { return self.reorderConceptIDs(str);});
    return _.compact(ids).sort(function(a, b) {
      a = "" + a;
      b = "" + b;
      return a.localeCompare(b, "en-US");
    }).join(',');    
  } else {
    return ids.trim();
  } 
}

BioC.prototype.normalizeConceptString = function(str, prefix) {
  var idx = str.indexOf(":");
  var ids = str.substring(idx + 1);
  var type = str.substring(0, idx + 1);

  str = type + this.reorderConceptIDs(ids);
  if (prefix) {
    str = str.replace(/\s/g, '');
    var rePrefix = prefix.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&');
    var re = new RegExp('^' + rePrefix, 'i');
    if (!str.match(re)) {
      str = prefix + str;
    }
    str = str.replace(re, prefix);
  }
  return str;
};

BioC.prototype.updateConcept = function($tr) {
  var self = this;
  var type = $tr.find(".type").text().trim();
  var oldValue = $tr.find(".concept-text.for-id").text().trim();
  var newValue = $tr.find(".concept-edit input").val().trim();
  var isMention = ($tr.data('mode') == 'mention') || (!oldValue);
  var annotation_id = $tr.data('annotation_id');
  console.log("UPDATE concept", oldValue, newValue)
  var entityType = self.entityTypes[type] || {};
  newValue = self.normalizeConceptString(newValue, entityType.prefix);      
  if (oldValue !== newValue && annotation_id) {
    $tr.find('.concept .dimmer').addClass('active');
    $.ajax({
      url: self.annotationUrl(annotation_id),
      method: "PATCH",
      data: {
        mode: !isMention, 
        concept: newValue, 
        type: type, 
        no_update_note: true
      }, 
      success: function(data) {
        console.log(data);
        newValue = data[0].concept;
        self.refreshViewUpdate(data);
        $tr.removeClass("new");
        self.restoreTR();
        $tr.find(".concept-text.for-id").text(newValue)
            .removeClass('for-' + self.conceptNameCache.escape(oldValue))
            .addClass('for-' + self.conceptNameCache.escape(newValue));
        $tr.find(".concept-edit input").val(newValue);
        $tr.find(".concept-text").prop('title', newValue);
        self.conceptNameCache.get(newValue, function(ret, name) {
          $tr.find(".concept-text").prop('title', name);
        });
        toastr.success("Successfully updated.");              
        self.refreshAnnotationListModal();
      },
      error: function(xhr, status, err) {
        console.log(err, status, xhr)
        toastr.error(xhr.responseText || err);                          
      },
      complete: function() {
        $tr.find('.concept .dimmer').removeClass('active');
      }
    });
  } else {
    $tr.removeClass("new");
    self.restoreTR();
  }
};

BioC.prototype.isValidTimestamp = function(time) {
  return (time && moment(time).local().format('YYYY') != '1980')
};

BioC.prototype.getCurrentRightPane = function() {
  return $(".right-side > .tabular.menu .active.item").data('tab');
};

BioC.prototype.clickAnnotation = function(e, option) {
  var self = this;
  var $e = $(e);
  var force = option && option.force;
  if ($("#annotationListModal").is(":visible") && !force) {
    return;
  }
  console.log("Clicked", $e);
  var id = $e.data('id').toString();
  if (!id) {
    console.log("Sorry, No id");
    return;
  }
  if ($e.data('passage') !== undefined) {
    self.scrollToPasssage($e.data('passage'));
  }
  if (self.getCurrentRightPane() == 'relations' && option && option.event && (option.event.metaKey || option.event.ctrlKey)) {
    self.addNodeToRelation(id);
    return;
  }
  self.annotationModal.show(id);
};

BioC.prototype.renderRelationTable = function() {
  var self = this;
  var html = _.map(self.relations, function(relation) {
    if (!self.hasEnabledAnnotators(relation.annotator)) {
      return "";
    }
    self.attachNodeToRelation(relation);
    return self.templates.relationTr(relation);
  });
  self.clearSVG();
  $("#relationList").html(html.join("\n"));
  $(".refresh-relation-table").removeClass('loading');
  self.bindRelationTr();
};

BioC.prototype.bindRelationTr = function() {
  var self = this;
  $("#relationList .relation-tr").unbind('click').click(function(e) {
    if ($(this).hasClass("selected")) {
      return self.clearSVG();
    }
    if (e.metaKey || e.ctrlKey) {
      self.addNodeToRelation($(e.currentTarget).data('id'), {type: 'relation'});
      return;
    }
    self.selectRelation($(e.currentTarget).data('relation_id'));
  });

  $("#relationList .show-popup").unbind('click').click(function(e) {
    var $e = $(e.currentTarget);
    self.relationModal.show($e.closest("tr").data("id"));
  });

  if (self.writable) {
    $("#relationList .relation-tr .type-text").unbind("click").click(self.clickRelationType.bind(self));
  }
};

function inlineOffset($e) {
  var el = $("<i class='icon plus'></i>").insertBefore($e);
  var pos = el.offset();
  el.remove();
  return pos;
}

BioC.prototype.clearSVG = function() {
  $("#drawing > svg").empty();
  $("#relationList .relation-tr.selected").removeClass("selected");
};

BioC.prototype.drawRelation = function(relation, options) {
  var self = this;
  options.visited.push(relation.id);
  var x = 0, y = 0, cnt = 0;
  _.each(relation.nodes, function(n, idx) {
    if (!n.type) {
      self.attachNode(n);
    }
    if (n.type == "A") {
      n.pos = inlineOffset($('.AL_' + n.a.id + '_' + n.a.offset));
      self.svg.circle(20).move(n.pos.left - 10, n.pos.top - 5)
        .fill({color: "#f00", opacity: 0.2})
        .stroke({
            width: 3, color: '#f00', opacity: 0.3,
            dasharray: '4,2'
          }).animate(1000).stroke({dashoffset: 12}).loop();
      self.svg.text(idx + 1 + "").font({
        family: "Lato",
        size: '0.7em', 
        weight: 'bold', 
        anchor: 'middle'
      }).fill({color: '#633'}).move(n.pos.left, n.pos.top);
    } else if (n.type == "R") {
      if (!options.visited.includes(n.r.id)) {
        n.pos = self.drawRelation(n.r, {visited: options.visited});
      } 
    } 
    if (n.pos) {
      x += n.pos.left;
      y += n.pos.top;
      cnt++;
    }
  });
  var pos =  {
    left: x / cnt,
    top: y / cnt - 30
   };
 
  _.each(relation.nodes, function(n) {
    if (n.pos) {
      self.svg.line(pos.left, pos.top, n.pos.left, n.pos.top + 5)
        .stroke({
          width: 4, color: '#f00', opacity: 0.3,
          dasharray: '4,2'
        }).animate(1000).stroke({dashoffset: 12}).loop();
    }
  });

  var nameColor = (options && options.root) ? "#fff" : "#633";
  self.svg.circle(30).move(pos.left - 15 , pos.top - 15).fill({color: "#f00", opacity: 0.3});
  self.svg.text(""+relation.id).font({
    family: "Lato",
    size: '0.8em', 
    weight: 'bold', 
    anchor: 'middle'
  }).fill({color: nameColor}).move(pos.left, pos.top - 7);

  return pos;
};

BioC.prototype.highlightRelation = function(relation) {
  var self = this;
  $("#drawing").height($(".main-container").height() + "px");
  if (typeof(relation) != 'object') {
    relation = _.find(self.relations, {relation_id: relation});
  }

  var pos = self.drawRelation(relation, {root: true, visited: []});
  self.scrollToPos(pos.top);
};

BioC.prototype.attachNode = function(node) {
  var self = this;
  if (node.type && (node.type == "A" || node.type == "R")) {
    return;
  }
  var annotation = _.find(self.annotations, {id: node.ref_id});
  var relation = _.find(self.relations, {id: node.ref_id});
  node.a = annotation || {text: "N/A"};
  node.r = relation
  node.type = (annotation) ? "A" : (relation ? "R" : "N/A");
};

BioC.prototype.attachNodeToRelation = function(relation) {
  _.each(relation.nodes, this.attachNode.bind(this));
};

BioC.prototype.selectRelation = function(relation) {
  var self = this;
  if (typeof(relation) != 'object') {
    relation = _.find(self.relations, {relation_id: relation});
  }
  self.clearSVG();
  $("#relationList .relation-tr[data-id=" + relation.id + "]").addClass("selected");
  this.highlightRelation(relation);
}

BioC.prototype.hasCircularReference = function(relation, nodes) {
  var self = this;
  var visited = [];
  if (self.hasCycle(relation, visited)) {
    return true;
  }
  for(var i = 0; i < nodes.length; i++) {
    if (self.hasCycle(nodes[i], visited)) {
      return true;
    }
  }
  return false;
};

BioC.prototype.hasCycle = function(relation, visited) {
  var self = this;
  if (visited.includes(relation.id)) {
    return true;
  }
  visited.push(relation.id);
  for(var i = 0; i < relation.nodes.length; i++) {
    var n = relation.nodes[i];
    if (!n.type) { self.attachNode(n);}
    if (n.type == "R") {
      if (self.hasCycle(n.r, visited)) {
        return true;
      }
    }
  }
  return false;
}

BioC.prototype.addNodeToRelation = function(ids, options) {
  var self = this;
  options = options || {};
  if (!self.writable) {
    return;
  }
  if (typeof(ids) != 'object') {
    ids = [ids];
  }
  if (options.force) {
    self.clearSVG();
  }
  var $selected = $("#relationList .relation-tr.selected");
  var relation = _.find(self.relations, {id: $selected.data("id")});

  var nodes;
  if (options.type && options.type == 'relation') {
    nodes = _.filter(self.relations, function(r) {
      return ids.includes(r.id);
    });
    if (relation && self.hasCircularReference(relation, nodes)) {
      toastr.error("Circular reference encountered.");
      return; 
    }
  } else {
    nodes = _.filter(self.annotations, function(a) {
      return ids.includes(a.id);
    });
  }

  if ($selected.length > 0 && relation) {
    var relationType = self.relationTypes[relation.type];
    if (relationType && relation.nodes.length >= relationType.num) {
      toastr.error(relation.type + " can have only " + relationType.num + " reference nodes.");
      return;    
    }    

    var ref_ids = _.map(relation.nodes, function(n) {return n.ref_id;});
    var duplicates = _.filter(nodes, function(n) {
      return ref_ids.includes(n.id);
    });

    if (duplicates.length > 0) {
      toastr.error("Already exist annotation/relation: " + _.map(duplicates, function(e) {return e.text;}).join(','));
      return;
    }

    if (nodes.length < 1 && !options.force) {
      toastr.error("Not exist annotation / relation");
      return;
    }

    var order_no = relation.nodes.length;
    _.each(nodes, function(n, idx) {
      var node = {ref_id: n.id, order_no: order_no + idx};
      self.attachNode(node);
      relation.nodes.push(node);
    });

    $selected.find('.nodes .dimmer').addClass('active');
    $.ajax({
      url: self.relationUrl(relation.relation_id),
      method: "PATCH",
      data: relation,
      success: function(data) {
        $selected.replaceWith(self.templates.relationTr(relation));
        self.bindRelationTr();
        self.selectRelation(relation);
      },
      error: function(xhr, status, err) {
        toastr.error(xhr.responseText || err);              
      },
      complete: function() {
        $selected.find('.type .dimmer').removeClass('active');
      }
    })

  } else {
    var type = $("#defaultRTypeSelector option:selected").text();
    if (!type) {
      self.addNewRelationType();
      type = $("#defaultRTypeSelector option:selected").text();
      if (!type) {
        toastr.error("Cannot create a relation without assigning a relation type");
        return;
      }
    }
    $(".document-loader").addClass("active");
    var data = {type: type, nodes: []};
    _.each(nodes, function(n, idx) {
      data.nodes.push({ref_id: n.id, order_no: idx});
    });
    $.ajax({
      url: self.relationUrl(),
      method: "POST",
      data: data,
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      success: function(data) {
        console.log(data);
        if (data.relation) {
          self.attachNodeToRelation(data.relation);
          self.relations.push(data.relation);
          $("#relationList").prepend(self.templates.relationTr(data.relation));
          self.selectRelation(data.relation);
          self.bindRelationTr();
        } else {
          toastr.error("Unable to create an annotation. Maybe texts are located in sentences."); 
        }
      },
      error: function(xhr, status, err) {
        toastr.error(xhr.responseText || err);              
      },
      complete: function() {
        $(".document-loader").removeClass("active");
      }
    });
  }
};

BioC.prototype.clickRelationType = function(e) {
  this.restoreRTR();
  var self = this;
  var $e = $(e.currentTarget);
  var $tr = $e.closest("tr");
  var $td = $tr.find("td.type");
  $td.addClass("editing");
  var oldValue = $td.text().trim();
  $td.data('value', oldValue);
  $td.find(".type-edit").html($("<select/>").html($("#relationModal select[name='type']").html()));
  $td.find("select").val(oldValue).focus();
  $td.find("select").unbind('change').change(function(e) {
    self.updateRelationType($tr);
  });
  $td.find("select").unbind('blur').blur(function() {
    self.updateRelationType($tr);
  });
};


BioC.prototype.restoreRTR = function(e) {
  _.each($("td.type.editing"), function(cell) {
    var $e = $(cell);
    $e.removeClass("editing")
    $e.find(".type-edit").empty();
    $e.find(".type-text").html($e.data("value"));
  });
  $(".relation-tr").removeClass("editable");
};

function getSelected() {
  if(window.getSelection) { return window.getSelection(); }
  else if(document.getSelection) { return document.getSelection(); }
  else {
    var selection = document.selection && document.selection.createRange();
    if(selection.text) { return selection.text; }
    return false;
  }
  return false;
}

function clearSelection() {
  if (window.getSelection) {
    if (window.getSelection().empty) {  // Chrome
      window.getSelection().empty();
    } else if (window.getSelection().removeAllRanges) {  // Firefox
      window.getSelection().removeAllRanges();
    }
  } else if (document.selection) {  // IE?
    document.selection.empty();
  }
}

BioC.prototype.initPaneWidthHeight = function() {
  var width = parseInt($(".document").width(), 10);
  var leftWidth = ($(".document").hasClass("outline") ? 200 : 0);
  var rightWidth = (width > 991) ? 350 : 250;
  var mainWidth = width - (rightWidth + leftWidth);
  
  if (width > 2000) {
    mainWidth = 1300;
  } else if (width > 1600) {
    mainWidth = 1200 - leftWidth;
  } else if (width > 1400) {
    mainWidth = 1050 - leftWidth;
  }
  if (mainWidth >= 850) {
    rightWidth = width - (mainWidth + leftWidth);
  }
  if (mainWidth < 400) {
    mainWidth = mainWidth + leftWidth;
    leftWidth = 0;
  }

  $(".main.pane").css("margin-left", leftWidth + "px");    
  $(".left-side.pane").toggle(leftWidth > 0);  
  $(".main.pane").width(mainWidth + "px");
  $(".right.pane").css('left', (($(".main.pane").outerWidth() + leftWidth) + "px"))
                  .css('width', rightWidth + 'px').show();
  this.clearSVG();
};


BioC.prototype.initOutlineScroll = function() {
  var self = this;
  $('.outline-link').click(function(e) {
    e.preventDefault();
    self.scrollToPasssage($.attr(this, 'href'));
    return false;
  });
};

BioC.prototype.scrollToPasssage = function(passage) {
  if (!/^#passage/.test(passage)) {
    passage = "#passage-" + passage;
  }
  $("html, body").animate({
      scrollTop: ($(passage).offset().top - 130) 
    }, 300);
};

BioC.prototype.scrollToPos = function(top) {
  var height = $(window).height();
  top = Math.max(top - height / 2, 0);
  $("html, body").animate({scrollTop: top}, 300);
};

BioC.prototype.storeScrollTop = function() {
  var pos = $("html, body").scrollTop();
  localStorage && localStorage.setItem('ScrollTop_' + this.id, pos);
  console.log("last pos: " + pos);
}

BioC.prototype.restoreScrollTop = function() {
  var pos = localStorage && localStorage.getItem('ScrollTop_' + this.id);
  if (pos && pos > 0) {
    if (confirm("Do you want to go to the last used location in the document?")) {
      $("html, body").animate({
          scrollTop: pos 
        }, 300);
    } else {
      localStorage && localStorage.removeItem('ScrollTop_' + this.id);
    }
  }
}
BioC.prototype.bindInfonBtns = function() {
  $(".infon-btn").click(function(e) {
    var id = $(e.currentTarget).data("id");
    e.preventDefault();
    $(".modal.infon-" + id).modal({
      blurring: true
    })
    .modal('show');
    return false;
  });
}
BioC.prototype.initModal = function() {
  $(".doc-info-btn").click(function() {
    $(".modal.doc-info").modal({
      blurring: true
    })
    .modal('show');
  });
  this.bindInfonBtns(); 
};

BioC.prototype.renderPassage = function(id) {
  var self = this;
  var $p = $('#passage-'+id);
  var $p_text_div = $p.find('.passage-text');
  if (!$p_text_div) {
    return;
  }
  var p_offset = parseInt($p.data('offset'), 10);
  var ranges = [p_offset];
  var ptext = $('#ptext-' + id).text();
  var max = p_offset + ptext.length;
  var annotations = _.filter(this.annotations, function(a) {
    if (a.offset < p_offset ||
        a.offset > (p_offset + ptext.length)) {
      return false;
    }
    if (!a.annotator || self.hasEnabledAnnotators(a.annotator)) {
      return true;
    }
    return false;
  });
  var div = document.createElement("div");
  _.each(annotations, function(a) {
    div.innerHTML = a.text;
    a.length = div.innerText.length;
    var n_pos = a.offset + a.length;
    ranges.push(a.offset)
    if (n_pos < max) {
      ranges.push(n_pos); 
    }
  });
  $p_text_div.html("");
  ranges = _.uniq(ranges).sort(function(a, b) {return a - b;});
  _.each(ranges, function(s_pos, index) {
    e_pos = (index < ranges.length - 1) ? ranges[index + 1] : max;

    var a_selected = null;
    var ids = [], a_types = [], a_concepts = [], a_texts = [], cls = [];
    var last_size = 9999999;
    var annotation_ids = [];
    var entity_type = "", concept_id = "";
    var a_in_range = [];
    _.each(annotations, function(a) {
      var size = a.length;
      var ss = a.offset;
      var ee = ss + size;
      if (ee > s_pos && e_pos > ss) {
        if (size < last_size) {
          a_selected = a;
          last_size = size;
        }
        ids.push('AL_' + a.id + '_' + a.offset);
        annotation_ids.push(a.id);
        a_concepts.push(a.concept);
        a_in_range.push(a);
        a_types.push(a.type);
        a_texts.push(a.text);
      }
    });

    if (a_selected) {
      entity_type = a_selected.type;
      concept_id = a_selected.concept;
      cls.push("A_" + a_selected.type.toUpperCase());
      cls.push("need-popup2");
    }

    if (annotation_ids.length > 1) {
      cls.push('overlapped');
    }
    a_concepts = _.uniq(a_concepts);
    a_texts = _.uniq(a_texts);
    a_types = _.uniq(a_types);
    annotation_ids = _.uniq(annotation_ids);

    if (a_concepts.length > 1 || a_texts.length > 1 || a_types.length > 1) {
      _.each(a_in_range, function(a) {
        a.review_result = "disagreed";
      });
      cls.push('mismatched');
    }

    cls = _.uniq(cls);
    if (cls.length > 0) {
      cls.push('annotation');
    }
    $p_text_div.append('<span class="phrase ' + cls.join(' ') + ' ' + ids.join(' ') + '"/>');
    var ret = $p_text_div.find('span:last-child');
    ret.data('ids', annotation_ids.join(' '));
    ret.data('type', entity_type);
    ret.data('concept', concept_id);
    ret.data('id', a_selected && a_selected.id);
    ret.data('offset', s_pos);
    ret.text(ptext.substring(s_pos - p_offset, e_pos - p_offset));
    if (a_concepts) {
      // ret.data('html', a_concepts.join('<br>'));
      ret.data('concepts', a_concepts.join(' '));
    }
  });

  $p_text_div.find('.annotation').click(function(e) {
    self.clickAnnotation(e.currentTarget, {event: e});
  });

  $p_text_div.find(".phrase.need-popup2").unbind('mouseover').mouseover(function(e) {
    var pos = inlineOffset($(e.currentTarget));
    var concepts = $(e.currentTarget).data('concepts').split(' ');
    concepts = _.filter(_.map(concepts, function(n) {return n && n.trim();}), function(n) {return n.length > 0;});
    var names = _.map(concepts, function(c) { 
      var name = self.conceptNameCache.get(c);
      if (c == name) {
        name = "";
      }
      return self.templates.popup({id: c, name: name}); 
    });
    if (names.length > 0) {
      $("#conceptPopup table").html(names.join());
    } else {
      $("#conceptPopup table").html("<tr><td colspan='2' class='warning'>No ID assigned</td></tr>");
    }      
    $("#conceptPopup").show().css({top: (pos.top + 32) + "px", left: pos.left + "px"});      
  });
  $p_text_div.find(".phrase.need-popup2").unbind('mouseout').mouseout(function(e) {
    $("#conceptPopup").hide();
  });
}

BioC.prototype.renderAllPassages = function(id) {
  var last = $('.passage:last').data('id');
  for(var i = 0; i <= last; i++) {
    this.renderPassage(i);
  }
  this.renderAnnotationTable();
  this.renderRelationTable();
};
