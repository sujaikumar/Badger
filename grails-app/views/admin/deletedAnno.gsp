<%@ page contentType="text/html;charset=UTF-8" %>

<html>
  <head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name='layout' content='main'/>
  <title>${grailsApplication.config.projectID} admin</title>
  <parameter name="admin" value="selected"></parameter>
  </head>

  <body>
 <div class="bread"><g:link action="home">Admin</g:link> > <g:link action="home">Home</g:link> <g:link action="editData" params="${[id:file.filedata.meta.id]}">Edit data set</g:link>  > Delete annotation file > Deleted annotation file</div>     
<h1>The following annotation file and all dependencies are being deleted</h1>

<h2>${source} ${file}</h2>

</body>
</html>