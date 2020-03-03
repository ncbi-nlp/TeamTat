var ProjectActionManager = function() {
  this.projectId = $("#projectActionModal").data('project');
  this.version = parseInt($("#projectActionModal").data('version') || 0);
}

ProjectActionManager.prototype.lock = function(genUrl, version, finalAction) {
  var self = this;
  $.ajax({
    url: '/projects/' + self.projectId + '/lock.json',
    method: 'POST',
    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
    success: function(data) {
      self.documents = data.documents;
      self.doEach(0, genUrl, version, finalAction);
      $('#projectActionModal .ui.progress').progress({
        total: self.documents.length,
        value: 0,
        text: {
          active: '{value} of {total} done'
        },
        label: 'percent'
      });
    },
    error: function(err) {
      console.error(err);
      toastr.error(err.responseText || err); 
      $("#projectActionModal").modal('hide');
    },
  });
};

ProjectActionManager.prototype.unlock = function() {
  var self = this;
  $.ajax({
    url: '/projects/' + self.projectId + '/unlock.json',
    method: 'POST',
    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
    success: function(data) {
    },
    error: function(err) {
      console.error(err);
      toastr.error(err.responseText || err); 
      $("#projectActionModal").modal('hide');
    },
  });
};

ProjectActionManager.prototype.doEach = function(idx, genUrl, version, finalAction) {
  var self = this;
  var documentId = self.documents[idx];
  if (!documentId) {
    return;
  }
  $.ajax({
    url: genUrl(documentId),
    data: { version: version  },
    method: 'POST',
    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
    success: function(data) {
      $('#projectActionModal .ui.progress').progress({
        value: idx + 1,
        total: self.documents.length,
        text: {
          active: '{value} of {total} done'
        },
        label: 'percent'
      });
      if (idx < self.documents.length - 1) {
        self.doEach(idx + 1, genUrl, version, finalAction);
      } else {
        finalAction();
      }
    },
    error: function(err) {
      self.unlock();
      console.error(err);
      toastr.error(err.responseText || err); 
      $("#projectActionModal").modal('hide');
    },
  });
};

ProjectActionManager.prototype.startRound = function(options) {
  var self = this;
  $("#projectActionModal .header").text("Start Annotation Round");
  $("#projectActionModal").modal({
    closable  : false,
  }).modal('show');

  self.lock(
    function(id) { 
      return '/documents/' + id + '/start_round';
    }, 
    self.version + 1,
    function() {
      location = '/projects/' + self.projectId + '/start_round'; 
    }
  );
};

ProjectActionManager.prototype.startRound2 = function(options) {
  var self = this;
  $("#projectActionModal .header").text("Start Annotation Round");
  $("#projectActionModal").modal({
    closable  : false,
  }).modal('show');

  self.lock(
    function(id) { 
      return '/documents/' + id + '/start_round2';
    }, 
    self.version + 1,
    function() {
      location = '/projects/' + self.projectId + '/start_round2'; 
    }
  );
};

ProjectActionManager.prototype.stopRound = function() {
  var self = this;
  $("#projectActionModal .header").text("End Annotation Round");
  $("#projectActionModal").modal({
    closable  : false,
  }).modal('show');

  self.lock(
    function(id) { 
      return '/documents/' + id + '/simple_merge';
    }, 
    self.version,
    function() {
      location = '/projects/' + self.projectId + '/end_round'; 
    }
  );
};

ProjectActionManager.prototype.finalMerge = function() {
  var self = this;
  $("#projectActionModal .header").text("Generate Final Merge");
  $("#projectActionModal").modal({
    closable  : false,
  }).modal('show');

  self.lock(
    function(id) { 
      return '/documents/' + id + '/final_merge';
    }, 
    self.version,
    function() {
      location = '/projects/' + self.projectId + '/final_merge'; 
    }
  );
};

ProjectActionManager.prototype.createTask = function(form) {
  var self = this;
  $("#projectActionModal .header").text("Preparing documents for a new task");
  $("#projectActionModal").modal({
    closable  : false,
  }).modal('show');

  self.lock(
    function(id) { 
      return '/documents/' + id + '/attach';
    }, 
    null,
    function() {
      // alert('submit here!');
      form.submit(); 
    }
  );
};

$(function() {
  if ($("#projectActionModal").length > 0) {
    $("#startRoundButton1").click(function() {
      if (confirm("Are you sure to start an individual round?")) {
        var projectActionManager = new ProjectActionManager();
        projectActionManager.startRound();
      }
    });

    $("#startRoundButton2").click(function() {
      if (confirm("Are you sure to start a collaborative round?")) {
        var projectActionManager = new ProjectActionManager();
        projectActionManager.startRound2();
      }
    });

    $("#stopAnnotationButton").click(function() {
      if (confirm("Are you sure to end annotation round?")) {
        var projectActionManager = new ProjectActionManager();
        projectActionManager.stopRound();
      }
    });

    $("#finalMergeButton").click(function() {
      if (confirm("Are you sure to merge all annotations into a new version?")) {
        var projectActionManager = new ProjectActionManager();
        projectActionManager.finalMerge();
      }
    });
  }
});
















