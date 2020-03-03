// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function updateProjectStatus() {
  var $e = $(".project-status");
  if ($e.length <= 0) {
    return;
  }
  var id = $e.data("id");
  var status = $e.data('status');
  $.getJSON("/projects/" + id + ".json", function(data) {
    console.log(data.status, status);
    $e.html(data.status_with_icon);
    $(".task-buttons-annotate").toggleClass("disabled", !data.task_available);
    $(".task-buttons-train").toggleClass("disabled", !data.task_available || !data.has_annotations);
    $(".documents-list .ui.checkbox input[type='checkbox']").prop('disabled', !(data.status == 'annotating' &&  data.status == 'reviewing'));
    if (data.task_available) {
      popup_title = "Mark when annotation is done.";
    } else {
      popup_title = "This feature is unavailable while the project is not in the annotation round";
    }
    $(".need-popup.for-done-button").attr('title', popup_title);
    $(".ajax-update-disbled-with-status").toggleClass('disabled', !data.task_available);

  });
}

$(function() {
  $('.done-checker .checkbox').checkbox().checkbox({
    beforeChecked: function() {
      var unreviewed = parseInt($("#reviewWarning").text(), 10);
      if ( unreviewed > 0 && 
          !confirm("You have not reviewed " + unreviewed + " annotation(s) yet. Are you sure to complete this document?")) {
          return false;
      }
      return true;
    },
    onChange: function() {
      var $e = $(this);
      var id = $e.data('id');
      var checked = $e.prop('checked');
      var $loader = $e.siblings('.loader');
      console.log(id, checked, $loader);
      $loader.addClass('active');
      $e.addClass
      $.ajax({
        url: '/documents/' + id + '/done',
        method: "POST",
        data: {value: checked}, 
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        success: function(data) {
          location.reload();
          console.log(data);
        }, 
        error: function(err) {
          console.error(err);
        },
        complete: function() {
          $loader.removeClass('active');
        }
      });
    },
  });
  
  $('.curatable-checker .checkbox').checkbox().checkbox({
    onChange: function() {
      var $e = $(this);
      var id = $e.data('id');
      var checked = $e.prop('checked');
      var $loader = $e.siblings('.loader');
      console.log(id, checked, $loader);
      $loader.addClass('active');
      $e.addClass
      $.ajax({
        url: '/documents/' + id + '/curatable',
        method: "POST",
        data: {value: checked}, 
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        success: function(data) {
          location.reload();
          console.log(data);
        }, 
        error: function(err) {
          console.error(err);
        },
        complete: function() {
          $loader.removeClass('active');
        }
      });
    },
  });});

/*! modernizr 3.6.0 (Custom Build) | MIT *
 * https://modernizr.com/download/?-webp-setclasses !*/
!function(e,n,A){function o(e,n){return typeof e===n}function t(){var e,n,A,t,a,i,l;for(var f in r)if(r.hasOwnProperty(f)){if(e=[],n=r[f],n.name&&(e.push(n.name.toLowerCase()),n.options&&n.options.aliases&&n.options.aliases.length))for(A=0;A<n.options.aliases.length;A++)e.push(n.options.aliases[A].toLowerCase());for(t=o(n.fn,"function")?n.fn():n.fn,a=0;a<e.length;a++)i=e[a],l=i.split("."),1===l.length?Modernizr[l[0]]=t:(!Modernizr[l[0]]||Modernizr[l[0]]instanceof Boolean||(Modernizr[l[0]]=new Boolean(Modernizr[l[0]])),Modernizr[l[0]][l[1]]=t),s.push((t?"":"no-")+l.join("-"))}}function a(e){var n=u.className,A=Modernizr._config.classPrefix||"";if(c&&(n=n.baseVal),Modernizr._config.enableJSClass){var o=new RegExp("(^|\\s)"+A+"no-js(\\s|$)");n=n.replace(o,"$1"+A+"js$2")}Modernizr._config.enableClasses&&(n+=" "+A+e.join(" "+A),c?u.className.baseVal=n:u.className=n)}function i(e,n){if("object"==typeof e)for(var A in e)f(e,A)&&i(A,e[A]);else{e=e.toLowerCase();var o=e.split("."),t=Modernizr[o[0]];if(2==o.length&&(t=t[o[1]]),"undefined"!=typeof t)return Modernizr;n="function"==typeof n?n():n,1==o.length?Modernizr[o[0]]=n:(!Modernizr[o[0]]||Modernizr[o[0]]instanceof Boolean||(Modernizr[o[0]]=new Boolean(Modernizr[o[0]])),Modernizr[o[0]][o[1]]=n),a([(n&&0!=n?"":"no-")+o.join("-")]),Modernizr._trigger(e,n)}return Modernizr}var s=[],r=[],l={_version:"3.6.0",_config:{classPrefix:"",enableClasses:!0,enableJSClass:!0,usePrefixes:!0},_q:[],on:function(e,n){var A=this;setTimeout(function(){n(A[e])},0)},addTest:function(e,n,A){r.push({name:e,fn:n,options:A})},addAsyncTest:function(e){r.push({name:null,fn:e})}},Modernizr=function(){};Modernizr.prototype=l,Modernizr=new Modernizr;var f,u=n.documentElement,c="svg"===u.nodeName.toLowerCase();!function(){var e={}.hasOwnProperty;f=o(e,"undefined")||o(e.call,"undefined")?function(e,n){return n in e&&o(e.constructor.prototype[n],"undefined")}:function(n,A){return e.call(n,A)}}(),l._l={},l.on=function(e,n){this._l[e]||(this._l[e]=[]),this._l[e].push(n),Modernizr.hasOwnProperty(e)&&setTimeout(function(){Modernizr._trigger(e,Modernizr[e])},0)},l._trigger=function(e,n){if(this._l[e]){var A=this._l[e];setTimeout(function(){var e,o;for(e=0;e<A.length;e++)(o=A[e])(n)},0),delete this._l[e]}},Modernizr._q.push(function(){l.addTest=i}),Modernizr.addAsyncTest(function(){function e(e,n,A){function o(n){var o=n&&"load"===n.type?1==t.width:!1,a="webp"===e;i(e,a&&o?new Boolean(o):o),A&&A(n)}var t=new Image;t.onerror=o,t.onload=o,t.src=n}var n=[{uri:"data:image/webp;base64,UklGRiQAAABXRUJQVlA4IBgAAAAwAQCdASoBAAEAAwA0JaQAA3AA/vuUAAA=",name:"webp"},{uri:"data:image/webp;base64,UklGRkoAAABXRUJQVlA4WAoAAAAQAAAAAAAAAAAAQUxQSAwAAAABBxAR/Q9ERP8DAABWUDggGAAAADABAJ0BKgEAAQADADQlpAADcAD++/1QAA==",name:"webp.alpha"},{uri:"data:image/webp;base64,UklGRlIAAABXRUJQVlA4WAoAAAASAAAAAAAAAAAAQU5JTQYAAAD/////AABBTk1GJgAAAAAAAAAAAAAAAAAAAGQAAABWUDhMDQAAAC8AAAAQBxAREYiI/gcA",name:"webp.animation"},{uri:"data:image/webp;base64,UklGRh4AAABXRUJQVlA4TBEAAAAvAAAAAAfQ//73v/+BiOh/AAA=",name:"webp.lossless"}],A=n.shift();e(A.name,A.uri,function(A){if(A&&"load"===A.type)for(var o=0;o<n.length;o++)e(n[o].name,n[o].uri)})}),t(),a(s),delete l.addTest,delete l.addAsyncTest;for(var p=0;p<Modernizr._q.length;p++)Modernizr._q[p]();e.Modernizr=Modernizr}(window,document);
