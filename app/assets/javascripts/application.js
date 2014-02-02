// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require turbolinks
//= require_tree .

function showSearchBox() {
  if ($("#searchbox").is(":visible")) {
    $("#searchbox").hide();
  } else {
    $("#searchbox").show();
    $("#searchbox").focus();
  }
};

$(function() {
  $( ".datepicker" ).datepicker({
    yearRange: '2012:2100',
    numberOfMonths: 2,
    showButtonPanel: false,
    dateFormat: "DD, d M yy",
    onSelect: function(dateText) {
      var propertyId = this.id.toString().substring(3)
      if (this.name == 'auto') {
        var newDate = $("#" + this.id).datepicker('getDate');
        updateCallDate(propertyId, newDate)
      }
    }
  });
});

function addDeleteFunction(id) {  
  $( "#del-" + id ).click(function() {
    $.ajax({
      type: "POST",
      url: "/delete_note",
      data: 'note_id=' + id,
      dataType: "json",
      error: function(xhr, status, error) {
        alert('Unable to delete note')
      },
      success: function (xhr, data) {
        if ($("#nli-" + id).length > 0) {
          $("#nli-" + id).remove()
        }
      }
    });
  });
}
function updateCallDate(propertyId, newDate) {
  $.ajax({
      type: "POST",
      url: "/update_call_date",
      data: 'new_call_date=' + newDate + '&property_id=' + propertyId,
      dataType: "json",
      error: function(xhr, status, error) {
        alert('Unable to update date')
        $( "#" + propertyId ).datepicker("setDate", oldDate );  
      },
      success: function (xhr, data) {
        location.reload();
      }
  });
}
function closeProperty(propertyId) {
  $.ajax({
      type: "POST",
      url: "/close",
      data: 'property_id=' + propertyId,
      dataType: "json",
      error: function(xhr, status, error) {
        alert('Unable to close property')
      },
      success: function (xhr, data) {
        location.reload();
      }
  });
}
function reopenProperty(propertyId) {
  $.ajax({
      type: "POST",
      url: "/reopen",
      data: 'property_id=' + propertyId,
      dataType: "json",
      error: function(xhr, status, error) {
        alert('Unable to reopen property')
      },
      success: function (xhr, data) {
        location.reload();
      }
  });
}
function deleteProperty(propertyId) {
  $.ajax({
      type: "DELETE",
      url: "/properties/" + propertyId,
      dataType: "json",
      error: function(xhr, status, error) {
        alert('Unable to delete property')
      },
      success: function (xhr, data) {
        location.href = "/";
      }
  });
}
function updateStatus(propertyId, newStatus) {
  $.ajax({
      type: "POST",
      url: "/update_status",
      data: 'new_status=' + newStatus + '&property_id=' + propertyId,
      dataType: "json",
      error: function(xhr, status, error) {
        alert('Unable to update status')
      },
      success: function (data, status, response) {
        note = JSON.parse(data["note"])
        var html = "<li id='nli-" + note["id"] + "'' class='" + note["note_type"] + "'>"
        html += note["formatted_date"] + " - "
        html += note["content"]
        html += "<span><img alt='Delete' class='delete_note' id='del-" + note["id"] + "' src='/assets/delete.png' width='14'></span></li>"

        $( "#accordian-notes-" + propertyId + " ul" ).prepend(html);                
        addDeleteFunction(note["id"]);
      }
  });
}
function updatePreferences(userId, overviewWeeks, expandNotes, images, showTodayOnly) {
  $.ajax({
      type: "POST",
      url: "/update_preferences",
      data: 'user_id=' + userId + '&overview_weeks=' + overviewWeeks + '&expand_notes=' + expandNotes + '&images=' + images + '&show_today_only=' + showTodayOnly,
      dataType: "json",
      error: function(xhr, status, error) {
        alert("Unable to update preferences - " + error)
      },
      success: function (data, status, response) {
        location.reload();
      }
  });
}
function updateAlert(id, read) {
  $.ajax({
      type: "PUT",
      url: "/alerts/" + id,
      data: 'read=' + read,
      dataType: "json",
      error: function(xhr, status, error) {
        alert("Unable to update alert");
      },
      success: function (data, status, response) {
        location.reload();
      }
  });
}
function readAllAlerts() {
  $.ajax({
      type: "POST",
      url: "/alerts/readall",
      dataType: "json",
      error: function(xhr, status, error) {
        alert("Unable to update alerts");
      },
      success: function (data, status, response) {
        location.reload();
      }
  });
}
function unreadAllAlerts() {
  $.ajax({
      type: "POST",
      url: "/alerts/unreadall",
      dataType: "json",
      error: function(xhr, status, error) {
        alert("Unable to update alerts");
      },
      success: function (data, status, response) {
        location.reload();
      }
  });
}
function deleteAllReadAlerts() {
  $.ajax({
      type: "POST",
      url: "/alerts/deleteread",
      dataType: "json",
      error: function(xhr, status, error) {
        alert("Unable to delete alerts");
      },
      success: function (data, status, response) {
        location.reload();
      }
  });
}
function deleteAllUnreadAlerts() {
  $.ajax({
      type: "POST",
      url: "/alerts/deleteunread",
      dataType: "json",
      error: function(xhr, status, error) {
        alert("Unable to delete alerts");
      },
      success: function (data, status, response) {
        location.reload();
      }
  });
}
