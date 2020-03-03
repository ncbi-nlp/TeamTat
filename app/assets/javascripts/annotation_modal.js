var AnnotationModal = function(bioC) {
  var self = this;
  self.bioC = bioC;
};

AnnotationModal.prototype.show = function(id) {
  var self = this;
  var all_a = _.filter(self.bioC.annotations, {id: id});
  var a = all_a[0];
  var offsets = _.map(all_a, function(a) {return a.offset});
  if (!a) {
    console.log("Sorry, There is no A");
    return;
  }
  var annotation_id = a.annotation_id;
  var old_type = a.type;
  var old_concept = a.concept;
  var old_note = a.note;
  $("#annotationModal .hide-for-add").show();
  $("#annotationModal .show-for-add").hide();
  $("#annotationModal .for-annotate-all").hide();
  $(".btn-update-text").text("Update");
  $("#annotationModal").addClass(self.bioC.roundState);
  $("#annotationModal .header").html(a.text);
  $("#annotationModal input[name='text']").val(a.text);
  $("#annotationModal input[name='offset']").val(offsets.join(","));
  $("#annotationModal select[name='type']").dropdown("set selected", a.type);
  $("#annotationModal input[name='concept']").val(a.concept);
  $("#annotationModal input[name='note']").val(a.note);
  if (!old_concept.trim()) {
    $(".old-concept-text").text('-- NO Concept ID assigned --');
    $("#annotationModal .ui.checkbox.concept-mode").checkbox('set disabled');
  } else {
    $(".old-concept-text").text(old_concept);
  }
  self.bioC.conceptNameCache.get(a.concept, function(ret, name) {
    if (name) {
      $("#annotationModal .concept-name").text(name);
    } else {
      $("#annotationModal .concept-name").text("");
    }
  });
  var links = self.bioC.conceptNameCache.extractID(a.concept);

  $("#showMoreBtn").data("type", links.type)
  $("#showMoreBtn").data("id", links.id.join(","));
  if (links.type == "MESH") {
    $("#showMoreBtn").attr('href', 'https://meshb.nlm.nih.gov/record/ui?ui=' + links.id[0]);
    $("#showMoreBtn").show();
  }
  else if (links.type == "GENE") {
    $("#showMoreBtn").attr('href', 'https://www.ncbi.nlm.nih.gov/gene/' + links.id.join(","));
    $("#showMoreBtn").show();
  } else {
    $("#showMoreBtn").attr('href', '#').hide();
  }
  
  if (self.bioC.roundState == 'reviewing') {
    $("#annotationModal .skip-button").unbind('click').click(function(e) {
      $("#annotationModal input[name='review_result']").val(3);
      $("#annotationModal .positive.button").click();
    });
  }

  $("#annotationModal #showMoreBtn").unbind("click").click(function(e) {
    var $e = $(e.currentTarget);
    var type = $e.data("type");
    var ids = $e.data("id").split(",");
    if (type == "MESH" && ids.length > 1) {
      e.preventDefault();
      _.each(ids, function(id) {
        window.open('https://meshb.nlm.nih.gov/record/ui?ui=' + id);      
      })
      return false;
    }
    return true;
  });
  
  // $("#annotationModal input[name='mode']").prop("checked", $e.hasClass("concept"));
  $("#annotationModal input[name='annotate_all']").prop("checked", false);
  $("#annotationModal .dimmer").removeClass("active");
  if (!self.bioC.writable) {
    $(".action-button").hide();
    $("#annotationModal input").prop("disabled", true);
    $("#annotationModal .dropdown").addClass("disabled");
  }
  
  $("#annotationModal .ui.checkbox.for-mention").checkbox("uncheck");
  $("#annotationModal .ui.checkbox.case-sensitive").checkbox("uncheck");
  $("#annotationModal .ui.checkbox.whole-word").checkbox("check");
  $("#annotationModal .ui.checkbox.annotate-all").checkbox({
    onChecked: function() {
      $("#annotationModal .for-annotate-all").show();
      $(".btn-update-text").text("Update & Annotate All")
    },
    onUnchecked: function() {
      $("#annotationModal .for-annotate-all").hide();
      $(".btn-update-text").text("Update");
    }
  }).checkbox('uncheck');
  $("#annotationModal input[name='concept']").keyup(function() {
    var text = $(this).val().trim();
    if (text) {
      $("#annotationModal .ui.checkbox.annotate-all").checkbox('set enabled');
    } else {
      $("#annotationModal .ui.checkbox.annotate-all").checkbox('set disabled');
    }
  }).keyup();
  
  var update_msgs = [];
  if (a.annotator || self.bioC.isValidTimestamp(a.updated_at)) {
    update_msgs.push("Last updated");
    if (a.annotator) {
      update_msgs.push("by <i class='annotator'>" + a.annotator + "</i>");
    }
    if (self.bioC.isValidTimestamp(a.updated_at)) {
      // update_msgs.push("at <i class='updated_at'>" + a.updated_at + "</i>");
      update_msgs.push("at <i class='updated_at'>" + moment(a.updated_at).local().format('LLL') + "</i>");
    }
  }

  $("#annotationModal .update_log").html(update_msgs.join(" "));
  $("#annotationModal .add-relation-button").unbind('click').click(function() {
    $('#typeTab .item').tab('change tab', 'relations');
    $("#annotationModal").modal('hide');
    self.bioC.addNodeToRelation(a.id);
  });

  $("#annotationModal .delete-annotation")
    .dropdown({
      action: 'hide', 
      onChange: function(value) {
        $("#annotationModal .dimmer").addClass("active");
        $("#annotationModal input[name='deleteMode']").val(value);
        $.ajax({
          url: self.bioC.annotationUrl(annotation_id),
          method: "DELETE",
          data: $("#annotationModal form").serialize(), 
          success: function(data) {
            self.bioC.refreshViewAfterDelete(data);
            self.bioC.renderAnnotationTable();
            $("#annotationModal").modal("hide");
            self.bioC.refreshAnnotationListModal();
            toastr.success("Successfully deleted.");              
          },
          error: function(xhr, status, err) {
            toastr.error(xhr.responseText || err);              
            $("#annotationModal .dimmer").removeClass("active");
          },
        });
      }
    });
  $("#annotationModal .delete-annotation .item").removeClass("active selected");
  $("#annotationModal")
    .modal({
      allowMultiple: true,
      onVisible: function() {
        setTimeout(function() {
          $("#annotationModal input[name='concept']").focus();
        }, 10);
      },
      onApprove: function() {
        $("#annotationModal input[name='concept']").val($("#annotationModal input[name='concept']").val().trim());
        var new_type = $("#annotationModal select[name='type']").val();
        var new_concept = $("#annotationModal input[name='concept']").val();
        var new_note = $("#annotationModal input[name='note']").val();
        var mode = $("#annotationModal input[name='mode']").val();
        var needAnnotateAll = ($(".btn-update-text").text() != "Update");

        var entityType = self.bioC.entityTypes[new_type] || {};
        new_concept = self.bioC.normalizeConceptString(new_concept, entityType.prefix);  
        $("#annotationModal input[name='concept']").val(new_concept);
        // if (old_concept == new_concept && old_note == new_note && old_type == new_type && !needAnnotateAll) {
        //   return;
        // }
        if (old_concept != new_concept) {
          self.bioC.conceptNameCache.get(new_concept, function() {}); // prefetch
        }
        $("#annotationModal .dimmer").addClass("active");
        $.ajax({
          url: self.bioC.annotationUrl(annotation_id),
          method: "PATCH",
          data: $("#annotationModal form").serialize(), 
          success: function(data) {
            self.bioC.refreshViewUpdate(data);
            toastr.success("Successfully updated.");   
            self.bioC.renderAnnotationTable();
            self.bioC.refreshAnnotationListModal();
            $("#annotationModal").modal("hide");
          },
          error: function(xhr, status, err) {
            toastr.error(err);              
          },
          complete: function() {
            $("#annotationModal .dimmer").removeClass("active");
          }
        });
        return false;
      }
    })
    .modal("show");
};