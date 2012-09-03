<%@ page contentType="text/html;charset=UTF-8" %>

<html>
  <head>
	  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	  <meta name='layout' content='main'/>
	  <title>${grailsApplication.config.projectID} home</title>
	  <parameter name="home" value="selected"></parameter>
  </head>

  <body>
	  <sec:ifNotLoggedIn>
	  	<h1>Welcome to the home of the <i>${grailsApplication.config.projectID}</i> genome project.</h1>    
	  </sec:ifNotLoggedIn>	
	  <sec:ifLoggedIn>
	  <h1>Welcome <sec:username /></h1>
	    <p>
	    This site represents the main portal to the <i>${grailsApplication.config.projectID}</i> genome project. All assembly and annotation data 
	    will be accessible from here via the links above. </p><br>
	  
	  <div style="overflow:auto; padding-right:2px; max-height:200px">  
		  <div class="inline">  
			<h1>Latest News</h1>
			<sec:ifAnyGranted roles="ROLE_ADMIN">
				<g:form action="addNews" controller="home">
					(<a href="#" onclick="parentNode.submit()">add news item</a>)
				</g:form>
				<br>
			</sec:ifAnyGranted>
		  </div>
		 		  
		  <table>	  
		  <g:each var="res" in="${newsData}">
			  <tr>
				<td>
				  <div class="inline">
					<sec:ifAnyGranted roles="ROLE_ADMIN">	    
						<g:form action="editNews" controller="home" params="[titleString: res.titleString]" >
							<a href="#" onclick="parentNode.submit()"><img src="${resource(dir: 'images', file: 'edit-icon.png')}" width="15px"/></a>
						</g:form>  	
						<g:form action="deleteNews" controller="home" params="[titleString: res.titleString]" >
							<a href="#" onclick="parentNode.submit()"><img src="${resource(dir: 'images', file: 'delete-icon.png')}" width="15px"/></a>
						</g:form> 
					</sec:ifAnyGranted>
					<b><g:link action="news" params="${[newsTitle : res.titleString]}"><g:formatDate format="yyyy MMM d" date="${res.dateString}"/>:</b></g:link>

					</td><td>
					${res.titleString} 
					</div>
				  </td>
			  </tr>
		  </g:each>
		  </table>
	  </div>
	  
	  <h1>Plan</h1>
	  The plan for the project....
	
	</sec:ifLoggedIn>
  </body>
</html>
