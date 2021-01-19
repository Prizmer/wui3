// Variables     
var is_electric_monthly = 0;
var is_electric_daily = 1;
var is_electric_current = 0;
var is_electric_delta = 0;
var is_electric_period = 0;


// Variables End     
     
$(document).ready(function(){

    
// Loader 
hide_loader();
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
	
    if ($(this).val()%2==0)
    { //для чётного отображаем 1 календаря
        $("#datepickerEnd").show();
        $("#datepickerStart").hide();
        $("#title-date-start").hide();
		
		<!-- $("#export_report").html('<a class="button" href ='+'"../../report/'+$(this).val()+'?electric_data_end='+$('#datepickerEnd').datepicker().val()+'&electric_data_start='+$('#datepickerStart').datepicker().val()+'"'+'>Экспорт</a>') -->
        <!-- $("#export_report").html('<a class="button" href ='+'"../../report/'+$(this).val()+'?electric_data_end='+electric_data_end+'"'+'>Экспорт</a>') -->
		$("#export_report").html('<a class="button" href ='+'"../../report/'+$(this).val()+'?electric_data_end='+electric_data_end_1+'&electric_data_start='+electric_data_start_1+'&obj_key='+obj_key+'&is_electric_monthly='+is_electric_monthly+'&is_electric_daily='+is_electric_daily+'&is_electric_current='+is_electric_current+'&is_electric_delta='+is_electric_delta+'&is_electric_period='+is_electric_period+'&obj_parent_title='+obj_parent_title+'&obj_title='+obj_title+'"'+'>Экспорт</a>')
		<!-- $("#export_report_archive").html('<a class="button" href ='+'"../../report/'+$(this).val()+'_arch"'+'>Экспорт в Архив</a>') -->
        refresh_data_table($(this).val());
    }
    else
    { //для нечётного отображаем 2 календарь
        $("#datepickerEnd").show();
        $("#datepickerStart").show();
        $("#title-date-start").show();
		
		
		<!-- $("#export_report").html('<a class="button" href ='+'"../../report/'+$(this).val()+'/"'+'>Экспорт</a>') -->
		<!-- $("#export_report").html('<a class="button" href ='+'"../../report/'+$(this).val()+'"'+'>Экспорт</a>') -->
        <!-- $("#export_report").html('<a class="button" href ='+'"../../report/'+$(this).val()+'?electric_data_end='+$('#datepickerEnd').datepicker().val()+'&electric_data_start='+$('#datepickerStart').datepicker().val()+'&test=Test'+'"'+'>Экспорт</a>') -->
<!-- 	$("#export_report").html('<a class="button" href ='+'"../../report/'+$(this).val()+'?electric_data_end='+electric_data_end+'&electric_data_start='+electric_data_start+'&test=Test'+'"'+'>Экспорт</a>') -->
		<!-- $("#export_report").html('<a class="button" href ='+'"../../report/'+$(this).val()+'?electric_data_end='+electric_data_end+'"'+'>Экспорт</a>') -->
		$("#export_report").html('<a class="button" href ='+'"../../report/'+$(this).val()+'?electric_data_end='+electric_data_end_1+'&electric_data_start='+electric_data_start_1+'&obj_key='+obj_key+'&is_electric_monthly='+is_electric_monthly+'&is_electric_daily='+is_electric_daily+'&is_electric_current='+is_electric_current+'&is_electric_delta='+is_electric_delta+'&is_electric_period='+is_electric_period+'&obj_parent_title='+obj_parent_title+'&obj_title='+obj_title+'"'+'>Экспорт</a>')
		<!-- $("#export_report_archive").html('<a class="button" href ='+'"../../report/'+$(this).val()+'_arch"'+'>Экспорт в Архив</a>') -->
        refresh_data_table($(this).val());
    }
        }   
    });
// конец Меню выбора отчета
// Подкрашиваем зеленым "На начало суток"
$("#electric-daily-button").css("background-color", "#E6F7F2");
$("#electric-daily-button").css("border", "3px solid rgba(132,159,187,1)");
$("#electric-monthly-button").css("border", "2px solid rgba(132,159,187,1)");
$("#electric-monthly-button").css("background-color", "#D8E2EC");
$("#electric-monthly-button").css("color", "grey");

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
		$("#export_report").html('<a class="button" href ='+'"../../report/'+menuItem_1+'?electric_data_end='+electric_data_end_1+'&electric_data_start='+electric_data_start_1+'&obj_key='+obj_key+'&is_electric_monthly='+is_electric_monthly+'&is_electric_daily='+is_electric_daily+'&is_electric_current='+is_electric_current+'&is_electric_delta='+is_electric_delta+'&is_electric_period='+is_electric_period+'&obj_parent_title='+obj_parent_title+'&obj_title='+obj_title+'"'+'>Экспорт</a>')
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
		$("#export_report").html('<a class="button" href ='+'"../../report/'+menuItem_1+'?electric_data_end='+electric_data_end_1+'&electric_data_start='+electric_data_start_1+'&obj_key='+obj_key+'&is_electric_monthly='+is_electric_monthly+'&is_electric_daily='+is_electric_daily+'&is_electric_current='+is_electric_current+'&is_electric_delta='+is_electric_delta+'&is_electric_period='+is_electric_period+'&obj_parent_title='+obj_parent_title+'&obj_title='+obj_title+'"'+'>Экспорт</a>')
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
		$("#export_report").html('<a class="button" href ='+'"../../report/'+menuItem_1+'?electric_data_end='+electric_data_end_1+'&electric_data_start='+electric_data_start_1+'&obj_key='+obj_key+'&is_electric_monthly='+is_electric_monthly+'&is_electric_daily='+is_electric_daily+'&is_electric_current='+is_electric_current+'&is_electric_delta='+is_electric_delta+'&is_electric_period='+is_electric_period+'&obj_parent_title='+obj_parent_title+'&obj_title='+obj_title+'"'+'>Экспорт</a>')
		
});


// Убираем календари при загрузке страницы
$("#datepickerStart").hide();
$("#datepickerEnd").hide();

$("#datepickerStart").datepicker({onSelect:function(){refresh_data_table($("#choice_report").val())}}) 
$("#datepickerEnd").datepicker({onSelect:function(){refresh_data_table($("#choice_report").val())}})           
   $("#electric-monthly-button").click(function(){
        is_electric_monthly = 1;
        is_electric_daily = 0;
        is_electric_current = 0;
        is_electric_delta = 0;
        refresh_all();
       /*  $("#datepickerStart").hide();
        $("#title-date-start").hide(); */
        $("#electric-monthly-button").css("background-color", "#E6F7F2");
		$("#electric-monthly-button").css("border", "3px solid rgba(132,159,187,1)");
		$("#electric-daily-button").css("border", "2px solid rgba(132,159,187,1)");
		$("#electric-daily-button").css("background-color", "#D8E2EC");
		$("#electric-daily-button").css("color", "grey");
		
		
        $("#electric-current-button").css( "color", "black" );
        $("#electric-delta").css( "color", "black" );      
        });
        
   $("#electric-daily-button").click(function(){
        is_electric_monthly = 0;
        is_electric_daily = 1;
        is_electric_current = 0;
        is_electric_delta = 0;
        refresh_all();
        /* $("#datepickerStart").hide();
        $("#title-date-start").hide(); */
		$("#electric-daily-button").css("background-color", "#E6F7F2");
		$("#electric-daily-button").css("border", "3px solid rgba(132,159,187,1)");
		$("#electric-monthly-button").css("border", "2px solid rgba(132,159,187,1)");
		$("#electric-monthly-button").css("background-color", "#D8E2EC");
		$("#electric-monthly-button").css("color", "grey");
		
		
       
        $("#electric-current-button").css( "color", "black" );
        $("#electric-delta").css( "color", "black" );
        });
        
   $("#electric-current-button").click(function(){
        is_electric_monthly = 0;
        is_electric_daily = 0;
        is_electric_current = 1;
        is_electric_delta = 0;
        refresh_all();
       /*  $("#datepickerStart").hide();
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
        $("#datepickerStart").show();
        $("#title-date-start").show();
        $("#electric-monthly-button").css( "color", "black" );
        $("#electric-daily-button").css( "color", "black" );
        $("#electric-current-button").css( "color", "black" );
        $("#electric-delta").css( "color", "green" );
        });

       $("input").click(function(){
        is_electric_period = $( "input:checked" ).val();
        
        if (is_electric_period == 0){ 
            $("#datepickerStart").hide();
            $("#title-date-start").hide(); }      
        else { $("#datepickerStart").show();
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
    $.ui.fancytree.info("Event('" + event.type + "', node=" + data.node + ")" + msg);
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
		beforeSend: function(){show_loader();},
		data: {obj_parent_title:obj_parent_title, obj_key: obj_key, obj_title: obj_title, is_electric_monthly: is_electric_monthly, is_electric_daily: is_electric_daily, is_electric_current: is_electric_current,  is_electric_delta: is_electric_delta, is_electric_period:is_electric_period, electric_data_start: electric_data_start, electric_data_end: electric_data_end},
	   })
	 
     

	 
     .done(function( msg ) {
        $('#data-table').html(msg); // Пишем в div ответ от страницы /askue/?номер отчёта
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
console.log('!!!!!!!!!', resource);
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