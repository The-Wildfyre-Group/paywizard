// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.remotipart

	
// common functions 
//= require altair/common.min

// uikit functions
//= require altair/uikit_custom.min

//= require parsley
//= require dropzone
		

// altair common functions/helpers
//= require altair/altair_admin_common.min
//= require altair/pages/login.min

//  help/faq functions -->
//= require altair/pages/page_help.min

// page specific plugins
//= require d3/d3.min
//= require metrics-graphics/dist/metricsgraphics.min
//= require chartist/dist/chartist.min
//= require maplace.js/src/maplace-0.1.3
//= require d3/d3.min

// peity (small charts) -->
//= require peity/jquery.peity.min
// easy-pie-chart (circular statistics) -->
//= require jquery.easy-pie-chart/dist/jquery.easypiechart.min
// countUp -->
//= require countUp.js/countUp.min
// handlebars.js -->
//= require handlebars/handlebars.min
//= require altair/custom/handlebars_helpers.min
// CLNDR -->
//= require clndr/src/clndr
// fitvids -->
//= require fitvids/jquery.fitvids

//  dashbord functions -->
//= require altair/pages/dashboard.min

// ionrangeslider -->
//= require ionrangeslider/js/ion.rangeSlider.min
// htmleditor (codeMirror) -->
//= require altair/uikit_htmleditor_custom.min
// inputmask-->
//= require jquery.inputmask/dist/jquery.inputmask.bundle.min

// tablesorter -->
//= require jquery.tablesorter/dist/js/jquery.tablesorter.min
//= require jquery.tablesorter/dist/js/jquery.tablesorter.widgets.min
//= require jquery.tablesorter/dist/js/widgets/widget-alignChar.min
//= require jquery.tablesorter/addons/pager/jquery.tablesorter.pager

// kendo UI -->
//= require altair/kendoui_custom.min

//  tablesorter functions -->
//= require altair/pages/plugins_tablesorter.min

//= require magnific-popup/dist/jquery.magnific-popup.min
//= require altair/custom/uikit_fileinput.min

// user profile functions
//= require altair/pages/page_user_profile.min


// user edit functions
// require altair/pages/page_user_edit.min

// forms advanced functions -->
//= require altair/pages/forms_advanced

// forms kendoui functions  -->
//= require altair/pages/kendoui.min

// user contact list -->
//= require altair/pages/page_contact_list.min

//  forms_file_upload functions -->
//= require altair/pages/forms_file_upload.min

// MUST GO AFTER "forms_advanced.min"

// jquery steps -->
//= require altair/custom/wizard_steps.min

// file input -->
//= require altair/custom/uikit_fileinput.min

// forms wizard functions -->
//= require altair/pages/forms_wizard.min

// forms notes functions -->
//= require altair/pages/page_notes.min


   

// google web fonts
WebFontConfig = {
    google: {
        families: [
            'Source+Code+Pro:400,700:latin',
            'Roboto:400,300,500,700,400italic:latin'
        ]
    }
};
(function() {
    var wf = document.createElement('script');
    wf.src = ('https:' == document.location.protocol ? 'https' : 'http') +
    '://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js';
    wf.type = 'text/javascript';
    wf.async = 'true';
    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(wf, s);
})();
    
    
//  user profile functions
$(function() {
    // enable hires images
    altair_helpers.retina_images();
    // fastClick (touch devices)
    if(Modernizr.touch) {
        FastClick.attach(document.body);
    }
});

// $(document).click(function(event) {
// 	var ClickedVariable = $(event.target).text();
// 	if (ClickedVariable == "About") {
// 		$('#masonry-about-tab').load(document.URL +  ' #masonry-about-tab');
// 	}
// });
   
   
// $(function () {
//     var whitelist = ["xls", "xlsx", "csv"];
//     $('#file-field').on('change.bs.fileinput', function() {
//       var ext = $('#file-field').val().split('.').pop().toLowerCase();
//       var extensionisgood = (whitelist.indexOf(ext) > -1);
//       if (extensionisgood) {
//           $('#file-submit').removeAttr('disabled');
//           $('#invalid-message').hide()
//
//       } else {
//           $('#file-submit').attr('disabled', true);
//           $('#file-field').val("")
//           $('#invalid-message').css({ display: "block" });
//       }
//     });
// });



