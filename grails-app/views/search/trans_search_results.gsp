<%@ page contentType="text/html;charset=UTF-8" %>

<html>
  <head>
    <meta name='layout' content='main'/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>${grailsApplication.config.projectID} search results</title>
    <parameter name="search" value="selected"></parameter>   
    <script src="${resource(dir: 'js', file: 'DataTables-1.9.0/media/js/jquery.dataTables.js')}" type="text/javascript"></script>
    <script src="${resource(dir: 'js', file: 'TableTools-2.0.2/media/js/TableTools.js')}" type="text/javascript"></script>
    <script src="${resource(dir: 'js', file: 'TableTools-2.0.2/media/js/ZeroClipboard.js')}" type="text/javascript"></script>
    <style type="text/css">
            @import "${resource(dir: 'js', file: 'DataTables-1.9.0/media/css/demo_page.css')}";
            @import "${resource(dir: 'js', file: 'DataTables-1.9.0/media/css/demo_table.css')}";
            @import "${resource(dir: 'js', file: 'TableTools-2.0.2/media/css/TableTools.css')}";
    </style>

    <script type="text/javascript">
        /* new sorting functions */
        jQuery.fn.dataTableExt.oSort['scientific-asc']  = function(a,b) {
        	var x = parseFloat(a);
        	var y = parseFloat(b);
        	return ((x < y) ? -1 : ((x > y) ?  1 : 0));
        };
 
        jQuery.fn.dataTableExt.oSort['scientific-desc']  = function(a,b) {
        	var x = parseFloat(a);
        	var y = parseFloat(b);
        	return ((x < y) ? 1 : ((x > y) ?  -1 : 0));
        };
    </script> 
    <script>
    function get_table_data(){
    	//alert(${annoType})
    	var table_scrape = [];
    	var rowNum
    	var regex
    	if (${annoType} === 1){ 
	    	var oTableData = document.getElementById('table_data');
	    	rowNum = 1
	    }else if (${annoType} === 2){ 
	    	var oTableData = document.getElementById('func_table_data');
	    	rowNum = 0
	    }else if (${annoType} === 3){ 
	    	var oTableData = document.getElementById('ipr_table_data');
	    	rowNum = 0
	    }
	    //gets table
	    var rowLength = oTableData.rows.length;
	    //gets rows of table
	    for (i = 0; i < rowLength; i++){
	    //loops through rows
	       var oCells = oTableData.rows.item(i).cells;
	       var cellVal = oCells.item(rowNum).innerHTML;
	       var matcher = cellVal.match(/.*?contig_id=(.*?)"\starget.*/);
	       if (matcher){
	       	  	table_scrape.push(matcher[1])
	    	}
	    }
	    document.getElementById('fileId').value=table_scrape;
	    //alert(table_scrape)
    }
    </script>
    <script>
    
    <% 
    def jsonData = results.encodeAsJSON(); 
    %>

    </script>
    <script>
 
  $(document).ready(function() {
 
  var anOpen = [];
  var sImageUrl = "${resource(dir: 'js', file: 'DataTables-1.9.0/examples/examples_support/')}";
     
	  if (${annoType} === 1){ 
		var oTable = $('#table_data').dataTable( {
			"bProcessing": true,
			"aaData": ${jsonData},
			"aoColumns": [
				{
				   "mDataProp": null,
				   "sClass": "control center",
				   "sDefaultContent": '<img src="'+sImageUrl+'details_open.png'+'">'
				},
				{ "mDataProp": "contig_id",
				"fnRender": function ( oObj, sVal ){
					return "<a href=\"trans_info?contig_id="+oObj.aData["contig_id"]+ "\"target='_blank'>"+sVal+"</a>";
				}},
				{ "mDataProp": "anno_db" },
				{ "mDataProp": "anno_id" },
				{ "mDataProp": "descr"},
				{ "mDataProp": "score"},
			],
			"sPaginationType": "full_numbers",
				"iDisplayLength": 10,
				"aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
				"oLanguage": {
						 "sSearch": "Filter records:"
				 },
				"aaSorting": [[ 5, "desc" ]],
				"sDom": 'T<"clear">lfrtip',
				"oTableTools": {
				"sSwfPath": "${resource(dir: 'js', file: 'TableTools-2.0.2/media/swf/copy_cvs_xls_pdf.swf')}"
				}
		} );
		
	   
	  $('#table_data td.control').live( 'click', function () {
	  var nTr = this.parentNode;
	  var i = $.inArray( nTr, anOpen );
	   
	  if ( i === -1 ) {
		$('img', this).attr( 'src', sImageUrl+"details_close.png" );
		var nDetailsRow = oTable.fnOpen( nTr, fnFormatDetails(oTable, nTr), 'details' );
		$('div.innerDetails', nDetailsRow).slideDown();
		anOpen.push( nTr );
	  }
	  else {
		$('img', this).attr( 'src', sImageUrl+"details_open.png" );
		$('div.innerDetails', $(nTr).next()[0]).slideUp( function () {
		  oTable.fnClose( nTr );
		  anOpen.splice( i, 1 );
		} );
	  }
	} );
	 
	function fnFormatDetails( oTable, nTr )
	{
	  var oData = oTable.fnGetData( nTr );
	  var sOut =
		'<div class="innerDetails">'+
		'<div class="blast_res">'+
		  '<table width="100%" cellpadding="5" cellspacing="0" border="0" style="table-layout:fixed; padding-left:10px; overflow:auto;">'+
			'<tr><td><b>Alignment info:</b> Length='+oData.align+' Gaps='+oData.gaps+' Identity='+oData.identity+'</td></tr>'+
			'<tr><td><b>'+oData.contig_id+'</b> '+oData.anno_start+' '+oData.anno_stop+'</td></tr>'+
			'<tr><td>'+oData.qseq+'</td></tr>'+
			'<tr><td>'+oData.midline+'</td></tr>'+
			'<tr><td>'+oData.hseq+'</td></tr>'+
			'<tr><td><b>'+oData.anno_id+'</b> '+oData.hit_start+' '+oData.hit_stop+'</td></tr>'+
		  '</table>'+
		'</div>'+  
		'</div>';
	   //alert(sOut)
	  return sOut;
	}
  }else if (${annoType} === 2){
  //for func annotations  
	var iprTable = $('#func_table_data').dataTable( {
        "bProcessing": true,
        "aaData": ${jsonData},
        "aoColumns": [
          	{ "mDataProp": "contig_id",
				"fnRender": function ( oObj, sVal ){
					return "<a href=\"trans_info?contig_id="+oObj.aData["contig_id"]+ "\"target='_blank'>"+sVal+"</a>";
			}},
            { "mDataProp": "anno_db" },
            { "mDataProp": "anno_id" },
            { "mDataProp": "descr"},
            { "mDataProp": "score"},
        ],
        "sPaginationType": "full_numbers",
    		"iDisplayLength": 10,
    		"aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
    	    "oLanguage": {
    	     	     "sSearch": "Filter records:"
    	     },
    	    "aaSorting": [[ 4, "desc" ]], 
    	    "sDom": 'T<"clear">lfrtip',
            "oTableTools": {
        	"sSwfPath": "${resource(dir: 'js', file: 'TableTools-2.0.2/media/swf/copy_cvs_xls_pdf.swf')}"
            }
    	} 	);
	}else if (${annoType} === 3){
	  //for interproscan and it's evalue sorting
		var iprTable = $('#ipr_table_data').dataTable( {
			"bProcessing": true,
			"aaData": ${jsonData},
			"aoColumns": [
				{ "mDataProp": "contig_id",
				"fnRender": function ( oObj, sVal ){
					return "<a href=\"trans_info?contig_id="+oObj.aData["contig_id"]+ "\"target='_blank'>"+sVal+"</a>";
				}},
				{ "mDataProp": "anno_db" },
				{ "mDataProp": "anno_id" ,
				"fnRender": function ( oObj, sVal ){
					var splitter = sVal.split(" ");
					if (splitter[0].match(/IPR/g)){ 
						return "<a href=\"http://www.ebi.ac.uk/interpro/IEntry?ac="+splitter[0]+ "\"target='_blank'>"+splitter[0]+"</a>: "+splitter[2]+"";
					}else{
						return "<a href=\"http://www.ebi.ac.uk/QuickGO/GTerm?id="+sVal+ "\"target='_blank'>"+sVal+"</a>";
					}
				}},
				{ "mDataProp": "descr"},
				{ "mDataProp": "score", "sType": "scientific"},
			],
			"sPaginationType": "full_numbers",
			"iDisplayLength": 10,
			"aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
			"oLanguage": {
					 "sSearch": "Filter records:"
			 },
			"aaSorting": [[ 4, "asc" ]],
			"sDom": 'T<"clear">lfrtip',
			"oTableTools": {
			"sSwfPath": "${resource(dir: 'js', file: 'TableTools-2.0.2/media/swf/copy_cvs_xls_pdf.swf')}"
				}
			} 	);
	}
  });
    
    </script>
  </head>
  <body>
    
  <!-- check for errors -->
  <g:if test="${error == "empty"}">
    <h1>Please enter a search term</h1>
    <g:link action=''>Search Again</g:link>
  </g:if>
  <g:if test="${error == "too_short"}">
    <h1>Your search term is too short, it needs to be at least two characters, please <g:link action=''>search Again</g:link></h1>
  </g:if>
  <g:if test="${error == "no_anno"}">
    <h1>Please select some annotations</h1>
    <g:link action=''>Search Again</g:link>
  </g:if>
  
    <h1>Results for transcriptome annotation descriptions matching '<em>${term}</em>'.</h1>
		<g:if test="${results}">
		    <table class="table_border" width='100%'>
		    	<tr><td>
		    		Searched ${printf("%,d\n",GDB.TransBlast.count() + GDB.TransAnno.count())} records in ${search_time}.<br>
		    		Found ${uniques} contigs with ${results.size()} top hits from distinct databases
		    		</td><td><center>
		    		<!-- download contigs form gets fileName value from get_table_data() -->
		    		<g:form name="fileDownload" url="[controller:'FileDownload', action:'trans_contig_download']">
		    			<g:hiddenField name="fileId" value=""/>
		    			<g:hiddenField name="fileName" value="${term}"/>
		    			<input align="right" type="submit" value="Download contigs in table" class="mybuttons" onclick="get_table_data()"/>
		    		</g:form>
		    		</center>
		    		</td></tr>
		    		</table>
		    	<% if (annoType == "1"){ %>
				<table id='table_data' class="display">  	
				<% }else if (annoType == "2"){ %>
				<table id='func_table_data' class="display">  
			    <% }else if (annoType == "3"){ %>
			    <table id='ipr_table_data' class="display">  
			    <% } %>   
			    <thead>
				<tr>
				<% if (annoType == "1"){ %>
				  <th></th>
				<% } %>
				  <th><b>Transcript ID</b></th>
				  <th><b>Database</b></th>
				  <th><b>Hit ID</b></th>
				  <th width=50%><b>Description</b></th>
				  <th><b>Score</b></th>
				</tr>
				</thead>
				<tbody>
				</tbody>
			      </table>

          </g:if>
          <g:else>
          	<p>Found <strong>0</strong> hits.</p>
          	<g:link action=''>Search Again</g:link>
          </g:else>
</body>
</html>

