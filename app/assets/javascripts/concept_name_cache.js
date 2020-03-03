var ConceptNameCache = function() {
  this.init();
};

ConceptNameCache.prototype.init = function() {
  this.listForFetch = [];
};

ConceptNameCache.prototype.escape = function(id) {
  return id.replace(/[:\s,;\|]/, "-");
};

ConceptNameCache.prototype.get = function(id, cb) {
  var self = this;
  var e = self.extractID(id);
  // console.log("FOUND ID:", e);
  if (!e.type) {
    if (cb) {
      cb(id);
    }
    return id;
  }
  var cbNames = [];
  var cb2 = cb && function(error, name) {
    cbNames.push(name);
    if (cbNames.length >= e.id.length) {
      var finalName = self.get(id);
      if (cb) {
        cb(null, finalName);
      }
    }
  };

  var names = _.map(e.id, function(id) {
    return self._get(e.type + ":" + id, cb2);
  });
  return names.join(', ');
};


ConceptNameCache.prototype._get = function(id, cb) {
  var self = this;
  var name = localStorage && localStorage.getItem("CACHE-" + id);
  if (name) {
    if (cb) {
      cb(null, name);
    }
    // console.log('Get <' + id + " : " + name +"> from cache");
    return name;
  } else {
    if (cb) {
      self.fetch(id, cb);
    } else {
      if (this.listForFetch.indexOf(id) === -1) {
        console.log('Cache miss: put list << ' + id);
        this.listForFetch.push(id);
      }      
    }
    return id;
  }
};

ConceptNameCache.prototype.postFound = function(id, name) {
  // console.log('change title [' + '.concept-text.for-' + this.escape(id) + "]" + name);
  $('.concept-text.for-' + this.escape(id)).prop('title', name); 
};

ConceptNameCache.prototype.fetchAll = function() {
  var self = this;
  // console.log("Fetch all for " + self.listForFetch.join(","));
  _.each(self.listForFetch, function(id) {
    var name = localStorage && localStorage.getItem("CACHE-" + id);
    if (!name) {
      self.fetch(id);
    } else {
      self.postFound(id, name);
    }
  });
  self.listForFetch = [];
};

ConceptNameCache.prototype.initFetch = function(annotations) {
  var self = this;
  var genes = [], others = []; 
  _.each(annotations, function(a) {
    var t = self.extractID(a.concept);
    if (t.type == 'GENE') {
      genes = genes.concat(t.id);
    } else if (t.type == 'MESH' || t.type == 'SPECIES')  {
      others.push(a.concept);
    }
  });
  self.fetchGeneBulk(genes);
  _.each(others, function(id) {
    self.fetch(id);
  });
};

ConceptNameCache.prototype.getFetchTypeAndURL = function(id) {
  var parts = id.split(":");
  if (id.match(/^MESH:/i)) {
    return {
      url: 'https://id.nlm.nih.gov/mesh/' + parts[1] + '.json',
      dataType: 'json',
      parseName: function(data) {
        if (data && data.label && data.label['@value']) {
          return data.label['@value'];
        }
        return data && data['@graph'] && 
              data['@graph'][0] && data['@graph'][0].label &&
              data['@graph'][0].label['@value'];
      }
    };
  } else if (id.match(/^GENE:/i)) {
    return {
      url: 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=gene&id='+ parts[1] + '&format=json',
      dataType: 'json',
      parseName: function(data) {
        var name = data && data.result && data.result[parts[1]] && data.result[parts[1]].name;
        var species = data && data.result && data.result[parts[1]] && data.result[parts[1]].organism && (
           data.result[parts[1]].organism.scientificname || data.result[parts[1]].organism.commonname);
        name = name && name.trim();
        species = species && species.trim();
        if (!name) {
          return "";  
        } else {
          return [name, species].join(" | ");
        }          
      }
    }
  } else if (id.match(/^SPECIES:/i)) {
    return {
      url: '/home/proxy?url=' + encodeURIComponent('https://www.ncbi.nlm.nih.gov/taxonomy/'+ parts[1] +'?report=taxon&format=text'),
      dataType: 'xml',
      parseName: function(xml) {
        var name = $(xml).find('pre').text();
        name = name && name.trim();
        if (!name) {
          return "";  
        } else {
          return name;
        }          
      }
    }
  }
  return {};
};

ConceptNameCache.prototype.fetchGeneBulk = function(ids) {
  ids = _.uniq(ids);
  $.ajax({
    url: 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=gene&id='+ ids.join(',') + '&format=json',
    method: 'GET',
    dataType: 'json',
    success: function(data) {
      var result = data && data.result;
      if (result) {
        _.each(ids, function(id) {
          var name = result[id] && result[id].name;
          var species = result[id] && result[id].organism && (
                        result[id].organism.scientificname || result[id].organism.commonname);
          name = name && name.trim();
          species = species && species.trim();
          if (name) {
            localStorage && localStorage.setItem("CACHE-GENE:" + id, [name, species].join(" | "));
          }
        });
      }
    },
    error: function(xhr, status, err) {
      console.log(err);
    }
  });
};


ConceptNameCache.prototype.__stripIdType = function(type, str) {
  var r = new RegExp('^' + type + ':', 'i');
  var m = str.replace(r, '');
  return m;
};

ConceptNameCache.prototype.extractID = function(str) {
  var self = this;
  var ret = {
    type: null,
    id: []
  };
  var remain = str;
  if (str.match(/^MESH:/i)) {
    ret.type = "MESH";
  } else if (str.match(/^GENE:/i)) {
    ret.type = "GENE";
  } else if (str.match(/^SPECIES:/i)) {
    ret.type = "SPECIES";
  }
  ret.id = _.map(_.compact(str.split(/[,\s;\|]/)), function(id) {
    // console.log("ID=", id);
    id = self.__stripIdType(ret.type, id);
    var m = id.match(/^([^-]+)/);
    return m && m[1];
  });
  ret.id = _.compact(ret.id);
  return ret;
};

ConceptNameCache.prototype.fetch = function(id, cb) {
  var self = this;
  var ret = self.getFetchTypeAndURL(id);
  if (ret && ret.url) {
    $.ajax({
      url: ret.url,
      method: 'GET',
      dataType: ret.dataType,
      success: function(data) {
        var name = ret.parseName(data);
        if (name) {
          // console.log('Fetch success <' + id + " : " + name +">");
          localStorage && localStorage.setItem("CACHE-" + id, name);
          self.postFound(id, name);
          if (cb) {
            return cb(null, name);
          }      
        } else {
          self.postFound(id, id);
          if (cb) {
            return cb(null, id);
          }
        }
      }, 
      error: function(xhr, status, err) {
        console.log(err);  
        if (cb) {
          cb(null, id);
        }            
      }
    });
  }
};
