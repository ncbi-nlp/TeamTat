var AnnotatorManager = function(annotations, me) {
  this.loadAnnotations(annotations, me);
  this.view = Handlebars.compile($("#annotatorSelectRow").html());
};

AnnotatorManager.prototype.loadAnnotations = function(annotations, me) {
  var self = this;
  var emails = [me];
  _.each(annotations, function(a) {
    _.each(a.annotator.split(','), function(name) {
      emails.push(name.trim());
    });
  });
  self.emails = _.uniq(emails).sort();
  self.hidden_names = {}
  var idx = 1;
  _.each(_.shuffle(self.emails), function(email) {
    var name = (email == me) ? 'You' : ('Other' + (idx++));
    self.hidden_names[email] = name;
  });
};

AnnotatorManager.prototype.getEmails = function() {
  return this.emails;
};

AnnotatorManager.prototype.getHiddenNames = function() {
  return _.values(this.hidden_names);
};

AnnotatorManager.prototype.convertName = function(email) {
  email = email.trim();
  return this.hidden_names[email] || 'Other';
};

AnnotatorManager.prototype.convert = function(emails) {
  var self = this;
  return _.map(emails.split(','), function(email) {
    return self.convertName(email)
  }).join(',');
};

AnnotatorManager.prototype.anonymize = function(annotations) {
  var self = this;
  if (self.mode != 'anonymized') {
    _.each(annotations, function(a) {
      a.real_annotator = a.annotator;
      a.annotator = self.convert(a.annotator);
    });
    self.mode = 'anonymized';
  }
};

AnnotatorManager.prototype.deAnonymize = function(annotations) {
  var self = this;
  if (self.mode == 'anonymized') {
    _.each(annotations, function(a) {
      if (a.real_annotator) {
        a.annotator = a.real_annotator;
      }
    });
    self.mode = 'normal';
  }
};

AnnotatorManager.prototype.renderAnnotatorChecker = function() {
  var self = this;
  var names = (self.mode == 'anonymized') ? self.getHiddenNames() : self.getEmails();
  $("#hideAnnotatorButton").toggle(self.mode != 'anonymized');
  $("#showAnnotatorButton").toggle(self.mode == 'anonymized');

  $('#annotatorCheckerList').html("<div class='header'><i class='user icon'></i>Toggle annotator</div><div class='divider'></div>" + 
        _.map(names.sort(), function(e) {return self.view({email: e}); }).join(""));
};