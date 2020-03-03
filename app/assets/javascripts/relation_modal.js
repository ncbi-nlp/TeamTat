var RelationModal = function(bioC) {
  var self = this;
  self.bioC = bioC;
  self.dirty = false;
  self.annotationTr = Handlebars.compile($("#annotationInRelationModal").html());
  self.refSelectorItemA = Handlebars.compile($("#refSelectorItemA").html());
  self.refSelectorItemR = Handlebars.compile($("#refSelectorItemR").html());
};

RelationModal.prototype.listCandidateAnnotation = function() {
  var self = this;
  var containRelations = [];
  self.bioC.hasCycle(self.relation, containRelations);

  var relationType = self.bioC.relationTypes[self.relation.type];
  var refIds = _.map($("#relationModal .ref-node"), function(e) {return $(e).data('id').toString();});
  var candidates = _.filter(self.bioC.annotations, function(a) {
    return (!relationType || !relationType.entity || relationType.entity.length == 0 || relationType.entity.includes(a.type)) 
            && !refIds.includes(a.id);
  });
  var candidateRelations = _.filter(self.bioC.relations, function(r) {
    return (!relationType || !relationType.entity || relationType.entity.length == 0 || relationType.entity.includes(r.type)) 
            && !self.bioC.hasCircularReference(self.relation, [r])
  });
  $("#refSelector .dropdown .menu").html(_.map(candidates, function(a) {
      return self.refSelectorItemA(a);
    }).join("\n") + _.map(candidateRelations, function(r) {
      return self.refSelectorItemR(r);
    }).join("\n"));

  $("#refSelector div.dropdown").dropdown({
    onChange: function() {
      var id = $("#refSelector div.dropdown").dropdown('get value');
      if (id) {
        $("#refSelector button").prop('disabled', false);
      }
    }
  });
};

RelationModal.prototype.serialize = function() {
  var nodes = _.map($("#relationModal .ref-node"), function(n) {
    var $n = $(n);
    return {
      ref_id: $n.data('id'),
      role: $n.find("input[name='role']").val()
    };
  });
  if (!nodes) {
    nodes = [];
  }
  return {
    type: $("#relationModal select[name='type']").dropdown('get value'),
    note: $("#relationModal input[name='note']").val(),
    nodes: nodes,
    forceUpdateNodes: 1
  };
};

RelationModal.prototype.bindDeleteNode = function() {
  var self = this;
  $("#relationModal .remove-node").unbind('click').click(function(e) {
    e.stopPropagation();
    if (!confirm("Are you sure to remove?")) {
      return false;
    }
    $(e.currentTarget).closest('tr').remove();
    self.dirty = true;
    return false;
  });
};

RelationModal.prototype.show = function(id) {
  var self = this;
  var all_r = _.filter(self.bioC.relations, {id: id});
  self.relation = all_r[0];
  if (!self.relation) {
    console.log("Sorry, There is no R");
    return;
  }
  var relation_id = self.relation.relation_id;
  var old_type = self.relation.type;
  var old_note = self.relation.note;
  $("#relationModal .hide-for-add").show();
  $("#relationModal .show-for-add").hide();
  $(".btn-update-text").text("Update");
  $("#relationModal .header").html("Relation #" + self.relation.id);
  $("#relationModal select[name='type']").dropdown({
    onChange: function() { self.dirty = true; },
  }).dropdown("set selected", self.relation.type);
  $("#relationModal input[name='note']")
    .change(function() {self.dirty = true;})
    .val(self.relation.note);
  $("#relationModal .ref-nodes tbody").html(
    _.map(self.relation.nodes, function(n) { return self.annotationTr(n);}).join("\n")
  );
  self.bindDeleteNode();

  $("#relationModal .ref-nodes tbody").sortable({});

  $("#relationModal .dimmer").removeClass("active");
  if (!self.bioC.writable) {
    $("#relationModal .action-button").hide();
  }
  self.dirty = false;

  var update_msgs = [];
  if (self.relation.annotator || self.bioC.isValidTimestamp(a.updated_at)) {
    update_msgs.push("Last updated");
    if (self.relation.annotator) {
      update_msgs.push("by <i class='annotator'>" + self.relation.annotator + "</i>");
    }
    if (self.bioC.isValidTimestamp(self.relation.updated_at)) {
      update_msgs.push("at <i class='updated_at'>" + moment(self.relation.updated_at).local().format('LLL') + "</i>");
    }
  }
  $("#relationModal .update_log").html(update_msgs.join(" "));
  $("#refSelector").hide();
  $("#relationModal .delete-relation .item").removeClass("active selected");

  $("#relationModal .add-node").unbind('click').click(function(e) {
    self.listCandidateAnnotation();
    $("#refSelector div.dropdown").dropdown("clear");
    $("#refSelector button").unbind('click').click(function(e) {
      var id = $("#refSelector div.dropdown").dropdown('get value');
      var node = {
        ref_id: id,
        role: ""
      };
      self.bioC.attachNode(node);
      $("#relationModal .ref-nodes tbody").append(self.annotationTr(node));
      $("#refSelector").hide();
      self.bindDeleteNode();
      self.dirty = true;
    }).prop('disabled', true);
    $("#refSelector").show();
  });


  
  $("#relationModal")
    .modal({
      allowMultiple: true,
      closable  : false,
      onVisible: function() {
        // setTimeout(function() {
        //   $("#relationModal input[name='note']").focus();
        // }, 10);
      },
      onDeny: function($e) {
        if ($e.hasClass('delete-relation')) {
          if (!confirm("Are you sure to delete?")) {
            return false;
          }
          $.ajax({
            url: self.bioC.relationUrl(relation_id),
            method: "DELETE",
            success: function(data) {
              $(".relation-tr[data-relation_id='" + self.relation.relation_id+ "']").remove();
              self.bioC.relations = _.filter(self.bioC.relations, function(r) {
                return r.relation_id != data;
              });
              self.bioC.clearSVG();
              toastr.success("Successfully deleted.");              
            },
            error: function(xhr, status, err) {
              toastr.error(xhr.responseText || err);              
            },
          });
        } else if (self.dirty && !confirm("Discard changes?")) {
          return false;
        }
        $("#projectActionModal").modal('hide');
      },
      onApprove: function() {
        $("#relationModal .dimmer").addClass("active");
        $.ajax({
          url: self.bioC.relationUrl(relation_id),
          method: "PATCH",
          data: self.serialize(), 
          success: function(data) {
            var relation = data.relation;
            self.relation.type = relation.type;
            self.relation.passage = relation.passage;
            self.relation.note = relation.note;
            self.relation.annotator = relation.annotator;
            self.relation.updated_at = relation.updated_at;
            self.relation.user_id = relation.user_id;
            self.relation.nodes = relation.nodes;
            self.bioC.attachNodeToRelation(self.relation);
            $(".relation-tr[data-relation_id='" + self.relation.relation_id+ "']")
              .replaceWith(self.bioC.templates.relationTr(self.relation));
            self.bioC.bindRelationTr();
            self.bioC.selectRelation(self.relation); 
            toastr.success("Successfully updated.");  
          },
          error: function(xhr, status, err) {
            toastr.error(xhr.responseText || err);              
          },
          complete: function() {
            $("#relationModal dimmer").removeClass("active");
          }
        });
      }
    })
    .modal("show");
};