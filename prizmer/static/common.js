console.log("common.js loaded and executing."); // Added for debugging

// Variables     
var is_electric_monthly = 0;
var is_electric_daily = 1;
var is_electric_current = 0;
var is_electric_delta = 0;
var is_electric_period = 0;


// Variables End     
     
$(document).ready(function(){
var heat_dm_block_el = document.getElementById('heat_dm_block');
if (heat_dm_block_el) {
    heat_dm_block_el.style.display = 'none';
}  
    
// Loader 
hide_loader();
// Highlight active resource icon based on URL
    var path = window.location.pathname;
    if (path.includes("/askue/electric")) {
        var $el = $("#electric-ico").closest("a");
        $el.addClass("active-resource-icon");
    } else if (path.includes("/askue/water")) {
        var $el = $("#water-ico").closest("a");
        $el.addClass("active-resource-icon");
    } else if (path.includes("/askue/heat")) {
        var $el = $("#heat-ico").closest("a");
        $el.addClass("active-resource-icon");
    } else if (path.includes("/askue/economic")) {
        var $el = $("#economic-ico").closest("a");
        $el.addClass("active-resource-icon");
    }
// Loader End
$("#datepickerEnd").datepicker("setDate", new Date());
$("#tree").click(function clickTree(){
        refresh_data_table($("#choice_report").val());
        });
		
$(function () {
  $('[data-toggle="tooltip"]').tooltip()
})


// Меню выбора типа отчета
$("#choice_report").selectmenu({ width: 383 });
$("#choice_report").selectmenu({
     select: function( event, ui ) {
	 var electric_data_start_1 = $('#datepickerStart').datepicker().val();
     var electric_data_end_1 = $('#datepickerEnd').datepicker().val(); 
	 var obj_parent_title="";
	 var obj_title="";
	 var obj_key="";
	 
	 var node = $("#tree").fancytree("getActiveNode");
	     if(node){obj_title = escapeHtml(node.title);
              obj_key = node.key;
              obj_parent_title = escapeHtml(node.parent.title);}
                else{obj_title = "Не выбран";
                     obj_key = "Не выбран";
                     obj_parent_title = "Не выбран";}	
	
	if ($(this).val()==56 || $(this).val()==59)
    {
        var heat_dm_block_el = document.getElementById('heat_dm_block');
        if (heat_dm_block_el) {
		    heat_dm_block_el.style.display = 'block';
        }
	}
	else
	{
        var heat_dm_block_el = document.getElementById('heat_dm_block');
        if (heat_dm_block_el) {
    		heat_dm_block_el.style.display = 'none';
        }
	}
    if ($(this).val()%2==0)
    {
        $("#datepickerEnd").css('visibility', 'visible');
        $("#datepickerStart").css('visibility', 'hidden');
        		$("#export_report").html('<button type="button" class="btn btn-primary" onclick="window.location.href=\'../../report/'+$(this).val()+'?electric_data_end='+electric_data_end_1+'&electric_data_start='+electric_data_start_1+'&obj_key='+obj_key+'&is_electric_monthly='+is_electric_monthly+'&is_electric_daily='+is_electric_daily+'&is_electric_current='+is_electric_current+'&is_electric_delta='+is_electric_delta+'&is_electric_period='+is_electric_period+'&obj_parent_title='+obj_parent_title+'&obj_title='+obj_title+'\'">Экспорт</button>')		<!-- $("#export_report_archive").html('<a class="button" href ='+'"../../report/'+$(this).val()+'_arch"'+'>Экспорт в Архив</a>') -->
        refresh_data_table($(this).val());
    }
    else
    { //для нечётного отображаем 2 календарь
        $("#datepickerEnd").css('visibility', 'visible');
        $("#datepickerStart").css('visibility', 'visible');
        $("#title-date-start").show();
		
		
		<!-- $("#export_report").html('<a class="button" href ='+'"../../report/'+$(this).val()+'/"'+'>Экспорт</a>') -->
		<!-- $("#export_report").html('<a class="button" href ='+'"../../report/'+$(this).val()+'"'+'>Экспорт</a>') -->
        <!-- $("#export_report").html('<a class="button" href ='+'"../../report/'+$(this).val()+'?electric_data_end='+$('#datepickerEnd').datepicker().val()+'&electric_data_start='+$('#datepickerStart').datepicker().val()+'&test=Test'+'"'+'>Экспорт</a>') -->
<!-- 	$("#export_report").html('<a class="button" href ='+'"../../report/'+$(this).val()+'?electric_data_end='+electric_data_end+'&electric_data_start='+electric_data_start+'&test=Test'+'"'+'>Экспорт</a>') -->
		<!-- $("#export_report").html('<a class="button" href ='+'"../../report/'+$(this).val()+'?electric_data_end='+electric_data_end+'"'+'>Экспорт</a>') -->
		$("#export_report").html('<button type="button" class="btn btn-primary" onclick="window.location.href=\'../../report/'+$(this).val()+'?electric_data_end='+electric_data_end_1+'&electric_data_start='+electric_data_start_1+'&obj_key='+obj_key+'&is_electric_monthly='+is_electric_monthly+'&is_electric_daily='+is_electric_daily+'&is_electric_current='+is_electric_current+'&is_electric_delta='+is_electric_delta+'&is_electric_period='+is_electric_period+'&obj_parent_title='+obj_parent_title+'&obj_title='+obj_title+'\'">Экспорт</button>')
		<!-- $("#export_report_archive").html('<a class="button" href ='+'"../../report/'+$(this).val()+'_arch"'+'>Экспорт в Архив</a>') -->
        refresh_data_table($(this).val());
    }
        }   
    });
// конец Меню выбора отчета
// Set initial active state for toggle buttons
$("#electric-daily-button").addClass("active");
$("#electric-monthly-button").removeClass("active");

//замена спецсимволов
function escapeHtml(text) {
  var map = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#039;'
  };

  return text.replace(/[&<>"']/g, function(m) { return map[m]; });
}


//изменение дат в кнопке экспорт
$( "#tree" ).mouseleave(function() {
         var obj_parent_title="";
	     var obj_title="";
	     var obj_key="";	 
	     var node = $("#tree").fancytree("getActiveNode");
	     if(node){obj_title = escapeHtml(node.title);
              obj_key = node.key;
              obj_parent_title = escapeHtml(node.parent.title);}
                else{obj_title = "Не выбран";
                     obj_key = "Не выбран";
                     obj_parent_title = "Не выбран";}
		//console.log(obj_parent_title);
		//console.log(obj_title);
        var menuItem_1=$("#choice_report").val()		
        var electric_data_start_1 = $('#datepickerStart').datepicker().val();
        var electric_data_end_1 = $('#datepickerEnd').datepicker().val();  	
        <!-- $("#export_report").html('<a class="button" href ='+'"../../report/'+$(this).val()+'?electric_data_end='+electric_data_end+'"'+'>Экспорт</a>') -->
		$("#export_report").html('<button type="button" class="btn btn-primary" onclick="window.location.href=\'../../report/'+menuItem_1+'?electric_data_end='+electric_data_end_1+'&electric_data_start='+electric_data_start_1+'&obj_key='+obj_key+'&is_electric_monthly='+is_electric_monthly+'&is_electric_daily='+is_electric_daily+'&is_electric_current='+is_electric_current+'&is_electric_delta='+is_electric_delta+'&is_electric_period='+is_electric_period+'&obj_parent_title='+obj_parent_title+'&obj_title='+obj_title+'\'">Экспорт</button>')
});
$( "#datepickerStart" ).mouseleave(function() {
         var obj_parent_title="";
	     var obj_title="";
	     var obj_key="";	 
	     var node = $("#tree").fancytree("getActiveNode");
	     if(node){obj_title = escapeHtml(node.title);
              obj_key = node.key;
              obj_parent_title = escapeHtml(node.parent.title);}
                else{obj_title = "Не выбран";
                     obj_key = "Не выбран";
                     obj_parent_title = "Не выбран";}
		//console.log(obj_parent_title);
		//console.log(obj_title);
        var menuItem_1=$("#choice_report").val()		
        var electric_data_start_1 = $('#datepickerStart').datepicker().val();
        var electric_data_end_1 = $('#datepickerEnd').datepicker().val();  	
        <!-- $("#export_report").html('<a class="button" href ='+'"../../report/'+$(this).val()+'?electric_data_end='+electric_data_end+'"'+'>Экспорт</a>') -->
		$("#export_report").html('<button type="button" class="btn btn-primary" onclick="window.location.href=\'../../report/'+menuItem_1+'?electric_data_end='+electric_data_end_1+'&electric_data_start='+electric_data_start_1+'&obj_key='+obj_key+'&is_electric_monthly='+is_electric_monthly+'&is_electric_daily='+is_electric_daily+'&is_electric_current='+is_electric_current+'&is_electric_delta='+is_electric_delta+'&is_electric_period='+is_electric_period+'&obj_parent_title='+obj_parent_title+'&obj_title='+obj_title+'\'">Экспорт</button>')
});
$( "#datepickerEnd" ).mouseleave(function() {
         var obj_parent_title="";
	     var obj_title="";
	     var obj_key="";
         var menuItem_1=$("#choice_report").val();
		 var electric_data_start_1 = $('#datepickerStart').datepicker().val();
         var electric_data_end_1 = $('#datepickerEnd').datepicker().val();
	     var node = $("#tree").fancytree("getActiveNode");
	     if(node){obj_title = escapeHtml(node.title);
              obj_key = node.key;
              obj_parent_title = escapeHtml(node.parent.title);}
                else{obj_title = "Не выбран";
                     obj_key = "Не выбран";
                     obj_parent_title = "Не выбран";}
       <!-- $("#export_report").html('<a class="button" href ='+'"../../report/'+$(this).val()+'?electric_data_end='+electric_data_end+'"'+'>Экспорт</a>') -->
		$("#export_report").html('<button type="button" class="btn btn-primary" onclick="window.location.href=\'../../report/'+menuItem_1+'?electric_data_end='+electric_data_end_1+'&electric_data_start='+electric_data_start_1+'&obj_key='+obj_key+'&is_electric_monthly='+is_electric_monthly+'&is_electric_daily='+is_electric_daily+'&is_electric_current='+is_electric_current+'&is_electric_delta='+is_electric_delta+'&is_electric_period='+is_electric_period+'&obj_parent_title='+obj_parent_title+'&obj_title='+obj_title+'\'">Экспорт</button>')
		
});


$("#datepickerStart").css('visibility', 'hidden');
$("#datepickerEnd").css('visibility', 'hidden');

$("#datepickerStart").datepicker({onSelect:function(){refresh_data_table($("#choice_report").val())}}) 
$("#datepickerEnd").datepicker({onSelect:function(){refresh_data_table($("#choice_report").val())}})           
   $("#electric-monthly-button").click(function(){
        is_electric_monthly = 1;
        is_electric_daily = 0;
        is_electric_current = 0;
        is_electric_delta = 0;
        refresh_all();
        $("#electric-monthly-button").addClass("active");
        $("#electric-daily-button").removeClass("active");
        // The following lines are for other buttons, keep them for now if they are still relevant
        $("#electric-current-button").css( "color", "black" );
        $("#electric-delta").css( "color", "black" );      
        });
        
   $("#electric-daily-button").click(function(){
        is_electric_monthly = 0;
        is_electric_daily = 1;
        is_electric_current = 0;
        is_electric_delta = 0;
        refresh_all();
        $("#electric-daily-button").addClass("active");
        $("#electric-monthly-button").removeClass("active");
        // The following lines are for other buttons, keep them for now if they are still relevant
        $("#electric-current-button").css( "color", "black" );
        $("#electric-delta").css( "color", "black" );
        });
        
   $("#electric-current-button").click(function(){
        is_electric_monthly = 0;
        is_electric_daily = 0;
        is_electric_current = 1;
        is_electric_delta = 0;
        refresh_all();
       /*  ${"$"}(#"datepickerStart")'.css('visibility', 'hidden');
        $("#title-date-start").hide(); */
        $("#electric-monthly-button").css( "color", "black" );
        $("#electric-daily-button").css( "color", "black" );
        $("#electric-current-button").css( "color", "green" );
        $("#electric-delta").css( "color", "black" );
        });
        
    $("#electric-delta").click(function(){
        is_electric_monthly = 0;
        is_electric_daily = 0;
        is_electric_current = 0;
        is_electric_delta = 1;
        refresh_all();
        $("#datepickerStart").css('visibility', 'visible');
        $("#title-date-start").show();
        $("#electric-monthly-button").css( "color", "black" );
        $("#electric-daily-button").css( "color", "black" );
        $("#electric-current-button").css( "color", "black" );
        $("#electric-delta").css( "color", "green" );
        });

       $("input").click(function(){
        is_electric_period = $( "input:checked" ).val();
        
        if (is_electric_period == 0){ 
            $("#datepickerStart").css('visibility', 'hidden');
            $("#title-date-start").hide(); }      
        else {                $("#datepickerStart").css('visibility', 'visible');
               $("#title-date-start").show(); }
        refresh_all();
        });
        
    $("#electric-mnemoschema").click(function(){
        refresh_data_table_viz_new_window();
    });

 });
 
    
function logEvent(event, data, msg){
   var args = $.isArray(args) ? args.join(", ") :
msg = msg ? ": " + msg : "";
// $.ui.fancytree.info("Event('" + event.type + "', node=" + data.node + ")" + msg); // Disabled Fancytree logging
}
    
	
    $(function(){ 
	var pre_url=window.location.pathname
	//console.log(pre_url)
        $("#tree").fancytree({
		//var pathname = window.location.pathname;
		 source: {		   
           url: "/askue/tree_data/",
           data: {preurl: window.location.pathname}		   
         }, 
        
        blurTree: function(event, data) {
        logEvent(event, data);
      },
      create: function(event, data) {
        logEvent(event, data);
      },
      init: function(event, data, flag) {
        logEvent(event, data, "flag=" + flag);
      },
      focusTree: function(event, data) {
        logEvent(event, data);
      },
      // Node events
      activate: function(event, data) {
        logEvent(event, data);
        var node = data.node;
        // acces node attributes
        $("#my-object-jquery").val(node.title);
        if( !$.isEmptyObject(node.data) ){
//          alert("custom node data: " + JSON.stringify(node.data));
        }
      },
      beforeActivate: function(event, data) {
        logEvent(event, data, "current state=" + data.node.isActive());
        // return false to prevent default behavior (i.e. activation)
//              return false;
      },
      beforeExpand: function(event, data) {
        logEvent(event, data, "current state=" + data.node.isExpanded());
        // return false to prevent default behavior (i.e. expanding or collapsing)
//        return false;
      },
      beforeSelect: function(event, data) {
//        console.log("select", event.originalEvent);
        logEvent(event, data, "current state=" + data.node.isSelected());
        // return false to prevent default behavior (i.e. selecting or deselecting)
//        if( data.node.isFolder() ){
//          return false;
//        }
      },
      blur: function(event, data) {
        logEvent(event, data);
        $("#echoFocused").text("-");
      },
      click: function(event, data) {
        logEvent(event, data, ", targetType=" + data.targetType);
        // return false to prevent default behavior (i.e. activation, ...)
        //return false;
      },
      collapse: function(event, data) {
        logEvent(event, data);
      },
      createNode: function(event, data) {
        // Optionally tweak data.node.span or bind handlers here
        logEvent(event, data);
      },
      dblclick: function(event, data) {
        logEvent(event, data);
//        data.node.toggleSelect();
      },
      deactivate: function(event, data) {
        logEvent(event, data);
        $("#echoActive").text("-");
      },
      expand: function(event, data) {
        logEvent(event, data);
      },

      select: function(event, data) {
        logEvent(event, data, "current state=" + data.node.isSelected());
        var s = data.tree.getSelectedNodes().join(", ");
        $("#echoSelected").text(s);
      }
    }).bind("fancytreeactivate", function(event, data){
      // alternative way to bind to 'activate' event
//        logEvent(event, data);
    });

    });
var refresh_data_table = function(xyz){
    setTimeout(function() {
     var electric_data_start = $('#datepickerStart').datepicker().val();
     var electric_data_end = $('#datepickerEnd').datepicker().val();
	 <!-- $("#export_report").html('<a class="button" href ='+'"../../report/'+$(this).val()+'?electric_data_end='+electric_data_end+'&electric_data_start='+electric_data_start+'&test=Test'+'"'+'>Экспорт</a>') -->
     var node = $("#tree").fancytree("getActiveNode");
	     if(node){obj_title = node.title;
              obj_key = node.key;
              obj_parent_title = node.parent.title;}
                else{obj_title = "Не выбран";
                     obj_key = "Не выбран";
                     obj_parent_title = "Не выбран";}
					 
	 if(obj_key.indexOf('meter') + 1) {
		 //console.log(obj_key, 'is meter level')
		 my_url = "/askue/meter_info";}
	 else {
		 my_url = "/askue/"+xyz;}
		

	 	 $.ajax({
		

	 		type: "GET",
		

	 		url:  my_url,
		

	 		beforeSend: function(){
		


		


		

	             show_loader();
		

	         },
		

	 		data: {obj_parent_title:obj_parent_title, obj_key: obj_key, obj_title: obj_title, is_electric_monthly: is_electric_monthly, is_electric_daily: is_electric_daily, is_electric_current: is_electric_current,  is_electric_delta: is_electric_delta, is_electric_period:is_electric_period, electric_data_start: electric_data_start, electric_data_end: electric_data_end},
		

	 	   })
		

	      .done(function( msg ) {
		

	         $('#data-table').html(msg); // Пишем в div ответ от страницы /askue/?номер отчёта
		

	             hide_loader();
		

	         })
		

	      .fail(function(jqXHR, textStatus, errorThrown) {
		

	         console.error("AJAX Request Failed:", textStatus, errorThrown);
		

	         hide_loader();
		

	      });
  });
};
//--------------------------------------------------

var refresh_data_table_viz = function(){
     $.ajax({
        type: "GET",
        url: "/viz/test3",
       })
     
     .done(function( msg_viz ) {
        $('#data-table').html(msg_viz); // Пишем в div ответ от страницы /askue/?номер отчёта
        });
  };
  
var refresh_data_table_viz_new_window = function(){
    window.open('/viz/energo_schema', '_blank');
  };

//----------------------------------------------------  

var refresh_all = function(){
        refresh_data_table($("#choice_report").val());
    };

var show_loader = function(){
    $("#fadingBarsG_1").show();
    $("#fadingBarsG_2").show();
    $("#fadingBarsG_3").show();
    $("#fadingBarsG_4").show();
    $("#fadingBarsG_5").show();
    $("#fadingBarsG_6").show();
    $("#fadingBarsG_7").show();
    $("#fadingBarsG_8").show();
    };
    
var hide_loader = function(){
    $("#fadingBarsG_1").hide();
    $("#fadingBarsG_2").hide();
    $("#fadingBarsG_3").hide();
    $("#fadingBarsG_4").hide();
    $("#fadingBarsG_5").hide();
    $("#fadingBarsG_6").hide();
    $("#fadingBarsG_7").hide();
    $("#fadingBarsG_8").hide();
    };
    
 $(function() {
    $( "#datepickerStart" ).datepicker({ dateFormat: 'dd.mm.yy', defaultDate:+0 });
    $( "#datepickerEnd" ).datepicker({ dateFormat: 'dd.mm.yy', defaultDate:+0 });
    $("#QQQ").monthpicker();
  });
 
//Загрузка комментариев
var LoadComments = function(){
    //console.log($(this).attr('id'))
	var row = document.getElementById($(this).attr('id'));
	var guid_abonents=$(this).attr('id');
	var resource = row.dataset.resource;
	$.ajax({
		type: "GET",
        url: "../../askue/comment",
		data: {
			'id':guid_abonents,
			'resource':resource,			
		},
		dataType: "html",
        cache: false,
		success:function(data) {
		event.preventDefault();
		$('#overlay').fadeIn(400, // снaчaлa плaвнo пoкaзывaем темную пoдлoжку
		 	function(){ // пoсле выпoлнения предъидущей aнимaции
				$('#comment-block') 
					.css('display', 'block') // убирaем у мoдaльнoгo oкнa display: none;
					.animate({opacity: 1, top: '50%'}, 200); // плaвнo прибaвляем прoзрaчнoсть oднoвременнo сo съезжaнием вниз
		});
        $("#comment-block").html(data); // Пишем в div ответ от страницы 
       	
        }		
	});	

	/* Зaкрытие мoдaльнoгo oкнa, тут делaем тo же сaмoе нo в oбрaтнoм пoрядке */
	$('#modal_close, #overlay').click( function(){ // лoвим клик пo крестику или пoдлoжке
		$('#comment-block')
			.animate({opacity: 0, top: '45%'}, 200,  // плaвнo меняем прoзрaчнoсть нa 0 и oднoвременнo двигaем oкнo вверх
				function(){ // пoсле aнимaции
					$(this).css('display', 'none'); // делaем ему display: none;
					$('#overlay').fadeOut(400); // скрывaем пoдлoжку
				}
			);
	});
	
};


//Загрузка комментариев
var AddComments = function(){
//console.log($(this).attr('id'));
var row = document.getElementById($(this).attr('id'));
var guid_abonents=$(this).attr('id');
var resource = row.dataset.resource;

	$.ajax({
		type: "GET",
        url: "../../askue/add_comment/",		
		data: {
			'id':guid_abonents,	
			'resource':resource,			
		},
		dataType: "html",
        cache: false,
		success:function(data) {
		event.preventDefault();
		$('#overlay').fadeIn(400, // снaчaлa плaвнo пoкaзывaем темную пoдлoжку
		 	function(){ // пoсле выпoлнения предъидущей aнимaции
				$('#comment-block') 
					.css('display', 'block') // убирaем у мoдaльнoгo oкнa display: none;
					.animate({opacity: 1, top: '50%'}, 200); // плaвнo прибaвляем прoзрaчнoсть oднoвременнo сo съезжaнием вниз
		});
        $("#comment-block").html(data); // Пишем в div ответ от страницы 
       	
        }		
	});	
	     
	/* Зaкрытие мoдaльнoгo oкнa, тут делaем тo же сaмoе нo в oбрaтнoм пoрядке */
	$('#modal_close, #overlay').click( function(){ // лoвим клик пo крестику или пoдлoжке
		$('#comment-block')
			.animate({opacity: 0, top: '45%'}, 200,  // плaвнo меняем прoзрaчнoсть нa 0 и oднoвременнo двигaем oкнo вверх
				function(){ // пoсле aнимaции
					$(this).css('display', 'none'); // делaем ему display: none;
					$('#overlay').fadeOut(400); // скрывaем пoдлoжку
				}
			);
	});
	
};


var LoadExtendedInfo = function(){
	/*console.log('LoadExtendedInfo')*/
    /* console.log($(this).attr('id')) */
	var row = document.getElementById($(this).attr('id'));
	/* console.log(row.dataset.dateStart, row.dataset.dateEnd) */
	$.ajax({
		type: "GET",
        url: "../../askue/extended_info",
		data: {
			'id':$(this).attr('id'),
			'electric_data_start':row.dataset.dateStart,
			'electric_data_end':row.dataset.dateEnd,
			'obj_title':row.dataset.abonent,
			'obj_parent_title':row.dataset.object,
			'mini':row.dataset.limitMini,
			'maxi':row.dataset.limitMaxi,
		},
		dataType: "html",
        cache: false,
		success:function(data) {
		event.preventDefault();
		$('#overlay').fadeIn(400, // снaчaлa плaвнo пoкaзывaем темную пoдлoжку
		 	function(){ // пoсле выпoлнения предъидущей aнимaции
				$('#extended-info') 
					.css('display', 'block') // убирaем у мoдaльнoгo oкнa display: none;
					.animate({opacity: 1, top: '50%'}, 200); // плaвнo прибaвляем прoзрaчнoсть oднoвременнo сo съезжaнием вниз
		});
        $("#extended-info").html(data); // Пишем в div ответ от страницы 
       	
        }		
	});	

	/* Зaкрытие мoдaльнoгo oкнa, тут делaем тo же сaмoе нo в oбрaтнoм пoрядке */
	$('#modal_close, #overlay').click( function(){ // лoвим клик пo крестику или пoдлoжке
		$('#extended-info')
			.animate({opacity: 0, top: '45%'}, 200,  // плaвнo меняем прoзрaчнoсть нa 0 и oднoвременнo двигaем oкнo вверх
				function(){ // пoсле aнимaции
					$(this).css('display', 'none'); // делaем ему display: none;
					$('#overlay').fadeOut(400); // скрывaем пoдлoжку
				}
			);
	});
	
};

//Удаление комментариев
var DelComments = function(){
var guid_comment=$(this).attr('id');
	$.ajax({
		type: "GET",
        url: "../../askue/del_comment/",		
		data: {
			'id':guid_comment,			
		},
		dataType: "html",
        cache: false,
		success:function(data) {
			/* Зaкрытие мoдaльнoгo oкнa, тут делaем тo же сaмoе нo в oбрaтнoм пoрядке */		
			$('#comment-block')
				.animate({opacity: 0, top: '45%'}, 200,  // плaвнo меняем прoзрaчнoсть нa 0 и oднoвременнo двигaем oкнo вверх
					function(){ // пoсле aнимaции
						$(this).css('display', 'none'); // делaем ему display: none;
						$('#overlay').fadeOut(400); // скрывaем пoдлoжку
					}
				);
		refresh_all();
        //$("#comment-block").html(data); // Пишем в div ответ от страницы 
       	//alert(data);
		
		
        }		
	});	
	     
};












